# Chess Game Database

A web application for browsing and searching the complete history of World Chess Championship games. Built as a database design project, starting from an ER model and mapped to a relational schema.

**Live site:** https://jessupthefish.github.io/chess-game-db/

## About

This database contains 949 real over-the-board games from every classical World Chess Championship match from Steinitz–Zukertort 1886 through Anand–Kramnik 2008, including the PCA-side matches during the 1993–2006 schism. 

Users can search and filter games by player, opening, or result, view player statistics, and browse curated collections grouped by historical era.

### Data source

PGN data from [mainali123/Chess-Dataset](https://github.com/mainali123/Chess-Dataset), which mirrors the World Championship subset of [pgnmentor.com](https://www.pgnmentor.com). ECO opening names from [lichess-org/chess-openings](https://github.com/lichess-org/chess-openings). The FIDE knockout-format championships from 1998–2004 are excluded — those used a 128-player single-elimination format rather than a head-to-head title match, and including their ~2000 qualifier games would have drowned out the actual title matches.

The classical title-match scope means coverage stops at 2008. Modern matches (2010 onward) are not yet in the database.

### ER-to-Relational Mapping

| Table | Mapping Step | What It Stores |
|-------|-------------|----------------|
| Player | Step 1 — regular entity | 35 players with name, title, peak rating, country |
| Event | Step 1 — regular entity | 43 World Championship matches |
| Opening | Step 1 — regular entity (natural key: ECO code) | 279 chess openings |
| Collection | Step 1 — regular entity | 6 thematic groupings |
| Game | Step 4 — 1:N FKs added | 949 games with FKs to Player (x2), Event, Opening |
| Game_Collection | Step 5 — M:N junction table | Links between games and collections |

The Game table has four foreign keys from four separate 1:N relationships: `white_player_id` and `black_player_id` (both referencing Player), `event_id`, and `eco_code`. The Game_Collection junction table resolves the many-to-many relationship between Game and Collection.

A MySQL schema file (`schema_mysql.sql`) is included in the repo and contains all data as INSERT statements.

### Collections

Games are auto-grouped into six thematic collections:

- **Classical Era (1886–1937)** — pre-FIDE matches from Steinitz to Alekhine
- **Soviet Era (1948–1990)** — FIDE matches dominated by Soviet players
- **Schism Era (1993–2005)** — PCA and FIDE titles during the schism
- **Reunification (2006–2008)** — Kramnik–Topalov unification onward
- **Karpov–Kasparov Rivalry** — all five title matches between them (1984–1990)
- **Decisive Games** — every game that didn't end in a draw

