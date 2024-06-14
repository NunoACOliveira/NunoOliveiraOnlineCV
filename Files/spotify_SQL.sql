-- This is a projetct on Spofify Songs

-- Take a look at the data
SELECT * 
FROM popular_spotify_songs
LIMIT 500;

-- 1. Create a table to work on and keep the original data

DROP TABLE popular_spotify_songs_staging;

CREATE TABLE popular_spotify_songs_staging
LIKE popular_spotify_songs;

INSERT popular_spotify_songs_staging
SELECT * 
FROM popular_spotify_songs;

SELECT * 
FROM popular_spotify_songs_staging
LIMIT 500;

-- Rename the track name column

ALTER TABLE popular_spotify_songs_staging CHANGE ï»¿track_name track_name text;

-- 2. Check for duplicates and remove them

WITH duplicate_cte AS
(
	SELECT *, 
	ROW_NUMBER() OVER(
		partition by track_name, `artist(s)_name`, released_year, released_month, released_day
			) as row_num
	FROM popular_spotify_songs_staging
)
SELECT * 						
FROM duplicate_cte
where row_num > 1;

-- we get 3 results with the same name, artist and release date, bellow we check them to see if they are truly duplicates and realize they aren't

SELECT * 
from popular_spotify_songs_staging 
where track_name = "Take My Breath";


-- Divide the % values by 100 in order to turn them into actual % later in powerbi
	-- First change the column type from int to double
    
ALTER TABLE popular_spotify_songs_staging
MODIFY COLUMN `danceability_%` DOUBLE,
MODIFY COLUMN `valence_%` DOUBLE,
MODIFY COLUMN `energy_%` DOUBLE,
MODIFY COLUMN `acousticness_%` DOUBLE,
MODIFY COLUMN `instrumentalness_%` DOUBLE,
MODIFY COLUMN `liveness_%` DOUBLE,
MODIFY COLUMN `speechiness_%` DOUBLE;

UPDATE popular_spotify_songs_staging
SET `danceability_%` = `danceability_%`/100,
	`valence_%` = `valence_%`/100, 
    `energy_%` = `energy_%`/100,
    `acousticness_%` = `acousticness_%` / 100,
    `instrumentalness_%` = `instrumentalness_%`/100,
    `liveness_%` = `liveness_%`/100,
    `speechiness_%` = `speechiness_%`/100;

    
    


