# exercise 1.1 - Salary report - part 1
# Write a query that compares the earnings of men and women.
#
# Take the following assumptions:
#
# only the current salary should be taken into account,
# assume that the salary column in the salaries table is homogenous,
# i.e. all values are in the same currency.

CREATE TEMPORARY TABLE current_salaries AS
    (SELECT emp_no, salary, to_date
    FROM (SELECT emp_no,
        salary,
        to_date,
        ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY to_date DESC) AS row_num
    FROM salaries) AS ranked_salaries
    WHERE row_num = 1);

SELECT
    gender,
    AVG(salary)
FROM employees
INNER JOIN current_salaries AS cs on employees.emp_no = cs.emp_no
GROUP BY gender;

# exercise 2.1 - Salary report - part 2
# Extend the query from the previous task and check for differences in earnings in the following groups:
#
# divided by gender, and department,
# divided by gender,
# no division.
# Display the data in a way that is easy to read.
#
# Remember to add information on how many people were in each group.
# On this basis it will be possible to determine whether the groups are comparable.

SELECT *
FROM employees;
SELECT *
FROM departments;
SELECT *
FROM dept_emp;

SELECT
    gender,
    dept_name AS department_name,
    AVG(salary) AS avg_salary,
    COUNT(*)
FROM employees
INNER JOIN dept_emp USING (emp_no)
LEFT JOIN current_salaries USING (emp_no)
LEFT JOIN departments USING (dept_no)
GROUP BY gender, department_name
WITH ROLLUP;

