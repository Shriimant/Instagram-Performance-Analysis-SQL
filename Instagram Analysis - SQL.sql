USE gdb0120;
SHOW TABLES;

DESC dim_dates;
DESC fact_account;
DESC fact_content;

## Instagram Analysis - SQL 

#Q1. How many unique post types are found in the 'fact_content' table?

SELECT DISTINCT post_type
FROM fact_content;

SELECT COUNT(DISTINCT post_type) AS unique_post_types
FROM fact_content;

-- Insight:
-- The dataset contains 4 unique Instagram content formats:
-- IG Image, IG Reel, IG Carousel, and IG Video.
-- These content types will be used for further reach, engagement,
-- and performance analysis throughout the project.



#Q2. What are the highest and lowest recorded impressions for each post type ?

SELECT
    post_type,
    MAX(impressions) AS highest_impressions,
    MIN(impressions) AS lowest_impressions
FROM fact_content
GROUP BY post_type;

-- Insight:
-- IG Reels achieved the highest peak impressions (339,708),
-- significantly outperforming all other content formats.
--
-- IG Carousel recorded both the lowest maximum impressions (9,677)
-- and the lowest minimum impressions (3,264), indicating limited visibility.
--
-- IG Images and IG Videos showed moderate impression performance,
-- but neither matched the reach potential of Reels.
--
-- Recommendation:
-- Increase focus on Reel-based content to maximize audience visibility
-- and impressions, while reviewing the effectiveness of Carousel posts.

## Test Data

SELECT DISTINCT post_type
FROM fact_content;

SELECT DISTINCT post_category
FROM fact_content;

SELECT *
FROM fact_content
LIMIT 10;

#Q3. Filter all the posts that were published on a weekend in the month of March and April and export them to a separate csv file. 

SELECT fc.*
FROM fact_content fc
JOIN dim_dates dd
    ON fc.date = dd.date
WHERE dd.weekday_or_weekend = 'Weekend'
  AND dd.month_name IN ('March','April');
  
  -- Insight:
-- A total of 17 posts were published on weekends during March and April.
-- The extracted dataset can be used to analyze weekend posting performance,
-- engagement trends, and content effectiveness separately from weekday posts.

-- Recommendation:
-- Compare weekend performance against weekday performance to identify
-- whether weekends generate higher reach, impressions, or engagement.

#Q4. Create a report to get the statistics for the account. The final output includes the following fields: 
#• month_name 
#• total_profile_visits 
#• total_new_followers 

SELECT
    dd.month_name,
    SUM(fa.profile_visits) AS total_profile_visits,
    SUM(fa.new_followers) AS total_new_followers
FROM fact_account fa
JOIN dim_dates dd
    ON fa.date = dd.date
GROUP BY dd.month_name
ORDER BY MIN(fa.date);

-- Insight:
-- Profile visits and follower growth showed a significant increase during May and June compared to earlier months.
-- June recorded the highest number of new followers (76,942),
-- while May recorded the highest profile visits (106,571).

-- After June, both profile visits and follower acquisition declined,
-- indicating a possible reduction in campaign effectiveness or audience engagement.

-- Recommendation:
-- Analyze the content strategy and campaigns executed during May and June
-- to identify factors that drove the spike in profile visits and follower growth.
-- Replicating successful content formats from these months may help improve
-- future account performance.

#Q5. Write a CTE that calculates the total number of 'likes’ for each 
#'post_category' during the month of 'July' and subsequently, arrange the 
#'post_category' values in descending order according to their total likes. 

WITH july_likes AS
(
    SELECT
        fc.post_category,
        SUM(fc.likes) AS total_likes
    FROM fact_content fc
    JOIN dim_dates dd
        ON fc.date = dd.date
    WHERE dd.month_name = 'July'
    GROUP BY fc.post_category
)
SELECT *
FROM july_likes
ORDER BY total_likes DESC;

