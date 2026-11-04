# What our Oblig.hs does

An explanation of [`Oblig.hs`](Oblig.hs), section by section. It describes the
finished code as it stood on 4 November (commit `bf8a13d`, 17/17 tests). It's
interview prep, not part of the submission: we only hand in `Oblig.hs`.

The overall pipeline is:

```
String ──tokenise──▶ [String] ──parse──▶ Ast ──generateEqns──▶ [Eqn] ──unify──▶ Type
```

`typeOf` ties the pipeline together, and `main` puts a user loop around it.

---

## §1.1 `data Ast`: the shape of an expression

`Ast` is the tree a parsed expression becomes. There's one constructor for each
kind of thing the grammar can produce:

- **The four operators** (`Add`, `Sub`, `Mult`, `Div`) each hold their left
  and right operand as sub-trees.
- **`App`** is function application, `[f x]` in the oblig's syntax. It holds the
  function and its argument, both as trees.
- **`Val`** holds a number as an `Int`, and **`Var`** holds a variable name as a
  `String`. These are the leaves.
- **`Lambda`** holds the parameter name (just a `String`, since a parameter is
  always a bare name) and the body as a tree.

We derive `Eq`, `Show` and `Read` so trees can be compared, printed in GHCi
and read back in.

## §1.2 `tokenise`: from characters to tokens

`tokenise` walks the input string and cuts it into the pieces the parser works
with:

- Whitespace is skipped.
- `->` is caught first, as a single two-character token. If it weren't, the
  `-` would come out as subtraction.
- A run of lowercase letters becomes one token (an identifier), and a run of
  digits becomes one token (a number that may have several digits). `span`
  splits the run off from the rest of the input in one step.
- Any other character (`+ - * : ( ) | [ ]`) becomes a one-character token.

Example: `"|f -> [f 23]+ab"` gives `["|","f","->","[","f","23","]","+","ab"]`.

## §1.2 `parse`: from tokens to a tree

The parser uses the same pattern as Sheet 8: **one function per grammar level**.
Each one takes the remaining tokens and returns a pair: the tree it built and
the tokens it didn't use. The next function carries on from those leftover tokens.

- **`parseExpr`** (the lowest-priority level: `+` and `-`). It first gets a
  term from `parseExpr1`. If the next token is `+` or `-`, it parses the rest
  as another `parseExpr` and joins the two with `Add` or `Sub`. Otherwise the
  term on its own is the answer.
- **`parseExpr1`** (the middle level: `*` and `:`) does the same thing one
  level down. It gets a value from `parseValue` and joins it with `Mult` or
  `Div`. This split is what makes `*` bind tighter than `+`: a whole `*`-chain
  is finished before `parseExpr` ever looks for a `+`.
- **`parseValue`** (the highest-priority level: the smallest units) looks at
  the first token and decides:
  - digits become a `Val`, and lowercase letters become a `Var`
  - `(` means parse a whole `Expr` inside, then drop the `)`
  - `|` means a lambda: the next token is the parameter name, then we skip the
    name and the `->` and parse the body as a full `Expr`. So the body
    extends as far to the right as it can.
  - `[` means application: parse two *Values* in a row (function, then
    argument), then drop the `]`
- **`parse`** is the entry point. It tokenises the string, runs `parseExpr`,
  and keeps only the tree.

Because each operator level calls itself on the right, chains group to the
right: `5 - 3 - 1` parses as `Sub (Val 5) (Sub (Val 3) (Val 1))`.

---

## §2.1 `liste`: fresh type-variable names

An infinite list `["t1","t2","t3",...]`, built with a list comprehension over
`[1..]`. Haskell is lazy, so the list is only built as far as someone reads
it. It's the supply of fresh names that `generateEqns` will draw from.

## §2.2 `data Type`: the types we infer

There are three kinds of type:

- **`TVar`** is an unknown type with a name, such as `t1`.
- **`NumT`** is the number type.
- **`Arr a b`** is a function type `a -> b`.

We derive only `Eq`. `Show` is written by hand, so types print the way the PDF
writes them (`(NumT->t1)->t1`) instead of as constructors
(`Arr (Arr NumT (TVar "t1")) (TVar "t1")`):

- `NumT` prints as `NumT`, and `TVar x` prints as just the name `x`.
- `Arr a b` prints as `a->b`, calling `show` on each side.
- **Brackets go only around an arrow on the left of another arrow.** Arrows
  group to the right, as in Haskell's own type signatures, so `NumT->t1->t1`
  already means `NumT->(t1->t1)`. But `(NumT->t1)->t1` (a function that *takes*
  a function) needs its brackets. The nested pattern `Arr (Arr x y) b` catches
  that case. It sits **above** the general `Arr a b` line, because Haskell tries
  patterns top to bottom and the general line would match it first.

