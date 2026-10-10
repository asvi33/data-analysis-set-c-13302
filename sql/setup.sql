
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS assessments;
DROP TABLE IF EXISTS courses;

CREATE TABLE courses (
    course_id   TEXT PRIMARY KEY,
    course      TEXT NOT NULL,
    department  TEXT NOT NULL
);

CREATE TABLE assessments (
    assessment_id   INTEGER PRIMARY KEY,
    month           TEXT NOT NULL CHECK (month IN ('Jan','Feb','Mar')),
    course_id       TEXT NOT NULL,
    batch           TEXT NOT NULL CHECK (batch IN ('Morning','Evening','Weekend')),
    score           NUMERIC NOT NULL CHECK (score BETWEEN 0 AND 100),
    attendance_pct  NUMERIC NOT NULL CHECK (attendance_pct BETWEEN 0 AND 100),
    FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

INSERT INTO courses (course_id, course, department) VALUES
('C1','Excel','Business'),
('C2','PowerBI','Business'),
('C3','SQL','Technology'),
('C4','Python','Technology');

-- 12 unique rows. The raw file has assessment_id 12 twice; it is loaded ONCE.
INSERT INTO assessments (assessment_id, month, course_id, batch, score, attendance_pct) VALUES
(1,'Jan','C1','Morning',72,90),
(2,'Jan','C2','Evening',45,70),
(3,'Jan','C3','Morning',65,85),
(4,'Jan','C4','Weekend',38,60),
(5,'Feb','C1','Evening',80,95),
(6,'Feb','C2','Weekend',55,80),
(7,'Feb','C3','Morning',48,75),
(8,'Feb','C4','Evening',68,88),
(9,'Mar','C1','Weekend',90,98),
(10,'Mar','C2','Morning',60,82),
(11,'Mar','C3','Evening',75,92),
(12,'Mar','C4','Weekend',42,65);

-- Row-count verification (expect 12 and 4)
SELECT 'assessments' AS table_name, COUNT(*) AS row_count FROM assessments
UNION ALL
SELECT 'courses', COUNT(*) FROM courses;
