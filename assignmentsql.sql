#1. Create a table called employees with the following structure?
#: emp_id (integer, should not be NULL and should be a primary key)Q
#: emp_name (text, should not be NULL)Q
#: age (integer, should have a check constraint to ensure the age is at least 18)Q
#: email (text, should be unique for each employee)Q
#: salary (decimal, with a default value of 30,000).
# Write the SQL query to create the above table with all constraints.

CREATE TABLE employees (
    emp_id INT PRIMARY KEY NOT NULL,
    emp_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(255) UNIQUE,
    salary DECIMAL DEFAULT 30000
);
select * from employees;

# 2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide 
# examples of common types of constraints.

#Constraints play a crucial role in maintaining data integrity by ensuring that only valid and consistent data is stored in the database. They enforce rules at the database level, preventing accidental errors and maintaining relationships between tables. Without constraints, databases may contain duplicate, incomplete, or incorrect data, leading to unreliable results.
#Types of constraints and their importance
#1 PRIMARY KEY:It Ensures that each record in a table is uniquely identifiable. For example, emp_id in the employees table serves as a unique identifier.
#2 NOT NULL: Prevents columns from having NULL values, ensuring essential data is always present. For instance, emp_name cannot be left empty
#3 UNIQUE: Guarantees that all values in a column are distinct. The email column ensures no two employees have the same email.

# How Constraints Maintain Data Integrity
# - They prevent duplication.
# - They enforce valid relationships.
# - They ensure correctness.
# - They avoid NULL-related issues

# 3.Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer 

#Answer - NOT NULL prevents missing values, ensuring essential data is always stored.
#- A Primary Key cannot contain NULL values because it uniquely identifies each record.
#Since NULL represents an unknown or missing value, allowing NULLs in a primary key would mean that some records might not have a unique identifier, which contradicts the purpose of a primary key.

#4  Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.

#Answer - For adding the constraint-
# ALTER TABLE employees ADD CONSTRAINT chk_age CHECK (age >= 18);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY NOT NULL,
    emp_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(255) UNIQUE,
    salary DECIMAL DEFAULT 30000
);
ALTER TABLE employees ADD CONSTRAINT age CHECK (age >= 18);

# for removing the constraint
#ALTER TABLE employees DROP CONSTRAINT fk_department;

ALTER TABLE employees DROP CONSTRAINT age;

#5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. Provide an example of an error message that might occur when violating a constraint.

#When you violate database constraints, the DBMS prevents the operation and returns an error, maintaining data integrity. 
#Consequences:
#- Data Integrity Issues: Corrupts data, making it inconsistent.
#-Transaction Failure: Operation fails and is rolled back.

CREATE TABLE users (
    emp_id INT PRIMARY KEY NOT NULL,
    emp_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE
);
# here i am inserting the values.
INSERT INTO users (emp_id, emp_name, email) 
VALUES (1, 'John Doe', 'johndoe@example.com');

#here i am inserting the values but the email is duplicate.
INSERT INTO users (emp_id, emp_name, email) 
VALUES (2, 'Jane Smith', 'johndoe@example.com');

# ERROR: duplicate key value violates unique constraint "users_email_key"
# DETAIL: Key (email)=(johndoe@example.com) already exists.

# 6.You created a products table without constraints as follows:
 # CREATE TABLE products (
 #product_id INT,
 #product_name VARCHAR(50),
 #price DECIMAL(10, 2));  
  # Now, you realise that
 #The product_id should be a primary key
 #The price should have a default value of 50.00
 
 CREATE TABLE products (
 product_id INT,
 product_name VARCHAR(50),
 price DECIMAL(10, 2));
 
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE products ALTER COLUMN price SET DEFAULT 50.00;

#7.  You have two tables:
#Write a query to fetch the student_name and class_name for each student using an INNER JOIN.

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    class_id INT
);

CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(100)
);
INSERT INTO students (student_id, student_name, class_id) 
VALUES 
  ("1", 'Alice', "101"),
  ("2", 'Bob', "102"),
  ("3", 'Charlie', "101");
  
  INSERT INTO classes (class_id, class_name) 
