-- Write a query to display: 
-- 1. the first name, last name, salary, and job grade for all employees.
SELECT first_name, last_name, salary, job_title
FROM employees LEFT JOIN jobs USING (job_id);

-- 2. the first and last name, department, city, and state province for each employee.
SELECT first_name,last_name,department_name,city,state_province
FROM employees left join departments USING(department_id)
left join locations USING (location_id);

-- 3. the first name, last name, department number and department name, for all employees for departments 80 or 40.
SELECT first_name,last_name,department_id,department_name
FROM employees LEFT JOIN departments USING (department_id)
WHERE department_id BETWEEN 40 AND 80;

-- 4. those employees who contain a letter z to their first name and also display their last name, department, city, and state province.
SELECT last_name,department_name,city,state_province
FROM employees
LEFT JOIN departments USING(department_id)
LEFT JOIN locations USING (location_id)
WHERE first_name like '%z%';

-- 5. the first and last name and salary for those employees who earn less than the employee earn whose number is 182.
Select first_name,last_name,salary
From employees
where salary < (SELECT salary FROM employees where employee_id = 182);

-- 6. the first name of all employees including the first name of their manager.
SELECT e.first_name as "Employee Name" , m.first_name as "Manager"
FROM employees e JOIN employees m ON e.manager_id = m.employee_id

-- 7. the first name of all employees and the first name of their manager including those who does not working under any manager.
SELECT e.first_name , m.first_name
FROM employees e LEFT OUTER JOIN employees m ON e.manager_id = m.employee_id;

-- 8. the details of employees who manage a department.
SELECT first_name, last_name
FROM EMPLOYEES JOIN DEPARTMENTS ON departments.manager_id = employees.employee_id

-- 9. the first name, last name, and department number for those employees who works in the same department as the employee who holds the last name as Taylor.
SELECT e1.first_name, e1.last_name, e1.department_id
FROM employees e1 JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e2.last_name = 'Taylor'

--10. the department name and number of employees in each of the department.
SELECT departments.department_name as "Department", COUNT (*) as "Employees"
FROM departments LEFT JOIN employees ON employees.department_id = departments.department_id
group by departments.department_id, department_name

--11. the name of the department, average salary and number of employees working in that department who got commission.
SELECT d.department_name, avg(salary), count(e.employee_id)
FROM DEPARTMENTS d JOIN EMPLOYEES e
ON d.department_id = e.department_id
WHERE e.commission_pct IS NOT NULL
GROUP BY d.department_name

--12. job title and average salary of employees.
SELECT job_title,AVG(salary)
FROM JOBS j JOIN EMPLOYEES e
             ON j.job_id = e.job_id
GROUP BY job_title

--13. the country name, city, and number of those departments where at least 2 employees are working.

SELECT COUNTRY_NAME,
       CITY,
       D.DEPARTMENT_ID,
       COUNT(E.DEPARTMENT_ID) AS "NUMBER_OF_EMPLOYEES"
FROM COUNTRIES C
         JOIN LOCATIONS L
              ON C.COUNTRY_ID = L.COUNTRY_ID
         JOIN DEPARTMENTS D
              ON L.LOCATION_ID = D.LOCATION_ID
         JOIN EMPLOYEES E on D.DEPARTMENT_ID = E.DEPARTMENT_ID
HAVING COUNT(E.DEPARTMENT_ID) >= 2
GROUP BY COUNTRY_NAME, CITY, D.DEPARTMENT_ID;

--14. the employee ID, job name, number of days worked in for all those jobs in department 80.
SELECT employee_id, job_title, end_date - start_date
FROM JOB_HISTORY
  NATURAL JOIN JOBS
WHERE department_id = 80

--15. the name ( first name and last name ) for those employees who gets more salary than the employee whose ID is 163.

SELECT CONCAT(first_name , last_name) as "name"
FROM employees
WHERE salary > (SELECT salary FROM employees WHERE employee_id = 163)

--16. the employee id, employee name (first name and last name ) for all employees who earn more than the average salary.
SELECT employee_id , CONCAT(first_name, last_name) as "name"
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)

--17. the employee name ( first name and last name ), employee id and salary of all employees who report to Payam.

SELECT CONCAT(first_name, last_name) AS "name", employee_id, salary
FROM employees
WHERE manager_id = (SELECT employee_id FROM employees WHERE first_name = 'Payam')

--18. the department number, name ( first name and last name ), job and department name for all employees in the Finance department.
SELECT e.department_id, CONCAT(e.first_name, e.last_name) AS "name", j.job_title, d.department_name
FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN JOBS j ON e.job_id = j.job_id
WHERE department_name = 'Finance'

--19. all the information of an employee whose id is any of the number 134, 159 and 183.
SELECT * FROM employees
WHERE employee_id IN (134, 159, 183)

--20. all the information of the employees whose salary is within the range of smallest salary and 2500.
SELECT * FROM employees
WHERE salary > (SELECT MIN(min_salary) FROM jobs) AND salary < 2500

