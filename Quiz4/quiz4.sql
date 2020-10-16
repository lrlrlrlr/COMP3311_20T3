create table x
(
    id   integer primary key,
    name text unique
);
create table y
(
    id   integer primary key,
    x_id integer references x (id),
    defn text
);

-- todo insert
INSERT INTO x VALUES (1, 'a');
INSERT INTO x VALUES (2, 'b');
INSERT INTO x VALUES (3, 'c');
INSERT INTO x VALUES (4, 'd');

INSERT INTO y VALUES (1,1,'DEFN...');
INSERT INTO y VALUES (2,2,'DEFN...');
INSERT INTO y VALUES (3,2,'DEFN...');
INSERT INTO y VALUES (4,3,'DEFN...');
INSERT INTO y VALUES (5,3,'DEFN...');
INSERT INTO y VALUES (6,3,'DEFN...');

-- normal join
SELECT *
FROM x
         JOIN y ON x.id = y.x_id;


-- left outer join
SELECT *
FROM x
         LEFT OUTER JOIN y ON x.id = y.x_id;

-- right outer join
SELECT *
FROM x
         RIGHT OUTER JOIN y ON x.id = y.x_id;

-- full outer join
SELECT *
FROM x
         FULL OUTER JOIN y ON x.id = y.x_id;


-- my correct answer
SELECT x.name, count(y.id)
FROM x
         FULL OUTER JOIN y ON (x.id = y.x_id)
GROUP BY x.name;

-- a.
SELECT x.name, count(y.id)
FROM x
         JOIN y ON (x.id = y.x_id)
GROUP BY x.name;

-- b.
SELECT x.name, count(y.id)
FROM x
         LEFT OUTER JOIN y ON (x.id = y.x_id)
GROUP BY x.name;

-- c.
SELECT x.name, count(y.id)
FROM x
         RIGHT OUTER JOIN y ON (x.id = y.x_id)
GROUP BY x.name;

-- d.
SELECT x.name,
       (
           select count(x_id)
           from y
           where y.x_id = x.id) as count
from x
         full outer join y on (x.id = y.x_id);

-- e.
select distinct x.name, (select count(x_id) from y where y.x_id = x.id) as count
from x
         full outer join y on (x.id = y.x_id);


-- Q2
create table Beers
(
    name   text primary key,
    brewer text
);
create table Drinkers
(
    name    text primary key,
    address text,
    phone   text
);
create table Likes
(
    drinker text references Drinkers (name),
    beer    text references Beers (name),
    primary key (drinker, beer)
);

INSERT INTO Beers
VALUES ('beer1', 'bre1');
INSERT INTO Beers
VALUES ('beer2', 'bre1');
INSERT INTO Beers
VALUES ('beer3', 'bre3');

INSERT INTO Drinkers
VALUES ('drinker_a', 'addr..', 'phone..');
INSERT INTO Drinkers
VALUES ('drinker_b', 'addr..', 'phone..');
INSERT INTO Drinkers
VALUES ('drinker_c', 'addr..', 'phone..');


INSERT INTO Likes
VALUES ('drinker_a', 'beer1');
INSERT INTO Likes
VALUES ('drinker_b', 'beer1');
INSERT INTO Likes
VALUES ('drinker_b', 'beer2');
INSERT INTO Likes
VALUES ('drinker_c', 'beer1');
INSERT INTO Likes
VALUES ('drinker_c', 'beer2');
INSERT INTO Likes
VALUES ('drinker_c', 'beer3');

SELECT D.name
FROM Beers
         JOIN Likes L on Beers.name = L.beer
         JOIN Drinkers D on L.drinker = D.name
WHERE exists(select L.beer from Likes where L.drinker = d.name);

-- a.
select d.name
from Drinkers d
where not exists(
            (select L.beer as name from Likes L where L.drinker = d.name)
            except
            (select name from Beers)
    );

-- b.
select d.name
from Drinkers d
where not exists(
            (select name from Beers)
            except
            (select L.beer as name from Likes L where L.drinker = d.name)
    );

-- c.
select d.name
from Drinkers d
where (select count(*) from Beers)
          =
      (select count(L.beer) from Likes L where L.drinker = d.name);

-- d.
select d.name
from Drinkers d
where exists(
                  (select L.beer as name from Likes L where L.drinker = d.name)
                  except
                  (select name from Beers)
          );


-- q3
create or replace function
    mystery(n integer, m integer) returns integer
as
$$
declare
    i integer;
    r integer := 1;
begin
    r := n;
    for i in 2..m
        loop
            r := r * n;
        end loop;
    return r;
end;
$$ language plpgsql;

SELECT mystery(10, 2);


-- q4
DROP TABLE IF EXISTS enrolments;
create table enrolments
(
    student text,
    course  text,
    mark    integer check (mark between 0 and 100),
    grade   char(1) check (grade between 'A' and 'E'),
    primary key (student, course)
);

INSERT INTO enrolments
VALUES ('james', 'COMP1917 12s1', '50', 'D');
INSERT INTO enrolments
VALUES ('peter', 'COMP1917 12s1', '45', 'E');
INSERT INTO enrolments
VALUES ('john', 'COMP1917 12s1', '90', 'A');
INSERT INTO enrolments
VALUES ('peter', 'COMP1917 12s2', '40', 'E');
INSERT INTO enrolments
VALUES ('john', 'COMP1927 12s2', '85', 'A');
INSERT INTO enrolments
VALUES ('james', 'COMP1927 12s2', '55', 'D');
INSERT INTO enrolments
VALUES ('james', 'COMP2911 13s1', '50', 'D');
INSERT INTO enrolments
VALUES ('john', 'COMP2911 13s1', '85', 'A');
INSERT INTO enrolments
VALUES ('john', 'COMP3311 13s2', '70', 'B');

create type stu_res as
(
    student text,
    score   numeric(5, 2)
);
create function results() returns setof stu_res
as
$$
declare
    r record; res stu_res;
    p text := ''; s integer := 0; n integer := 0;
begin
    for r in
        select student, mark
        from enrolments
        order by student
        loop
            if (p <> r.student and n > 0) then
                res.student := p;
                res.score := (s::float / n)::numeric(5, 2);
                return next res;
                s := 0; n := 0;
            end if;
            n := n + 1;
            s := s + r.mark;
            p := r.student;
        end loop;
    if (n > 0) then
        res.student := r.student;
        res.score := (s::float / n)::numeric(5, 2);
        return next res;
    end if;
end;
$$ language plpgsql;

select *
from results()
order by student;
