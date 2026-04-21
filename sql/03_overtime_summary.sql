USE hr_audit;
GO

SELECT
    emp_name,
    COUNT(*)                                AS ot_days,
    ROUND(SUM(ot_mins)  / 60.0, 2)         AS total_ot_hours,
    ROUND(AVG(ot_mins)  / 60.0, 2)         AS avg_ot_per_day_hrs,
    ROUND(MAX(ot_mins)  / 60.0, 2)         AS max_ot_day_hrs
FROM Attendance
WHERE ot_mins > 0
  AND status_clean IN ('Present', 'Weekend Present')
GROUP BY emp_name
ORDER BY total_ot_hours DESC;