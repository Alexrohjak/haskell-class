"""Pull INF122 material out of Mitt UiB into this repo.

Read-only: this script only ever issues GET requests. It never submits, posts,
marks anything complete, or changes a single Canvas setting.

    .venv/bin/python src/canvas_sync.py                 # sync everything, fetch new files
    .venv/bin/python src/canvas_sync.py --no-download   # text only, skip the files
    .venv/bin/python src/canvas_sync.py --quiet         # only report what changed

Writes one `README.md` per week folder recording what the lecturer posted, and
downloads the files alongside it. Those files are generated — edit them and the
next run overwrites your changes.

Needs a token in .env (gitignored) — see .env.example.

Why this exists: Mitt UiB access disappears when the course ends, and the
lecturer publishes material week by week. Re-run this whenever something new
appears and the repo stays a complete offline archive.

A note on where the material is. This course barely uses pages — the lecture
notes and the weekly exercises sit in the **Files** area, in `forelesningsnotater/`
and `oppgaver/`. UiB lets students enumerate that (HVL did not), so this script
walks the folder tree and files each item by the week number in its name:
`uke1.txt` and `1krav-plan+intro.pdf` are both course week 1, which is uke34.

Links inside pages are still followed, for the courses that do work that way.
Anything whose week cannot be determined lands in `docs/canvas/files/`, which is
not a failure — just a file that has to be placed by hand.
"""

from __future__ import annotations

import argparse
import html
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from datetime import date, timedelta
from pathlib import Path

from paths import ROOT
from week import DATES, PLAN, YEAR, folder, iso_week

OUT = ROOT / "docs" / "canvas"
RAW = OUT / "raw"
LINKS = ROOT / "resources" / "canvas-links.md"

# Which week a page belongs to, when the title says so outright.
WEEK_IN_TITLE = re.compile(r"(?:[Vv]eke|[Uu]ke|[Ww]eek)\s*(\d{1,2})")

# ...or when it only gives a date: "24.08", "24.08.2026", "24/8".
DATE_IN_TITLE = re.compile(r"\b(\d{1,2})[./](\d{1,2})(?:[./](\d{2,4}))?\b")

# Files-area folders whose contents belong inside a week folder, and where.
# Keyed on the folder's own name, lowercased. Anything unlisted goes to
# docs/canvas/files/ rather than being guessed at.
FOLDER_MAP = {
    "forelesningsnotater": "slides",
    "forelesninger": "slides",
    "notater": "slides",
    "slides": "slides",
    "transparenter": "slides",
    "oppgaver": "exercises",
    "ukesoppgaver": "exercises",
    "obliger": None,          # obligs are cross-week — assignments/, by hand
}

# The course week a filename claims: "uke1.txt", "forelesning3.pdf", "1intro.pdf".
COURSE_WEEK_IN_NAME = re.compile(
    r"(?:uke|veke|week|forelesning|lecture|lec)[ _-]*(\d{1,2})", re.I)
LEADING_NUMBER = re.compile(r"^(\d{1,2})(?=\D)")


def course_week_from_name(name: str) -> int | None:
    match = COURSE_WEEK_IN_NAME.search(name) or LEADING_NUMBER.match(name)
    return int(match.group(1)) if match else None


def place(entry: dict) -> tuple[int | None, str | None]:
    """(uke, subfolder) for a Files-area entry. (None, None) means unplaceable."""
    sub = FOLDER_MAP.get(Path(entry["folder"]).name.casefold(), "unknown")
    if sub in (None, "unknown"):
        return None, None
    course_week = course_week_from_name(entry["name"])
    uke = iso_week(course_week) if course_week else None
    return (uke, sub) if uke else (None, None)


# --------------------------------------------------------------------------
# config
# --------------------------------------------------------------------------

def load_env() -> dict[str, str]:
    env_file = ROOT / ".env"
    if not env_file.exists():
        sys.exit("No .env — copy .env.example to .env and add your Mitt UiB token.")

    vals: dict[str, str] = {}
    for line in env_file.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, value = line.split("=", 1)
            vals[key.strip()] = value.strip()

    token = vals.get("CANVAS_API_TOKEN", "")
    if not token or token == "paste_your_token_here":
        sys.exit("CANVAS_API_TOKEN is not set in .env.")
    # Two formats in the wild: the current "1234~abc..." and the legacy
    # 64-character alphanumeric one, which is what UiB still issues.
    if not (re.fullmatch(r"\d+~[A-Za-z0-9]{20,}", token)
            or re.fullmatch(r"[A-Za-z0-9]{40,}", token)):
        sys.exit(
            "CANVAS_API_TOKEN doesn't look like a Canvas token. Expected either "
            "'1234~' followed by letters and digits, or a single run of 40+ "
            "letters and digits. Check for stray characters from pasting."
        )
    return vals


