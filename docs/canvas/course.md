# INF122 26H / Funksjonell programmering

Mirrored from Mitt UiB by `src/canvas_sync.py`. **Do not edit by hand** —
re-run the script instead. Per-week records are in `weeks/*/README.md`.

Course: `INF122` (id 59171)

## Canvas sections

| Section | Link |
|---|---|
| Heim | /courses/59171 |
| Kunngjeringar | /courses/59171/announcements |
| Diskusjonar | /courses/59171/discussion_topics |
| Vurderingar | /courses/59171/grades |
| Personar | /courses/59171/users |
| Filer | /courses/59171/files |
| Emneoversikt | /courses/59171/assignments/syllabus |
| Panopto Video | /courses/59171/external_tools/1045 |
| Litteraturliste | /courses/59171/external_tools/1334 |

## Modules

### Kom igang med Haskell

- **Installasjonsguide** — Page
- **GHCi** — Page
- **Læreboken** — Page

## Pages

### INF122

*Module: Front page · updated 2026-08-10T04:33:22Z · not week-specific*

Velkommen til INF122 – Funksjonell programmering

På første forelesning, mandag 17. august, kl 8:15 (timeplan), får du informasjon om krav og foreløpig plan, samt en introduksjon til Haskell (samlet på transparenter for første forelesning - under Filer/forelesningsnotater). Eneste faglige kravet for å kunne gå opp til eksamen blir å få godkjent (uten karakter) én stor obligatorisk oppgave mot slutten av semesteret.

Gruppetimene begynner samme uke som forelesningene. På første gruppetime kan du få hjelp til å installere haskellkompilatoren og begynne på de første ukesoppgavene.

Hold deg oppdatert på kursets kunngjøringer på MittUiB .

Introduksjon til funksjonell programmering

Sett av ti minutter for å få en kjapp introduksjon - gitt av Håkon Gylterud - til hovedforskjeller mellom imperativ og funksjonell programmering:

Emneansvarlig

Hvis du har spørsmål om kursets innhold kan du ta kontakt direkte via e-post med emneansvarlig: Michal.Walicki@uib.no.

**Links:**
- https://www4.uib.no/studier/emner/inf122
- https://www.uib.no/personer/H%C3%A5kon.Robbestad.Gylterud

### Installasjonsguide

*Module: Kom igang med Haskell · updated 2026-06-22T18:08:22Z · not week-specific*

For å gjøre oppgaver i kurset må du installere GHC (Glasgow Haskell Compiler) og Cabal på datamaskinen din (hvis du ikke allerede har disse installert). Vi anbefaler å bruke GHCup for å installere disse to programmene. GHC er den mest brukte haskellkompilatoren og Cabal er et pakkesystem vi skal bruke i de større obligatoriske oppgavene.

Installasjon via GHCup

GHCup finner du her: https://www.haskell.org/ghcup. Følg instruksjonene for operativsystemet på din maskin og installér GHCup med GHC og Cabal. (Hvis du foretrekker en annen måte å installere GHC og Cabal på din maskin kan du selvsagt bruke den.)

Redigeringsprogram for kildekode

Du kan skrive programmene dine i det tekstredigeringsprogrammet/IDE som passer deg best (Vim, Emacs, Kate, VSCode…).

Noen IDEer støtter Language Server Protocol (LSP), som implementeres av Haskell Language Server (HLS), som gir ekstra funksjonalitet til IDEet man skriver koden i. HLS kan installeres med GHCup.

Hvis du vil bruke Emacs kan du installere lsp-mode, lsp-ui, lsp-haskell pakkene for å bruke HLS. Se dokumentasjonen til HLS.

Hvis du vil bruke VSCode kan du bruke følgende Haskell-plugin: https://marketplace.visualstudio.com/items?itemName=haskell.haskell. Velg så å bruke HLS via GHCup i instillingene til pluginet i VSCode.

