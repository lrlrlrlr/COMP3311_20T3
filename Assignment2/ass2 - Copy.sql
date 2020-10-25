-- COMP3311 20T3 Assignment 2

-- Q1: students who've studied many courses

create view Q1(unswid,name)
as
...
;

-- Q2: numbers of students, staff and both

create or replace view Q2(nstudents,nstaff,nboth)
as
...
;

-- Q3: prolific Course Convenor(s)

create or replace view Q3(name,ncourses)
as
...
;

-- Q4: Comp Sci students in 05s2 and 17s1

create or replace view Q4a(id,name)
as
...
;

create or replace view Q4b(id,name)
as
...
;

-- Q5: most "committee"d faculty

create or replace view Q5(name)
as
...
;

-- Q6: nameOf function

create or replace function
   Q6(id integer) returns text
as $$
...
$$ language sql;

-- Q7: offerings of a subject

create or replace function
   Q7(subject text)
     returns table (subject text, term text, convenor text)
as $$
...
$$ language sql;

-- Q8: transcript

create or replace function
   Q8(zid integer) returns setof TranscriptRecord
as $$
...
$$ language plpgsql;

-- Q9: members of academic object group

create or replace function
   Q9(gid integer) returns setof AcObjRecord
as $$
...
$$ language plpgsql;

-- Q10: follow-on courses

create or replace function
   Q10(code text) returns setof text
as $$
...
$$ language plpgsql;
