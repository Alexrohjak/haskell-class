module Eksamen_2017 where

{-
  # INF-122 Funksjonell programmering — eksamen 8. desember 2017

  - **Dato:** 8 desember 2017
  - **Tid:** 9:00 – 12:00
  - **Antall sider:** 3
  - **Tillatte hjelpemidler:** Ingen

  - Prosentsatsene angir *kun omtrentlig* vekting ved sensur og forventet tidsforbruk
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Angi typen til enhver funksjon du programmerer.
  - Programmer og forklar alle hjelpefunksjoner som du selv innfører. Din kode skal ikke forutsette andre funksjoner enn de som er tilgjengelige fra standard `Prelude`.
-}

{-
  ## 1 Programmer følgende funksjoner: (25%)
-}




{-
  **1.1.** `harEl::(t->Bool)->[t]->Bool`, slik at `harEl pr xs = True` hvis listen `xs` har et element `x` som tilfredstiller predikatet `pr`, dvs., slik at `pr x = True`, og `False` ellers. F.eks.:

  ```haskell
  harEl (==3) [1,1,2,3,2] = True
  harEl (<3) [1,1,2,3,2] = True
  harEl (>5) [1,1,2,3,2] = False.
  ```
-}




{-
  **1.2.** `el::(t->Bool)->[t]->t`, slik at `el pr xs` returnerer første elementet `x` fra listen `xs` som tilfredstiller predikatet `pr`. Funksjonen antar at et slikt element finnes i listen. F.eks.:

  ```haskell
  el ((=='a').fst) [('b',2),('a',3),('a',4)] = ('a',3)
  el ((>3).snd) [('b',2),('a',3),('a',4)] = ('a',4).
  ```
-}




{-
  **1.3.** `gRep::(t->Bool)->t->[t]->[t]`, slik at `gRep pr y xs` erstatter med `y`, ethvert element `x` fra listen `xs` som tilfredstiller predikatet `pr`. F.eks.:

  ```haskell
  gRep (<'d') 'z' "abcd" = "zzzd"
  gRep (=='a') 'x' "abcbcac" = "xbcbcxc".
  ```
-}




{-
  **1.4.** Vi bruker binære trær med heltall lagret i alle noder (inklusivt blader) definert ved: `data BT = B Int | N BT Int BT`. Programmer følgende funksjoner:

  (a) `elt::BT->Int->Bool`, slik at `elt tr x = True` hvis tallet `x` forekommer i treet `tr`, og `False` ellers, f.eks., `elt (N (B 1) 2 (B 0)) 2 = True` og `elt (B 1) 2 = False`.

  (b) `toL::BT->[Int]`, slik at `toL tr` er en liste med alle tall som forekommer i treet `tr`, f.eks., `toL (N (B 1) 2 (N (B 3) 3 (B 0))) = [1,2,3,3,0]`.

  (c) `dup::BT->Bool`, slik at `dup tr = True` hvis noen tall forekommer (minst) to ganger i treet `tr`, og `False` ellers. For eksempel, `dup (N (B 1) 2 (N (B 3) 5 (B 0))) = False` og `dup (N (B 1) 2 (B 2)) = True`.
-}




{-
  ## 2 Rettede grafer (40%)

  En (rettet) graf er en mengde av noder med kanter som forbinder utvalgte par av noder (i én retning, fra kilde- til målnode). F.eks.: følgende graf `gr` har 5 noder og 6 kanter:

  ```
  a ───► b        gr          noder:      [a, b, c, d, e]
  │    ↗ │                    kanter, KL = [(a, b), (a, c), (b, d), (c, b), (d, c), (d, e)]
  ▼   /  ▼
  c ◄─── d ───► e
  ```

  En graf kan representeres som en *kantliste*, nemlig en liste hvis elementer er alle par av noder tilsvarende kanter. F.eks., representerer kantlisten KL grafen `gr`. (Vi antar at hver node er med i minst én kant, slik at vi ikke representerer noder i tillegg til kanter.) Alternativt, kan grafen representeres som en *naboliste*, nemlig, en liste av par der første elementet er en node, si x, og andre er listen av noder med kanter fra denne noden x. F.eks., er grafen `gr` representert av nabolisten NL = [(a, [b, c]), (b, [d]), (c, [b]), (d, [c, e]), (e, [])].
-}




