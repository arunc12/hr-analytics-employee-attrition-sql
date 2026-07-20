create database project_hr_analytics;

Use project_hr_analytics;
select * from hr_data_updated;

select count(Employee_ID) from hr_data_updated;

select gender from hr_data_updated;

-- DATA CLEANING


CREATE TABLE adviti_hr_data_final AS 
SELECT 
Employee_ID,
Employee_Name,
Age,
CASE 
	  WHEN Age BETWEEN 21 AND 25 THEN '21-25'
	  WHEN Age BETWEEN 26 AND 30 THEN '26-30'
    WHEN Age BETWEEN 31 AND 35 THEN '31-35'
    WHEN Age BETWEEN 36 AND 40 THEN '36-40'
    WHEN Age BETWEEN 41 AND 45 THEN '41-45'
    WHEN Age BETWEEN 46 AND 50 THEN '46-50'
    ELSE '<=20'
END AS AgeGroup,
Position,
CASE 
	  WHEN Position IN ('Account Exec.', 'Account Executive', 'AccountExec.', 'AccountExecutive') THEN 'Account Executive'
    WHEN Position IN ('Content Creator', 'Creator') THEN 'Content Creator'
    WHEN Position IN ('DataAnalyst', 'Data Analyst') THEN 'Data Analyst'
    ELSE Position
END AS Position_updated,
REPLACE(REPLACE(REPLACE(REPLACE(Gender, 'Male', 'M'), 'Female', 'F'), 'M', 'Male'), 'F', 'Female') AS Gender,
CASE 
	WHEN Department IS NULL THEN 'Management' 
    ELSE Department 
END AS Department,
Salary,
    CASE 
		WHEN Salary >= 5000000 THEN '> 50L'
        WHEN Salary >= 4000000 THEN '40L - 50L'
        WHEN Salary >= 3000000 THEN '30L - 40L'
        WHEN Salary >= 2000000 THEN '20L - 30L'
        WHEN Salary >= 1000000 THEN '10L - 20L'
        ELSE '< 10L'
	END AS Salary_Buckets,
Attrition,
HireDate_dt, 
ExitDate_dt,
TIMESTAMPDIFF(YEAR, HireDate_dt, IFNULL(ExitDate_dt,CURDATE())) AS Years_of_Service,
Performance_Rating,
Work_Hours,
Promotion,
LastPromotion_dt,
Training_Hours,
CASE 
	WHEN Training_Hours >= 40 THEN '40+ Hours'
	WHEN Training_Hours >= 30 THEN '30 - 40 Hours'
	WHEN Training_Hours >= 20 THEN '20 - 30 Hours'
	WHEN Training_Hours >= 10 THEN '10 - 20 Hours'
	ELSE '< 10 Hours'
END AS Training_Hours_Buckets,
Education_Level,
Employee_Engagement_Score,
Absenteeism,
CASE
	WHEN Absenteeism = 0 THEN 'No Leaves'
	WHEN Absenteeism BETWEEN 1 AND 5 THEN '1-5 days'
	WHEN Absenteeism BETWEEN 6 AND 10 THEN '6-10 days'
	WHEN Absenteeism BETWEEN 11 AND 15 THEN '11-15 days'
	ELSE '15+ days'
END AS Absenteeism_Buckets,
Distance_from_Work,
CASE 
	WHEN Distance_from_Work >= 40 THEN '40+ Kms'
	WHEN Distance_from_Work >= 30 THEN '30 - 40 Kms'
	WHEN Distance_from_Work >= 20 THEN '20 - 30 Kms'
	WHEN Distance_from_Work >= 10 THEN '10 - 20 Kms'
	ELSE '< 10 Kms'
END AS Distance_from_Work_Buckets,
JobSatisfaction_PeerRelationship,
JobSatisfaction_WorkLifeBalance,
JobSatisfaction_Compensation,
JobSatisfaction_Management,
JobSatisfaction_JobSecurity,
(JobSatisfaction_PeerRelationship +
JobSatisfaction_WorkLifeBalance +
JobSatisfaction_Compensation +
JobSatisfaction_Management +
JobSatisfaction_JobSecurity)/5*100 AS JobSatisfaction_rate,    
EmployeeBenefit_HealthInsurance,
EmployeeBenefit_PaidLeave,
EmployeeBenefit_RetirementPlan,
EmployeeBenefit_GymMembership,
EmployeeBenefit_ChildCare,
(EmployeeBenefit_HealthInsurance +
EmployeeBenefit_PaidLeave +
EmployeeBenefit_RetirementPlan +
EmployeeBenefit_GymMembership +
EmployeeBenefit_ChildCare)/5*100 AS EmployeeBenefit_Satisfaction_rate
FROM hr_data_updated;

