-- Ba Choi Project Q2. SQL DDL

create table product(
	Product_ID integer,
	Product_Name varchar(100),
	Brand_ID integer,
	P_type_ID integer,
	Country_State varchar(20),
	ABV integer,
	Price decimal(10,2), 
	primary key (Product_ID));

create table brand(
	Brand_ID integer,
	Brand_name varchar(20),
	Brand_description varchar(100),
	primary key (Brand_ID));

create table product_type(
	P_type_ID integer,
	Type_name varchar(10),
	Type_description varchar(100),
	primary key (P_type_ID));
	
create table order_made(
	Order_ID integer,
	Client_ID integer,
	Product_ID integer,
	Order_date date,
	Quantity integer, 
	primary key (Order_ID,Client_ID,Product_ID));

create table client(
	Client_ID integer,
	Location varchar(20),
	State_ID integer,
	primary key(Client_ID));
	
create table state (
	State_ID integer,
	State_name varchar(10),
	primary key (State_ID));


create table made_by (
	Brand_ID integer,
	Product_ID integer,
	primary key(Product_ID),
	foreign key(Product_ID) references product(Product_ID),
	foreign key(Brand_ID) references brand(Brand_ID));
	
create table has_type (
	P_type_ID integer,
	Product_ID integer,
	primary key(Product_ID),
	foreign key(P_type_ID) references product_type(P_type_ID),
	foreign key(Product_ID) references product(Product_ID));	
	
create table has(
	Order_ID integer,
	Client_ID integer,
	Product_ID integer,
	primary key (Order_ID,Client_ID,Product_ID),
	foreign key(Product_ID)references product(Product_ID),
	foreign key(Order_ID,Client_ID,Product_ID)references Order_made(Order_ID,Client_ID,Product_ID));

	
create table make (
	Order_ID integer,
	Client_ID integer,
	Product_ID integer,
	primary key(Order_ID,Client_ID,Product_ID),
	foreign key(Order_ID,Client_ID,Product_ID) references order_made(Order_ID,Client_ID,Product_ID),
	foreign key(Client_ID) references client(Client_ID));

create table locate_at (
	State_ID integer,
	Client_ID integer,
	primary key(Client_ID),
	foreign key (State_ID) references state (State_ID),
	foreign key (Client_ID) references client (Client_ID));