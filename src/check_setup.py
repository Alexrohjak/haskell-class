"""Verify the haskell-class environment is working.

Run with:  python src/check_setup.py

Two environments live in this repo and they are checked separately:

  * The **Haskell toolchain** — GHC, GHCi, cabal, stack, installed by GHCup.
    This is what the course and the tutorial actually need.
  * The **Python tooling** — only used by the three scripts in `src/`
    (Canvas sync, search, this file). Missing it costs you the sync and the
    search, not the ability to write Haskell.
"""

from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

from paths import ROOT

# The toolchain. runghc is what tutorial/check.sh drives; stack is optional
# because nothing in this repo needs a project build yet.
HASKELL = [
    ("ghc", True), ("ghci", True), ("runghc", True),
    ("cabal", True),          # the oblig is expected to be a cabal project
    ("ghcup", False), ("stack", False),
    ("haskell-language-server-wrapper", False),   # ghcup install hls
]


def version(tool: str) -> str:
    try:
        out = subprocess.run([tool, "--version"], capture_output=True,
                             text=True, timeout=60)
        return (out.stdout or out.stderr).strip().splitlines()[0]
    except Exception as exc:
        return f"(could not run: {str(exc)[:40]})"


def check_haskell() -> list[str]:
    print("  haskell toolchain")
    missing = []
    for tool, required in HASKELL:
        if shutil.which(tool):
            print(f"    ok       {tool:<8} {version(tool)[:60]}")
        elif required:
            print(f"    MISSING  {tool}")
            missing.append(tool)
        else:
            print(f"    absent   {tool}  (optional)")
    return missing


def check_quickcheck() -> None:
    """The course's notes use QuickCheck from week 1, and it is not in base."""
    print("\n  course packages")
    try:
        out = subprocess.run(["ghc-pkg", "list", "--simple-output", "QuickCheck"],
                             capture_output=True, text=True, timeout=60)
        found = (out.stdout or "").strip()
    except Exception:
        found = ""
    if found:
        print(f"    ok       QuickCheck  {found.split()[-1]}")
    else:
        print("    absent   QuickCheck  — cabal install --lib QuickCheck")
        print("             Only needed for the lecturer's notes; the tutorial")
        print("             harness deliberately uses nothing beyond base.")


def check_python() -> list[str]:
    print("\n  python tooling")
    print(f"    ok       python   {sys.version.split()[0]}  ({sys.executable})")
    missing = []
    for name, why in (("pypdf", "search inside slide and textbook PDFs"),):
        try:
            module = __import__(name)
            print(f"    ok       {name:<8} {getattr(module, '__version__', '?')}")
        except ImportError:
            print(f"    MISSING  {name:<8} — needed to {why}")
            missing.append(name)
    return missing


def check_sync() -> None:
    print("\n  canvas sync")
    env = ROOT / ".env"
    if not env.exists():
        print("    absent   .env — copy .env.example and add your Mitt UiB token")
        return
    keys = {line.split("=", 1)[0].strip()
            for line in env.read_text().splitlines()
            if "=" in line and not line.strip().startswith("#")}
    for key in ("CANVAS_BASE_URL", "CANVAS_COURSE_ID", "CANVAS_API_TOKEN"):
        print(f"    {'ok      ' if key in keys else 'MISSING '} {key}")
    mirror = ROOT / "docs" / "canvas" / "course.md"
    print(f"    {'ok       mirrored' if mirror.exists() else 'absent   never synced'}"
          "  docs/canvas/course.md")


def check_tutorial() -> int:
    """The real end-to-end test: run a week's tests against its own solution.

    If this passes, GHC works, the harness compiles and the runner script is
    wired up correctly — which is everything the weekly loop depends on.
    """
    print("\n  end-to-end")
    runner = ROOT / "tutorial" / "check.sh"
    if not runner.exists():
        print("    MISSING  tutorial/check.sh")
        return 1
    try:
        out = subprocess.run([str(runner), "1", "--solution"], capture_output=True,
                             text=True, timeout=300, cwd=runner.parent)
    except Exception as exc:
        print(f"    FAILED   could not run the harness: {str(exc)[:60]}")
        return 1

    tail = [l for l in (out.stdout or "").splitlines() if l.strip()][-1:] or ["(no output)"]
    if out.returncode == 0:
        print(f"    ok       week 1 tests pass against the reference solution")
        print(f"             {tail[0][:70]}")
        return 0
    print(f"    FAILED   exit {out.returncode}: {tail[0][:70]}")
    print("             Try it directly: cd tutorial && ./check.sh 1 --solution")
    return 1


def main() -> int:
    print(f"haskell-class — {ROOT}\n")

    hs_missing = check_haskell()
    check_quickcheck()
    py_missing = check_python()
    check_sync()

    if hs_missing:
        print(f"\nMissing from the toolchain: {', '.join(hs_missing)}")
        print("Install it with GHCup:")
        print("  curl --proto '=https' --tlsv1.2 -sSf "
              "https://get-ghcup.haskell.org | sh")
        return 1

    failed = check_tutorial()

    if py_missing:
        print(f"\nPython tooling incomplete: {', '.join(py_missing)}")
        print("Fix with: pip install -r requirements.txt")
        print("Haskell itself is fine — only src/find.py is affected.")

    if failed:
        return 1

    print("\nToolchain works and the harness is green. Go write some Haskell.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
