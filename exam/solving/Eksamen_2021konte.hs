module Eksamen_2021konte where

{-
  # INF-122 Funksjonell programmering — Kontinuasjonseksamen 2. mars 2022 (2021konte)

  Universitetet i Bergen, Det matematisk-naturvitenskapelige fakultet (Norsk)

  | | |
  |---|---|
  | Eksamen i | INF-122 Funksjonell programmering |
  | Dato | 2 mars 2022 |
  | Tid | 9:00 – 12:00 |
  | Antall sider | 3 |
  | Tillatte hjelpemidler | Alle trykte og skrevne |

  - Prosentsatsene angir *kun omtrentlig* forventet tidsforbruk og vekting ved sensur.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Dine funksjoner kan alltid ha en mer generell type enn den som kreves i oppgaven.
  - Med mindre noe annet er sagt, kan du benytte egendefinerte hjelpefunksjoner eller funksjoner tilgjengelige fra andre moduler enn `Prelude`, men må da angi deres type.
-}

{-
  ## 1 Programmer følgende funksjoner: (35%)

  ### 1.1

  `abc::t->Int->t->[t]` slik at kallet `abc x n y` gir en liste med `n` kopier av elementet `x` etterfulgt av ett element `y`, f.eks.,

  ```haskell
  abc 1 2 3 = [1,1,3]          abc 'a' 5 'b' = "aaaaab".
  ```

  ### 1.2

  `tryggIndeks::[t]->Int->t->t` slik at kallet `tryggIndeks xs n def` returnerer elementet med indeks `n` fra listen `xs`, dersom `n` er en lovlig indeks inne i listen `xs`. I motsatt fall returneres elementet `def`(ault). F.eks.:

  ```haskell
  tryggIndeks [0,1,2,3] 4 9 = 9          tryggIndeks "abcd" 1 'x' = 'b'
  tryggIndeks [4,2,2,7] 3 9 = 7          tryggIndeks "abcd" 6 'x' = 'x'.
  ```

  ### 1.3

  `inds::String->String->[Int]` slik at `inds sub str` returnerer liste med indekser til posisjoner i `str` der `sub` starter som en delstreng av `str` (dvs. en sammenhengende ord identisk med `sub`, ikke adskilt med andre tegn). F.eks.:

  ```haskell
  inds "ab" "xabaabbab" = [1,4,7]          inds "aaa" "aaaa" = [0,1]
  inds "aa" "aaaa" = [0,1,2]               inds "ac" "abcaa" = [].
  ```

  ### 1.4

  `ordTeller::String->[(String,Int)]` som returnerer liste av par `(ord,ant)`, med hvert `ord` som forekommer i input strengen og `ant`allet av ordets forekomster der. Et ord er en streng som ikke inneholder noen mellomrom og som forekommer i teksten `inp` mellom to mellomrom. Resulterende liste skal være sortert alfabetisk etter ordene. F.eks.:

  ```haskell
  ordTeller "ikke alle er her er der alle men ikke er"
            = [("alle",2),("der",1),("er",3),("her",1),("ikke",2),("men",1)].
  ```

  ### 1.5

  `dec::Int->String->Int` som omregner strengen i andre argumentet, tolket som et tall i base `b` angitt som første argumentet, til et tall i base 10. (En serie siffer dₙ...d₂d₁d₀ i base b, med hvert siffer dᵢ < b, tilsvarer tallet dₙ ∗ bⁿ + ... + d₂ ∗ b² + d₁ ∗ b¹ + d₀ i base 10.) Strengen må altså bestå av siffer < `b`, der 2 ≤ `b` ≤ 10, ellers skal feil repporteres. F.eks.:

  ```haskell
  dec 10 "123" = 123, dvs. 1 ∗ 10² + 2 ∗ 10¹ + 3
  dec 2 "110" = 6,  dvs. 2² + 2¹ + 0          dec 4 "301" = 49, dvs. 3 ∗ 4² + 0 ∗ 4¹ + 1.
  dec 3 "110" = 12, dvs. 3² + 3¹ + 0          dec 3 "301" = error:for stort siffer.
  ```
-}