# --------------------------------------------------------------------------
# api
# --------------------------------------------------------------------------

class Canvas:
    def __init__(self, base: str, token: str, course_id: str):
        self.base = base.rstrip("/")
        self.token = token
        self.cid = course_id

    def get(self, path: str, **params):
        """GET an API path. Returns (data, error) — never raises on HTTP error."""
        url = f"{self.base}/api/v1{path}"
        if params:
            url += "?" + urllib.parse.urlencode(params)
        req = urllib.request.Request(
            url, headers={"Authorization": f"Bearer {self.token}"}
        )
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                return json.loads(resp.read().decode()), None
        except urllib.error.HTTPError as exc:
            return None, f"HTTP {exc.code}"
        except Exception as exc:  # network, timeout, malformed JSON
            return None, str(exc)[:120]

    def download(self, url: str, dest: Path) -> str:
        """Fetch a file to dest. Returns a one-word status for the report."""
        if dest.exists():
            return "exists"
        dest.parent.mkdir(parents=True, exist_ok=True)
        req = urllib.request.Request(
            url, headers={"Authorization": f"Bearer {self.token}"}
        )
        try:
            with urllib.request.urlopen(req, timeout=120) as resp:
                dest.write_bytes(resp.read())
            return "downloaded"
        except Exception as exc:
            return f"failed ({str(exc)[:60]})"


# --------------------------------------------------------------------------
# html -> text
# --------------------------------------------------------------------------

def to_text(raw: str | None) -> str:
    """Canvas page bodies are HTML. Flatten to something readable in markdown."""
    body = raw or ""
    body = re.sub(r"<br\s*/?>", "\n", body)
    body = re.sub(r"</(p|div|li|h[1-6]|tr)>", "\n", body)
    body = re.sub(r"<li[^>]*>", "  - ", body)
    body = re.sub(r"<[^>]+>", "", body)
    body = html.unescape(body)
    body = "\n".join(line.rstrip() for line in body.splitlines())
    return re.sub(r"\n{3,}", "\n\n", body).strip()


def file_ids(raw: str | None) -> list[int]:
    """Canvas file ids linked from a page body, in order, without repeats.

    A single file is usually referenced twice — once by the visible link and
    once by a preview attribute — so dedupe or it downloads twice.
    """
    found = re.findall(r"/files/(\d+)", raw or "")
    return [int(fid) for fid in dict.fromkeys(found)]


def external_links(raw: str | None) -> list[str]:
    """Off-Canvas links worth keeping — Hutton's site, the code, GitHub, video."""
    found = re.findall(r'href="(https?://[^"]+)"', raw or "")
    return [
        html.unescape(url)
        for url in dict.fromkeys(found)
        if "instructure.com" not in url and "mitt.uib.no" not in url
    ]


# --------------------------------------------------------------------------
# collection
# --------------------------------------------------------------------------

