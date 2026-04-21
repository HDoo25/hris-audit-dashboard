USE hr_audit;
GO

SELECT
    emp_name,
    SUM(CASE WHEN status_clean = 'Absent' THEN 1 ELSE 0 END)                           AS absent_days,
    SUM(CASE WHEN late_category = 'Severe - over 1 hour' THEN 1 ELSE 0 END)            AS severe_late_days,
    SUM(CASE WHEN late_category IN (
        'Severe - over 1 hour',
        'Moderate - 30 to 60 min') THEN 1 ELSE 0 END)                                  AS total_late_days,
    ROUND(100.0 * SUM(CASE WHEN status_clean = 'Present' THEN 1 ELSE 0 END) /
        NULLIF(SUM(CASE WHEN status_clean
            IN ('Present', 'Absent') THEN 1 ELSE 0 END), 0), 1)                        AS attendance_rate_pct,
    CASE
        WHEN SUM(CASE WHEN status_clean = 'Absent' THEN 1 ELSE 0 END) >= 15
            THEN 'Critical - immediate review'
        WHEN SUM(CASE WHEN status_clean = 'Absent' THEN 1 ELSE 0 END) >= 10
            THEN 'High - manager follow-up'
        WHEN SUM(CASE WHEN late_category = 'Severe - over 1 hour'
            THEN 1 ELSE 0 END) >= 3
            THEN 'Moderate - coaching needed'
        ELSE 'Monitor'
    END                                                                                 AS hr_action
FROM Attendance
GROUP BY emp_name
HAVING
    SUM(CASE WHEN status_clean = 'Absent' THEN 1 ELSE 0 END) >= 5
    OR SUM(CASE WHEN late_category = 'Severe - over 1 hour' THEN 1 ELSE 0 END) >= 3
ORDER BY absent_days DESC, severe_late_days DESC;