CREATE DATABASE studentdb;
USE studentdb;

CREATE TABLE Departments (
  DeptID   VARCHAR(5) PRIMARY KEY,
  DeptName VARCHAR(50),
  Location VARCHAR(30)
);

CREATE TABLE Instructors (
  InstructorID   INT PRIMARY KEY,
  InstructorName VARCHAR(50),
  DeptID         VARCHAR(5),
  FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Courses (
  CourseID     VARCHAR(5) PRIMARY KEY,
  CourseName   VARCHAR(50),
  InstructorID INT NULL,
  Credits      INT,
  FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

CREATE TABLE Students (
  StudentID   INT PRIMARY KEY,
  StudentName VARCHAR(50),
  Email       VARCHAR(100),
  MentorID    INT NULL,
  FOREIGN KEY (MentorID) REFERENCES Students(StudentID)
);

CREATE TABLE Enrollments (
  StudentID INT,
  CourseID  VARCHAR(5),
  Marks     INT,
  PRIMARY KEY (StudentID, CourseID),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Departments VALUES
('D01','Computer Science','Block A'),
('D02','Mathematics','Block B'),
('D03','Data Science','Block C'),
('D04','Electronics','Block D'),
('D05','Mechanical','Block E');

-- Instructors (6 rows)
INSERT INTO Instructors VALUES
(201,'Suresh Kumar','D01'),
(202,'Meena Pillai','D02'),
(203,'Arjun Das','D03'),
(204,'Kavitha Raman','D01'),
(205,'Vikram Sethi','D04'),
(206,'Lakshmi Narayan','D05');   

INSERT INTO Courses VALUES
('C01','Database Systems',201,4),
('C02','Statistics',202,3),
('C03','Machine Learning',203,4),
('C04','Cloud Computing',201,3),
('C05','Data Visualization',203,3),
('C06','Digital Electronics',205,4),
('C07','Discrete Mathematics',202,3),
('C08','Deep Learning',203,4),
('C09','Cyber Security',204,3),          
('C10','Renewable Energy Systems',NULL,3); 

INSERT INTO Students VALUES
(101,'Ananya Rao','ananya.rao@mail.com',NULL),
(102,'Karthik Iyer','karthik.iyer@mail.com',101),
(103,'Divya Menon','divya.menon@mail.com',101),
(104,'Rahul Sharma','rahul.sharma@mail.com',102),
(105,'Priya Nair','priya.nair@mail.com',NULL),
(106,'Mohammed Faisal','mohammed.faisal@mail.com',101),
(107,'Sneha Reddy','sneha.reddy@mail.com',103),
(108,'Arjun Pillai','arjun.pillai@mail.com',NULL),
(109,'Kavya Krishnan','kavya.krishnan@mail.com',106),
(110,'Vishal Gupta','vishal.gupta@mail.com',102),
(111,'Meera Suresh','meera.suresh@mail.com',107),
(112,'Aditya Verma','aditya.verma@mail.com',NULL),
(113,'Nandini Raj','nandini.raj@mail.com',103),
(114,'Farhan Ahmed','farhan.ahmed@mail.com',106),
(115,'Shreya Joshi','shreya.joshi@mail.com',NULL),
(116,'Rohan Desai','rohan.desai@mail.com',110),
(117,'Ishita Bose','ishita.bose@mail.com',NULL),   -- zero enrollments
(118,'Naveen Kumar','naveen.kumar@mail.com',NULL); -- zero enrollments

INSERT INTO Enrollments VALUES
(101,'C01',88),(101,'C02',76),(101,'C04',91),
(102,'C01',91),(102,'C03',84),(102,'C08',79),
(103,'C02',79),(103,'C05',85),
(104,'C04',85),(104,'C06',72),
(105,'C03',90),(105,'C08',87),
(106,'C01',68),(106,'C07',74),
(107,'C02',95),(107,'C05',89),(107,'C08',91),
(108,'C06',77),
(109,'C01',82),(109,'C03',88),(109,'C10',80),
(110,'C04',70),(110,'C07',66),
(111,'C05',93),(111,'C08',85),
(112,'C01',59),(112,'C02',61),
(113,'C03',87),(113,'C10',91),
(114,'C06',84),(114,'C04',78),
(115,'C02',73),(115,'C07',69),(115,'C08',90),
(116,'C01',66),(116,'C05',72);

-- 1.innerjoin Every student's name, course name, and marks
SELECT s.StudentName, c.CourseName, e.Marks
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- 2.[INNER JOIN] Course + instructor + department
SELECT c.CourseName, i.InstructorName, d.DeptName
FROM Courses c
INNER JOIN Instructors i ON c.InstructorID = i.InstructorID
INNER JOIN Departments d ON i.DeptID = d.DeptID;

-- 3.[LEFT JOIN] Every course with instructor name
SELECT c.CourseName, i.InstructorName
FROM Courses c
LEFT JOIN Instructors i ON c.InstructorID = i.InstructorID;

-- 4.[LEFT JOIN] Students not enrolled in any course 
SELECT s.StudentID, s.StudentName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.StudentID IS NULL;

-- 5.[RIGHT JOIN] Every instructor + courses taught 
SELECT i.InstructorName, c.CourseName
FROM Courses c
RIGHT JOIN Instructors i ON c.InstructorID = i.InstructorID;

-- 6.[RIGHT JOIN] Courses with zero enrolled students
SELECT c.CourseID, c.CourseName
FROM Enrollments e
RIGHT JOIN Courses c ON e.CourseID = c.CourseID
WHERE e.StudentID IS NULL;

-- 7.[FULL OUTER JOIN] Every student-course relationship 
SELECT s.StudentID, s.StudentName, c.CourseID, c.CourseName, e.Marks
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID
UNION
SELECT s.StudentID, s.StudentName, c.CourseID, c.CourseName, e.Marks
FROM Enrollments e
RIGHT JOIN Courses c ON e.CourseID = c.CourseID
LEFT JOIN Students s ON e.StudentID = s.StudentID;

-- 8.[CROSS JOIN] Every (Student, Course) pairing, limited to Computer Science courses 
SELECT s.StudentName, c.CourseName
FROM Students s
CROSS JOIN (
    SELECT c.CourseID, c.CourseName
    FROM Courses c
    INNER JOIN Instructors i ON c.InstructorID = i.InstructorID
    INNER JOIN Departments d ON i.DeptID = d.DeptID
    WHERE d.DeptName = 'Computer Science'
) c;

-- 9.[SELF JOIN] Every mentor + number of mentees 
SELECT m.StudentName AS Mentor, COUNT(s.StudentID) AS NumMentees
FROM Students s
INNER JOIN Students m ON s.MentorID = m.StudentID
GROUP BY m.StudentName;

-- 10.[SELF JOIN] Students who are BOTH a mentor and a mentee 
SELECT DISTINCT s.StudentName
FROM Students s
INNER JOIN Students mentee ON mentee.MentorID = s.StudentID
WHERE s.MentorID IS NOT NULL;

-- 11.Department + total students enrolled in that department's courses 
SELECT d.DeptName, COUNT(e.StudentID) AS TotalStudentsEnrolled
FROM Departments d
INNER JOIN Instructors i ON d.DeptID = i.DeptID
INNER JOIN Courses c ON i.InstructorID = c.InstructorID
INNER JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DeptName;

-- 12. Average marks per course, highest to lowest 
SELECT c.CourseName, AVG(e.Marks) AS AvgMarks
FROM Courses c
INNER JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName
ORDER BY AvgMarks DESC;