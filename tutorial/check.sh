#!/usr/bin/env bash
# Run the tests for one week of the INF122 tutorial.
#
#   ./check.sh 3            run week 3's tests against YOUR Exercises.hs
#   ./check.sh 3 --solution run them against the reference solution
#   ./check.sh 3 --repl     open GHCi with your week-3 code loaded
#
# Exit status is 0 only when every check passes.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -lt 1 ]; then
  echo "usage: $(basename "$0") <week-number> [--solution|--repl]" >&2
  exit 2
fi

WEEK=$(printf 'week%02d' "$(( 10#${1#week} ))" 2>/dev/null) || {
  echo "error: '$1' is not a week number" >&2; exit 2; }
MODE="${2:-}"

SRC="$HERE/$WEEK"
[ -d "$SRC" ] || { echo "error: no such week: $SRC" >&2; exit 2; }

case "$MODE" in
  --solution|-s) SRC="$HERE/solutions/$WEEK"
     [ -d "$SRC" ] || { echo "error: no solution for $WEEK yet" >&2; exit 2; } ;;
  --repl|-r) exec ghci -Wno-x-partial -i"$HERE/lib" -i"$SRC" "$SRC/Exercises.hs" ;;
  "") : ;;
  *) echo "error: unknown option '$MODE'" >&2; exit 2 ;;
esac

# GHC emits a harmless 'libgmp.so' shared-library warning on this machine;
# strip it so the test report is the only thing on screen.
runghc -Wno-x-partial -i"$HERE/lib" -i"$SRC" "$HERE/$WEEK/Tests.hs" 2>&1 \
  | grep -v -e 'missed-extra-shared-lib' \
            -e 'libgmp' \
            -e "It's OK if you don't want to use symbols" \
            -e 'the package DLL is loaded by the system linker' \
            -e 'which manages dependencies by itself' \
            -e '^<no location info>: warning:' \
  | cat -s

exit "${PIPESTATUS[0]}"
