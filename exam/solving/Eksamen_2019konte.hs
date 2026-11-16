module Eksamen_2019konte where

{-
  # INF-122 Funksjonell programmering — konteeksamen 14. februar 2020 (2019konte)

  - **Dato:** 14 februar 2020
  - **Tid:** 9:00 – 12:00
  - **Antall sider:** 4 (inkl. vedlegg)
  - **Tillatte hjelpemidler:** Ingen

  - Prosentsatsene angir *kun omtrentlig* vekting ved sensur og forventet tidsforbruk.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Programmer, og angi typen til, alle hjelpefunksjoner som du selv innfører. Din kode skal ikke forutsette andre funksjoner enn de som er tilgjengelige fra standard `Prelude`.
-}

{-
  ## 1 Velg/angi riktige svar (25%)
-}




{-
  **1.1.** Evaluering av `filter even (map (*2) [1..5])` gir:

  - (a) `[2,4]`
  - (b) `[4,8]`
  - (c) `[2,6,10]`
  - (d) `[2,4,6,8,10]`
-}




{-
  **1.2.** Hva blir resultatet av å evaluere `take 5 nats` med hver av følgende definisjoner?

  - (a) `nats = 0:1:tail nats`
  - (b) `nats = 0:tail nats`
  - (c) `nats = 0:map (+1) nats`
  - (d) `nats = map (+1) [0..]`
-}




{-
  **1.3.** Hva blir resultatet avå evaluere `concat ["ab","cd","","efg"]` med hver av følgende definisjoner?

  - (a) `concat xss = [x | x<-xss]`
  - (b) `concat xss = [x | xs<-xss, x<-xs]`
  - (c) `concat xss = concat (tail xss)`
  - (d) `concat xss = map (++) xss`
-}




{-
  **1.4.** Funksjon `apply` definert ved `apply f x = f x` har typen:

  - (a) `a -> b -> c`
  - (b) `(a -> b) -> a -> b`
  - (c) `a -> (b -> a) -> b`
  - (d) `a -> b -> (a -> b)`
-}




{-
  ## 2 Matrisemultiplikasjon (20%)

  To n×n matriser multipliseres ved følgende formel (x<sub>r,k</sub> er tallet i r-te rad og k-te kolonne):

  ```
  ⎡ a1,1 a1,2 ... a1,n ⎤   ⎡ b1,1 b1,2 ... b1,n ⎤   ⎡ c1,1 c1,2 ... c1,n ⎤
  ⎢ a2,1 a2,2 ... a2,n ⎥ ⊗ ⎢ b2,1 b2,2 ... b2,n ⎥ = ⎢ c2,1 c2,2 ... c2,n ⎥ ,
  ⎢ ...  ...  ... ...  ⎥   ⎢ ...  ...  ... ...  ⎥   ⎢ ...  ...  ... ...  ⎥
  ⎣ an,1 an,2 ... an,n ⎦   ⎣ bn,1 bn,2 ... bn,n ⎦   ⎣ cn,1 cn,2 ... cn,n ⎦
  ```

  der, for 1 ≤ r ≤ n og 1 ≤ k ≤ n, er tallet c<sub>r,k</sub> – i r-te rad og k-te kolonne av resultatmatrisen – definert ved følgende multiplikasjon av r-te rad fra første matrisen med k-te kolonne fra andre matrisen (∗, + er vanlig multiplikasjon og addisjon):

  ```
                                       ⎡ b1,k ⎤
  c_r,k = [a_r,1 , a_r,2 , ..., a_r,n] ⊗ ⎢ b2,k ⎥ = a_r,1 ∗ b1,k + a_r,2 ∗ b2,k + ... + a_r,n ∗ bn,k .
                                       ⎢ ...  ⎥
                                       ⎣ bn,k ⎦
  ```

  For eksempel,

  ```
  ⎡1 2⎤   ⎡3 4⎤   ⎡(1∗3 + 2∗5) (1∗4 + 2∗6)⎤   ⎡13 16⎤
  ⎣3 4⎦ ⊗ ⎣5 6⎦ = ⎣(3∗3 + 4∗5) (3∗4 + 4∗6)⎦ = ⎣29 36⎦
  ```

  Vi representerer en n × n matrise som en liste med n lister, tilsvarende rader i matrisen. F.eks. matriser `[1 2; 3 4]` og `[3 4; 5 6]` representeres ved lister `[[1, 2], [3, 4]]` og `[[3, 4], [5, 6]]`. Programmer følgende funksjoner (og eventuelle hjelpefunksjoner):
-}




{-
  **2.1.** `row::[[Int]] -> Int -> [Int]` – `row m r` returner r-te rad fra matrisen m, f.eks. `row [[1,2],[3,4]] 2 = [3,4]`.
-}




{-
  **2.2.** `col::[[Int]] -> Int -> [Int]` – `col m k` returner k-te kolonne fra matrisen m, f.eks. `col [[1,2],[3,4]] 1 = [1,3]`.
-}




{-
  **2.3.** `cols::[[Int]] -> [[Int]]` – returnerer liste med kolonner for matrisen, f.eks. `cols [[1,2],[3,4]] = [[1,3],[2,4]]`.
-}




{-
  **2.4.** `mult::[[Int]]->[[Int]]->[[Int]]` – gitt to n × n matriser, returnerer resultatet av deres multiplikasjon, f.eks., `mult [[1,2],[3,4]] [[3,4],[5,6]] = [[13,16],[29,36]]`.
-}




