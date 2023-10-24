DROP TABLE departments --5
DROP TABLE salaries --1
DROP TABLE titles --6
DROP TABLE employees --4
DROP TABLE dept_manager --2
DROP TABLE dept_emp --3



-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/YHnruI
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar(200)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar(200)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(200)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(200)   NOT NULL,
    "last_name" varchar(200)   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "salaries" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");



select * from departments -- 1
select * from dept_emp -- 3
select * from dept_manager -- 3
select * from employees -- 2
select * from salaries -- 1
select * from titles -- 1


-- Data Analysis

-- List the employee number, last name, first name, sex, and salary of each employee.
select e.emp_no,e.last_name,e.first_name,e.sex,s.salary from employees e 
left outer join salaries s on e.emp_no = s.emp_no

-- List the first name, last name, and hire date for the employees who were hired in 1986.
select first_name,last_name,hire_date from employees
where hire_date between '1986-01-01' and '1986-12-31'

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
select m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name from dept_manager m
left outer join departments d on m.dept_no = d.dept_no
left outer join employees e on m.emp_no = e.emp_no

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
select e.emp_no
		,e.last_name
		,e.first_name
		,d.dept_no
		,d.dept_name 
from employees e
left outer join dept_emp de on e.emp_no = de.emp_no
left outer join dept_manager dm on e.emp_no = dm.emp_no
left outer join departments d on de.dept_no = d.dept_no

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select first_name,last_name,sex from employees
where first_name = 'Hercules'
	and last_name like 'B%'

-- List each employee in the Sales department, including their employee number, last name, and first name.
select e.emp_no
		,e.last_name
		,e.first_name
		,de.dept_no
		,d.dept_name 
from employees e
left outer join dept_emp de on e.emp_no = de.emp_no
left outer join departments d on de.dept_no = d.dept_no
where d.dept_name = 'Sales'

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT 
		e.emp_no
		,e.last_name
		,e.first_name
		,de.dept_no
		,d.dept_name
FROM employees e
LEFT OUTER JOIN dept_emp de on e.emp_no = de.emp_no
LEFT OUTER JOIN departments d on de.dept_no = d.dept_no
WHERE    --filter to find the emp_no in both 004 query result and 006 query result(1+2).
	e.emp_no in 
			(SELECT de.emp_no
			FROM dept_emp de
			where de.dept_no = 'd004')  --1: subquery to get emp_no in de with dept_no = d004
	AND  --mean 1+2 not 1 OR 2
	e.emp_no in 
			(SELECT de.emp_no
			FROM dept_emp de
			WHERE de.dept_no = 'd006') --2: subquery to get emp_no in de with dept_no = d006

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;




