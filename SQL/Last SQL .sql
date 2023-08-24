USE master;

GO
CREATE TABLE Student
(
    Student_ID VARCHAR(10) NOT NULL,
    First_Name VARCHAR(64) NOT NULL,
    Last_Name VARCHAR(64) NOT NULL,
    Phone_Number BIGINT NOT NULL,
    Password BINARY(64) NOT NULL,
    Year INT NOT NULL,
    Semester INT NOT NULL,
    Level_Of_Completion VARCHAR(64) DEFAULT NULL,
    CONSTRAINT Student_PK PRIMARY KEY(Student_ID),
    CONSTRAINT Student_PK_chk CHECK(Student_ID LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT Chk_PN CHECK(Phone_Number BETWEEN 94700000000 AND 94799999999),
    CONSTRAINT Chk_Yr CHECK((Level_Of_Completion IS NULL AND Year BETWEEN 1 AND 4) OR (Level_Of_Completion IS NOT NULL AND Year BETWEEN 1 AND 2)),
    CONSTRAINT Chk_sem CHECK(Semester BETWEEN 1 AND 2)
);

CREATE TABLE Staff_Role
(
    Role_ID INT NOT NULL,
    Role_Title VARCHAR(64) NOT NULL,
    Description VARCHAR(200) DEFAULT NULL,
    CONSTRAINT Role_PK PRIMARY KEY(Role_ID)
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
    CONSTRAINT Staff_PK_chk CHECK(Staff_ID LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT Staff_Email_chk CHECK(Email LIKE '%_@__%.__%'),
    CONSTRAINT Staff_Role_FK FOREIGN KEY(Role) REFERENCES Staff_Role(Role_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Staff_Phone_Number
(
    Phone_Number BIGINT NOT NULL,
    Staff_ID VARCHAR(10) NOT NULL,
    CONSTRAINT SPN_PK PRIMARY KEY(Phone_Number),
    CONSTRAINT SPN_chk CHECK(Phone_Number BETWEEN 94700000000 AND 94799999999),
    CONSTRAINT SPN_FK FOREIGN KEY(Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Priority
(
    ID INT IDENTITY(1,1),
    Category_Name VARCHAR(64) NOT NULL,
    Note VARCHAR(200) DEFAULT NULL,
    CONSTRAINT Priority_PK PRIMARY KEY(ID)
);

CREATE TABLE Issue
(
    ID INT IDENTITY(100,1),
    Issue_ID AS 'I' + CAST(ID AS VARCHAR(64)) PERSISTED,
    Subject VARCHAR(200) NOT NULL,
    Description VARCHAR(800) DEFAULT NULL,
    Priority INT DEFAULT NULL,
    Encounters INT NOT NULL,
    CONSTRAINT Issue_PK PRIMARY KEY(Issue_ID),
    CONSTRAINT Issue_Priority_FK FOREIGN KEY(Priority) REFERENCES Priority(ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Feedback
(
    ID INT IDENTITY(100,1),
    Feedback_ID AS 'F' + CAST(ID AS VARCHAR(64)) PERSISTED,
    Subject VARCHAR(200) NOT NULL,
    Description VARCHAR(800) DEFAULT NULL,
    Rating INT DEFAULT 1 NOT NULL,
    CONSTRAINT Feedback_PK PRIMARY KEY(Feedback_ID)
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
    CONSTRAINT Ticket_Student_FK FOREIGN KEY(Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Ticket_Staff_FK FOREIGN KEY(Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE SET NULL ON UPDATE CASCADE,
);

CREATE TABLE Issue_Solution
(
    Ticket_ID VARCHAR(65) NOT NULL,
    Issue_ID VARCHAR(65),
    Solution VARCHAR(800) DEFAULT NULL,
    CONSTRAINT ISolution_Ticket_FK FOREIGN KEY(Ticket_ID) REFERENCES Ticket(Ticket_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ISolution_Issue_FK FOREIGN KEY(Issue_ID) REFERENCES Issue(Issue_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ISolution_PK PRIMARY KEY(Ticket_ID)
);

CREATE TABLE Feedback_Reply
(
    Ticket_ID VARCHAR(65) NOT NULL,
    Feedback_ID VARCHAR(65),
    Reply VARCHAR(800) DEFAULT NULL,
    CONSTRAINT FReply_Ticket_FK FOREIGN KEY(Ticket_ID) REFERENCES Ticket(Ticket_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FReply_Issue_FK FOREIGN KEY(Feedback_ID) REFERENCES Feedback(Feedback_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FReply_PK PRIMARY KEY(Ticket_ID)
);

CREATE TABLE Thread_Category
(
    Category_ID INT NOT NULL,
    Category_Name VARCHAR(64) NOT NULL,
    CONSTRAINT TCategory_PK PRIMARY KEY(Category_ID)
);

CREATE TABLE Thread_Topic
(
    Topic_ID INT IDENTITY(1,1) NOT NULL,
    Started_By VARCHAR(10) DEFAULT NULL,
    Authorized_By VARCHAR(10) DEFAULT NULL,
    Title VARCHAR(200) NOT NULL,
    Description VARCHAR(800) DEFAULT NULL,
    Category INT NOT NULL,
    Created_At DATETIME DEFAULT GETDATE() NOT NULL,
    Status BIT DEFAULT 1 NOT NULL,
    Rating INT DEFAULT 0 NOT NULL,
    CONSTRAINT TTopic_PK PRIMARY KEY(Topic_ID),
    CONSTRAINT TTopic_Student_FK FOREIGN KEY(Started_By) REFERENCES Student(Student_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT TTopic_Staff_Auth_FK FOREIGN KEY(Authorized_By) REFERENCES Staff(Staff_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT TTopic_Category_FK FOREIGN KEY(Category) REFERENCES Thread_Category(Category_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Thread_Reply
(
    Topic_ID INT NOT NULL,
    Reply_ID INT DEFAULT 1,
    Student_ID VARCHAR(10) DEFAULT NULL,
    Staff_ID VARCHAR(10) DEFAULT NULL,
    Date_Time DATETIME DEFAULT GETDATE() NOT NULL,
    Comment VARCHAR(800) NOT NULL,
    Rating INT DEFAULT 0 NOT NULL,
    CONSTRAINT TReply_TTopic_FK FOREIGN KEY(Topic_ID) REFERENCES Thread_Topic(Topic_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT TReply_PK PRIMARY KEY(Topic_ID, Reply_ID),
    CONSTRAINT TReply_Student_FK FOREIGN KEY(Student_ID) REFERENCES Student(Student_ID),
    CONSTRAINT TReply_Staff_FK FOREIGN KEY(Staff_ID) REFERENCES Staff(Staff_ID)
);

CREATE TABLE Knowledge_Base_Category
(
    Category_ID INT IDENTITY(1,1) NOT NULL,
    Category_Name VARCHAR(64) NOT NULL,
    CONSTRAINT KBC_PK PRIMARY KEY(Category_ID)
);

CREATE TABLE Knowledge_Base
(
    KB_ID INT IDENTITY(1,1) NOT NULL,
    Author_ID VARCHAR(10),
    Title VARCHAR(200) NOT NULL,
    Description VARCHAR(800) DEFAULT NULL,
    Category INT NOT NULL,
    Created_At DATETIME DEFAULT GETDATE() NOT NULL,
    Updated_AT DATETIME DEFAULT GETDATE() NOT NULL,
    CONSTRAINT KB_PK PRIMARY KEY(KB_ID),
    CONSTRAINT KB_Staff_FK FOREIGN KEY(Author_ID) REFERENCES Staff(Staff_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT KB_Category_FK FOREIGN KEY(Category) REFERENCES Knowledge_Base_Category(Category_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Knowledge_Base_Attachment
(
    KB_ID INT NOT NULL,
    Attachment_ID INT IDENTITY(1,1) NOT NULL,
    Attachment VARCHAR(200) NOT NULL,
    CONSTRAINT KB_Attachment_FK FOREIGN KEY(KB_ID) REFERENCES Knowledge_Base(KB_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT KB_Attachment_PK PRIMARY KEY(KB_ID, Attachment_ID),
);

CREATE TABLE Hotline
(
    Hotline_Number BIGINT NOT NULL,
    Description VARCHAR(64) NOT NULL,
    CONSTRAINT Hotline_PK PRIMARY KEY(Hotline_Number),
    CONSTRAINT HL_Chk CHECK(Hotline_Number BETWEEN 94110000000 AND 94819999999)
);

CREATE TABLE Call
(
    Start_Time DATETIME DEFAULT GETDATE() NOT NULL,
    Caller_Phone_Number BIGINT NOT NULL,
    Student_ID VARCHAR(10) NOT NULL,
    End_Time DATETIME DEFAULT NULL,
    Hotline_Number BIGINT,
    Staff_ID VARCHAR(10),
    Description VARCHAR(200),
    CONSTRAINT Call_PN_Chk CHECK(Caller_Phone_Number BETWEEN 94110000000 AND 94819999999),
    CONSTRAINT Call_PK PRIMARY KEY(Start_Time, Caller_Phone_Number),
    CONSTRAINT Call_Student_FK FOREIGN KEY(Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Call_Hotline_FK FOREIGN KEY(Hotline_Number) REFERENCES Hotline(Hotline_Number) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT Call_Staff_FK FOREIGN KEY(Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

GO

/*
   This trigger handles the insertion of rows into the Thread_Reply table.
   It overrides the default INSERT behavior and provides custom logic for inserting rows.
   The trigger assigns a unique Reply_ID for each inserted row based on the Topic_ID.
   If the Topic_ID is new, the Reply_ID starts from 1. Otherwise, it increments the maximum Reply_ID by 1.
   The trigger inserts the modified rows into the Thread_Reply table and processes the next row until all rows are inserted.
*/

CREATE OR ALTER TRIGGER TRG_Thread_Reply ON Thread_Reply INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON
    DECLARE @InsertedRows TABLE
    (
        Topic_ID INT,
        Reply_ID INT NULL,
        Student_ID VARCHAR(10),
        Staff_ID VARCHAR(10),
        Comment VARCHAR(800)
    )

    INSERT INTO @InsertedRows
        (Topic_ID, Reply_ID, Student_ID, Staff_ID, Comment)
    SELECT Topic_ID, Reply_ID, Student_ID, Staff_ID, Comment
    FROM INSERTED

    DECLARE @T_ID INT
    DECLARE @R_ID INT
    DECLARE @Student_ID VARCHAR(10)
    DECLARE @Staff_ID VARCHAR(10)
    DECLARE @C VARCHAR(800)

    WHILE EXISTS (SELECT *
    FROM @InsertedRows)
    BEGIN
        SELECT TOP 1
            @T_ID = Topic_ID, @Student_ID = Student_ID, @Staff_ID = Staff_ID, @C = Comment
        FROM @InsertedRows

        IF NOT EXISTS (SELECT *
        FROM Thread_Reply
        WHERE Topic_ID = @T_ID)
            SET @R_ID = 1
        ELSE
            SET @R_ID = (SELECT MAX(T.Reply_ID) + 1
        FROM Thread_Reply T
        WHERE T.Topic_ID = @T_ID)

        INSERT INTO Thread_Reply
            (Topic_ID, Reply_ID, Student_ID, Staff_ID, Comment)
        VALUES
            (@T_ID, @R_ID, @Student_ID, @Staff_ID, @C)

        DELETE TOP (1) FROM @InsertedRows
    END
END

GO
INSERT INTO Student
    (Student_ID, First_Name, Last_Name, Phone_Number, Password, Year, Semester, Level_Of_Completion)
VALUES
    ('IT12345768', 'John', 'Doe', 94712345678, 0x39A4D0DC216628A7B4F0754B942A7B12683EDE7CB8ED6F4F034B4B9A7C0B6AAE, 2, 1, 'BSC'),
    ('IT98765432', 'Jane', 'Smith', 94723456789, 0x3BE7C03B69A7281A9E7CECB697F0CDAE0A07BBD7B2C389292D9D4503A1E690AA, 1, 1, NULL),
    ('EN54321098', 'David', 'Johnson', 94734567890, 0xA42D1A1D6D44F36FCE9AAB68F59BC875B9F170C8FA9BB823B2BAA2A5D34D58D0, 1, 1, 'MSC'),
    ('DS67890123', 'Sarah', 'Williams', 94745678901, 0x5B49D6F6D1101B3D01B048A57DAD8531E295D7EBDA879C1ED5C960C0B7C61F3F, 2, 1, 'BSC'),
    ('IT34567890', 'Michael', 'Brown', 94756789012, 0xF87CE40D4F0AB559AED1D91E011B47B50AFA78A2DBCA0499F740DBAACD313B60, 2, 1, 'MSC'),
    ('EN90123456', 'Emily', 'Taylor', 94767890123, 0x1B3C086DD2EE4F1D35B9C5EBDCED654A0C109D2A854A13C3FCAAE913378B99ED, 1, 2, NULL),
    ('IT56789012', 'Andrew', 'Anderson', 94778901234, 0xE7A7A2376BB6156E10C7D18E52CDA3B3B27DBF2A8F68D02793F2D7C9BEA6090B, 2, 1, 'MSC'),
    ('EN12345678', 'Olivia', 'Lee', 94789012345, 0x64DCC6348BDFC8E89DD6F255AAE97F53FD54271B1C43A4C0B924B1D4A18118D1, 2, 1, 'BSC'),
    ('DS09876543', 'Daniel', 'Clark', 94790123456, 0x3B2A85A8DCD8D17F26A60A4D89DD754B137BCD9A4C83D5A254438927D576A2FA, 4, 1, NULL),
    ('IT65432109', 'Sophia', 'Walker', 94701234567, 0xA5C3DA3C46C5C81EB80C65C5DD2E6C3A604EF7396F36F03F4DC0A81E2E6D149A, 1, 1, 'MSC');

INSERT INTO Staff_Role
    (Role_ID, Role_Title, Description)
VALUES
    (1, 'Administrator', 'Responsible for system administration and management.'),
    (2, 'Student Advisor', 'Provides guidance and support to students.'),
    (3, 'Faculty Member', 'Teaches courses and conducts research.'),
    (4, 'IT Specialist', 'Handles technical issues and system maintenance.'),
    (5, 'Librarian', 'Manages library resources and assists patrons.'),
    (6, 'Accountant', 'Handles financial transactions and manages budgets.'),
    (7, 'HR Manager', 'Oversees human resources activities.'),
    (8, 'Marketing Specialist', 'Promotes products and services.'),
    (9, 'Customer Service Representative', 'Assists customers with inquiries and issues.'),
    (10, 'Research Assistant', 'Provides support to research projects.');

INSERT INTO Staff
    (Staff_ID, First_Name, Last_Name, Role, Email, Password)
VALUES
    ('AB12345678', 'John', 'Doe', 1, 'john.doe@example.com', 0xE1B22E91B8CE3DFE451F1C424DE4F5D86B5D02C6BC485DD7FDC2544E446E63EF),
    ('CD98765432', 'Jane', 'Smith', 2, 'jane.smith@example.com', 0x8C3C55CFF40B0A0F7C7BDC2CC4E139682A2F6C85B0065E1D54D6B1F97B96ACFB),
    ('EF54321098', 'David', 'Johnson', 3, 'david.johnson@example.com', 0x2AC2952A83F70A0A580254A6996F3F0B7D1ED0B246BB3C378A99CB2974A687D3),
    ('GH67890123', 'Sarah', 'Williams', 4, 'sarah.williams@example.com', 0x5638F31B721C4847ECA5B11C085DC7E542D61AB7B8E77736B8F2E352DD1A7231),
    ('IJ34567890', 'Michael', 'Brown', 5, 'michael.brown@example.com', 0x8E138826FA4F4DBAC227DAD8A334D4C2670CB83991B15C4F0850A365F6E127A1),
    ('KL90123456', 'Emily', 'Taylor', 6, 'emily.taylor@example.com', 0xAED5A378B314DE3F2A2BBFC03669A1DEA2AE6A05C7B6B4E3610576ACD8D9E1BC),
    ('MN56789012', 'Andrew', 'Anderson', 7, 'andrew.anderson@example.com', 0x2B89C4DAF6F7D4145A73D5C6AF0A7D2D7523D22C79F16669229B186C8D46F35B),
    ('OP12345678', 'Olivia', 'Lee', 8, 'olivia.lee@example.com', 0xB950CAB8A4C5C5B70F8AFC098E3CDA0AB7C3FCD566DACEE346AF881E2D0C1C22),
    ('QR09876543', 'Daniel', 'Clark', 9, 'daniel.clark@example.com', 0xE2FEB8C0A70A04D1252EAD6C5E43D3778C47E91C399E5B3F6119CE4807E6C086),
    ('ST65432109', 'Sophia', 'Walker', 10, 'sophia.walker@example.com', 0x3AF4D88F75C1955C3342B16D5A25425BFD32A1C6A37C998DBB7CC7277EBA4ED1);

INSERT INTO Staff_Phone_Number
    (Phone_Number, Staff_ID)
VALUES
    (94712345678, 'AB12345678'),
    (94723456789, 'CD98765432'),
    (94734567890, 'EF54321098'),
    (94745678901, 'GH67890123'),
    (94756789012, 'IJ34567890'),
    (94767890123, 'KL90123456'),
    (94778901234, 'MN56789012'),
    (94789012345, 'OP12345678'),
    (94790123456, 'QR09876543'),
    (94701234567, 'ST65432109');

INSERT INTO Priority
    (Category_Name, Note)
VALUES
    ('Technical Issue', 'Student is unable to log in to the online portal.'),
    ('Registration Assistance', 'Student needs help with course registration for the upcoming semester.'),
    ('Password Reset', 'Student forgot their password and needs to reset it.'),
    ('Network Connectivity', 'Student is experiencing difficulties connecting to the campus Wi-Fi.'),
    ('Email Access', 'Student cannot access their university email account.'),
    ('Software Installation', 'Student needs assistance installing a required software for a course.'),
    ('Printing Problem', 'Student is unable to print documents from the university computers.'),
    ('Library Support', 'Student requires guidance in finding research materials in the library.'),
    ('Financial Aid Inquiry', 'Student has questions regarding financial aid eligibility and application.'),
    ('General Information', 'Student seeks general information about campus services and facilities.');

INSERT INTO Issue
    (Subject, Description, Priority, Encounters)
VALUES
    ('Login Error', 'Unable to login to the online portal. Receive error message "Invalid username or password."', 1, 5),
    ('Course Registration Issue', 'Encountering an error when trying to register for courses for the upcoming semester.', 2, 3),
    ('Password Reset Request', 'Forgot password and need assistance in resetting it.', 3, 2),
    ('Wi-Fi Connectivity Problem', 'Experiencing difficulties connecting to the campus Wi-Fi network.', 4, 1),
    ('Email Access Problem', 'Unable to access university email account. Getting an "access denied" message.', 5, 4),
    ('Software Installation Failure', 'Encountering errors while trying to install required software for a course.', 6, 2),
    ('Printing Error', 'Unable to print documents from the university computers. Printer shows offline.', 7, 3),
    ('Library Resources Assistance', 'Require help in locating research materials in the library for a project.', 8, 1),
    ('Financial Aid Inquiry', 'Need information regarding financial aid eligibility and application process.', 9, 2),
    ('General Information Request', 'Seeking general information about campus services and facilities.', 10, 3);

INSERT INTO Feedback
    (Subject, Description, Rating)
VALUES
    ('Excellent Service', 'I am highly satisfied with the support provided. The staff was very helpful and resolved my issue promptly.', 5),
    ('Registration Assistance Feedback', 'The support staff guided me through the registration process and answered all my queries. Great experience!', 4),
    ('Password Reset Feedback', 'The staff promptly helped me reset my password and provided clear instructions. Thank you!', 4),
    ('Wi-Fi Connectivity Feedback', 'The Wi-Fi issue was resolved quickly, and I can now connect to the network without any problems.', 3),
    ('Email Access Feedback', 'The staff assisted me in accessing my email account, but it took a bit longer than expected. Overall, a satisfactory experience.', 3),
    ('Software Installation Feedback', 'The staff helped me install the required software, but I encountered some minor issues during the process.', 3),
    ('Printing Support Feedback', 'The printer issue was resolved, but it took a few attempts. Nevertheless, I appreciate the assistance.', 2),
    ('Library Assistance Feedback', 'The staff provided adequate guidance for finding research materials in the library. It was a decent experience.', 4),
    ('Financial Aid Inquiry Feedback', 'The support staff answered my questions about financial aid, but I felt they lacked detailed information.', 2),
    ('General Information Feedback', 'The staff provided the basic information I needed, but I had to follow up with additional questions.', 3);

INSERT INTO Ticket
    (Student_ID, Staff_ID, Date_Created, Date_Closed, Is_Feedback)
VALUES
    ('IT12345768', 'CD98765432', '2023-03-12 09:23:45', NULL, 1),
    ('EN54321098', 'GH67890123', '2023-04-15 14:30:10', '2023-04-17 11:45:20', 0),
    ('DS67890123', 'KL90123456', '2023-03-28 10:10:20', NULL, 1),
    ('IT34567890', 'OP12345678', '2023-04-19 12:35:45', '2023-04-20 09:10:55', 0),
    ('EN12345678', 'GH67890123', '2023-05-10 15:45:30', NULL, 1),
    ('DS09876543', 'KL90123456', '2023-03-15 08:20:40', '2023-03-17 13:05:25', 1),
    ('IT65432109', 'OP12345678', '2023-04-05 11:30:15', NULL, 0),
    ('EN54321098', 'OP12345678', '2023-04-05 11:30:15', NULL, 0),
    ('IT12345768', 'AB12345678', '2023-05-19 09:00:00', '2023-05-19 10:30:00', 1),
    ('EN54321098', 'CD98765432', '2023-05-19 10:15:00', NULL, 1),
    ('IT34567890', 'IJ34567890', '2023-05-19 13:15:00', NULL, 0),
    ('EN12345678', 'KL90123456', '2023-05-19 14:30:00', '2023-05-19 15:00:00', 1),
    ('IT65432109', 'QR09876543', '2023-05-19 17:00:00', '2023-05-19 18:15:00', 1),
    ('EN54321098', 'ST65432109', '2023-05-19 18:45:00', '2023-05-19 19:30:00', 0),
    ('IT12345768', 'CD98765432', '2023-05-19 09:00:00', '2023-05-19 10:30:00', 0),
    ('EN54321098', 'GH67890123', '2023-05-19 10:15:00', NULL, 1),
    ('IT34567890', 'IJ34567890', '2023-05-19 13:15:00', NULL, 0),
    ('EN12345678', 'KL90123456', '2023-05-19 14:30:00', '2023-05-19 15:00:00', 1),
    ('IT65432109', 'QR09876543', '2023-05-19 17:00:00', '2023-05-19 18:15:00', 0),
    ('EN54321098', 'ST65432109', '2023-05-19 18:45:00', '2023-05-19 19:30:00', 0);


INSERT INTO Issue_Solution
    (Ticket_ID, Issue_ID, Solution)
VALUES
    ('T101', 'I100', 'The issue was resolved by resetting the student''s password.'),
    ('T103', 'I101', 'Assisted the student in completing the course registration process.'),
    ('T106', 'I102', 'Provided step-by-step instructions to reset the password.'),
    ('T107', 'I103', 'Adjusted the Wi-Fi settings and resolved the connectivity issue.'),
    ('T110', 'I104', 'Reset the student''s email account password and restored access.'),
    ('T113', 'I105', 'Reinstalled the software and resolved the installation error.'),
    ('T114', 'I106', 'Fixed the printer connectivity issue, enabling successful printing.'),
    ('T116', 'I107', 'Assisted the student in finding the required library resources.'),
    ('T118', 'I108', 'Provided information on financial aid eligibility and application process.'),
    ('T119', 'I109', 'Gave an overview of campus services and facilities available to the student.');

INSERT INTO Feedback_Reply
    (Ticket_ID, Feedback_ID, Reply)
VALUES
    ('T100', 'F100', 'Thank you for your positive feedback! We are glad that we could assist you.'),
    ('T102', 'F101', 'We appreciate your feedback and will strive to improve our registration assistance services.'),
    ('T104', 'F102', 'We apologize for any inconvenience caused. We will work on providing clearer password reset instructions.'),
    ('T105', 'F103', 'Thank you for your feedback. We will continue to improve the Wi-Fi connectivity for better user experience.'),
    ('T108', 'F104', 'We apologize for the delay in resolving your email access issue. We will address this internally.'),
    ('T109', 'F105', 'We appreciate your feedback and will look into the software installation issues you encountered.'),
    ('T111', 'F106', 'We apologize for the inconvenience caused by the printing problem. Our team is investigating the issue.'),
    ('T112', 'F107', 'Thank you for your feedback. We will continue to assist students in finding library resources.'),
    ('T115', 'F108', 'We apologize if we could not provide detailed information regarding financial aid. We will strive to improve our responses.'),
    ('T117', 'F109', 'Thank you for your feedback. We will work on providing more comprehensive information about campus services.');

INSERT INTO Thread_Category
    (Category_ID, Category_Name)
VALUES
    (1, 'Course Registration'),
    (2, 'Accessing Online Resources'),
    (3, 'Assignment Queries'),
    (4, 'Research Topic Guidance'),
    (5, 'Lost Student ID Card'),
    (6, 'Part-Time Job Recommendations'),
    (7, 'Course Material Accessibility'),
    (8, 'Course Transfer Request'),
    (9, 'Lecture Timing Concerns'),
    (10, 'Study Schedule Assistance');

INSERT INTO Thread_Topic
    (Started_By, Authorized_By, Title, Description, Category)
VALUES
    ('IT12345768', 'CD98765432', 'Need help with course registration', 'I''m having trouble registering for my courses. Can someone assist me?', 1),
    ('EN54321098', 'EF54321098', 'Trouble accessing online resources', 'I''m unable to access the online library and other resources. Any suggestions?', 2),
    ('DS67890123', 'GH67890123', 'Query regarding assignment deadline', 'I have a question about the deadline for the upcoming assignment. Can someone clarify?', 3),
    ('IT34567890', 'IJ34567890', 'Seeking guidance on research topic', 'I''m looking for guidance in choosing a research topic for my dissertation. Any recommendations?', 4),
    ('EN12345678', 'KL90123456', 'Lost student ID card', 'I''ve lost my student ID card. What should I do?', 5),
    ('DS09876543', 'MN56789012', 'Recommendations for part-time jobs', 'I''m looking for part-time job opportunities near the campus. Any recommendations?', 6),
    ('IT65432109', 'OP12345678', 'Course material not accessible', 'I''m unable to access the course materials on the learning management system. Can someone help?', 7),
    ('EN54321098', 'QR09876543', 'Request for course transfer', 'I would like to request a transfer to a different course. How can I proceed?', 8),
    ('DS67890123', 'ST65432109', 'Concerns regarding lecture timings', 'I have some concerns regarding the timing of one of my lectures. Can I discuss this with someone?', 9),
    ('IT34567890', 'AB12345678', 'Need assistance with study schedule', 'I need help in creating an effective study schedule. Any tips?', 10),
    ('EN12345678', 'CD98765432', 'Assistance with project presentation', 'I need assistance with preparing for my project presentation. Can someone guide me?', 1),
    (NULL, 'EF54321098', 'Tips for effective time management', 'I''m struggling with managing my time effectively. Any tips or suggestions?', 2),
    ('IT12345768', NULL, 'Recommendations for learning resources', 'I''m looking for recommendations on learning resources for a specific subject. Any suggestions?', 3),
    (NULL, 'IJ34567890', 'Advice on selecting elective courses', 'I''m undecided on which elective courses to choose. Can someone provide advice or recommendations?', 4),
    ('DS67890123', NULL, 'Guidance for career planning', 'I''m seeking guidance for career planning. Any resources or tips?', 5);

INSERT INTO Thread_Reply
    (Topic_ID, Student_ID, Staff_ID, Comment)
VALUES
    (1, 'IT12345768', NULL, 'I can help you with course registration. Please provide me with more details.'),
    (1, NULL, 'CD98765432', 'I also faced some issues with course registration before. Let me share my experience.'),
    (1, 'EN54321098', NULL, 'If you need any assistance, feel free to ask. I''m here to help.'),
    (2, NULL, 'CD98765432', 'To access online resources, try clearing your browser cache and cookies.'),
    (2, NULL, 'GH67890123', 'You can also try accessing the resources using a different web browser.'),
    (3, NULL, 'EF54321098', 'The assignment deadline is mentioned in the course syllabus. Have you checked it?'),
    (4, NULL, 'IJ34567890', 'Choosing a research topic can be challenging. What are your areas of interest?'),
    (4, NULL, 'KL90123456', 'Consider exploring recent publications and attending research seminars for inspiration.'),
    (5, NULL, 'KL90123456', 'You should report the loss of your student ID card to the university administration.'),
    (6, NULL, 'MN56789012', 'Check the job listings board on the campus website for part-time job opportunities.'),
    (6, NULL, 'OP12345678', 'Networking with fellow students and alumni can also help in finding part-time jobs.'),
    (7, NULL, 'OP12345678', 'Please contact the IT department for assistance with accessing course materials.'),
    (8, NULL, 'QR09876543', 'To request a course transfer, you should reach out to the academic advising office.'),
    (8, NULL, 'ST65432109', 'Make sure to review the course transfer policy before proceeding.'),
    (9, NULL, 'QR09876543', 'You can discuss your concerns regarding lecture timings with your course instructor.'),
    (10, 'IT12345768', NULL, 'Creating a study schedule involves setting specific goals and allocating time for each subject.'),
    (10, NULL, 'ST65432109', 'Consider using study apps or online tools to help you manage your study schedule.');
    
INSERT INTO Knowledge_Base_Category
    (Category_Name)
VALUES
    ('Course Registration'),
    ('Online Resources'),
    ('Assignment Deadlines'),
    ('Research Topics'),
    ('Lost Student ID'),
    ('Part-Time Jobs'),
    ('Course Materials'),
    ('Course Transfer'),
    ('Lecture Timings'),
    ('Study Schedule');

INSERT INTO Knowledge_Base
    (Author_ID, Title, Description, Category)
VALUES
    ('AB12345678', 'How to Register for Courses', 'A step-by-step guide on how to register for courses.', 1),
    ('CD98765432', 'Accessing Online Library Resources', 'Instructions on how to access the online library resources.', 2),
    ('EF54321098', 'Understanding Assignment Deadlines', 'Information about assignment deadlines and their importance.', 3),
    ('GH67890123', 'Choosing a Research Topic', 'Tips and suggestions for selecting a research topic for your dissertation.', 4),
    ('IJ34567890', 'Lost Student ID Card - What to Do', 'Guidance on what to do if you have lost your student ID card.', 5),
    ('KL90123456', 'Part-Time Job Opportunities', 'Information about part-time job opportunities near the campus.', 6),
    ('MN56789012', 'Accessing Course Materials', 'Instructions on how to access course materials on the learning management system.', 7),
    ('OP12345678', 'Requesting a Course Transfer', 'Steps to follow when requesting a transfer to a different course.', 8),
    ('QR09876543', 'Concerns about Lecture Timings', 'Addressing concerns regarding the timing of lectures.', 9),
    ('ST65432109', 'Creating an Effective Study Schedule', 'Tips and strategies for creating a productive study schedule.', 10);

INSERT INTO Knowledge_Base_Attachment
    (KB_ID, Attachment)
VALUES
    (1, 'http://fileserver.com/attachments/how_to_register.pdf'),
    (1, 'http://fileserver.com/attachments/course_registration_form.docx'),
    (2, 'http://fileserver.com/attachments/online_library_access_guide.pdf'),
    (3, 'http://fileserver.com/attachments/assignment_deadline_policy.pdf'),
    (4, 'http://fileserver.com/attachments/research_topic_ideas.pdf'),
    (5, 'http://fileserver.com/attachments/lost_id_card_procedure.doc'),
    (7, 'http://fileserver.com/attachments/course_materials_access_steps.docx');

INSERT INTO Hotline
    (Hotline_Number, Description)
VALUES
    (94111234567, 'Academic Support Hotline'),
    (94112345678, 'IT Helpdesk Hotline'),
    (94113456789, 'Financial Aid Hotline'),
    (94114567890, 'Counseling Services Hotline'),
    (94115678901, 'Admissions Hotline');

INSERT INTO Call
    (Start_Time, Caller_Phone_Number, Student_ID, End_Time, Hotline_Number, Staff_ID, Description)
VALUES
    ('2023-05-19 09:30:00', 94111234567, 'IT12345768', '2023-05-19 09:45:00', 94111234567, 'CD98765432', 'Need assistance with course selection'),
    ('2023-05-19 10:00:00', 94112345678, 'IT98765432', '2023-05-19 10:15:00', 94112345678, 'EF54321098', 'Troubleshooting network connectivity issue'),
    ('2023-05-19 11:30:00', 94113456789, 'EN54321098', '2023-05-19 11:45:00', 94113456789, 'GH67890123', 'Inquiring about scholarship opportunities'),
    ('2023-05-19 12:00:00', 94114567890, 'DS67890123', NULL, 94114567890, 'IJ34567890', 'Seeking advice on study techniques'),
    ('2023-05-19 13:30:00', 94115678901, 'IT34567890', '2023-05-19 13:45:00', 94115678901, 'KL90123456', 'Requesting information on campus housing'),
    ('2023-05-19 14:00:00', 94111234567, 'EN90123456', NULL, 94111234567, 'MN56789012', 'Enrollment verification request'),
    ('2023-05-19 14:30:00', 94112345678, 'IT56789012', NULL, 94112345678, 'OP12345678', 'Question regarding course prerequisites'),
    ('2023-05-19 15:00:00', 94113456789, 'EN12345678', NULL, 94113456789, 'QR09876543', 'Financial aid eligibility inquiry'),
    ('2023-05-19 15:30:00', 94114567890, 'DS09876543', '2023-05-19 15:45:00', 94114567890, 'ST65432109', 'Concerns about class scheduling'),
    ('2023-05-19 16:00:00', 94115678901, 'IT65432109', '2023-05-19 16:15:00', 94115678901, 'AB12345678', 'Requesting help with library resources');

