explain select * from pilot
where last_name = 'Rain';

drop index idx_ln on pilot;
create index idx_ln on pilot(last_name);

explain select * from pilot
where last_name = 'Rain';


create index idx_type_name on ticket_type(type_name);
create index idx_class_name on flight_class(class_name);
create index idx_dd on flight(departure_date);
create index idx_ad on flight(arrival_date);
create index idx_price on ticket(price);



