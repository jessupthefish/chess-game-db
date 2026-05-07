# Chess Game Database

A web application for browsing and searching a database of master-level chess games. Built as a database design project, starting from an ER model in Chen notation and mapped to a relational schema.

**Live site:** https://YOUR_USERNAME.github.io/chess-game-db/

## About

This project stores 147 real over-the-board chess games from events like the World Chess Championship, Tata Steel Masters, Candidates Tournament, and more. Users can search and filter games by player, opening, or result, view player statistics, and browse curated collections.

The data comes from public PGN archives (PGN Mentor, TWIC) and covers players from Paul Morphy (1858) to Gukesh Dommaraju (2024).

## Database Design

The database was designed using the ER modeling process from Elmasri & Navathe:

1. **Requirements analysis** — identified what data to store and the rules governing it
2. **Conceptual design** — built an ER diagram in Chen notation with 5 entities and 5 relationships
3. **Logical design** — mapped the ER model to 6 relational tables using the standard mapping steps

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

## How to Run Locally

Just open `index.html` in a browser. No server or install needed — all data and logic is embedded in a single file.

## Tech Stack

- HTML / CSS / JavaScript (vanilla, no frameworks)
- Data embedded as JSON, rendered client-side
- Hosted on GitHub Pages
