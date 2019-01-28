--2.1
select * from employee;
select * from employee where lastname = 'King';
select * from employee where firstname = 'Andrew' and reportsto is null;

--2.2
select * from album order by title desc;
select firstname from employee order by city desc;

--2.3
insert into genre (genreid, name) values (26, 'Gabber');
insert into genre (genreid, name) values (27, 'Speedcore');

insert into employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
values (9, 'Roark', 'Michael', 'Trainee Associate', 1, to_timestamp('1992-09-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2019-01-07 0:00:00', 'YYYY-MM-DD HH24:MI:SS'), '4144 Prestwick Sq.', 'New Albany', 'IN', 'USA', '47150', '+1(812)406-3333', null, 'michaelrroark@gmail.com');
insert into employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
values (10, 'Roark', 'Michael', 'Trainee Associate', 1, to_timestamp('1992-09-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2019-01-07 0:00:00', 'YYYY-MM-DD HH24:MI:SS'), '4144 Prestwick Sq.', 'New Albany', 'IN', 'USA', '47150', '+1(812)406-3333', null, 'michaelrroark@gmail.com');

insert into customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
values (60, 'Mike', 'Roark', 'Revature', '4144 Prestwick Sq.', 'New albany', 'IN', 'USA', '47172', '1(812)406-3333', null, 'lightreborn@live.com', 9);
insert into customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
values (61, 'Mike', 'Roark', 'Revature', '4144 Prestwick Sq.', 'New albany', 'IN', 'USA', '47172', '1(812)406-3333', null, 'lightreborn@live.com', 10);

--2.4
update customer
set firstname = 'Robert', lastname = 'Walter'
where firstname = 'Aaron' and lastname = 'Mitchell';

update artist
set "name" = 'CCR'
where "name" = 'Creedence Clearwater Revival';

--2.5
select * from invoice where billingaddress like 'T%';

--2.6
select * from invoice where total between 15 and 50;
select * from employee where hiredate between to_timestamp('2003-06-1 00:00:00', 'YYY-MM-DD HH24:MI:SS') and to_timestamp('2004-03-1 00:00:00', 'YYY-MM-DD HH24:MI:SS')

--2.7
delete from invoiceline where invoiceid in (select invoiceid from invoice where customerid = (select customerid from customer where firstname = 'Robert' and lastname = 'Walter'));
delete from invoice where customerid = (select customerid from customer where firstname = 'Robert' and lastname = 'Walter');
delete from customer where firstname = 'Robert' and lastname = 'Walter';

--Section 3
--3.1
create or replace function getTime()
returns text as $$
declare 
	thetime timestamp;
	formattedtime text;
begin
	thetime = clock_timestamp();
	formattedtime = extract(hour from thetime) || ':' || extract(minute from thetime);
	return formattedtime;
end;
$$ language plpgsql;

select getTime();

create or replace function getmedialenth(id numeric)
returns numeric as $$
declare
	item text;
	curs refcursor;
begin
	open curs for select "name" from mediatype where mediatypeid = id;
	fetch curs into item;
	return length(item);
end;
$$ language plpgsql;

select getmedialenth(1);

--3.2
create or replace function averageinvoicetotal()
returns numeric as $$
declare
	average numeric;
	counter numeric;
	accumulator numeric;
begin
	select sum(total) from invoice into accumulator;
	select count(*) from invoice into counter;
	average = accumulator / counter;
	return average;
end;
$$ language plpgsql;

select averageinvoicetotal();

create or replace function mostexpensivetrack()
returns numeric as $$
declare
	maxprice numeric;
begin
	select max(unitprice) from track into maxprice;
	return maxprice;
end
$$ language plpgsql;

select mostexpensivetrack();

--3.3
create or replace function averageinvoicelinecost()
returns numeric as $$
declare
	average numeric;
	counter numeric;
	accumulator numeric;
begin
	select sum(unitprice) from invoiceline into accumulator;
	select count(*) from invoiceline into counter;
	average = accumulator / counter;
	return average;
end;
$$ language plpgsql;

select averageinvoicelinecost();

--3.4
create or replace function getemployeesafter1968()
returns table (
	employeeid	int4,
	lastname	varchar(20), 
	firstname	varchar(20), 
	title		varchar(30), 
	reportsto	int4, 
	birthdayt	timestamp, 
	hiredate	timestamp, 
	address		varchar(70), 
	city		varchar(40), 
	state		varchar(40), 
	country		varchar(40), 
	postalcode	varchar(10), 
	phone		varchar(24), 
	fax			varchar(24), 
	email		varchar(60))
as $$
begin
	return query select * from employee where birthdate::date > date '1968-01-01'; 
end
$$ language plpgsql;

select getemployeesafter1968();

--Section 4
--4.1
create or replace function getemployeenames()
returns table (
	fname varchar(20),
	lname varchar(20)
)
as $$
begin
	return query select firstname, lastname from employee;
