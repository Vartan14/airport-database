# Airport Database Project

This project provides a MySQL database schema for managing an airport system, including tables for airlines, airplanes, flights, pilots, passengers, tickets, and related entities.
The database also includes predefined roles for different types of users and several views for querying useful information. Procedures, functions and triggers are useful to manage data.

## Installation

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/your-username/airport-database.git
   cd airport-database
   ```

2. **Set Up MySQL Database:**
   - Ensure you have MySQL installed and running.
   - Create a new database:
     ```sql
     CREATE DATABASE airport;
     ```
   - Use the created database:
     ```sql
     USE airport;
     ```

3. **Run the SQL Scripts:**
   - Execute the provided SQL script to create tables, roles, users, views, and insert sample data:
     ```sh
     mysql -u 'your-username' -p airport < 'script'.sql
     ```

## Database Schema

### Tables

The database schema includes the following tables:

- `address`: Stores address information.
- `airline`: Stores information about airlines.
- `airplane`: Stores information about airplanes.
- `pilot`: Stores information about pilots.
- `flight`: Stores information about flights.
- `passport_data`: Stores passport information for passengers.
- `passenger`: Stores information about passengers.
- `ticket`: Stores information about tickets.
- `ticket_type`: Stores information about ticket types.
- `flight_class`: Stores information about flight classes.

### Roles and Users

The database defines roles and users with specific privileges:

- `airport_admin`: Has all privileges on the `airport` database.
  - User: `admin_alex` with password `12345`
- `employee`: Can delete, insert, select, and update on the `airport` database.
  - User: `emp_mike` with password `11111`
- `customer`: Can select from the `ticket` table.
  - User: `passenger_1` with password `11111`

### Views

The database includes several views for easy querying:

1. **Flight Information:**
   ```sql
   CREATE OR REPLACE VIEW flight_info AS
   SELECT f.flight_id, a.airline_name, ap.model, f.departure_date, f.arrival_date, aa.city as 'Arrival Airport'
   FROM flight f
   INNER JOIN airline a ON f.airline_id = a.airline_id
   INNER JOIN airplane ap ON f.airplane_id = ap.airplane_id
   INNER JOIN address aa ON f.arrival_airport_address_id = aa.address_id;
   ```

2. **Passenger Information:**
   ```sql
   CREATE OR REPLACE VIEW passenger_info AS
   SELECT p.passenger_id, pd.passport_number, p.first_name, p.last_name,
          pd.sex, pd.nationality, pd.date_of_birth
   FROM passenger p
   INNER JOIN passport_data pd ON p.passport_number = pd.passport_number;
   ```

3. **Flight Ticket Statistics:**
   ```sql
   CREATE OR REPLACE VIEW flight_ticket_stats AS
   SELECT f.flight_id,  COUNT(t.ticket_id) as 'Total Tickets', SUM(t.price) as 'Total Revenue'
   FROM flight f
   LEFT JOIN ticket t ON f.flight_id = t.flight_id
   GROUP BY f.flight_id;
   ```

4. **Passenger Ticket History:**
   ```sql
   CREATE OR REPLACE VIEW passenger_ticket_history AS
   SELECT p.passenger_id, CONCAT(p.first_name, ' ', p.last_name) as 'Passenger Name',
          COUNT(t.ticket_id) as 'Total Tickets', SUM(t.price) as 'Total Spending'
   FROM passenger p
   INNER JOIN ticket t ON p.passenger_id = t.passenger_id
   GROUP BY p.passenger_id;
   ```

5. **Ticket Full Information:**
   ```sql
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
   ```

## Usage

- **Connecting to the Database:**
  Use your preferred MySQL client to connect to the `airport` database with the appropriate user credentials.

- **Querying Views:**
  Example to get flight information:
  ```sql
  SELECT * FROM flight_info;
  ```

- **Managing Roles and Users:**
  Example to create a new employee user:
  ```sql
  CREATE USER 'new_emp'@'localhost' IDENTIFIED BY 'password';
  GRANT employee TO 'new_emp'@'localhost';
  ```
