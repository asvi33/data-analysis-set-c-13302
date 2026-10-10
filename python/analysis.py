import os
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd

matplotlib.use("Agg")
os.makedirs("outputs", exist_ok=True)

# ---------------- P1: Load, Clean & Merge ----------------

fact = pd.read_csv("data/raw/assessments.csv", on_bad_lines="skip")
lookup = pd.read_csv("data/raw/courses.csv", dtype=str)

fact["attendance_pct"] = (
    fact["attendance_pct"].astype(str).str.split(" ").str[0]
)
fact["score"] = pd.to_numeric(fact["score"])
fact["attendance_pct"] = pd.to_numeric(fact["attendance_pct"])


fact = fact.drop_duplicates().reset_index(drop=True)

df = fact.merge(lookup, on="course_id", how="left")

assert len(df) == 12, f"Expected 12 unique rows, got {len(df)}"
assert df["department"].isna().sum() == 0, "Unmatched course_id found!"
print("✅ STEP 1 PASSED: 12 Unique records verified.")

# ---------------- P2: Derived Field & Analysis ----------------

df["pass_flag"] = (df["score"] >= 50).astype(int)

dept = (
    df.groupby("department")
    .agg(
        total_assessments=("pass_flag", "count"),
        passing_assessments=("pass_flag", "sum"),
        avg_score=("score", "mean"),
    )
    .reset_index()
)
dept["pass_rate_pct"] = (
    dept["passing_assessments"] / dept["total_assessments"] * 100
).round(2)
dept["avg_score"] = dept["avg_score"].round(2)

print("\n--- Department Summary ---")
print(dept.to_string(index=False))

course = (
    df.groupby(["course_id", "course"])
    .agg(
        total_assessments=("pass_flag", "count"),
        passing_assessments=("pass_flag", "sum"),
    )
    .reset_index()
)
course["pass_rate_pct"] = (
    course["passing_assessments"] / course["total_assessments"] * 100
).round(2)

min_rate = course["pass_rate_pct"].min()
lowest_courses = course[course["pass_rate_pct"] == min_rate]

print("\n--- Lowest Performing Course (Printed Output) ---")
for _, r in lowest_courses.iterrows():
    print(
        f"Course: {r['course']} ({r['course_id']}) -> Passing Count (Numerator): {int(r['passing_assessments'])}, Total Assessments (Denominator): {int(r['total_assessments'])} (Pass Rate: {r['pass_rate_pct']:.2f}%)"
    )

# ---------------- P3: Chart & Exports ----------------

df["month"] = pd.Categorical(
    df["month"], categories=["Jan", "Feb", "Mar"], ordered=True
)
monthly = df.groupby("month", observed=False)["score"].mean().round(2)

fig, ax = plt.subplots(figsize=(7, 4.5))
bars = ax.bar(monthly.index, monthly.values, color="#c0392b")
ax.bar_label(bars, fmt="%.2f", padding=3)
ax.set_title("Monthly Average Assessment Score (Jan - Mar)", fontweight="bold")
ax.set_xlabel("Month")
ax.set_ylabel("Average Score (0-100)")
ax.set_ylim(0, 100)

fig.tight_layout()
fig.savefig("outputs/python_chart.png", dpi=150)
df.to_csv("outputs/clean_data.csv", index=False)
dept.to_csv("outputs/python_summary.csv", index=False)

print("\n STEP 3 PASSED: All outputs exported to 'outputs/' folder!")