end
$$ language plpgsql;

select getemployeenames();

--4.2
--updateemployee(, , , , , , , , , , , , , , ) 
create or replace function updateemployee(
	empid			integer,	--integer
	newlastname		text, 		--unknown
	newfirstname	text, 		--unknown
	newtitle		text, 		--unknown
	newreportsto	integer, 	--integer
	newbirthdate	timestamp, 	--timestamp with time zone
	newhiredate		timestamp, 	--timestamp with time zone
	newaddress		text, 		--unknown
	newcity			text, 		--unknown
	newstate		text, 		--unknown
	newcountry		text, 		--unknown
	newpostalcode	text, 		--unknown
	newphone		text, 		--unknown
	newfax			text, 		--unknown	
	newemail		text		--unknown
)
returns void as $$
begin
	update employee
	set 
		lastname = newlastname,
		firstname = newfirstname,
		title = newtitle,
		reportsto = newreportsto,
		birthdate = newbirthdate,
		hiredate = newhiredate,
		address = newaddress,
		city = newcity,
		state = newstate,
		country = newcountry,
		postalcode = newpostalcode,
		phone = newphone,
		fax = newfax,
		email =newemail
	where employeeid = empid;
end
$$ language plpgsql;

select * from employee;
select updateemployee(10, 'Roark'::text, 'Ryan'::text, 'Trainee Associate'::text, 1, to_timestamp('1992-09-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS')::timestamp without time zone, to_timestamp('2019-01-07 0:00:00', 'YYYY-MM-DD HH24:MI:SS')::timestamp without time zone, '4144 Prestwick Sq.'::text, 'New Albany'::text, 'IN'::text, 'USA'::text, '47150'::text, '+1(812)406-3333'::text, null, 'michaelrroark@gmail.com'::text);

create or replace function getemployeemanager(id numeric)
returns text as $$
declare 
	rec record;
	outbound text;
begin
	select * into rec from employee where employeeid = (select reportsto from employee where employeeid = id);
	outbound = rec.firstname || ' ' ||rec.lastname;
	return outbound;
end
$$ language plpgsql;

select getemployeemanager(10);

--4.3
create or replace function getcustomernameandcompany(id numeric)
returns text as $$
declare
	rec record;
	customername text;
	workplace text;
begin
	select * into rec from customer where customerid = id;
	customername = rec.firstname || ' ' || rec.lastname;
	workplace = rec.company;
	return customername || ' ' || workplace;
end
$$ language plpgsql;

select getcustomernameandcompany(10);

--Section 5
--5.0
create or replace function deleteinvoice(id numeric)
returns void as $$
begin
	delete from invoiceline where invoiceid = id;
	delete from invoice where invoiceid = id;
end
$$ language plpgsql;

select deleteinvoice(1);

create or replace function insertnewcustomer()
returns void as $$
begin
	insert into customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
	values (62, 'Mike', 'Roark', 'Revature', '4144 Prestwick Sq.', 'New albany', 'IN', 'USA', '47172', '1(812)406-3333', null, 'lightreborn@live.com', 10);
end
$$ language plpgsql;	


create or replace function performinsertnewcustomer()
returns void as $$
begin
	perform insertnewcustomer();
end
$$ language plpgsql;

select performinsertnewcustomer();
select * from customer;

--Section 6
--6.1
create or replace function insertalert()
returns trigger as $$
begin
	RAISE NOTICE 'INSERT COMMAND EXECUTED!';
	return null;
end
$$ language plpgsql;

create trigger emp_insert_alert after insert on employee for each row
	execute procedure insertalert();

create or replace function updatealert()
returns trigger as $$
begin
	RAISE NOTICE 'UPDATE COMMAND EXECUTED!';
	return null;
end
$$ language plpgsql;

create trigger album_update_alert after update on album for each row
	execute procedure updatealert();

create or replace function deletealert()
returns trigger as $$
begin
	RAISE NOTICE 'DELETE COMMAND EXECUTED!';
	return null;
end
$$ language plpgsql;

create trigger customer_delete_alert after delete on customer for each row
	execute procedure deletealert();

--Section 7
--7.1
select customer.firstname, customer.lastname, invoice.invoiceid
from invoice
inner join customer on invoice.customerid = customer.customerid;

--7.2
select customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total
from customer
full join invoice on invoice.customerid = customer.customerid;

--7.3
select artist."name", album.title
from artist
right join album on album.artistid = artist.artistid;

--7.4
select *
from album
cross join artist order by artist."name" asc;

--7.5
select nonmanageremployee.firstname, nonmanageremployee.lastname, manageremployee.firstname, manageremployee.lastname
from employee as nonmanageremployee
join employee as manageremployee on nonmanageremployee.reportsto = manageremployee.employeeid;


--EOF
