-- write the detailed SQL commands to create the resulting tables (with primary keys + foreign keys)
-- and populate them by extracting relevant data from the original relations

FD:
-- Be aware that the attribute S is not a part of any of the relations.
-- So S is a part of the candidate key together with PID and HID

PID -> PN
HID -> HS, HZ -- merged version
HZ -> HC
PID -> HID, S

-- original table
CREATE TABLE Rentals (
       PID INT NOT NULL,
       HID INT NOT NULL, 
       PN VARCHAR(50) NOT NULL, 
       S INT NOT NULL, 
       HS VARCHAR(50) NOT NULL,
       HZ INT NOT NULL, 
       HC VARCHAR(50) NOT NULL,
       PRIMARY KEY (PID, HID)
);

--------------------------------------------------

1. PID -> PN
Decomposed: PIDPN
table: pID(PID,PN)

CREATE TABLE Rentals2 (
    PID INT PRIMARY KEY,
    PN VARCHAR(50) NOT NULL,
);

INSERT INTO Rentals2
SELECT PID, PN
FROM Rentals;

--------------------------------------------------

2. HID -> HS, HZ
Decomposed: HIDHS
table: hID(ID,HS,HZ)

CREATE TABLE Rentals3 (
    HID INT PRIMARY KEY,
    HS VARCHAR(50) NOT NULL,
    HZ INT NOT NULL,
);

INSERT INTO Rentals3
SELECT HID, HS, HZ
FROM Rentals;

--------------------------------------------------

3. HZ -> HC
Decomposed: HZHC
table: HZ(HZ,HC)

CREATE TABLE Rentals1 (
    HZ INT PRIMARY KEY,
    HC VARCHAR(50) NOT NULL,
);

INSERT INTO Rentals1
SELECT HZ, HC
FROM Rentals;

--------------------------------------------------

-- VIGTIGSTE TABELLOS ---

4. PID -> HID, S
Decomposed: PID, HID, S -- S only a candidate key NOT a primary key
table: pID(PID,HID,S)

CREATE TABLE Rentals4 (
    PID INT NOT NULL,
    HID VARCHAR(50) NOT NULL,
    S INT NOT NULL,
    FOREIGN KEY (HID) REFERENCES Rentals3(HID)
    FOREIGN KEY (PID) REFERENCES Rentals2(PID)
    PRIMARY KEY(PID, HID),
);

INSERT INTO Rentals4
SELECT PID, HID, S
FROM Rentals;

-- all tables are now in BCNF (no redundancy)


-- Index selection --

-- Consider the relaiton with info on parts:
-- Part (id, descr, price, stock)

-- stock = quantity
-- price = very high and stocks are very low

-- you are given a set of existing unclustered B+ tree indexes for the Part relation

-- For each query select the index (or indexes) that a good 
-- query optimizer is most likely to use to process the query OR 
-- select 'no index' if a full table scan would yield better performance 
-- than any of the available indexes

The available indexes are:
(a) Part(id)
(b) Part(stock)
(c) Part(price)
(d) Part(stock, price)
(e) Part(stock, price, id)
(f) Part(stock, price, descr)
(g) No index

-- Start by looking at the Where statements

The queries are:
Q1: select id, descr, price
from Part
where stock > 33;
-- (a) Part(stock)

Q2: select stock
from Part
where price = 500;
-- (d) Part(price)
-- point query looking for a single, specific value (might return more than 1)
-- highly selective

Q3: select id
from Part
where stock > (select max(price) from Part); 
-- (a) Part(stock)
-- (c) Part(price)
-- the order is important here - the option Part(price, stock) could also work, but is not an
-- option mentioned.

Q4: select id, descr, price
from Part;
-- no index, will do a full table scan because there is no condition