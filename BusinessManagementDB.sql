-- BusinessManagementDB: SQL Script

-- Drop existing database if it exists
IF DB_ID('BusinessManagementDB') IS NOT NULL
BEGIN
    ALTER DATABASE BusinessManagementDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BusinessManagementDB;
END
GO

-- Create the database
CREATE DATABASE BusinessManagementDB;
GO

USE BusinessManagementDB;
GO

-- Drop tables if they exist
IF OBJECT_ID('dbo.SaleItems', 'U') IS NOT NULL DROP TABLE dbo.SaleItems;
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;
IF OBJECT_ID('dbo.CustomerAccounts', 'U') IS NOT NULL DROP TABLE dbo.CustomerAccounts;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID('dbo.Invoices', 'U') IS NOT NULL DROP TABLE dbo.Invoices;
IF OBJECT_ID('dbo.Vendors', 'U') IS NOT NULL DROP TABLE dbo.Vendors;
IF OBJECT_ID('dbo.Terms', 'U') IS NOT NULL DROP TABLE dbo.Terms;
IF OBJECT_ID('dbo.GLAccounts', 'U') IS NOT NULL DROP TABLE dbo.GLAccounts;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
GO

-- Create Tables
CREATE TABLE dbo.GLAccounts (
    AccountNo INT NOT NULL PRIMARY KEY,
    AccountDescription VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Terms (
    TermsID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TermsDescription VARCHAR(50) NOT NULL,
    TermsDueDays SMALLINT NOT NULL
);

CREATE TABLE dbo.Vendors (
    VendorID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VendorName VARCHAR(100) NOT NULL,
    VendorState CHAR(2) NOT NULL,
    VendorCity VARCHAR(50),
    VendorZipCode VARCHAR(20),
    VendorPhone VARCHAR(50),
    VendorContactLName VARCHAR(50),
    VendorContactFName VARCHAR(50),
    DefaultTermsID INT NOT NULL,
    DefaultAccountNo INT NOT NULL,
    FOREIGN KEY (DefaultTermsID) REFERENCES dbo.Terms(TermsID),
    FOREIGN KEY (DefaultAccountNo) REFERENCES dbo.GLAccounts(AccountNo)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Title VARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL
);

CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(100),
    State CHAR(2)
);

CREATE TABLE dbo.CustomerAccounts (
    AccountID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerID INT NOT NULL,
    Balance MONEY DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);

CREATE TABLE dbo.Invoices (
    InvoiceID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VendorID INT NOT NULL,
    InvoiceNumber VARCHAR(50) NOT NULL,
    InvoiceDate DATE NOT NULL,
    InvoiceTotal MONEY NOT NULL,
    PaymentTotal MONEY DEFAULT 0,
    CreditTotal MONEY DEFAULT 0,
    TermsID INT NOT NULL,
    InvoiceDueDate DATE NOT NULL,
    PaymentDate DATE NULL,
    FOREIGN KEY (VendorID) REFERENCES dbo.Vendors(VendorID),
    FOREIGN KEY (TermsID) REFERENCES dbo.Terms(TermsID)
);

CREATE TABLE dbo.Sales (
    SaleID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerID INT NOT NULL,
    VendorID INT NOT NULL,
    EmployeeID INT NOT NULL,
    SaleDate DATE NOT NULL,
    TotalAmount MONEY NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    FOREIGN KEY (VendorID) REFERENCES dbo.Vendors(VendorID),
    FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID)
);

CREATE TABLE dbo.SaleItems (
    SaleItemID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SaleID INT NOT NULL,
    Description VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    Price MONEY NOT NULL,
    FOREIGN KEY (SaleID) REFERENCES dbo.Sales(SaleID)
);
GO

-- Insert GL Accounts
INSERT INTO dbo.GLAccounts (AccountNo, AccountDescription) VALUES
(100, 'Cash'), (200, 'Accounts Payable'), (400, 'Sales Revenue'),
(500, 'Salary Expenses'), (600, 'Supplies Expenses');

-- Insert Terms
INSERT INTO dbo.Terms (TermsDescription, TermsDueDays) VALUES
('Net 30', 30), ('Net 60', 60), ('Due on Receipt', 0);

-- Insert Vendors
INSERT INTO dbo.Vendors (VendorName, VendorState, VendorCity, VendorZipCode, VendorPhone, VendorContactLName, VendorContactFName, DefaultTermsID, DefaultAccountNo) VALUES
('TechPro Inc.', 'TX', 'Austin', '73301', '512-555-0100', 'Smith', 'John', 1, 400),
('SupplyHub', 'CA', 'Los Angeles', '90001', '323-555-0190', 'Davis', 'Anna', 2, 600),
('AdWorks', 'NY', 'New York', '10001', '212-555-0123', 'White', 'Chris', 3, 400),
('Printify', 'TX', 'Dallas', '75001', '214-555-0456', 'King', 'Angela', 1, 600),
('MediaBoost', 'FL', 'Miami', '33101', '305-555-0345', 'Lopez', 'Juan', 2, 400),
('Logistics LLC', 'NV', 'Las Vegas', '89101', '702-555-0678', 'Clark', 'Debbie', 1, 600),
('DesignR', 'WA', 'Seattle', '98101', '206-555-0789', 'Nguyen', 'Kim', 3, 400),
('ConsultPro', 'MT', 'Bozeman', '59715', '406-555-0111', 'Hall', 'Mike', 2, 400);

