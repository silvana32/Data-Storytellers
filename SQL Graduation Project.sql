
SELECT* 
FROM Accident_Table

SELECT 
COUNT(*)
FROM Accident_Table


----------------------------------- Accident factors ---------------------------------------------

-- 1. Which factors contribute most to severe accidents?

SELECT 
     Speed_Limit ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY Speed_Limit
ORDER BY Severe_Accidents DESC 

SELECT 
     Weather_Conditions ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY Weather_Conditions
ORDER BY Severe_Accidents DESC 

SELECT 
      Driver_Alcohol_Level ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Driver_Alcohol_Level
ORDER BY Severe_Accidents DESC 

SELECT 
      Driver_Fatigue ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Driver_Fatigue 
ORDER BY Severe_Accidents DESC 

SELECT 
      Driver_Age_Group ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Driver_Age_Group 
ORDER BY Severe_Accidents DESC 

SELECT 
      Vehicle_Condition ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Vehicle_Condition 
ORDER BY Severe_Accidents DESC

SELECT 
      Road_Condition ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Road_Condition 
ORDER BY Severe_Accidents DESC

SELECT 
     Visibility_Level ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Visibility_Level 
ORDER BY Severe_Accidents DESC

SELECT 
      Traffic_Volume ,
COUNT(*) AS Severe_Accidents 
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Traffic_Volume 
ORDER BY Severe_Accidents DESC


-- 2. How does accident severity vary with speed limits across different countries?

SELECT 
      Country , 
      Accident_Severity ,
COUNT(*) AS Number_of_Accident
FROM Accident_Table
GROUP BY Country ,
         Accident_Severity ,
         Speed_Limit
ORDER BY  Accident_Severity  DESC , 
          Number_of_Accident DESC

-- 2. Is there a noticeable relationship between poor visibility and high fatality rates?

SELECT 
      Visibility_Category ,
SUM(Number_of_Fatalities) AS Sum_of_Fatalities
FROM Accident_Table
GROUP BY Visibility_Category 
ORDER BY Sum_of_Fatalities DESC


-- 4. How do weather conditions (rain, fog, clear) affect the number and severity of accidents?

SELECT 
      Weather_Conditions, 
      Accident_Severity,
COUNT(*) AS Number_of_Accident
FROM Accident_Table
GROUP BY Weather_Conditions,
         Accident_Severity
ORDER BY Number_of_Accident DESC ,
         Weather_Conditions DESC

-- 5. Are accidents more severe during nighttime compared to daytime?

SELECT 
      Time_of_Day ,
COUNT(*) AS Severe_Accident
FROM Accident_Table
WHERE Accident_Severity = 'Severe'
GROUP BY  Time_of_Day
ORDER BY Severe_Accident DESC


-- 6. Which countries have the highest ratio of fatalities to total accidents (fatality rate)?

SELECT 
      Country ,
SUM(Number_of_Fatalities) AS Total_Fatalities,
COUNT(*) AS Total_Accident,
CAST(SUM(Number_of_Fatalities) AS DECIMAL (10,2)) / COUNT(*) AS fatality_rate 
FROM Accident_Table
GROUP BY Country
ORDER BY fatality_rate DESC


-- 7. Does the number of accidents increase in specific weather–visibility combinations?

SELECT 
     Weather_Conditions ,
     Visibility_Category , 
COUNT(*) AS Total_Accident
FROM Accident_Table
GROUP BY  Weather_Conditions,
          Visibility_Category 
ORDER BY Total_Accident DESC 


-- 8. Are rural areas associated with higher fatality rates than urban areas?

SELECT 
     Urban_Rural , 
SUM(Number_of_Fatalities) AS Sum_of_Fatalities ,
COUNT(*) AS Total_Accident ,
CAST(SUM(Number_of_Fatalities) AS DECIMAL (10,2)) / COUNT(*) AS Fatality_Rates
FROM Accident_Table
GROUP BY Urban_Rural
ORDER BY Sum_of_Fatalities DESC 

SELECT 
     Urban_Rural , 
SUM(Number_of_Fatalities) AS Sum_of_Fatalities 
FROM Accident_Table
GROUP BY Urban_Rural
ORDER BY Sum_of_Fatalities DESC


-- 9. What is the average number of fatalities per accident in each country?

SELECT 
      Country , 
AVG(Number_of_Fatalities) AS  AVG_Number_of_Fatalities_Per_Accident
FROM Accident_Table
GROUP BY Country
ORDER BY AVG_Number_of_Fatalities_Per_Accident DESC


-- 10. How does the accident cause affect the severity level?

SELECT 
      Accident_Cause,
      Accident_Severity , 
COUNT(*) AS Total_Accident 
FROM Accident_Table 
GROUP BY  Accident_Cause ,
          Accident_Severity 
ORDER BY Accident_Severity DESC ,
         Total_Accident DESC

      
------------------------------ Temporal & Regional Insights ----------------------------------------

-- 1. How do accidents vary across months or seasons of the year?

SELECT 
     Year, 
     Month , 
COUNT(*) AS Total_Accident
FROM Accident_Table
GROUP BY Year, 
         Month  
ORDER BY Total_Accident DESC  


