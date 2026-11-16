module Eksamen_2021 where

{-
  # INF-122 Funksjonell programmering — Eksamen 22. november 2021

  Universitetet i Bergen, Det matematisk-naturvitenskapelige fakultet (Norsk)

  | | |
  |---|---|
  | Eksamen i | INF-122 Funksjonell programmering |
  | Dato | 22 november 2021 |
  | Tid | 9:00 – 12:00 |
  | Antall sider | 3 |
  | Tillatte hjelpemidler | Alle trykte og skrevne |

  - Prosentsatsene angir *kun omtrentlig* vekting ved sensur og forventet tidsforbruk
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Dine funksjoner kan alltid ha en mer generell type enn den som kreves i oppgaven.
  - Du kan alltid definere egne hjelpefunksjoner, eller benytte funksjoner tilgjengelige fra andre moduler enn `Prelude`, men må da angi deres type.
-}

{-
  ## 1 Programmer følgende funksjoner: (15%)

  ### 1.1

  Definer funksjon `takeW::Int->String->String` slik at et kall `takeW n str` returnerer substreng av `str` med `n` første ord (et ord er en substreng mellom to mellomrom som selv ikke inneholder noen mellomrom), f.eks.:

  ```haskell
  takeW 1 "abc def ghi j klm" = "abc"
  takeW 4 "abc def ghi j klm" = "abc def ghi j"
  takeW 9 "abc def ghi j klm"= "abc def ghi j klm"
  ```

  ### 1.2

  En liste `xs` er en *subliste* av en liste `ys` hvis elementene fra `xs` forekommer i `ys` i den samme rekkefølgen, muligens med andre elementer innimellom, mens `xs` er en *substreng* av `ys` dersom den er en sammenhengende subliste av `ys`, uten noen andre elementer innimellom. F.eks. er "ship" en subliste, men ikke en substreng, av "Fish&Chips", mens den er en substreng av "Fiships".

  Definer funksjoner `erSubliste` og `erSubstreng`, hver med type `(Eq a)=>[a]->[a]->Bool`, som bestemmer om første listen er en subliste, respektivt, substreng, av den andre listen.
-}




{-
  ## 2 Høyere ordens funksjoner (40%)

  ### 2.1

  Et *fikspunkt* for en funksjon `f::a->a` er et element `x::a` slik at `f x == x`. For noen funksjoner `f`, kan et fikspunkt finnes ved å starte med et element `x` og anvende funksjonen tilstrekkelig antall ganger, dvs. `f(f(...f(x)...))`. Definer funksjon

  ```haskell
  finnFiksPunkt::(Eq a)=>(a->a)->a->Int->Maybe a,
  ```

  slik at `finnFiksPunk f x n` returnerer første fikspunktet funnet i løpet av høyst `n` applikasjoner av `f` til `x`, og `Nothing` ellers. For eksempel, for funksjonen `g x = div (x*3+5) 4`, blir `finnFiksPunkt g 1 10 = Just 2` og `finnFiksPunkt g 8 10 = Just 5`.

  ### 2.2

  Definer funksjon `serie::(Int->b)->Int->[b]` som returnerer en uendelig liste
  `serie f i = [f(i),f(i+1),f(i+2),f(i+3),...]`, f.eks.

  ```haskell
  take 3 (serie (id) 0) = [0,1,2]   og   take 5 (serie (+1) 0) = [1,2,3,4,5].
  ```

  ### 2.3

  Definer to følgende funksjoner, hver med ett kall til `serie` med passende parametere (og, muligens, noen kall til andre funksjoner):

  (a) `sq::Int->[Int]` slik at `sq n = [0²,1²,2²,...,n²]`, for `n::Int`, og

  (b) `streng::Int->String`, slik at `streng n = "f(0),f(1),...,f(n)"`, for `n::Int`, f.eks., `streng 0 = "f(0)"`, `streng 2 = "f(0),f(1),f(2)"`, osv..

  ### 2.4

  Definer funksjon `h::(Int->Int)->Int->[Int]` som returnerer en uendelig liste
  `h f i = [f(i), f(i)+f(i+1), f(i)+f(i+1)+f(i+2), f(i)+f(i+1)+f(i+2)+f(i+3),...]`.
  F.eks.

  ```haskell
  take 5 (h (id) 0) = [0,1,3,6,10]
  take 5 (h (+1) 0) = [1,3,6,10,15]
  ```

  ### 2.5

  Hva gjør funksjonen `hva xs = foldr (++) [] (map sing xs) where sing x = [x]`?
  Hva blir resultatet av kallet `hva [1,2,3]`?

  ### 2.6

  Fyll inn passende funksjoner (seksjoner) for `?1` og `?2` som gir likheten

  ```haskell
  map ?1 . filter ?2 = filter (>0) . map (+1).
  ```
-}




