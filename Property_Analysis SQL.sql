create database property;
use property;

create table property_analysis(
  datesold varchar(50),
  postcode int,
  price int,
  propertytype varchar(10),
  bedrooms int
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Property_analysis.csv'
INTO TABLE property_analysis
CHARACTER SET LATIN1
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;

select * from property_analysis;

/*1. Display first 10 sale date*/
SELECT datesold 
FROM property_analysis 
LIMIT 10;

/*2. Show distinct property types (house/unit)*/
SELECT DISTINCT propertyType
FROM property_analysis;

/*3. Show distinct bedroom counts available*/
SELECT DISTINCT bedrooms
FROM property_analysis
ORDER BY bedrooms;

SELECT COUNT(*)
FROM property_analysis
WHERE bedrooms = 2;

/*4. Calculate average price of 3-bedroom properties*/
SELECT AVG(price)
FROM property_analysis
WHERE bedrooms = 3;

/*5. Show houses with 3 bedrooms and price >500000*/
SELECT * FROM property_analysis
WHERE propertyType = 'house' and price > 500000
AND bedrooms = 3;

/*6. Show year wise data*/
SELECT *
FROM property_analysis
WHERE YEAR(datesold) = 2015;

SELECT COUNT(*)
FROM property_analysis
WHERE YEAR(datesold) = 2018;

SELECT *
FROM property_analysis
WHERE YEAR(datesold) > 2016;

/*7. Show top 10 most expensive house*/
SELECT *FROM property_analysis
WHERE propertyType = 'house'
ORDER BY price DESC
LIMIT 10;

/*8. Show cheapest unit property*/
SELECT * FROM property_analysis
WHERE propertyType = 'unit'
ORDER BY price ASC
LIMIT 1;

/*9. Show minimum and maximum property price*/
SELECT 
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM property_analysis;

/*10. Show minimum and maximum price for each property type (house and unit)*/
SELECT 
    propertyType,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM property_analysis
GROUP BY propertyType;

/*11. Count number of sales by property type*/
SELECT propertyType, COUNT(*) AS total_count
FROM property_analysis
GROUP BY propertyType;

SELECT * FROM property_analysis
WHERE (datesold)
BETWEEN '2015-01-01' AND '2017-12-31';

/*12. Count total sales year-wise*/
SELECT 
    YEAR(datesold) AS sale_year,
    COUNT(*) AS total_sales
FROM property_analysis
GROUP BY sale_year
ORDER BY sale_year;

/*13. Calculate average price year-wise*/
SELECT 
    YEAR(datesold) AS sale_year,
    AVG(price) AS avg_price
FROM property_analysis
GROUP BY sale_year
ORDER BY sale_year;

/*14. Find most sold bedroom type*/
SELECT 
    bedrooms,
    COUNT(*) AS total_sales
FROM property_analysis
GROUP BY bedrooms
ORDER BY total_sales DESC
LIMIT 1;

/*15. Find highest property price year-wise*/
SELECT 
    YEAR(datesold) AS sale_year,
    MAX(price) AS highest_price
FROM property_analysis
GROUP BY sale_year
ORDER BY sale_year;

/*16. Find highest price per year for each property type*/
SELECT 
    YEAR(datesold) AS sale_year,
    propertyType,
    MAX(price) AS highest_price
FROM property_analysis
GROUP BY sale_year, propertyType
ORDER BY sale_year, propertyType;

/*17. Find average price for each property type.*/
SELECT
    propertytype, AVG(price) as average_price
    FROM property_analysis
    GROUP BY propertytype;
    
/*18. Find top 3 most expensive properties in each postcode.*/
SELECT * from
   (SELECT
    propertytype, datesold, postcode, price, bedrooms,
    row_number() over (partition by postcode order by price desc) as top_3
    from property_analysis) as ranked
    where top_3 <=3;
    
/*19. Rank properties by price (highest first)*/
SELECT 
    price,
    propertyType,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS price_rank
FROM property_analysis;

/*20. Get top 3 highest priced houses*/
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY propertyType ORDER BY price DESC) AS rn
    FROM property_analysis
) t
WHERE propertyType = 'house'
AND rn <= 3;

/*21. Rank price separately for house and unit*/
SELECT 
    propertyType,
    price,
    ROW_NUMBER() OVER (
        PARTITION BY propertyType 
        ORDER BY price DESC
    ) AS rank_in_type
FROM property_analysis;

/*22. Categorize properties based on price*/
SELECT 
    price,
    CASE 
        WHEN price < 400000 THEN 'Low Price'
        WHEN price BETWEEN 400000 AND 700000 THEN 'Medium Price'
        ELSE 'High Price'
    END AS price_category
FROM property_analysis;

/*23. Categorize bedroom size*/
SELECT 
    bedrooms,
    CASE
        WHEN bedrooms <= 2 THEN 'Small'
        WHEN bedrooms = 3 THEN 'Medium'
        ELSE 'Large'
    END AS bedroom_category
FROM property_analysis;

/*24. Classify sales year into two groups*/
SELECT 
    datesold,
    CASE 
        WHEN YEAR(datesold) <= 2015 
        THEN 'Before 2015'
        ELSE 'After 2015'
    END AS year_category
FROM property_analysis;

/*25. Compare price with overall average*/
SELECT 
    price,
    CASE 
        WHEN price > (SELECT AVG(price) FROM property_analysis)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS price_comparison
FROM property_analysis;