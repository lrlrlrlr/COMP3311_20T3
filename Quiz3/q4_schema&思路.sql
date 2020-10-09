create table student
(
    zid  int primary key,
    name text not null,
    age  int

);

create table class
(
    code int primary key,
    name text
);


create table enrolment
(
    student int,
    class   int,
    mark    int,
    primary key (student, class)
);



INSERT INTO student
VALUES (1234567, 'Harry Roo', 21);
INSERT INTO student
VALUES (2345678, 'Chen Zhang', 25);
INSERT INTO student
VALUES (3456789, 'Patricia Li', 18);

INSERT INTO class
VALUES (3311, 'Databases for fun and profit');
INSERT INTO class
VALUES (6441, 'Security learning');
INSERT INTO class
VALUES (1521, 'Deep dive into MIPS');

INSERT INTO Enrolment
VALUES (1234567, 3311, null);
INSERT INTO Enrolment
VALUES (2345678, 3311, 76);
INSERT INTO Enrolment
VALUES (2345678, 1521, 77);
INSERT INTO Enrolment
VALUES (2345678, 6441, 77);
INSERT INTO Enrolment
VALUES (1234567, 1521, null);


-- Quiz3 - Q4
-- A.
create VIEW all_marks_a(student, course, mark) as
SELECT name, name, mark
from class
         as c
         JOIN student as s ON s.zid = c.code;

-- B.
create VIEW all_marks_b(student, course, mark) AS
select s.name, c.name, e.mark
FROM enrolment AS e
         JOIN class AS c ON c.code = e.class
         JOIN student as s ON s.zid = e.student;


-- C.
create VIEW all_marks_c(student, course, mark) AS
SELECT s.name, c.name, e.mark
FROM student as s
         JOIN enrolment as e ON s.zid = e.student
         JOIN Class as c ON c.code = e.class;

-- D.
CREATE VIEW all_marks_d(student, course, mark) AS
SELECT *
FROM enrolment as e
         JOIN class AS c on c.code = e.class
         JOIN student as s ON s.zid = e.student
WHERE s.name, c.name, e.mark;



-- 挨个运行, 并查看能否成功运行/运行出来的结果是否正确即可.
-- example: 查看b选项输出
SELECT *
from all_marks_b;
