-- SELECT * FROM sqlProject.zepto;

drop table if exists sqlproject.zepto;

 create table sqlproject.zepto (
 sku_id SERIAL PRIMARY KEY,
 ï»¿Category VARCHAR(120),
 name VARCHAR(150) NOT NULL,
 mrp NUMERIC(8,2),
 discountPercent NUMERIC(5,2),
 availableQuantity INTEGER,
 discountedSellingPrice NUMERIC(8,2),
 weightInGms INTEGER,
 outOfStock BOOLEAN,	
 quantity INTEGER
);

-- --data exploration

-- --count of rows
select count(name) from sqlproject.zepto;

-- --sample data
SELECT * FROM sqlproject.zepto
LIMIT 10;

-- null values
SELECT * FROM sqlproject.zepto
WHERE name IS NULL
OR
ï»¿Category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- different product categories
SELECT DISTINCT ï»¿Category
FROM sqlproject.zepto
ORDER BY ï»¿Category;

-- products in stock vs out of stock
SELECT outOfStock, COUNT(quantity)
FROM sqlproject.zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(quantity) AS "Number of SKUs"
FROM sqlproject.zepto
GROUP BY name
HAVING count(quantity) > 1
ORDER BY count(quantity) DESC;

-- data cleaning

-- products with price = 0
SELECT * FROM sqlproject.zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM sqlproject.zepto
WHERE mrp = 0;

-- convert paise to rupees
UPDATE sqlproject.zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM sqlproject.zepto;

-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM sqlproject.zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM sqlproject.zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT ï»¿Category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM sqlproject.zepto
GROUP BY ï»¿Category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM sqlproject.zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT ï»¿Category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM sqlproject.zepto
GROUP BY ï»¿Category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM sqlproject.zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM sqlproject.zepto;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT ï»¿Category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM sqlproject.zepto
GROUP BY ï»¿Category
ORDER BY total_weight;