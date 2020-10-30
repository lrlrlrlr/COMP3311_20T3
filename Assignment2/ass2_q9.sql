select * from people;

create type AcObjRecord as (
	objtype text,  -- academic object's type e.g. subject, stream, program
	objcode text   -- academic object's code e.g. COMP3311, SENGA1, 3978
);


create or replace function Q9(gid integer) returns setof AcObjRecord


select * from acad_object_groups where definition like '%COMP%';

select * from acad_object_groups where id =20026;
select * from acad_object_groups where id =113111;
select * from acad_object_groups where id =113167;

select * from program_group_members;
select * from stream_group_members;
select * from subject_group_members;

-- enumerated program groups
select code from programs where id in (select program from program_group_members where ao_group = 20026);
select code from programs where id in (select program from program_group_members where ao_group = 113111);

-- pattern-based program
select * from acad_object_groups where id=115901;
select * from acad_object_groups where id=117030;
select * from acad_object_groups where id=116738;
select regexp_split_to_table(definition, ',') from acad_object_groups where id=116738;

