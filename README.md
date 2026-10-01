# Hospital Management Database System

**Course:** Database Management Systems (2501IT05)
**Department:** Artificial Intelligence and Machine Learning, Aditya University
**Project type:** Capstone Project (B.Tech)
**Batch:** AIML_TT1_BATCHXX <!-- replace with your batch folder name -->

## Team

| Name | Roll No. | Responsibility |
|------|----------|----------------|
| Member 1 | | ER diagram and schema design |
| Member 2 | | Table creation (DDL) and constraints |
| Member 3 | | Sample data and CRUD (DML) |
| Member 4 | | Queries, views and reports (DQL) |
| Member 5 | | Documentation, PPTs and video |

## Problem Statement

Hospitals manage patients, doctors, rooms, appointments, treatments, prescriptions and billing, often in separate registers or spreadsheets. This leads to duplicate data, inconsistent records and slow retrieval. This project designs a normalized (3NF) relational database in MySQL that stores all of this in one place and enforces data integrity through keys and constraints.

## Objectives

- Design an ER diagram and relational schema with at least 6 entities.
- Implement the database with primary keys, foreign keys and validation constraints.
- Support CRUD operations and reporting queries (joins, aggregates, subqueries, views).
- Demonstrate transactions, indexing and a stored procedure.
- Demonstrate data integrity by showing constraint violations being rejected.

## Database Design

The database has 10 tables:

| Table | Purpose | Key relationships |
|-------|---------|-------------------|
| DEPARTMENT | Hospital departments | Parent of ROOM and DOCTOR |
| PATIENT | Patient details | Parent of APPOINTMENT, ADMISSION, TREATMENT, PRESCRIPTION, BILLING |
| MEDICINE | Medicine catalogue | Parent of PRESCRIPTION |
| ROOM | Hospital rooms | FK to DEPARTMENT |
| DOCTOR | Doctor details | FK to DEPARTMENT |
| APPOINTMENT | Patient-doctor appointments | FK to PATIENT, DOCTOR |
| ADMISSION | Inpatient stays | FK to PATIENT, ROOM |
| TREATMENT | Treatments and costs | FK to PATIENT, DOCTOR |
| PRESCRIPTION | Medicines prescribed | FK to PATIENT, DOCTOR, MEDICINE |
| BILLING | Bills and payment status | FK to PATIENT, ADMISSION (optional) |

ER diagram and relational schema are in the `docs/` folder.

### Constraints used

- **PRIMARY KEY** with `AUTO_INCREMENT` on every table
- **FOREIGN KEY** with `ON UPDATE CASCADE` and `ON DELETE RESTRICT` or `CASCADE`
- **UNIQUE** on mobile, phone, room number and department name
- **NOT NULL** on all mandatory columns
- **CHECK** on age (0 to 120), prices, costs and amounts (not negative)
- **ENUM** for gender, room type, room status, admission status and payment status
- **DEFAULT** for room status, admission status and payment status

## SQL Script Contents

`sql/hospital_management_db.sql` runs top to bottom and contains:

1. **DDL:** database and table creation
2. **DML:** sample data, at least 5 rows per table
3. **DQL:** CRUD, joins (equi, left, natural, multi-table), GROUP BY / HAVING, correlated subquery, view
4. **Additional DDL:** ALTER, RENAME, TRUNCATE, DROP
5. **Index:** `CREATE INDEX` on appointment date
6. **Transactions:** COMMIT and ROLLBACK examples
7. **Stored procedure:** `Discharge_Patient`
8. **Integrity tests:** commented-out statements that are expected to fail

## How to Run

Requirements: **MySQL 8.0.16 or later** (earlier versions ignore CHECK constraints) and MySQL Workbench or the MySQL command line.

**Workbench:** open `sql/hospital_management_db.sql`, then click the lightning icon to run the whole script.

**Command line:**

```bash
mysql -u root -p < sql/hospital_management_db.sql
```

The script drops and recreates `hospital_management_db` each time, so it is safe to re-run.

### Testing data integrity

Open Section 8 of the script, uncomment one statement at a time, run it, and observe the error. Comment it out again before re-running the full script.

## Repository Structure

```
AIML_TT1_BATCHXX/
├── README.md
├── sql/
│   └── hospital_management_db.sql
├── docs/
│   ├── Final_Project_Report.docx
│   ├── ER_Diagram.png
│   └── Relational_Schema.png
├── presentations/
│   ├── Review_I.pptx
│   └── Review_II.pptx
├── screenshots/
└── video/
    └── Project_Presentation_Video (link or file)
```

## Review Schedule

| Review | Focus | Period |
|--------|-------|--------|
| Review I | Database design (entities, ER diagram, schema, keys) | 11-14 August 2026 |
| Review II | Implementation (DDL, DML, DQL, integrity, demo) | 5-8 October 2026 |