{-
  ## 3 IO og postfiksuttrykk (35%)

  Vi betrakter følgende grammatikk for aritmetiske uttrykk i postfiks notasjon:

  ```
  E   ::= Pos | E E * | E E + | E E –
  Pos ::= Digit | DigitPos
  Digit ::= 0 | 1 | ... 8 | 9
  ```

  Pos er ikke-terminal symbol for ikke-negative heltall (altså, uten noen minus tegn foran). Et uttrykk evalueres ved at en binær operator anvendes på to uttrykk til venstre for den, med uttrykket lenger til venstre som det første argumentet, f.eks.:

  - (a) `"11 2 3 * + 4 –"` tilsvarer `(11 + (2 * 3)) – 4`
  - (b) `"11 2 * 3 + 4 –"` tilsvarer `((11 * 2) + 3) – 4`
  - (c) `"4 11 2 3 * + –"` tilsvarer `4 – (11 + (2 * 3))`

  Postfiks uttrykk evalueres online, mens de leses fra venstre til høyre, vha. en stabel. I det man leser et tall, legges det øverst på stabelen, mens i det man leser en operator, hentes – og fjernes – to øverste tall fra stabelen, anvendes operator på dem, og så legges resultatet øverst på stabelen. Eksemplene viser sekvenser av stabeler, der hver stabel stammer fra forrige i det tegnet som står under stabelen er lest.

  (Stabeldiagram; hver kolonne er en stabel, toppen øverst, og tegnet under streken er det som nettopp ble lest.)

  ```
  (a)                                  (b)                                  (c)
                                                                                      3
            3                                                                     2   2   6
        2   2   6       4                  2       3       4                 11  11  11  11  17
   11  11  11  11  17  17  13         11  11  22  22  25  25  21         4   4   4   4   4   4  −13
   ---------------------------        ---------------------------        ---------------------------
   11   2   3   ∗   +   4   −         11   2   ∗   3   +   4   −         4  11   2   3   ∗   +   −
  ```

  Programmer en aksjon `eval::IO()` (og alle hjelpefunksjoner) som leser fra terminalen én linje om gangen, med ett ikke-negativt heltall eller én operator, inntil brukeren taster en tom linje (dvs., kun Enter/CR knappen) for å avslutte programmet. Etter hver innlest linje, viser programmet stabelen resulterende fra evaluering av hele uttrykket som har blitt lest så langt, som i eksemplene over.

  **NB!** Utskriften skal bestå kun av en liste med tall tilsvarende stabelen. F.eks., i tre eksemplene over, skriver programmet lister som følger, etter hver input fra brukeren (dvs., ett tall, `+`, `*` eller `–`, med Enter/CR knappen etter hver av dem):

  ```
  (a)                 (b)                 (c)
  > eval              > eval              > eval
  11                  11                  4
  [11]                [11]                [4]
  2                   2                   11
  [2,11]              [2,11]              [11,4]
  3                   *                   2
  [3,2,11]            [22]                [2,11,4]
  *                   3                   3
  [6,11]              [3,22]              [3,2,11,4]
  +                   +                   *
  [17]                [25]                [6,11,4]
  4                   4                   +
  [4,17]              [4,25]              [17,4]
  –                   –                   –
  [13]                [21]                [-13]
  ```

  Når brukeren taster et ugyldig input (feil tegn, eller en operator når det ikke er nok argumenter), skal programmet gi en passende tilbakemelding og fortsette evaluering av uttrykket som har blitt samlet opp, etter at brukeren gir korrekt input.
-}




{-
  ## 4 Hindley-Milner (20%)

  La fuksjonen `apply` være definert ved likningen: `apply f x = f x`.
-}




{-
  **4.1.** Skriv denne definisjonen ved hjelp av λ-uttrykk, dvs. på formen `apply = \f ->...`
-}




{-
  **4.2.** Bruk Hindley-Milner samt unifikasjonsalgoritme for å avlede typen til `apply`.

  *Lykke til!* — Michal Walicki
-}




{-
  ## Vedlegg

  **Hindley-Milner typeinferens: transformasjonsalgoritme**

  | | input | ⇒ output | |
  |---|---|---|---|
  | (t1) | E(Γ \| con :: t) | ⇒ {t = θ(con)} | – typen til en konstant slås opp i ordboken |
  | (t2) | E(Γ \| x :: t) | ⇒ {t = Γ(x)} | – typen til en variabel sjekkes i konteksten |
  | (t3) | E(Γ \| f g :: t) | ⇒ E(Γ \| g :: a) ∪ E(Γ \| f :: a → t) | – a er en fersk typevariabel |
  | (t4) | E(Γ \| \x → ex :: t) | ⇒ {t = a → b} ∪ E(Γ, x :: a \| ex :: b) | – a, b er ferske typevariabler |

  **Martelli-Montanari unifikasjonsalgoritme**

  | | input | ⇒ output | forutsatt at: |
  |---|---|---|---|
  | (u1) | E, t = t | ⇒ E | |
  | (u2) | E, f(t1 ... tn) = f(s1 ... sn) | ⇒ E, t1 = s1, ..., tn = sn | |
  | (u3) | E, f(t1 ... tn) = g(s1 ... sm) | ⇒ NO | f ≠ g eller n ≠ m |
  | (u4) | E, f(t1 ... tn) = x | ⇒ E, x = f(t1 ... tn) | |
  | (u5) | E, x = t | ⇒ E[x/t], x = t | x ∉ Var(t) |
  | (u6) | E, x = t | ⇒ NO | x ∈ Var(t) |
-}
