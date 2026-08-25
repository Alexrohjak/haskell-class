# Setup notes

What is installed on this machine for INF122, and the one thing that was broken.

## Toolchain

Installed through GHCup, nothing through apt:

| | |
|---|---|
| GHC | 9.10.3 |
| cabal | 3.16.1.0 |
| stack | 3.11.1 |
| HLS | 2.14.0.0 — has a binary for GHC 9.10.3 |
| QuickCheck | 2.18.0.0, via `cabal install --lib` |

QuickCheck is not in a package database `ghc-pkg` will show. `cabal install
--lib` records it in a **GHC environment file**,
`~/.ghc/x86_64-linux-9.10.3/environments/default`, which `ghc` and `runghc` read
automatically. Verified with the lecturer's own qsort property from
`weeks/uke34/slides/1QuickCheck.pdf`: `+++ OK, passed 100 tests.`

That environment file is global, and the tutorial harness is meant to need
nothing beyond `base`. Both built weeks were re-run against their reference
solutions afterwards — 19/19 and 42/42 — so it does not interfere.

HLS is the server only. Point your editor at
`haskell-language-server-wrapper`; the configuration guides are in
[`../resources/links.md`](../resources/links.md).

## The libgmp problem — fixed 24 August 2026

`sudo apt install libgmp-dev` was run and this is resolved. Kept because it was
invisible for weeks, and because a fresh machine starts out in exactly this state.

**GHC on this machine could interpret Haskell but not produce a binary.**

```
$ ghc T.hs -o t
/usr/bin/x86_64-linux-gnu-ld.bfd: cannot find -lgmp: No such file or directory
```

Ubuntu ships `libgmp10` (the runtime library, `libgmp.so.10`) but the linker
looks for the unversioned `libgmp.so`, which only the **dev** package provides.
GHC links every binary against GMP for `Integer`, so:

- `runghc` and `ghci` — fine. Nothing is linked, which is why the tutorial
  harness has always passed and this went unnoticed.
- `ghc -o prog`, and **`cabal build`** — failed. That matters, because the
  obligatorisk oppgåve is expected to be a cabal project.

This is also the source of the `libgmp.so` warning that `tutorial/check.sh`
filters out of its test report. The warning was the symptom; this was the cause.

### The stopgap in place now, and why it is not enough

A user-level symlink standing in for the dev package's:

```bash
mkdir -p ~/.local/lib
ln -s /usr/lib/x86_64-linux-gnu/libgmp.so.10 ~/.local/lib/libgmp.so
```

The linker only finds it when `LIBRARY_PATH` points there, which is how
QuickCheck and HLS were installed:

```bash
export LIBRARY_PATH="$HOME/.local/lib"
```

There is then a second, accidental effect worth understanding. QuickCheck was
built with `--extra-lib-dirs=$HOME/.local/lib`, so its entry in the cabal store
package db records that directory — and the global GHC environment file exposes
that db to every `ghc` call. GHC turns each library dir into a `-L`, so a plain
`ghc -o prog` now links **even with no environment variable set**.

Do not rely on it:

- it works only while that environment file and that package exist;
- **`cabal build` ignores the environment file, so it still fails** — verified on
  an empty `cabal init`-style project depending on nothing but `base`.

Which means the oblig cannot be built until the real fix is applied.

### The fix that was applied

```bash
sudo apt install libgmp-dev      # + libgmpxx4ldbl, 351 kB
```

That installs the `/usr/lib/x86_64-linux-gnu/libgmp.so` symlink the linker was
looking for. Verified afterwards in a scrubbed environment (`env -i`, and
`-package-env=-` so the accidental `-L` could not help):

- `ghc -o prog` links and runs
- `cabal build` links and runs, on a project depending only on `base`
- the `libgmp.so` warning GHC used to print on every `runghc` is gone

The `~/.local/lib/libgmp.so` stopgap was then **deleted**, and both still work —
so nothing depends on it. `tutorial/check.sh` keeps filtering the old warning as
a guard for a fresh machine, which is a comment in that file, not a live problem.

If root is genuinely unavailable, the no-root equivalent is to make both paths
permanent by hand: `extra-lib-dirs: /home/alexrohjak/.local/lib` in
`~/.cabal/config` for cabal, and `export LIBRARY_PATH="$HOME/.local/lib"` in
`~/.bashrc` for plain `ghc`. Two moving parts instead of none, which is why it is
the second choice.

`.venv/bin/python src/check_setup.py` compiles a throwaway program on every run — with
environment files bypassed, so it tests the toolchain rather than the accident —
and exits non-zero while this is unfixed.
