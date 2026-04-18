-- Data was imported by converting the Excel file into CSV format and loading it into MySQL using the import wizard / SQL query.
-- The table was created beforehand, and the data was verified after import.

CREATE DATABASE student_placement_db;
USE student_placement_db;

CREATE TABLE students (
    Student_ID VARCHAR(20),
    Gender VARCHAR(10),
    Age INT,
    Department VARCHAR(50),
    Degree VARCHAR(50),
    College_Region VARCHAR(50),
    CGPA FLOAT,
    Attendance_Percent FLOAT,
    Internship_Completed VARCHAR(10),
    Certifications_Count INT,
    Communication_Score INT,
    Quantitative_Score INT,
    Technical_Score INT,
    Soft_Skills_Score INT,
    Projects_Completed INT,
    Hackathon_Participation VARCHAR(10),
    Extra_Curricular_Score INT,
    Placement_ID VARCHAR(20),
    Company_Name VARCHAR(100),
    Industry_Sector VARCHAR(50),
    Job_Role VARCHAR(50),
    CTC_LPA FLOAT,
    Placement_Status VARCHAR(20),
    Placement_Type VARCHAR(20),
    Interview_Rounds_Cleared INT,
    Offer_Accepted VARCHAR(10),
    TOTAL_SCORE FLOAT
);
select * from students;

-- TRIGGER 1--

-- Placement Status Trigger
DELIMITER $$
CREATE TRIGGER trg_placement_status
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.CTC_LPA > 0 THEN
        SET NEW.Placement_Status = 'Placed';
    ELSE
        SET NEW.Placement_Status = 'Not Placed';
    END IF;
END$$

DELIMITER ;

-- Test Code
INSERT INTO students (Student_ID, CTC_LPA) VALUES ('S001', 5.5);
SELECT Student_ID, CTC_LPA, Placement_Status FROM students WHERE Student_ID = 'S001';

/*When a new student is inserted:
If CTC_LPA > 0 → student is Placed
If CTC_LPA = 0 or NULL → Not Placed */

-- TRIGGER 2--
-- Total Score Calculation Trigger
DELIMITER $$

CREATE TRIGGER trg_total_score
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    SET NEW.TOTAL_SCORE =
        (NEW.Communication_Score +
         NEW.Quantitative_Score +
         NEW.Technical_Score +
         NEW.Soft_Skills_Score +
         NEW.Attendance_Percent +
         NEW.Projects_Completed +
         NEW.Extra_Curricular_Score);
END$$
DELIMITER ;

-- Test Code
INSERT INTO students (Student_ID,Communication_Score,Quantitative_Score,Technical_Score,
Soft_Skills_Score,Attendance_Percent,Projects_Completed,Extra_Curricular_Score)VALUES ('S002', 80, 70, 75, 85,73,3 ,60);

SELECT Student_ID, TOTAL_SCORE FROM students WHERE Student_ID = 'S002';


-- TRIGGER 3--
-- OFFER ACCEPTED TRIGGER --
DELIMITER $$

CREATE TRIGGER trg_offer_status
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.CTC_LPA > 0 THEN
        SET NEW.Offer_Accepted = 'Yes';
    ELSE
        SET NEW.Offer_Accepted = 'No';
    END IF;
END$$
DELIMITER ;

-- test code
INSERT INTO students (Student_ID, CTC_LPA)VALUES ('S003', 0);
SELECT Student_ID, CTC_LPA, Offer_Accepted FROM students WHERE Student_ID = 'S003';

SHOW TRIGGERS;
