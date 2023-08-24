create table student 
(
	student_Id varchar(10) not null,
	fname varchar(100) not null,
	phoneN Bigint not null,
	password Binary (64) not null,
	Year int not null,
	semester int not null,
	constraint Student_PK primary key (student_Id),
	constraint Student_PK_chk check (student_Id like '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

);





CREATE TABLE Staff 
(
 Staff_ID VARCHAR(10) NOT NULL,
 First_Name VARCHAR(64) NOT NULL,
 Last_Name VARCHAR(64) NOT NULL,
 Email VARCHAR(64) NOT NULL,
 Password BINARY(64) NOT NULL,
 Role INT DEFAULT NULL,
 CONSTRAINT Staff_PK PRIMARY KEY(Staff_ID),
 CONSTRAINT Staff_PK_chk CHECK(Staff_ID LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-
9]'),
 CONSTRAINT Staff_Email_chk CHECK(Email LIKE '%_@__%.__%')
);


CREATE TABLE Ticket 
(
 ID INT IDENTITY(100,1),
 Ticket_ID AS 'T' + CAST(ID AS VARCHAR(64)) PERSISTED,
 Student_ID VARCHAR(10) NOT NULL,
 Staff_ID VARCHAR(10) DEFAULT NULL,
 Date_Created DATETIME DEFAULT GETDATE() NOT NULL,
 Date_Closed DATETIME DEFAULT NULL,
 Is_Feedback BIT DEFAULT 0 NOT NULL,
 CONSTRAINT Ticket_PK PRIMARY KEY(Ticket_ID),
 CONSTRAINT Ticket_Student_FK FOREIGN KEY(Student_ID) REFERENCES student(student_Id) ON DELETE
CASCADE ON UPDATE CASCADE,
 CONSTRAINT Ticket_Staff_FK FOREIGN KEY(Staff_ID) REFERENCES staff(Staff_ID) ON DELETE SET NULL
ON UPDATE CASCADE,
);

alter table Ticket drop constraint Ticket_PK;
alter table Ticket drop constraint Ticket_Student_FK;
alter table Ticket drop constraint Ticket_Staff_FK;

INSERT INTO student (student_Id, fname, phoneN, password, Year, semester)
VALUES
  ('AB12345678', 'John Doe', 1234567890, 0x12AB34CD56EF78, 2023, 1),
  ('CD98765432', 'Jane Smith', 9876543210, 0x5678901234ABCD, 2022, 2);

INSERT INTO Staff (Staff_ID, First_Name, Last_Name, Email, Password, Role)
VALUES
  ('AB12345678', 'John', 'Doe', 'john@example.com', 0x12AB34CD56EF78, NULL),
  ('CD98765432', 'Jane', 'Smith', 'jane@example.com', 0x5678901234ABCD, 1);

INSERT INTO Ticket (Student_ID, Staff_ID, Date_Created, Date_Closed, Is_Feedback)
VALUES
  ('AB12345678', 'AB12345678', GETDATE(), NULL, 1),
  ('CD98765432', NULL, GETDATE(), GETDATE(), 0);




select * from student;
select * from Ticket;
select * from staff;



drop table student;
drop table Ticket;
drop table staff;