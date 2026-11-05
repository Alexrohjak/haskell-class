# Hva Oblig.hs-en vår gjør

En forklaring av [`Oblig.hs`](Oblig.hs), del for del. Den beskriver den
ferdige koden slik den så ut 4. november (commit `bf8a13d`, 17/17 tester). Den
er forberedelse til intervjuet og ikke en del av innleveringen: vi leverer bare
`Oblig.hs`. (Norsk oversettelse av [`EXPLAINED.md`](EXPLAINED.md).)

Hele kjeden ser slik ut:

```
String ──tokenise──▶ [String] ──parse──▶ Ast ──generateEqns──▶ [Eqn] ──unify──▶ Type
```

`typeOf` binder kjeden sammen, og `main` legger en brukerløkke rundt den.

---

## §1.1 `data Ast`: formen på et uttrykk

`Ast` er treet et parset uttrykk blir til. Det finnes én konstruktør for hver
type ting grammatikken kan produsere:

- **De fire operatorene** (`Add`, `Sub`, `Mult`, `Div`) holder hver sin venstre
  og høyre operand som deltrær.
- **`App`** er funksjonsanvendelse, `[f x]` i obligens syntaks. Den holder
  funksjonen og argumentet, begge som trær.
- **`Val`** holder et tall som `Int`, og **`Var`** holder et variabelnavn som
  `String`. Dette er bladene.
- **`Lambda`** holder parameternavnet (bare en `String`, siden en parameter
  alltid er et rent navn) og kroppen som et tre.

Vi deriverer `Eq`, `Show` og `Read`, slik at trær kan sammenlignes, skrives ut i
GHCi og leses inn igjen.

## §1.2 `tokenise`: fra tegn til tokens

`tokenise` går gjennom inndatastrengen og deler den opp i bitene parseren
jobber med:

- Mellomrom hoppes over.
- `->` fanges først, som ett token på to tegn. Ellers ville `-` blitt tolket
  som subtraksjon.
- En sekvens av små bokstaver blir ett token (en identifikator), og en sekvens
  av sifre blir ett token (et tall som kan ha flere sifre). `span` deler
  sekvensen fra resten av inndataene i ett steg.
- Alle andre tegn (`+ - * : ( ) | [ ]`) blir et token på ett tegn.

Eksempel: `"|f -> [f 23]+ab"` gir `["|","f","->","[","f","23","]","+","ab"]`.

## §1.2 `parse`: fra tokens til et tre

Parseren bruker samme mønster som oppgavesett 8: **én funksjon per
grammatikknivå**. Hver av dem tar de gjenværende tokenene og returnerer et par:
treet den bygde og tokenene den ikke brukte. Neste funksjon fortsetter fra de
gjenværende tokenene.

- **`parseExpr`** (nivået med lavest prioritet: `+` og `-`). Den henter først et
  ledd fra `parseExpr1`. Hvis neste token er `+` eller `-`, parser den resten
  som en ny `parseExpr` og setter de to sammen med `Add` eller `Sub`. Ellers er
  leddet alene svaret.
- **`parseExpr1`** (mellomnivået: `*` og `:`) gjør det samme ett nivå ned. Den
  henter en verdi fra `parseValue` og setter den sammen med `Mult` eller `Div`.
  Denne oppdelingen er det som får `*` til å binde sterkere enn `+`: en hel
  `*`-kjede er ferdig før `parseExpr` i det hele tatt ser etter en `+`.
- **`parseValue`** (nivået med høyest prioritet: de minste enhetene) ser på
  første token og bestemmer:
  - sifre blir en `Val`, og små bokstaver blir en `Var`
  - `(` betyr: parse et helt `Expr` inni, og fjern så `)`
  - `|` betyr en lambda: neste token er parameternavnet, så hopper vi over
    navnet og `->` og parser kroppen som et fullt `Expr`. Kroppen strekker seg
    derfor så langt til høyre som mulig.
  - `[` betyr anvendelse: parse to *Values* etter hverandre (funksjon, så
    argument), og fjern så `]`
- **`parse`** er inngangspunktet. Den tokeniserer strengen, kjører `parseExpr`
  og beholder bare treet.

Fordi hvert operatornivå kaller seg selv på høyre side, grupperes kjeder mot
høyre: `5 - 3 - 1` parses som `Sub (Val 5) (Sub (Val 3) (Val 1))`.

---

