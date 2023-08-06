drop table if exists Jojos;
drop table if exists Homes;
drop table if exists left_for;
drop table if exists Loners;
drop table if exists thought;

create table Jojos(
    JID integer primary key,
    name varchar not null)

create table Homes(
    HID integer primary key, 
    state varchar not null)

create table Loners(
    LID integer primary key,
    status  varchar not null)

create table left_for(
    JID integer not null references Jojos(JID),
    HID integer not null references Homes(HID),
    LID integer not null references Loners(LID),
    what varchar not null,
    to_where varchar not null,
    primary key (JID, HID, what)
);

create table thought(
    JID integer not null references Jojos(JID),
    LID integer not null references Loners(LID),
    lasted integer not null,
    primary key (JID)
);