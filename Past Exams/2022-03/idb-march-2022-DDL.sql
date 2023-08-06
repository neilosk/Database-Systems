create table Jojos (
	JID int primary key,
	name varchar not null
);

create table Homes (
	HID int primary key,
	state varchar not null
);

-- Choosing option 2 here
create table Left_For (
	LFID int primary key,
	HID int not null references Homes (HID),
	JID int not null references Jojos (JID),
	what varchar not null,
	unique (fromHID, JID, what)
);

create table Loners (
	LID int primary key,
	status varchar not null,
	LFID int not null references Left_For (LFID),
	to_where varchar not null
);

create table Thought (
	JID int primary key references Jojos (JID),
	LID int not null references Loners (LID),
	lasted varchar not null
);
