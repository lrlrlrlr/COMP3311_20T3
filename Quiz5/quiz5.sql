create table Courses
(
    id    integer primary key,
    code  char(4),
    title char(4),
    quota integer check (quota between 1 and 9999)
);


create table Students
(
    id integer primary key
);

create table Enrolments
(
    student integer references Students (id),
    course  integer references Courses (id)
);

INSERT INTO students VALUES (1);
INSERT INTO students VALUES (2);
INSERT INTO students VALUES (3);
INSERT INTO students VALUES (4);
INSERT INTO students VALUES (5);
INSERT INTO students VALUES (6);
INSERT INTO students VALUES (7);
INSERT INTO students VALUES (8);
INSERT INTO students VALUES (9);
INSERT INTO students VALUES (10);
INSERT INTO Courses VALUES (1,'c001','c001',2);
INSERT INTO Courses VALUES (2,'c002','c002',3);
INSERT INTO Courses VALUES (3,'c003','c003',4);
-- COURSE ENROLMENT:
-- COURSE001: 1,2 have 2students, equal to the quota
INSERT INTO Enrolments VALUES (1,1);
INSERT INTO Enrolments VALUES (2,1);

-- COURSE002: 8 have 1 students, less than the quota
INSERT INTO Enrolments VALUES (8,2);

-- COURSE003: 1,2,3,4,6 have 5 students, more than the quota
INSERT INTO Enrolments VALUES (1,3);
INSERT INTO Enrolments VALUES (2,3);
INSERT INTO Enrolments VALUES (3,3);
INSERT INTO Enrolments VALUES (4,3);
INSERT INTO Enrolments VALUES (6,3);


create assertion check_quota
    check (not exists (
        select count(*)
        from   Courses c join Enrolments e on (e.course = c.id)
        group  by e.student
        having count(*) > c.quota
    )
    );



create assertion check_quota
    check (not exists (
        select *
        from   (select c.id, count(student) as nstu, c.quota
                from   Courses c join Enrolments e on (e.course = c.id)
                group  by c.id
               ) as x
        where  x.nstu > x.quota
    )
    );





create assertion check_quota
    check (not exists (
        select *
        from   Courses c
        where  c.quota >= (select count(*) from Enrolments e where e.course = c.id)
    )
    );



-- Q2
-- https://cgi.cse.unsw.edu.au/~cs3311/20T3/lectures/triggers/slides.html
create table S (x integer, y integer);
create table T (z integer);
-- all S.x values must be larger than all T.z values
create or replace function checkXlarger() returns trigger
as $$
declare
minX integer; maxZ integer;
begin
select min(x) into minX from S;
select max(z) into maxZ from T;
if (maxZ >= minX) then
       raise exception 'All S.x must be greater than all T.z';
end if;
return new;
end;
$$ language plpgsql;


-- a
create trigger checkAssert before insert or update on S
for each row execute procedure checkXlarger();



-- b
create trigger checkAssert after insert or update on S
for each row execute procedure checkXlarger();


-- c
create trigger checkAssert1 before insert or update on S
for each row execute procedure checkXlarger();
create trigger checkAssert2 before insert or update on T
for each row execute procedure checkXlarger();

-- d
create trigger checkAssert1 after insert or update on S
for each row execute procedure checkXlarger();
create trigger checkAssert2 after insert or update on T
for each row execute procedure checkXlarger();

-- e No trigger is needed; this whole question is a bluff. This checking could be done more simply with standard database constraints


-- clear
drop trigger checkAssert ON S;
drop trigger checkAssert1 ON S;
drop trigger checkAssert2 ON T;

TRUNCATE table S;
TRUNCATE table T;

insert into S values (5,0); -- x=5  no prob
insert into T values (2); -- z=2 no prob
insert into T values (6); -- z=6 bad
insert into S values (1); -- x=1 bad
UPDATE public.s SET x = 1 WHERE x = 5 AND y = 0; -- change x=5 to x=1, bad
UPDATE public.t SET z = 9 WHERE z = 2;  -- change c=2 to c=9, bad


-- Q3
-- Aggregates
-- look at the slides https://cgi.cse.unsw.edu.au/~cs3311/20T3/lectures/aggregates/slides.html
create function
    join(s1 text, s2 text) returns text
as $$
begin
   if (s1 = '') then
      return s2;
   else
      return s1||','||s2;
   end if;
end;
$$ language plpgsql;

create aggregate concat(text) (
   stype    = text,
   initcond = '',
   sfunc    = join
);


-- Q4
create type IntPair as (x integer, y integer);
create function
    next_state(p IntPair, n integer) returns IntPair
as $$
begin
    if (p.x is null) then
        p.x := n;
    elsif (p.y is null) then
        if (n < p.x) then
            p.y := n;
        elsif (n > p.x) then
            p.y := p.x; p.x := n;
        end if;
    elsif (n > p.x) then
        p.y := p.x; p.x := n;
    elsif (n < p.x and n > p.y) then
        p.y := n;
    end if;
    return p;
end;
$$ language plpgsql;
create function
    second(p IntPair) returns integer
as $$
begin
    return p.y;
end;
$$ language plpgsql;
create aggregate max2 (int) (
    sfunc = next_state,
    stype = IntPair,
    finalfunc = second
);

--
--  student |    course     | mark | grade
-- ---------+---------------+------+-------
--  james   | COMP1917 12s1 |   50 | D
--  peter   | COMP1917 12s1 |   45 | E
--  john    | COMP1917 12s1 |   90 | A
--  peter   | COMP1917 12s2 |   40 | E
--  john    | COMP1927 12s2 |   85 | A
--  james   | COMP1927 12s2 |   55 | D
--  james   | COMP2911 13s1 |   50 | D
--  john    | COMP2911 13s1 |   85 | A
--  john    | COMP3311 13s2 |   70 | B

create table question5 (student text, course text, mark int, grade text);
INSERT INTO question5 VALUES ('james','COMP1917 12s1',50,'D');
INSERT INTO question5 VALUES ('peter','COMP1917 12s1',45,'E');
INSERT INTO question5 VALUES ('john ','COMP1917 12s1',90,'A');
INSERT INTO question5 VALUES ('peter','COMP1917 12s2',40,'E');
INSERT INTO question5 VALUES ('john ','COMP1927 12s2',85,'A');
INSERT INTO question5 VALUES ('james','COMP1927 12s2',55,'D');
INSERT INTO question5 VALUES ('james','COMP2911 13s1',50,'D');
INSERT INTO question5 VALUES ('john ','COMP2911 13s1',85,'A');
INSERT INTO question5 VALUES ('john ','COMP3311 13s2',70,'B');

select max2(mark) from question5;
