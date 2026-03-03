#which categories have the highest average engagement rate?
SELECT category_id,
       AVG(engagement_rate) AS avg_engagement
FROM trending_videos
GROUP BY category_id
ORDER BY avg_engagement DESC;

#which videos have unusually high engagement but low views?
SELECT title, channel_title, views, engagement_rate
FROM trending_videos
WHERE views < (
    SELECT AVG(views) FROM trending_videos
)
ORDER BY engagement_rate DESC
LIMIT 10;

Does higher like_ratio lead to more views?
SELECT 
    CASE 
        WHEN like_ratio > 0.1 THEN 'High'
        ELSE 'Low'
    END AS like_group,
    AVG(views) AS avg_views
FROM trending_videos
GROUP BY like_group;

// CHANNEL PERFORMANCE

#Top 10 channels by number of times trending
SELECT channel_title,
       COUNT(*) AS trending_count
FROM trending_videos
GROUP BY channel_title
ORDER BY trending_count DESC
LIMIT 10;

Channels with highest average views (min 5 trending videos)
SELECT channel_title,
       AVG(views) AS avg_views,
       COUNT(*) AS total_trending
FROM trending_videos
GROUP BY channel_title
HAVING COUNT(*) >= 5
ORDER BY avg_views DESC
LIMIT 10;

//CONTENT STRATERGY

#Best publish hour for maximum average views
SELECT publish_hour,
       AVG(views) AS avg_views
FROM trending_videos
GROUP BY publish_hour
ORDER BY avg_views DESC;

#Does description length affect engagement?
SELECT 
    CASE 
        WHEN description_length > 1000 THEN 'Long'
        ELSE 'Short'
    END AS description_group,
    AVG(engagement_rate)
FROM trending_videos
GROUP BY description_group;

#Does title length impact views
SELECT 
    CASE 
        WHEN title_length > 70 THEN 'Long Title'
        ELSE 'Short Title'
    END AS title_group,
    AVG(views)
FROM trending_videos
GROUP BY title_group;

//TRENDING SPEED ANALYSIS

Which categories trend fastest
SELECT category_id,
       AVG(days_to_trend) AS avg_days
FROM trending_videos
GROUP BY category_id
ORDER BY avg_days ASC;

#videos that trended the same day they were published
SELECT title, channel_title, views
FROM trending_videos
WHERE days_to_trend = 0
ORDER BY views DESC;

#correlation proxy: High views but low engagement
SELECT title, views, engagement_rate
FROM trending_videos
WHERE views > (
    SELECT AVG(views) FROM trending_videos
)
AND engagement_rate < (
    SELECT AVG(engagement_rate) FROM trending_videos
)
ORDER BY views DESC;

#category share of total views
SELECT category_id,
       SUM(views) * 100.0 / (SELECT SUM(views) FROM trending_videos) AS percentage_share
FROM trending_videos
GROUP BY category_id
ORDER BY percentage_share DESC;

#channel dominating specific categories
SELECT category_id, channel_title, COUNT(*) AS count
FROM trending_videos
GROUP BY category_id, channel_title
ORDER BY count DESC;

#Top 5 most viewed videos per category
SELECT *
FROM (
    SELECT category_id, title, views,
           RANK() OVER (PARTITION BY category_id ORDER BY views DESC) AS rnk
    FROM trending_videos
) ranked
WHERE rnk <= 5;

Are weekend better for trending?
SELECT EXTRACT(DOW FROM publish_time) AS day_of_week,
       AVG(views)
FROM trending_videos
GROUP BY day_of_week
ORDER BY AVG(views) DESC;


