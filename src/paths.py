"""Project paths, so the scripts in here don't care where they're run from.

    from paths import ROOT
    (ROOT / "weeks").iterdir()
"""

from pathlib import Path

# This file is at <project>/src/paths.py, so the project root is two levels up.
ROOT = Path(__file__).resolve().parent.parent

WEEKS = ROOT / "weeks"
TUTORIAL = ROOT / "tutorial"
DOCS = ROOT / "docs"
REFERENCE = ROOT / "reference"

__all__ = ["ROOT", "WEEKS", "TUTORIAL", "DOCS", "REFERENCE"]
