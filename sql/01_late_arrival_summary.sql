USE hr_audit;
GO

SELECT
    emp_name,
    COUNT(*)                                                                            AS late_days,
    ROUND(AVG(lateby_mins), 1)                                                          AS avg_late_mins,
    MAX(lateby_mins)                                                                    AS worst_late_mins,
    SUM(CASE WHEN late_category = 'Severe - over 1 hour'   THEN 1 ELSE 0 END)          AS severe_count,
    SUM(CASE WHEN late_category = 'Moderate - 30 to 60 min' THEN 1 ELSE 0 END)         AS moderate_count,
    SUM(CASE WHEN late_category = 'Minor - under 30 min'   THEN 1 ELSE 0 END)          AS minor_count
FROM Attendance
WHERE lateby_mins > 0
  AND status_clean IN ('Present', 'Weekend Present')
GROUP BY emp_name
ORDER BY late_days DESC;