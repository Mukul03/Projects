
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE salaries (
    employee_id INT PRIMARY KEY,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);


Data Insertion (Sample)
INSERT INTO departments (department_id, department_name) VALUES
(1, 'HR'), (2, 'Finance'), (3, 'Engineering'),
(4, 'Sales'), (5, 'Marketing'), (6, 'Operations');

INSERT INTO employees (employee_id, name, department_id, hire_date) VALUES
(101, 'Alice Johnson', 3, '2015-03-12'),
(102, 'Bob Smith', 2, '2020-07-01'),
(103, 'Charlie Lee', 4, '2017-11-19'),
(104, 'Diana Prince', 1, '2012-05-05'),
(105, 'Ethan Hunt', 3, '2018-08-15'),
(106, 'Fay Morgan', 5, '2021-01-20'),
(107, 'George Brown', 6, '2013-06-25'),
(108, 'Hannah White', 4, '2019-09-10'),
(109, 'Ian Grey', 2, '2016-11-02'),
(110, 'Jenna Black', 1, '2014-04-18');

INSERT INTO salaries (employee_id, salary) VALUES
(101, 95000.00), (102, 72000.00), (103, 68000.00),
(104, 60000.00), (105, 98000.00), (106, 53000.00),
(107, 71000.00), (108, 64000.00), (109, 80000.00), (110, 62000.00);
Project Queries
Retrieve all employees in the Engineering department
SELECT e.employee_id, e.name, d.department_name, s.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN salaries s ON e.employee_id = s.employee_id
WHERE d.department_name = 'Engineering';
Calculate average salary by department
SELECT d.department_name, ROUND(AVG(s.salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_name;
Identify employees with over 5 years of service
SELECT employee_id, name, hire_date
FROM employees
WHERE hire_date <= CURRENT_DATE - INTERVAL '5 years';
Highest-paid employee in each department
SELECT d.department_name, e.name, s.salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN salaries s ON e.employee_id = s.employee_id
WHERE (d.department_id, s.salary) IN (
    SELECT e.department_id, MAX(s.salary)
    FROM employees e
    JOIN salaries s ON e.employee_id = s.employee_id
    GROUP BY e.department_id
);
Top 3 highest paid employees overall
SELECT e.name, s.salary
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
ORDER BY s.salary DESC
LIMIT 3;
Count of employees per department
SELECT d.department_name, COUNT(e.employee_id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
Employees hired in the last 2 years
SELECT name, hire_date
FROM employees
WHERE hire_date >= CURRENT_DATE - INTERVAL '2 years';
Employees with salary above department average
SELECT e.name, s.salary, d.department_name
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
JOIN departments d ON e.department_id = d.department_id
WHERE s.salary > (
    SELECT AVG(s2.salary)
    FROM employees e2
    JOIN salaries s2 ON e2.employee_id = s2.employee_id
    WHERE e2.department_id = e.department_id
);
Department salary distribution
SELECT d.department_name,
       MIN(s.salary) AS min_salary,
       MAX(s.salary) AS max_salary,
       ROUND(AVG(s.salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_name;
Rank employees by salary in each department
SELECT e.name, d.department_name, s.salary,
       RANK() OVER (PARTITION BY e.department_id ORDER BY s.salary DESC) AS salary_rank
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
JOIN departments d ON e.department_id = d.department_id;
Department with the most employees
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC
LIMIT 1;
Average employee tenure by department
SELECT d.department_name,
       ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.hire_date))), 2) AS avg_tenure_years
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
Employees who joined on the same date
SELECT hire_date, COUNT(*) as total_employees
FROM employees
GROUP BY hire_date
HAVING COUNT(*) > 1;
Departments with no employees
SELECT department_name
FROM departments
WHERE department_id NOT IN (SELECT DISTINCT department_id FROM employees);