-- Insight:
-- 'Other Gadgets' received the highest number of likes (26,519) in July,
-- followed by 'Tech Tips' (20,296).
--
-- 'Smartwatch' generated the lowest engagement with only 3,918 likes,
-- indicating lower audience interest compared to other categories.
--
-- Mobile and Earphone content performed moderately well, but were
-- outperformed by Other Gadgets and Tech Tips.

-- Recommendation:
-- Increase the frequency of content related to Other Gadgets and Tech Tips,
-- as these categories demonstrate stronger audience engagement.
-- Review the Smartwatch content strategy to identify opportunities
-- for improving user interest and interaction.

#Q6. Create a report that displays the unique post_category names alongside their respective counts for each month. 
# The output should have three columns:  
#• month_name 
#• post_category_names  
#• post_category_count 

#Example:  
#• 'April', 'Earphone,Laptop,Mobile,Other Gadgets,Smartwatch', '5' 
#• 'February', 'Earphone,Laptop,Mobile,Smartwatch', '4'

SELECT
    dd.month_name,
    GROUP_CONCAT(
        DISTINCT fc.post_category
        ORDER BY fc.post_category
        SEPARATOR ' , '
    ) AS post_category_names,
    COUNT(DISTINCT fc.post_category) AS post_category_count
FROM fact_content fc
JOIN dim_dates dd
    ON fc.date = dd.date
GROUP BY dd.month_name
ORDER BY MIN(fc.date);

-- Insight:
-- The variety of content categories increased over time, indicating a
-- broader content strategy and diversification of topics.
--
-- January had only 3 content categories, while May recorded the highest
-- category diversity with 6 unique content categories.
--
-- 'Tech Tips' and 'Other Gadgets' were introduced later in the year,
-- expanding the content portfolio and providing audiences with a wider
-- range of content topics.
--
-- After May, the number of active content categories stabilized between
-- 4 and 5 categories per month.

-- Recommendation:
-- Maintain a diverse content mix to cater to different audience interests.
-- Further analysis should be performed to identify which categories
-- contribute most to reach, engagement, and follower growth.

#Q7. What is the percentage breakdown of total reach by post type?  The final output includes the following fields: 
#• post_type 
#• total_reach 
#• reach_percentage 

SELECT
    post_type,
    SUM(reach) AS total_reach,
    ROUND(
        SUM(reach) * 100.0 /
        (SELECT SUM(reach) FROM fact_content),
        2
    ) AS reach_percentage
FROM fact_content
GROUP BY post_type
ORDER BY total_reach DESC;

-- Insight:
-- IG Reels contributed 61.63% of the total account reach,
-- making them the most effective content format for reaching audiences.
--
-- IG Images generated 21.38% of total reach, while IG Videos
-- contributed 16.30%.
--
-- IG Carousel posts accounted for only 0.69% of total reach,
-- indicating significantly lower visibility compared to other formats.
--
-- Recommendation:
-- Prioritize Reel content in the content strategy, as it delivers
-- the highest audience reach and visibility.
--
-- Consider reducing dependence on Carousel posts or revising their
-- content approach to improve performance.

#Q8. Create a report that includes the quarter, total comments, and total saves recorded for each post category. 
#Assign the following quarter groupings: 

#(January, February, March) → “Q1” 
#(April, May, June) → “Q2” 
#(July, August, September) → “Q3” 

#The final output columns should consist of: 
#• post_category 
#• quarter 
#• total_comments 
#• total_saves


WITH quarter_data AS
(
    SELECT
        fc.post_category,
        fc.comments,
        fc.saves,
        CASE
            WHEN dd.month_name IN ('January','February','March') THEN 'Q1'
            WHEN dd.month_name IN ('April','May','June') THEN 'Q2'
            WHEN dd.month_name IN ('July','August','September') THEN 'Q3'
        END AS quarter
    FROM fact_content fc
    JOIN dim_dates dd
        ON fc.date = dd.date
)
SELECT
    post_category,
    quarter,
    SUM(comments) AS total_comments,
    SUM(saves) AS total_saves