def collect(api: Canvas) -> dict:
    """Everything the API will give us, in one dict."""
    snap: dict = {"pages": [], "modules": [], "announcements": [],
                  "assignments": [], "files": {}, "area": [], "errors": []}

    course, err = api.get(f"/courses/{api.cid}")
    if err:
        sys.exit(f"Cannot read course {api.cid}: {err}")
    snap["course"] = {
        "name": course.get("name"),
        "code": course.get("course_code"),
        "id": course.get("id"),
    }

    tabs, err = api.get(f"/courses/{api.cid}/tabs")
    snap["tabs"] = [
        {"label": t.get("label"), "url": t.get("html_url"), "type": t.get("type")}
        for t in (tabs or [])
    ]
    if err:
        snap["errors"].append(f"tabs: {err}")

    # The front page usually carries the lecture plan and the pensum list.
    front, err = api.get(f"/courses/{api.cid}/front_page")
    if err:
        snap["errors"].append(f"front page: {err}")
    else:
        body = front.get("body", "")
        snap["pages"].append({
            "title": front.get("title"),
            "slug": front.get("url"),
            "module": "Front page",
            "updated": front.get("updated_at"),
            "text": to_text(body),
            "file_ids": file_ids(body),
            "links": external_links(body),
        })

    # Unlike DAT158, the page index may well be enabled here — if it is, it
    # catches pages that no module links to.
    loose, err = api.get(f"/courses/{api.cid}/pages", per_page=100)
    if err:
        snap["errors"].append(f"page index: {err}")
    seen_slugs = {p["slug"] for p in snap["pages"]}
    for stub in loose or []:
        slug = stub.get("url")
        if not slug or slug in seen_slugs:
            continue
        page, page_err = api.get(f"/courses/{api.cid}/pages/{slug}")
        if page_err:
            snap["errors"].append(f"page {slug}: {page_err}")
            continue
        body = page.get("body", "")
        seen_slugs.add(slug)
        snap["pages"].append({
            "title": page.get("title"),
            "slug": slug,
            "module": "(not in a module)",
            "updated": page.get("updated_at"),
            "text": to_text(body),
            "file_ids": file_ids(body),
            "links": external_links(body),
        })

    modules, err = api.get(f"/courses/{api.cid}/modules", per_page=100)
    if err:
        snap["errors"].append(f"modules: {err}")
    for module in modules or []:
        items, item_err = api.get(
            f"/courses/{api.cid}/modules/{module['id']}/items", per_page=100
        )
        if item_err:
            snap["errors"].append(f"module {module['id']} items: {item_err}")
        entry = {"name": module.get("name"), "items": []}
        for item in items or []:
            entry["items"].append(
                {"title": item.get("title"), "type": item.get("type"),
                 "page_url": item.get("page_url"), "url": item.get("html_url")}
            )
            slug = item.get("page_url")
            if not slug:
                continue
            # Already fetched via the index — just record which module owns it.
            existing = next((p for p in snap["pages"] if p["slug"] == slug), None)
            if existing:
                existing["module"] = module.get("name")
                continue
            page, page_err = api.get(f"/courses/{api.cid}/pages/{slug}")
            if page_err:
                snap["errors"].append(f"page {slug}: {page_err}")
                continue
            body = page.get("body", "")
            seen_slugs.add(slug)
            snap["pages"].append({
                "title": page.get("title"),
                "slug": slug,
                "module": module.get("name"),
                "updated": page.get("updated_at"),
                "text": to_text(body),
                "file_ids": file_ids(body),
                "links": external_links(body),
            })
        snap["modules"].append(entry)

    # Canvas only returns the last 14 days unless a window is given, so older
    # notices would silently vanish from the record as new ones arrive. Ask for
    # the whole semester instead — starting a month before teaching does, since
    # the ones about groups and sign-up land before the first lecture.
    term_start = date.fromisocalendar(YEAR, min(PLAN), 1) - timedelta(days=30)
    term_end = date.fromisocalendar(YEAR, max(PLAN), 7)
    anns, err = api.get("/announcements", per_page=100,
                        start_date=term_start.isoformat(),
                        end_date=term_end.isoformat(),
                        **{"context_codes[]": f"course_{api.cid}"})
    if err:
        snap["errors"].append(f"announcements: {err}")
    for ann in anns or []:
        body = ann.get("message", "")
        snap["announcements"].append({
            "title": ann.get("title"),
            "posted": ann.get("posted_at"),
            "text": to_text(body),
            "file_ids": file_ids(body),
            "links": external_links(body),
        })

    assigns, err = api.get(f"/courses/{api.cid}/assignments", per_page=100)
    if err:
        snap["errors"].append(f"assignments: {err}")
    for a in assigns or []:
        body = a.get("description", "")
        snap["assignments"].append({
            "name": a.get("name"),
            "due_at": a.get("due_at"),
            "points": a.get("points_possible"),
            "url": a.get("html_url"),
            "text": to_text(body),
            "file_ids": file_ids(body),
            "links": external_links(body),
        })

    # The Files area. This is where this course actually publishes, so it
    # matters more than everything above it.
    folders, err = api.get(f"/courses/{api.cid}/folders", per_page=100)
    if err:
        snap["errors"].append(f"files area: {err}")
    for f in folders or []:
        if not f.get("files_count"):
            continue
        listing, ferr = api.get(f"/folders/{f['id']}/files", per_page=100)
        if ferr:
            snap["errors"].append(f"folder {f.get('full_name')}: {ferr}")
            continue
        for meta in listing or []:
            snap["area"].append({
                "folder": f.get("full_name") or "",
                "name": meta.get("display_name"),
                "id": meta.get("id"),
                "size": meta.get("size"),
                "type": meta.get("content-type"),
                "url": meta.get("url"),      # capability URL — never committed
                "updated": meta.get("updated_at"),
            })

    # Resolve every file id we saw. Enumeration is 403 for students, so this
    # is the only way to learn a file's real name.
    seen: set[int] = set()
    for group in ("pages", "announcements", "assignments"):
        for entry in snap[group]:
            seen.update(entry.get("file_ids", []))
    for fid in sorted(seen):
        meta, err = api.get(f"/files/{fid}")
        if err:
            snap["errors"].append(f"file {fid}: {err}")
            continue
        snap["files"][str(fid)] = {
            "name": meta.get("display_name"),
            "size": meta.get("size"),
            "type": meta.get("content-type"),
            "url": meta.get("url"),          # capability URL — never committed
            "updated": meta.get("updated_at"),
        }
    return snap