VALUES 
  ("101", 'Math'),
  ("102", 'Science'),
  ("103", 'History');
SELECT students.student_name, classes.class_name 
FROM students 
INNER JOIN classes ON students.class_id = classes.class_id;

#8 Consider the following three tables:
#Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are listed even if they are not associated with an order 

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    order_id INT DEFAULT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_id, customer_name) VALUES 
    (101, 'ALICE'),
    (102, 'BOB');

INSERT INTO products (product_id, product_name, order_id) VALUES 
    (1, 'Laptop', 1),
    (2, 'Phone', NULL);


INSERT INTO orders (order_id, customer_id, product_id) VALUES 
    (1, 101, 1),   
    (2, 102, 2);   
    
SELECT orders.order_id, customers.customer_name, products.product_name 
FROM orders 
INNER JOIN customers ON orders.customer_id = customers.customer_id
LEFT JOIN products ON orders.product_id = products.product_id;

ALTER TABLE products
ALTER COLUMN order_id SET DEFAULT NULL;

#9 Given the following tables:
# Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name) VALUES 
    (101, 'Laptop'),
    (102, 'Phone');
    
INSERT INTO sales (sale_id, product_id, amount) VALUES 
    (1, 101, 500),
    (2, 102, 300),
    (3, 101, 700);
    

SELECT products.product_name, SUM(sales.amount) AS total_sales 
FROM sales 
INNER JOIN products ON sales.product_id = products.product_id 
GROUP BY products.product_name;

#10 You are given three tables:
# Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer using an INNER JOIN between all three tables.

CREATE TABLE order_details (
    order_id INT PRIMARY KEY,
    customer_id INT,
    quantity INT
);
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT
);
INSERT INTO customers (customer_id, customer_name) VALUES 
    (1, 'ALICE'),
    (2, 'BOB');

INSERT INTO order_details (order_id, customer_id, quantity) VALUES 
    (1, 101, 5),
    (3, 102, 3),
    (2,101,213);

INSERT INTO orders (order_id, customer_id, product_id) VALUES 
    (1, 2024-01-02, 1),   
    (2, 2024-01-05, 2);  
    
SELECT order_details.order_id, customers.customer_name, order_details.quantity 
FROM order_details 
INNER JOIN customers ON order_details.customer_id = customers.customer_id;

# SQL Commands

CREATE DATABASE Mavenmovies;

USE Mavenmovies;

#1 Identify the primary keys and foreign keys in maven movies db. Discuss the differences?

SELECT 
    TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, 
    REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'mavenmovies';

# 1. Purpose  
  # - Primary Key (PK): Uniquely identifies each row in a table.  
   #- Foreign Key (FK): Establishes a relationship between two tables by referencing a primary key in another table.  

# 2. Uniqueness  
  # - PK: Must be unique for every row in the table.  
  # - FK: Can have duplicate values in the referencing table.  

# 3. Null Values  
  # - PK: Cannot contain NULL values.  
   #- FK: Can contain NULL values (unless defined with NOT NULL).  

#4. Number of Keys Per Table  
   #- PK: Each table can have only one primary key.  
 #  - FK: A table can have multiple foreign keys referencing different tables.  

#5. Automatic Indexing  
 #  - PK: Automatically creates a unique index.  
 #  - FK: Does not automatically create an index (but indexing is recommended for performance).  

#6. Referencing  
  # - PK: Does not reference any other key.  
  # - FK: References a primary key from another table.  

#7. Modification Impact  
  # - PK: Changing a primary key value affects all related foreign keys.  
  # - FK: Deleting or updating a referenced primary key may cause errors unless CASCADE or SET NULL is used. 
  
  #2 List all details of actors?
  
  SELECT * FROM actor;
  
  #3 List all customer information from DB.
  
  SELECT * FROM customer;
  
  #4 List different countries.
  
  SELECT * FROM country;
  SELECT DISTINCT country FROM country;
  
  #5 Display all active customers.
  
  SELECT * FROM customer;
  SELECT * FROM customer WHERE active = 1;
  
  #6 List of all rental IDs for customer with ID 1.
  
  SELECT rental_id FROM rental WHERE customer_id = 1;
  
  #7 Display all the films whose rental duration is greater than 5 .
  
  SELECT film_id, title, rental_duration FROM film WHERE rental_duration > 5;

