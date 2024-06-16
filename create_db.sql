create database if not exists airport;

use airport;

create table if not exists address(
    address_id int primary key auto_increment,
    city varchar(35) not null,
    street varchar(100) not null,
    house_number int not null
);

create table if not exists airline(
    airline_id int primary key auto_increment,
    airline_name varchar(50) not null,
    phone_number varchar(15),
    email varchar(254) unique,
    address_id int,

    constraint fk_address_on_airline
    foreign key (address_id)
    references address(address_id)
);

create table if not exists airplane(
    airplane_id int primary key auto_increment,
    model varchar(30) not null,
    seats_number int not null,
    range_of_flight int not null,

    constraint chk_airplane
    check (seats_number > 0 and range_of_flight > 0)
);

create table if not exists pilot(
    pilot_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    phone_number varchar(15) not null,
    email varchar(254) not null unique,
    work_experience int,

    constraint chk_exp check (work_experience > 0)
);

create table if not exists flight(
    flight_id int primary key auto_increment,
    airline_id int not null,
    airplane_id int not null,
    pilot_id int not null,
    departure_date datetime not null,
    arrival_date datetime not null,
    departure_airport_address_id int not null,
    arrival_airport_address_id int not null ,

    constraint fk_airline_on_flight
    foreign key (airline_id)
    references airline(airline_id),

    constraint fk_airplane_on_flight
    foreign key (airplane_id)
    references airplane(airplane_id),

    constraint fk_pilot_on_flight
    foreign key (pilot_id)
    references pilot(pilot_id),

    constraint fk_departure_airport_address_on_flight
    foreign key (departure_airport_address_id)
    references address(address_id),

    constraint fk_airport_address_on_flight
    foreign key (arrival_airport_address_id)
    references address(address_id),

    constraint chk_dates
    check (arrival_date > departure_date)
);

create table if not exists passport_data(
    passport_number bigint primary key,
    sex enum('M', 'F') not null,
    nationality varchar(30) not null,
    date_of_birth date not null,
    RNTRC bigint not null unique,
    reg_address_id int not null,

    constraint fk_reg_address_on_passport_data
    foreign key (reg_address_id)
    references address (address_id)
);

create table if not exists passenger(
    passenger_id int primary key auto_increment,
    passport_number bigint not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    phone_number varchar(15) not null,
    email varchar(254) not null unique,

    constraint fk_passport_data_on_passenger
    foreign key (passport_number)
    references passport_data(passport_number)
);

create table if not exists ticket_type(
    type_id int primary key,
    type_name varchar(20) not null,
    age_restriction int,
    percent_of_sale int,

    constraint chk_age check (age_restriction > 0),
    constraint chk_sale check (percent_of_sale between 0 and 100)
);

create table flight_class(
    class_id int primary key,
    class_name varchar(20) not null,
    baggage_weight int not null,
    seat_type varchar(30) not null,
    free_wi_fi bool not null,
    available_meals varchar(50) not null
);

create table if not exists ticket(
    ticket_id int primary key auto_increment,
    flight_id int not null,
    passenger_id int not null,
    class_id int not null,
    type_id int not null,
    seat_number int not null unique,
    price dec(10, 2) not null,
    purchase_date date not null,

    constraint fk_flight_on_ticket
    foreign key (flight_id)
    references flight(flight_id),

    constraint fk_passenger_on_ticket
    foreign key (passenger_id)
    references passenger(passenger_id),

    constraint fk_class_on_ticket
    foreign key (class_id)
    references flight_class(class_id),

    constraint fk_type_on_ticket
    foreign key (type_id)
    references ticket_type(type_id),

    constraint chk_seat_number check (seat_number > 0),
    constraint chk_price check (price > 0),

);


