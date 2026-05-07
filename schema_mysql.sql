-- ============================================================
-- Chess Game Database - MySQL Schema
-- ER-to-Relational Mapping Implementation
-- ============================================================

DROP DATABASE IF EXISTS chess_game_db;
CREATE DATABASE chess_game_db;
USE chess_game_db;

-- ============================================================
-- Step 1: Map Regular Entity Types
-- Each entity from the ER model becomes its own table.
-- ============================================================

-- PLAYER entity
-- Mapping: Regular entity type with simple attributes.
-- player_id is the primary key from the ER diagram.
CREATE TABLE Player (
    player_id   INT             AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50)     NOT NULL,
    last_name   VARCHAR(50)     NOT NULL,
    title       ENUM('GM','IM','FM','NM','CM','WGM','WIM','WFM','none') DEFAULT 'none',
    rating      INT,
    country     VARCHAR(50)
);

-- EVENT entity
-- Mapping: Regular entity type with simple attributes.
-- event_id is the primary key.
CREATE TABLE Event (
    event_id    INT             AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(200)    NOT NULL,
    city        VARCHAR(100),
    country     VARCHAR(50),
    start_date  DATE,
    end_date    DATE,
    type        ENUM('tournament','match','exhibition') DEFAULT 'tournament'
);

-- OPENING entity
-- Mapping: Regular entity type. eco_code is a natural key
-- (ECO codes are unique identifiers in chess).
CREATE TABLE Opening (
    eco_code    VARCHAR(5)      PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    family      VARCHAR(50)
);

-- COLLECTION entity
-- Mapping: Regular entity type with simple attributes.
CREATE TABLE Collection (
    collection_id   INT             AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,
    description     TEXT
);

-- ============================================================
-- Step 4: Map Binary 1:N Relationships
-- For each 1:N relationship, add the PK of the 1-side
-- as a FK in the N-side table.
-- ============================================================

-- GAME entity + all 1:N foreign keys
-- Mapping:
--   PLAYS_AS_WHITE (Player 1:N Game) -> white_player_id FK
--   PLAYS_AS_BLACK (Player 1:N Game) -> black_player_id FK
--   HELD_AT        (Event 1:N Game)  -> event_id FK
--   USES_OPENING   (Opening 1:N Game) -> eco_code FK
CREATE TABLE Game (
    game_id         INT             AUTO_INCREMENT PRIMARY KEY,
    white_player_id INT             NOT NULL,
    black_player_id INT             NOT NULL,
    event_id        INT,
    eco_code        VARCHAR(5),
    result          ENUM('1-0','0-1','1/2-1/2') NOT NULL,
    date            DATE,
    moves           TEXT,
    round           VARCHAR(10),
    time_control    VARCHAR(20),
    FOREIGN KEY (white_player_id) REFERENCES Player(player_id),
    FOREIGN KEY (black_player_id) REFERENCES Player(player_id),
    FOREIGN KEY (event_id)        REFERENCES Event(event_id),
    FOREIGN KEY (eco_code)        REFERENCES Opening(eco_code)
);

-- ============================================================
-- Step 5: Map Binary M:N Relationships
-- Create a junction table with composite PK from both
-- participating entity PKs.
-- ============================================================

-- IN_COLLECTION (Game M:N Collection) -> junction table
-- Mapping: Composite PK of (game_id, collection_id).
-- Both columns are FKs referencing their parent tables.
CREATE TABLE Game_Collection (
    game_id         INT NOT NULL,
    collection_id   INT NOT NULL,
    PRIMARY KEY (game_id, collection_id),
    FOREIGN KEY (game_id)       REFERENCES Game(game_id),
    FOREIGN KEY (collection_id) REFERENCES Collection(collection_id)
);

-- ============================================================
-- Sample Data
-- ============================================================

-- Players
INSERT INTO Player (first_name, last_name, title, rating, country) VALUES
('Magnus',    'Carlsen',      'GM',   2830, 'Norway'),
('Hikaru',    'Nakamura',     'GM',   2788, 'USA'),
('Fabiano',   'Caruana',      'GM',   2796, 'USA'),
('Ian',       'Nepomniachtchi','GM',  2771, 'Russia'),
('Ding',      'Liren',        'GM',   2780, 'China'),
('Garry',     'Kasparov',     'GM',   2851, 'Russia'),
('Bobby',     'Fischer',      'GM',   2785, 'USA'),
('Mikhail',   'Tal',          'GM',   2620, 'Latvia'),
('Viswanathan','Anand',       'GM',   2751, 'India'),
('Alireza',   'Firouzja',     'GM',   2760, 'France');

