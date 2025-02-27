-- Insert a new Customer
INSERT INTO Customers (accountNumber, name, email, phone, address, joinDate)
VALUES(
    :acctNumInput,
    :nameInput,
    :emailInput,
    :phoneInput,
    :addressInput,
    :joinDateInput
);

-- Update Customer Info
UPDATE Customers
SET name = :updatedName,
    email = :updatedEmail,
    phone = :updatedPhone,
    address = :updatedAddress
WHERE customerID = :custID;

-- Delete a Customer
DELETE FROM Customers
WHERE customerID = :custIDToDelete;

-- List All BillingRecords
SELECT billingID, customerID, billingDate, totalAmount, paymentStatus
FROM BillingRecords;