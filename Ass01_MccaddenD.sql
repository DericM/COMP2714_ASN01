
SET ECHO ON

SPOOL C:\Users\Deric\workspace\COMP2714_LAB01\Lab01_MccaddenD.txt
--
-- ---------------------------------------------------------
--
--  COMP 2714 
--  SET 2D
--  Assignment Asn01
--  Mccadden, Deric    A00751277
--  email: dmccadden@my.bcit.ca
--
-- ---------------------------------------------------------
--  START C:\Users\Deric\workspace\COMP2714_LAB01\Lab01_MccaddenD.sql
-- ---------------------------------------------------------
--
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';
--
SELECT SYSDATE
FROM DUAL;
--
--Q1--------------------------------------------------------
--
DROP TABLE Booking;
DROP TABLE Guest;
DROP TABLE Room;
DROP TABLE Hotel;
DROP TABLE OldBoooking;
--
--Q2--------------------------------------------------------
--
CREATE TABLE Hotel
(hotelNo           CHAR(8)       NOT NULL
,hotelName         VARCHAR2(20)  NOT NULL
,city              VARCHAR2(30)  NOT NULL
,CONSTRAINT PKHotel     PRIMARY KEY (hotelNo)
,CONSTRAINT CHKHotelNo  CHECK (hotelNo >= 1 OR hotelNo <= 100)
);
--
CREATE TABLE Room
(roomNo            CHAR(8)       NOT NULL    
,hotelNo           CHAR(8)       NOT NULL
,type              VARCHAR(20)   NOT NULL    
,price             DECIMAL(12,2) NOT NULL   
,CONSTRAINT PKRoom     PRIMARY KEY (roomNo)
,CONSTRAINT FKHotelNo  FOREIGN KEY (hotelNo)  REFERENCES Hotel (hotelNo)
,CONSTRAINT CHKType    CHECK (type = 'Single' OR type = 'Double' OR type = 'Family')
,CONSTRAINT CHKPrice   CHECK (price >= 10 OR price <= 100)
,CONSTRAINT CHKRoomNo  CHECK (roomNo >= 1 OR roomNo <= 100)
);
--
--Q3--------------------------------------------------------
--
CREATE TABLE Guest
(guestNo           CHAR(8)       NOT NULL
,guestName         VARCHAR2(50)  NOT NULL
,guestAddress      VARCHAR2(70)  NOT NULL
,CONSTRAINT PKGuest    PRIMARY KEY (guestNo)
);
--
CREATE TABLE Booking
(hotelNo           CHAR(8)       NOT NULL
,guestNo           CHAR(8)       NOT NULL
,roomNo            CHAR(8)       NOT NULL
,dateFrom          DATE          NOT NULL
,dateTo            DATE          NOT NULL
,CONSTRAINT PKDateFrom PRIMARY KEY (dateFrom)
,CONSTRAINT FKHotelNo  FOREIGN KEY (hotelNo) REFERENCES Hotel (hotelNo)
,CONSTRAINT FKGuestNo  FOREIGN KEY (guestNo) REFERENCES Room (guestNo)
,CONSTRAINT FKRoomNo   FOREIGN KEY (roomNo)  REFERENCES Hotel (roomNo)
);
--
--Q4--------------------------------------------------------
--
INSERT INTO Hotel (hotelName, city)     VALUES
('Casino','Vancouver')
,('Dive','Hope')
,('Motel','Kelowna');

INSERT INTO Room (hotelNo, type, price) VALUES 
 ((SELECT hotelNo from Hotel WHERE hotelName='Casino'), 'Family', 100)
,((SELECT hotelNo from Hotel WHERE hotelName='Dive'), 'Single', 30)
,((SELECT hotelNo from Hotel WHERE hotelName='Motel'), 'Double', 60);

INSERT INTO Guest (guestName, guestAddress) VALUES
('Jimmy','336 Hill St.')
,('Fred','213 Lake Ave.')
,('Bill','336 Forest Road');
 
INSERT INTO Booking (hotelNo, guestNo, roomNo) VALUES
 ((SELECT hotelNo from Hotel WHERE hotelName='Casino')
 ,(SELECT guestNo from Guest WHERE guestName='Jimmy')
 ,(SELECT roomNo from Room WHERE hotelNo='Jimmy'))

,((SELECT hotelNo from Hotel WHERE hotelName='Casino')
 ,(SELECT guestNo from Guest WHERE guestName='Jimmy')
 ,(SELECT guestNo from Guest WHERE guestName='Jimmy'))
 
--
--Q5--------------------------------------------------------
--
ALTER TABLE Room DROP CONSTRAINT CHKType;
ALTER TABLE Room ADD  CONSTRAINT CHKType    CHECK (type = 'Single' OR type = 'Double' OR type = 'Family')
--
--Q6--------------------------------------------------------
--

--
--Q7--------------------------------------------------------
--







