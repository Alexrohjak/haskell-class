"""Search everything you have collected for this subject, in one place.

    .venv/bin/python src/find.py foldr                 # where is this covered?
    .venv/bin/python src/find.py "list comprehension"  # phrases need quotes
    .venv/bin/python src/find.py guard --context 3     # more hits per file
    .venv/bin/python src/find.py foldr --solutions     # include the reference answers
    .venv/bin/python src/find.py --sources             # what is indexed
    .venv/bin/python src/find.py --rebuild foldr       # force re-extraction

Searches the week records, the Mitt UiB mirror, every lesson, every exercise
and test file, your own Haskell code, and any slide deck or textbook PDF you
have filed — and reports the page or line, so you can go straight there.

`grep -r` only reads the text files. Lecture material arrives as PDF, which is
exactly what you want during revision, so this extracts those too and caches
the text. First run is slow (a 600-page book takes a few seconds); later runs
are instant until a file changes.

**Solutions are excluded by default.** Searching them is a fast way to read an
answer you have not earned yet — pass `--solutions` when you actually mean it.

**Scanned PDFs are invisible here.** A PDF with no text layer cannot be
searched without OCR — `--sources` lists which ones are affected.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

from paths import ROOT

CACHE = ROOT / ".searchcache"

# Where to look, and what to call it in the output.
SOURCES = [
    ("week record", "weeks/*/README.md"),
    ("canvas",      "docs/canvas/course.md"),
    ("guide",       "*.md"),
    ("guide",       "docs/*.md"),
    ("guide",       "resources/*.md"),
    ("guide",       "exam/*.md"),
    ("guide",       "tutorial/README.md"),
    ("lesson",      "tutorial/week*/LESSON.md"),
    ("exercise",    "tutorial/week*/Exercises.hs"),
    ("tests",       "tutorial/week*/Tests.hs"),
    ("harness",     "tutorial/lib/*.hs"),
    ("my code",     "weeks/*/code/**/*.hs"),
    ("my code",     "assignments/**/*.hs"),
    ("my code",     "scratch/**/*.hs"),
    ("slides",      "weeks/*/slides/*.pdf"),
    ("slides",      "weeks/*/slides/**/*.html"),
    ("exercise set", "weeks/*/exercises/*.pdf"),
    ("textbook",    "reference/**/*.pdf"),
    ("canvas file", "docs/canvas/files/*.pdf"),
]

# Answers. Only indexed when you ask for them — see the module docstring.
SPOILERS = [
    ("solution", "tutorial/solutions/week*/Exercises.hs"),
    ("paper",    "tutorial/solutions/week*/PAPER.md"),
]


def cache_path(path: Path) -> Path:
    key = re.sub(r"[^A-Za-z0-9]+", "_", str(path.relative_to(ROOT)))
    return CACHE / f"{key}.json"


def extract_pdf(path: Path) -> list[tuple[str, str]]:
    """[(locator, text)] per page. Empty list if there is no text layer."""
    try:
        from pypdf import PdfReader
    except ImportError:
        sys.exit("pypdf is not installed — run: pip install -r requirements.txt")

    out = []
    try:
        reader = PdfReader(str(path))
        for n, page in enumerate(reader.pages, 1):
            try:
                text = page.extract_text() or ""
            except Exception:
                text = ""
            if text.strip():
                out.append((f"p.{n}", text))
    except Exception as exc:
        print(f"  ! {path.name}: {str(exc)[:70]}", file=sys.stderr)
    return out


def extract_text_file(path: Path) -> list[tuple[str, str]]:
    """Markdown, Haskell and HTML, chunked by line so we can report line numbers."""
    try:
        raw = path.read_text(encoding="utf-8", errors="ignore")
    except Exception:
        return []
    if path.suffix == ".html":
        raw = re.sub(r"<script.*?</script>|<style.*?</style>", " ", raw, flags=re.S)
        raw = re.sub(r"<[^>]+>", " ", raw)
    return [(f"line {n}", line)
            for n, line in enumerate(raw.splitlines(), 1) if line.strip()]


def load(path: Path, rebuild: bool) -> list[tuple[str, str]]:
    """Extracted units for one file, cached against its mtime and size."""
    stat = path.stat()
    stamp = f"{int(stat.st_mtime)}:{stat.st_size}"
    cp = cache_path(path)

    if not rebuild and cp.exists():
        try:
            blob = json.loads(cp.read_text())
            if blob.get("stamp") == stamp:
                return [tuple(x) for x in blob["units"]]
        except Exception:
            pass

    units = extract_pdf(path) if path.suffix == ".pdf" else extract_text_file(path)

    CACHE.mkdir(exist_ok=True)
    cp.write_text(json.dumps({"stamp": stamp, "units": units}))
    return units


def gather(spoilers: bool) -> list[tuple[str, Path]]:
    """Every file worth searching, deduped, with its label."""
    seen: dict[Path, str] = {}
    for label, pattern in SOURCES + (SPOILERS if spoilers else []):
        for path in sorted(ROOT.glob(pattern)):
            if path.is_file() and path not in seen:
                seen[path] = label
    return [(label, path) for path, label in seen.items()]


def snippet(text: str, term: re.Pattern, width: int = 150) -> str:
    m = term.search(text)
    if not m:
        return " ".join(text.split())[:width]
    flat = " ".join(text.split())
    m2 = term.search(flat) or m
    start = max(0, m2.start() - width // 3)
    out = flat[start:start + width]
    return ("…" if start else "") + out + ("…" if start + width < len(flat) else "")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("query", nargs="?", help="text to look for (case-insensitive)")
    ap.add_argument("--rebuild", action="store_true", help="re-extract everything")
    ap.add_argument("--sources", action="store_true", help="list what is indexed")
    ap.add_argument("--solutions", action="store_true",
                    help="also search the reference answers")
    ap.add_argument("--context", type=int, default=1, help="hits to show per file")
    args = ap.parse_args()

    files = gather(args.solutions)

    if args.sources or not args.query:
        print(f"{len(files)} files indexed"
              + ("" if args.solutions else "  (solutions excluded)") + "\n")
        blind = []
        by_label: dict[str, int] = {}
        for label, path in files:
            by_label[label] = by_label.get(label, 0) + 1
            if path.suffix == ".pdf" and not load(path, args.rebuild):
                blind.append(path)
        for label, n in sorted(by_label.items()):
            print(f"  {label:12} {n}")
        if blind:
            print("\nNot searchable — no text layer (scanned images, would need OCR):")
            for path in blind:
                print(f"  {path.relative_to(ROOT)}")
        if not args.query:
            print("\nGive a search term, e.g.  .venv/bin/python src/find.py foldr")
        return 0

    term = re.compile(re.escape(args.query), re.I)
    total = 0
    for label, path in files:
        hits = [(loc, text) for loc, text in load(path, args.rebuild) if term.search(text)]
        if not hits:
            continue
        total += len(hits)
        print(f"\n{path.relative_to(ROOT)}  [{label}] — {len(hits)} hit(s)")
        for loc, text in hits[:args.context]:
            print(f"    {loc}: {snippet(text, term)}")
        if len(hits) > args.context:
            print(f"    … {len(hits) - args.context} more (use --context)")

    print(f"\n{total} hit(s) across {len(files)} files."
          if total else f"\nNothing found for {args.query!r}."
          + ("" if args.solutions else " (Solutions were not searched.)"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
