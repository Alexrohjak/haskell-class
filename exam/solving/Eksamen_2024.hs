module Eksamen_2024 where

{-
  # INF122 — Eksamen 9. desember 2024

  Universitetet i Bergen, Det matematisk-naturvitenskapelige fakultet

  | | |
  |---|---|
  | Eksamen i | INF-122 Funksjonell programmering |
  | Dato | 9 desember 2024 |
  | Tid | 3 timer |
  | Antall sider | 4 (inkl. vedlegg) |
  | Tillatte hjelpemidler | Ingen |

  - Prosentsatsene angir *kun omtrentlig* vekting ved sensur og forventet tidsforbruk.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Programmer og angi typen til alle hjelpefunksjoner som du selv innfører.
-}

{-
  ## 1 Velg/angi riktige svar (25%)
-}




{-
  **1.1.** Evaluering av `filter even (map (*2) [1..5])` gir:

  (a) `[2,4]`  (b) `[4,8]`  (c) `[2,4,6,8]`  (d) `[2,4,6,8,10]` .
-}




{-
  **1.2.** Hva blir resultatet av `con ["ab","cd","","efg"]` med hver av følgende definisjoner?

  ```haskell
  (a) con xss = [x | x<-xss]
  (b) con xss = [x | xs<-xss, x<-xs]
  (c) con xss = con (tail xss)
  (d) con xss = map (++) xss
  ```
-}




{-
  **1.3.** Hva blir resultatet av å evaluere `take 5 nats` med hver av følgende definisjoner?

  ```haskell
  (a) nats = 0:1:tail nats
  (b) nats = 0:tail nats
  (c) nats = 1:map (+1) nats
  (d) nats = iterate (+1) 0
  ```
-}




{-
  **1.4.** Funksjon `apply` definert ved `apply f x = f x` har typen:

  (a) `a->b->b`  (b) `(a->b)->a->b`  (c) `a->(b->a)->b`  (d) `a->b->(a->b)` .
-}




{-
  ## 2 Høyereordens funksjoner (25%)
-}




{-
  **2.1.** I Prelude finnes den en funksjon `zipWith::(a->b->c)->[a]->[b]->[c]`, som anvender en funksjon gitt som det første argumentet på par av påfølgende elementer fra lister i det andre og tredje argumentet. F.eks.:

  ```haskell
  zipWith (+) [4,2,5,6] [2,6,2,3,11] = [6,8,7,9]
  zipWith max [6,3,2,1] [7,3,1] = [7,3,2]
  zipWith (++) ["a ","bar ","go"] ["cat","hop","od"]
                                        = ["a cat","bar hop","good"]
  ```

  Programmer `zipWith` med mønstre og deretter definer vanlig `zip::[a]->[b]->[(a,b)]` ved ett kall til `zipWith` med et passende argument.

  For full uttelling i neste to deloppgaver, **2.2.** og **2.3.**, skal funksjonene programmeres uten mønstre ved å bruke høyst funksjoner: `foldr`, `$`, `(.)`, `id`, `map`.
-}




{-
  **2.2.** Programmer funksjon `ap::[b->b]->b->b` som anvender funksjoner fra listen i det første argumentet (fra høyre til venstre, dvs., den siste funksjonen i listen anvendes først) på det andre argumentet. F.eks.:

  ```haskell
  ap [(+1),(*3)] 4 = 13
  ap [(*3),(+1)] 4 = 15
  ```
-}




{-
  **2.3.** Programmer funksjon `apl::[b->b]->[b]->[b]` som anvender funksjoner fra listen i det første argumentet (fra høyre til venstre; den siste funksjonen i listen anvendes først) på hvert element i den andre listen. F.eks.:

  ```haskell
  apl [(+1),(*3)] [1,3,4] = [4,10,13]
  apl [(*3),(+1)] [1,3,4] = [6,12,15]
  ```
-}




