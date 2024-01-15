SELECT * FROM employees;

CREATE TABLE people (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(50) NOT NULL,
    fist_name VARCHAR(50),
    last_name VARCHAR(50)
);

SELECT first_name, last_name 
FROM employees;

CREATE TABLE employees (
 id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR(50) NOT NULL, 
 last_name VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL
);

CREATE TABLE products (
 id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(80) NOT NULL,
 category_id INT NOT NULL
);

ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50) NOT NULL;


ALTER TABLE products
ADD CONSTRAINT fk_category_id
FOREIGN KEY (category_id)
REFERENCES categories (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100); 
