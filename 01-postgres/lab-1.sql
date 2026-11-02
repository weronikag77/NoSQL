SELECT * FROM employees;


-- TASK 1

-- zad.1 
select first_name, last_name, department, salary from employees;

-- zad.2
select * from employees where department = 'Engineering';

-- zad.3
select * from employees where is_remote = 'true' and salary > 80000;

-- zad.4
select * from employees where hire_date between '2021-01-02' and '2022-12-31' order by hire_date asc;

-- zad.5
select * from employees where job_title like '%Manager%';

-- zad.6
select * from employees order by salary desc limit 3;

-- zad.7
select count(id) as employee_count, avg(salary) as average_salary from employees;

-- zad.8
select count(id) as employee_count, avg(salary) as average_salary from employees
group by department;

-- zad.9
select department, avg(salary) as average_salary from employees
group by department
having avg(salary) > 80000;


-- TASK 2

create table rooms (
    id serial primary key,
    room_name varchar(50) not null unique,
    capacity int check (capacity > 0),
    has_projector boolean default true
);

INSERT INTO rooms (room_name, capacity, has_projector) VALUES
('Boardroom A', 12, true),
('Focus Room B', 4, false),
('Auditorium C', 50, true);

create table users (
    id serial primary key,
    full_name varchar(100) not null,
    email varchar(100) not null unique
);

INSERT INTO users (full_name, email) VALUES
('Alice Johnson', 'alice.johnson@example.com'),
('Bob Smith', 'bob.smith@example.com'),
('Charlie Brown', 'charlie.brown@example.com');

create table bookings (
    id serial primary key,
    room_id int not null references rooms(id) on delete cascade,
    user_id int not null references users(id) on delete cascade,
    booking_date date not null,
    duration_hours int check (duration_hours between 1 and 8)
);

INSERT INTO bookings (room_id, user_id, booking_date, duration_hours) VALUES
(1, 1, '2026-09-20', 2), -- Alice booked Boardroom A
(1, 2, '2026-09-21', 4), -- Bob booked Boardroom A
(2, 1, '2026-09-22', 1), -- Alice booked Focus Room B
(3, 3, '2026-09-20', 3); -- Charlie booked Auditorium C

-- operation A

select full_name, room_name, booking_date, duration_hours from bookings b inner join users u on b.user_id = u.id inner join rooms r on b.room_id = r.id;

-- operation B

INSERT INTO users (full_name, email) 
VALUES ('Duplicate User', 'alice.johnson@example.com');

INSERT INTO rooms (room_name, capacity, has_projector) 
VALUES ('Tiny Closet', 0, false);

INSERT INTO bookings (room_id, user_id, booking_date, duration_hours) 
VALUES (1, 1, '2026-09-25', 10);

-- operation C

-- Delete user 'Alice Johnson'
DELETE FROM users WHERE email = 'alice.johnson@example.com';

-- Verify that Alice's bookings were automatically removed from the bookings table
SELECT * FROM bookings;


-- TASK 3

-- operation A
select full_name, country, o.id as order_id, order_date from orders o inner join customers c on o.customer_id = c.id
where status = 'COMPLETED';

-- operation B

select full_name, sum(quantity * unit_price) as order_total
from orders o inner join customers c on o.customer_id = c.id inner join order_items oi on o.id = oi.order_id
where status = 'COMPLETED'
group by full_name;


-- operation C

select full_name, sum(quantity * unit_price) as order_total
from orders o inner join customers c on o.customer_id = c.id inner join order_items oi on o.id = oi.order_id
where status = 'COMPLETED'
group by full_name
having sum(quantity * unit_price) > 300;

-- operation D

CREATE VIEW v_customer_revenue AS
select full_name, sum(quantity * unit_price) as order_total
from orders o inner join customers c on o.customer_id = c.id inner join order_items oi on o.id = oi.order_id
where status = 'COMPLETED'
group by full_name;

SELECT * FROM v_customer_revenue;
SELECT * FROM v_customer_revenue WHERE country = 'USA';