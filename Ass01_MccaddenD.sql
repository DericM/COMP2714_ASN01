SET ECHO ON
SPOOL C:\Users\Deric\workspace\COMP2714_ASS01\Ass01_MccaddenD.txt
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
--  START C:\Users\Deric\workspace\COMP2714_ASS01\Ass01_MccaddenD.sql
-- ---------------------------------------------------------
--
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';
--
SELECT SYSDATE
FROM DUAL;
--
--Q1--------------------------------------------------------
--
DROP TABLE OldBooking;
DROP TABLE Booking;
DROP TABLE Guest;
DROP TABLE Room;
DROP TABLE Hotel;
--
--Q2--------------------------------------------------------
--
CREATE TABLE Hotel
(hotelNo           CHAR(8)       NOT NULL
,hotelName         VARCHAR2(20)  NOT NULL
,city              VARCHAR2(30)  NOT NULL
,CONSTRAINT PKHotel    
  PRIMARY KEY (hotelNo)
,CONSTRAINT CHKHotelNo 
  CHECK (hotelNo >= 1 OR hotelNo <= 100)
);

CREATE TABLE Room
(roomNo            CHAR(8)       NOT NULL    
,hotelNo           CHAR(8)       NOT NULL
,type              VARCHAR(20)   NOT NULL    
,price             DECIMAL(12,2) NOT NULL   
,CONSTRAINT PKRoom     
  PRIMARY KEY (roomNo)
,CONSTRAINT FKRoom     
  FOREIGN KEY (hotelNo)  REFERENCES Hotel (hotelNo)
,CONSTRAINT CHKRoomType   
  CHECK (type = 'Single' OR type = 'Double' OR type = 'Family')
,CONSTRAINT CHKRoomPrice
  CHECK (price >= 10 OR price <= 100)
,CONSTRAINT CHKRoomRoomNo
  CHECK (roomNo >= 1 OR roomNo <= 100)
,CONSTRAINT CHKRoomHotelNo
  CHECK (hotelNo >= 1 OR hotelNo <= 100)
);
--
--Q3--------------------------------------------------------
--
CREATE TABLE Guest
(guestNo           CHAR(8)       NOT NULL
,guestName         VARCHAR2(50)  NOT NULL
,guestAddress      VARCHAR2(70)  NOT NULL
,CONSTRAINT PKGuest    
  PRIMARY KEY (guestNo)
,CONSTRAINT CHKGuestGuestNo
  CHECK (guestNo >= 1 OR guestNo <= 100)
);

CREATE TABLE Booking
(hotelNo           CHAR(8)       NOT NULL
,guestNo           CHAR(8)       NOT NULL
,roomNo            CHAR(8)       NOT NULL
,dateFrom          DATE          NOT NULL
,dateTo            DATE          NOT NULL
,CONSTRAINT PKBooking
  PRIMARY KEY (dateFrom)
,CONSTRAINT FKBooking1 
  FOREIGN KEY (hotelNo) REFERENCES Hotel (hotelNo)
,CONSTRAINT FKBooking2 
  FOREIGN KEY (guestNo) REFERENCES Guest (guestNo)
,CONSTRAINT FKBooking3 
  FOREIGN KEY (roomNo)  REFERENCES Room (roomNo)
,CONSTRAINT CHKBookingHotelNo
  CHECK (hotelNo >= 1 OR hotelNo <= 100)
,CONSTRAINT CHKBookingGuestNo
  CHECK (guestNo >= 1 OR guestNo <= 10000)
,CONSTRAINT CHKBookingRoomNo
  CHECK (roomNo >= 1 OR roomNo <= 100)
);
--
--Q4--------------------------------------------------------
--
INSERT INTO Hotel     
  VALUES (1, 'Casino','Vancouver');
INSERT INTO Hotel     
  VALUES (2, 'Dive','Hope');
INSERT INTO Hotel     
  VALUES (3, 'Motel','Kelowna');
--
--
INSERT INTO Room (roomNo, hotelNo, type, price) 
  VALUES (31, 1, 'Family', 100);
INSERT INTO Room (roomNo, hotelNo, type, price) 
  VALUES (42, 2, 'Single', 30);
INSERT INTO Room (roomNo, hotelNo, type, price) 
  VALUES (63, 3, 'Double', 60);
--
--
INSERT INTO Guest (guestNo, guestName, guestAddress) 
  VALUES (6500, 'Jimmy','336 Hill St.');
INSERT INTO Guest (guestNo, guestName, guestAddress) 
  VALUES (6501, 'Fred','213 Lake Ave.');
INSERT INTO Guest (guestNo, guestName, guestAddress) 
  VALUES (6502, 'Bill','336 Forest Road');
--
--
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) 
  VALUES (1, 6500, 31, '2015-12-20', '2015-12-25');
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) 
  VALUES (1, 6501, 31, '2016-01-05', '2016-01-08');
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) 
  VALUES (1, 6502, 31, '2016-01-10', '2016-01-11');
--
--Q5--------------------------------------------------------
--
ALTER TABLE Room 
  DROP CONSTRAINT CHKRoomType;
ALTER TABLE Room 
  ADD  CONSTRAINT CHKRoomType     
    CHECK (type = 'Single' OR type = 'Double' OR type = 'Family');
ALTER TABLE Room 
  ADD discount CHAR(8) DEFAULT 0
    CONSTRAINT CHKDiscount CHECK (discount >= 1 OR discount <= 30);                    
--
--Q6--------------------------------------------------------
--
UPDATE Room
  SET price = price * 0.15
  WHERE type = 'Double';
UPDATE Booking
  SET dateFrom = '2016-01-9'
  WHERE guestNo = '6502';
UPDATE Booking
  SET dateTo = '2016-01-12'
  WHERE guestNo = '6502';
--
--Q7--------------------------------------------------------
--
CREATE TABLE OldBooking
(hotelNo           CHAR(8)       NOT NULL
,guestNo           CHAR(8)       NOT NULL
,roomNo            CHAR(8)       NOT NULL
,dateFrom          DATE          NOT NULL
,dateTo            DATE          NOT NULL
);

INSERT INTO OldBooking
  SELECT *
  FROM Booking
  WHERE dateTo < DATE'2016-01-01';
--
--END--------------------------------------------------------
--
SPOOL OFF