# --------------------------------------------------------------------------
# which week does this belong to
# --------------------------------------------------------------------------

def week_from_date(text: str) -> int | None:
    """A "24.08"-style date in a title, turned into its ISO week."""
    for day, month, year in DATE_IN_TITLE.findall(text):
        try:
            when = date(YEAR, int(month), int(day))
        except ValueError:
            continue
        uke = when.isocalendar().week
        if uke in PLAN:
            return uke
    return None


def weeks_for_page(page: dict) -> list[int]:
    """Which teaching weeks a Canvas page belongs to.

    Three routes, in order of how much they can be trusted: the title names the
    week, the title carries a date inside a teaching week, or the page sits in
    a module whose name matches a topic in PLAN (a module may span two weeks,
    so both get the record).
    """
    for field in ("title", "module"):
        value = page.get(field) or ""
        if field == "module" and value.strip().casefold() in ("", "front page"):
            continue
        match = WEEK_IN_TITLE.search(value)
        if match:
            uke = int(match.group(1))
            return [uke] if uke in PLAN else []
        uke = week_from_date(value)
        if uke:
            return [uke]

    module = (page.get("module") or "").strip().casefold()
    if not module or module in ("front page", "(not in a module)"):
        return []
    return sorted(u for u, (topic, _) in PLAN.items()
                  if topic.strip().casefold() == module)


def primary_week(page: dict) -> int | None:
    """Where a page's files go. Earliest week wins, so nothing is duplicated."""
    hits = weeks_for_page(page)
    return hits[0] if hits else None


# --------------------------------------------------------------------------
# output
# --------------------------------------------------------------------------

def write_digest(snap: dict) -> Path:
    OUT.mkdir(parents=True, exist_ok=True)
    lines = [
        f"# {snap['course']['name']}",
        "",
        "Mirrored from Mitt UiB by `src/canvas_sync.py`. **Do not edit by hand** —",
        "re-run the script instead. Per-week records are in `weeks/*/README.md`.",
        "",
        f"Course: `{snap['course']['code']}` (id {snap['course']['id']})",
        "",
        "## Canvas sections",
        "",
        "| Section | Link |",
        "|---|---|",
    ]
    for tab in snap["tabs"]:
        lines.append(f"| {tab['label']} | {tab['url'] or ''} |")

    lines += ["", "## Modules", ""]
    if not snap["modules"]:
        lines.append("*No modules — this course publishes some other way.*")
    for module in snap["modules"]:
        lines += [f"### {module['name']}", ""]
        for item in module["items"]:
            lines.append(f"- **{item['title']}** — {item['type']}")
        lines.append("")

    lines += ["## Pages", ""]
    for page in snap["pages"]:
        weeks = weeks_for_page(page)
        filed = ", ".join(f"uke{u}" for u in weeks) if weeks else "not week-specific"
        lines += [f"### {page['title']}", "",
                  f"*Module: {page['module']} · updated {page['updated']} · {filed}*",
                  ""]
        lines.append(page["text"] or "*(empty)*")
        if page["file_ids"]:
            lines += ["", "**Attached files:**"]
            for fid in page["file_ids"]:
                meta = snap["files"].get(str(fid))
                name = meta["name"] if meta else f"(unreadable file {fid})"
                lines.append(f"- {name}")
        if page["links"]:
            lines += ["", "**Links:**"] + [f"- {url}" for url in page["links"]]
        lines.append("")

    lines += ["## Files area", ""]
    if not snap["area"]:
        lines.append("*Empty, or not readable — see below.*")
    else:
        lines += ["| File | Folder | Filed as | Updated |", "|---|---|---|---|"]
        for entry in sorted(snap["area"], key=lambda e: (e["folder"], e["name"] or "")):
            uke, sub = place(entry)
            where = f"`weeks/uke{uke}/{sub}/`" if uke else "`docs/canvas/files/` (by hand)"
            lines.append(f"| {entry['name']} | {entry['folder']} | {where} "
                         f"| {(entry['updated'] or '')[:10]} |")
    lines.append("")

    lines += ["## Announcements", ""]
    if not snap["announcements"]:
        lines.append("*None.*")
    for ann in snap["announcements"]:
        lines += [f"### {ann['title']}", "", f"*Posted {ann['posted']}*", "",
                  ann["text"], ""]

    lines += ["## Assignments", ""]
    if not snap["assignments"]:
        lines.append("*None published yet.*")
    for a in snap["assignments"]:
        lines += [f"### {a['name']}", "",
                  f"*Due: {a['due_at'] or 'no date'} · {a['points']} points*", "",
                  a["text"], ""]

    if snap["errors"]:
        lines += ["", "## Not readable", "",
                  "Blocked by Canvas permissions or missing — not script failures:", ""]
        lines += [f"- {e}" for e in snap["errors"]]

    path = OUT / "course.md"
    path.write_text("\n".join(lines) + "\n")
    return path


