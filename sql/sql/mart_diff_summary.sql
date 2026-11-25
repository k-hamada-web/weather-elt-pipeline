CREATE OR REPLACE TABLE `gen-lang-client-0488662860.weather_demo.mart_diff_summary` AS
WITH categorized_days AS (
  SELECT
    city,
    date,
    temp_diff,
    CASE
      WHEN temp_diff >= 10.0 THEN 'Large (>= 10C)'
      WHEN temp_diff >= 5.0 THEN 'Medium (5.0-9.9C)'
      ELSE 'Small (< 5C)'
    END AS diff_category
  FROM
    `gen-lang-client-0488662860.weather_demo.daily_temp_cities`
)
SELECT
  city,
  diff_category,
  COUNT(*) AS days_count,
  ROUND(AVG(temp_diff), 1) AS avg_temp_diff
FROM
  categorized_days
GROUP BY
  city,
  diff_category;
