SET ECHO ON
SPOOL C:\Users\Deric\workspace\COMP2714_ASN01\Asn01_MccaddenD.txt
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
--  START C:\Users\Deric\workspace\COMP2714_ASN01\Ass01_MccaddenD.sql
-- ---------------------------------------------------------
--
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';
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
  (hotelNo   CHAR(8)       NOT NULL
  ,hotelName VARCHAR2(20)  NOT NULL
  ,city      VARCHAR2(30)  NOT NULL
  ,CONSTRAINT pk_hotel PRIMARY KEY (hotelNo)
  ,CONSTRAINT ck_hotelNo CHECK (hotelNo >= 1 OR hotelNo <= 100)
  )
;

CREATE TABLE Room
  (roomNo    CHAR(8)       NOT NULL    
  ,hotelNo   CHAR(8)       NOT NULL
  ,type      VARCHAR(20)   NOT NULL    
  ,price     DECIMAL(12,2) NOT NULL   
  ,CONSTRAINT pk_room        PRIMARY KEY (roomNo, hotelNo)
  ,CONSTRAINT fk_room_hotel  FOREIGN KEY (hotelNo)  REFERENCES Hotel (hotelNo)
  ,CONSTRAINT ck_room_type   CHECK (type IN ('Single', 'Double', 'Family'))
  ,CONSTRAINT ck_room_price  CHECK (price BETWEEN 10 AND 100)
  ,CONSTRAINT ck_room_roomNo CHECK (roomNo BETWEEN 1 AND 100)
  )
;
--
--Q3--------------------------------------------------------
--
CREATE TABLE Guest
  (guestNo      CHAR(8)      NOT NULL
  ,guestName    VARCHAR2(50) NOT NULL
  ,guestAddress VARCHAR2(70) NOT NULL
  ,CONSTRAINT pk_guest         PRIMARY KEY (guestNo)
  )
;

CREATE TABLE Booking
  (hotelNo  CHAR(8) NOT NULL
  ,guestNo  CHAR(8) NOT NULL
  ,roomNo   CHAR(8) NOT NULL
  ,dateFrom DATE    NOT NULL
  ,dateTo   DATE    NULL
  ,CONSTRAINT pk_booking       PRIMARY KEY (hotelNo, guestNo, DateFrom)
  ,CONSTRAINT fk_booking_room  FOREIGN KEY (roomNo, hotelNo) REFERENCES Room (roomNo, hotelNo)
  ,CONSTRAINT fk_booking_guest FOREIGN KEY (guestNo)         REFERENCES Guest (guestNo)
  ,CONSTRAINT ck_booking_hotelNo CHECK (hotelNo >= 1 OR hotelNo <= 100)
  ,CONSTRAINT ck_booking_guestNo CHECK (guestNo >= 1 OR guestNo <= 10000)
  ,CONSTRAINT ck_booking_roomNo  CHECK (roomNo >= 1 OR roomNo <= 100)
  )
;
--
--Q4--------------------------------------------------------
--
INSERT INTO Hotel     
  VALUES ('1', 'Casino','Vancouver')
;
INSERT INTO Hotel     
  VALUES ('2', 'Dive','Hope')
;
INSERT INTO Hotel     
  VALUES ('3', 'Motel','Kelowna')
;
--
--
INSERT INTO Room (roomNo, hotelNo, type, price) 
  VALUES ('31', '1', 'Family', 100)
;
INSERT INTO Room (roomNo, hotelNo, type, price) 
  VALUES ('42', '2', 'Single', 30)
;
INSERT INTO Room (roomNo, hotelNo, type, price) 
  VALUES ('63', '3', 'Double', 60)
;
--
--
INSERT INTO Guest (guestNo, guestName, guestAddress) 
  VALUES ('6500', 'Jimmy','336 Hill St.')
;
INSERT INTO Guest (guestNo, guestName, guestAddress) 
  VALUES ('6501', 'Fred','213 Lake Ave.')
;
INSERT INTO Guest (guestNo, guestName, guestAddress) 
  VALUES ('6502', 'Bill','336 Forest Road')
;
--
--
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) 
  VALUES ('1', '6500', '31', DATE'2015-12-20', DATE'2015-12-25')
;
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) 
  VALUES ('1', '6501', '31', DATE'2016-01-05', DATE'2016-01-08')
;
INSERT INTO Booking (hotelNo, guestNo, roomNo, dateFrom, dateTo) 
  VALUES ('1', '6502', '31', DATE'2016-01-10', DATE'2016-01-11')
;
--
--Q5--------------------------------------------------------
--
ALTER TABLE Room 
  DROP CONSTRAINT ck_room_type
;
ALTER TABLE Room 
  ADD CONSTRAINT ck_room_type CHECK (type IN ('Single', 'Double', 'Family', 'Deluxe'))
;
ALTER TABLE Room 
  ADD discount DECIMAL(3) DEFAULT 0 NOT NULL
    CONSTRAINT ck_room_discount CHECK (discount BETWEEN 0 AND 30)
;                    
--
--Q6--------------------------------------------------------
--
UPDATE Room
  SET price = price * 1.15
  WHERE type = 'Double'
  AND hotelNo = (SELECT hotelNo
                 FROM Hotel
                 WHERE hotelName = 'Motel')
;
UPDATE Booking
  SET dateFrom = DATE'2016-01-9', 
      dateTo = DATE'2016-01-12'
  WHERE guestNo = (SELECT guestNo
                   FROM Guest
                   WHERE guestName = 'Fred')
  AND hotelNo =   (SELECT hotelNo
                   FROM Hotel
                   WHERE hotelName = 'Casino')
  AND dateFrom =   DATE'2016-01-05'
;
--
--Q7--------------------------------------------------------
--
CREATE TABLE OldBooking
  (hotelNo  CHAR(8) NOT NULL
  ,guestNo  CHAR(8) NOT NULL
  ,roomNo   CHAR(8) NOT NULL
  ,dateFrom DATE    NOT NULL
  ,dateTo   DATE    NULL
  ,CONSTRAINT pk_oldBooking PRIMARY KEY (hotelNo, roomNo)
  )
;

INSERT INTO OldBooking
  (SELECT *
  FROM Booking
  WHERE dateTo < DATE'2016-01-01')
;
DELETE FROM Booking
  WHERE dateTo < DATE'2016-01-01'
;
--
--END--------------------------------------------------------
--
SPOOL OFF