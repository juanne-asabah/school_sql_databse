CREATE DATABASE IF NOT EXISTS alu_db;
USE alu_db;

---member one; Craig David---
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    classroom_id INT,
    enrollment_date DATE NOT NULL,
    PRIMARY KEY (student_id)
);

---member two; Juanne Asabah---
CREATE TABLE Classroom (
    classroom_id INT AUTO_INCREMENT,
    room_number VARCHAR(50) NOT NULL,
    building VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    PRIMARY KEY (classroom_id)
);

---member three; David Boyo---
CREATE TABLE Faculty (
    faculty_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50) NOT NULL,
    PRIMARY KEY (faculty_id)
);

---member four; Sarah Wendo---
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    faculty_id INT,
    classroom_id INT,
    PRIMARY KEY (course_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id) ON DELETE SET NULL,
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id) ON DELETE SET NULL
);

---member five; David Bitwayiki---
CREATE TABLE Extra_Curricular_Activities (
    activity_id INT AUTO_INCREMENT,
    activity_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    faculty_advisor_id INT,
    PRIMARY KEY (activity_id),
    FOREIGN KEY (faculty_advisor_id) REFERENCES Faculty(faculty_id) ON DELETE SET NULL
);

---David Bitwayiki---
CREATE TABLE Student_Courses (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

---creating join tables---
CREATE TABLE Student_Activities (
    student_id INT,
    activity_id INT,
    PRIMARY KEY (student_id, activity_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (activity_id) REFERENCES Extra_Curricular_Activities(activity_id) ON DELETE CASCADE
);

ALTER TABLE Students
ADD FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id) ON DELETE SET NULL;

---Inserting records into the fileds in each table---
INSERT INTO Classroom (room_number, building, capacity) VALUES
('Room 101', 'A-Block', 30),
('Room 102', 'A-Block', 25),
('Lab 201', 'B-Block', 40),
('Auditorium Max', 'C-Block', 150),
('Seminar 05', 'B-Block', 15);

INSERT INTO Faculty (name, email, department) VALUES
('Dr. John Doe', 'jdoe@alu.edu', 'Computer Science'),
('Prof. Sarah Smith', 'ssmith@alu.edu', 'Mathematics'),
('Dr. Robert Evans', 'revans@alu.edu', 'Business'),
('Alice Mwangi', 'amwangi@alu.edu', 'Social Sciences'),
('David Stone', 'dstone@alu.edu', 'Natural Sciences');

INSERT INTO Students (name, email, classroom_id, enrollment_date) VALUES
('Alex Jones', 'alex.j@alu.edu', 1, '2026-01-15'),
('Beatrice Kim', 'b.kim@alu.edu', 1, '2026-01-16'),
('Charlie Brown', 'cbrown@alu.edu', 2, '2026-02-01'),
('Diana Prince', 'diana@alu.edu', 3, '2026-01-10'),
('Evan Wright', 'ewright@alu.edu', 3, '2026-02-15');

INSERT INTO Courses (course_name, credits, faculty_id, classroom_id) VALUES
('Introduction to SQL', 4, 1, 3),
('Advanced Calculus', 3, 2, 1),
('Entrepreneurship 101', 3, 3, 2),
('Data Structures', 4, 1, 3),
('Macroeconomics', 3, 3, 4);

INSERT INTO Extra_Curricular_Activities (activity_name, category, faculty_advisor_id) VALUES
('Tech Club', 'Academic', 1),
('Debate Society', 'Arts', 4),
('Football Team', 'Sports', 5),
('Chess Club', 'Recreational', 2),
('Music Ensemble', 'Arts', 4);

INSERT INTO Student_Courses (student_id, course_id) VALUES
(1, 1), (1, 4),
(2, 1), (2, 3),
(3, 2), (3, 5),
(4, 1), (4, 4),
(5, 3), (5, 5);

INSERT INTO Student_Activities (student_id, activity_id) VALUES
(1, 1),
(2, 2), (2, 4),
(3, 3),
(4, 1), (4, 5),
(5, 3);

---Updating, Deleting, Selecting records in Students table---
UPDATE Students SET classroom_id = 2 WHERE student_id = 1;

DELETE FROM Students WHERE student_id = 5;

SELECT * FROM Students WHERE enrollment_date > '2026-01-31';

---Updating, Deleting, Selecting records in Classroom table---
UPDATE Classroom SET capacity = 35 WHERE classroom_id = 1;

DELETE FROM Classroom WHERE classroom_id = 5;

SELECT * FROM Classroom WHERE building = 'B-Block';

---Updating, Deleting, Selecting records in Faculty table---
UPDATE Faculty SET department = 'Data Science' WHERE faculty_id = 1;

DELETE FROM Faculty WHERE faculty_id = 5;

SELECT * FROM Faculty WHERE department = 'Mathematics';

---Updating, Deleting, Selecting records in Courses table---
UPDATE Courses SET credits = 5 WHERE course_id = 1;

DELETE FROM Courses WHERE course_id = 5;

SELECT * FROM Courses WHERE credits >= 4;

---Updating, Deleting, Selecting records in Extra_Curricular_Activities table---
UPDATE Extra_Curricular_Activities SET faculty_advisor_id = 3 WHERE activity_id = 4;

DELETE FROM Extra_Curricular_Activities WHERE activity_id = 3;

SELECT * FROM Extra_Curricular_Activities WHERE category = 'Arts';


SELECT
    CONCAT(s.name, ' is enrolled in ', c.course_name, ', taught by ', f.name, ', in ', cl.room_number, '.') AS full_sentence
FROM Student_Courses sc
JOIN Students s ON sc.student_id = s.student_id
JOIN Courses c ON sc.course_id = c.course_id
JOIN Faculty f ON c.faculty_id = f.faculty_id
JOIN Classroom cl ON c.classroom_id = cl.classroom_id;

SELECT
    CONCAT(s.name, ' participates in ', e.activity_name, ', advised by ', f.name, '.') AS full_sentence
FROM Student_Activities sa
JOIN Students s ON sa.student_id = s.student_id
JOIN Extra_Curricular_Activities e ON sa.activity_id = e.activity_id
JOIN Faculty f ON e.faculty_advisor_id = f.faculty_id;

SELECT
    CONCAT(s.name, ' uses homeroom ', cl.room_number, ' located inside ', cl.building, '.') AS alternative_sentence
FROM Students s
JOIN Classroom cl ON s.classroom_id = cl.classroom_id;

SELECT
    c.course_name,
    COUNT(sc.student_id) AS total_enrolled_students
FROM Courses c
LEFT JOIN Student_Courses sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name;
