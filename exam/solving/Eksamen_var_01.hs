module Eksamen_var_01 where

{-
  # INF122 — Øvingseksamen var-01 (variant, ikke en ekte eksamen)

  | | |
  |---|---|
  | Eksamen i | INF-122 Funksjonell programmering |
  | Tid | 3 timer |
  | Tillatte hjelpemidler | Ingen |

  - Prosentsatsene angir *kun omtrentlig* vekting ved sensur og forventet tidsforbruk.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Programmer og angi typen til alle hjelpefunksjoner som du selv innfører. Din kode skal ikke forutsette andre funksjoner enn de som er tilgjengelige fra standard `Prelude`.
-}

{-
  ## 1 Velg/angi riktige svar (20%)
-}




{-
  **1.1.** Uttrykket `[x*y | x <- [1..3], y <- [x..3], odd (x+y)]` evaluerer til:

  (a) `[2,6]`  (b) `[2,3,6]`  (c) `[2,6,6]`  (d) `[1,2,3,6,9]`  (e) `[3,6]` .
-}




{-
  **1.2.** Hva blir resultatet av å evaluere `take 4 xs` med hver av følgende definisjoner?

  ```haskell
  (a) xs = 1 : map (*2) xs
  (b) xs = 1 : zipWith (+) xs (tail xs)
  (c) xs = 1 : 1 : zipWith (+) xs (tail xs)
  (d) xs = 2 : [x+3 | x <- xs]
  ```
-}




{-
  **1.3.** Angi typen til hvert av følgende uttrykk:

  - (a) `(.) (+1)`
  - (b) `\f -> f . f`
  - (c) `map (uncurry (+))`
  - (d) `\x -> [x] : []`
-}




{-
  **1.4.** Angi hva GHCi gir for hvert av uttrykkene under: en verdi (hvilken?), en feilmelding, eller ingen avslutning.

  - (a) ``length [undefined, 1 `div` 0]``
  - (b) `fst (3, length [1..])`
  - (c) `sum (takeWhile (<10) [1,3..])`
  - (d) `takeWhile (<10) (filter even [1,3..])`
  - (e) `null (filter (>5) [1..])`
-}




{-
  ## 2 Høyereordens funksjoner (20%)
-}




{-
  **2.1.** Programmer med mønstre (eller `case`) en funksjon `utfold::(b->Maybe (a,b))->b->[a]` som bygger en liste fra en startverdi. Funksjonen i det første argumentet anvendes på den aktuelle tilstanden: gir den `Nothing`, er listen ferdig; gir den `Just (x,s)`, blir `x` neste element i listen, og `s` den nye tilstanden. F.eks.:

  ```haskell
  utfold (\n -> if n > 5 then Nothing else Just (n*n, n+1)) 1 = [1,4,9,16,25]
  utfold (\xs -> if null xs then Nothing else Just (sum xs, tail xs)) [1,2,3] = [6,5,3]
  ```

  Definer deretter, hver med ett kall til `utfold` med passende argumenter:

  (a) `bits::Int->[Int]` som gir binærsifrene til et ikke-negativt tall, minst signifikante siffer først, f.eks.:

  ```haskell
  bits 6 = [0,1,1]      bits 13 = [1,0,1,1]      bits 0 = []
  ```

  (b) `biter::Int->[a]->[[a]]` som deler en liste i biter med lengde `k` (den siste biten kan være kortere), f.eks.:

  ```haskell
  biter 2 [1,2,3,4,5] = [[1,2],[3,4],[5]]
  biter 3 "abcdefgh" = ["abc","def","gh"]
  ```

  For full uttelling i **2.2** skal funksjonene programmeres uten listemønstre og uten eksplisitt rekursjon, med høyst funksjonene `foldr`, `(.)`, `map`, `filter` og λ-uttrykk.
-}




{-
  **2.2.** Programmer:

  (a) `antall::(a->Bool)->[a]->Int` som teller elementene som tilfredsstiller predikatet, f.eks.:

  ```haskell
  antall even [1,2,4,7,8] = 3       antall (=='a') "banana" = 3
  ```

  (b) `del::(a->Bool)->[a]->([a],[a])` som, med ett enkelt kall til `foldr`, deler listen i elementene som tilfredsstiller predikatet og de som ikke gjør det (begge i opprinnelig rekkefølge), f.eks.:

  ```haskell
  del even [1,2,4,7,8] = ([2,4,8],[1,7])
  del (<'n') "haskell" = ("hakell","s")
  ```

  (c) `alle::[a->Bool]->a->Bool` som gir `True` hvis elementet i det andre argumentet tilfredsstiller alle predikatene i listen, f.eks.:

  ```haskell
  alle [even,(>10)] 12 = True     alle [even,(>10)] 8 = False     alle [] 5 = True
  ```
-}




{-
  **2.3.** Gitt definisjonen

  ```haskell
  hva = foldr (\x ys -> x : take 2 ys) []
  ```

  Angi typen til `hva`, forklar hva funksjonen gjør, og angi resultatet av `hva [5,4,3,2,1]` og av `hva [1..]`.
-}




{-
  ## 3 Binære søketrær (30%)

  Vi bruker binære trær med elementer lagret i de indre nodene:

  ```haskell
  data Tre a = Tom | Node (Tre a) a (Tre a) deriving Show
  ```

  Et *søketre* er et tre der, for hver node `Node v x h`, alle elementer i `v` er mindre enn `x` og alle elementer i `h` er større enn `x`. Ingen elementer forekommer to ganger.
-}




