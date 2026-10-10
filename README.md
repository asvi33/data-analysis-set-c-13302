# Training Performance Analysis - Data Analysis Set C

**Student name:** Ambaliya Asvi Sanjaybhai  |  **Student ID:** 13302  |  **Set:** C
**Institute:** Red & White Skill Education - Practical Exam (Data Analysis)

## 1. Business objective
Which course needs the most academic support, and how does performance differ across batches?
Questions answered: (1) Which course/department has the lowest scores & pass rate? (2) How do batches and months compare?

## 2. Dataset & data dictionary
| File | Rows | Purpose |
|---|---|---|
| `data/raw/assessments.csv` | 13 (12 unique + 1 exact duplicate) | fact table |
| `data/raw/courses.csv` | 4 | lookup (course_id -> course, department) |

| Column | Type | Meaning |
|---|---|---|
| assessment_id | integer | unique assessment id |
| month | text (ordered Jan>Feb>Mar) | assessment month |
| course_id | text | key to courses |
| batch | text | Morning / Evening / Weekend |
| score | number 0-100 | assessment score |
| attendance_pct | number 0-100 | attendance % |
| course, department | text | from courses.csv |
| pass_flag (derived) | 0/1 | 1 when score >= 50 (exactly 50 passes) |

## 3. Cleaning & metric definitions
- Removed the 1 exact duplicate (assessment_id 12) -> **12 unique rows** in every module. Raw values preserved.
- Join key: `course_id` (one course -> many assessments), left join, 0 unmatched keys.
- **Pass rate = passing assessments / total assessments** (computed from counts, never an average of percentages).
- Results reported to 2 decimals.

## 4. Tools & versions
Excel (Microsoft 365) | Power BI Desktop (latest) | SQLite 3.45.1 | Python 3.x with pandas, matplotlib (see `requirements.txt`).

## 5. Folder structure
```
data-analysis-set-c-YOUR-STUDENT-ID/
├── README.md  requirements.txt  .gitignore
├── data/raw/            assessments.csv, courses.csv
├── excel/analysis.xlsx  (Raw, Lookup, Clean, Summary)
├── sql/                 setup.sql, queries.sql
├── python/analysis.py
├── powerbi/             dashboard.pbix (+ power_query_steps.m, dax_measures.dax, BUILD_GUIDE.md)
└── outputs/             clean_data.csv, python_summary.csv, python_chart.png,
                         powerbi_dashboard.png, sql/ (query result CSVs)
```

## 6. How to run
**SQL (SQLite 3.45):** `sqlite3 data.db < sql/setup.sql` then `sqlite3 -header -csv data.db < sql/queries.sql`.
Execution order: setup.sql (creates tables, loads 4 + 12 rows) -> queries.sql (S2a, S2b, S2c, S3 checks). Results saved in `outputs/sql/`.

**Python:** `pip install -r requirements.txt` then, from the repo root, `python python/analysis.py`.

**Excel (`excel/analysis.xlsx`):** *Raw* = original 13 rows + row count; *Lookup* = 4 courses; *Clean* = 12 rows, department (INDEX/MATCH), pass_flag, before/after counts; *Summary* = COUNTIFS pass count by batch, department x month average score table + column chart.

**Power BI refresh:** open `dashboard.pbix` > Home > Transform data > Data source settings (or edit the `File.Contents` path in Advanced Editor) > point to your cloned `data/raw/assessments.csv` and `courses.csv` > Close & Apply > Refresh.
Data source path used: `C:\YOUR_PATH\data-analysis-set-c-YOUR-STUDENT-ID\data\raw\`.

## 7. Findings & recommendation (unfiltered, 12 records)
1. **Technology avg score = 56.00 vs Business = 67.00**; Technology pass rate = 3/6 = **50.00%** vs Business 5/6 = 83.33%.
2. **Python has the lowest pass rate: 1 passing / 3 total = 33.33%** (avg score 49.33); PowerBI also underperforms (avg 53.33). Batches: Evening 67.00 > Morning 61.25 > Weekend 56.25 (Weekend pass 2/4 = 50.00%).
3. Monthly average improves: Jan 55.00 -> Feb 62.75 -> Mar 66.75.

**Recommendation:** Prioritise academic support (extra revision/labs) for **Python**, then **PowerBI**, and review Weekend-batch delivery. **Limitation:** only 12 independent assessments (3 per course), so results are indicative, not statistically conclusive.

## 8. Cross-tool reconciliation - Technology average score
| Tool | Method | Value |
|---|---|---|
| Excel | `Summary!B13` AVERAGEIFS | 56.00 |
| SQL | S2a query | 56.00 |
| Python | python_summary.csv | 56.00 |
| Power BI | Avg Score card with Technology selected | 56.00 (confirm after building) |

No rounding differences (exact value 56).

## 9. Video
URL: PASTE-LINK-HERE  |  Duration: MM:SS

## 10. References
None (own code). 

## 11. Authorship
All work in this repository is my own except where cited.

Final commit hash: PASTE-HASH-HERE
