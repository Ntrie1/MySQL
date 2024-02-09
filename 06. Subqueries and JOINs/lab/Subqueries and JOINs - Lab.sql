USE soft_uni;

-- 1. Managers

SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.department_id,
    d.name AS department_name
FROM
    employees e
        JOIN
    departments d ON e.employee_id = d.manager_id
ORDER BY e.employee_id
LIMIT 5;


-- 2. Towns Addresses

SELECT 
    t.town_id, t.name AS `town_name`, a.address_text
FROM
    towns t
        JOIN
    addresses a ON a.town_id = t.town_id
WHERE
    t.name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY t.town_id , a.address_id;  


-- 3. Employees Without Managers

SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_id,
    e.salary
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.manager_id IS NULL; 


-- 4. High Salary

SELECT 
    COUNT(*)
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);