#8 List the total number of films whose replacement cost is greater than $15 and less than $20

SELECT COUNT(*) AS total_films
FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

#9  Display the count of unique first names of actors.

SELECT COUNT(DISTINCT first_name) AS unique_first_names FROM actor;

#10 Display the first 10 records from the customer table.

SELECT * FROM customer LIMIT 10;

#11  Display the first 3 records from the customer table whose first name starts with ‘b’.

SELECT * FROM customer 
WHERE first_name LIKE 'B%' 
LIMIT 3;

#12 Display the names of the first 5 movies which are rated as ‘G’.

SELECT title FROM film 
WHERE rating = 'G' 
LIMIT 5;

#13 Find all customers whose first name starts with "a".

SELECT * FROM customer 
WHERE first_name LIKE 'A%';

#14 Find all customers whose first name ends with "a".

SELECT * FROM customer 
WHERE first_name LIKE 'A%';

#15 Display the list of first 4 cities which start and end with ‘a’ .

SELECT city FROM city 
WHERE city LIKE 'A%a' 
LIMIT 4;

#16 Find all customers whose first name have "NI" in any position.

SELECT * FROM customer 
WHERE first_name LIKE '%NI%';

#17 Find all customers whose first name have "r" in the second position .

SELECT * FROM customer 
WHERE first_name LIKE '_r%';

#18 Find all customers whose first name starts with "a" and are at least 5 characters in length.

SELECT * FROM customer 
WHERE first_name LIKE 'A%' 
AND LENGTH(first_name) >= 5;

#19 Find all customers whose first name starts with "a" and ends with "o".

SELECT * FROM customer 
WHERE first_name LIKE 'A%o';


#20 Get the films with pg and pg-13 rating using IN operator.

SELECT * FROM film 
WHERE rating IN ('PG', 'PG-13');

#21 Get the films with length between 50 to 100 using between operator.

SELECT * FROM film 
WHERE length BETWEEN 50 AND 100;

#22  Get the top 50 actors using limit operator.

SELECT * FROM actor 
ORDER BY first_name 
LIMIT 50;

#23 Get the distinct film ids from inventory table.

SELECT DISTINCT film_id FROM inventory;
SELECT COUNT(DISTINCT film_id) AS total_unique_films FROM inventory;

#                                                          Functions

Create database Sakila;

#1  Retrieve the total number of rentals made in the Sakila database.

USE Sakila;
SELECT COUNT(*) AS total_rentals FROM rental;

#2 Find the average rental duration (in days) of movies rented from the Sakila database.

SELECT AVG(rental_duration) AS avg_rental_duration FROM film;

#3 Display the first name and last name of customers in uppercase.

SELECT UPPER(first_name) AS first_name_upper, 
       UPPER(last_name) AS last_name_upper 
FROM customer;

#4 Extract the month from the rental date and display it alongside the rental ID.

SELECT rental_id, MONTH(rental_date) AS rental_month 
FROM rental;


#5  Retrieve the count of rentals for each customer (display customer ID and the count of rentals).

SELECT customer_id, COUNT(rental_id) AS rental_count
FROM rental
GROUP BY customer_id;

#6  Find the total revenue generated by each store

SELECT c.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.store_id;

#8  Find the average rental rate of movies in each language.

SELECT l.name AS language_name, AVG(f.rental_rate) AS average_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

#9 Questions 9 -
 #Display the title of the movie, customer s first name, and last name who rented it.
 #Hint: Use JOIN between the film, inventory, rental, and customer tables.

SELECT f.title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

#10 Question 10:
# Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
 # Hint: Use JOIN between the film actor, film, and actor tables.

SELECT a.first_name, a.last_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'Gone with the Wind';


