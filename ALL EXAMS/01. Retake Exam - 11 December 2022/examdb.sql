CREATE DATABASE airlinedb;
USE airlinedb;

-- 01. Table Design

CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE airplanes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL UNIQUE,
    passengers_capacity INT NOT NULL,
    tank_capacity DECIMAL(19 , 2 ) NOT NULL,
    cost DECIMAL(19 , 2 ) NOT NULL
);

CREATE TABLE passengers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    country_id INT NOT NULL,
    FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

CREATE TABLE flights (
    id INT PRIMARY KEY AUTO_INCREMENT,
    flight_code VARCHAR(30) NOT NULL UNIQUE,
    departure_country INT NOT NULL,
    destination_country INT NOT NULL,
    airplane_id INT NOT NULL,
    has_delay BOOLEAN,
    departure DATETIME,
    FOREIGN KEY (departure_country)
        REFERENCES countries (id),
    FOREIGN KEY (destination_country)
        REFERENCES countries (id),
    FOREIGN KEY (airplane_id)
        REFERENCES airplanes (id)
);

CREATE TABLE flights_passengers (
    flight_id INT,
    passenger_id INT,
    FOREIGN KEY (flight_id)
        REFERENCES flights (id),
    FOREIGN KEY (passenger_id)
        REFERENCES passengers (id)
);



-- 02. Insert

INSERT INTO airplanes(model, passengers_capacity, tank_capacity, cost) 
SELECT 
CONCAT(REVERSE(p.first_name), '797') AS model,
CHAR_LENGTH(p.last_name) * 17 AS passengers_capacity,
p.id * 790 AS tank_capacity,
CHAR_LENGTH(p.first_name) * 50.6 AS cost
FROM passengers AS p
WHERE p.id <= 5;


-- 03. Update

UPDATE flights 
SET 
    airplane_id = airplane_id + 1
WHERE
    departure_country = (SELECT 
            id
        FROM
            countries
        WHERE
            name = 'Armenia');

-- 04. Delete

DELETE FROM flights 
WHERE
    id NOT IN (SELECT DISTINCT
        flight_id
    FROM
        flights_passengers);
        
        
-- 05. Airplanes

SELECT 
    id, model, passengers_capacity, tank_capacity, cost
FROM
    airplanes
ORDER BY cost DESC , id DESC;

-- 06. Flights from 2022

SELECT 
    flight_code, departure_country, airplane_id, departure
FROM
    flights
WHERE
    YEAR(departure) = 2022
ORDER BY airplane_id , flight_code
LIMIT 20;


-- 07. Private flights

SELECT 
    UPPER(CONCAT(LEFT(p.last_name, 2), p.country_id)) AS `flight_code`,
    CONCAT(p.first_name, ' ', p.last_name) AS `full_name`,
    country_id
FROM
    passengers AS p
        LEFT JOIN
    flights_passengers AS fp ON fp.passenger_id = p.id
WHERE
    fp.flight_id IS NULL
ORDER BY country_id;


-- 08. Leading destinations

SELECT 
    c.name,
    c.currency,
    COUNT(fp.passenger_id) AS `booked_tickets`
FROM
    countries AS c
        JOIN
    flights AS f ON f.destination_country = c.id
        JOIN
    flights_passengers AS fp ON f.id = fp.flight_id
GROUP BY c.name
HAVING `booked_tickets` >= 20
ORDER BY `booked_tickets` DESC;


-- 09. Parts of the day

SELECT 
    flight_code,
    departure,
    CASE
        WHEN HOUR(departure) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN HOUR(departure) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(departure) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS 'day_part'
FROM
    flights
ORDER BY flight_code DESC;


-- 10. Number of flights
DELIMITER $

CREATE FUNCTION udf_count_flights_from_country(country VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN 
RETURN(
SELECT COUNT(*) 
FROM flights f 
JOIN countries c ON f.departure_country = c.id
WHERE c.name = country
);
END $


-- 11. Delay flight
DELIMITER $

CREATE PROCEDURE udp_delay_flight(IN `code` VARCHAR(50))
BEGIN
UPDATE flights 
SET has_delay = true, departure = DATE_ADD(departure, INTERVAL 30 MINUTE)
WHERE flight_code = `code`; 
END $

SELECT departure from flights;
