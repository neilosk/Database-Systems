drop table if exists Tours;
drop table if exists Cities;
drop table if exists Racers;
drop table if exists race_in;
drop table if exists Legs;
drop table if exists Stretches;
drop table if exists consist_of;

create table Tours(
    TID integer primary key,
    name varchar not null);

create table Cities(
    CID integer primary key,
    name varchar not null);

create table Racers(
    RID integer primary key,
    name varchar not null);

create table Legs(
    LID integer primary key,
    name varchar not null,
    start_in integer null references Cities(CID),
    end_in integer not null references Cities(CID)
);

create table Stretches(
    LID integer not null references Legs(LID),
    name varchar not null,
    primary key (LID, name)
);

create table consist_of(
    TID integer not null references Tours(TID),
    LID integer not null references Legs(LID),
    RID integer not null references Racers(RID),
    sequence integer not null,
    primary key (TID, LID)
);

create table race_in(
    RID integer not null references Racers(RID),
    LID integer not null references Legs(LID),
    TID integer not null references Tours(TID),
    rank integer not null,
    foreign key (RID, LID) references consist_of(RID, LID),
    primary key (RID, LID, TID)
)