--21. all the information of the employees who does not work in those departments where some employees works whose id within the range 100 and 200.
SELECT * FROM employees
WHERE department_id NOT IN
(SELECT department_id FROM departments
  WHERE employee_id BETWEEN 100 AND 200)

--22. all the information for those employees whose id is any id who earn the second highest salary.
SELECT * FROM employees
WHERE salary = (SELECT MAX(salary)FROM
(SELECT salary FROM employees MINUS SELECT MAX(salary)FROM employees)
)

--23. the employee name( first name and last name ) and hiredate for all employees in the same department as Clara. Exclude Clara.
SELECT CONCAT(first_name,last_name) , hire_date
FROM employees
WHERE department_id = (SELECT department_id FROM (SELECT department_id FROM employees WHERE first_name = 'Clara') WHERE first_name NOT LIKE 'Clara')

--24. the employee number and name( first name and last name ) for all employees who work in a department with any employee whose name contains a T.
SELECT employee_id , CONCAT( first_name , last_name )
 FROM EMPLOYEES
WHERE department_id = ANY
       (SELECT department_id
        FROM employees
        WHERE first_name like '%T%')

--25. full name(first and last name), job title, starting and ending date of last jobs for those employees with worked without a commission percentage.
SELECT e.first_name || ' ' || e.last_name , j.job_title--, start_date, end_date
FROM employees e INNER JOIN  job_history jh
                   ON e.employee_id = jh.employee_id
                LEFT JOIN JOBS j
                   ON e.job_id = j.job_id
  WHERE e.commission_pct is null

--26. the employee number, name( first name and last name ), and salary for all employees who earn more than the average salary and who work in a department with any employee with a J in their name.
SELECT employee_id, first_name || ' ' || last_name, salary
FROM EMPLOYEES
WHERE salary > (SELECT AVG(salary) FROM EMPLOYEES)
    AND department_id = ANY (SELECT department_id
                             FROM EMPLOYEES
                             WHERE first_name like '%J%')


--27. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN.
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, JOB_TITLE
FROM EMPLOYEES e
INNER JOIN JOBS j
ON e.job_id = j.job_id
WHERE salary < (SELECT SALARY
                            FROM EMPLOYEES
                  WHERE job_id = 'MK_MAN')


--28. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN. Exclude Job title MK_MAN.
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, JOB_TITLE
FROM EMPLOYEES e
INNER JOIN JOBS j
ON e.job_id = j.job_id
WHERE salary < ANY(SELECT SALARY
                            FROM EMPLOYEES
                  WHERE job_id = 'MK_MAN')
                  AND e.job_id <> 'MK_MAN'

--29. all the information of those employees who did not have any job in the past.
SELECT * FROM EMPLOYEES e
LEFT JOIN JOB_HISTORY j
ON e.EMPLOYEE_ID = J.EMPLOYEE_ID
WHERE J.JOB_ID IS NOT NULL

--30. the employee number, name( first name and last name ) and job title for all employees whose salary is more than any average salary of any department.
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME , JOB_TITLE
FROM EMPLOYEES e
LEFT JOIN JOBS j
ON e.JOB_ID = j.JOB_ID
WHERE e.SALARY > ANY(SELECT AVG(SALARY) FROM EMPLOYEES
                   WHERE DEPARTMENT_ID = ANY(SELECT DEPARTMENT_ID FROM DEPARTMENTS))

--31. the employee id, name ( first name and last name ) and the job id column with a modified title SALESMAN for those employees whose job title is ST_MAN and DEVELOPER for whose job title is IT_PROG.
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, JOB_ID,
      CASE
        WHEN JOB_ID = 'ST_MAN' THEN 'SALESMAN'
        WHEN JOB_ID = 'DEVELOPER' THEN 'IT_PROG'
        ELSE JOB_ID
      END  AS JOB_ID
FROM EMPLOYEES

--32. the employee id, name ( first name and last name ), salary and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than the average salary of all employees.
SELECT EMPLOYEE_ID , FIRST_NAME || ' ' || LAST_NAME, SALARY ,
       (CASE
         WHEN SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES) THEN 'HIGH'
         WHEN SALARY < (SELECT AVG(SALARY) FROM EMPLOYEES) THEN 'LOW'
         ELSE '   '
         END) AS SALARY
FROM EMPLOYEES

--33. the employee id, name ( first name and last name ), SalaryDrawn, AvgCompare (salary - the average salary of all employees)
    -- and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than
    -- the average salary of all employees.
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME AS NAME, SALARY AS SALARY_DRAWN,
  (SALARY - (
	SELECT AVG(SALARY)
	FROM EMPLOYEES)) AS AVG_COMPARE,
	(
		CASE WHEN SALARY > ( SELECT avg(SALARY)
		                     FROM EMPLOYEES) THEN 'HIGH'
		ELSE 'LOW'
	END) AS SALARY_STATUS
FROM EMPLOYEES;