## §2.3 `occursIn`: does a variable appear inside a type?

`occursIn` recurses through a type and answers whether a given variable name
appears anywhere in it. A `TVar` checks whether its name matches, `NumT`
answers no, and an arrow checks both of its sides. Unification needs this for
the occurs check. Setting `t1 = t1 -> NumT` would describe an infinitely deep
type, so it has to be refused.

## §2.3.1 `subst`: replace a variable everywhere

`subst x s t` rebuilds `t` with every `TVar x` swapped for the type `s`.
Everything else is copied unchanged, and arrows are rebuilt with both sides
substituted. This is how a solved equation spreads its answer into the
equations that are still left.

## §2.4 `unify`: solve the equations

`unify` takes a list of type equations (`Eqn` is a pair of types that must be
equal) and the type we want the answer for, `t0`. It works through the
equations one at a time using the unification rules from the lecture:

1. **Keep `t0` around.** An equation whose left side is `t0` is not
   eliminated. It is moved to the back of the list. When it's the only
   equation left, its right side is the answer.
2. **Eliminate a variable.** For `TVar a = x`, where `a` doesn't occur in `x`,
   substitute `x` for `a` in all the remaining equations, then drop this
   equation. The occurs check is the `not (occursIn a x)` guard.
3. **Delete trivial equations.** `NumT = NumT` and `a = a` say nothing, so
   they're dropped.
4. **Decompose arrows.** `a -> x = y -> z` becomes two equations, `a = y`
   and `x = z`.
5. **Swap.** If the variable is on the right (`x = TVar a`), flip the
   equation so that rule 2 can handle it.
6. **Fail.** Anything else (a failed occurs check, or a clash such as
   `NumT = a -> b`) stops with `error "Occurs check feil"`.

Example: with `t0 = t1 -> NumT` and `t1 = NumT`, `unify` returns
`Arr NumT NumT`. The `t1` equation is eliminated, its answer is substituted
into the `t0` equation, and that equation is what's left.

---

## §3: the idea in one paragraph

Typing works like algebra. The whole expression gets an unknown type, `t0`.
`generateEqns` walks the tree and writes down **facts** (equations) about the
unknowns, one or more per node. `unify` then solves the facts and reports what
`t0` turned out to be. `generateEqns` never solves anything itself; it only
writes facts down.

## §3.1 `Context`: the sticky notes

A context is a list of `(Ast, Type)` pairs, such as `(Var "y", TVar "t1")`,
meaning "y's type is t1". A lambda adds a note for its parameter, and a `Var`
reads the note. Variables are the only thing in it.

The PDF offers an optional `initialContext` holding the operator types. **We
don't use one.** Every operator has the same rule (numbers in, number out), so
hard-coding it in `generateEqns` is simpler than looking it up. The PDF allows
both ("kan eventuelt hardkodes"), and §3.1–3.2 are only hints anyway: the task
itself is §3.3.

## §3.2 `generateEqns`: writing down the facts

```haskell
generateEqns :: Context -> Ast -> Type -> [String] -> ([Eqn], [String])
```

In words: given the known variables, a tree, the unknown for this tree, and a
supply of unused names, give back the equations plus the names still unused.

- **The unknown is a `Type`, not a `String`.** So it goes straight into
  equations, and `typeOf` hands the same value to `unify`. It also lets a case
  hand a child a *known* type (`NumT`) or a built one (`Arr …`) instead of a
  bare variable. Both tricks are used below.
- **The names are threaded like the parser's leftover tokens.** A case that
  calls itself twice gives the second call whatever the first call left over,
  and hands back what the last call left over. So no name is ever used twice.

`t` always means **the type of the whole expression at this node**. The cases:

