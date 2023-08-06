--------------------------------------------------

1. HZ -> HC
Decomposed: HZHC
table: HZ(HZ,HC)

CREATE TABLE Rentals2 (
    HZ INT PRIMARY KEY,
    HC VARCHAR(50) NOT NULL,
);

INSERT INTO Rentals2
SELECT HZ, HC
FROM Rentals;


--------------------------------------------------

2. PID -> PN
Decomposed: PIDPN
table: pID(PID,PN)

CREATE TABLE Rentals6 (
    PID INT PRIMARY KEY,
    PN VARCHAR(50) NOT NULL,
);

INSERT INTO Rentals6
SELECT PID, PN
FROM Rentals;


--------------------------------------------------

3. HID -> HS, HZ
Decomposed: HIDHS
table: hID(HID,HS,HZ)

CREATE TABLE Rentals4 (
    HID INT PRIMARY KEY,
    HS VARCHAR(50) NOT NULL,
    HZ INT NOT NULL,
);

INSERT INTO Rentals4
SELECT HID, HS, HZ
FROM Rentals;

--------------------------------------------------


4. PID -> HID, S
Decomposed: PID, HID, S 
table: pID(PID,HID,S)

CREATE TABLE Rentals1 (
    PID INT NOT NULL,
    HID VARCHAR(50) NOT NULL,
    S INT NOT NULL,
    FOREIGN KEY (HID) REFERENCES Rentals3(HID)
    FOREIGN KEY (PID) REFERENCES Rentals2(PID)
    PRIMARY KEY(PID, HID),
);

INSERT INTO Rentals1
SELECT PID, HID, S
FROM Rentals;