use airport;

-- 1) view to display flight information

CREATE OR REPLACE VIEW flight_info AS
SELECT f.flight_id, a.airline_name, ap.model, f.departure_date, f.arrival_date, aa.city as 'Arrival Airport'
FROM flight f
INNER JOIN airline a ON f.airline_id = a.airline_id
INNER JOIN airplane ap ON f.airplane_id = ap.airplane_id
INNER JOIN address aa ON f.arrival_airport_address_id = aa.address_id;

SELECT * FROM flight_info;

-- 2) view to display passenger information

CREATE OR REPLACE VIEW passenger_info AS
SELECT p.passenger_id, pd.passport_number, p.first_name, p.last_name,
       pd.sex, pd.nationality, pd.date_of_birth
FROM passenger p
INNER JOIN passport_data pd ON p.passport_number = pd.passport_number;

SELECT * FROM passenger_info;

-- !!!!!!!!!
-- 3) ticket statistics for each flight, including the total number of tickets sold and total revenue.

CREATE OR REPLACE VIEW flight_ticket_stats AS
SELECT f.flight_id,  COUNT(t.ticket_id) as 'Total Tickets', SUM(t.price) as 'Total Revenue'
FROM flight f
LEFT JOIN ticket t ON f.flight_id = t.flight_id
GROUP BY f.flight_id;

SELECT * FROM flight_ticket_stats;

-- !!!!!!!!
-- 4) info about passenger and his ticket history

CREATE OR REPLACE VIEW passenger_ticket_history AS
SELECT p.passenger_id, CONCAT(p.first_name, ' ', p.last_name) as 'Passenger Name',
       COUNT(t.ticket_id) as 'Total Tickets', SUM(t.price) as 'Total Spending'
FROM passenger p
INNER JOIN ticket t ON p.passenger_id = t.passenger_id
GROUP BY p.passenger_id;

SELECT * FROM passenger_ticket_history;

-- 5) ticket_info

CREATE OR REPLACE VIEW ticket_full_info AS
SELECT t.ticket_id,
       al.airline_name as airline,
       ap.model as airplane,
       CONCAT(p1.first_name,' ',p1.last_name) as pilot,
       CONCAT(p.first_name,' ', p.last_name) as passenger,
       f.departure_date, f.arrival_date,
       tt.type_name, fc.class_name, t.seat_number, t.price

    FROM ticket t
    INNER JOIN flight f ON t.flight_id = f.flight_id
    INNER JOIN airline al ON f.airline_id = al.airline_id
    INNER JOIN airplane ap ON f.airplane_id = ap.airplane_id
    INNER JOIN pilot p1 ON f.pilot_id = p1.pilot_id
    INNER JOIN passenger p ON t.passenger_id = p.passenger_id
    INNER JOIN ticket_type tt ON t.type_id = tt.type_id
    INNER JOIN flight_class fc ON t.class_id = fc.class_id;

SELECT * FROM ticket_full_info;