-- Drop tables first before creating
DROP TABLE OrdProd;
DROP TABLE OrderTbl;
DROP TABLE Product;
DROP TABLE Customer;
--
-- Q1. Create Customer Table  - Note sample coding style
CREATE TABLE Customer
(CustNo           CHAR(8)       NOT NULL
,CustFirstName    VARCHAR2(20)  NOT NULL
,CustLastName     VARCHAR2(30)  NOT NULL
,CustStreet       VARCHAR2(50)  NOT NULL
,CustCity         VARCHAR2(30)  NOT NULL
,CustState        CHAR(2)       NOT NULL
,CustZip          CHAR(10)      NOT NULL
,CustBal          DECIMAL(12,2) DEFAULT 0 NOT NULL
,CONSTRAINT PKCustomer PRIMARY KEY (CustNo)
);
-- Q2. Create Product Table
CREATE TABLE Product
(ProdNo            CHAR(8)       NOT NULL
,ProdName          VARCHAR2(50)  NOT NULL
,ProdMfg           VARCHAR2(20)  NOT NULL
,ProdQOH           DECIMAL(10)   NOT NULL
,ProdPrice         DECIMAL(12,2) NOT NULL
,ProdNextShipDate  DATE
,CONSTRAINT PKProduct PRIMARY KEY (ProdNo)
);
-- Q3. Create Order Table
CREATE TABLE OrderTbl
(OrdNo      CHAR(8)  NOT NULL
,OrdDate    DATE     NOT NULL
,CustNo     CHAR(8)  NOT NULL
,CONSTRAINT PKOrder PRIMARY KEY (OrdNo)
,CONSTRAINT FKCustNo FOREIGN KEY (CustNo) REFERENCES Customer (CustNo)
);
-- Q4. Create Ordered Product Table
CREATE TABLE OrdProd
(OrdNo    CHAR(8)     NOT NULL
,ProdNo   CHAR(8)     NOT NULL
,Qty      DECIMAL(10) DEFAULT 1 NOT NULL
,CONSTRAINT PKOrdProd PRIMARY KEY (OrdNo, ProdNo)
,CONSTRAINT FKOrdNo FOREIGN KEY (OrdNo) REFERENCES OrderTbl (OrdNo)
  ON DELETE CASCADE 
,CONSTRAINT FKProdNo FOREIGN KEY (ProdNo) REFERENCES Product (ProdNo)
);
--
--  ... Additional sections of SQL commands / statements.
--      Note the sample coding style.
--
-- The sQL*Plus command DESCRIBE can be used to display the table info
DESCRIBE Customer;
DESCRIBE Product;
DESCRIBE OrderTbl;
DESCRIBE OrdProd;
--  
--  Q5. Insert some sample data - Note sample coding style
--
-- Insert Customer Data
INSERT INTO Customer
  VALUES('C0954327','Sheri','Gordon','336 Hill St.','Littleton','CO',
         '80129-5543',230.00);
-- Insert Product Data
INSERT INTO Product
  VALUES ('P1445671','Color Laser Printer','Intersafe',33,14.99,NULL);
-- Insert Order Data
INSERT INTO OrderTbl
  VALUES ('O1116324',DATE'2015-01-23','C0954327');
-- Insert Ordered Product Data
INSERT INTO OrdProd
  VALUES('O1116324','P1445671',5);
COMMIT;
--
-- Q6. Display inserted data
--
SELECT * 
FROM Customer;
--
SELECT *
FROM Product;
--
SELECT *
FROM OrderTbl
WHERE OrdDate = DATE'2015-01-23'
  AND CustNo = 'C0954327';
--
SELECT *
FROM OrdProd;
-- 
-- Q.7  - Note sample coding style
--
SELECT OrdNo, OrdDate, CustNo
FROM OrderTbl
WHERE OrdDate = DATE'2015-01-23'
  AND CustNo = 'C0954327';
--
-- Q.8  - Note sample coding style
--
SELECT c.CustNo, CustFirstName, CustLastName, 
       o.OrdNo, OrdDate, p.ProdNo, ProdName, ProdPrice
FROM Customer c
       JOIN OrderTbl o 
         ON c.CustNo = o.CustNo
       JOIN OrdProd op
         ON o.OrdNo = op.OrdNo
       JOIN Product p
         ON op.ProdNo = p.ProdNo
WHERE OrdDate > DATE'2015-01-01'
  AND c.CustNo = 'C0954327';
--
-- Q.9  - Note use of SQL*Plus commands SET and COLUMN
--        Compare the output differences between Q.8 and Q.9
--
SET LINESIZE 100
SET PAGESIZE 60
COLUMN CustFirstName FORMAT A10
COLUMN CustLastName  FORMAT A15
COLUMN PordName      FORMAT A15
COLUMN ProdPrice     FORMAT 9999.99
--
SELECT c.CustNo, CustFirstName, CustLastName, 
       o.OrdNo, OrdDate, p.ProdNo, ProdName, ProdPrice
FROM Customer c
       JOIN OrderTbl o 
         ON c.CustNo = o.CustNo
       JOIN OrdProd op
         ON o.OrdNo = op.OrdNo
       JOIN Product p
         ON op.ProdNo = p.ProdNo
WHERE OrdDate > DATE'2015-01-01'
  AND c.CustNo = 'C0954327';
--
--
--  ** This last SQL*Plus SPOOL command line is MOST IMPORTANT !! **
--  It is usually the last line of the script file, and its purpose 
--    is to close off the current spool output text file, so that all 
--    output from this script will be flushed to disk and saved to the 
--    SPOOL text file. 
--  Otherwise, you may end up missing output content.
--
SPOOL OFF
