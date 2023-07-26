#1.查询和Zlotkey相同部门的员工姓名和工资
#方式一：自查询
SELECT e1.last_name,e1.salary
FROM employees e1 ,employees e2 
WHERE e2.last_name = 'Zlotkey' 
AND e1.department_id = e2.department_id;
#方式二：子查询
SELECT last_name,salary
FROM employees
WHERE department_id IN(SELECT department_id
												FROM employees
												WHERE last_name = 'Zlotkey'
												);


#2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (SELECT AVG(salary)
								FROM employees
								);

#3.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name, job_id, salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary > ALL(
								SELECT salary
								FROM employees
								WHERE job_id = 'SA_MAN'
								);

#4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT employee_id,last_name
FROM employees
WHERE department_id IN(
											 SELECT DISTINCT department_id
											 FROM employees
											 WHERE last_name LIKE '%u%'
											);

#5.查询在部门的location_id为1700的部门工作的员工的员工号
SELECT employee_id
FROM employees
WHERE department_id IN (
												SELECT department_id
												FROM departments
												WHERE location_id = 1700
												);

#6.查询管理者是King的员工姓名和工资
#方式一：
SELECT last_name,salary
FROM employees e1
WHERE EXISTS (
							SELECT employee_id
							FROM employees e2 
							WHERE e2.last_name = 'King'
							AND e2.employee_id = e1.manager_id
							);
							
#方式二：
SELECT last_name,salary
FROM employees 
WHERE manager_id IN (
										SELECT employee_id
										FROM employees 
										WHERE last_name = 'King'
										);

#7.查询工资最低的员工信息: last_name, salary
SELECT last_name,salary
FROM  employees
WHERE salary = (
								SELECT MIN(salary)
								FROM employees
								);

#8.查询平均工资最低的部门信息
#方式一：
SELECT *
FROM departments
WHERE department_id = (SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING AVG(salary) <= ALL(
																							SELECT AVG(salary) arg_sal 
																							FROM employees e2 
																							GROUP BY department_id
																							)
											);
#方式二：
SELECT d.* 
FROM departments d
WHERE department_id = (SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING AVG(salary) = (
																							SELECT MIN(avg_sal)
																							FROM (
																										SELECT AVG(salary) avg_sal
																										FROM employees
																										GROUP BY department_id
																									)	t_dept_avg_sal
																						)
											);

#方式三：
SELECT *
FROM departments
WHERE department_id = (SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING AVG(salary) = (
																							SELECT AVG(salary) avg_sal 
																							FROM employees
																							GROUP BY department_id
																							ORDER BY  avg_sal  ASC
																							LIMIT 0,1
																						)
											);
#方式四：
SELECT d.*
FROM departments d, (
										SELECT department_id,AVG(salary) avg_sal
										FROM employees
										GROUP BY department_id
										ORDER BY avg_sal ASC
										LIMIT 0,1
										)	t_dept_avg_sal
WHERE d.department_id = t_dept_avg_sal.department_id;				
											
#9.查询平均工资最低的部门信息和该部门的平均工资（相关子查询）
#方式一：
SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.department_id) avg
FROM departments d
WHERE department_id = (SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING AVG(salary) <= ALL(
																							SELECT AVG(salary) arg_sal 
																							FROM employees e2 
																							GROUP BY department_id
																							)
											);
#方式二：
SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.department_id) avg
FROM departments d
WHERE department_id = (SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING AVG(salary) = (
																							SELECT MIN(avg_sal)
																							FROM (
																										SELECT AVG(salary) avg_sal
																										FROM employees
																										GROUP BY department_id
																									)	t_dept_avg_sal
																						)
											);

#方式三：
SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.department_id) avg
FROM departments d
WHERE department_id = (SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING AVG(salary) = (
																							SELECT AVG(salary) avg_sal 
																							FROM employees
																							GROUP BY department_id
																							ORDER BY  avg_sal  ASC
																							LIMIT 0,1
																						)
											);
#方式四：
SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.department_id) avg
FROM departments d, (
										SELECT department_id,AVG(salary) avg_sal
										FROM employees
										GROUP BY department_id
										ORDER BY avg_sal ASC
										LIMIT 0,1
										)	t_dept_avg_sal
WHERE d.department_id = t_dept_avg_sal.department_id;				

#10.查询平均工资最高的 job 信息
#方式一：
SELECT *
FROM jobs
WHERE job_id = (
								SELECT job_id
								FROM employees e
								GROUP BY job_id
								HAVING AVG(salary) = (SELECT AVG(salary) avg_sal 
																FROM employees
																GROUP BY job_id
																ORDER BY avg_sal DESC
																LIMIT 0,1
																)
							);
#方式二：
SELECT *
FROM jobs 
WHERE job_id = (SELECT job_id
								FROM employees
								GROUP BY job_id
								HAVING AVG(salary) >= ALL(
																				SELECT AVG(salary) arg_sal 
																				FROM employees 
																				GROUP BY job_id
																				)
								);
#方式三：
SELECT d.* 
FROM jobs d
WHERE job_id = (SELECT job_id
								FROM employees
								GROUP BY job_id
								HAVING AVG(salary) = (
																				SELECT MAX(avg_sal)
																				FROM (
																							SELECT AVG(salary) avg_sal
																							FROM employees
																							GROUP BY job_id
																						)	t_dept_avg_sal
																			)
								);	
#方式四：
SELECT j.*
FROM jobs j, (
							SELECT job_id,AVG(salary) avg_sal
							FROM employees
							GROUP BY job_id
							ORDER BY avg_sal DESC
							LIMIT 0,1
							)	t_dept_avg_sal
WHERE j.job_id = t_dept_avg_sal.job_id;	
																		
