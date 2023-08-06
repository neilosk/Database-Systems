create table tours (
	TID int primary key,
	name varchar not null
);

create table cities (
	CID int primary key,
	name varchar not null
);

create table racers (
	RID int primary key,
	name varchar not null
);

create table legs (
	LID int primary key,
	name varchar not null,
	end_at int not null references cities(CID),
	-- Here, the null constraint is important
	start_at int null references cities(CID)
);

create table stretches (
	LID int references legs(LID),
	name varchar not null,
	primary key (LID, name)
);

create table consist_of (
	TID int references tours(TID),
	LID int references legs(LID),
	sequence int not null,
	primary key (TID, LID)
);

create table race_in (
	TID int references tours(TID),
	LID int references legs(LID),
	RID int references racers(RID),
	rank int not null,
	primary key (TId, LID, RID),
	-- Here, the correct foreign key is important
	foreign key (TID, LID) references consist_of(TID, LID)
);

-- alternative and equivalent solution to start_at
create table legs_2 (
	LID int primary key,
	name varchar not null,
	end_at int not null references cities(CID)
);

create table start_at_2 (
	-- Here, the correct primary key is important
	LID integer primary key references legs_2(LID),
	CID integer references cities(CID)
);

-- alternative and equivalent solution to race_in
create table consist_of_2 (
	COID int primary key,
	TID int references tours(TID),
	LID int references legs(LID),
	-- Here, the additional unique constraint is important
	unique (TID, LID),
	sequence int not null
);

create table race_in_2 (
	COID int references consist_of_2,
	RID int references racers(RID),
	rank int not null,
	primary key (COID, RID)
);

