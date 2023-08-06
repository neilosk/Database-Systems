drop table if exists Teachers;
drop table if exists Censors;
drop table if exists Students;
drop table if exists Lectures;
drop table if exists Attend;
drop table if exists Tutor;

create table Teachers(
    TID integer primary key,
    name varchar not null)

create table Censors(
    CID integer primary key, 
    name varchar not null)

create table Students(
    SID integer primary key,
    TID integer not null references Teachers(TID),
    name varchar not null)

create table Lectures(
    LID integer primary key,
    sunject varchar not null)

create table Attend(
    SID integer not null references Students(SID),
    LID integer not null references Lectures(LID),
    primary key (SID, LID)
);

create table Tutor(
    TID integer not null references Teachers(TID),
    SID integer not null references Students(SID),
    CID integer not null references Censors(CID),
    fromyear integer not null,
    primary key (SID, fromyear)
);