def write_raw(snap: dict) -> Path:
    """The full snapshot, minus the capability URLs, which are secrets."""
    RAW.mkdir(parents=True, exist_ok=True)
    safe = json.loads(json.dumps(snap))
    for meta in safe["files"].values():
        meta.pop("url", None)
    for entry in safe["area"]:
        entry.pop("url", None)
    path = RAW / "snapshot.json"
    path.write_text(json.dumps(safe, indent=2, ensure_ascii=False) + "\n")
    return path


def write_links(snap: dict) -> Path:
    """Every off-Canvas link the course points at, deduped, with its source."""
    found: dict[str, str] = {}
    for group, label in (("pages", "page"), ("announcements", "announcement"),
                         ("assignments", "assignment")):
        for entry in snap[group]:
            name = entry.get("title") or entry.get("name") or "?"
            for url in entry.get("links", []):
                found.setdefault(url, f"{label}: {name}")

    LINKS.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# Links the course points at",
        "",
        "Generated by `src/canvas_sync.py` — every non-Canvas URL found in the",
        "course material, so it survives losing Mitt UiB access. Links you find",
        "yourself go in `resources/links.md` instead; this file is overwritten.",
        "",
    ]
    if found:
        lines += [f"- <{url}>  — {src}" for url, src in sorted(found.items())]
    else:
        lines.append("*Nothing linked off Canvas yet.*")
    LINKS.write_text("\n".join(lines) + "\n")
    return LINKS


def download_files(api: Canvas, snap: dict, quiet: bool) -> list[str]:
    """Put each linked file next to the week it belongs to."""
    report = []
    for group in ("pages", "announcements", "assignments"):
        for entry in snap[group]:
            uke = primary_week(entry) if group == "pages" else None
            dest_dir = (folder(uke) / "slides") if uke else (OUT / "files")
            for fid in entry.get("file_ids", []):
                meta = snap["files"].get(str(fid))
                if not meta or not meta.get("url"):
                    report.append(f"  skip  file {fid} — no download URL")
                    continue
                # Inline decoration (banner images and the like) is not lecture
                # material — keep it out of the week folders.
                target = dest_dir
                if uke and str(meta.get("type", "")).startswith("image/"):
                    target = OUT / "files"
                dest = target / meta["name"]
                status = api.download(meta["url"], dest)
                if status != "exists" or not quiet:
                    report.append(f"  {status:11} {dest.relative_to(ROOT)}")

    for entry in snap["area"]:
        if not entry.get("url"):
            report.append(f"  skip        {entry['name']} — no download URL")
            continue
        uke, sub = place(entry)
        dest = (folder(uke) / sub / entry["name"]) if uke else (OUT / "files" / entry["name"])
        status = api.download(entry["url"], dest)
        if status != "exists" or not quiet:
            report.append(f"  {status:11} {dest.relative_to(ROOT)}")
    return report


def folder_contents(uke: int) -> list[str]:
    """What is actually filed in a week folder, as markdown bullets."""
    base = folder(uke)
    lines = []
    for sub in ("slides", "exercises", "code"):
        d = base / sub
        files = sorted(f for f in d.iterdir() if f.name != ".gitkeep") if d.exists() else []
        if not files:
            lines.append(f"- `{sub}/` — empty")
            continue
        total = sum(f.stat().st_size for f in files if f.is_file())
        lines.append(f"- `{sub}/` — {len(files)} item(s), {total // 1024} KB")
        for f in files:
            lines.append(f"  - `{f.name}`")
    return lines