SELECT COUNT(*) FROM adviti_hr_data_final;
select * from hr_data_updated;
select * from adviti_hr_data_final;


-- so here hr_data_updated is the raw data And
-- adviti_hr_data_final is the final cleaned data ,so im using this cleaned datasets for upcoming queries..


SELECT DISTINCT Gender FROM adviti_hr_data_final;

SELECT DISTINCT Position_updated FROM adviti_hr_data_final
ORDER BY Position_updated;

-- Phase 1 --  Workforce Overview


-- 1.1 Gender Distribution
SELECT
  Gender,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM adviti_hr_data_final
GROUP BY Gender
ORDER BY emp_count DESC;

-- 1.2 Age Distribution
SELECT
  MIN(Age) AS min_age,
  ROUND(AVG(Age), 2) AS avg_age,
  MAX(Age) AS max_age
FROM adviti_hr_data_final;

SELECT
  AgeGroup,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY AgeGroup
ORDER BY emp_count DESC;

-- 1.3 Department Distribution
SELECT
  Department,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY Department
ORDER BY emp_count DESC;

-- 1.4 Position Distribution
SELECT
  Position_updated,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY Position_updated
ORDER BY emp_count DESC;

-- 1.5 Education Level Distribution
SELECT
   Education_Level,
   count(*) AS emp_count,
   ROund(100*count(*)/SUM(count(*)) over(),2)as pct
from Adviti_hr_data_final
Group By Education_Level
Order By emp_count Desc;   

-- 1.6 Salary Distribution
SELECT 
   min(Salary) AS min_Salary,
   Round(avg(Salary),2) as avg_Salary,
   max(Salary) AS Max_Salary
   From adviti_hr_data_final;

-- salary Buckets 

SELECT
Salary_Buckets,
count(*) AS emp_count,
ROUND(100*count(*)/sum(count(*)) over(), 2) as pct
from adviti_hr_data_final
group by salary_buckets
order by emp_count desc;

-- 1.7 Years of Distribution
-- service summary
select min(years_of_service) AS min_years,
Round(avg(years_of_service), 2) AS Avg_Years,
max(years_of_service) AS max_years
From adviti_hr_data_final;

-- service bucket distribution
select
case 
when years_of_service < 1 then '<1 year'
when years_of_service between 1 and 2 then '1-2 years'
when years_of_service between 3 and 5 then '3-5 years'
when years_of_service between 6 and 10 then '6-10 years'
else '10+years'
end as service_bucket,
count(*) AS emp_count,
round(100*count(*)/sum(count(*)) over(), 2) as pct
from adviti_hr_data_final
group by service_bucket
order by emp_count desc;

--  1.8 Performance rating distribution

SELECT
  Performance_Rating,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY Performance_Rating
ORDER BY Performance_Rating;

select promotion,COUNT(*) AS emp_count,
ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY promotion
ORDER BY emp_count DESC;


-- 1.9 Training hours Distribution
SELECT
  Training_Hours_Buckets,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY Training_Hours_Buckets
ORDER BY emp_count DESC;

-- 1.10 Engagement Score and Absenteeism
SELECT
  Employee_Engagement_Score,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY Employee_Engagement_Score
ORDER BY Employee_Engagement_Score;

SELECT
  MIN(Absenteeism) AS min_absent_days,
  ROUND(AVG(Absenteeism), 2) AS avg_absent_days,
  MAX(Absenteeism) AS max_absent_days
FROM adviti_hr_data_final;

-- 1.11 Overall Attrition baseline

SELECT
  Attrition,
  COUNT(*) AS emp_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM adviti_hr_data_final
GROUP BY Attrition
ORDER BY emp_count DESC;


-- Phase 2 
-- Attrition Distribution (Where is Atttrition High?)

-- Attrition by Age Group
-- 2.1) Attrition % by AgeGroup
SELECT
  AgeGroup,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY AgeGroup
