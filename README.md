# Competition-management-system
 ### **大学生竞赛管理系统设计**

一个学生可以参加多个学科竞赛，竞赛分为不同等级，按照重要性可以分为 A 类、B类和 C 类，学生可以多人组队参加一个比赛，每个队可以有多个指导教师，竞赛成绩按照
获奖级别有国家级和省级，分为一等奖、二等奖、三等奖，每种竞赛每年都有相对固定的比赛时间、名称和主办机构。试设计一个大学生竞赛管理系统，能够完成对学生竞赛的管理，可以实现统计高校各个学院某个时间段内竞赛的参加和获奖情况，也可以统计每个同学或每个年级某个时间段内竞赛的参加和获奖情况。

**(1)画出系统的 E-R 图，给出实体或联系的属性，标明联系的种类；**
![image](https://user-images.githubusercontent.com/60837761/103448781-4ee24d00-4cd9-11eb-9715-eed275a9d2b9.png)

**(2)写出关系模式；**
学院（学院号，学院名称，成立时间）
专业（专业号，专业名称，学院号）
学生（学号，姓名，班级，专业号）
团队（团队编号，项目名称，团队名称，竞赛编号，获奖级别，获奖奖项，开始时间，获奖时间）
竞赛（竞赛编号，名称，主办方，等级，比赛月份）
老师（工号，姓名，职称）
团队指导（团队编号，工号）
团队组成（团队编号，学号）

**(3)根据关系规范理论进行数据库的逻辑设计，给出数据库表的设计，数据库表设计格 式参照下面：**

表 1 学院表（college）
字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
collegekey | 学院号 | int | 主键 |  
name | 学院名称 | char(30) | not null |  
collegetime | 成立时间 | date | null |  


表 2 专业表（major）
字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
majorkey | 专业号 | char(6) | 主键 |  
majorname | 专业名称 | varchar(30) | null |  
collegekey | 学院号 | int | null | 外键，参照college表的collegekey

表 3 学生表（student）
字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
stid | 学号 | char(6) | 主键 |  
sname | 姓名 | char(20) | null |  
class | 班级 | char(20) | null |  
majorkey | 专业号 | char(6) | null | 外键，参照major表的majorkey

表 4 团队表（team）
字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
teamid | 团队编号 | int | 主键 |  
pname | 项目名称 | varchar(30) | null |  
tname | 团队名称 | varchar(30) | null |  
cid | 竞赛编号 | int | null | 外键，参照competeinfo表的cid
stime | 开始时间 | date | null |  
pgrade | 获奖级别 | char(10) | null |  
pburse | 获奖奖项 | char(10) | null |  
ptime | 获奖时间 | date | null |  

表 5 老师表（teacher）
字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
tid | 工号 | char(6) | 主键 |  
tname | 姓名 | char(20) | null |  
title | 职称 | char(20) | null |  

表 6 竞赛表（competeinfo）
字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
cid | 竞赛编号 | int | 主键 |  
cname | 竞赛名称 | varchar(100) | not null |  
cunit | 主办方 | varchar(100) | not null |  
cgrade | 竞赛等级 | char(1) | not null | 取值为A、B、C中一个
cmonth | 比赛月份 | char(2) | null |  

表 7 团队指导表（directioninfo）

字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
teamid | 团队编号 | int | 外键，参照team表的teamid | teamid和tid联合作为主键
tid | 工号 | char(6) | 外键，参照teacher表的tid

表 8 团队组成表（componentinfo）

字段名 | 中文含义 | 类型 | 约束 | 备注
-- | -- | -- | -- | --
teamid | 团队编号 | int | 外键，参照team表的teamid | teamid和stid联合作为主键
stid | 学号 | char(6) | 外键，参照student表的stid

**(5)在 Sql server 数据库中创建数据库 test 并创建相应的数据库表；** 
**(6)可以通过导入文件的方式在数据库表中输入若干条数据；** 
通过SQL Server导入各表数据：
在sql server中创建bigtest数据库，使用如下语句进行数据库建表  
CREATE TABLE college(  
	collegekey int primary key,  
	name char(30) not null,	  
	collegetime date null  
)  
  
CREATE TABLE major(  
	majorkey char(6) primary key,  
	majorname varchar(30) null,  
	collegekey int null references college(collegekey)  
)    

CREATE TABLE student(  
	stid char(6) primary key,  
	sname char(20) null,  
	class char(20) null,  
	majorkey char(6) null references major(majorkey)  
)  

CREATE TABLE team(  
	teamid int primary key,  
	pname varchar(30) null,  
	tname varchar(30) null,  
	cid int null references competeinfo(cid),  
	pgrade char(10) null,  
	pburse char(10) null,  
	ptime date null  
)  

CREATE TABLE teacher(  
	tid char(6) primary key,  
	tname char(20) null,  
	title char(20) null  
)  

CREATE TABLE competeinfo(  
	cid int primary key,  
	cname varchar(100) not null,  
	cunit varchar(100) not null,  
	cgrade char(1) not null check (cgrade in ('A','B','C')),  
	cmonth char(2) null,  
)  

CREATE TABLE directioninfo(  
	teamid int references team(teamid),  
	tid char(6) references teacher(tid),  
	primary key(teamid,tid)  
)  

**(7)自己构造若干 SQL 语句，完成对数据库的调用、并实现题目所给统计要求，SQL 语 句至少为 10 条，要求自定义功能要求，并给出 SQL 语句结果，包括下面的语句：
create table 、create index 、 create view 、 select 语句 (至少 3 条，要把子句用上， 包括 from 子句、where 字句、group by 子句、having 字句、order by 子句)、insert 语句、 delete 语句、update 语句、grant 语句**

**create index语句：**  
**把student表中按学号升序和班级降序的建立索引**  
create index studentindexs  
on student(stid asc,class desc)  
  
把team表中按竞赛号降序建立索引  
create index team_index  
on team(cid desc)    
![image](https://user-images.githubusercontent.com/60837761/103448825-1000c700-4cda-11eb-9098-94173e545f5b.png)  

  
**create view语句：**  
**创建一个视图Viewprize，统计人工智能学院不同专业国家级、省级的获奖总数量**  
  
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
![image](https://user-images.githubusercontent.com/60837761/103448827-198a2f00-4cda-11eb-8e4f-d06b43e51d82.png)
  
**insert语句：**  
**插入一条学生数据**  
insert student  
values('151020','张杰','计141','080901')  
 
![image](https://user-images.githubusercontent.com/60837761/103448830-2575f100-4cda-11eb-9a13-5d117781fa4e.png)
  
**插入一条团队数据**  
insert team values(26,'面向未来的系统','未来',16,'2019/8/29',NULL,NULL,NULL)  
![image](https://user-images.githubusercontent.com/60837761/103448832-2d359580-4cda-11eb-818e-74becf3535b4.png)
![image](https://user-images.githubusercontent.com/60837761/103448835-2f97ef80-4cda-11eb-8b55-7a9ac105492a.png)

**delete语句：**  
**删除学号为151020的student信息**  
delete student  
where stid = '151020';  
  
**删除“面向未来的系统”队名的team信息**  
delete team  
where pname = '面向未来的系统'  
  
**update 语句**  
更新“未来1”队的指导老师  
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

**grant 语句**  
**创建团队管理员角色，对team表有查找更新插入权限，创建用户，分配团队管理员角色**  
create login zzy with password = 'abc',default_database = bigtestnew  
create user zzy for login zzy  

create role team_manager  
grant select,insert,update   
on team  
to team_manager  

exec sp_addrolemember 'team_manager','zzy'  
![image](https://user-images.githubusercontent.com/60837761/103448845-48a0a080-4cda-11eb-8773-d0619a37df04.png)
![image](https://user-images.githubusercontent.com/60837761/103448848-4a6a6400-4cda-11eb-9040-317f4844e73a.png)
![image](https://user-images.githubusercontent.com/60837761/103448851-4cccbe00-4cda-11eb-9720-ba99ebe24054.png)

**select语句：**  
**查询未来1队的指导老师信息**    
select *  
from teacher,directioninfo  
where directioninfo.tid = teacher.tid  
and directioninfo.teamid =   
(select teamid  
from team   
where team.tname = '未来')  
 

**查询计算机科学与技术专业的团队参加获奖情况**  
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

**统计人工智能与数据科学学院的省级获取情况**  
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
  
**统计不同学院的专业的竞赛获奖情况**  
select college.name,pgrade,major.majorname,COUNT(pgrade) as num  
from team,componentinfo,student,major,college  
where team.teamid = componentinfo.teamid  
and componentinfo.stid = student.stid  
and student.majorkey = major.majorkey  
and major.collegekey = college.collegekey  
group by college.name,majorname,pgrade  
having pgrade <> 'NULL'  
order by num  

**(9)对于复杂的报表查询逻辑处理和自定义完整性，使用存储过程或触发器来完成。**  
1.查询学院不同年份，不同月份，各专业省级、国家级竞赛获奖总人数，各学院的省级获奖情况，各学院的国家级获奖情况，学校获奖省级总人数，学校获奖国家级总人数。  
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
![image](https://user-images.githubusercontent.com/60837761/103448863-7d145c80-4cda-11eb-8cab-352de3d6ebed.png)
![image](https://user-images.githubusercontent.com/60837761/103448866-80a7e380-4cda-11eb-8efa-9c2c50cfbf8e.png)
![image](https://user-images.githubusercontent.com/60837761/103448869-843b6a80-4cda-11eb-94ef-02ce411e1093.png)



