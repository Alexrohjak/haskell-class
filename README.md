# Haskell Class

Working directory for Haskell coursework.

## Layout

| Folder        | Use                                      |
|---------------|------------------------------------------|
| `lectures/`   | Code written along with lectures          |
| `exercises/`  | Practice problems / tutorial sheets       |
| `assignments/`| Graded submissions                        |
| `scratch/`    | Throwaway experiments                     |

## Toolchain

Nothing is installed yet. Recommended install via GHCup:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

That gives you `ghc` (compiler), `ghci` (REPL), `cabal` (build tool), and optionally `stack`.

## Quick use

```bash
ghci scratch/Hello.hs   # load into REPL
ghc  scratch/Hello.hs -o hello && ./hello   # compile and run
```

In GHCi: `:r` reload, `:t expr` type of, `:q` quit.
