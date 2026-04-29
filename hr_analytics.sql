create database Hr_Analyts;
use Hr_analyts;
drop table hr_final;
CREATE TABLE hr_final AS
SELECT 
    age,
    attrition,
    department,
    jobrole,
    joblevel,
    monthlyincome,
    yearsatcompany,
    totalworkingyears,
    jobsatisfaction,
    worklifebalance,
    environmentsatisfaction,
    relationshipsatisfaction,
    gender,
    education,
    educationfield,
    overtime,
    businesstravel,
    maritalstatus
FROM cleaned_hr_data;
ALTER TABLE cleaned_hr_data
DROP COLUMN dailyrate,
DROP COLUMN hourlyrate,
DROP COLUMN monthlyrate,
DROP COLUMN over18;
# 1.Overall Attrition Rate
SELECT 
    ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_final;
# 2. Attrition by Department
SELECT 
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_final
GROUP BY department
ORDER BY attrition_rate DESC;
#3. Attrition by Salary Band
SELECT 
    CASE 
        WHEN monthlyincome < 3000 THEN 'Low'
        WHEN monthlyincome BETWEEN 3000 AND 7000 THEN 'Medium'
        ELSE 'High'
    END AS salary_band,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_final
GROUP BY salary_band
ORDER BY attrition_rate DESC;
#4. Attrition by Job Role
SELECT 
    jobrole,
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_final
GROUP BY jobrole
ORDER BY attrition_rate DESC;
#5  Attrition by Tenure
SELECT 
    CASE 
        WHEN yearsatcompany <= 2 THEN '0-2 Years'
        WHEN yearsatcompany <= 5 THEN '3-5 Years'
        WHEN yearsatcompany <= 10 THEN '6-10 Years'
        ELSE '10+ Years'
    END AS tenure_group,
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_final
GROUP BY tenure_group
ORDER BY attrition_rate DESC;
#6. Attrition vs Job Satisfaction
SELECT 
    jobsatisfaction,
    COUNT(*) AS total,
    ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_final
GROUP BY jobsatisfaction
ORDER BY jobsatisfaction;
#7 Avg Salary by Attrition
SELECT 
    attrition,
    ROUND(AVG(monthlyincome), 2) AS avg_salary
FROM hr_final
GROUP BY attrition;
#8 High-Risk Employees Count
SELECT count(*) as high_risk
FROM hr_final
WHERE attrition = 'Yes'
AND monthlyincome < 5000
AND jobsatisfaction <= 2
AND yearsatcompany <= 3;
#9 Top 5 High Attrition Job Roles
SELECT 
    jobrole,
    ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_final
GROUP BY jobrole
ORDER BY attrition_rate DESC
LIMIT 5;


