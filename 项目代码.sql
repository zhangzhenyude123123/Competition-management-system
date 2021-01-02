update directioninfo
set tid = (
	select tid
	from teacher
	where teacher.tname = '����'
)
where teamid = (
	select teamid
	from team
	where team.tname = 'δ��1'
)
select tid
	from teacher
	where teacher.tname = '����'--142806  
	--132961
select *
from teacher
where teacher.tid = '132961';--������
	
select teamid
	from team
	where team.tname = 'δ��1'--26
insert directioninfo
values(26,'132961')

--��ѯδ��1�ӵ��Ŷ���Ϣ��ָ����ʦ��Ϣ
select *
from team,teacher,directioninfo
where team.teamid=directioninfo.teamid
and directioninfo.tid = teacher.tid
and team.tname = 'δ��1'
--��ѯδ��1�ӵ�ָ����ʦ��Ϣ
select *
from teacher,directioninfo
where directioninfo.tid = teacher.tid
and directioninfo.teamid = 
(select teamid
from team 
where team.tname = 'δ��1')

--
select *
from teacher,directioninfo
where teacher.tid = directioninfo.tid;

insert team values(26,'����δ����ϵͳ','δ��1',16,'2019/8/29',NULL,NULL,NULL)
delete team
where pname = '����δ����ϵͳ'


insert student
values('151020','�Ž�','��141','080901')

SELECT *
FROM student 
WHERE stid = '151020';

delete student
where stid = '151020'; 

Alter table competeinfo
Alter column cmonth char(2)
alter table competeinfo
alter column cname varchar(100)

alter table competeinfo
alter column cunit varchar(100)

--��ѯ�Ŷ�-ѧ��-������Ӧ��Ϣ*
select distinct team.*,student.*
from team,componentinfo,student,major
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid

--��ѯ��ͬ���ྺ�����Ŷӳ�Ա�Ļ����
select competeinfo.cname,competeinfo.cgrade,pname,pgrade,pburse,
student.sname,student.stid,major.majorname
from team,componentinfo,student,major,competeinfo
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and competeinfo.cid = team.cid
and student.majorkey = major.majorkey
group by cname,cgrade,pgrade,pburse,team.pname,student.stid,student.sname,major.majorname

--��ѯ�������ѧ�뼼��רҵ���ŶӲμӻ����
select cname,cgrade,pname,pgrade,pburse,student.stid,student.sname
from team,componentinfo,student,competeinfo
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and competeinfo.cid = team.cid
and student.majorkey = (select majorkey
						from major
						where major.majorname = '�������ѧ�뼼��')
and pgrade != 'NULL'
group by cgrade,cname,pgrade,pburse,student.stid,
student.sname,team.pname

--ͳ���˹����������ݿ�ѧѧԺ��ʡ����ȡ���
select cname,cgrade,pname,pgrade,pburse,student.stid,student.sname
from team,componentinfo,student,competeinfo,major
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and competeinfo.cid = team.cid
and student.majorkey = major.majorkey
and major.collegekey in (select collegekey
						from college
						where college.name = '�˹����������ݿ�ѧѧԺ') 
group by cgrade,cname,pgrade,pburse,student.stid,
student.sname,team.pname
having pgrade <> '���Ҽ�' and pgrade != 'NULL'

--ͳ�Ʋ�ͬѧԺ��רҵ�ľ��������
select college.name,pgrade,major.majorname,COUNT(pgrade) as num
from team,componentinfo,student,major,college
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and student.majorkey = major.majorkey
and major.collegekey = college.collegekey
group by college.name,majorname,pgrade
having pgrade <> 'NULL'
order by num

--grant
create login zzy with password = 'abc',default_database = bigtestnew
create user zzy for login zzy

create role team_manager
grant select,insert,update 
on team
to team_manager

exec sp_addrolemember 'team_manager','zzy'

--��student���а�ѧ������Ͱ༶����Ľ�������

create index studentindexs
on student(stid desc,class desc)

drop index studentindexs
on student

select *
from student with(index(studentindexs))


--��team���а������Ž���������
create index team_index
on team(cid desc)

select *
from team with(index(team_index))

--����һ����ͼViewprize��ͳ���˹�����ѧԺ��ͬרҵ���Ҽ���ʡ���Ļ�������
go
create view Viewprize
as
select college.name,pgrade,major.majorname,COUNT(pgrade) as num
from team,componentinfo,student,major,college
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and student.majorkey = major.majorkey
and major.collegekey = college.collegekey
and college.name ='�˹����������ݿ�ѧѧԺ'
group by college.name,majorname,pgrade
having pgrade <> 'NULL'
go

select *
from Viewprize


--ͳ�Ʋ�ͬѧԺ��רҵ�ľ��������,ͳ��ȫУʡ����������ȫУ���Ҽ�������
--ͳ�Ʋ�ͬѧԺ����ͬרҵ�Ĳ�ͬ�����ģ���ͬ���������
GO
create proc proc_include
@syear int,@date_begin int,@date_end int
as
declare @s_totalnumber int ,@g_totalnumber int 
begin

