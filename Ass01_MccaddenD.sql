
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
,CONSTRAINT PKHotelNo  CHECK (hotelNo >= 1 OR hotelNo <= 100)
);
--
CREATE TABLE Room
(roomNo            CHAR(8)       NOT NULL    
,hotelNo           CHAR(8)       NOT NULL
,type              VARCHAR(20)   NOT NULL    
,price             DECIMAL(12,2) NOT NULL   
,CONSTRAINT PKRoom     PRIMARY KEY (roomNo)
,CONSTRAINT FKHotelNo1 FOREIGN KEY (hotelNo)  REFERENCES Hotel (hotelNo)
,CONSTRAINT CHKType     CHECK (type = 'Single' OR type = 'Double' OR type = 'Family')
,CONSTRAINT CHKPrice    CHECK (price >= 10 OR price <= 100)
,CONSTRAINT CHKRoomNo1  CHECK (roomNo >= 1 OR roomNo <= 100)
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
,CONSTRAINT FKHotelNo2 FOREIGN KEY (hotelNo) REFERENCES Hotel (hotelNo)
,CONSTRAINT FKGuestNo  FOREIGN KEY (guestNo) REFERENCES Guest (guestNo)
,CONSTRAINT FKRoomNo2  FOREIGN KEY (roomNo)  REFERENCES Room (roomNo)
);
--
--Q4--------------------------------------------------------
--
INSERT INTO Hotel     VALUES   (1, 'Casino','Vancouver');
INSERT INTO Hotel     VALUES   (2, 'Dive','Hope');
INSERT INTO Hotel     VALUES   (3, 'Motel','Kelowna');

INSERT INTO Room (roomNo, hotelNo, type, price) VALUES (31, 1, 'Family', 100);
INSERT INTO Room (roomNo, hotelNo, type, price) VALUES (42, 2, 'Single', 30);
INSERT INTO Room (roomNo, hotelNo, type, price) VALUES (63, 3, 'Double', 60);

INSERT INTO Guest (guestNo, guestName, guestAddress) VALUES (6500, 'Jimmy','336 Hill St.');
INSERT INTO Guest (guestNo, guestName, guestAddress) VALUES (6501, 'Fred','213 Lake Ave.');
INSERT INTO Guest (guestNo, guestName, guestAddress) VALUES (6502, 'Bill','336 Forest Road');
 
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) VALUES (1, 6500, 31, '2015-12-29', '2016-01-03');
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) VALUES (1, 6500, 31, '2016-01-05', '2016-01-08');
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) VALUES (1, 6500, 31, '2016-01-10', '2016-01-11');
--
--Q5--------------------------------------------------------
--
ALTER TABLE Room DROP CONSTRAINT CHKType;
ALTER TABLE Room ADD  CONSTRAINT CHKType    CHECK (type = 'Single' OR type = 'Double' OR type = 'Family');
--
--Q6--------------------------------------------------------
--

--
--Q7--------------------------------------------------------
--





SPOOL OFF