--34. all the employees who earn more than the average and who work in any of the IT departments.
SELECT * FROM EMPLOYEES e
LEFT JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
AND D.DEPARTMENT_NAME = 'IT'

--35. who earns more than Mr. Ozer.
SELECT * FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY FROM EMPLOYEES WHERE LAST_NAME = 'Ozer')

--36. which employees have a manager who works for a department based in the US.

SELECT * FROM EMPLOYEES e
INNER JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
INNER JOIN LOCATIONS L
ON d.LOCATION_ID = l.LOCATION_ID
WHERE L.COUNTRY_ID = 'US'

--37. the names of all employees whose salary is greater than 50% of their department’s total salary bill.
SELECT CONCAT(FIRST_NAME, LAST_NAME)
FROM EMPLOYEES FE
WHERE SALARY >=
      (SELECT SUM(SALARY) * .5
       FROM EMPLOYEES SE
       WHERE FE.DEPARTMENT_ID = SE.DEPARTMENT_ID);

--38. the employee id, name ( first name and last name ), salary, department name and city for all
--the employees who gets the salary as the salary earn by the employee which is maximum within the joining person January 1st, 2002 and December 31st, 2003.
SELECT EMPLOYEE_ID, CONCAT(FIRST_NAME, LAST_NAME), SALARY, DEPARTMENT_NAME, CITY
FROM EMPLOYEES
         JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = EMPLOYEES.DEPARTMENT_ID
         JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE SALARY =
      (SELECT MAX(SALARY)
       FROM EMPLOYEES
       WHERE HIRE_DATE BETWEEN TO_DATE('2002-01-01', 'YYYY-MM-DD')
                 AND TO_DATE('2003-12-31', 'YYYY-MM-DD'));

--39. the first and last name, salary, and department ID for all those employees who earn more than the average salary and arrange the list in descending order on salary.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY)FROM EMPLOYEES)
ORDER BY SALARY DESC

--40. the first and last name, salary, and department ID for those employees who earn more than the maximum salary of a department which ID is 40.

SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT MAX(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = 40)

--41. the department name and Id for all departments where they located, that Id is equal to the Id for the location where department number 30 is located.
SELECT d.DEPARTMENT_NAME, d.DEPARTMENT_ID
FROM DEPARTMENTS d
JOIN LOCATIONS l ON
	(d.LOCATION_ID = l.LOCATION_ID)
WHERE d.LOCATION_ID = ( SELECT LOCATION_ID
                        FROM DEPARTMENTS
	                      WHERE DEPARTMENT_ID = 30);

--42. the first and last name, salary, and department ID for all those employees who work in that department where the employee works who hold the ID 201.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 201)

--43. the first and last name, salary, and department ID for those employees whose salary is equal to the salary of the employee who works in that department which ID is 40.
SELECT FIRST_NAME,LAST_NAME, SALARY,DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY = (SELECT SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 40)

--44. the first and last name, salary, and department ID for those employees who earn more than the minimum salary of a department which ID is 40.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT MIN(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = 40)

--45. the first and last name, salary, and department ID for those employees who earn less than the minimum salary of a department which ID is 70.
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY < (SELECT MIN(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = 70)

--46. the first and last name, salary, and department ID for those employees who earn less than the average salary, and also work at the department where the employee Laura is working as a first name holder.
SELECT FIRST_NAME, LAST_NAME,SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE SALARY < (SELECT AVG(SALARY) FROM EMPLOYEES)
  AND DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Laura')

--47. the full name (first and last name) of manager who is supervising 4 or more employees.
SELECT FIRST_NAME || ' ' || LAST_NAME
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (SELECT MANAGER_ID
                   FROM DEPARTMENTS
                   WHERE (SELECT COUNT(EMPLOYEE_ID)
                          FROM EMPLOYEES e
                          INNER JOIN DEPARTMENTS d
                          ON e.MANAGER_ID = d.MANAGER_ID
                          WHERE e.MANAGER_ID = d.MANAGER_ID)> 4)

--48. the details of the current job for those employees who worked as a Sales Representative in the past.
SELECT DISTINCT J.JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY
FROM JOBS J
         JOIN EMPLOYEES E ON J.JOB_ID = E.JOB_ID
         JOIN JOB_HISTORY JH ON J.JOB_ID = JH.JOB_ID
WHERE J.JOB_ID IN
      (SELECT E.JOB_ID
       FROM EMPLOYEES
       WHERE E.JOB_ID IN
             (SELECT JH.JOB_ID
              FROM JOB_HISTORY
              WHERE JH.JOB_ID = 'SA_REP'));

--49. all the infromation about those employees who earn second lowest salary of all the employees.
SELECT * FROM employees
WHERE salary = (SELECT MIN(salary)FROM
(SELECT salary FROM employees MINUS SELECT MIN(salary)FROM employees))

--50. the department ID, full name (first and last name), salary for those employees who is highest salary drawar in a department.
SELECT DEPARTMENT_ID, MAX(FIRST_NAME || ' ' || LAST_NAME), MAX(SALARY) AS SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID;
