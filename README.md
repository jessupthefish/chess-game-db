# Chess Game Database

A web application for browsing and searching a database of master-level chess games. Built as a database design project, starting from an ER model and mapped to a relational schema.

**Live site:** https://jessupthefish.github.io/chess-game-db/

## About

This project stores 147 real over-the-board chess games from events like the World Chess Championship, Tata Steel Masters, Candidates Tournament, and more. Users can search and filter games by player, opening, or result, view player statistics, and browse curated collections.

The data comes from public PGN archives and covers players from Paul Morphy to Gukesh Dommaraju.

### ER-to-Relational Mapping

| Table | Mapping Step | What It Stores |
|-------|-------------|----------------|
| Player | Step 1 — regular entity | 45 players with name, title, rating, country |
| Event | Step 1 — regular entity | 20 tournaments and matches |
| Opening | Step 1 — regular entity (natural key: ECO code) | 40 chess openings |
| Collection | Step 1 — regular entity | 8 curated game groupings |
| Game | Step 4 — 1:N FKs added | 147 games with FKs to Player (x2), Event, Opening |
| Game_Collection | Step 5 — M:N junction table | Links between games and collections |

The Game table has four foreign keys from four separate 1:N relationships: `white_player_id` and `black_player_id` (both referencing Player), `event_id`, and `eco_code`. The Game_Collection junction table resolves the many-to-many relationship between Game and Collection.

A MySQL schema file (`schema_mysql.sql`) is included in the repo.