#11 Question 11:
 #Retrieve the customer names along with the total amount they've spent on rentals.
 #Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.

SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

#12  Question 12:
 #List the titles of movies rented by each customer in a particular city (e.g., 'London').
 # Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.
 
 SELECT c.first_name, c.last_name, ci.city, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY c.first_name, c.last_name, ci.city, f.title;

#13 Question 13:
# Display the top 5 rented movies along with the number of times they've been rented.
# Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.

SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

#14 Question 14:
 #Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
# Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;

#                                                 Windows function

#1  Rank the customers based on the total amount they've spent on rentals.

SELECT c.customer_id, c.first_name, c.last_name, 
       SUM(p.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

#2 Calculate the cumulative revenue generated by each film over time.

SELECT f.title, p.payment_date, 
       SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY f.title, p.payment_date;

  #3 Determine the average rental duration for each film, considering films with similar lengths
  
  SELECT f.title, f.length, 
       AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title, f.length
ORDER BY f.length;

#4  Identify the top 3 films in each category based on their rental counts.
  
  SELECT c.name AS category, f.title, COUNT(r.rental_id) AS rental_count,
       RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS rank
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name, f.title
HAVING rank <= 3
ORDER BY c.name, rank;

#5  Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.
 
 SELECT c.customer_id, c.first_name, c.last_name, 
       COUNT(r.rental_id) AS total_rentals,
       (COUNT(r.rental_id) - (SELECT AVG(customer_rentals) 
                              FROM (SELECT COUNT(r.rental_id) AS customer_rentals 
                                    FROM rental r 
                                    GROUP BY r.customer_id) AS avg_rentals)) AS rental_difference
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

#6 Find the monthly revenue trend for the entire rental store over time.

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, 
       SUM(amount) AS total_revenue
FROM payment
GROUP BY month
ORDER BY month;

#7 Identify the customers whose total spending on rentals falls within the top 20% of all customers.

WITH customer_spending AS (
    SELECT c.customer_id, c.first_name, c.last_name, 
           SUM(p.amount) AS total_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
spending_threshold AS (
    SELECT PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY total_spent) AS threshold
    FROM customer_spending
)
SELECT cs.customer_id, cs.first_name, cs.last_name, cs.total_spent
FROM customer_spending cs
JOIN spending_threshold st ON cs.total_spent >= st.threshold
ORDER BY cs.total_spent DESC;

#8 Calculate the running total of rentals per category, ordered by rental count.

WITH category_rentals AS (
    SELECT c.name AS category, COUNT(r.rental_id) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name
),
running_total AS (
    SELECT category, rental_count,
           SUM(rental_count) OVER (ORDER BY rental_count DESC) AS running_total
    FROM category_rentals
)
SELECT * FROM running_total;

#9 Find the films that have been rented less than the average rental count for their respective categories.

WITH film_rental_counts AS (
    SELECT f.film_id, f.title, c.name AS category, COUNT(r.rental_id) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY f.film_id, f.title, c.name
),
category_avg_rentals AS (
    SELECT category, AVG(rental_count) AS avg_rentals
    FROM film_rental_counts
    GROUP BY category
)
SELECT f.title, f.category, f.rental_count, c.avg_rentals
FROM film_rental_counts f
JOIN category_avg_rentals c ON f.category = c.category
WHERE f.rental_count < c.avg_rentals
ORDER BY f.category, f.rental_count;

#10  Identify the top 5 months with the highest revenue and display the revenue generated in each month.

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, 
       SUM(amount) AS total_revenue
FROM payment
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 5;

#                                                          Normalization and CTE

#1 First Normal Form (1NF):
             #  a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.
             
#A table violates 1NF if:             
#- It contains duplicate columns for the same attribute.
#- It has repeating groups (multiple values in a single field).
#- It lacks a primary key to uniquely identify records.

#A table that violates 1NF in the Sakila database is the film table.

#To Normalize to 1NF?
#To achieve 1NF, we need to remove multi-valued attributes and create a separate table for film categories.

CREATE TABLE film_category (
    film_id INT,
    category VARCHAR(50),
    PRIMARY KEY (film_id, category),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

INSERT INTO film_category (film_id, category) VALUES (1, 'Action');
INSERT INTO film_category (film_id, category) VALUES (1, 'Comedy');
INSERT INTO film_category (film_id, category) VALUES (2, 'Drama');
INSERT INTO film_category (film_id, category) VALUES (3, 'Action');
INSERT INTO film_category (film_id, category) VALUES (3, 'Horror');
    

#2 Second Normal Form (2NF):
             #  a. Choose a table in Sakila and describe how you would determine whether it is in 2NF.If it violates 2NF, explain the steps to normalize it   


#A table is in Second Normal Form (2NF) if:

#- It follows 1NF (no multi-valued attributes or repeating groups).
#- No partial dependency exists, meaning:
#- Every non-key attribute should be fully dependent on the entire primary key (not just part of it). 

# The rental table is a good example to check for 2NF violations.          

#Checking for 2NF Violation

#- Primary Key: rental_id (unique for each rental).
#- Non-Key Attributes: customer_name, store_address.
#- Issue: customer_name and store_address depend only on customer_id and store_id, not on rental_id.
#            This is a partial dependency that Violates 2NF

 #Normalizing to 2NF
# To fix this, we separate customer_name and store_address into new tables.

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

INSERT INTO customer (customer_id, customer_name) VALUES (101, 'John Doe');
INSERT INTO customer (customer_id, customer_name) VALUES (102, 'Alice Smith');

CREATE TABLE store (
    store_id INT PRIMARY KEY,
    store_address VARCHAR(255)
);
INSERT INTO store (store_id, store_address) VALUES (1, '123 Main St, NY');
INSERT INTO store (store_id, store_address) VALUES (2, '456 Park Ave, LA');

#  3. Third Normal Form (3NF):
              # a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies present and outline the steps to normalize the table to 3NF.
               
# A table is in Third Normal Form (3NF) if:

#It follows 2NF (no partial dependencies).
#It has no transitive dependencies, meaning:
#- A non-key attribute should not depend on another non-key attribute.
#- Every non-key column should depend only on the primary key.

#The customer table is a good example to check for 3NF violations.

# Primary Key: customer_id
# Non-Key Attributes: address_id, city, country
# Issue:
#-city depends on address_id.
#-country depends on city.
#-country is transitively dependent on customer_id through city.
#-This violates 3NF because customer_id should be the only determinant for all columns.

# To fix this, we separate city and country into new tables.

CREATE TABLE address (
    address_id INT PRIMARY KEY,
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

INSERT INTO address (address_id, city_id) VALUES (201, 1);
INSERT INTO address (address_id, city_id) VALUES (202, 2);
INSERT INTO address (address_id, city_id) VALUES (203, 3);

CREATE TABLE city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);
INSERT INTO city (city_id, city_name, country_id) VALUES (1, 'New York', 1);
INSERT INTO city (city_id, city_name, country_id) VALUES (2, 'Los Angeles', 1);
INSERT INTO city (city_id, city_name, country_id) VALUES (3, 'Toronto', 2);

CREATE TABLE country (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100)
);
INSERT INTO country (country_id, country_name) VALUES (1, 'USA');
INSERT INTO country (country_id, country_name) VALUES (2, 'Canada');


#4  4. Normalization Process:
              # a. Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF.  
           
# Unnormalized Form (UNF)
# A table is in UNF (Unnormalized Form) if:

# It contains duplicate or redundant data.
# It includes multi-valued attributes (repeating groups).    

# rental table is the best example of un normalized form

#Problem:

#The column movie_titles contains multiple values (comma-separated).
#This violates 1NF, as each field should contain atomic (single) values.   

#Convert to First Normal Form (1NF)
CREATE TABLE rental_1NF (
    rental_id INT,
    customer_name VARCHAR(100),
    rental_date DATE,
    movie_title VARCHAR(255),
    store_address VARCHAR(255)
);
# Convert to Second Normal Form (2NF)

CREATE TABLE rental (
    rental_id INT PRIMARY KEY,
    customer_id INT,
    rental_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE rental_movie (
    rental_id INT,
    movie_id INT,
    PRIMARY KEY (rental_id, movie_id),
    FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
    FOREIGN KEY (movie_id) REFERENCES film(film_id)
);
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    store_address VARCHAR(255)
);

# 5. CTE Basics:
               # a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables.
                
#A Common Table Expression (CTE) is a temporary result set that makes complex queries more readable.

#In this query, we use a CTE to:

#Join actor and film_actor tables.
#Count the number of films each actor has acted in.
#Retrieve the distinct actor names along with their film count.      

WITH ActorFilmCount AS (
    SELECT 
        a.actor_id,
        a.first_name || ' ' || a.last_name AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, actor_name
)
SELECT * FROM ActorFilmCount;

#6 CTE with Joins:
                #a. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.
                
   #Why Use a CTE?
# A Common Table Expression (CTE) helps simplify queries by storing intermediate results that can be used in the final SELECT statement.   
WITH FilmLanguage AS (
    SELECT 
        f.film_id,
        f.title AS film_title,
        l.name AS language_name,
        f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM FilmLanguage;

#7  CTE for Aggregation:
            #   a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables. 
           
      WITH CustomerRevenue AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(p.amount) AS total_revenue
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, customer_name
)
SELECT * FROM CustomerRevenue;

#8 CTE with Window Functions:
             #  a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.   
             
 WITH FilmRanking AS (
    SELECT 
        film_id,
        title AS film_title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS rank_position
    FROM film
)
SELECT * FROM FilmRanking;

#9 CTE and Filtering:
           #    a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details.
                        
 # WITH FrequentRenters AS (
    SELECT 
        r.customer_id,
        COUNT(r.rental_id) AS total_rentals
    FROM rental r
    GROUP BY r.customer_id
    HAVING COUNT(r.rental_id) > 2
    )
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    f.total_rentals
FROM FrequentRenters f
JOIN customer c ON f.customer_id = c.customer_id;

