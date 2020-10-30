select * from subjects;
select * from subject_prereqs;
select * from rules;
select * from acad_object_groups;

select * from subjects where code='COMP9321'; --id 1935
select * from subject_prereqs where subject=1935;
select * from rules where id = 1206;
select * from acad_object_groups where id=111944;

select * from rules where id = 1207;
select * from acad_object_groups where id=111945;

select * from rules where id = 1208;
select * from acad_object_groups where id=111946;


select * from subjects
join subject_prereqs sp on subjects.id = sp.subject
join rules r on sp.rule = r.id
join acad_object_groups aog on r.ao_group = aog.id
where subjects.code='COMP9332';
