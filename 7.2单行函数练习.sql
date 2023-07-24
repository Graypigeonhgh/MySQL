# 1.显示系统时间(注：日期+时间)
SELECT NOW(),SYSDATE(),LOCALTIME(),CURRENT_TIMESTAMP()
FROM DUAL;

# 2.查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
SELECT employee_id,last_name,salary,salary * 1.2 "new salary"
FROM employees;

# 3.将员工的姓名按首字母排序，并写出姓名的长度（length）
SELECT last_name,LENGTH(last_name) "name_length"
FROM employees 
#ORDER BY last_name asc;
ORDER BY name_length ASC;

# 4.查询员工id,last_name,salary，并作为一个列输出，别名为OUT_PUT
SELECT CONCAT(employee_id,',',last_name,',',salary) "OUT_PUT"
FROM employees;

# 5.查询公司各员工工作的年数、工作的天数，并按工作年数的降序排序
SELECT employee_id,DATEDIFF(CURDATE(),hire_date)/365 "worked_years",DATEDIFF(CURDATE(),hire_date) "worked_dates"
FROM employees
ORDER BY worked_years DESC;

# 6.查询员工姓名，hire_date,department_id，满足以下条件：
#雇用时间在1997年之后，department_id为80 或 90 或110, commission_pct不为空
SELECT last_name,hire_date,department_id
FROM employees
WHERE department_id IN(80,90,100)
AND commission_pct IS NOT NULL
AND hire_date >= STR_TO_DATE('1997-01-01','%Y-%m-%d');

# 7.查询公司中入职超过10000天的员工姓名、入职时间
SELECT last_name,hire_date
FROM employees
WHERE DATEDIFF(CURDATE(),hire_date) >=10000;

# 8.做一个查询，产生下面的结果
#<last_name> earns <salary> monthly but wants <salary*3>
SELECT CONCAT(last_name,' earns ',TRUNCATE(salary,0),' monthly but wants ',TRUNCATE(salary*3,0)) "Dream salary"
FROM employees;
