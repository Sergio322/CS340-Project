-- =============================================
-- CS340 Cable Internet Provider Database DDL
-- This file creates the following tables:
--   - Customers
--   - Services
--   - BillingRecords
--   - Subscriptions
--   - Payments

-- Disable foreign key checks and autocommit to avoid errors during import
SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Subscriptions;
DROP TABLE IF EXISTS BillingRecords;
DROP TABLE IF EXISTS Services;
DROP TABLE IF EXISTS Customers;


CREATE TABLE Customers (
  customerID INT AUTO_INCREMENT PRIMARY KEY,
  accountNumber VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(15) NOT NULL,
  address VARCHAR(255) NOT NULL,
  joinDate DATE NOT NULL
);

CREATE TABLE Services (
  serviceID INT AUTO_INCREMENT PRIMARY KEY,
  serviceName VARCHAR(255) NOT NULL,
  monthlyCost DECIMAL(10,2) NOT NULL,
  description VARCHAR(255)
);


CREATE TABLE BillingRecords (
  billingID INT AUTO_INCREMENT PRIMARY KEY,
  customerID INT NOT NULL,
  billingDate DATE NOT NULL,
  totalAmount DECIMAL(10,2) NOT NULL,
  paymentStatus ENUM('Paid', 'Unpaid') NOT NULL,
  CONSTRAINT fk_billing_customers 
	FOREIGN KEY (customerID) REFERENCES Customers(customerID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ====================================================
-- Table: Subscriptions
-- Purpose: Represents the many-to-many relationship between Customers and Services.
-- ====================================================
CREATE TABLE Subscriptions (
  subscriptionID INT AUTO_INCREMENT PRIMARY KEY,
  customerID INT NOT NULL,
  serviceID INT NOT NULL,
  startDate DATE NOT NULL,
  endDate DATE,
  CONSTRAINT fk_subscriptions_customers FOREIGN KEY (customerID) REFERENCES Customers(customerID),
  CONSTRAINT fk_subscriptions_services FOREIGN KEY (serviceID) REFERENCES Services(serviceID)
);

CREATE TABLE Payments (
  paymentID INT AUTO_INCREMENT PRIMARY KEY,
  billingID INT DEFAULT NULL,
  paymentDate DATE NOT NULL,
  amountPaid DECIMAL(10,2) NOT NULL,
  paymentMethod ENUM('Credit Card', 'Debit Card', 'Bank Transfer', 'Cash', 'Check') NOT NULL,
  confirmationNumber VARCHAR(50) NOT NULL UNIQUE,
  CONSTRAINT fk_payments_billing FOREIGN KEY (billingID) REFERENCES BillingRecords(billingID)
);


-- Insert sample data into Customers table
INSERT INTO Customers (accountNumber, name, email, phone, address, joinDate)
VALUES
('ACCT001', 'Alice Johnson', 'alice.j@example.com', '555-1234', '123 Elm St', '2020-01-15'),
('ACCT002', 'Bob Smith', 'bob.smith@example.com', '555-2345', '456 Oak Ave', '2020-03-22'),
('ACCT003', 'Carol White', 'carol.white@example.com', '555-3456', '789 Pine Rd', '2020-06-10');

-- Insert sample data into Services table
INSERT INTO Services (serviceName, monthlyCost, description)
VALUES
('Internet', 39.99, 'High-speed broadband internet'),
('Cable TV', 29.99, 'Digital cable TV with over 200 channels'),
('Phone', 19.99, 'Unlimited local calling');

-- Insert sample data into BillingRecords table
INSERT INTO BillingRecords (customerID, billingDate, totalAmount, paymentStatus)
VALUES
(1, '2023-01-01', 69.98, 'Paid'),
(2, '2023-01-01', 29.99, 'Unpaid'),
(1, '2023-02-01', 39.99, 'Paid');

-- Insert sample data into Subscriptions table
INSERT INTO Subscriptions (customerID, serviceID, startDate, endDate)
VALUES
(1, 1, '2020-01-15', NULL),
(1, 2, '2020-02-01', '2022-12-31'),
(2, 2, '2020-03-22', NULL),
(3, 3, '2020-06-10', NULL);

-- Insert sample data into Payments table
INSERT INTO Payments (billingID, paymentDate, amountPaid, paymentMethod, confirmationNumber)
VALUES
(1, '2023-01-05', 69.98, 'Credit Card', 'CONF001'),
(2, '2023-01-07', 15.00, 'Cash', 'CONF002'),
(2, '2023-01-20', 14.99, 'Cash', 'CONF003'),
(NULL, '2023-02-02', 39.99, 'Bank Transfer', 'CONF004');

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;