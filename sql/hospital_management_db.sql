-- =====================================================================
-- HOSPITAL MANAGEMENT DATABASE SYSTEM
-- Database Management Systems (2501IT05) | Capstone Project
-- Normalized to 3NF | Requires MySQL 8.0.16+
-- =====================================================================

DROP DATABASE IF EXISTS hospital_management_db;
CREATE DATABASE hospital_management_db;
USE hospital_management_db;

-- =====================================================================
-- SECTION 1: DDL - TABLE CREATION
-- =====================================================================

CREATE TABLE DEPARTMENT (
    Department_ID   INT AUTO_INCREMENT PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL UNIQUE,
    Location        VARCHAR(100) NOT NULL
);

CREATE TABLE PATIENT (
    Patient_ID  INT AUTO_INCREMENT PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL,
    Age         INT NOT NULL CHECK (Age BETWEEN 0 AND 120),
    Gender      ENUM('Male', 'Female', 'Other') NOT NULL,
    Mobile      VARCHAR(15) NOT NULL UNIQUE,
    Address     VARCHAR(255) NOT NULL
);

CREATE TABLE MEDICINE (
    Medicine_ID   INT AUTO_INCREMENT PRIMARY KEY,
    Medicine_Name VARCHAR(100) NOT NULL,
    Category      VARCHAR(50) NOT NULL,
    Price         DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);

