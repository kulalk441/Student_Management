-- Create Databases
CREATE DATABASE IF NOT EXISTS faculty_login;
CREATE DATABASE IF NOT EXISTS student_login;

-- Setup faculty_login DB
USE faculty_login;

CREATE TABLE IF NOT EXISTS login (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50),
    fname VARCHAR(50),
    lname VARCHAR(50),
    department VARCHAR(50),
    age VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS admin (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    course_id VARCHAR(50),
    course_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS notices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_path VARCHAR(255)
);

-- Setup student_login DB
USE student_login;

CREATE TABLE IF NOT EXISTS login (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50),
    fname VARCHAR(50),
    lname VARCHAR(50),
    department VARCHAR(50),
    roll VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    course_id VARCHAR(50),
    course_name VARCHAR(50),
    roll INT,
    total INT DEFAULT 30,
    marks INT DEFAULT 0,
    attended INT DEFAULT 0
);

-- Insert default admin
USE faculty_login;
INSERT INTO admin (username, password) VALUES ('admin', 'admin') ON DUPLICATE KEY UPDATE password='admin';
USE faculty_login;
SELECT * FROM admin;
USE faculty_login;

INSERT INTO login (username, password, fname, lname, department, age)
VALUES ('faculty', 'faculty', 'Test', 'Faculty', 'CSE', '35');

USE student_login;

INSERT INTO login (username, password, fname, lname, department, roll)
VALUES ('student', 'student', 'Test', 'Student', 'CSE', '101');
USE faculty_login;

ALTER TABLE admin
ADD fname VARCHAR(50),
ADD lname VARCHAR(50),
ADD age INT,
ADD image_path VARCHAR(255);
UPDATE admin
SET fname='Admin', lname='User', age=25, image_path='admin.jpeg'
WHERE username='admin';
SELECT image_path FROM admin WHERE username='admin';
select * from admin;

CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sid VARCHAR(50),
    fid VARCHAR(50),
    msg VARCHAR(500),
    msg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE messagef (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sid VARCHAR(50),
    fid VARCHAR(50),
    msg VARCHAR(500),
    msg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
