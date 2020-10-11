/* Calculation of 90th percentile of DomInteractive time at each minute od the day for previous 10 minutes (BigQuery Standard SQL) */

WITH timeFrames AS (
      SELECT DISTINCT TIMESTAMP_SUB(TIMESTAMP_TRUNC(Date, MINUTE), INTERVAL 8 MINUTE) AS DateStart
                     ,TIMESTAMP_ADD(TIMESTAMP_TRUNC(Date, MINUTE), INTERVAL 1 MINUTE) AS DateEnd           
      FROM data_tbl)

SELECT Date
      ,AVG(DomInteractive90thPercentile) AS DomInteractive90thPercentile
FROM (      
    SELECT t.DateEnd AS Date      
          ,PERCENTILE_CONT(d.DOMInteractive, 0.9) OVER (PARTITION BY t.DateEnd) AS DomInteractive90thPercentile
    FROM data_tbl d
    INNER JOIN timeFrames t ON d.Date >= t.DateStart AND d.Date < t.DateEnd
    )
GROUP BY Date
ORDER BY Date