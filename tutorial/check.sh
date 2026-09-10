#!/usr/bin/env bash
# Run the tests for one week of the INF122 tutorial.
#
# Each week has two sets of exercises: the book's (Exercises.hs) and the
# lecturer's weekly sheet (Oppgaver.hs). By default both run.
#
#   ./check.sh 3                 both: the book, then the sheet
#   ./check.sh 3 --book          just the book exercises
#   ./check.sh 3 --oppg          just the lecturer's sheet
#   ./check.sh 3 --solution      the book tests against the reference solution
#   ./check.sh 3 --repl          GHCi with your week-3 book code loaded
#   ./check.sh 3 --oppg --repl   GHCi with your week-3 sheet code loaded
#
# There is no --solution for the sheets: the lecturer asks that AI not solve
# them, so no reference answers exist.
#
# Exit status is 0 only when every check passes.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "usage: $(basename "$0") <week-number> [--book|--oppg] [--solution] [--repl]" >&2
  exit 2
}

[ $# -ge 1 ] || usage

WEEK=$(printf 'week%02d' "$(( 10#${1#week} ))" 2>/dev/null) || {
  echo "error: '$1' is not a week number" >&2; exit 2; }
shift

DIR="$HERE/$WEEK"
[ -d "$DIR" ] || { echo "error: no such week: $DIR" >&2; exit 2; }

TRACK=both SOLUTION= REPL=
for arg in "$@"; do
  case "$arg" in
    --book|-b)     TRACK=book ;;
    --oppg|-o)     TRACK=oppg ;;
    --solution|-s) SOLUTION=1 ;;
    --repl|-r)     REPL=1 ;;
    *) echo "error: unknown option '$arg'" >&2; usage ;;
  esac
done

HAS_OPPG=; [ -f "$DIR/Oppgaver.hs" ] && HAS_OPPG=1

if [ "$TRACK" = oppg ] && [ -z "$HAS_OPPG" ]; then
  echo "error: no lecturer's sheet in $WEEK yet" >&2; exit 2
fi

if [ -n "$SOLUTION" ]; then
  [ "$TRACK" = oppg ] && {
    echo "error: the lecturer's sheets have no reference answers, on purpose" >&2
    exit 2; }
  TRACK=book
  BOOK_SRC="$HERE/solutions/$WEEK"
  [ -d "$BOOK_SRC" ] || { echo "error: no solution for $WEEK yet" >&2; exit 2; }
else
  BOOK_SRC="$DIR"
fi

if [ -n "$REPL" ]; then
  if [ "$TRACK" = oppg ]; then
    exec ghci -Wno-x-partial -i"$HERE/lib" -i"$DIR" "$DIR/Oppgaver.hs"
  fi
  exec ghci -Wno-x-partial -i"$HERE/lib" -i"$BOOK_SRC" "$BOOK_SRC/Exercises.hs"
fi

# run <source dir> <test file>
run() {
  # Kept as a guard, not because it fires here any more: before libgmp-dev was
  # installed GHC emitted a shared-library warning about libgmp on every run,
  # and it would come back on a fresh machine that only has libgmp10. Strip it
  # so the test report is the only thing on screen. See ../docs/setup-notes.md.
  runghc -Wno-x-partial -i"$HERE/lib" -i"$1" "$2" 2>&1 \
    | grep -v -e 'missed-extra-shared-lib' \
              -e 'libgmp' \
              -e "It's OK if you don't want to use symbols" \
              -e 'the package DLL is loaded by the system linker' \
              -e 'which manages dependencies by itself' \
              -e '^<no location info>: warning:' \
    | cat -s
  return "${PIPESTATUS[0]}"
}

STATUS=0

if [ "$TRACK" != oppg ]; then
  run "$BOOK_SRC" "$DIR/Tests.hs" || STATUS=1
fi

if [ "$TRACK" != book ]; then
  if [ -n "$HAS_OPPG" ]; then
    run "$DIR" "$DIR/OppgaverTests.hs" || STATUS=1
  else
    echo
    echo "(no lecturer's sheet in $WEEK yet)"
  fi
fi

exit "$STATUS"