#11.查询平均工资高于公司平均工资的部门有哪些?
SELECT department_id,AVG(salary) avg
FROM employees  
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING avg > (
								SELECT AVG(salary) 
								FROM employees
								);


#12.查询出公司中所有 manager 的详细信息
#方式一：自连接
SELECT DISTINCT mag.*
FROM employees mag JOIN employees emp
ON mag.employee_id = emp.manager_id;

#方式二：子查询
SELECT *
FROM employees 
WHERE employee_id IN(
										SELECT DISTINCT manager_id
										FROM employees
										) ;
#方式三：使用EXISTS
SELECT *
FROM employees e1 
WHERE EXISTS(
						SELECT *
						FROM employees e2 
						WHERE e1.employee_id =e2.manager_id
						) ;

#13.各个部门中 最高工资中最低的那个部门的 最低工资是多少?
#方式一：				
SELECT department_id,salary
FROM employees
WHERE salary = (
								SELECT MIN(max_sal)
								FROM(
										SELECT MAX(salary) max_sal
										FROM employees
										GROUP BY department_id
										) t_dept_max_sal
								);

#方式二：
SELECT MIN(salary)
FROM employees
WHERE department_id = (
											SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING MAX(salary) = (
																						SELECT MIN(max_sal)
																						FROM(
																								SELECT MAX(salary) max_sal
																								FROM employees
																								GROUP BY department_id
																								) t_dept_max_sal
																			);
											)
#方式三：
SELECT MIN(salary)
FROM employees
WHERE department_id = (
											SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING MAX(salary) <= ALL (
																						SELECT MAX(salary)
																						FROM employees
																						GROUP BY department_id
																			)
											);

#方式四：
SELECT MIN(salary)
FROM employees
WHERE department_id = (
											SELECT department_id
											FROM employees
											GROUP BY department_id
											HAVING MAX(salary) = (
																						SELECT MAX(salary) max_sal
																						FROM employees
																						GROUP BY department_id
																						ORDER BY max_sal ASC
																						LIMIT 0,1
																						)
											);
#方式五：
SELECT MIN(salary)
FROM employees e , (
							SELECT department_id,MAX(salary) max_sal
							FROM employees
							GROUP BY department_id
							ORDER BY max_sal ASC
							LIMIT 0,1
							)	t_dept_max_sal
WHERE e.department_id = t_dept_max_sal.department_id;	
																								
#14.查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
#方式一：
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id IN (
									SELECT manager_id
									FROM employees
									WHERE department_id = (
																			SELECT department_id
																			FROM employees
																			GROUP BY department_id
																			HAVING AVG(salary) >= ALL(
																														SELECT MAX(avg_sal)
																														FROM (
																																SELECT AVG(salary) avg_sal 
																																FROM employees
																																GROUP BY department_id
																																) t_dept_avg_sal
																														)

																			)
										);																			
#方式二：
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id IN (
											SELECT manager_id
											FROM employees e,(
																			SELECT department_id,AVG(salary) avg_sal
																			FROM employees
																			GROUP BY department_id
																			ORDER BY avg_sal DESC
																			LIMIT 0,1
																			) t_dept_avg_sal
											WHERE e.department_id = t_dept_avg_sal.department_id								
											);

#15. 查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号
#方式一：
SELECT DISTINCT department_id
FROM employees
WHERE department_id <> (
												SELECT DISTINCT department_id
												FROM employees
												WHERE job_id = 'ST_CLERK'
												);
#方式二：
SELECT DISTINCT department_id
FROM employees
WHERE department_id NOT IN (
												SELECT DISTINCT department_id
												FROM employees
												WHERE job_id = 'ST_CLERK'
												);												
#方式三：
SELECT department_id
FROM departments d
WHERE NOT EXISTS (
									SELECT department_id
									FROM employees e
									WHERE d.department_id = e.department_id
									AND job_id = 'ST_CLERK'
									)
																			
#16. 选择所有没有管理者的员工的last_name
#方式一：
SELECT last_name
FROM employees
WHERE manager_id <=> NULL;

#方式二：
SELECT last_name
FROM employees emp
WHERE NOT EXISTS(
								SELECT * 
								FROM employees mgr 
								WHERE emp.manager_id = mgr.manager_id
								);

#17．查询员工号、姓名、雇用时间、工资，其中员工的管理者为 'De Haan'
SELECT employee_id,last_name,hire_date,salary
FROM employees
WHERE manager_id IN (
										SELECT employee_id
										FROM employees
										WHERE last_name = 'De Haan'
										);

#18.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资（相关子查询）
#方式1：使用相关子查询
SELECT last_name,salary,department_id
FROM employees e1
WHERE salary > (
		SELECT AVG(salary)
		FROM employees e2
		WHERE department_id = e1.`department_id`
		);

#方式2：在FROM中声明子查询
SELECT e.last_name,e.salary,e.department_id
FROM employees e,(
									SELECT department_id,AVG(salary) avg_sal
									FROM employees
									GROUP BY department_id) t_dept_avg_sal
WHERE e.department_id = t_dept_avg_sal.department_id
AND e.salary > t_dept_avg_sal.avg_sal

#19.查询每个部门下的部门人数大于 5 的部门名称（相关子查询）
SELECT department_name
FROM departments d 
WHERE 5 < (
					SELECT COUNT(*)
					FROM employees e
					WHERE d.department_id = e.department_id
					);

#20.查询每个国家下的部门个数大于 2 的国家编号（相关子查询）
SELECT DISTINCT country_id
FROM locations l1 
WHERE 2 < (
					SELECT COUNT(*)
					FROM locations l2 
					WHERE l2.country_id = l1.country_id
					);
SELECT * 
FROM locations