print('ѧԺ��רҵʡ�������Ҽ�������������')
select college.name,pgrade,major.majorname,COUNT(pgrade) as num
from team,componentinfo,student,major,college
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and student.majorkey = major.majorkey
and major.collegekey = college.collegekey
and year(ptime) = @syear 
and month(ptime)>@date_begin 
and month(ptime)<@date_end 
group by college.name,majorname,pgrade
having pgrade <> 'NULL'
order by num

print('��ѧԺ��ʡ�������')
select college.name,pgrade,COUNT(pgrade) as num
from team,componentinfo,student,major,college
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and student.majorkey = major.majorkey
and major.collegekey = college.collegekey
and year(ptime) = @syear 
and month(ptime)>@date_begin 
and month(ptime)<@date_end 
group by college.name,pgrade
having pgrade <> 'NULL' and pgrade <> '���Ҽ�' 

print('��ѧԺ�Ĺ��Ҽ������')
select college.name,pgrade,COUNT(pgrade) as num
from team,componentinfo,student,major,college
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and student.majorkey = major.majorkey
and major.collegekey = college.collegekey
and year(ptime) = @syear 
and month(ptime)>@date_begin 
and month(ptime)<@date_end 
group by college.name,pgrade
having pgrade <> 'NULL' and pgrade <> 'ʡ��' 

select @g_totalnumber = COUNT(pgrade)
from team 
where year(ptime) = @syear 
and month(ptime)>@date_begin 
and month(ptime)<@date_end 
and pgrade <> 'NULL' and pgrade <> 'ʡ��' 

select @s_totalnumber = COUNT(pgrade)
from team 
where year(ptime) = @syear 
and month(ptime)>@date_begin 
and month(ptime)<@date_end 
and pgrade <> 'NULL' and pgrade <> '���Ҽ�' 

print('ѧУ��ʡ����������')
print @s_totalnumber
print('ѧУ�񽱹��Ҽ���������')
print @g_totalnumber
end

drop proc proc_include;

exec proc_include 2020,1,6;
exec proc_include 2020,4,11;

--ͳ�Ʋ�ͬ�꼶����ͬרҵ����ͬ�����Ļ����
SELECT *
FROM student
WHERE stid LIKE '15%'

SELECT *
FROM student
WHERE stid LIKE '14%'

SELECT *
FROM student
WHERE stid LIKE '13%'

GO
CREATE PROC select_2
@syear int
AS
declare @a_totalnumber1 int ,@b_totalnumber1 int, @c_totalnumber1 int
declare @a_totalnumber2 int ,@b_totalnumber2 int, @c_totalnumber2 int
BEGIN

	print('13��ѧԺ��רҵʡ�������Ҽ�������������')
	select competeinfo.cname,college.name,pgrade,major.majorname,COUNT(pgrade) as num 
	from team,componentinfo,student,major,college,competeinfo
	where competeinfo.cid = team.cid 
	and team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid
	and student.majorkey = major.majorkey
	and major.collegekey = college.collegekey
	and year(ptime) = @syear 
	and student.stid LIKE '13%'
	group by competeinfo.cname,college.name,majorname,pgrade
	having pgrade <> 'NULL'
	order by num
	
	print('13��ʡ��������')
	select @a_totalnumber1 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '���Ҽ�'
	and student.stid LIKE '13%'
	print(@a_totalnumber1)
	
	print('13�����Ҽ�������')
	select @a_totalnumber2 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> 'ʡ��'
	and student.stid LIKE '13%'
	print(@a_totalnumber2)
	
	print('14��ѧԺ��רҵʡ�������Ҽ�������������')
	select competeinfo.cname,college.name,pgrade,major.majorname,COUNT(pgrade) as num
	from team,componentinfo,student,major,college,competeinfo
	where competeinfo.cid = team.cid 
	and team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid
	and student.majorkey = major.majorkey
	and major.collegekey = college.collegekey
	and year(ptime) = @syear 
	and student.stid LIKE '14%'
	group by competeinfo.cname,college.name,majorname,pgrade
	having pgrade <> 'NULL'
	order by num
	
	print('14��ʡ��������')
	select @b_totalnumber1 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '���Ҽ�'
	and student.stid LIKE '14%'
	print(@b_totalnumber1)
	
	print('14�����Ҽ�������')
	select @b_totalnumber2 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> 'ʡ��'
	and student.stid LIKE '14%'
	print(@b_totalnumber2)
	
	print('15��ѧԺ��רҵʡ�������Ҽ�������������')
	select competeinfo.cname,college.name,pgrade,major.majorname,COUNT(pgrade) as num
	from team,componentinfo,student,major,college,competeinfo
	where competeinfo.cid = team.cid 
	and team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid
	and student.majorkey = major.majorkey
	and major.collegekey = college.collegekey
	and year(ptime) = @syear 
	and student.stid LIKE '15%'
	group by competeinfo.cname,college.name,majorname,pgrade
	having pgrade <> 'NULL'
	order by num
	
	print('15��ʡ��������')
	select @c_totalnumber1 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '���Ҽ�'
	and student.stid LIKE '15%'
	print(@c_totalnumber1)
	
	print('15�����Ҽ�������')
	select @c_totalnumber2 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> 'ʡ��'
	and student.stid LIKE '15%'
	print(@c_totalnumber2)
END
GO


drop PROC select_2

exec select_2 2020;






