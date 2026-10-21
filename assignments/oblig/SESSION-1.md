# Session 1: Phase 0 + §1 (parsing and ASTs)

The plan for the morning. You write all the code; this sheet only asks
questions and explains tools. Work top to bottom and stop at each **Q**. When
you get stuck, bring it to me and we'll take that one question together.

```bash
./tutorial/check.sh oblig --repl     # GHCi with Oblig.hs loaded; :r after each edit
```

The suite stays at 0/17 today, and that's expected. Today's "green" is the
checkpoint list at the end.

**Done for the morning:** `Ast` declared, `tokenise` and `parse` written, the file
loads, and every string in the checkpoint list parses to the tree you predicted
on paper.

---

## Part A: Phase 0 (about 30 minutes)

Read `oblig.pdf` from start to finish once, without writing anything. Then:

**Q0.1** The grammar has `Value : Expr1`. Section 1.1 lists `Add, Sub, Mult, Div`.
Section 3.1 lists `+, -, *, :`. Which constructor does `:` become? What does
that tell you its type must be, from what it does in Haskell?

**Q0.2** Open the PDF and look at the colours. Terminal symbols are red. In
`... |Ident -> Expr`, which `|` is the BNF "or", and which one is the lambda
symbol you have to parse?

**Q0.3** Section 2.1 says names `"t1", "t2", ...`, but the examples print `t0`. Do
you care? (The tests don't.) Decide, then write one line under *Decisions* in
`NOTES.md`.

**Q0.4** (intuition only, no algorithm yet) Look at `|f -> [f 2]` and its type
`(NumT->t1)->t1`. Say out loud why `f` must be a function, why its argument is
`NumT`, and why its result is a variable instead of `NumT`.

Tick Phase 0 in `NOTES.md`.

---

## Part B: §1.1, `data Ast`

Every constructor must hold enough to rebuild the expression. Go through them
one at a time.

**Q1.1** `Val` holds a Number. What Haskell type holds that? `Var` holds an
Ident. What type is that?

**Q1.2** `Add`, `Sub`, `Mult`, `Div`, `App`: how many sub-expressions does each
have, and what type are they?

**Q1.3** `Lambda` is the one real decision. It holds the bound variable and a
body. Should the variable be a `String` or an `Ast` (a `Var ...`)? Both work.
To decide, look ahead to 3.1: the Context is `[(Ast, Type)]`, and in Phase 3
you will push the lambda's variable onto it. Which choice makes that line
shorter? Write it under *Decisions*.

**Q1.4** What should `Ast` derive?
- You'll want to *look at* trees in GHCi today.
- In Phase 3 you'll search a `[(Ast, Type)]` for a key. What does `lookup :: Eq a => a -> [(a, b)] -> Maybe b`
  require of the key type?

Checkpoint: `:r` loads. Type one tree by hand in GHCi, for example the tree for `|x -> x`.

---

## Part C: §1.2, `tokenise`

**Q2.1** Before writing code, list every *kind* of token the grammar has. (Hint:
there are numbers, identifiers, and a handful of symbols. Find all the symbols,
including the two-character one.)

**Q2.2** On paper, tokenise `[[|a -> |b -> a+b 2] 3]` and `|f -> [f 2]`. These
are your expected outputs. Check them in GHCi later.

**Q2.3** Compare with your Sheet 8 `tokenise` (`tutorial/week08/Oppgaver.hs`).
Which guards carry over unchanged, and what's new?

Tools you'll need:

- **`span`** again, for numbers this time. `span isDigit "42+x"` gives `("42", "+x")`.
  (`isDigit` comes from `Data.Char`, which `Oblig.hs` doesn't import yet.)
- **Matching more than one character at the head.** A pattern can name several
  leading elements: `f ('o':'k':rest) = ...` matches only strings that start with
  `"ok"`, and binds the remainder to `rest`. Equations are tried top to bottom.

**Q2.4** Why does the order of your equations matter for `-` and `->`? What
does `"a->b"` tokenise to if you get it wrong?

---

## Part D: §1.2, `parse`

It's the same pattern as Sheet 8: one function per grammar level, each of type
`[String] -> (Ast, [String])`, returning the tree plus the tokens it didn't use.

| Grammar | Sheet 8 counterpart |
|---|---|
| `Expr ::= Expr1 + Expr \| Expr1 - Expr \| Expr1` | `parseB` (but two operators, not one) |
| `Expr1 ::= Value * Expr1 \| Value : Expr1 \| Value` | `parseA` |
| `Value ::= ...` | `parseC` |

**Q3.1** `parseB` checked for one operator after parsing an `A`. `Expr` has two
operators, and each builds a different constructor. How do you change the
shape? (There's more than one fair answer.)

**Q3.2** `Value` has five alternatives. For each one, what does the *first token*
look like? That first token is how you pick the alternative, just as `parseC`
did with `"T"`, `"F"` and `"("`.

**Q3.3** For `[ Value Value ]`: you parse a Value, then another Value from what's
left, then expect `]`. Why does the grammar say *Value* here and not *Expr*?
(Try to parse `[f 2]` in your head as if it said Expr.)

**Q3.4** A lambda body is an `Expr`, so it keeps going as far as it can. Trace
`[|a -> a+3 4]` by hand: where does the body stop, and why doesn't it swallow
the `4`?

**Q3.5** `parse` drops the leftover tokens. Should it complain if any are left
over? (Optional, but if you do, write it under *Decisions*.)

Don't change this: `Expr1 - Expr` is right-recursive, so `5-3-1` parses as
`5-(3-1)`. That's what the grammar says, and it doesn't affect typing.

---

## Checkpoints

Before running each one, write down on paper the tree you expect.

```haskell
tokenise "[[|a -> |b -> a+b 2] 3]"
tokenise "|f->[f 2]"              -- no spaces at all
parse "5"
parse "x"
parse "|x -> x"
parse "|x -> x+x"
parse "[|a -> a+3 4]"
parse "|a -> a + [|b -> b 2]"
parse "|f -> [f 2]"
parse "|f -> |a -> [f a]"
parse "|a -> [a a]"
parse "[4 5]"
parse "2*3:4+1-5"
parse "(1+2)*3"
```

Tick Phase 2 in `NOTES.md`.

## Parking lot

Questions for the group session, or for us:

-
