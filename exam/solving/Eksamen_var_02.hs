module Eksamen_var_02 where

{-
  # INF122 — Øvingseksamen var-02 (variant, ikke en ekte eksamen)

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
  **1.1.** Uttrykket `[c | (c,i) <- zip "haskell" [0..], even i]` evaluerer til:

  (a) `"hsel"`  (b) `"akl"`  (c) `"hskl"`  (d) `"haskell"`  (e) en feil, siden `[0..]` er uendelig.
-}




{-
  **1.2.** Hva blir resultatet av å evaluere `f [3,1,2]` med hver av følgende definisjoner?

  ```haskell
  (a) f []     = []
      f (x:xs) = f xs ++ [x]

  (b) f (x:xs) = x : f xs

  (c) f xs = [y | y <- xs, y < head xs]

  (d) f xs = f (map (+1) xs)
  ```
-}




{-
  **1.3.** Angi typen til hvert av følgende uttrykk:

  - (a) `\x y -> x == y || x < y`
  - (b) `\xs -> [x | Just x <- xs]`
  - (c) `zipWith ($)`
  - (d) `\f -> map (f . fst)`
-}




{-
  **1.4.** Oppgi resultatet for hvert av kallene under:

  - (a) `foldr (\x acc -> x + 2*acc) 0 [1,2,3] =`
  - (b) `foldl (\acc x -> 2*acc + x) 0 [1,2,3] =`
  - (c) `foldl (flip (:)) [] [1,2,3] =`
  - (d) `foldr1 (-) [10,4,3] =`
-}




{-
  ## 2 Halerekursjon og induksjon (15%)
-}




{-
  **2.1.** Følgende funksjon returnerer det minste og det største elementet i en ikke-tom liste:

  ```haskell
  minmaks :: Ord a => [a] -> (a,a)
  minmaks [x]    = (x,x)
  minmaks (x:xs) = let (a,b) = minmaks xs in (min x a, max x b)
  ```

  F.eks. `minmaks [3,1,4,1,5] = (1,5)`, `minmaks "haskell" = ('a','s')` og `minmaks [7] = (7,7)`.

  Er definisjonen halerekursiv? Begrunn svaret. Gi en halerekursiv definisjon `minmaksH` (og evt. hjelpefunksjoner) slik at `minmaksH xs = minmaks xs` for hver ikke-tom liste `xs`.
-}




{-
  **2.2.** Gitt definisjonene:

  ```haskell
  m1. map f []     = []
  m2. map f (x:xs) = f x : map f xs
  l1. length []     = 0
  l2. length (x:xs) = 1 + length xs
  c1. (f . g) x = f (g x)
  ```

  (a) Angi typene til `map` og `length` (for lister).

  (b) Bevis ved induksjon at for alle lister `xs` og alle funksjoner `f` av rett type: `length (map f xs) = length xs`.

  (c) Bevis ved induksjon at for alle lister `xs` og alle funksjoner `f`, `g` av rett type: `map f (map g xs) = map (f . g) xs`.
-}




{-
  ## 3 Et lite robotspråk (35%)

  En robot står på et rutenett. Den har en posisjon `(x,y)` og en retning: nord `(0,1)`, øst `(1,0)`, sør `(0,-1)` eller vest `(-1,0)`. Den styres av programmer i følgende språk:

  ```
  P    ::= K | K P
  K    ::= F Tall | V | H | R Tall [ P ]
  Tall ::= Siffer | Siffer Tall
  Siffer ::= 0 | 1 | ... | 9
  ```

  Terminalsymboler er {`F`,`V`,`H`,`R`,`[`,`]`,`0`,...,`9`}, startsymbolet er `P`. Mellomrom kan forekomme mellom symbolene og har ingen betydning, bortsett fra å skille tall. Kommandoene betyr:

  - `F n` : gå n steg fram i den aktuelle retningen,
  - `V` : snu 90° til venstre (f.eks. fra nord til vest),
  - `H` : snu 90° til høyre (f.eks. fra nord til øst),
  - `R n [ P ]` : utfør programmet P n ganger.

  F.eks. går `"R4[F2 H]"` rundt et kvadrat og ender der den startet. Vi bruker datatypen

  ```haskell
  data Kmd = Fram Int | Venstre | Hoyre | Gjenta Int [Kmd] deriving (Show, Eq)
  ```

  der et program representeres som `[Kmd]`.
-}




{-
  **3.1.** Hvilke av følgende strenger er lovlige programmer? Begrunn kort for de ulovlige.

  (a) `"F10"`  (b) `"R2[]"`  (c) `"VH"`  (d) `"R[F1]"`  (e) `"F1R2[VF3]"`

  Er grammatikken entydig? Begrunn svaret kort.
-}




{-
  **3.2.** Programmer `tokens::String->[String]` som deler en streng i tokens: mellomrom hoppes over, en sammenhengende sekvens av siffer blir ett token, og ethvert annet tegn blir et eget token. F.eks.:

  ```haskell
  tokens "R 12[F3 V]" = ["R","12","[","F","3","V","]"]
  tokens "F2 X" = ["F","2","X"]
  ```
-}