CREATE TABLE ROOM (
    Room_ID       INT AUTO_INCREMENT PRIMARY KEY,
    Room_Number   VARCHAR(10) NOT NULL UNIQUE,
    Room_Type     ENUM('General', 'Private', 'ICU', 'Deluxe') NOT NULL,
    Status        ENUM('Available', 'Occupied', 'Maintenance') NOT NULL DEFAULT 'Available',
    Department_ID INT NOT NULL,
    CONSTRAINT fk_room_department
        FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE DOCTOR (
    Doctor_ID      INT AUTO_INCREMENT PRIMARY KEY,
    Name           VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Phone          VARCHAR(15) NOT NULL UNIQUE,
    Department_ID  INT NOT NULL,
    CONSTRAINT fk_doctor_department
        FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE APPOINTMENT (
    Appointment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID     INT NOT NULL,
    Doctor_ID      INT NOT NULL,
    Date           DATE NOT NULL,
    Time           TIME NOT NULL,
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ADMISSION (
    Admission_ID   INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID     INT NOT NULL,
    Room_ID        INT NOT NULL,
    Admission_Date DATE NOT NULL,
    Status         ENUM('Admitted', 'Discharged') NOT NULL DEFAULT 'Admitted',
    CONSTRAINT fk_admission_patient
        FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_admission_room
        FOREIGN KEY (Room_ID) REFERENCES ROOM(Room_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE TREATMENT (
    Treatment_ID   INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID     INT NOT NULL,
    Doctor_ID      INT NOT NULL,
    Treatment_Name VARCHAR(150) NOT NULL,
    Cost           DECIMAL(10,2) NOT NULL CHECK (Cost >= 0),
    CONSTRAINT fk_treatment_patient
        FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_treatment_doctor
        FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE PRESCRIPTION (
    Prescription_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID      INT NOT NULL,
    Doctor_ID       INT NOT NULL,
    Medicine_ID     INT NOT NULL,
    Date            DATE NOT NULL,
    Dosage          VARCHAR(100) NOT NULL,
    CONSTRAINT fk_prescription_patient
        FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_prescription_doctor
        FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prescription_medicine
        FOREIGN KEY (Medicine_ID) REFERENCES MEDICINE(Medicine_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Admission_ID is nullable: outpatient bills have no room admission
CREATE TABLE BILLING (
    Bill_ID        INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID     INT NOT NULL,
    Admission_ID   INT NULL,
    Amount         DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Bill_Date      DATE NOT NULL,
    Payment_Status ENUM('Paid', 'Pending', 'Partial') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_billing_patient
        FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_billing_admission
        FOREIGN KEY (Admission_ID) REFERENCES ADMISSION(Admission_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================================
-- SECTION 2: DML - SAMPLE DATA
-- =====================================================================

INSERT INTO DEPARTMENT (Department_Name, Location) VALUES
('Cardiology',       'Block A, Floor 1'),
('Orthopedics',      'Block A, Floor 2'),
('Neurology',        'Block B, Floor 1'),
('Pediatrics',       'Block B, Floor 2'),
('General Medicine', 'Block C, Floor 1');

INSERT INTO PATIENT (Name, Age, Gender, Mobile, Address) VALUES
('Ravi Kumar',       34, 'Male',   '9876543210', 'Kakinada, AP'),
('Sita Devi',        28, 'Female', '9876543211', 'Rajahmundry, AP'),
('Anil Reddy',       45, 'Male',   '9876543212', 'Vijayawada, AP'),
('Lakshmi Priya',    52, 'Female', '9876543213', 'Visakhapatnam, AP'),
('Mohammed Imran',   19, 'Male',   '9876543214', 'Eluru, AP'),
('Kavitha Rao',      63, 'Female', '9876543215', 'Guntur, AP');

INSERT INTO MEDICINE (Medicine_Name, Category, Price) VALUES
('Paracetamol 500mg', 'Analgesic',     15.50),
('Amoxicillin 250mg', 'Antibiotic',    45.00),
('Atorvastatin 10mg', 'Statin',        80.25),
('Cetirizine 10mg',   'Antihistamine', 12.00),
('Metformin 500mg',   'Antidiabetic',  30.75);

INSERT INTO ROOM (Room_Number, Room_Type, Status, Department_ID) VALUES
('101', 'General', 'Occupied',  1),
('102', 'Private', 'Available', 4),
('201', 'ICU',     'Occupied',  3),
('202', 'Deluxe',  'Occupied',  5),
('103', 'General', 'Available', 2);

INSERT INTO DOCTOR (Name, Specialization, Phone, Department_ID) VALUES
('Dr. Suresh Babu', 'Cardiologist',     '9000011111', 1),
('Dr. Priya Menon', 'Orthopedic',       '9000011112', 2),
('Dr. Arjun Varma', 'Neurologist',      '9000011113', 3),
('Dr. Neha Sharma', 'Pediatrician',     '9000011114', 4),
('Dr. Vikram Rao',  'General Physician','9000011115', 5);

INSERT INTO APPOINTMENT (Patient_ID, Doctor_ID, Date, Time) VALUES
(1, 1, '2026-09-01', '09:30:00'),
(2, 2, '2026-09-01', '10:00:00'),
(3, 3, '2026-09-02', '11:15:00'),
(4, 4, '2026-09-02', '14:00:00'),
(5, 5, '2026-09-03', '16:45:00');

INSERT INTO ADMISSION (Patient_ID, Room_ID, Admission_Date, Status) VALUES
(1, 1, '2026-09-01', 'Admitted'),
(3, 3, '2026-09-02', 'Admitted'),
(4, 2, '2026-08-20', 'Discharged'),
(6, 4, '2026-09-05', 'Admitted'),
(2, 5, '2026-08-15', 'Discharged');

INSERT INTO TREATMENT (Patient_ID, Doctor_ID, Treatment_Name, Cost) VALUES
(1, 1, 'Angioplasty',       125000.00),
(2, 2, 'Fracture Casting',    8500.00),
(3, 3, 'MRI Brain Scan',      6200.00),
(4, 4, 'Vaccination',          950.00),
(5, 5, 'General Checkup',      500.00);

INSERT INTO PRESCRIPTION (Patient_ID, Doctor_ID, Medicine_ID, Date, Dosage) VALUES
(1, 1, 3, '2026-09-01', 'Atorvastatin 10mg - 1 tab OD after dinner'),
(2, 2, 1, '2026-09-01', 'Paracetamol 500mg - 1 tab TDS'),
(3, 3, 4, '2026-09-02', 'Cetirizine 10mg - 1 tab HS'),
(4, 4, 2, '2026-09-02', 'Amoxicillin 250mg - 1 tab BD for 5 days'),
(5, 5, 5, '2026-09-03', 'Metformin 500mg - 1 tab BD before meals');

INSERT INTO BILLING (Patient_ID, Admission_ID, Amount, Bill_Date, Payment_Status) VALUES
(1, 1,    125000.00, '2026-09-05', 'Partial'),
(2, 5,      8500.00, '2026-09-01', 'Paid'),
(3, 2,      6200.00, '2026-09-02', 'Pending'),
(4, 3,       950.00, '2026-09-02', 'Paid'),
(5, NULL,    500.00, '2026-09-03', 'Paid');

-- =====================================================================
-- SECTION 3: DQL - QUERIES
-- =====================================================================

-- 3.1 CRUD operations

-- INSERT
INSERT INTO PATIENT (Name, Age, Gender, Mobile, Address)
VALUES ('Deepak Sinha', 40, 'Male', '9876543299', 'Kakinada, AP');

-- SELECT with WHERE
SELECT Patient_ID, Name, Age, Gender
FROM PATIENT
WHERE Age > 40;

-- UPDATE
UPDATE ROOM
SET Status = 'Available'
WHERE Room_ID = 2;

-- DELETE
DELETE FROM APPOINTMENT
WHERE Appointment_ID = 5;

-- 3.2 Joins

-- Equi join
SELECT D.Name AS Doctor_Name, D.Specialization, Dept.Department_Name
FROM DOCTOR D
JOIN DEPARTMENT Dept ON D.Department_ID = Dept.Department_ID;

-- Left join
SELECT P.Patient_ID, P.Name, A.Admission_Date, A.Status
FROM PATIENT P
LEFT JOIN ADMISSION A ON P.Patient_ID = A.Patient_ID;

-- Natural join
SELECT Name, Age, Appointment_ID, Date, Time
FROM PATIENT
NATURAL JOIN APPOINTMENT;

-- 3.3 Aggregation and grouping

-- Revenue per doctor (only above 5000)
SELECT Doc.Name AS Doctor_Name, COUNT(T.Treatment_ID) AS Treatments_Given,
       SUM(T.Cost) AS Total_Revenue
FROM TREATMENT T
JOIN DOCTOR Doc ON T.Doctor_ID = Doc.Doctor_ID
GROUP BY Doc.Doctor_ID, Doc.Name
HAVING SUM(T.Cost) > 5000;

-- Average bill per payment status
SELECT Payment_Status, COUNT(Bill_ID) AS Number_Of_Bills,
       AVG(Amount) AS Average_Amount
FROM BILLING
GROUP BY Payment_Status;

-- Admissions per room type
SELECT R.Room_Type, COUNT(A.Admission_ID) AS Total_Admissions
FROM ROOM R
LEFT JOIN ADMISSION A ON R.Room_ID = A.Room_ID
GROUP BY R.Room_Type
ORDER BY Total_Admissions DESC;

-- Doctors per department
SELECT Dept.Department_Name, COUNT(D.Doctor_ID) AS Doctors
FROM DEPARTMENT Dept
LEFT JOIN DOCTOR D ON Dept.Department_ID = D.Department_ID
GROUP BY Dept.Department_ID, Dept.Department_Name;

-- Outstanding amount (Pending + Partial bills)
SELECT SUM(Amount) AS Outstanding_Amount
FROM BILLING
WHERE Payment_Status IN ('Pending', 'Partial');

-- 3.4 Multi-table join

SELECT P.Name AS Patient, Doc.Name AS Doctor, M.Medicine_Name, Pr.Dosage, Pr.Date
FROM PRESCRIPTION Pr
JOIN PATIENT  P   ON Pr.Patient_ID  = P.Patient_ID
JOIN DOCTOR   Doc ON Pr.Doctor_ID   = Doc.Doctor_ID
JOIN MEDICINE M   ON Pr.Medicine_ID = M.Medicine_ID;

-- 3.5 Correlated subquery: patients billed above the average bill
SELECT P.Patient_ID, P.Name
FROM PATIENT P
WHERE (
    SELECT SUM(B.Amount)
    FROM BILLING B
    WHERE B.Patient_ID = P.Patient_ID
) > (
    SELECT AVG(Amount) FROM BILLING
);

-- 3.6 View
CREATE VIEW Patient_Admission_Room_View AS
SELECT
    P.Patient_ID,
    P.Name           AS Patient_Name,
    P.Age,
    P.Gender,
    A.Admission_ID,
    A.Admission_Date,
    A.Status         AS Admission_Status,
    R.Room_ID,
    R.Room_Number,
    R.Room_Type,
    R.Status         AS Room_Status
FROM PATIENT P
JOIN ADMISSION A ON P.Patient_ID = A.Patient_ID
JOIN ROOM R     ON A.Room_ID = R.Room_ID;

SELECT * FROM Patient_Admission_Room_View;

-- =====================================================================
-- SECTION 4: ADDITIONAL DDL (ALTER / RENAME / TRUNCATE / DROP)
-- =====================================================================

ALTER TABLE PATIENT ADD COLUMN Email VARCHAR(100) NULL UNIQUE;
ALTER TABLE PATIENT MODIFY COLUMN Address VARCHAR(300) NOT NULL;

UPDATE PATIENT SET Email = 'ravi.kumar@example.com' WHERE Patient_ID = 1;
SELECT Patient_ID, Name, Email FROM PATIENT;

CREATE TABLE TEMP_NOTES (
    Note_ID INT AUTO_INCREMENT PRIMARY KEY,
    Note    VARCHAR(100) NOT NULL
);
INSERT INTO TEMP_NOTES (Note) VALUES ('test note 1'), ('test note 2');
RENAME TABLE TEMP_NOTES TO HOSPITAL_NOTES;
SELECT * FROM HOSPITAL_NOTES;
TRUNCATE TABLE HOSPITAL_NOTES;
SELECT COUNT(*) AS Rows_After_Truncate FROM HOSPITAL_NOTES;
DROP TABLE HOSPITAL_NOTES;

DESC PATIENT;
DESC ROOM;
DESC BILLING;
SHOW TABLES;

-- =====================================================================
-- SECTION 5: INDEX
-- =====================================================================

CREATE INDEX idx_appointment_date ON APPOINTMENT (Date);
SHOW INDEX FROM APPOINTMENT;

-- =====================================================================
-- SECTION 6: TRANSACTIONS
-- =====================================================================

-- COMMIT: admit Deepak Sinha to Room 103
START TRANSACTION;
INSERT INTO ADMISSION (Patient_ID, Room_ID, Admission_Date, Status)
SELECT Patient_ID, 5, '2026-09-10', 'Admitted' FROM PATIENT WHERE Mobile = '9876543299';
UPDATE ROOM SET Status = 'Occupied' WHERE Room_ID = 5;
COMMIT;
SELECT * FROM ROOM WHERE Room_ID = 5;

-- ROLLBACK: undo a billing update
START TRANSACTION;
UPDATE BILLING SET Payment_Status = 'Paid' WHERE Bill_ID = 3;
SELECT Bill_ID, Payment_Status FROM BILLING WHERE Bill_ID = 3;
ROLLBACK;
SELECT Bill_ID, Payment_Status FROM BILLING WHERE Bill_ID = 3;

-- =====================================================================
-- SECTION 7: STORED PROCEDURE
-- =====================================================================

DROP PROCEDURE IF EXISTS Discharge_Patient;
DELIMITER $$
CREATE PROCEDURE Discharge_Patient(IN p_admission_id INT)
BEGIN
    DECLARE v_room INT;
    SELECT Room_ID INTO v_room FROM ADMISSION WHERE Admission_ID = p_admission_id;
    UPDATE ADMISSION SET Status = 'Discharged' WHERE Admission_ID = p_admission_id;
    UPDATE ROOM SET Status = 'Available' WHERE Room_ID = v_room;
END$$
DELIMITER ;

CALL Discharge_Patient(4);
SELECT * FROM Patient_Admission_Room_View;

-- =====================================================================
-- SECTION 8: DATA INTEGRITY TESTS
-- Each statement below is expected to fail. They are commented out so
-- the script runs end to end. Uncomment one at a time, run it, and
-- screenshot the error.
-- =====================================================================

-- UNIQUE: duplicate mobile (ERROR 1062)
-- INSERT INTO PATIENT (Name, Age, Gender, Mobile, Address)
-- VALUES ('Duplicate Test', 30, 'Male', '9876543210', 'Test');

-- CHECK: invalid age (ERROR 3819)
-- INSERT INTO PATIENT (Name, Age, Gender, Mobile, Address)
-- VALUES ('Age Test', 150, 'Male', '9111111111', 'Test');

-- FOREIGN KEY: non-existent doctor (ERROR 1452)
-- INSERT INTO APPOINTMENT (Patient_ID, Doctor_ID, Date, Time)
-- VALUES (1, 99, '2026-09-10', '10:00:00');

-- RESTRICT: delete department that still has doctors (ERROR 1451)
-- DELETE FROM DEPARTMENT WHERE Department_ID = 1;

-- NOT NULL: patient without a name (ERROR 1048)
-- INSERT INTO PATIENT (Name, Age, Gender, Mobile, Address)
-- VALUES (NULL, 30, 'Male', '9222222222', 'Test');

-- ENUM: invalid payment status (ERROR 1265/1366)
-- INSERT INTO BILLING (Patient_ID, Amount, Bill_Date, Payment_Status)
-- VALUES (1, 100.00, '2026-09-10', 'Unknown');

-- CHECK: negative price (ERROR 3819)
-- INSERT INTO MEDICINE (Medicine_Name, Category, Price) VALUES ('Test', 'Test', -5);

-- CASCADE (succeeds): deleting a patient removes their dependent rows.
-- Re-run the full script afterwards to restore the data.
-- DELETE FROM PATIENT WHERE Patient_ID = 6;
-- SELECT * FROM ADMISSION WHERE Patient_ID = 6;
