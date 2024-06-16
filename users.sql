-- airport admin
create role airport_admin;
grant all on airport.* to airport_admin;

create user admin_alex@localhost identified by '12345';
grant airport_admin to admin_alex@localhost;

-- employee
create role employee;
grant delete, insert, select, update on airport.* to employee;

create user emp_mike@localhost identified by '11111';
grant employee to emp_mike@localhost;

-- passenger
create role customer;
grant select on table ticket to customer;

create user passenger_1@localhost identified by '11111';
grant customer to passenger_1@localhost;


