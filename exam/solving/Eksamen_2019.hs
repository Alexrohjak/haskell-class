module Eksamen_2019 where

{-
  # INF-122 Funksjonell programmering — eksamen 27. november 2019

  - **Dato:** 27 november 2019
  - **Tid:** 15:00 – 18:00
  - **Antall sider:** 3
  - **Tillatte hjelpemidler:** Ingen

  - Prosentsatsene angir *kun omtrentlig* vekting ved sensur og forventet tidsforbruk.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Programmer, og angi typen til, alle hjelpefunksjoner som du selv innfører. Din kode skal ikke forutsette andre funksjoner enn de som er tilgjengelige fra standard `Prelude`.
-}

{-
  ## 1 Velg/angi riktige svar (10%)
-}




{-
  **1.1.** Uttrykket `[(x,y) | x<-[1,2], y<-[1,2]]` evaluerer til:

  - a) `([1,2],[1,2])`
  - b) `[(1,2),(1,2)]`
  - c) `[(1,1),(2,2)]`
  - d) `[(1,1),(2,1),(1,2),(2,2)]`
  - e) `[(1,1),(1,2),(2,1),(2,2)]`
-}




{-
  **1.2.** Evaluering av `zip [1,2] ['a','b','c']` gir:

  - a) en error
  - b) `([1,2],['a','b','c'])`
  - c) `[(1,'a'),(2,'b')]`
  - d) `[(1,'a'),(2,'b'),(2,'c')]`
-}




{-
  **1.3.** Angi typen til verdier i a) og b), og til funksjoner i c) og d):

  - a) `[(False, '0'), (True, '1')]`
  - b) `[reverse, tail, take 3]`
  - c) `two x = (x, x)`
  - d) `\p -> filter p`
-}




{-
  **1.4.** Oppgi resultatet for hvert av kallene under (der `(/)` er desimal divisjon, for eksempel, `(/) 1 4 = 1/4 = 0.25` og `(/) 4 1 = 4/1 = 4.0`.)

  - a) `foldr (/) 1 [2,4] =`
  - b) `foldl (/) 1 [2,4] =`
  - c) `foldr (-) 9 [4,3,2] =`
  - d) `foldl (-) 9 [4,3,2] =`
-}




{-
  ## 2 Sortering (10%)
-}




{-
  **2.1.** Definer en rekursiv funksjon `ins::Int->[Int]->[Int]` som innsetter et heltall i riktig posisjon i en sortert liste av heltall, f.eks., `ins 4 [1,2,7,9] = [1,2,4,7,9]`.
-}




{-
  **2.2.** Bruk `ins` for å definere en rekursiv funksjon `isort::[Int]->[Int]` som sorterer en liste med heltall ved "innstikk sorterting" (insertion sort), dvs. slik at tom liste betraktes som sortert, mens en ikke-tom liste sorteres ved å sette dens hode inn i riktig posisjon i listen som resulterer fra sortering av dens hale.
-}




{-
  ## 3 Halerekursjon (10%)

  Definer en halerekursiv funksjon `duh` (og evt. hjelpefunksjoner) som returnerer det samme resultatet som følgende funksjonen `dup`, dvs. slik at for hver liste `xs`: `duh xs = dup xs`.

  ```haskell
  dup [] = ([],[])
  dup (x:xs) = let (as,bs) = dup xs in (x:as,x:bs).
  ```
-}




{-
  ## 4 Prefiksuttrykk (55%)

  Oppgaven bruker definisjonen: `data Exp = Val Int | Pl Exp Exp | Ml Exp Exp`.
-}




{-
  **4.1.** Definer funksjoner (helst som instanser av én generisk funksjon):

  ```haskell
  eval :: Exp -> Int
  ints :: Exp -> [Int].
  ```

  `eval` evaluerer `Exp` (tolket som et aritmetisk prefiks uttrykk, med `Pl` tolket som `+` og `Ml` som `*`) til dets heltallsverdi; `ints` gir listen med `Int` som forekommer i uttrykket. F.eks.:

  ```haskell
  eval (Pl (Val 7) (Ml (Val 9) (Val 3))) = 34       -- tilsv. + 7 * 9 3, dvs., 7+(9*3).
  ints (Pl (Val 7) (Ml (Val 9) (Pl (Val 7) (Val 3)))) = [7,9,7,3]
  ```
-}




