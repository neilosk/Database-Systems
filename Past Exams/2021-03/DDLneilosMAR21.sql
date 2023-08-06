drop table if exists Course;
drop table if exists Student;
drop table if exists Term;
drop table if exists Examiner;

create table Term(
    TID integer primary key,
    desca varchar not null);

create table Student(
    SID integer primary key,
    TID integer not null references Term(TermID));

create table Course(
    CID integer primary key);

create table Examiner(
    EID integer primary key);

create table Takes(
    room varchar not null,
    SID integer not null references Student(SID),
    CID integer not null references Course(CID),
    TID integer not null references Term(TID),
    PRIMARY KEY (SID, CID, TID));
    
create table Grades(
    grade varchar not null,
    EID integer not null references Examiner(EID),
    foreign key (SID, CID, TID) references Takes(SID, CID, TID)
    PRIMARY KEY (SID, CID, TID, EID));