{-
  **3.1.** Programmer `settInn::Ord a=>a->Tre a->Tre a` som setter inn et element i et søketre slik at resultatet er et søketre (forekommer elementet allerede, returneres treet uendret), og `fraListe::Ord a=>[a]->Tre a` som bygger et søketre ved å sette inn elementene fra listen ett om gangen, fra venstre mot høyre, i et tomt tre. F.eks.:

  ```haskell
  fraListe [5,3,8,1,4,8] = Node (Node (Node Tom 1 Tom) 3 (Node Tom 4 Tom)) 5 (Node Tom 8 Tom)
  ```

  ```
           5
         /   \
        3     8
       / \
      1   4
  ```

  ```haskell
  settInn 7 (fraListe [5,3,8,1,4,8])
      = Node (Node (Node Tom 1 Tom) 3 (Node Tom 4 Tom)) 5 (Node (Node Tom 7 Tom) 8 Tom)
  ```
-}




{-
  **3.2.** Programmer den generiske funksjonen `foldT::(b->a->b->b)->b->Tre a->b` (naturlig fold for `Tre`), og bruk den for å definere, hver med ett kall til `foldT`:

  - `inorden::Tre a->[a]` — elementene fra venstre mot høyre,
  - `storrelse::Tre a->Int` — antallet elementer,
  - `hoyde::Tre a->Int` — antallet noder på den lengste stien fra roten (et tomt tre har høyde 0).

  For `t = fraListe [5,3,8,1,4,8]`:

  ```haskell
  inorden t = [1,3,4,5,8]     storrelse t = 5     hoyde t = 3     hoyde (fraListe [1..5]) = 5
  ```
-}




{-
  **3.3.** Programmer `mellom::Ord a=>a->a->Tre a->[a]` slik at `mellom lo hi t` gir, i stigende rekkefølge, alle elementer `x` i søketreet `t` med `lo <= x <= hi`. Funksjonen skal ikke besøke subtrær som ikke kan inneholde slike elementer. F.eks., med `t` som over:

  ```haskell
  mellom 2 6 t = [3,4,5]     mellom 4 4 t = [4]     mellom 9 20 t = []
  ```
-}




{-
  **3.4.** To søketrær skal regnes som like når de inneholder de samme elementene, uansett form. Gjør `Tre a` til en instans av `Eq` (for `Eq a`) slik at f.eks.:

  ```haskell
  fraListe [2,1,3] == fraListe [1,2,3]   = True
  fraListe [3,1,3] == fraListe [1,3]     = True
  fraListe [1,2]   == fraListe [1,2,3]   = False
  ```
-}




{-
  **3.5.** Vi vil teste funksjonene med QuickCheck.

  (a) Skriv en egenskap `prop_sortert::[Int]->Bool` som sier at `inorden (fraListe xs)` er strengt stigende, og en egenskap `prop_mellom::Int->Int->[Int]->Bool` som sammenligner `mellom` med en enkel definisjon som bruker `filter`.

  (b) Hva skriver du i GHCi for å teste `prop_sortert`, og hva betyr svaret `+++ OK, passed 100 tests.`?

  (c) Noen foreslår egenskapen `prop_lengde xs = storrelse (fraListe xs) == length xs`. Holder den? Begrunn svaret, og gi et moteksempel hvis den ikke holder.
-}




{-
  ## 4 Litt IO (15%)

  Programmer en aksjon `mengde::IO()` (og alle hjelpefunksjoner/-aksjoner) som lar brukeren vedlikeholde en mengde heltall, lagret i et søketre fra oppgave 3 (du kan bruke funksjonene derfra, selv om du ikke har programmert dem). Mengden er tom i starten. Programmet leser én kommando per linje:

  - `+ n` : legger tallet n til mengden (ingen utskrift),
  - `? n` : skriver `ja` hvis n er i mengden, og `nei` ellers,
  - `vis` : skriver elementene i mengden som en stigende liste,
  - `m a b` : skriver listen med elementene x i mengden med a ≤ x ≤ b,
  - `q` : skriver `Ha det!` og avslutter.

  Tallene n, a og b er ikke-negative heltall. Ved ugyldig input (ukjent kommando, feil antall argumenter, eller et argument som ikke er et tall) skriver programmet en passende melding og fortsetter med den samme mengden. F.eks. (input fra brukeren og utskrift fra programmet i rekkefølge):

  ```
  > mengde
  + 5
  + 3
  + 9
  ? 4
  nei
  + 4
  ? 4
  ja
  vis
  [3,4,5,9]
  m 4 8
  [4,5]
  + x
  Ugyldig kommando: + x
  m 4
  Ugyldig kommando: m 4
  + 3
  vis
  [3,4,5,9]
  q
  Ha det!
  ```
-}




{-
  ## 5 Typeavledning (15%)

  La funksjonen `fun` være definert ved likningen: `fun f g x = g (f x) x`.
-}




{-
  **5.1.** Skriv denne definisjonen ved hjelp av λ-uttrykk, dvs. på formen `fun = \f -> ...`
-}




{-
  **5.2.** Bruk Hindley-Milner samt unifikasjonsalgoritme for å avlede typen til `fun`, eller vis at den ikke har noen type i Haskell.
-}




{-
  **5.3.** Bruk de samme algoritmene for å avlede typen til `\x -> \y -> y x (x y)`, eller vis at uttrykket ikke har noen type i Haskell.

  Lykke til!
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
