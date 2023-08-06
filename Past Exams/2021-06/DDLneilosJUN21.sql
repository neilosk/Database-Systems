drop table if exists E1;
drop table if exists E2;
drop table if exists E3;
drop table if exists E4;

create table E1(
    E1ID integer primary key,
    E2ID integer not null references E2(E2ID));

create table E3(
    E3ID integer primary key,
    E1ID integer not null references E1(E1ID));

create table E5(
    E5ID integer primary key);

create table E4(
    E4ID integer primary key,
    E5ID integer not null references E5(E5ID));

create table E2(
    E2ID integer primary key);

create table R1(
    E1ID integer not null references E1(E1ID),
    E2ID integer not null references E2(E2ID),
    primary key (E1ID, E2ID));

create table R3(
    E4ID integer not null references E4(E4ID),
    E5ID integer not null references E5(E5ID),
    primary key (E4ID, E5ID));

create table R2(
    E1ID integer not null references E1(E1ID),
    E2ID integer not null references E2(E2ID),
    E5ID integer not null references E3(E3ID),
    E4ID integer not null references E4(E4ID),
    FOREIGN KEY (E1ID, E2ID) REFERENCES R1(E1ID, E2ID),
    FOREIGN KEY (E4ID, E5ID) REFERENCES R3(E4ID, E5ID),
    primary key (E1ID, E2ID, E5ID, E4ID));