{-
  ## 2 Lister (25%)

  Du har gitt følgende typer (ment som angitt av navn og kommentar):

  ```haskell
  type EtOrd = String -- ett ord, tegn venstre-til-høyre uten noen mellomrom
  type Linje = [EtOrd] -- én linje, ord venstre-til-høyre (muligens tom, med ingen ord)
  type Side = [Linje] -- én side, linjer venstre-til-høyre (muligens tom, med ingen linje)
  type Bok = [Side] -- en bok, sider venstre-til-høyre
  ```

  Et "ord" betyr en ikke tom streng uten noen mellomrom.

  ### 2.1

  Bruk kun `map`, `(.)`, `sum` og `length` for å definere i én linje (uten noen hjelpefunksjoner) hver av funksjoner

  (a) `antLinjer::Bok->Int`, som returnerer antall linjer i input boken, og

  (b) `antOrd::Bok->Int`, som returnerer antall ord i input boken

  ### 2.2

  Definer funksjon `eqs::Bok->Bok->Bool` som returnerer `True` hvis begge bøkene inneholder identisk tekst, dvs. de samme ordene i den samme rekkefølgen (der tomme linjer (som inneholder ingen ord), tomme sider (som inneholder ingen linjer) og sammenhengende mellomrom ikke spiller noen rolle), og `False` ellers. F.eks., følgende to dokumenter er like

  ```haskell
  [[["dette","er","første linje"],["på","side","en"]],[],[["siste","linje"]]] og
  [[["dette","er","første linje"]],[["på","side","en"],["siste","linje"],[]]]
  ```

  selv om det første har 3 sider, med andre siden tom og uten noe tomme linjer, mens det andre har to sider, der ingen er tom mens på den siste er det en tom linje på slutten.
-}




{-
  ## 3 Trær (40%)

  Vi behandler datatype av trær, der noder lagrer vilkårlig type og kan ha vilkårlig antall barn.

  ```haskell
  data Tre t = Nd t [Tre t] deriving (Eq, Show)
  ```

  Barn til en node `'N x trs'` er gitt av listen `trs` og bladnoder er de med tom barneliste.

  ### 3.1

  Definer to funksjoner som returnerer

  (a) `noder::Tre t->[t]` – listen med elementer lagret ved alle noder i treet.

  (b) `hoyde::Tre t->Int` – høyden av treet (lengden av lengste sti fra roten til en bladnode).

  For full uttelling, skal hver av disse funksjoner implementeres ved et enkelt kall til én og samme høyre-ordens funksjon med passende parametere.

  ### 3.2

  Definer funksjon `iso::(Tre a,Tre b)->Bool` som avgjør om to trær er isomorfe, dvs. har samme 'form', definert ved at to bladnoder er isomorfe, mens to indre noder (med ikke tomme barnelister) er isomorfe hvis og bare hvis de har samme antallet barn og deres første barna er isomorfe, andre barna er det, osv.. F.eks., all par av trær på tegningen i oppgave **3.3** er isomorfe, mens ingen i oppgave **3.4** er det.

  ### 3.3

  Definer funksjon `fmap::(a->b)->(Tre a->Tre b)` som anvender argumentfunksjon på hver node i tre (og gjør `Tre` til en instans av `Functor`). Bruk `fmap` for å definere funksjoner

  (a) `up::Tre Int->Tre Int`, som øker tallet lagret ved hver node med 1, samt

  (b) `const::Tre t->String->Tre String`, erstatter elementer ved alle noder i argument `Tre t` med oppgitt streng og returnerer et isomorft tre med denne strengen ved alle noder.

  Eksemplet under viser resultatet av `const "c" (up t)` for treet

  ```haskell
  t = Nd 1 [Nd 2 [Nd 3 []], Nd 4 [], Nd 5 [Nd 6 [], Nd 7 []]]:
  ```

  ```
        1                       2                              "c"
      / | \       ==up==>     / | \     ==const "c"==>      /   |   \
     2  4  5                 3  5  6                     "c"   "c"   "c"
     |    / \                |    / \                     |         /   \
     3   6   7               4   7   8                   "c"      "c"   "c"
  ```

  ### 3.4

  Vi antar nå at alle elementer lagret i et tre er forskjellige. Definer funksjon

  ```haskell
  inns::Eq t => t -> Tre t -> Tre t -> Tre t,
  ```

  slik at `inns n t1 t2` setter inn i et slikt tre `t1` et nytt subtre `t2`. `t2` blir et barn til noden som lagrer elementet `n`, dersom en slik node finnes i treet `t1`, og dersom resulterende tre fortsatt vil ha alle elementer forskjellige. I motsatt fall, returneres treet `t1` uendret. F.eks.:

  ```haskell
  inns 1 (Nd 1 [Nd 2 [Nd 3 []], Nd 4 []]) (Nd 5 [Nd 6 [], Nd 7 []])
                 = (Nd 1 [Nd 2 [Nd 3 []], Nd 4 [], Nd 5 [Nd 6 [], Nd 7 []]])
  ```

  som vist her:

  ```
  inns 1     1          5        =        1
            / \        / \              / | \
           2   4      6   7            2  4  5
           |                           |    / \
           3                           3   6   7
  ```

  *Lykke til! — Michał Walicki*
-}
