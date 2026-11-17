module Ovelse_01 where
import Data.Char

{-
  # Øvingssett 1: listefunksjoner, halerekursjon og enkel fold

  Skrevet i stilen til del 1 og 2 i eksamenssettene. Dette er ikke en ekte
  eksamen. Samme regler som på eksamen:

  - Programmer og angi typen til alle hjelpefunksjoner som du selv innfører.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de
    trenges i andre delproblemer.
-}

{-
  ## A  Programmer følgende funksjoner

  (A.1–A.3 bygger på hverandre, slik som i 2024konte del 1.)
-}

{-
  **A.1.** `fjernLike :: Eq a => a -> [a] -> [a]` fjerner alle forekomster av
  et gitt element fra en liste, f.eks.:

  ```haskell
  fjernLike 'a' "banana"   = "bnn"
  fjernLike 3 [3,1,3,2]    = [1,2]
  ```
-}

fjernLike :: Eq a => a -> [a] -> [a]
fjernLike _ [] = []
fjernLike n (x:xs)
  | x == n = fjernLike n xs
  | otherwise = x : fjernLike n xs


{-
  **A.2.** `unike :: Eq a => [a] -> [a]` beholder bare den første forekomsten
  av hvert element, f.eks.:

  ```haskell
  unike "banana"       = "ban"
  unike [3,1,3,2,1]    = [3,1,2]
  ```
-}

unike :: Eq a => [a] -> [a]
unike [] = []
unike (x:xs) = x : unike (fjernLike x xs)


{-
  **A.3.** `forekomster :: Eq a => [a] -> [(a,Int)]` teller hvor mange ganger
  hvert element forekommer i hele listen (ikke bare sammenhengende, slik som
  `lkode`). Elementene kommer i rekkefølgen de først dukker opp, f.eks.:

  ```haskell
  forekomster "banana"       = [('b',1),('a',3),('n',2)]
  forekomster [3,1,3,2,1]    = [(3,2),(1,2),(2,1)]
  ```
-}

forekomster :: Eq a => [a] -> [(a, Int)]
forekomster [] = []
forekomster xs = [(x, length (filter (== x) xs)) | x <- unike xs]

antallStore :: String -> Int
antallStore xs = length (filter isUpper xs)

{-
  **A.4.** `splittPaa :: Eq a => a -> [a] -> [[a]]` deler en liste opp i
  biter ved hver forekomst av et skilletegn. Skilletegnet selv blir borte, og
  to skilletegn etter hverandre gir en tom bit, f.eks.:

  ```haskell
  splittPaa ',' "ab,c,,d"      = ["ab","c","","d"]
  splittPaa ' ' "hei på deg"   = ["hei","på","deg"]
  splittPaa ',' ""             = [""]
  ```
-}

splittPaa :: Eq a => a -> [a] -> [[a]]
splittPaa _ [] = [[]]
splittPaa s (x:xs)
  | x == s = [] : (first : rest)
  | otherwise = (x : first) : rest
  where (first:rest) = splittPaa s xs


{-
  ## B  Halerekursjon

  For hver funksjon: er definisjonen halerekursiv? Begrunn svaret. Hvis den
  ikke er det, gi en halerekursiv definisjon.
-}

{-
  **B.1.**

  ```haskell
  lengde []     = 0
  lengde (_:xs) = 1 + lengde xs
  ```
-}

-- Den er ikke halerekursiv, fordi 1 + settes i kø mens det venter på rekursjonen til å bli fullført

lengde :: [a] -> Int
lengde [] = 0
lengde (_:xs) = lengde' 1 xs

lengde' :: Int -> [a] -> Int
lengde' acc [] = acc
lengde' acc (_:xs) = lengde' (acc + 1) xs


{-
  **B.2.** For heltall `b` og ikke-negativ `n`:

  ```haskell
  potens b 0 = 1
  potens b n = b * potens b (n-1)
  ```
-}

-- Den er ikke halerekursiv, fordi det ytterste uttrykket b * venter på resultatet til potens kallet

potens :: Int -> Int -> Int
potens b n = potens' b n 1

potens' :: Int -> Int -> Int -> Int
potens' _ 0 acc = acc
potens' b n acc = potens' b (n - 1) (acc * b) 


{-
  **B.3.** For en ikke-tom liste:

  ```haskell
  siste [x]    = x
  siste (_:xs) = siste xs
  ```
-}

-- Ja denne er halerekursiv, siden det eneste og siste kallet er rekursjonen


{-
  ## C  Enkel fold

  Bruk `foldr` eller `foldl` som angitt. Ingen eksplisitt rekursjon.
-}

{-
  **C.1.** Definer `produkt :: [Int] -> Int` med `foldr`, f.eks.:

  ```haskell
  produkt [2,3,4]   = 24
  produkt []        = 1
  ```
-}

produkt :: [Int] -> Int
produkt = foldr (*) 1


{-
  **C.2.** Definer `antall :: (a -> Bool) -> [a] -> Int` med `foldr`. Den
  teller hvor mange elementer som oppfyller predikatet, f.eks.:

  ```haskell
  antall even [1,2,3,4,6]      = 3
  antall (== 'a') "banana"     = 3
  ```
-}

antall :: (a -> Bool) -> [a] -> Int
antall p xs = foldr (\x acc -> if p x then acc + 1 else acc) 0 xs


{-
  **C.3.** Definer `snu :: [a] -> [a]` med `foldl`, f.eks.:

  ```haskell
  snu [1,2,3]   = [3,2,1]
  snu "hei"     = "ieh"
  ```
-}




{-
  **C.4.** Definer `alle :: (a -> Bool) -> [a] -> Bool` med `foldr`. Den gir
  `True` hvis alle elementene oppfyller predikatet, f.eks.:

  ```haskell
  alle even [2,4,6]   = True
  alle even [2,3,6]   = False
  alle even []        = True
  ```
-}




{-
  **C.5.** Velg riktige svar (uten GHCi først):

  `foldr (\x acc -> x - acc) 0 [1,2,3]` gir:
  (a) `-6`   (b) `0`   (c) `2`   (d) `6`

  `foldl (-) 0 [1,2,3]` gir:
  (a) `-6`   (b) `0`   (c) `2`   (d) `6`

  Skriv utregningen med parenteser for begge.
-}