#10 CTE for Date Calculations:
 # a. Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table

 WITH MonthlyRentals AS (
    SELECT 
        DATE_TRUNC('month', rental_date) AS rental_month,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY rental_month
    ORDER BY rental_month
)
SELECT * FROM MonthlyRentals;

#11 CTE and Self-Join:
 # a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table.
 
 WITH ActorPairs AS (
    SELECT 
        fa1.film_id,
        fa1.actor_id AS actor1_id,
        a1.first_name || ' ' || a1.last_name AS actor1_name,
        fa2.actor_id AS actor2_id,
        a2.first_name || ' ' || a2.last_name AS actor2_name
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id 
        AND fa1.actor_id < fa2.actor_id  -- Ensures each pair is unique
    JOIN actor a1 ON fa1.actor_id = a1.actor_id
    JOIN actor a2 ON fa2.actor_id = a2.actor_id
)
SELECT 
    ap.film_id, 
    f.title AS film_title, 
    ap.actor1_name, 
    ap.actor2_name
FROM ActorPairs ap
JOIN film f ON ap.film_id = f.film_id
ORDER BY film_title;

#12 CTE for Recursive Search:
 # a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column

      WITH RECURSIVE EmployeeHierarchy AS (
    -- Base Case: Start with the manager (e.g., Manager ID = 1)
    SELECT 
        staff_id, 
        first_name || ' ' || last_name AS employee_name,
        reports_to,
        1 AS hierarchy_level
    FROM staff
    WHERE staff_id = 1  -- Change this to the specific manager's ID

    UNION ALL

    -- Recursive Case: Find employees who report to employees found in the previous step
    SELECT 
        s.staff_id, 
        s.first_name || ' ' || s.last_name AS employee_name,
        s.reports_to,
        eh.hierarchy_level + 1
    FROM staff s
    JOIN EmployeeHierarchy eh ON s.reports_to = eh.staff_id
)
SELECT * FROM EmployeeHierarchy
ORDER BY hierarchy_level, employee_name;
                