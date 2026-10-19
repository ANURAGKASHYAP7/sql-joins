create database joins;
use joins;
create table customers(
customerId int auto_increment primary key,
customer_name varchar(50),
city varchar(50)

);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
);
CREATE TABLE Payments (
    PaymentID VARCHAR(10) PRIMARY KEY,
    CustomerID INT,
    PaymentDate DATE,
    Amount DECIMAL(10,2)
);
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT NULL
);
INSERT INTO Customers (CustomerID, CustomerName, City)
VALUES
(1, 'John Smith', 'New York'),
(2, 'Mary Johnson', 'Chicago'),
(3, 'Peter Adams', 'Los Angeles'),
(4, 'Nancy Miller', 'Houston'),
(5, 'Robert White', 'Miami');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount)
VALUES
(101, 1, '2024-10-01', 250),
(102, 2, '2024-10-05', 300),
(103, 1, '2024-10-07', 150),
(104, 3, '2024-10-10', 450),
(105, 6, '2024-10-12', 400);


INSERT INTO Payments (PaymentID, CustomerID, PaymentDate, Amount)
VALUES
('P001', 1, '2024-10-02', 250),
('P002', 2, '2024-10-06', 300),
('P003', 3, '2024-10-11', 450),
('P004', 4, '2024-10-15', 200);
INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID)
VALUES
(1, 'Alex Green', NULL),
(2, 'Brian Lee', 1),
(3, 'Carol Ray', 1),
(4, 'David Kim', 2),
(5, 'Eva Smith', 2);
ALTER TABLE Orders
RENAME COLUMN customer_id TO CustomerID;
DESCRIBE Customers;
ALTER TABLE Customers
RENAME COLUMN customer_id TO CustomerID;

ALTER TABLE Customers
RENAME COLUMN customer_name TO CustomerName;
SELECT * FROM Customers;

SELECT * FROM Orders;

SELECT * FROM Payments;

SELECT * FROM Employees;
#Question 1. Retrieve all customers who have placed at least one order.
# ans
select distinct c.CustomerId,c.CustomerName,c.city from Customers c
inner join Orders o 
ON c.CustomerId = o.CustomerId;

#Question 2. Retrieve all customers and their orders, including customers who have not placed any orders.
select c.CustomerID,c.CustomerName,o.OrderID,o.Amount
from Customers c left join Orders o on c.CustomerId = o.CustomerID;
# Question 3. Retrieve all orders and their corresponding customers, including orders placed by unknown
#customers
#--ANS 
select c.CustomerId,c.CustomerName,o.OrderId,o.Amount,o.OrderDate
from Customers c right join orders o on c.CustomerID = o.CustomerID;

# Question 4. Display all customers and orders, whether matched or not.
SELECT
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.Amount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID

UNION

SELECT
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.Amount
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;
#5. Find customers who have not placed any orders.
select c.customerID,c.CustomerName,c.City
from Customers c left join Orders o on c.CustomerID=o.CustomerID 
where o.orderID IS NULL;
# Question 6. Retrieve customers who made payments but did not place any orders
select c.CustomerName,o.OrderID,p.CustomerID
from orders o right join payments p on o.CustomerID = p.CustomerId
inner join Customers c on p.CustomerID = c.CustomerID
where o.orderID IS NULL;
# Question 7. Generate a list of all possible combinations between Customers and Orders.
SELECT 
    c.CustomerID AS Customer_ID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    o.Amount
FROM Customers c
CROSS JOIN Orders o;
# Question 8. Show all customers along with order and payment amounts in one table.
SELECT 
    c.CustomerID,
    c.CustomerName,
    COALESCE(o.TotalOrderAmount, 0) AS TotalOrderAmount,
    COALESCE(p.TotalPaymentAmount, 0) AS TotalPaymentAmount
FROM Customers c
LEFT JOIN (
    SELECT CustomerID, SUM(Amount) AS TotalOrderAmount
    FROM Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID
LEFT JOIN (
    SELECT CustomerID, SUM(Amount) AS TotalPaymentAmount
    FROM Payments
    GROUP BY CustomerID
) p ON c.CustomerID = p.CustomerID;
# Question 9. Retrieve all customers who have both placed orders and made payments
SELECT 
    c.CustomerID,
    c.CustomerName,
    COALESCE(o.TotalOrderAmount, 0) AS TotalOrderAmount,
    COALESCE(p.TotalPaymentAmount, 0) AS TotalPaymentAmount
FROM Customers c
LEFT JOIN (
    SELECT CustomerID, SUM(Amount) AS TotalOrderAmount
    FROM Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID
LEFT JOIN (
    SELECT CustomerID, SUM(Amount) AS TotalPaymentAmount
    FROM Payments
    GROUP BY CustomerID
) p ON c.CustomerID = p.CustomerID
WHERE o.TotalOrderAmount IS NOT NULL 
   OR p.TotalPaymentAmount IS NOT NULL;