## §2.1 `liste`: ferske navn på typevariabler

En uendelig liste `["t1","t2","t3",...]`, bygd med en listekomprehensjon over
`[1..]`. Haskell er lat, så listen bygges bare så langt noen leser den. Det er
lageret av ferske navn som `generateEqns` henter fra.

## §2.2 `data Type`: typene vi utleder

Det finnes tre slags typer:

- **`TVar`** er en ukjent type med et navn, for eksempel `t1`.
- **`NumT`** er talltypen.
- **`Arr a b`** er en funksjonstype `a -> b`.

Vi deriverer bare `Eq`. `Show` er skrevet for hånd, slik at typer skrives ut
slik PDF-en skriver dem (`(NumT->t1)->t1`) i stedet for som konstruktører
(`Arr (Arr NumT (TVar "t1")) (TVar "t1")`):

- `NumT` skrives som `NumT`, og `TVar x` skrives som bare navnet `x`.
- `Arr a b` skrives som `a->b`, med `show` kalt på hver side.
- **Parenteser kommer bare rundt en pil på venstre side av en annen pil.**
  Piler grupperes mot høyre, som i Haskells egne typesignaturer, så
  `NumT->t1->t1` betyr allerede `NumT->(t1->t1)`. Men `(NumT->t1)->t1` (en
  funksjon som *tar* en funksjon) trenger parentesene. Det nøstede mønsteret
  `Arr (Arr x y) b` fanger det tilfellet. Det står **over** den generelle
  `Arr a b`-linjen, fordi Haskell prøver mønstre ovenfra og ned, og den
  generelle linjen ellers ville truffet først.

## §2.3 `occursIn`: forekommer en variabel inne i en type?

`occursIn` går rekursivt gjennom en type og svarer på om et gitt variabelnavn
forekommer noe sted i den. En `TVar` sjekker om navnet stemmer, `NumT` svarer
nei, og en pil sjekker begge sidene sine. Unifisering trenger dette til
occurs-sjekken. Å sette `t1 = t1 -> NumT` ville beskrevet en uendelig dyp type,
så det må avvises.

## §2.3.1 `subst`: bytt ut en variabel overalt

`subst x s t` bygger `t` på nytt med hver `TVar x` byttet ut med typen `s`.
Alt annet kopieres uendret, og piler bygges på nytt med substitusjon på begge
sider. Slik sprer svaret fra en løst likning seg til likningene som gjenstår.

## §2.4 `unify`: løs likningene

`unify` tar en liste med typelikninger (`Eqn` er et par typer som må være
like) og typen vi vil ha svaret for, `t0`. Den går gjennom likningene én om
gangen med unifiseringsreglene fra forelesningen:

1. **Ta vare på `t0`.** En likning med `t0` på venstre side elimineres ikke.
   Den flyttes bakerst i listen. Når den er den eneste likningen igjen, er
   høyresiden svaret.
2. **Eliminer en variabel.** For `TVar a = x`, der `a` ikke forekommer i `x`:
   substituer `x` for `a` i alle de gjenværende likningene, og fjern så denne
   likningen. Occurs-sjekken er vakten `not (occursIn a x)`.
3. **Slett trivielle likninger.** `NumT = NumT` og `a = a` sier ingenting, så
   de fjernes.
4. **Dekomponer piler.** `a -> x = y -> z` blir to likninger, `a = y` og
   `x = z`.
5. **Bytt om.** Hvis variabelen står på høyre side (`x = TVar a`), snu
   likningen slik at regel 2 kan håndtere den.
6. **Feil.** Alt annet (en mislykket occurs-sjekk, eller en konflikt som
   `NumT = a -> b`) stopper med `error "Occurs check feil"`.

Eksempel: med `t0 = t1 -> NumT` og `t1 = NumT` returnerer `unify`
`Arr NumT NumT`. `t1`-likningen elimineres, svaret dens substitueres inn i
`t0`-likningen, og det er den likningen som blir igjen.

---

## §3: idéen i ett avsnitt

Typing fungerer som algebra. Hele uttrykket får en ukjent type, `t0`.
`generateEqns` går gjennom treet og skriver ned **fakta** (likninger) om de
ukjente, én eller flere per node. `unify` løser så faktaene og forteller hva
`t0` ble. `generateEqns` løser aldri noe selv; den bare skriver ned fakta.

## §3.1 `Context`: gule lapper

