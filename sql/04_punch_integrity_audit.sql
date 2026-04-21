USE hr_audit;
GO

SELECT
    punch_flag                                                              AS flag_type,
    COUNT(*)                                                                AS record_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Attendance), 1)         AS pct_of_total
FROM Attendance
GROUP BY punch_flag
ORDER BY record_count DESC;