| Node | Fresh names | Equations it adds | What the children get |
|---|---|---|---|
| `Val n` | none | `t = NumT` | – |
| `Var x` | none | `t = ` whatever the context says x is; not in the context is an error ("unknown variable") | – |
| `Add`, `Sub`, `Mult`, `Div` | none | `t = NumT` | both sides are handed `NumT` directly, since they must be numbers |
| `Lambda x body` | `n1` (x's type), `n2` (body's type) | `t = n1 -> n2` | the body gets `n2`, with the note `(Var x, n1)` added to the context |
| `App f a` | `n1` (the argument's type) | none of its own | `f` gets `n1 -> t`, and `a` gets `n1` |

Two cases are worth saying aloud:

- **Lambda**: a function's type is "parameter type → body type", and neither is
  known yet, so both get fresh names. The context note is how the `y` in the
  body later finds out it is `n1`. Notes go on the *front* of the list, so an
  inner lambda's `x` hides an outer one (`lookup` finds the first match).
- **App** `[f a]`: the result of the call is the whole node's type, which
  already has a name, `t`. Only the argument's type is new. `f` must be "a
  function from the argument's type to `t`", so it's simply handed that type.
  `App` adds no equation of its own: the facts come from the children, tied
  together because both mention `n1`.

Walkthrough, `|f -> [f 2]`, starting from `t0`:

| Step | Takes | Writes |
|---|---|---|
| Lambda, given `t0` | `t1` (f), `t2` (body) | `t0 = t1 -> t2`, note: f is `t1` |
| App `[f 2]`, given `t2` | `t3` (2's type) | – |
| `f`, given `t3 -> t2` | – | `t3 -> t2 = t1` (from the note) |
| `2`, given `t3` | – | `t3 = NumT` |

Solved: `t1 = NumT -> t2`, so `t0 = (NumT -> t2) -> t2`. That's the PDF's
`(NumT->t1)->t1` with different numbers.

## §3.3 `typeOf`: the whole chain

```haskell
typeOf s = unify eqs (TVar "t0")
  where (eqs, _) = generateEqns [] (parse s) (TVar "t0") liste
```

Read it as a type journey: `String` → `parse` → `Ast` → `generateEqns` →
`([Eqn], [String])` → keep the equations with the `(eqs, _)` pattern → `unify`
→ `Type`.

- **Empty context**: nothing is known at the start. A variable only gets a type
  when a lambda introduces it, which is why `typeOf "x"` is an error.
- **`TVar "t0"` twice**: `generateEqns` writes facts about `t0`, and `unify` is
  asked what `t0` is. Asking about any other variable would ask about
  something no equation describes.
- **`liste` starts at `t1`**: if `"t0"` were in it, a lambda could pick it as a
  "fresh" name and two different unknowns would merge. That's also why our
  answers print `t1->t1` where the PDF prints `t0->t0`. The names are
  different, but the type is the same.

## §4 `main`: the command loop

`main` repeats three steps: **read a line → look at the first letter → act**,
until it sees `q`. Reading and printing are side effects, so it is an `IO ()`
action written with `do`.

- `line <- getLine` waits for a line. `<-` means "run this IO step and name
  its result".
- `case line of` picks the command by pattern:
  - `('t':_:expr)` means the first char is `t`, then any char (the space), and
    the rest is `expr`. It prints `show (typeOf expr)`.
  - `('f':_:name)`: `contents <- readFile name` reads the file (also `<-`,
    since it comes from outside). `lines` splits it into expressions. A list
    comprehension builds one output line per expression, `e ++ " : " ++ show
    (typeOf e)`, and `unlines` glues them back into one text for `putStr`.
  - `"q"` (a whole one-letter *string*, so double quotes) gives `return ()`:
    nothing more to do, so control goes back to GHCi.
- After `t` and `f`, the last line is `main` again. The loop is just `main`
  calling itself.

---

## Things worth knowing for the interview

These are facts about the code as it stands. Deciding whether, and how, to
change any of them is up to us.

- **Two `t0` equations at once.** Rule 1 moves a `t0` equation to the back
  whenever there's more than one equation. If *every* remaining equation has
  `t0` on the left, they just keep swapping places. I checked in GHCi:
  `unify [(TVar "t0", NumT), (TVar "t0", NumT)] (TVar "t0")` never returns.
  With the finished `generateEqns` it hasn't happened in practice: none of the
  17 tests or the extra examples tried on 4 November hung. Operators hand their
  children `NumT` rather than `t`, which keeps `t0` out of most equations.
- **Unknown commands crash `main`.** A line that isn't `t …`, `f …` or `q`
  (an empty line, a typo) has no matching `case`, so `main` stops with
  "Non-exhaustive patterns". A catch-all `_ ->` line would fix it.
- **A type error inside `main` ends it.** `typeOf` reports errors with
  `error`, so `t x` or `t |a -> [a a]` prints the message and leaves `main`. The
  PDF doesn't say what should happen there.
- **Unused variables.** `-Wall` flags the unused `ctx` and `n` in some
  `generateEqns` cases. Writing `_` instead silences that.
- **One error message for two failures.** A failed occurs check and a type clash
  both report "Occurs check feil". (This is already an open item in `NOTES.md`.)
- **Partial `parseValue`.** It has no case for an empty token list, and its
  last case is `otherwise = undefined`. `ghci` also warns about the `head`
  in the lambda case.
- **`parse` ignores leftover tokens**, so trailing junk after a complete
  expression goes unnoticed.
- **Right-grouping.** `5 - 3 - 1` becomes `5 - (3 - 1)`. Check this against
  the grammar in the PDF and be ready to say why it's like that.