En kontekst er en liste med `(Ast, Type)`-par, for eksempel
`(Var "y", TVar "t1")`, som betyr «typen til y er t1». En lambda legger til en
lapp for parameteren sin, og en `Var` leser lappen. Variabler er det eneste som
står der.

PDF-en foreslår en valgfri `initialContext` med typene til operatorene. **Vi
bruker ikke en.** Alle operatorene har samme regel (tall inn, tall ut), så det
er enklere å hardkode den i `generateEqns` enn å slå den opp. PDF-en tillater
begge deler («kan eventuelt hardkodes»), og §3.1–3.2 er uansett bare hint:
selve oppgaven er §3.3.

## §3.2 `generateEqns`: skrive ned faktaene

```haskell
generateEqns :: Context -> Ast -> Type -> [String] -> ([Eqn], [String])
```

Med ord: gitt de kjente variablene, et tre, den ukjente for dette treet og et
lager av ubrukte navn, gi tilbake likningene pluss navnene som fortsatt er
ubrukt.

- **Den ukjente er en `Type`, ikke en `String`.** Dermed går den rett inn i
  likningene, og `typeOf` gir den samme verdien videre til `unify`. Det lar
  også et tilfelle gi et barn en *kjent* type (`NumT`) eller en bygd type
  (`Arr …`) i stedet for en ren variabel. Begge triksene brukes nedenfor.
- **Navnene tres gjennom som parserens gjenværende tokens.** Et tilfelle som
  kaller seg selv to ganger gir det andre kallet det det første kallet hadde
  igjen, og gir tilbake det det siste kallet hadde igjen. Dermed brukes aldri
  et navn to ganger.

`t` betyr alltid **typen til hele uttrykket i denne noden**. Tilfellene:

| Node | Ferske navn | Likninger den legger til | Hva barna får |
|---|---|---|---|
| `Val n` | ingen | `t = NumT` | – |
| `Var x` | ingen | `t = ` det konteksten sier x er; finnes den ikke i konteksten, er det en feil («unknown variable») | – |
| `Add`, `Sub`, `Mult`, `Div` | ingen | `t = NumT` | begge sider får `NumT` direkte, siden de må være tall |
| `Lambda x body` | `n1` (typen til x), `n2` (typen til kroppen) | `t = n1 -> n2` | kroppen får `n2`, med lappen `(Var x, n1)` lagt til i konteksten |
| `App f a` | `n1` (typen til argumentet) | ingen egne | `f` får `n1 -> t`, og `a` får `n1` |

To av tilfellene er verdt å si høyt:

- **Lambda**: typen til en funksjon er «parametertype → kroppstype», og ingen
  av dem er kjent ennå, så begge får ferske navn. Lappen i konteksten er
  hvordan `y` i kroppen senere finner ut at den er `n1`. Lapper legges *foran*
  i listen, så en indre lambdas `x` skygger for en ytre (`lookup` finner første
  treff).
- **App** `[f a]`: resultatet av kallet er typen til hele noden, som allerede
  har et navn, `t`. Bare typen til argumentet er ny. `f` må være «en funksjon
  fra argumentets type til `t`», så den får rett og slett den typen. `App`
  legger ikke til noen egen likning: faktaene kommer fra barna, bundet sammen
  fordi begge nevner `n1`.

Gjennomgang av `|f -> [f 2]`, med start i `t0`:

| Steg | Tar | Skriver |
|---|---|---|
| Lambda, gitt `t0` | `t1` (f), `t2` (kropp) | `t0 = t1 -> t2`, lapp: f er `t1` |
| App `[f 2]`, gitt `t2` | `t3` (typen til 2) | – |
| `f`, gitt `t3 -> t2` | – | `t3 -> t2 = t1` (fra lappen) |
| `2`, gitt `t3` | – | `t3 = NumT` |

Løst: `t1 = NumT -> t2`, så `t0 = (NumT -> t2) -> t2`. Det er PDF-ens
`(NumT->t1)->t1` med andre tall.

## §3.3 `typeOf`: hele kjeden

```haskell
typeOf s = unify eqs (TVar "t0")
  where (eqs, _) = generateEqns [] (parse s) (TVar "t0") liste
```

Les det som en typereise: `String` → `parse` → `Ast` → `generateEqns` →
`([Eqn], [String])` → behold likningene med mønsteret `(eqs, _)` → `unify` →
`Type`.

