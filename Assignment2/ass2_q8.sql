select course, mark, grade, uoc
from people
         join course_enrolments on course_enrolments.student = people.id
         join subjects s on s.id = course_enrolments.course
where people.id = 1012504;


-- wam = 59*(6/30) + 65*(6/30) + 58*(6/30) + ....

drop function wam();
create or replace function wam()
    returns table
            (
                course int,
                mark   int,
                grade  text,
                uoc    int
            )
as
$$

declare
    row        record;
    total_mark float;
    total_uoc  float;
    result     integer;
begin
    result := 0;

    select sum(s.uoc)
    into total_uoc
    from people
             join course_enrolments on course_enrolments.student = people.id
             join subjects s on s.id = course_enrolments.course
    where people.id = 1012504;

    select sum(course_enrolments.mark)
    into total_mark
    from people
             join course_enrolments on course_enrolments.student = people.id
             join subjects s on s.id = course_enrolments.course
    where people.id = 1012504;

    for row in (
        select course_enrolments.course, course_enrolments.mark, course_enrolments.grade, s.uoc
        from people
                 join course_enrolments on course_enrolments.student = people.id
                 join subjects s on s.id = course_enrolments.course
        where people.id = 1012504)
        loop
            result := result + (row.uoc / total_uoc) * row.mark;
            wam.uoc := row.uoc;
            wam.course := row.course;
            wam.mark := row.mark;
            wam.grade := row.grade;
            return next;
        end loop;


    -- display wam

--     if result > 65 and result < 75 then
--         wam.grade = 'CR';
--         endif;
        wam.course := null;
        wam.uoc := total_uoc;
        wam.mark := result;
        return next;

    end;

$$ language plpgsql;


select *
from wam();