-- Creating table Crime Statistics 
CREATE TABLE pet_project.CrimeStatistics (
    Region_Name VARCHAR(100) NOT NULL,
    Violent INT NOT NULL,
    Minor_Crimes INT NOT NULL,
    Serious_Crimes INT NOT NULL,
    Very_Serious_Crimes INT NOT NULL
);

-- Inserting crime data per district
INSERT INTO pet_project.CrimeStatistics (Region_Name, Violent, Minor_Crimes, Serious_Crimes, Very_Serious_Crimes)
VALUES
    ('Holosiivskyi distr.', 1180, 795, 2327, 584),
    ('Darnytskyi distr.', 1124, 916, 2446, 276),
    ('Desnianskyi distr.', 874, 386, 1765, 183),
    ('Dniprovskyi distr.', 1015, 651, 2347, 251),
    ('Obolon distr.', 1059, 604, 2212, 180),
    ('Pechersk distr.', 686, 840, 2999, 646),
    ('Podilskyi distr.', 778, 509, 1584, 179),
    ('Sviatoshynskyi distr.', 940, 880, 2152, 174),
    ('Solomianskyi distr.', 977, 1170, 2131, 619),
    ('Shevchenkivskyi distr.', 1221, 1170, 3267, 596);

-- Creating table for districts' details
CREATE TABLE IF NOT EXISTS pet_project.districts (
    name VARCHAR(255) UNIQUE NOT NULL,
    area DECIMAL(10, 2),
    population INT
);

-- Inserting district details: area and population
INSERT INTO pet_project.districts (name, area, population) VALUES
('Holosiivskyi distr.', 156, 247600),
('Darnytskyi distr.', 134, 314700),
('Desnianskyi distr.', 148, 358300),
('Dniprovskyi distr.', 67, 354700),
('Obolon distr.', 108.6, 319000),
('Pechersk distr.', 27, 152000),
('Podilskyi distr.', 34, 198100),
('Sviatoshynskyi distr.', 110, 340700),
('Solomianskyi distr.', 40, 383259),
('Shevchenkivskyi distr.', 26.6, 218900);

-- Creating a view to join crime statistics with camera data
CREATE VIEW pet_project.crimestatistics_kyiv_cam_view AS
SELECT 
    cs.*,  -- All columns from CrimeStatistics
    kc.*   -- All columns from kyiv_cam
FROM pet_project.CrimeStatistics cs 
JOIN pet_project.kyiv_cam kc
ON cs.Region_Name = kc.Districts;

-- Counting the number of cameras by model, replacing unknown values
WITH cte1 AS (
    SELECT 
        CASE 
            WHEN Model_cam LIKE '%Не вказана%' THEN 'Unknown'
            ELSE Model_cam
        END AS Model_cam1
    FROM pet_project.crimestatistics_kyiv_cam_view
)
SELECT 
    Model_cam1, 
    COUNT(*) AS Amount_Cam 
FROM cte1
GROUP BY Model_cam1
ORDER BY Amount_Cam DESC;

-- Calculating total crimes per district
SELECT 
    Region_Name AS District, 
    SUM(Violent + Minor_Crimes + Serious_Crimes + Very_Serious_Crimes) AS Total_Crimes
FROM pet_project.CrimeStatistics
GROUP BY Region_Name
ORDER BY Total_Crimes DESC;

-- Calculating camera and crime density per km²
WITH cte2 AS (
    SELECT
        cs.Region_Name AS District,
        COUNT(kc.Model_cam) AS As_Cam,
        (
            SELECT 
                SUM(Violent) + SUM(Minor_Crimes) + SUM(Serious_Crimes) + SUM(Very_Serious_Crimes)
            FROM pet_project.CrimeStatistics
            WHERE Region_Name = cs.Region_Name
        ) AS Total_Crimes,
        d.area AS area
    FROM pet_project.CrimeStatistics cs
    JOIN pet_project.kyiv_cam kc ON cs.Region_Name = kc.Districts
    JOIN pet_project.districts d ON cs.Region_Name = d.name
    GROUP BY cs.Region_Name, d.area
),
cte3 AS (
    SELECT
        District,
        As_Cam,
        Total_Crimes,
        (As_Cam / area) AS cam_per_km,  -- Camera density
        (Total_Crimes / area) AS crime_per_km  -- Crime density
    FROM cte2
)
SELECT
    District,
    As_Cam,
    Total_Crimes,
    cam_per_km,
    crime_per_km
FROM cte3
ORDER BY crime_per_km DESC;

-- Calculating crime rate deviation from the mean
WITH cte4 AS (
    SELECT 
        District,
        cam_per_km,
        crime_per_km,
        AVG(crime_per_km) OVER() AS av_crime,  -- Average crime density
        crime_per_km - AVG(crime_per_km) OVER() AS dev,  -- Deviation from the mean
        (crime_per_km - AVG(crime_per_km) OVER()) / AVG(crime_per_km) OVER() * 100 AS percent_dev  -- % deviation
    FROM cte3
)
SELECT District, cam_per_km, crime_per_km, av_crime, dev, percent_dev FROM cte4 
ORDER BY 3;

-- Assigning crime quartiles and camera terciles
WITH ranked AS (
    SELECT 
        District,
        crime_per_km,
        cam_per_km,
        ROW_NUMBER() OVER (ORDER BY crime_per_km DESC) AS crime_rank,  -- Rank by crime density
        ROW_NUMBER() OVER (ORDER BY cam_per_km DESC) AS cam_rank  -- Rank by camera density
    FROM cte3
)
SELECT 
    r.District,
    r.crime_per_km,
    r.cam_per_km,
    CEIL(r.crime_rank / (SELECT COUNT(*) FROM cte3) * 4) AS crime_quartile,  -- Divide into 4 groups
    CEIL(r.cam_rank / (SELECT COUNT(*) FROM cte3) * 3) AS camera_tercile,  -- Divide into 3 groups
    c.dev,
    c.percent_dev
FROM ranked r
JOIN cte4 c ON r.District = c.District;
