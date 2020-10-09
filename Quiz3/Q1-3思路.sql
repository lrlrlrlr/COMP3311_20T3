-- Q1 考察sum/count 的区别, 考察groupby的用法, 挨个运行下列语句并查看结果即可;
select branchname, sum(balance)
from account
group by branchname;
select branchname, count(balance)
from account
group by branchname;

select *
from account;
SELECT a1.branchName, SUM(a1.balance)
FROM account a1,
     account a2
where a1.branchname = a2.branchname;



-- Q2 考察DELETE的语法:
-- DELETE FROM {TABLE_NAME} WHERE {CONDITION};
-- 考察 LIKE 的语法
SELECT *
FROM account
WHERE branchname LIKE 'C%'; -- starts with C
SELECT *
FROM account
WHERE branchname LIKE '%C'; -- ends with C
SELECT *
FROM account
WHERE branchname LIKE '%C%';
-- any position contains C


-- A.
DELETE
FROM account
WHERE branchname LIKE '%C' WHERE balance >10000;

-- B.
DELETE
FROM account
WHERE branchname LIKE '%C%'
  AND balance > 10000;

-- C.
DELETE
FROM account
WHERE branchname LIKE 'C%' WHERE balance >= 10000;

-- D.
DELETE
FROM account
WHERE branchname LIKE 'C%'
  AND balance > 10000;



-- Q3 考察join的语法, 挨个运行查看结果即可.
-- A
SELECT o.customer, a.balance
FROM Account as a,
     Owner AS o
WHERE a.accountno = o.account
  AND a.balance < 15000;

-- B
SELECT customer, balance
FROM account
         JOIN owner
WHERE balance < 15000;

-- C
SELECT o.customer, a.balance
from account as a
         JOIN owner as o ON a.accountno = o.account
    AND a.balance < 15000;

-- D
SELECT o.customer, a.balance
FROM account AS a,
     owner as o;

