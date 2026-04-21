USE hr_audit;
GO

SELECT
    emp_name,
    COUNT(*)                                                                        AS total_days,
    SUM(CASE WHEN status_clean = 'Present'         THEN 1 ELSE 0 END)              AS present_days,
    SUM(CASE WHEN status_clean = 'Absent'          THEN 1 ELSE 0 END)              AS absent_days,
    SUM(CASE WHEN status_clean = 'Weekend Present' THEN 1 ELSE 0 END)              AS weekend_present,
    ROUND(100.0 * SUM(CASE WHEN status_clean = 'Present' THEN 1 ELSE 0 END) /
        NULLIF(SUM(CASE WHEN status_clean
            IN ('Present', 'Absent') THEN 1 ELSE 0 END), 0), 1)                    AS attendance_rate_pct
FROM Attendance
GROUP BY emp_name
ORDER BY attendance_rate_pct ASC;