ORDER BY attrition_pct DESC, total_employees DESC;

-- 2.2 Attrition by years of service

SELECT
  CASE
    WHEN Years_of_Service < 1 THEN '< 1 year'
    WHEN Years_of_Service BETWEEN 1 AND 2 THEN '1-2 years'
    WHEN Years_of_Service BETWEEN 3 AND 5 THEN '3-5 years'
    WHEN Years_of_Service BETWEEN 6 AND 10 THEN '6-10 years'
    ELSE '10+ years'
  END AS service_bucket,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY service_bucket
ORDER BY attrition_pct DESC, total_employees DESC;

-- 2.3 Attrition by Department
SELECT
  Department,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY Department
ORDER BY attrition_pct DESC, total_employees DESC;

-- 2.4 Attrition by position group
SELECT
  position_group,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM (
  SELECT
    Employee_ID,
    Attrition,
    Position_updated,
    CASE
      WHEN Position_updated IN ('CEO','COO','CTO','Director','Head Data Analytics','IT Support Head','Datawarehouse lead')
        THEN 'Leadership'
      WHEN Position_updated LIKE '%Manager%' OR Position_updated LIKE '%Team Leader%'
        THEN 'Management'
      WHEN Position_updated = 'Interns'
        THEN 'Interns'
      ELSE 'Individual Contributor'
    END AS position_group
  FROM adviti_hr_data_final
) x
GROUP BY position_group
ORDER BY attrition_pct DESC, total_employees DESC;

-- 2.5 Attrition by Engagement Score
SELECT
  CASE
    WHEN Employee_Engagement_Score IN (1,2) THEN 'Low (1-2)'
    WHEN Employee_Engagement_Score = 3 THEN 'Medium (3)'
    WHEN Employee_Engagement_Score IN (4,5) THEN 'High (4-5)'
    ELSE 'Unknown'
  END AS engagement_bucket,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY engagement_bucket
ORDER BY attrition_pct DESC, total_employees DESC;

-- 2.6 Attrition by Job Satisfaction,Promotion,training And Salary

SELECT
  CASE
    WHEN JobSatisfaction_rate < 40 THEN '<40%'
    WHEN JobSatisfaction_rate < 60 THEN '40-59%'
    WHEN JobSatisfaction_rate < 80 THEN '60-79%'
    ELSE '80-100%'
  END AS job_sat_bucket,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY job_sat_bucket
ORDER BY attrition_pct DESC, total_employees DESC;

-- by promotion
 
SELECT
  Promotion,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY Promotion
ORDER BY attrition_pct DESC, total_employees DESC;

-- by Training Bucket

SELECT
  Training_Hours_Buckets,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY Training_Hours_Buckets
ORDER BY attrition_pct DESC, total_employees DESC;