{-
  **3.3.** Programmer en parser for språket ved rekursiv nedstigning, med funksjonene

  ```haskell
  parseP :: [String] -> Maybe ([Kmd],[String])
  parseK :: [String] -> Maybe (Kmd,[String])
  parse  :: String -> Maybe [Kmd]
  ```

  `parseP` og `parseK` gjenkjenner henholdsvis en `P` og en `K` i starten av token-listen, og returnerer resultatet sammen med de tokens som er igjen, eller `Nothing` hvis starten av listen ikke kan parses. `parse` returnerer `Just` programmet bare hvis hele strengen er et lovlig program, og `Nothing` ellers. F.eks.:

  ```haskell
  parseP ["F","1","]","H"] = Just ([Fram 1],["]","H"])
  parse "F2 R3[F1 V] H"    = Just [Fram 2, Gjenta 3 [Fram 1, Venstre], Hoyre]
  parse "R2[R3[F1] H]"     = Just [Gjenta 2 [Gjenta 3 [Fram 1], Hoyre]]
  parse "R2[F1"            = Nothing
  parse "F1 ]"             = Nothing
  parse "F"                = Nothing
  ```
-}




{-
  **3.4.** Med

  ```haskell
  type Tilstand = ((Int,Int),(Int,Int))   -- (posisjon, retning)
  start :: Tilstand
  start = ((0,0),(0,1))                   -- i origo, mot nord
  ```

  programmer `kjor::[Kmd]->Tilstand->Tilstand` som gir tilstanden etter at programmet er utført fra den gitte tilstanden. F.eks.:

  ```haskell
  kjor [Fram 2, Hoyre, Fram 3] start                  = ((3,2),(1,0))
  kjor [Gjenta 4 [Fram 2, Hoyre]] start               = ((0,0),(0,1))
  kjor [Gjenta 3 [Fram 1, Venstre], Fram 5] start     = ((4,0),(1,0))
  ```
-}




{-
  **3.5.** Programmer

  (a) `lengde::[Kmd]->Int` som gir det totale antallet steg roboten går når programmet utføres, f.eks.:

  ```haskell
  lengde [Fram 2, Gjenta 3 [Fram 1, Venstre, Fram 2]] = 11
  lengde [Gjenta 4 [Fram 2, Hoyre]] = 8
  lengde [Venstre] = 0
  ```

  (b) `vis::[Kmd]->String` som skriver et program tilbake som en streng, med ett mellomrom mellom påfølgende kommandoer og ingen mellomrom rundt `[` og `]`, slik at `parse (vis p) == Just p` for hvert program `p`. F.eks.:

  ```haskell
  vis [Fram 2, Gjenta 3 [Fram 1, Venstre], Hoyre] = "F2 R3[F1 V] H"
  ```
-}




{-
  ## 4 IO: robotskall med angring (15%)

  Programmer en aksjon `robot::IO()` (og alle hjelpefunksjoner/-aksjoner) der brukeren styrer roboten fra oppgave 3 (du kan bruke funksjonene derfra, selv om du ikke har programmert dem). Roboten starter i `start`. Programmet leser én linje om gangen:

  - `q` : avslutter aksjonen,
  - `angre` : roboten går tilbake til tilstanden den hadde før det siste programmet som ikke allerede er angret (man kan angre flere ganger på rad, helt tilbake til start); hvis det ikke er noe å angre, skriv `Ingenting å angre`,
  - enhver annen linje tolkes som et program: hvis det er lovlig, utføres det fra den aktuelle tilstanden; ellers skrives `Ugyldig program` og tilstanden er uendret.

  Etter hvert utført program og hver `angre` skrives den aktuelle tilstanden ut som posisjonen fulgt av retningen i ord (`nord`, `øst`, `sør`, `vest`). F.eks. (input fra brukeren og utskrift fra programmet i rekkefølge):

  ```
  > robot
  F2 H F3
  (3,2) øst
  R2[F1 V]
  (4,3) vest
  angre
  (3,2) øst
  angre
  (0,0) nord
  angre
  Ingenting å angre
  (0,0) nord
  F2 X
  Ugyldig program
  R3[F1
  Ugyldig program
  V F4
  (-4,0) vest
  q
  ```
-}




{-
  ## 5 Typeavledning (15%)
-}




{-
  **5.1.** La funksjonen `fun` være definert ved likningen `fun f x y = f y (f x y)`. Skriv definisjonen ved hjelp av λ-uttrykk, og bruk Hindley-Milner samt unifikasjonsalgoritme for å avlede typen til `fun`, eller vis at den ikke har noen type i Haskell.
-}




{-
  **5.2.** Bruk de samme algoritmene for å avlede typen til `\f -> f True && f 'c'`, eller vis at uttrykket ikke har noen type i Haskell. Her er `True :: Bool`, `'c' :: Char` og `(&&) :: Bool -> Bool -> Bool` konstanter, og `e1 && e2` betyr `(&&) e1 e2`.

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
