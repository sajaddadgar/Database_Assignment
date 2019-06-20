use test;
-- Section1 
select id, first_name, last_name from account inner join car on account.id = car.driver_id where car.tag_number in (select car_id from ride)
and last_name in (select last_name from account inner join rider on account.id = rider.rider_id);
 -- Section2
 select s1.phone from
	(select account.phone, account.id, sum(payment.amount) as sum_of_salary from account
    inner join driver on driver.driver_id = account.id
    inner join car on car.driver_id = driver.driver_id inner join ride on ride.car_id = car.tag_number
    inner join payment on ride.ride_req_id = payment.ride_id
    where payment.is_cash = true group by driver.driver_id ) as s1 
order by s1.sum_of_salary desc, s1.id asc limit 5;
 -- Section3
select * from
  (select driver_info.first_name as driver_name, rider_info.first_name as rider_name, count(riderequest.ride_req_id) as travel_num from account as driver_info
    inner join driver on driver.driver_id = driver_info.id
    inner join car on car.driver_id = driver.driver_id
    inner join ride on ride.car_id = car.tag_number
    inner join riderequest on ride.ride_req_id = riderequest.ride_req_id
    inner join rider on rider.rider_id = riderequest.rider_id
    inner join account as rider_info on rider_info.id = rider.rider_id
    group by driver_info.id, rider_info.id order by travel_num desc) as x
where x.travel_num = (select max(y.travel_num) from
  (select count(riderequest.ride_req_id) as travel_num from account as driver_info
    inner join driver on driver_info.id = driver.driver_id
    inner join car on car.driver_id = driver.driver_id
    inner join ride on ride.car_id = car.tag_number
    inner join riderequest on ride.ride_req_id = riderequest.ride_req_id
    inner join rider on rider.rider_id = riderequest.rider_id
    inner join account as rider_info on rider_info.id = rider.rider_id
    group by driver_info.id, rider_info.id) as y)
order by x.driver_name, x.rider_name;
 -- Section4
select floor(distance.get_sum) from (select sum(sqrt(power(riderequest.destination_x_coordinate - riderequest.origin_x_coordinate, 2) + power(riderequest.destination_y_coordinate - riderequest.origin_y_coordinate, 2))) as get_sum from riderequest inner join ride on riderequest.ride_req_id = ride.ride_req_id) as distance;
 -- Section5
select get_driver.id from 
	(select driver.driver_id as id, avg(ride.driver_rating) as get_average, count(driver.driver_id) as get_num from driver
    inner join car on car.driver_id = driver.driver_id
    inner join ride on car.tag_number = ride.car_id
    group by driver.driver_id) as get_driver
	where get_driver.get_average < 3.5 and get_driver.get_num > 5;
 -- Section6
select '*', count(*) from (
	select avg(ride.driver_rating) as average from driver inner join car on car.driver_id = driver.driver_id inner join ride on
    car.tag_number = ride.car_id group by driver.driver_id 
    ) as x
    where x.average < 2

union
select '***', count(*) from (
	select avg(ride.driver_rating) as average from driver inner join car on driver.driver_id = car.driver_id inner join ride on
    car.tag_number = ride.car_id group by driver.driver_id 
    ) as x
    where x.average >= 2 and x.average < 4
    
union
select '*****', count(*) from (
	select avg(ride.driver_rating) as average from driver inner join car on car.driver_id = driver.driver_id inner join ride on
    car.tag_number = ride.car_id group by driver.driver_id 
    ) as x
    where x.average >= 4;
 -- Section7
select car.driver_id from car
    inner join ride on ride.car_id = car.tag_number
    inner join payment on ride.ride_req_id = payment.ride_id where car.type ='Eco' and ride.dropoff_time < adddate(ride.pickup_time, interval 10 minute) and payment.amount >= 20000 and payment.is_cash = true
    group by car.driver_id;
 -- Section8
 select getDriver.average from (
	select riderequest.rider_id, count(riderequest.rider_id) as rider_num, avg(ride.rider_rating) as average from riderequest
    inner join ride on ride.ride_req_id = riderequest.ride_req_id group by riderequest.rider_id
    order by rider_num desc, riderequest.rider_id limit 5) as getDriver;
-- Section9
select account.first_name, account.last_name from account
  inner join rider on rider.rider_id = account.id
  inner join riderequest on riderequest.rider_id = account.id
  left join ride on ride.ride_req_id = riderequest.ride_req_id, driver
where ride.ride_req_id is null and driver.is_active = true
and
      sqrt(
        power(driver.x_coordinate - riderequest.origin_x_coordinate, 2) +
        power(driver.y_coordinate - riderequest.origin_y_coordinate, 2)) < 1
group by account.id;
-- Section10
select myTable.id, myTable.first_name, myTable.last_name from
(
  select account.id, account.first_name, account.last_name, sum(payment.amount) as total from account
  inner join car on car.driver_id = account.id
  inner join ride on ride.car_id =  car.tag_number
  inner join payment on payment.ride_id = ride.ride_req_id group by car.driver_id
) as myTable where myTable.total >
                   (select avg(myTable2.total) from
                     (select sum(payment.amount) as total from driver
                       inner join car on car.driver_id = driver.driver_id
                       inner join ride on ride.car_id = car.tag_number
                       inner join payment on payment.ride_id = ride.ride_req_id
                       group by driver.driver_id) as myTable2);
-- Section11
select case when
              ((select count(riderequest.ride_req_id) from riderequest where car_type = 'Luxury' and riderequest.ride_req_id
                not in (select ride.ride_req_id from ride)) > (select count(riderequest.ride_req_id) 
                from riderequest where car_type = 'Eco' and riderequest.ride_req_id
                not in (select ride.ride_req_id from ride))) then 'Luxury' else 'Eco' 
  end , 
       abs((select count(riderequest.ride_req_id) from riderequest where car_type = 'Luxury' and riderequest.ride_req_id
                not in (select ride.ride_req_id from ride)) - (select count(riderequest.ride_req_id)
                from riderequest where car_type = 'Eco' and riderequest.ride_req_id
                not in (select ride.ride_req_id from ride)));
-- Section12
select
      model, count(model)
from car, driver
where car.driver_id = driver.driver_id and driver.is_active = true and car.tag_number like '__T%'
group by car.model;
-- Section13
select 
       ride.ride_req_id 
from ride, payment 
where ride.ride_req_id = payment.ride_id 
  and mod(payment.amount/1000, 2) = 0
  and (payment.amount/1000) / (time_to_sec(ride.dropoff_time - ride.pickup_time) / 60) > 5;




