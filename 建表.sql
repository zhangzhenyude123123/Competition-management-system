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
	stime date null,
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
	cname varchar(50) not null,
	cunit varchar(50) not null,
	cgrade char(1) not null check (cgrade in ('A','B','C')),
	cmonth char(1) null,
)

CREATE TABLE directioninfo(
	teamid int references team(teamid),
	tid char(6) references teacher(tid),
	primary key(teamid,tid)
)

CREATE TABLE componentinfo(
	teamid int references team(teamid),
	stid char(6) references student(stid),
	primary key(teamid,stid)
)