{-
  ## 3 Datatyper (35%)

  Vi behandler datatype av trær, der noder lagrer heltall og kan ha vilkårlig antall barn.

  ```haskell
  data Tre = Nd Int [Tre] deriving (Eq, Show)
  ```

  ### 3.1

  Definer funksjon `antb::Tre->Int` som gir antallet bladnoder (med tom barneliste).

  ### 3.2

  *Stilengde* av et tre er summen av lengder av stier fra roten til alle noder. Hvert tre i **3.3** har stilengde 9. Definer funksjon `stil::Tre->Int` som returnerer stilengde for et tre.

  ### 3.3

  Du skal definere to funksjoner, `kup` og `kus`, begge med typen `Tre->Tre` som returnerer input tre med hver nodes tall erstattet med produktet, respektivt, summen av alle tall i subtreet rotet i noden. Feks., for treet

  ```haskell
  t = Nd 1 [Nd 2 [Nd 3 []], Nd 4 [], Nd 5 [Nd 6 [], Nd 7 []]],
  ```

  til venstre, gir `kup t` treet i midten, og påfølgende applikasjon av `kup`, treet til høyre:

  ```
        1                        5040                      5276
      / | \        ==kup==>    /  |  \       ==kus==>    /  |  \
     2  4  5                  6   4   210               9   4   223
     |    / \                 |      /  \               |      /  \
     3   6   7                3     6    7              3     6    7
  ```

  ```haskell
  kup t = Nd 5040 [Nd 6 [Nd 3 []],Nd 4 [],Nd 210 [Nd 6 [],Nd 7 []]]
  kus (kup t) = Nd 5276 [Nd 9 [Nd 3 []], Nd 4 [], Nd 223 [Nd 6 [], Nd 7 []]].
  ```

  NB! For å få full uttelling, skal `kup` og `kus` være enkle kall til én generisk funksjon med passende parametere. Det samme gjelder for punkt **3.4**, så les det før du besvarer dette punktet.

  ### 3.4

  Et `Tre` kan representers som en streng tilsvarende DFS traveresering (fra en node `x` ned til første barnet `b1`, deretter rekursivt nedover fra `b1`, inntil man har besøkt hele subtre under `b1`, returnerer til `x` og fortsetter med andre barnet `b2` til `x`, osv.). En node skrives ut i det den besøkes fra foreldernoden, og hver gang traversering blir ferdig med barnelisten og backtracker til foreldernoden, innsettes tegnet '-'. Noder skilles med komma. F.eks., blir treet

  ```haskell
  Nd 1 [Nd 22 [Nd 3 []], Nd 4 [], Nd 55 [Nd 6[], Nd 77 []]],
  ```

  ```
         1
       / | \
     22  4  55
     |     /  \
     3    6    77
  ```

  representert av én av strengene (komma kreves kun for å skille tall)

  ```
  1,22,3--,4-,55,6-,77---  eller  1,22,3--4-55,6-77---  eller
  1,22,3--,4-,55,6-,77--   eller  1,22,3--4-55,6-77--.
  ```

  Definer funksjon `toStr::Tre->String` som returnerer en slik streng for et tre.

  NB! For full uttelling, skal også denne funksjonen implementeres som et enkelt kall med passende parametere til den samme generiske funksjonen som brukt for implementasjon av `kup` og `kus`. En slik funksjon kan ha type `(Int->[b]->b)->(Int->b)->Tre->b`, der første argumentet brukes ved interne noder og det andre ved blader. Dette er dog bare et eksempel.

  ### 3.5

  Gitt en strengrepresentasjon fra forrige punkt, definer fuksjon `bladene::String->[Int]` som returnerer listen av tall lagret ved alle bladnoder. For den bland strengene over som genereres av din implementasjon av `toStr`, skal `bladene` returnere `[3,4,6,77]`.
-}




{-
  ## 4 Typeavledning (10%)

  Gi en avledning av typen til `(\x y z -> (x z) (z y))` og spesifiser resultatet eller vis at uttrykket ikke har en type i Haskell.

  *Lykke til! — Michał Walicki*
-}




{-
  ## Vedlegg

  ### Hindley-Milner typeinferens: transformasjonsalgoritme

  | | input | ⇒ | output | |
  |---|---|---|---|---|
  | (t1) | E(Γ \| con :: t) | ⇒ | {t = θ(con)} | – typen til en konstant slås opp i ordboken |
  | (t2) | E(Γ \| x :: t) | ⇒ | {t = Γ(x)} | – typen til en variabel sjekkes i konteksten |
  | (t3) | E(Γ \| f g :: t) | ⇒ | E(Γ \| g :: a) ∪ E(Γ \| f :: a → t) | – a er en *fersk* typevariabel |
  | (t4) | E(Γ \| \x → ex :: t) | ⇒ | {t = a → b} ∪ E(Γ, x :: a \| ex :: b) | – a, b er *ferske* typevariabler |

  ### Martelli-Montanari unifikasjonsalgoritme

  | | input | ⇒ | output | forutsatt at : |
  |---|---|---|---|---|
  | (u1) | E, t = t | ⇒ | E | |
  | (u2) | E, f(t1...tn) = f(s1...sn) | ⇒ | E, t1 = s1, ..., tn = sn | |
  | (u3) | E, f(t1...tn) = g(s1...sm) | ⇒ | NO | f ≠ g eller n ≠ m |
  | (u4) | E, f(t1...tn) = x | ⇒ | E, x = f(t1...tn) | |
  | (u5) | E, x = t | ⇒ | E[x/t], x = t | x ∉ Var(t) |
  | (u6) | E, x = t | ⇒ | NO | x ∈ Var(t) |
-}