-- 2. What time of the day records the highest fatal or severe accidents?

SELECT 
      Time_of_Day ,
SUM(Number_of_Fatalities ) AS SUM_Fatalities , 
COUNT(*) AS Total_Accident 
FROM Accident_Table
WHERE  Accident_Severity = 'Severe' 
GROUP BY  Time_of_Day ,
          Accident_Severity  
ORDER BY  SUM_Fatalities DESC ,
          Total_Accident DESC 


-- 3. Do certain weekdays consistently show higher accident frequencies or severity levels?

SELECT 
      Day_of_Week , 
SUM(CASE 
    WHEN Accident_Severity = 'Severe' THEN 1 ELSE 0 END) AS Severe_Accidents , 
COUNT(*) AS Total_Accident
FROM Accident_Table 
GROUP BY  Day_of_Week 
ORDER BY Severe_Accidents DESC , 
         Total_Accident DESC 


-- 4. Are there specific countries showing a consistent monthly or seasonal trend in accidents?

SELECT 
    Country,
    Month,
COUNT(*) Total_Accident,
LAG(COUNT(*)) OVER (PARTITION BY Country ORDER BY Month) AS Prev_Month_Accidents,
COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY Country ORDER BY Month) AS Change_From_Last_Month
FROM Accident_Table
GROUP BY Country, Month
ORDER BY Country, Month


WITH MonthlyAccidents AS (
    SELECT 
        Country,
        Month,
        COUNT(*) AS Total_Accident
    FROM Accident_Table
    GROUP BY Country, Month
)
SELECT 
    Country,
    Month,
    Total_Accident,
    LAG(Total_Accident) OVER (PARTITION BY Country ORDER BY Month) AS Prev_Month_Accidents,
    Total_Accident - LAG(Total_Accident) OVER (PARTITION BY Country ORDER BY Month) AS Change_From_Last_Month
FROM MonthlyAccidents
ORDER BY Country, Month;

-- 5. How do population size and accident counts relate

SELECT 
      Population_Density , 
COUNT(*) AS Total_Accident , 
CAST((COUNT(*) / Population_Density) AS DECIMAL (10, 2)) AS Total_Acciden_Per_Population_Density
FROM Accident_Table 
WHERE Population_Density IS NOT NULL
GROUP BY Population_Density
ORDER BY Total_Acciden_Per_Population_Density DESC


-- 6. Is there a difference in accident patterns between continents?

SELECT 
     Country , 
COUNT(*) AS Total_Accident,
SUM(Number_of_Fatalities ) AS SUM_Fatalities ,
SUM (CASE 
    WHEN Accident_Severity = 'Severe' THEN 1 ELSE 0 END) AS Severe_Accident 
FROM Accident_Table 
GROUP BY Country
ORDER BY Total_Accident DESC


-- 7. Which country shows the fastest increase in accidents over time? 

WITH AccidentSummary AS (
    SELECT 
        Country,
        Year,
        COUNT(*) AS Total_Accident
    FROM Accident_Table
    GROUP BY Country, Year )

SELECT 
    Country,
    Year,
    Total_Accident,
    LAG(Total_Accident) OVER (PARTITION BY Country ORDER BY Year) AS Prev_Year_Accidents,
    Total_Accident - LAG(Total_Accident) OVER (PARTITION BY Country ORDER BY Year) AS Change_From_Last_Year
FROM AccidentSummary
ORDER BY Change_From_Last_Year DESC;



------------------------- Severity & Impact Analysis ------------------------------------

 -- 1.What percentage of accidents result in fatalities vs. injuries?

 SELECT 
COUNT(*) AS Total_Accident , 
SUM (Number_of_Fatalities) AS Total_Fatalities , 
SUM (Number_of_Injuries) AS Total_Injuries , 
CAST(SUM (Number_of_Fatalities)*100 AS DECIMAL(10,2))  / COUNT(*)  AS Fatalities_Percentage ,
CAST(SUM (Number_of_Injuries)*100 AS DECIMAL(10,2)) / COUNT(*) AS Injuries_Percentage
FROM Accident_Table
ORDER BY Total_Accident DESC


-- 2. Which countries have the most critical combination of high accident count and high severity?

SELECT 
      Country, 
      COUNT(*) AS Total_Accident, 
      SUM(CASE WHEN Accident_Severity = 'Severe' THEN 1 ELSE 0 END) AS Severe_Accident,
      CAST(SUM(CASE WHEN Accident_Severity = 'Severe' THEN 1 ELSE 0 END) AS DECIMAL(10,2)) 
           / COUNT(*) AS Severe_Accident_Rate
FROM Accident_Table
GROUP BY Country
ORDER BY Severe_Accident_Rate DESC, 
         Total_Accident DESC;


-- 3. How does the average severity score change under different visibility conditions?

SELECT 
      Visibility_Category,
      AVG(
          CASE 
              WHEN Accident_Severity = 'Minor' THEN 1
              WHEN Accident_Severity = 'Moderate' THEN 2
              WHEN Accident_Severity = 'Severe' THEN 3
          END ) AS Avg_Severity_Score
FROM Accident_Table
GROUP BY Visibility_Category
ORDER BY Avg_Severity_Score DESC 


    








