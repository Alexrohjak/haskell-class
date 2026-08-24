# Links

Yours to edit. The sync writes `canvas-links.md` next door — that one is
generated from whatever the course links to, and is overwritten on every run.

## The course

- INF122 course page — <https://www.uib.no/emne/INF122>
- Mitt UiB — <https://mitt.uib.no/courses/59171>
- Course Discord — <https://discord.gg/Dh2DwgJER>
  Run by the gruppeleiarar, optional, a supplement only. All real announcements
  still come through Mitt UiB or email.

## The textbook

- Hutton, *Programming in Haskell* (2nd ed.) — <https://www.cs.nott.ac.uk/~pszgmh/pih.html>
  The author's own page: free chapter code, and his video lectures. Pensum is
  kap. 1–8, 10 and 15 — not the whole book.

## QuickCheck

Used from the first week's notes onward (`weeks/uke34/slides/1QuickCheck.pdf`).

```bash
cabal install --lib QuickCheck
```

- Intro — <https://wiki.haskell.org/Introduction_to_QuickCheck1>
- Manual — <https://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html>

The idea is worth more than the library: state a property that must hold for
*every* input (`sorted (qs xs)`), and let it generate the inputs. That is a
different habit from writing example-based tests, and it is closer to how the
exam asks you to reason about programs.

## Reference you will actually use

- Hoogle — <https://hoogle.haskell.org>
  Search by *type signature*. `(a -> b) -> [a] -> [b]` finds `map`. The single
  most useful Haskell tool there is.
- Prelude docs — <https://hackage.haskell.org/package/base/docs/Prelude.html>
  Every function you get without importing anything.
- GHC user's guide — <https://downloads.haskell.org/ghc/latest/docs/users_guide/>
- GHC error messages, explained — <https://errors.haskell.org>
- Haskell Language Server — <https://haskell-language-server.readthedocs.io>
  `ghcup install hls`. The lecturer recommends it with whatever editor you use.

## When Hutton isn't clicking

- Learn You a Haskell (community edition) — <https://learnyouahaskell.github.io>
  Chattier than Hutton, same ground. Good second explanation.
- Typeclassopedia — <https://wiki.haskell.org/Typeclassopedia>
  For when Functor/Applicative/Monad stop being three words and start being a
  hierarchy. Not pensum, and not week 3 either.
- Haskell in industry — <https://github.com/erkmos/haskell-companies>
  From his slide 5, if you ever wonder who actually pays for this.