{-
  **4.2.** Definer funksjoner (`vis` bør helst være en instans av generisk funksjon fra 4.1.):

  ```haskell
  vis :: Exp -> String
  visE :: [Exp] -> IO().
  ```

  Strengen returnert av `vis` gir argumentet i infiks notasjon og brukes i punkt b) under for å definere `visE`, som viser en liste av `Exp` på skjermen slik at

  - a) hvert uttrykk fra listen kommer i en ny linje,
  - b) skrevet i infiks notasjon, der hver operator med dens argumenter står i paranteser,
  - c) og er etterfulgt av tegnet '`=`' med verdien til hvilken uttrykket evalueres, f.eks.:

  ```
  > visE [Pl(Val 1)(Ml(Val 2)(Val 3)), Pl(Ml(Val 1)(Val 2))(Val 3), Val 177,
          Ml(Val 1)(Pl(Val 2)(Val 3)), Ml(Pl(Val 1)(Val 2))(Ml(Val 3)(Val 4))]
  (1+(2*3)) = 7
  ((1*2)+3) = 5
  177 = 177
  (1*(2+3)) = 5
  ((1+2)*3*4) = 36
  ```
-}




{-
  **4.3.** Definer en funksjon `split::[a]->[([a],[a])]` som returnerer alle oppdelingene av listen i to ikke-tomme lister, hvis konkatenering gir den opprinnelige listen, f.eks.:

  ```haskell
  split [1,2,3,4] = [([1],[2,3,4]),([1,2],[3,4]),([1,2,3],[4])]
  split "ab" = [("a","b")]
  split "abc" = [("a","bc"),("ab","c")]
  ```
-}




{-
  **4.4.** Bruk `split` for å definere funksjon `allExp::[Int]->[Exp]` som returnerer en liste med alle uttrykk, for hvilke `ints` gir argumentlisten, dvs. `allExp xs` returnerer liste med alle `e::Exp` slik at `ints e = xs`. F.eks.,

  ```haskell
  allExp [1,2] = [Pl(Val 1)(Val 2), Ml(Val 1)(Val 2)], tilsvarende [1+2,1*2]
  allExp [1,2,3] = listen med Exp tislvarende
         [1+(2+3),1*(2+3),1+(2*3),1*(2*3),(1+2)+3,(1+2)*3,(1*2)+3,(1*2)*3].
  ```
-}




{-
  **4.5.** Bruk funksjoner over for å definere en funksjon `sol::[Int]->Int->[Exp]` som returnerer alle uttrykk, for hvilke `ints` gir det første argumentet og `eval` det andre, dvs., `sol xs v` gir en liste med alle `e::Exp` slik at `ints e = xs` og `eval e = v`. F.eks.,

  ```haskell
  sol [1,2,3] 5 = [Ml(Val 1)(Pl(Val 2)(Val 3)),Pl(Ml(Val 1)(Val 2))(Val 3)],
  ```

  tilsvarende `[(1*(2+3),(1*2)+3)]`, og

  ```haskell
  sol [1,2,3] 6 = [Pl(Val 1)(Pl(Val 2)(Val 3)),Ml(Val 1)(Ml(Val 2)(Val 3)),
                   Pl(Pl(Val 1)(Val 2))(Val 3),Ml(Ml(Val 1)(Val 2))(Val 3)]
  ```

  tilsvarende `[1+(2+3),1*(2*3),(1+2)+3,(1*2)*3]`.
-}




{-
  ## 5 Korrekthet (15%)

  Gitt definisjoner:

  ```haskell
  p1. [] ++ ys = ys
  p2. (x:xs) ++ ys = x : (xs ++ ys)
  c1. concat [] =[]
  c2. concat (xs:xss) = xs ++ concat xss.
  ```
-}




{-
  **5.1.** Angi typer til funksjonene `(++)` og `concat`.
-}




{-
  **5.2.** Bevis ved induksjon at for alle argumenter `xss` og `yss` av rett type:

  `concat (xss ++ yss) = (concat xss) ++ (concat yss)`.

  *Lykke til!* — Michal Walicki
-}
