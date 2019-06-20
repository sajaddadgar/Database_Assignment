use test2;
-- Section1
create table Patient (
	patient_id int auto_increment, 
    name varchar(255) not null,
    gender varchar(255), 
    address text,  
    phone varchar(255) not null unique, 
    disease varchar(255), 
    insurance_id varchar(255) unique,
    PRIMARY KEY (patient_id), 
    constraint gender_value check (gender='male' or gender='female' or gender='others')
);
-- Section2
CREATE TABLE Appointment(
	patient_id INT NOT NULL,
    dr_id INT NOT NULL,
    nurse_id INT NOT NULL,
    room_id INT NOT NULL,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES Room (room_id),
    FOREIGN KEY (dr_id) REFERENCES Doctor (dr_id),
    FOREIGN KEY (nurse_id) REFERENCES Nurse (nurse_id),
    FOREIGN KEY (patient_id) REFERENCES Patient (patient_id),
    PRIMARY KEY (datetime)
);
-- Section3
update stay inner join room on (room.room_id=stay.room_id)
	inner join patient on (patient.patient_id=stay.patient_id)
	set stay.room_id=(
    select room.room_id from room where room.room_number=25
    ) where patient.phone='989123456789' and stay.start_date='2019-03-01';
-- Section4
INSERT INTO Stay (patient_id , room_id , start_date , end_date)
VALUES ((SELECT Patient.patient_id FROM Patient
WHERE Patient.phone = '989123456788') ,(SELECT MIN(Room.room_id) FROM Room WHERE Room.status = 'empty')  ,CURDATE() ,DATE_ADD(CURDATE() , INTERVAL 2 DAY));
-- Section5
UPDATE Room INNER JOIN Stay ON Stay.room_id = Room.room_id
SET Room.status = 'full' WHERE (Stay. Start_date <= CURDATE() and Stay.end_date > CURDATE()) OR Stay.end_date is null; 
-- Section6
alter table nurse add position varchar(128) not null default 'Informatics Nurse';