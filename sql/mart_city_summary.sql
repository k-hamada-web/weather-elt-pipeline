CREATE OR REPLACE TABLE `gen-lang-client-0488662860.weather_demo.mart_city_summary` AS
SELECT
  city,
  COUNT(*) AS days_count,
  ROUND(AVG(temp_max), 1) AS avg_temp_max,
  ROUND(AVG(temp_min), 1) AS avg_temp_min,
  ROUND(AVG(temp_diff), 1) AS avg_temp_diff,
  MAX(temp_diff) AS max_temp_diff
FROM
  `gen-lang-client-0488662860.weather_demo.daily_temp_cities`
GROUP BY
  city;