- **Tom kontekst**: ingenting er kjent i starten. En variabel får bare en type
  når en lambda introduserer den, og derfor gir `typeOf "x"` en feil.
- **`TVar "t0"` to ganger**: `generateEqns` skriver fakta om `t0`, og `unify`
  blir spurt hva `t0` er. Å spørre om en annen variabel ville vært å spørre om
  noe ingen likning beskriver.
- **`liste` starter på `t1`**: hvis `"t0"` var med, kunne en lambda valgt det
  som et «ferskt» navn, og to forskjellige ukjente ville smeltet sammen. Det er
  også grunnen til at svarene våre skrives `t1->t1` der PDF-en skriver
  `t0->t0`. Navnene er forskjellige, men typen er den samme.

## §4 `main`: kommandoløkken

`main` gjentar tre steg: **les en linje → se på første bokstav → handle**,
helt til den ser `q`. Lesing og utskrift er sideeffekter, så det er en
`IO ()`-handling skrevet med `do`.

- `line <- getLine` venter på en linje. `<-` betyr «kjør dette IO-steget og
  gi resultatet et navn».
- `case line of` velger kommandoen etter mønster:
  - `('t':_:expr)` betyr at første tegn er `t`, så et hvilket som helst tegn
    (mellomrommet), og resten er `expr`. Den skriver ut `show (typeOf expr)`.
  - `('f':_:name)`: `contents <- readFile name` leser filen (også `<-`, siden
    den kommer utenfra). `lines` deler den opp i uttrykk. En
    listekomprehensjon bygger én utskriftslinje per uttrykk,
    `e ++ " : " ++ show (typeOf e)`, og `unlines` limer dem sammen til én
    tekst for `putStr`.
  - `"q"` (en hel *streng* på én bokstav, derfor doble anførselstegn) gir
    `return ()`: ingenting mer å gjøre, så kontrollen går tilbake til GHCi.
- Etter `t` og `f` er siste linje `main` igjen. Løkken er bare `main` som
  kaller seg selv.

---

## Verdt å vite til intervjuet

Dette er fakta om koden slik den står. Om og hvordan noe av det skal endres,
bestemmer vi selv.

- **To `t0`-likninger samtidig.** Regel 1 flytter en `t0`-likning bakerst
  hver gang det er mer enn én likning. Hvis *alle* gjenværende likninger har
  `t0` på venstre side, bytter de bare plass i det uendelige. Jeg sjekket i
  GHCi: `unify [(TVar "t0", NumT), (TVar "t0", NumT)] (TVar "t0")` returnerer
  aldri. Med den ferdige `generateEqns` har det ikke skjedd i praksis: ingen
  av de 17 testene eller de ekstra eksemplene vi prøvde 4. november hang.
  Operatorene gir barna sine `NumT` i stedet for `t`, og det holder `t0` ute
  av de fleste likningene.
- **Ukjente kommandoer krasjer `main`.** En linje som ikke er `t …`, `f …`
  eller `q` (en tom linje, en skrivefeil) treffer ingen `case`, så `main`
  stopper med «Non-exhaustive patterns». En oppsamlingslinje `_ ->` ville
  fikset det.
- **En typefeil inne i `main` avslutter den.** `typeOf` rapporterer feil med
  `error`, så `t x` eller `t |a -> [a a]` skriver ut meldingen og forlater
  `main`. PDF-en sier ikke hva som skal skje da.
- **Ubrukte variabler.** `-Wall` flagger de ubrukte `ctx` og `n` i noen av
  tilfellene i `generateEqns`. Å skrive `_` i stedet fjerner advarselen.
- **Én feilmelding for to feil.** En mislykket occurs-sjekk og en typekonflikt
  gir begge «Occurs check feil». (Dette står allerede som et åpent punkt i
  `NOTES.md`.)
- **Partiell `parseValue`.** Den har ikke noe tilfelle for en tom tokenliste,
  og siste tilfelle er `otherwise = undefined`. `ghci` advarer også om `head`
  i lambda-tilfellet.
- **`parse` ignorerer gjenværende tokens**, så søppel etter et komplett
  uttrykk blir ikke oppdaget.
- **Gruppering mot høyre.** `5 - 3 - 1` blir `5 - (3 - 1)`. Sjekk dette mot
  grammatikken i PDF-en, og vær klar til å forklare hvorfor det er slik.