-- by Salary Bucket
SELECT
  Salary_Buckets,
  COUNT(*) AS total_employees,
  SUM(Attrition = 'Yes') AS leavers,
  ROUND(100 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY Salary_Buckets
ORDER BY attrition_pct DESC, total_employees DESC;

-- Phase 3 Deep Analysis(why is Attrition is happening)

-- 3.1 Tenure x Department (Where is early attrition worst?)
SELECT
  CASE
    WHEN Years_of_Service < 1 THEN '< 1 year'
    WHEN Years_of_Service BETWEEN 1 AND 2 THEN '1-2 years'
    WHEN Years_of_Service BETWEEN 3 AND 5 THEN '3-5 years'
    WHEN Years_of_Service BETWEEN 6 AND 10 THEN '6-10 years'
    ELSE '10+ years'
  END AS service_bucket,
  Department,
  COUNT(*) AS total,
  SUM(Attrition='Yes') AS leavers,
  ROUND(100*SUM(Attrition='Yes')/COUNT(*),2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY service_bucket, Department
HAVING COUNT(*) >= 10
ORDER BY service_bucket, attrition_pct DESC;

-- 3.2 Training x Promotion (Does training lead to growth and retention?)
SELECT
  Training_Hours_Buckets,
  Promotion,
  COUNT(*) AS total,
  SUM(Attrition='Yes') AS leavers,
  ROUND(100*SUM(Attrition='Yes')/COUNT(*),2) AS attrition_pct,
  ROUND(AVG(Training_Hours),2) AS avg_training_hours
FROM adviti_hr_data_final
GROUP BY Training_Hours_Buckets, Promotion
HAVING COUNT(*) >= 10
ORDER BY Training_Hours_Buckets, attrition_pct DESC;

-- 3.3 Training x Engagement (Does training improve engagement?)
SELECT
  Training_Hours_Buckets,
  CASE
    WHEN Employee_Engagement_Score IN (1,2) THEN 'Low (1-2)'
    WHEN Employee_Engagement_Score = 3 THEN 'Medium (3)'
    WHEN Employee_Engagement_Score IN (4,5) THEN 'High (4-5)'
    ELSE 'Unknown'
  END AS engagement_bucket,
  COUNT(*) AS total,
  SUM(Attrition='Yes') AS leavers,
  ROUND(100*SUM(Attrition='Yes')/COUNT(*),2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY Training_Hours_Buckets, engagement_bucket
HAVING COUNT(*) >= 10
ORDER BY Training_Hours_Buckets, attrition_pct DESC;

-- 3.4 Satisfaction Dimensions (Which satisfaction factor drives most attrition?)
SELECT 'PeerRelationship' AS dimension,
  SUM(JobSatisfaction_PeerRelationship=1) AS satisfied,
  SUM(JobSatisfaction_PeerRelationship=0) AS not_satisfied,
  ROUND(100*SUM((JobSatisfaction_PeerRelationship=1) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_PeerRelationship=1),0),2) AS attrition_pct_if_satisfied,
  ROUND(100*SUM((JobSatisfaction_PeerRelationship=0) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_PeerRelationship=0),0),2) AS attrition_pct_if_not_satisfied
FROM adviti_hr_data_final
UNION ALL
SELECT 'WorkLifeBalance',
  SUM(JobSatisfaction_WorkLifeBalance=1),
  SUM(JobSatisfaction_WorkLifeBalance=0),
  ROUND(100*SUM((JobSatisfaction_WorkLifeBalance=1) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_WorkLifeBalance=1),0),2),
  ROUND(100*SUM((JobSatisfaction_WorkLifeBalance=0) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_WorkLifeBalance=0),0),2)
FROM adviti_hr_data_final
UNION ALL
SELECT 'Compensation',
  SUM(JobSatisfaction_Compensation=1),
  SUM(JobSatisfaction_Compensation=0),
  ROUND(100*SUM((JobSatisfaction_Compensation=1) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_Compensation=1),0),2),
  ROUND(100*SUM((JobSatisfaction_Compensation=0) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_Compensation=0),0),2)
FROM adviti_hr_data_final
UNION ALL
SELECT 'Management',
  SUM(JobSatisfaction_Management=1),
  SUM(JobSatisfaction_Management=0),
  ROUND(100*SUM((JobSatisfaction_Management=1) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_Management=1),0),2),
  ROUND(100*SUM((JobSatisfaction_Management=0) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_Management=0),0),2)
FROM adviti_hr_data_final
UNION ALL
SELECT 'JobSecurity',
  SUM(JobSatisfaction_JobSecurity=1),
  SUM(JobSatisfaction_JobSecurity=0),
  ROUND(100*SUM((JobSatisfaction_JobSecurity=1) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_JobSecurity=1),0),2),
  ROUND(100*SUM((JobSatisfaction_JobSecurity=0) AND (Attrition='Yes'))
    / NULLIF(SUM(JobSatisfaction_JobSecurity=0),0),2)
FROM adviti_hr_data_final;

-- 3.5 Absenteeism x Engagement (The early warning signal)
SELECT
  Absenteeism_Buckets,
  CASE
    WHEN Employee_Engagement_Score IN (1,2) THEN 'Low (1-2)'
    WHEN Employee_Engagement_Score = 3 THEN 'Medium (3)'
    WHEN Employee_Engagement_Score IN (4,5) THEN 'High (4-5)'
    ELSE 'Unknown'
  END AS engagement_bucket,
  COUNT(*) AS total,
  SUM(Attrition='Yes') AS leavers,
  ROUND(100*SUM(Attrition='Yes')/COUNT(*),2) AS attrition_pct
FROM adviti_hr_data_final
GROUP BY Absenteeism_Buckets, engagement_bucket
HAVING COUNT(*) >= 10
ORDER BY Absenteeism_Buckets, attrition_pct DESC;













