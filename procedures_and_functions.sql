use airport;

-- Procedures

-- 1) get a list of passengers from a specified country

CREATE PROCEDURE get_passengers_by_nationality(IN nationality VARCHAR(30))
BEGIN
  SELECT *
  FROM passenger_info pi
  WHERE pi.nationality = nationality;
END;

-- test
call get_passengers_by_nationality('Chinese');

-- 2) get flight information by flight ID

CREATE PROCEDURE get_flight_by_id(IN flight_id INT)
BEGIN
  SELECT f.flight_id, a.airline_name as airline, ap.model as airplane, f.departure_date, f.arrival_date,
         aa.city as 'arrival airport city'
  FROM flight f
  INNER JOIN airline a ON f.airline_id = a.airline_id
  INNER JOIN airplane ap ON f.airplane_id = ap.airplane_id
  INNER JOIN address aa ON f.arrival_airport_address_id = aa.address_id

  WHERE f.flight_id = flight_id;
END;
-- test
CALL get_flight_by_id(10);

-- !!!!!!!!!!!
-- 3) get flights with specific airplane model

CREATE PROCEDURE get_flight_by_plane(IN airplane_model VARCHAR(30))
BEGIN
   SELECT f.flight_id, a.model as 'airplane model'
   FROM flight f
   INNER JOIN airplane a on f.airplane_id = a.airplane_id
   WHERE a.model LIKE CONCAT(airplane_model, '%' )
   ORDER BY f.flight_id;
END;
-- test
CAll get_flight_by_plane('Airbus');

-- !!!!!!!!
-- 4) get tickets at a price lower than the specified price

CREATE PROCEDURE get_tickets_by_price(IN price DEC(10,2))
BEGIN
    SELECT * FROM ticket_full_info t
    WHERE t.price <= price;
END;
-- test
CALL get_tickets_by_price(15000);

-- 5) get a ticket by flight class

CREATE PROCEDURE get_ticket_by_class(IN class VARCHAR(20))
BEGIN
   SELECT * FROM ticket_full_info t
   WHERE t.class_name = class;
END;
-- test
CALL get_ticket_by_class('Economy Class');

-- 6) get the max, min and average price of tickets

CREATE PROCEDURE get_price_stats()
BEGIN

    DECLARE avg_price DEC(10,2);
    SELECT AVG(price) INTO avg_price FROM ticket;

    SELECT avg_price as 'Average price',
          MAX(price) as 'Max price',
          MIN(price) as 'Min price'
    FROM ticket;

END;

-- test
CALL get_price_stats();



-- Functions

-- 1) get revenue of all tickets

CREATE FUNCTION get_revenue()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE revenue DECIMAL(10,2);
  SET revenue = 0;

  SELECT SUM(price) INTO revenue
  FROM ticket;

  RETURN revenue;
END;

-- test
SELECT get_revenue() as 'Total Revenue';

-- 2) get allowed baggage weight by ticket_id

CREATE FUNCTION get_baggage_weight (ticket_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE weight INT;

    SELECT fc.baggage_weight INTO weight
    FROM ticket t
    JOIN flight_class fc ON t.class_id = fc.class_id
    WHERE t.ticket_id = ticket_id;

    RETURN weight;
END;

-- test
SELECT get_baggage_weight(1);

-- 3) get seat number by passenger_id

CREATE FUNCTION get_seat_number_by_passenger_id(passenger_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE seat_num INT;

    SELECT t.seat_number INTO seat_num
    FROM ticket t
    WHERE t.passenger_id = passenger_id;

    RETURN seat_num;
END;

-- test
select get_seat_number_by_passenger_id(10);

-- !!!!!!!!!
-- 4) get days remaining to flight

CREATE FUNCTION get_remaining_days(ticket_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE days INT;
    SELECT DATEDIFF(DATE(f.departure_date), t.purchase_date) INTO days
    FROM ticket t
    JOIN flight f on f.flight_id = t.flight_id
    WHERE t.ticket_id = ticket_id;

    RETURN days;
END;
-- test
select purchase_date, date(departure_date), get_remaining_days(2) as 'Days to flight'
from ticket t
join flight f on f.flight_id = t.flight_id
where ticket_id = 2;

-- 5) get amount of free seats by flight_id

DROP FUNCTION IF EXISTS get_amount_of_free_seats;

CREATE FUNCTION get_amount_of_free_seats(flight_id int)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE tickets_sold INT;
    DECLARE capacity INT;
    DECLARE free_seats iNT;

    # capacity of airplane
    SELECT a.seats_number INTO capacity FROM flight f
    JOIN airplane a on a.airplane_id = f.airplane_id
    WHERE f.flight_id = flight_id;

    # tickets sold
    SELECT count(*) INTO tickets_sold FROM ticket t
    WHERE t.flight_id = flight_id;

    # free seats
    SET free_seats = capacity - tickets_sold;

    RETURN free_seats;
END;
-- seats
SELECT get_amount_of_free_seats(11);



