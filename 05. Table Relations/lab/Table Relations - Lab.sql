USE camp;

-- 1. Mountains and Peaks

CREATE TABLE mountains (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50)
);

CREATE TABLE peaks (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
mountain_id INT,
CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (mountain_id)
REFERENCES mountains(id)
);

-- 2. Trip Organization

SELECT 
    driver_id,
    vehicle_type,
    CONCAT(first_name, ' ', last_name) AS `driver_name`
FROM
    campers
        JOIN
    vehicles ON campers.id = vehicles.driver_id;
    
-- 3. SoftUni Hiking 

SELECT 
    starting_point AS `route_staring_point`,
    end_point AS `route_ending_point`,
    leader_id,
    CONCAT(first_name, ' ', last_name) AS `leader_name`
FROM
    campers
        JOIN
    routes ON routes.leader_id = campers.id;
 
 
 -- 4. Delete Mountains
 
 -- 4 Delete Mountains
DROP TABLE `peaks`;
DROP TABLE `mountains`;

CREATE TABLE `mountains`(
    `id`   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50)
);

CREATE TABLE `peaks`
(
    `id`          INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(50),
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountains`
        FOREIGN KEY (`mountain_id`)
            REFERENCES `mountains` (`id`)
            on DELETE CASCADE
);
 

-- 5 Project Management DB*
CREATE DATABASE projcet_management;
USE projcet_management;

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    start_date DATE,
    end_date DATE
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    position VARCHAR(50),
    department VARCHAR(50)
);

CREATE TABLE task (
    id INT PRIMARY KEY AUTO_INCREMENT,
    task_name VARCHAR(50),
    description TEXT,
    deadline DATE
);

CREATE TABLE works_on (
    employee_id INT,
    project_id INT,
    hours_worked INT,
    PRIMARY KEY (employee_id , project_id),
    FOREIGN KEY (employee_id)
        REFERENCES employees (id),
    FOREIGN KEY (project_id)
        REFERENCES projects (id)
);

CREATE TABLE manages (
    employee_id INT,
    project_id INT,
    PRIMARY KEY (employee_id , project_id),
    FOREIGN KEY (employee_id)
        REFERENCES employees (id),
    FOREIGN KEY (project_id)
        REFERENCES projects (id)
);

CREATE TABLE assigned_to (
    employee_id INT,
    task_id INT,
    PRIMARY KEY (employee_id , task_id),
    FOREIGN KEY (employee_id)
        REFERENCES employee (id),
    FOREIGN KEY (task_id)
        REFERENCES task (id)
);
 