{-
  ## 3 Postfiksuttrykk og IO (35%)

  Oppgaven går ut på å evaluere aritmetiske uttrykk i postfiks notasjon. Det blir tilstrekkelig at du kan lese korrekt slike uttrykk, men i tilfelle behov finner du grammatikken på slutten av oppgaven. Et postfiksuttrykk bruker ikke parenteser mens operatorer plasseres etter argumenter. Et infiksuttrykk "`x ⊙ y`", med en binær operator ⊙, skrives i postfiks som "`x y ⊙`" (venstre argument av infiks kommer i postfiks først, og etterfølges av høyre infiks argument). F.eks.:

  (a) "8 12 5 * + 4 –" tilsvarer (8 + (12 * 5)) – 4
  (b) "8 12 * 5 + 4 –" tilsvarer ((8 * 12) + 5) – 4
  (c) "8 12 5 4 * + –" tilsvarer 8 – (12 + (5 * 4))

  Postfiksuttrykk kan evalueres fortløpende mens de leses fra venstre til høyre v.hj.a. en stabel (uten eksplisitt parsing eller konstruksjon av syntakstrær). Et innlest tall legges øverst på stabelen, mens i det programmet leser en (binær) operator, fjernes to øverste tall fra stabelen, anvendes operator på dem, og så legges resultatet øverst på stabelen. Eksemplene under viser sekvenser av stabler, der hver stabel stammer fra forrige i det tegnet som står under stabelen er lest.

  *(Figur: hver kolonne er en stabel, toppen øverst; tegnet under streken er input som ga stabelen. Gjengitt nøyaktig som på arket.)*

  ```
  (a)                                  (b)                                  (c)
                                                                                      4
              5                                                                  5    5    20
         12   12   60        4              12        5         4           12   12   12   12   32
    8    8    8    8    68   68   64     8  8    96   96   101  101  97   8  8    8    8    8    8    −24
   ---------------------------------   --------------------------------  ----------------------------------
    8    12   5    *    +    4    −     8  12   *    5    +    4    −    4  12   5    4    *    +    −
  ```

  Programmer en aksjon `eval::IO()` (og alle hjelpefunksjoner/-aksjoner) som leser fra terminalen én linje om gangen, med ett ikke-negativt heltall eller én binær operator (som er enten `+`, `*`, eller minus `-`), inntil brukeren taster en tom linje (dvs., kun Enter/Return knappen) for å avslutte aksjonen. Etter hver innlest linje, viser programmet stabelen resulterende fra evaluering av hele uttrykket som har blitt lest så langt, som i eksemplene over.

  NB! Etter hver input skriver programmet ut kun listen med tall tilsvarende stabelen. I tre eksemplene over, blir hver input fra brukeren (/ett tall, +, * eller –, med Enter/Return etter hver av dem) besvart med utskrift av listen, som angitt med `[...]` i figuren under.

  ```
  (a)              (b)              (c)
  > eval           > eval           > eval
  8                8                8
  [8]              [8]              [8]
  12               12               12
  [12,8]           [12,8]           [12,8]
  5                *                5
  [5,12,8]         [96]             [5,12,8]
  *                5                4
  [60,8]           [5,96]           [4,5,12,8]
  +                +                *
  [68]             [101]            [20,12,8]
  4                4                +
  [4,68]           [4,101]          [32,8]
  –                –                –
  [64]             [97]             [-24]
  ```

  Når input fra brukeren er ugyldig (feil tegn, eller en operator når det ikke er nok argumenter), skal programmet gi en passende tilbakemelding og fortsette evaluering av uttrykket som har blitt samlet opp, etter at brukeren gir korrekt input.

  **Grammatikk for aritmetiske postfiksuttrykk**

  Terminalsymboler er {`0`,`1`,..,`9`,`*`,`+`,`-`}, startsymbolet er `E` og `Pos` er ikke-terminal symbol for ikke-negative heltall (uten noen minus tegn foran). Regler er som følger:

  ```
  E ::= Pos | E E * | E E + | E E -
  Pos ::= Siffer | Siffer Pos
  Siffer ::= 0 | 1 | ...  8 | 9
  ```
-}




{-
  ## 4 Typeavledning (15%)

  La fuksjonen `fun` være definert ved likningen: `fun x y = x y y`.
-}




{-
  **4.1.** Skriv denne definisjonen ved hjelp av λ-uttrykk, dvs. på formen `fun = \x ->...`
-}




{-
  **4.2.** Bruk Hindley-Milner samt unifikasjonsalgoritme for å avlede typen til `fun` eller vise at den ikke har noen type i Haskell.

  Lykke til!
  Michał Walicki

  *(Vedlegg på neste side)*
-}




{-
  ## Vedlegg

  **Hindley-Milner typeinferens: transformasjonsalgoritme**

  | | input | ⇒ output | |
  |---|---|---|---|
  | (t1) | E(Γ \| con :: t) | ⇒ {t = θ(con)} | typen til en konstant slås opp i ordboken |
  | (t2) | E(Γ \| x :: t) | ⇒ {t = Γ(x)} | typen til en variabel sjekkes i konteksten |
  | (t3) | E(Γ \| f g :: t) | ⇒ E(Γ \| g :: a) ∪ E(Γ \| f :: a → t) | a er en fersk typevariabel |
  | (t4) | E(Γ \| \x → ex :: t) | ⇒ {t = a → b} ∪ E(Γ, x :: a \| ex :: b) | a, b er ferske typevariabler |

  **Martelli-Montanari unifikasjonsalgoritme**

  | | input | ⇒ output | forutsatt at: |
  |---|---|---|---|
  | (u1) | E, t = t | ⇒ E | |
  | (u2) | E, f(t1...tn) = f(s1...sn) | ⇒ E, t1 = s1, ..., tn = sn | |
  | (u3) | E, f(t1...tn) = g(s1...sm) | ⇒ NO | f ≠ g eller n ≠ m |
  | (u4) | E, f(t1...tn) = x | ⇒ E, x = f(t1...tn) | |
  | (u5) | E, x = t | ⇒ E[x/t], x = t | x ∉ Var(t) |
  | (u6) | E, x = t | ⇒ NO | x ∈ Var(t) |
-}
