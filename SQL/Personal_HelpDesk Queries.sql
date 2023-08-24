--Personal work
--Good luck

select *  from Student ;
--Faculty
select left(Student_ID,2) as Faculty from Student;
--Emails
select Student_ID + '@gmail.com' as Email from student;

Insert into Student (Student_ID,First_Name,Last_Name,Phone_Number,Year,Password ,Semester,Level_Of_Completion )
Values('IT10002345','Okabe','Taru',07777777777,2002,0x48656C6C6F20576F726C64,'MSC');


-- Delete a specific entry based on Student_ID
--DELETE FROM Student
--WHERE Student_ID = ITxxxxxxxx;