**Links:**
- https://www.haskell.org/cabal
- https://www.haskell.org/ghcup
- https://haskell-language-server.readthedocs.io/en/latest/configuration.html
- https://haskell-language-server.readthedocs.io/en/latest/configuration.html#configuring-your-editor
- https://marketplace.visualstudio.com/items?itemName=haskell.haskell

### GHCi

*Module: Kom igang med Haskell · updated 2026-08-08T09:40:28Z · not week-specific*

Øvingsoppgaver i GHCi

Etter at du har sett videoen ovenfor, bruk GHCi til å løse oppgavene nedenfor.

  - Regn ut 331·(513+49).

  - Regn ut summen av alle oddetall fra 1 til 100.

  - Definér en funksjon, med navn oddSum, som regner ut summen av oddetall fra 1 til n for et vilkårlig heltall n.

### Læreboken

*Module: Kom igang med Haskell · updated 2026-08-08T09:42:25Z · not week-specific*

Læreboken i dette kurset er «Programming in Haskell» av Graham Hutton.

Broken gir en konsis introduksjon til, og gode eksempler på Haskellprogrammering.

Første uke er kapitel 1 og 2 pensum. Les igjennom disse kapitlene og gjør oppgavene.

## Files area

| File | Folder | Filed as | Updated |
|---|---|---|---|
| 1QuickCheck.pdf | course files/forelesningsnotater | `weeks/uke34/slides/` | 2026-08-18 |
| 1krav-plan+intro.pdf | course files/forelesningsnotater | `weeks/uke34/slides/` | 2026-08-16 |
| 2typer-handout.pdf | course files/forelesningsnotater | `weeks/uke35/slides/` | 2026-08-24 |
| 3-func+list-handoutpdf.pdf | course files/forelesningsnotater | `weeks/uke36/slides/` | 2026-08-25 |
| uke1.txt | course files/oppgaver | `weeks/uke34/exercises/` | 2026-08-18 |
| uke2.txt | course files/oppgaver | `weeks/uke35/exercises/` | 2026-08-25 |

## Announcements

### Oppgaver uke2.txt

*Posted 2026-08-25T14:13:20Z*

er tilgjengelige fra katalogen Filer/oppgaver/...

### Ukens oppgaver

*Posted 2026-08-18T14:30:27Z*

er tilgjengelige fra katalogen Filer/oppgaver/...

### Which cord? Dis cord!

*Posted 2026-08-18T09:56:29Z*

Dette faget har nå en Discord, som kan brukes for å samarbeide og diskutere om kurset: https://discord.gg/Dh2DwgJER.

Den er drevet av gruppelederene, og virker som et supplement til kurset. Det er ikke obligatorisk å bli med, alle kunngjøringer kommer fortsatt til å gå over Mitt UiB eller e-post.

### Viktig info om grupper

*Posted 2026-08-16T07:17:20Z*

Grupper blir organisert i en tutorial-stil, hvor man diskuterer løsningsforsøk dere kommer med, evt. utvikler løsninger sammen. Du velger mellom to alternative opplegg ved å melde deg til én av følgende gruppe:

1) torsdag 10:15-12, fredag 10:15-12 eller fredag 12:15-14 - det blir vanlige/større diskusjons- og/eller arbeidsgrupper (meld deg via mitt-uib).

2) mindre (2-5 pers) og kortere (opptil 30min) grupper skal holdes på et tidspunkt som du avtaler direkte med gruppeleder ved å kontakte Johannes.Skivdal@student.uib.no eller James.Hobson@uib.no per epost eller discord (James’ gruppe blir på engelsk). Er dere en gruppe, meld dere helst sammen (si hvem som er med i gruppen).

Gruppedeltakelse er ikke obligatorisk, men det er verdt å merke at kursets historikk viser en ekstrem korrelasjon mellom dem som deltar i grupper og dem som består eksamen.

## Assignments

*None published yet.*

## Not readable

Blocked by Canvas permissions or missing — not script failures:

- page index: HTTP 404
