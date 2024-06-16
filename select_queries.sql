use airport;

-- 1) select all First Class tickets

SELECT t.ticket_id, fc.class_name FROM ticket t
JOIN flight_class fc ON fc.class_id = t.class_id
WHERE fc.class_name = 'First Class';

-- 2) select flights with pilots with experience more than 10 years

SELECT f.flight_id, f.pilot_id, p.work_experience FROM flight f
JOIN pilot p ON f.pilot_id = p.pilot_id
WHERE p.work_experience > 10;

-- 3) select male passengers

SELECT p.passenger_id, p.first_name, p.last_name, pd.sex FROM passenger p
JOIN passport_data pd ON pd.passport_number = p.passport_number
WHERE pd.sex = 1;

-- 4) select all child tickets

SELECT t.ticket_id, tt.type_id, tt.type_name FROM ticket t
JOIN ticket_type tt ON t.type_id = tt.type_id
WHERE tt.type_name = 'child';

-- 5) select flight with airplanes that have range of flight bigger than 5000m and less than 10000m

SELECT f.flight_id, a.airplane_id, a.model, a.range_of_flight FROM flight f
JOIN airplane a ON f.airplane_id = a.airplane_id
WHERE a.range_of_flight BETWEEN 5000 and 10000
ORDER BY f.flight_id;

-- 6) select tickets on January

SELECT t.ticket_id, f.flight_id, f.departure_date FROM ticket t
JOIN flight f ON t.flight_id = f.flight_id
WHERE month(f.departure_date) = '01';

-- 7) select flight with pilot with id 14 and info about him

SELECT  p.pilot_id, count(*) as flights,
        p.first_name, p.last_name, p.phone_number, p.email, p.work_experience FROM flight f
JOIN pilot p on p.pilot_id = f.pilot_id
WHERE p.pilot_id = 14;

-- 8) tickets with passengers with id: 3,7,8,13,15

SELECT t.ticket_id, p.first_name, p.last_name, t.seat_number, t.price FROM ticket t
JOIN passenger p on p.passenger_id = t.passenger_id
WHERE t.passenger_id in (3, 7, 8,13, 15);

-- 9) get info about class and type of tickets with id 8 and 10

SELECT t.ticket_id, tt.type_name, fc.class_name FROM ticket t
JOIN ticket_type tt on tt.type_id = t.type_id
JOIN flight_class fc on fc.class_id = t.class_id
WHERE t.ticket_id = 8 or t.ticket_id = 10;

-- 10) tickets with passengers whose name starts with letter 'A'

SELECT t.ticket_id, p.passenger_id, p.first_name FROM ticket t
JOIN passenger p on p.passenger_id = t.passenger_id
WHERE p.first_name like 'A%';

-- 11) flight made more than 6 month ago

SELECT * FROM flight f
WHERE DATEDIFF(CURDATE(), f.arrival_date ) > 182;

-- 12) flight with info about airline and airplane

SELECT f.flight_id, a.airline_name, ap.model
FROM flight f
JOIN airline a ON f.airline_id = a.airline_id
JOIN airplane ap ON f.airplane_id = ap.airplane_id;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- 13) total number of tickets sold for each ticket type more than 5 times

SELECT tt.type_name, COUNT(t.ticket_id) as 'Total Tickets'
FROM ticket_type tt
JOIN ticket t ON tt.type_id = t.type_id
GROUP BY tt.type_name;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- 14) total number of tickets sold for each airline

SELECT a.airline_name, COUNT(t.ticket_id) as 'Total Tickets'
FROM airline a
INNER JOIN flight f ON a.airline_id = f.airline_id
INNER JOIN ticket t ON f.flight_id = t.flight_id
GROUP BY a.airline_name
HAVING COUNT(t.ticket_id) > 1;

-- 15) get arrival addresses

SELECT t.ticket_id, concat(a.city,', ', a.street,', ',a.house_number) as 'arrival address' FROM ticket t
JOIN flight f on f.flight_id = t.flight_id
JOIN address a on a.address_id = f.arrival_airport_address_id
ORDER BY t.ticket_id
LIMIT 10;

-- 16) get flight where amount of seats is bigger than 450

SELECT f.flight_id, a.seats_number FROM flight f
JOIN airplane a on a.airplane_id = f.airplane_id
WHERE a.seats_number > 450
ORDER BY f.flight_id;

-- 17) get tickets to specific city 'Nea Santa'

SELECT t.ticket_id , a.city FROM ticket t
JOIN flight f on f.flight_id = t.flight_id
JOIN address a on a.address_id = f.arrival_airport_address_id
WHERE a.city = 'Nea Santa';

-- 18) tickets in order by the nearest date

SELECT f.departure_date, t.ticket_id  FROM ticket t
JOIN flight f on f.flight_id = t.flight_id
ORDER BY f.departure_date;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!
-- 19) tickets on specific date and price

SELECT t.ticket_id, f.departure_date, t.price FROM ticket t
JOIN flight f on f.flight_id = t.flight_id
WHERE (f.departure_date between '2022-06-14' and '2022-06-28')
       and t.price < 25000
ORDER BY t.ticket_id;

-- 20) get adult passengers

SELECT p.passenger_id, concat(p.first_name, ' ', p.last_name) as name, pd.date_of_birth
FROM passenger p
JOIN passport_data pd on pd.passport_number = p.passport_number
WHERE DATEDIFF(CURDATE(), date_of_birth) > 18*365;


