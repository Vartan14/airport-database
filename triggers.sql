use airport;

CREATE TABLE sales(
    airport_id INT PRIMARY KEY,
    tickets_sold INT,
    revenue DEC(10, 2)
);

INSERT INTO sales VALUES (1, 0, 0);

-- 1) insert trigger to track sales

CREATE TRIGGER trigger_insert_ticket
BEFORE INSERT
ON ticket FOR EACH ROW
BEGIN
    UPDATE sales s SET s.tickets_sold = s.tickets_sold + 1 WHERE airport_id = 1;
    UPDATE sales s SET s.revenue = s.revenue + new.price  WHERE airport_id = 1;
END;

-- test
select * from sales;

insert into ticket (flight_id, passenger_id, class_id, type_id, seat_number,
                    price,purchase_date) values (4, 11, 1, 1, 14, 11116.68,'2021-05-23');

-- 2) update trigger to track sales

CREATE TRIGGER trigger_update_ticket
BEFORE UPDATE
ON ticket FOR EACH ROW
BEGIN
    UPDATE sales s SET s.revenue = s.revenue - old.price + new.price  WHERE airport_id = 1;
END;

-- test

UPDATE ticket
SET price = 100000 WHERE seat_number = 14;

SELECT * FROM sales;

-- 3) delete trigger to track sales

CREATE TRIGGER trigger_delete_ticket
BEFORE DELETE
ON ticket FOR EACH ROW
BEGIN
    UPDATE sales s SET s.tickets_sold = s.tickets_sold - 1  WHERE airport_id = 1;
    UPDATE sales s SET s.revenue = s.revenue - old.price  WHERE airport_id = 1;
END;

-- test
select * from sales;

DELETE FROM ticket
WHERE seat_number = 14;

-- 4)

DROP TRIGGER IF EXISTS airplane_capacity_trigger;

CREATE TRIGGER airplane_capacity_trigger
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    DECLARE free_seats int;

    SET free_seats = get_amount_of_free_seats(new.flight_id);

    IF free_seats <= 0 THEN
        SET msg = 'THE FLIGHT IS FULL!';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
END;

insert into ticket (flight_id, passenger_id, class_id, type_id, seat_number, price, purchase_date) values (11, 11, 1, 1, 15, 11116.68,'2021-05-23' );

delete from ticket where ticket_id > 15;

alter table ticket
auto_increment = 16;

CHARINDEX('NEWS','No news is good NEWS');
