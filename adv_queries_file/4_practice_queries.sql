CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT 
    job_title_short,
    job_location,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;



SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;  

-- CTEs

WITH january_jobs AS(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT *
FROM january_jobs;

SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = True
    ORDER BY
        company_id
)


-- company with most job postings

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN 
    company_job_count ON 
    company_job_count.company_id = company_dim.company_id

ORDER BY
    total_jobs DESC;


-- filtering for remote jobs

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id

    WHERE
        job_postings.job_work_from_home = True
    GROUP BY
        skill_id
)
SELECT
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON
    skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 10;


-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION -- union companies from Feb and later add MAR jobs

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION -- Note: UNION all would return all values including duplicates.

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs



-- UNION practice, filtering for data analyst jobs

SELECT
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date:: DATE,
    quarter1_job_postings.salary_year_avg

FROM (
    SELECT *
    FROM january_jobs
    UNION ALL 
    SELECT *
    FROM february_jobs
    UNION ALL 
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings

WHERE
    quarter1_job_postings.salary_year_avg > 70_000 and
    quarter1_job_postings.job_title_short = 'Data Analyst'

ORDER BY
    quarter1_job_postings.salary_year_avg DESC;

--
