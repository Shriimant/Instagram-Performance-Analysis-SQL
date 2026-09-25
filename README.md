# Instagram Performance Analysis Using SQL

## 📌 Project Overview

This project analyzes Instagram content and account performance using SQL.

The objective is to identify content performance patterns, engagement trends,
reach contribution, follower growth and category-level insights.

The analysis was performed using MySQL.

---

## 🎯 Objectives

- Analyze Instagram content performance.
- Identify high-performing content formats.
- Analyze monthly and quarterly growth trends.
- Understand engagement across content categories.
- Analyze reach contribution by post type.
- Identify dates with high follower acquisition.
- Demonstrate advanced SQL techniques through analytical queries and a stored procedure.

---

## 🗂️ Dataset

The project uses three relational tables:

### 1. dim_dates

Contains date-related information:

- date
- month_name
- weekday_name
- weekday_or_weekend
- week_no

### 2. fact_account

Contains account-level metrics:

- date
- profile_visits
- new_followers

### 3. fact_content

Contains content-level metrics:

- date
- post_category
- post_type
- impressions
- reach
- shares
- follows
- likes
- comments
- saves
- video_duration
- carousel_item_count

---

## 🛠️ Tools & Technologies

- MySQL
- MySQL Workbench
- SQL
- GitHub

---

## 💻 SQL Concepts Used

- SELECT
- DISTINCT
- WHERE
- GROUP BY
- ORDER BY
- Aggregate Functions
- INNER JOIN
- Common Table Expressions (CTEs)
- CASE Statements
- Window Functions
- ROW_NUMBER()
- GROUP_CONCAT()
- Stored Procedures

---

## 🔍 Analysis Performed

### Q1. Unique Post Types

Identified the number of unique Instagram content formats.

**Result:** 4 unique post types.

---

### Q2. Impression Analysis

Calculated the highest and lowest impressions recorded for each post type.

**Key Finding:** IG Reel recorded the highest single-post impressions of 339,708.

---

### Q3. Weekend Posts

Identified Instagram posts published on weekends during March and April.

**Result:** 17 weekend posts were identified.

The resulting records were exported to CSV for further analysis.

---

### Q4. Monthly Account Growth

Calculated monthly profile visits and new followers.

**Key Findings:**

- May recorded the highest profile visits: 106,571.
- June recorded the highest new followers: 76,942.

---

### Q5. July Engagement Analysis

Calculated total likes by post category for July.

**Key Findings:**

- Other Gadgets: 26,519 likes
- Tech Tips: 20,296 likes
- Mobile: 16,338 likes

---

### Q6. Content Category Diversity

Analyzed the number of unique content categories used each month.

**Key Finding:**

Content variety increased from 3 categories in January to 6 categories in May.

---

### Q7. Reach Analysis

Calculated total reach and percentage contribution by post type.

**Key Finding:**

IG Reels contributed 61.63% of total reach.

---

### Q8. Quarterly Engagement

Analyzed comments and saves by post category across Q1, Q2 and Q3.

**Key Findings:**

- Mobile showed strong engagement across the reported quarters.
- Tech Tips generated 2,201 comments and 17,649 saves in Q2.
- Q2 showed particularly strong engagement across the reported categories.
- Saves were considerably higher than comments.

---

### Q9. Follower Growth Analysis

Used the `ROW_NUMBER()` window function to identify the top three follower acquisition dates for each month.

**Top daily follower gains included:**

- May 8, 2023: 8,872 followers
- June 30, 2023: 8,804 followers
- June 3, 2023: 8,802 followers

---

### Q10. Stored Procedure

Created a parameterized stored procedure to calculate total shares by post type for a selected week.

Example:
```sql
CALL get_total_shares_by_week('W17');









