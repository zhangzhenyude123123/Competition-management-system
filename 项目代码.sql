update directioninfo
set tid = (
	select tid
	from teacher
	where teacher.tname = '孙盼'
)
where teamid = (
	select teamid
	from team
	where team.tname = '未来1'
)
select tid
	from teacher
	where teacher.tname = '孙盼'--142806  
	--132961
select *
from teacher
where teacher.tid = '132961';--王立林
	
select teamid
	from team
	where team.tname = '未来1'--26
insert directioninfo
values(26,'132961')

--查询未来1队的团队信息，指导老师信息
select *
from team,teacher,directioninfo
where team.teamid=directioninfo.teamid
and directioninfo.tid = teacher.tid
and team.tname = '未来1'
--查询未来1队的指导老师信息
select *
from teacher,directioninfo
where directioninfo.tid = teacher.tid
and directioninfo.teamid = 
(select teamid
from team 
where team.tname = '未来1')

--
select *
from teacher,directioninfo
where teacher.tid = directioninfo.tid;

insert team values(26,'面向未来的系统','未来1',16,'2019/8/29',NULL,NULL,NULL)
delete team
where pname = '面向未来的系统'


insert student
values('151020','张杰','计141','080901')

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

--查询团队-学生-竞赛对应信息*
select distinct team.*,student.*
from team,componentinfo,student,major
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid

--查询不同种类竞赛，团队成员的获奖情况
select competeinfo.cname,competeinfo.cgrade,pname,pgrade,pburse,
student.sname,student.stid,major.majorname
from team,componentinfo,student,major,competeinfo
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and competeinfo.cid = team.cid
and student.majorkey = major.majorkey
group by cname,cgrade,pgrade,pburse,team.pname,student.stid,student.sname,major.majorname

--查询计算机科学与技术专业的团队参加获奖情况
select cname,cgrade,pname,pgrade,pburse,student.stid,student.sname
from team,componentinfo,student,competeinfo
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and competeinfo.cid = team.cid
and student.majorkey = (select majorkey
						from major
						where major.majorname = '计算机科学与技术')
and pgrade != 'NULL'
group by cgrade,cname,pgrade,pburse,student.stid,
student.sname,team.pname

--统计人工智能与数据科学学院的省级获取情况
select cname,cgrade,pname,pgrade,pburse,student.stid,student.sname
from team,componentinfo,student,competeinfo,major
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and competeinfo.cid = team.cid
and student.majorkey = major.majorkey
and major.collegekey in (select collegekey
						from college
						where college.name = '人工智能与数据科学学院') 
group by cgrade,cname,pgrade,pburse,student.stid,
student.sname,team.pname
having pgrade <> '国家级' and pgrade != 'NULL'

--统计不同学院的专业的竞赛获奖情况
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

--把student表中按学号升序和班级降序的建立索引

create index studentindexs
on student(stid desc,class desc)

drop index studentindexs
on student

select *
from student with(index(studentindexs))


--把team表中按竞赛号降序建立索引
create index team_index
on team(cid desc)

select *
from team with(index(team_index))

--创建一个视图Viewprize，统计人工智能学院不同专业国家级、省级的获奖总数量
go
create view Viewprize
as
select college.name,pgrade,major.majorname,COUNT(pgrade) as num
from team,componentinfo,student,major,college
where team.teamid = componentinfo.teamid
and componentinfo.stid = student.stid
and student.majorkey = major.majorkey
and major.collegekey = college.collegekey
and college.name ='人工智能与数据科学学院'
group by college.name,majorname,pgrade
having pgrade <> 'NULL'
go

select *
from Viewprize


--统计不同学院的专业的竞赛获奖情况,统计全校省级总人数，全校国家级总人数
--统计不同学院，不同专业的不同竞赛的，不同奖项的人数
GO
create proc proc_include
@syear int,@date_begin int,@date_end int
as
declare @s_totalnumber int ,@g_totalnumber int 
begin

print('学院各专业省级、国家级竞赛获奖总人数')
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

print('各学院的省级获奖情况')
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
having pgrade <> 'NULL' and pgrade <> '国家级' 

print('各学院的国家级获奖情况')
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
having pgrade <> 'NULL' and pgrade <> '省级' 

select @g_totalnumber = COUNT(pgrade)
from team 
where year(ptime) = @syear 
and month(ptime)>@date_begin 
and month(ptime)<@date_end 
and pgrade <> 'NULL' and pgrade <> '省级' 

select @s_totalnumber = COUNT(pgrade)
from team 
where year(ptime) = @syear 
and month(ptime)>@date_begin 
and month(ptime)<@date_end 
and pgrade <> 'NULL' and pgrade <> '国家级' 

print('学校获奖省级总人数：')
print @s_totalnumber
print('学校获奖国家级总人数：')
print @g_totalnumber
end

drop proc proc_include;

exec proc_include 2020,1,6;
exec proc_include 2020,4,11;

--统计不同年级、不同专业、不同竞赛的获奖情况
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

	print('13级学院各专业省级、国家级竞赛获奖总人数')
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
	
	print('13级省级总人数')
	select @a_totalnumber1 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '国家级'
	and student.stid LIKE '13%'
	print(@a_totalnumber1)
	
	print('13级国家级总人数')
	select @a_totalnumber2 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '省级'
	and student.stid LIKE '13%'
	print(@a_totalnumber2)
	
	print('14级学院各专业省级、国家级竞赛获奖总人数')
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
	
	print('14级省级总人数')
	select @b_totalnumber1 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '国家级'
	and student.stid LIKE '14%'
	print(@b_totalnumber1)
	
	print('14级国家级总人数')
	select @b_totalnumber2 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '省级'
	and student.stid LIKE '14%'
	print(@b_totalnumber2)
	
	print('15级学院各专业省级、国家级竞赛获奖总人数')
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
	
	print('15级省级总人数')
	select @c_totalnumber1 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '国家级'
	and student.stid LIKE '15%'
	print(@c_totalnumber1)
	
	print('15级国家级总人数')
	select @c_totalnumber2 = COUNT(pgrade)
	from team,componentinfo,student
	where team.teamid = componentinfo.teamid
	and componentinfo.stid = student.stid 
	and year(ptime) = @syear 
	and pgrade <> 'NULL' and pgrade <> '省级'
	and student.stid LIKE '15%'
	print(@c_totalnumber2)
END
GO


drop PROC select_2

exec select_2 2020;