-- Events
INSERT INTO Event (name, city, country, start_date, end_date, type) VALUES
('Tata Steel Masters 2024',        'Wijk aan Zee', 'Netherlands', '2024-01-13', '2024-01-28', 'tournament'),
('Candidates Tournament 2024',     'Toronto',      'Canada',      '2024-04-03', '2024-04-22', 'tournament'),
('World Chess Championship 2023',  'Astana',       'Kazakhstan',  '2023-04-09', '2023-04-30', 'match'),
('Sinquefield Cup 2023',           'St. Louis',    'USA',         '2023-08-17', '2023-08-28', 'tournament'),
('Norway Chess 2024',              'Stavanger',    'Norway',      '2024-05-27', '2024-06-07', 'tournament');

-- Openings
INSERT INTO Opening (eco_code, name, family) VALUES
('C44', 'Scotch Game',                     'King Pawn'),
('C45', 'Scotch Gambit',                   'King Pawn'),
('B90', 'Sicilian Najdorf',                'Sicilian'),
('D37', 'Queens Gambit Declined',           'Queen Pawn'),
('E20', 'Nimzo-Indian Defense',             'Indian'),
('C50', 'Italian Game',                     'King Pawn'),
('B12', 'Caro-Kann Defense',                'Semi-Open'),
('A20', 'English Opening',                  'Flank'),
('C65', 'Ruy Lopez Berlin',                 'King Pawn'),
('D06', 'Queens Gambit',                    'Queen Pawn');

-- Games
INSERT INTO Game (white_player_id, black_player_id, event_id, eco_code, result, date, moves, round, time_control) VALUES
(1, 2, 1, 'C45', '1-0', '2024-01-14', '1. e4 e5 2. Nf3 Nc6 3. d4 exd4 4. Bc4', '1', '90+30'),
(3, 4, 2, 'C65', '1/2-1/2', '2024-04-04', '1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6', '1', '90+30'),
(4, 5, 3, 'D37', '0-1', '2023-04-09', '1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 Be7', '1', '120+30'),
(1, 3, 4, 'B90', '1-0', '2023-08-18', '1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6', '2', '90+30'),
(2, 1, 5, 'E20', '0-1', '2024-05-28', '1. d4 Nf6 2. c4 e6 3. Nc3 Bb4', '1', '120+30'),
(9, 1, 1, 'C50', '0-1', '2024-01-16', '1. e4 e5 2. Nf3 Nc6 3. Bc4 Nf6', '3', '90+30'),
(10, 3, 2, 'B12', '1/2-1/2', '2024-04-06', '1. e4 c6 2. d4 d5 3. e5', '2', '90+30'),
(6, 7, NULL, 'D06', '1-0', '1992-09-02', '1. d4 d5 2. c4', '1', '120+30'),
(8, 6, NULL, 'B90', '1-0', '1960-03-15', '1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6', '1', '150+0'),
(5, 4, 3, 'D37', '1-0', '2023-04-12', '1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 Be7', '5', '120+30');

-- Collections
INSERT INTO Collection (name, description) VALUES
('Carlsen Masterpieces',     'Best games by Magnus Carlsen'),
('Scotch Gambit Study',      'Games featuring the Scotch Gambit and Scotch Game'),
('World Championship Games', 'Games from World Chess Championship matches'),
('Sicilian Najdorf Battles', 'Notable games in the Najdorf Sicilian');

-- Game_Collection (M:N junction)
INSERT INTO Game_Collection (game_id, collection_id) VALUES
(1, 1), (1, 2),       -- Carlsen game, also in Scotch study
(5, 1),                -- Another Carlsen win
(6, 1),                -- Carlsen win
(3, 3), (10, 3),       -- World championship games
(4, 4), (9, 4),        -- Najdorf games
(8, 3);                -- Classic match game
