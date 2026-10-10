-- =====================================================================
-- sql/queries.sql  (run AFTER setup.sql)  | Dialect: SQLite 3
-- =====================================================================

-- ---------- S2a : Average score by department (lowest first) ----------
SELECT c.department,
       ROUND(AVG(a.score), 2) AS avg_score
FROM assessments a
JOIN courses c ON a.course_id = c.course_id
GROUP BY c.department
ORDER BY avg_score ASC, c.department ASC;

-- ---------- S2b : Underperforming courses (avg score < 60) ------------
SELECT c.course_id,
       c.course,
       ROUND(AVG(a.score), 2) AS avg_score
FROM assessments a
JOIN courses c ON a.course_id = c.course_id
GROUP BY c.course_id, c.course
HAVING AVG(a.score) < 60
ORDER BY avg_score ASC, c.course ASC;

-- ---------- S2c : Top two batches by average score --------------------
-- Ties are broken alphabetically by batch name.
SELECT batch,
       ROUND(AVG(score), 2) AS avg_score
FROM assessments
GROUP BY batch
ORDER BY AVG(score) DESC, batch ASC
LIMIT 2;

-- ---------- S3 : Integrity check (1) courses LEFT JOIN assessments ----
SELECT c.course_id, c.course,
       COUNT(a.assessment_id) AS matched_assessments
FROM courses c
LEFT JOIN assessments a ON a.course_id = c.course_id
GROUP BY c.course_id, c.course
ORDER BY c.course_id;

-- ---------- S3 : Integrity check (2) unmatched fact keys --------------
-- Expected result: unmatched_keys = 0
SELECT COUNT(*) AS unmatched_keys
FROM assessments a
LEFT JOIN courses c ON a.course_id = c.course_id
WHERE c.course_id IS NULL;