def write_week_records(snap: dict) -> list[int]:
    """One README.md per week: what the lecturer posted, and what we hold.

    Generated, not authored. Anything hand-written here is lost on the next run
    — personal notes do not belong in a file the sync owns.
    """
    by_week: dict[int, list[dict]] = {}
    for page in snap["pages"]:
        for uke in weeks_for_page(page):
            by_week.setdefault(uke, []).append(page)

    # What the Files area put in this week, which for this course is most of it.
    area_by_week: dict[int, list[dict]] = {}
    for entry in snap["area"]:
        uke, sub = place(entry)
        if uke:
            area_by_week.setdefault(uke, []).append(dict(entry, sub=sub))

    written = []
    for uke, (topic, tut) in sorted(PLAN.items()):
        base = folder(uke)
        if not base.exists():
            continue

        out = [f"# Uke {uke} — INF122", "", f"**{DATES[uke]}** · {topic}", ""]
        if tut:
            out += [
                f"Tutorial week: [`tutorial/week{tut:02d}/`](../../tutorial/week{tut:02d}/)"
                f" — `cd tutorial && ./check.sh {tut}`",
                "",
            ]

        pages = by_week.get(uke, [])
        area = area_by_week.get(uke, [])
        if pages or area:
            out += ["## Posted by the lecturer", ""]
        for entry in area:
            out += [f"- `{entry['sub']}/{entry['name']}` — from Canvas "
                    f"`{entry['folder']}`, updated {(entry['updated'] or '')[:10]}"]
        if area:
            out.append("")
        if pages:
            for page in pages:
                out += [f"### {page['title']}", "", page["text"] or "*(no text)*", ""]
                if page["file_ids"]:
                    out.append("**Files:**")
                    for fid in page["file_ids"]:
                        meta = snap["files"].get(str(fid))
                        out.append(f"- {meta['name'] if meta else f'file {fid} (unreadable)'}")
                    out.append("")
                if page["links"]:
                    out += ["**Links:**"] + [f"- {u}" for u in page["links"]] + [""]
        if not pages and not area:
            out += [
                "## Posted by the lecturer",
                "",
                "*Nothing published for this week yet.* Re-run "
                "`.venv/bin/python src/canvas_sync.py` once it appears.",
                "",
            ]

        out += ["## In this folder", ""] + folder_contents(uke) + [
            "",
            "---",
            "",
            "<!-- Generated by src/canvas_sync.py. Do not edit — re-run the script. -->",
        ]

        (base / "README.md").write_text("\n".join(out) + "\n")
        written.append(uke)
    return written


# --------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-download", action="store_true",
                        help="skip fetching files; refresh the text only")
    parser.add_argument("--quiet", action="store_true", help="only report changes")
    args = parser.parse_args()

    env = load_env()
    api = Canvas(env["CANVAS_BASE_URL"], env["CANVAS_API_TOKEN"],
                 env["CANVAS_COURSE_ID"])

    snap = collect(api)
    digest = write_digest(snap)
    raw = write_raw(snap)
    links = write_links(snap)

    # Download before writing the week records. The records list what is on
    # disk, so filing the files afterwards leaves every record that gained a
    # file claiming an empty folder until the next run.
    downloads = None
    if not args.no_download:
        downloads = download_files(api, snap, args.quiet) or ["  nothing to do"]

    weeks = write_week_records(snap)

    if not args.quiet:
        print(f"Course : {snap['course']['name']}")
        print(f"Pages  : {len(snap['pages'])}")
        print(f"Files  : {len(snap['files'])} linked, "
              f"{len(snap['area'])} in the Files area")
        print(f"Notices: {len(snap['announcements'])}")
        print(f"Tasks  : {len(snap['assignments'])}")
        print()
        print(f"Wrote {digest.relative_to(ROOT)}")
        print(f"Wrote {raw.relative_to(ROOT)}")
        print(f"Wrote {links.relative_to(ROOT)}")
        print(f"Wrote {len(weeks)} week records (weeks/*/README.md)")

    if downloads is not None:
        print()
        print("Files:")
        for line in downloads:
            print(line)

    if snap["errors"] and not args.quiet:
        print()
        print(f"{len(snap['errors'])} item(s) not readable — see the digest.")


if __name__ == "__main__":
    main()
