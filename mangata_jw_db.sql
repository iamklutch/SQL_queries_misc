CREATE SCHEMA IF NOT EXISTS mangata_jw_db;

USE mangata_jw_db;

CREATE TABLE Clients (
	ClientID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL,
    ContactNimber INT NOT NULL,
    Email VARCHAR(255) NOT NULL
);

CREATE TABLE Products (
	ProductID INT PRIMARY KEY AUTO_INCREMENT,
    BuyPrice DECIMAL(10, 2) NOT NULL,
    SellPrice DECIMAL(10,2) NOT NULL,
    AmountInStock INT NOT NULL
);

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY AUTO_INCREMENT,
    Quantity INT NOT NULL, 
    TotalPrice DECIMAL(10,2) NOT NULL,
    OrderDate DATE NOT NULL,
    ClientID INT NOT NULL,
    ProductID INT NOT NULL,
    FOREIGN KEY (ClientID) 
		REFERENCES Clients(ClientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) 
		REFERENCES Products(ProductID)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Address (
	AddressID INT PRIMARY KEY AUTO_INCREMENT,
    Street VARCHAR(255) NOT NULL,
    ZipCode VARCHAR(255),
    State VARCHAR(255) NOT NULL
);

CREATE TABLE Delivery (
	DeliveryID INT PRIMARY KEY AUTO_INCREMENT,
    DeliveryStatus VARCHAR(255) NOT NULL, 
    OrderID INT NOT NULL,
    AddressID INT NOT NULL,
    Comment VARCHAR(255),
    DeliveryDate DATE,
    FOREIGN KEY (OrderID) 
		REFERENCES Orders(OrderID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (AddressID) 
		REFERENCES Address(AddressID)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE products
	ADD COLUMN
		ProductName VARCHAR(255) NOT NULL;

INSERT INTO clients (FullName, ContactNimber, Email)
VALUES 
( 'Vanessa McCarthy', 757536378, 'vm@mangatagallo.com'), 
( 'Marcos Romero', 757536379, 'mr@mangatagallo.com'), 
( 'Hiroki Yamane', 757536376, 'hy@mangatagallo.com'), 
( 'Anna Iversen', 757536375, 'ai@mangatagallo.com'), 
( 'Diana Pinto', 757536374, 'dp@mangatagallo.com');

INSERT INTO products (ProductName, BuyPrice, SellPrice, AmountInStock)
VALUES 
('Engagement ring', 2000, 2500, 25), 
('Silver brooch', 300, 400, 100), 
('Earrings', 1000, 1250, 100), 
('Luxury watch', 500, 800, 50), 
('Golden bracelet', 800, 1200, 100);

ALTER TABLE orders
	RENAME COLUMN TotalPrice TO TotalCost;

INSERT INTO orders (OrderDate, ClientID, ProductID, Quantity, TotalCost)
VALUES 
('2022-10-15', 1, 1, 1, 2500), 
('2022-10-16', 2, 2, 2, 800), 
('2022-10-17', 3, 5, 1, 800), 
('2022-10-17', 4, 3, 3, 1050), 
('2022-10-18', 5, 4, 1, 1250);

INSERT INTO address (Street, ZipCode, State)
VALUES 
('223 Golden Hills, North Austin, TX', '78758', 'Texas'),
('119 Silver Street, Bouldin Creek, TX', '78737', 'Texas'), 
('785 Bronze Lane, East Austin, TX', '78717', 'Texas'), 
('908 Diamond Crescent, South Lamar, TX','76643 ', 'Texas'), 
('345, Golden Hills, North Austin, TX', '78759', 'Texas'), 
('812, Diamond Crescent, North Burnet, TX', '78611', 'Texas');

INSERT INTO delivery (DeliveryDate, DeliveryStatus, AddressID, Comment, OrderID)
VALUES 
('2022-10-17', 'Done', 1, 'None', 1), 
('2022-10-20', 'Done', 2, 'None', 2), 
('2022-10-22', 'Done', 3, 'None', 3), 
('2022-10-25', 'Done', 4, 'None', 4), 
('2022-10-27', 'Done', 5, 'None', 5);

CREATE OR REPLACE VIEW orders_view AS
    SELECT 
        Orders.ClientID,
        Orders.OrderID,
        FullName,
        Orders.Quantity,
        TotalCost,
        DeliveryStatus,
        DeliveryDate,
        Street
    FROM
        Clients
            JOIN
        Orders ON Orders.ClientID = Clients.ClientID
            JOIN
        Products ON Orders.ProductID = Products.ProductID
            JOIN
        Delivery ON Delivery.OrderID = Orders.OrderID
            JOIN
        Address ON Delivery.AddressID = Address.AddressID;

SELECT * FROM orders_view;
