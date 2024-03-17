CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    continent VARCHAR(30) NOT NULL,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE actors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    height INT,
    awards INT,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

CREATE TABLE movies_additional_info (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(10 , 2 ) NOT NULL,
    runtime INT NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    budget DECIMAL(10 , 2 ),
    release_date DATE NOT NULL,
    has_subtitles BOOLEAN,
    description TEXT
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(70) NOT NULL UNIQUE,
    country_id INT NOT NULL,
    movie_info_id INT NOT NULL UNIQUE,
    FOREIGN KEY (country_id)
        REFERENCES countries (id),
    FOREIGN KEY (movie_info_id)
        REFERENCES movies_additional_info (id)
);

CREATE TABLE movies_actors (
    movie_id INT,
    actor_id INT,
    FOREIGN KEY (movie_id)
        REFERENCES movies (id),
    FOREIGN KEY (actor_id)
        REFERENCES actors (id)
);

CREATE TABLE genres_movies (
genre_id INT,
movie_id INT,
  FOREIGN KEY (genre_id)
        REFERENCES genres (id),
    FOREIGN KEY (movie_id)
        REFERENCES movies (id)
);

INSERT INTO actors(first_name, last_name, birthdate, height, awards, country_id)
SELECT 
REVERSE(a.first_name) AS first_name,
REVERSE(a.last_name) AS last_name,
DATE_SUB(a.birthdate, INTERVAL 2 DAY) AS birthdate,
a.height + 10 AS height,
country_id AS awards,
(SELECT id FROM countries WHERE name = 'Armenia') AS country_id
FROM actors AS a
WHERE a.id <= 10;

UPDATE movies_additional_info 
SET 
    runtime = runtime - 10
WHERE
    id BETWEEN 15 AND 25;


DELETE c FROM countries c
        LEFT JOIN
    movies m ON m.country_id = c.id 
WHERE
    m.country_id IS NULL;

SELECT 
    id, name, continent, currency
FROM
    countries
ORDER BY currency DESC , id;


SELECT 
    md.id, m.title, md.runtime, md.budget, md.release_date
FROM
    movies_additional_info md
        JOIN
    movies m ON m.movie_info_id = md.id
WHERE
    YEAR(md.release_date) BETWEEN 1996 AND 1999
ORDER BY md.runtime , id
LIMIT 20;



SELECT 
    CONCAT(first_name, ' ', last_name) AS `full_name`,
    CONCAT(REVERSE(last_name),
            CHAR_LENGTH(last_name),
            '@cast.com') AS `email`,
    2022 - YEAR(birthdate) AS `age`,
    height
FROM
    actors a
        LEFT JOIN
    movies_actors ma ON a.id = ma.actor_id
WHERE
    ma.movie_id IS NULL
ORDER BY height;



SELECT 
    c.name, COUNT(m.id) AS `movies_count`
FROM
    countries c
        JOIN
    movies m ON c.id = m.country_id
GROUP BY c.name
HAVING `movies_count` >= 7
ORDER BY c.name DESC;



SELECT 
    m.title,
    CASE
        WHEN ma.rating <= 4 THEN 'poor'
        WHEN ma.rating <= 7 THEN 'good'
        WHEN ma.rating > 7 THEN 'excellent'
    END AS `rating`,
    CASE
        WHEN ma.has_subtitles = TRUE THEN 'english'
        ELSE '-'
    END AS `subtitles`,
    ma.budget
FROM
    movies_additional_info AS ma
        JOIN
    movies AS m ON m.movie_info_id = ma.id
ORDER BY ma.budget DESC;





CREATE FUNCTION udf_actor_history_movies_count(`full_name` VARCHAR(50)) 
RETURNS INT
DETERMINISTIC
BEGIN 
RETURN (SELECT COUNT(*)
FROM actors AS a 
JOIN movies_actors AS ma ON a.id = ma.actor_id
JOIN movies AS m ON m.id = ma.movie_id
JOIN genres_movies AS gm ON gm.movie_id = m.id
JOIN genres AS g ON gm.genre_id = g.id
WHERE CONCAT(a.first_name, ' ', last_name) = `full_name` AND g.name = 'History'
);
END




CREATE PROCEDURE udp_award_movie(IN `movie_title` VARCHAR(50)) 
BEGIN 
UPDATE actors AS a
JOIN movies_actors AS ma ON ma.actor_id = a.id
JOIN movies AS m ON ma.movie_id = m.id
SET a.awards = a.awards + 1
WHERE m.title = `movie_title`;
END