FROM quarter_data
GROUP BY post_category, quarter
ORDER BY post_category, quarter;

-- Insight:
-- Q2 (April–June) recorded the highest engagement levels across most content categories.
--
-- Mobile content was the strongest performer overall, generating the highest
-- number of comments (2,313) and saves (17,207) in Q2.
--
-- Tech Tips emerged as a high-engagement category immediately after its introduction,
-- generating 2,201 comments and 17,649 saves in Q2, the highest saves among all categories.
--
-- Other Gadgets also performed exceptionally well, receiving 12,041 saves in Q2,
-- indicating strong audience interest in gadget-related content.
--
-- Across all categories, saves were significantly higher than comments,
-- suggesting users found the content valuable enough to revisit or reference later.

-- Recommendation:
-- Continue prioritizing Mobile, Tech Tips, and Other Gadgets content,
-- as these categories consistently drive strong audience engagement.
--
-- Analyze the content themes and posting strategies used in Q2,
-- as this quarter generated the highest interaction levels across multiple categories.

#Q9. List the top three dates in each month with the highest number of new followers. 
#The final output should include the following columns: 

#• month 
#• date 
#• new_followers

WITH ranked_followers AS
(
    SELECT
        dd.month_name,
        fa.date,
        fa.new_followers,
        ROW_NUMBER() OVER
        (
            PARTITION BY dd.month_name
            ORDER BY fa.new_followers DESC
        ) AS rn
    FROM fact_account fa
    JOIN dim_dates dd
        ON fa.date = dd.date
)

SELECT
    month_name,
    date,
    new_followers
FROM ranked_followers
WHERE rn <= 3
ORDER BY date;

-- Insight:
-- The highest follower acquisition days were concentrated between May and June,
-- indicating a strong growth phase for the account during this period.
--
-- May recorded the highest single-day follower gain of 8,872 followers
-- on 2023-05-08.
--
-- June continued the growth momentum, with multiple days generating
-- more than 8,800 new followers.
--
-- In comparison, January, February, August, and September recorded
-- relatively lower peak follower gains, suggesting slower audience growth.
--
-- The data indicates that content, campaigns, or promotional activities
-- executed during May and June were particularly effective in attracting
-- new followers.

-- Recommendation:
-- Analyze the content published on the top-performing dates in May and June
-- to identify the factors driving follower growth.
--
-- Replicating similar content formats, posting schedules, or campaigns
-- may help accelerate future audience acquisition.

#TEST DATA
SELECT DISTINCT week_no
FROM dim_dates
ORDER BY week_no;

#Q10. Create a stored procedure that takes the 'Week_no' as input and generates a report displaying the total shares 
# for each 'Post_type'. The output of the procedure should consist of two columns: 

#• post_type 
#• total_shares

DELIMITER $$

CREATE PROCEDURE get_total_shares_by_week
(
    IN p_week_no VARCHAR(10)
)
BEGIN

    SELECT
        fc.post_type,
        SUM(fc.shares) AS total_shares
    FROM fact_content fc
    JOIN dim_dates dd
        ON fc.date = dd.date
    WHERE dd.week_no = p_week_no
    GROUP BY fc.post_type;

END $$

DELIMITER ;


SHOW PROCEDURE STATUS
WHERE Db = 'gdb0120';

CALL get_total_shares_by_week('W17');
CALL get_total_shares_by_week('W30');
CALL get_total_shares_by_week('W25');

-- Example:
-- CALL get_total_shares_by_week('W25');

-- Insight:
-- The stored procedure enables dynamic analysis of content-sharing performance
-- across different weeks without rewriting the query.
--
-- By simply changing the input week number, stakeholders can quickly identify
-- which content formats generated the highest number of shares during a specific period.
--
-- This approach improves reusability, automation, and reporting efficiency.

-- Recommendation:
-- Use this procedure for weekly performance monitoring and trend analysis.
--
-- Track the top-performing post types each week and align future content planning
-- with the formats that consistently generate higher shares.


















































































