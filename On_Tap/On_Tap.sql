create database abc_shop;
use abc_shop;
create table users(
	user_id int primary key auto_increment,
    user_name varchar(255) not null unique,
    user_fullname varchar(100) not null,
	email varchar(100) not null unique,
    user_address text ,
    user_phone varchar(20) not null unique
);
create table employees(
	emp_id int primary key auto_increment ,
    user_id int,
    emp_position varchar(50),
    emp_hire_date date,
    salary int not null check(salary>0),
    status bit default(1),
    foreign key (user_id) references users(user_id)
);
create table orders(
	order_id int primary key auto_increment,
    user_id int,
    order_date date,
    order_total_amount int,
    foreign key (user_id) references users(user_id)	
);
create table products(
	pro_id int primary key auto_increment,
    pro_name varchar(100) not null unique,
    pro_price int not null check(pro_price>0),
    pro_quantity int,
    pro_status bit default 1
);
create table order_detail(
	order_detail_id int primary key auto_increment,
	order_id int ,
    pro_id int,
    order_detail_quantity int check(order_detail_quantity > 0),
    order_detail_price int,
    foreign key (order_id) references orders(order_id),
    foreign key (pro_id) references products(pro_id)
);

alter table orders
add column order_status  enum ('Pending', 'Processing', 'Completed', 'Cancelled') not null;

alter table users
modify user_phone varchar(11);

alter table users
drop column email;
 
insert into users(user_name, user_fullname, user_address, user_phone)
values
    ('Tran', 'Tran Thi B', 'Da Nang', '0912345678'),
    ('Nguyen', 'Nguyen Thi A', 'Hai Phong', '0987654321'),
    ('Le', 'Le Thi C', 'Ho Chi Minh', '0909876543');
    
insert into products(pro_name, pro_price, pro_quantity, pro_status)
values
    ('Laptop HP', 17000000, 8, 1),   
    ('iPhone 13', 21000000, 6, 1),  
    ('AirPods 2', 6000000, 20, 1);    

insert into orders(user_id, order_date, order_total_amount, order_status)
values
    (1, '2024-01-15', 39000000, 'Completed'),  
    (2, '2024-03-02', 21000000, 'Pending'),     
    (3, '2024-01-28', 16000000, 'Completed');  

insert into order_detail(order_id, pro_id, order_detail_quantity, order_detail_price)
values 
    (1, 1, 1, 17000000),   
    (1, 2, 1, 21000000),  
    (2, 3, 1, 6000000);    

insert into employees(user_id, emp_position, emp_hire_date, salary, status)
values
    (1, 'Manager', '2022-07-10', 28000000, 1),  
    (2, 'Sales', '2023-02-05', 16000000, 1),     
    (3, 'Technician', '2023-06-01', 19000000, 1); 

 -- cau 4a
 select 
 order_id,order_date,order_total_amount,order_status
 from orders;
 -- cau 4b
 select distinct user_name
 from users u
 join orders o on u.user_id = o.user_id;
 -- cau 5a
 select p.pro_name,o.order_detail_quantity
 from products p
 join order_detail o on p.pro_id = o.pro_id;
 -- cau 5b
 select p.pro_name,o.order_detail_quantity * p.pro_price as total
 from products p
 join order_detail o on p.pro_id = o.pro_id
 order by total desc;
 -- cau 6a
 select u.user_fullname,count(o.order_id) as total_order
 from orders o
 join users u on o.user_id = u.user_id
 group by u.user_id,u.user_fullname;
 -- cau 6b
 select u.user_fullname,count(o.order_id) as total_order
 from orders o
 join users u on o.user_id = u.user_id
 group by u.user_id,u.user_fullname
 having total_order > 2;
 -- cau 7
 select u.user_fullname, sum(o.order_total_amount) as total_amount_spent
 from users u
 join orders o on u.user_id = o.user_id
 group by u.user_id,u.user_fullname
 order by total_amount_spent desc
 limit 5;
 -- cau 8
 select u.user_fullname,em.emp_position,count(o.order_id) as total_order
 from employees em
 join users u on em.user_id = u.user_id
 left join orders o on u.user_id = o.user_id
 group by em.user_id,u.user_fullname,em.emp_position;
 -- cau 9
 select u.user_fullname,o.order_total_amount
 from orders o 
 join users u on o.user_id = u.user_id
 where o.order_total_amount = (select max(order_total_amount) from orders);
 -- cau 10
 select p.pro_id,p.pro_name,p.pro_quantity
 from products p
 where p.pro_id not in (select distinct pro_id from products);


 