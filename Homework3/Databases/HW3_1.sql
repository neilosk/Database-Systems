-- QUESTION 1 --
CREATE TABLE People
(
  ID INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  PhoneNumber VARCHAR(20) NOT NULL,
  DOB DATE NOT NULL,
  DOD DATE DEFAULT NULL
);

-- QUESTION 2 --
CREATE TABLE WaspMember
(
  ID INT PRIMARY KEY,
  start_membership DATE,
  FOREIGN KEY (ID) REFERENCES People(ID)
);

CREATE TABLE Enemy
(
  ID INT PRIMARY KEY,
  reason VARCHAR(255) NOT NULL,
  FOREIGN KEY (ID) REFERENCES People(ID)
);


-- QUESTION 3 --
CREATE TABLE WaspAssets
(
 personID INT,
	name VARCHAR(50),
	detail VARCHAR(300) NOT NULL,
	uses VARCHAR(300) NOT NULL,
	PRIMARY KEY (personID, name),
	FOREIGN KEY(personID) REFERENCES member(personID),
	UNIQUE (personID, name)
);

-- QUESTION 4-5 --
CREATE TABLE Linking
(
  ID INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL
);

CREATE TABLE Participates
(
  person_id INT,
  linking_id INT,
  PRIMARY KEY (person_id, linking_id),
  FOREIGN KEY (person_id) REFERENCES People(ID),
  FOREIGN KEY (linking_id) REFERENCES Linking(ID),
  FOREIGN KEY
  (monitoring_member) REFERENCES WaspMember
  (ID)
);

-- QUESTION 6 --
CREATE TABLE Roles
(
  ID INT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  monthly_salary DECIMAL(10, 2) NOT NULL,
  UNIQUE (title, monthly_salary)
);

CREATE TABLE Serve_in
(
  member_id INT,
  role_id INT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  PRIMARY KEY (member_id, role_id),
  FOREIGN KEY (member_id) REFERENCES WaspMember(ID),
  FOREIGN KEY (role_id) REFERENCES Roles(ID)
);

-- QUESTION 7 --
CREATE TABLE Party
(
    ID INT PRIMARY KEY,
    Country VARCHAR(20) NOT NULL,
    Name VARCHAR(255) NULL,
    MemberID INT NOT NULL,
    End_date DATE NOT NULL,
    Start_date DATE PRIMARY KEY,
    UNIQUE (country, name),
    FOREIGN KEY (MemberID) REFERENCES Member (MemberID),
    OPID INT NOT NULL REFERENCES Opponent(ID)
);


-- QUESTION 8 --
CREATE TABLE Sponsor
(
  ID INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  industry VARCHAR(255) NOT NULL
);

CREATE TABLE Grants
(
  sponsor_id INT PRIMARY KEY,
  member_id INT PRIMARY KEY,
  date_awarded DATE PRIMARY KEY,
  amount DECIMAL(10,2) NOT NULL,
  payback VARCHAR(255) NOT NULL,
  FOREIGN KEY (sponsor_id) REFERENCES Sponsor(ID),
  FOREIGN KEY (member_id) REFERENCES WaspMember(ID)
);

-- QUESTION 9 --
CREATE TABLE GrantReview
(
  member_id INT PRIMARY KEY,
  sponsor_id INT PRIMARY KEY,
  review_date DATE NOT NULL,
  grade INT CHECK(grade >= 1 AND grade <= 10) NOT NULL,
  FOREIGN KEY (member_id) REFERENCES WaspMember(ID),
  FOREIGN KEY (sponsor_id) REFERENCES Sponsor(ID)
);

  -- QUESTION 10 --
  CREATE TABLE Opponents (
  ID INT PRIMARY KEY
  EnemyID INT NOT NULL, 
  FOREIGN KEY (EnemyID) REFERENCES Enemy(ID)
  );


  CREATE TABLE OppositionAppointments
  (
    opponent_id INT,
    member_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (opponent_id) REFERENCES Opponents(ID),
    FOREIGN KEY (member_id) REFERENCES WaspMember(ID)
  );