{-
  **2.1.** Programmer en funksjon `naboL::Eq t => [(t,t)]->[(t,[t])]` som konverterer kantliste representasjon av en graf til dens naboliste, f.eks., `naboL` KL kan gi NL.
-}




{-
  **2.2.** Programmer en invers funksjon `kantL::[(t,[t])]->[(t,t)]` som konverterer naboliste representasjon av en graf til dens kantliste, f.eks., `kantL` NL kan gi KL.
-}




{-
  **2.3.** En *sti* er en liste med noder [x1, x2, ..., xn] slik at hvert par (x1, x2), (x2, x3), ..., (xn−1, xn) er en kant. En *syklus* er en sti som starter og slutter i samme node, dvs. der x1 = xn. (Man følger kanter kun fra kilde til mål, dvs., kun i pilens retning.)

  For resten av denne oppgaven, velg enten en kant- eller en nabolisterepresentasjon. Si hva du har valgt. Valget ditt betegner vi med `??`.

  (a) Programmer en funksjon `naboer::??->t->[t]`, slik at `naboer g x` returnerer listen av alle naboer til noden `x` (alle noder som har en kant fra `x`) i grafen `g`. I grafen `gr` over, `naboer gr a = [b,c]` og `naboer gr e = []`.

  (b) Programmer nå en funksjon `cyc::??->t->[t]`, slik at `cyc g x` returnerer stien tilsvarende en syklus når en slik kan nås ved å starte fra noden `x` i grafen `g`, og tom sti `[]` ellers. F.eks., for grafen `gr` over,

  ```haskell
  cyc gr e = []          -- siden ingen syklus kan nås fra e,
  cyc gr b = [b,d,c,b],
  cyc gr a = [a,b,d,c,b] eller cyc gr a = [a,c,b,d,c].
  ```

  I det siste tilfellet er det opp til deg å bestemme om funksjonen returnerer hele stien fom. noden tom. syklusen, eller bare syklusen (dvs. bare `[b,d,c,b]` eller `[c,b,d,c]`.)

  [[Hint: Det er hovedsaklig korrekthet, og ikke effektivitet, som teller her. Det kan være lurt å programmere en hjelpefunksjon `trav::??->t->...`, slik at `trav gr x...` besøker alle stier utgående fra node `x` i grafen `gr`, uten å gå i en syklus. Den kan ha bruk for et ekstra argument som samler alle noder besøkt på den aktuelle stien.]]
-}




{-
  ## 3 Litt IO (15%)

  Programmer en funksjon (samt alle hjelpefunksjoner) `main::IO ()` som gir brukeren mulighet til å utføre følgende kommandoer:

  - `g` : oppretter en ny, tom graf
  - `k x y` : legger kanten (x,y) til grafen (også hvis node x eller y ikke finnes fra før)
  - `f x y` : fjerner kanten (x,y) fra grafen
  - `s` : viser en vilkårlig syklus i den aktuelle grafen eller tom sti, hvis grafen er asyklisk
  - `q` : avslutter programmet.

  Dersom det har noen betydning, spesifiser hvilken grafrepresentasjon du bruker.
-}




{-
  ## 4 Typeinferens (20%)

  Vi betrakter to følgende uttrykk:

  (a) `\h -> \x -> (h x) h`     og     (b) `\h -> \x -> (h x) x`.

  Et av dem har en type i Haskell, mens det andre har det ikke. Velg det uttrykket som ikke har en type, vis hele typeavledning (så langt den går) og grunnen til at den feiler.

  (Hvis du har tid, vis også avledning av typen for det andre uttrykket.)

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