-- Insert Customers
INSERT INTO dbo.Customers (FirstName, LastName, Phone, Email, Address, State) VALUES
('Alice', 'Morgan', '512-555-1111', 'alice@email.com', '123 Main St', 'TX'),
('Bob', 'Smith', '213-555-2222', 'bob@email.com', '456 Elm St', 'CA'),
('Cathy', 'Brown', '305-555-3333', 'cathy@email.com', '789 Oak St', 'FL'),
('David', 'Lee', '702-555-4444', 'david@email.com', '135 Pine St', 'NV'),
('Ella', 'Jones', '206-555-5555', 'ella@email.com', '246 Maple St', 'WA'),
('Frank', 'Kim', '406-555-6666', 'frank@email.com', '357 Cedar St', 'MT'),
('Grace', 'Zhou', '737-555-7777', 'grace@email.com', '468 Birch St', 'TX'),
('Henry', 'Moore', '323-555-8888', 'henry@email.com', '579 Walnut St', 'CA'),
('Irene', 'Chan', '212-555-9999', 'irene@email.com', '680 Cherry St', 'NY'),
('Jake', 'Stone', '214-555-0000', 'jake@email.com', '791 Spruce St', 'TX');

-- Insert Employees
INSERT INTO dbo.Employees (FirstName, LastName, Title, HireDate) VALUES
('Alice', 'Johnson', 'Sales Manager', '2021-05-12'),
('Bob', 'Smith', 'Customer Service Rep', '2020-03-15'),
('Carol', 'Lee', 'Marketing Analyst', '2022-08-20'),
('Daniel', 'Miller', 'Account Executive', '2023-01-10'),
('Eva', 'Martinez', 'Support Specialist', '2023-11-01');

-- Insert Customer Accounts
INSERT INTO dbo.CustomerAccounts (CustomerID, Balance) VALUES
(1, 150.00), (2, 300.00), (3, 0.00), (4, 75.00), (5, 125.00),
(6, 200.00), (7, 0.00), (8, 50.00), (9, 25.00), (10, 90.00);

-- Insert Invoices 
INSERT INTO dbo.Invoices (VendorID, InvoiceNumber, InvoiceDate, InvoiceTotal, PaymentTotal, CreditTotal, TermsID, InvoiceDueDate, PaymentDate) VALUES
(1, 'INV-1001', '2025-04-01', 1500.00, 1500.00, 0.00, 1, '2025-05-01', '2025-04-28'),
(2, 'INV-1002', '2025-04-02', 800.00, 400.00, 0.00, 2, '2025-06-01', NULL),
(3, 'INV-1003', '2025-04-05', 950.00, 950.00, 0.00, 1, '2025-05-05', '2025-04-30'),
(4, 'INV-1004', '2025-04-07', 400.00, 400.00, 0.00, 3, '2025-04-30', '2025-04-29');

-- Insert Sales and SaleItems 
INSERT INTO dbo.Sales (CustomerID, VendorID, EmployeeID, SaleDate, TotalAmount) VALUES
(1, 1, 1, '2025-01-15', 500.00), (2, 2, 2, '2025-02-01', 750.00),
(3, 3, 1, '2025-02-18', 300.00), (4, 4, 2, '2025-03-10', 1000.00),
(5, 5, 3, '2025-03-22', 120.00), (6, 6, 1, '2025-03-29', 80.00),
(7, 7, 2, '2025-04-02', 450.00), (8, 8, 3, '2025-04-09', 900.00),
(9, 1, 4, '2025-04-12', 100.00), (10, 2, 5, '2025-04-15', 700.00),
(1, 3, 1, '2025-04-17', 300.00), (2, 4, 2, '2025-04-20', 600.00),
(3, 5, 3, '2025-04-22', 200.00), (4, 6, 1, '2025-04-23', 75.00),
(5, 7, 2, '2025-04-24', 820.00);

INSERT INTO dbo.SaleItems (SaleID, Description, Quantity, Price) VALUES
(1, 'Product Design', 1, 500.00), (2, 'Marketing Consultation', 1, 750.00),
(3, 'Flyer Printing', 3, 100.00), (4, 'Banner Ads', 2, 500.00),
(5, 'Business Cards', 4, 30.00), (6, 'Posters', 10, 8.00),
(7, 'Social Media Ads', 3, 150.00), (8, 'SEO Services', 1, 900.00),
(9, 'Web Audit', 2, 50.00), (10, 'Press Release', 2, 350.00),
(11, 'Email Campaign', 3, 100.00), (12, 'Google Ads', 4, 150.00),
(13, 'Facebook Ads', 2, 100.00), (14, 'Radio Spot', 3, 25.00),
(15, 'TV Commercial', 1, 820.00);

--finshed
GO
