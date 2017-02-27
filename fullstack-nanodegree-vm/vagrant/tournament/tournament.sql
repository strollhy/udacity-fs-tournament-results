-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


CREATE TABLE players (id SERIAL PRIMARY KEY, name TEXT);
CREATE TABLE matches (id SERIAL PRIMARY KEY, winner INTEGER REFERENCES players (id), loser INTEGER REFERENCES players (id));

CREATE VIEW win_totals AS
    SELECT players.id, COUNT(winner) AS wins FROM players, matches
    WHERE players.id=matches.winner GROUP BY players.id ORDER BY wins DESC;

CREATE VIEW match_totals AS
    SELECT players.id, COUNT(winner) AS total FROM players
    LEFT JOIN matches
    ON players.id=matches.winner OR players.id=matches.loser GROUP BY players.id;

CREATE VIEW standings AS
    SELECT players.id, players.name, coalesce(wins,0) AS wins, total FROM players
    LEFT JOIN win_totals ON win_totals.id = players.id
    LEFT JOIN match_totals ON match_totals.id = players.id
    ORDER BY wins DESC;
