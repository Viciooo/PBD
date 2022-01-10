--zadanie 2
-- 2)Czy są jacyś klienci, którzy nie złożyli żadnego zamówienia w 1997 roku? Jeśli tak, wyświetl ich dane adresowe. Wykonaj za pomocą operatorów:
-- a)join b)in c)exist

-- using not in
select c1.CompanyName
from Customers c1
where c1.CustomerID not in (select C.CustomerID
from Customers C
join Orders O on C.CustomerID = O.CustomerID
where year(o.OrderDate) = 1997)

-- using exist
select c1.CompanyName
from Customers c1
where not exists (select C.CustomerID
from Customers C
join Orders O on C.CustomerID = O.CustomerID
where year(o.OrderDate) = 1997 and c1.CustomerID = C.CustomerID)

-- using join
SELECT c.CompanyName, c.Address, c.City, c.PostalCode, c.Country
	FROM Customers as c LEFT JOIN Orders as o ON c.CustomerID = o.CustomerID AND YEAR(o.OrderDate)='1997'
	WHERE o.OrderDate IS NULL

-- Podaj listę członków biblioteki (imię, nazwisko) mieszkających w Arizonie (AZ), którzy mają
-- więcej niż dwoje dzieci zapisanych do biblioteki oraz takich, którzy mieszkają w Kalifornii (CA)
-- i mają więcej niż troje dzieci zapisanych do bibliotek. Dla każdej z tych osób podaj liczbę książek
-- przeczytanych (oddanych) przez daną osobę i jej dzieci w grudniu 2001 (użyj operatora union).



--1)
-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki. Interesuje nas imię, nazwisko,
-- data urodzenia dziecka, adres zamieszkania, imię i nazwisko rodzica oraz liczba aktualnie wypożyczonych książek.



--2)
-- Dla każdego pracownika (imie i nazwisko) podaj łączną wartość zamówień obsłużonych
-- przez tego pracownika (z ceną za przesyłkę). * Uwzględnij tylko pracowników, którzy nie mają podwładnych.


--3)
-- Czy są jacyś klienci, którzy nie złożyli żadnego zamówienia w 1997, jeśli tak pokaż
-- ich nazwy i dane adresowe (3 wersje - join, in, exists).

--4)
-- Podaj listę człownków biblioteki (imię, nazwisko) mieszkających w Arizonie (AZ), którzy mają
-- więcej niż dwoje dzieci zapisanych do biblioteki oraz takich, którzy mieszkają w Kalifornii (CA)
-- i mają więcej niż troje dzieci zapisanych do bibliotek. Dla każdej z tych osób podaj liczbę książek
-- przeczytanych (oddanych) przez daną osobę i jej dzieci w grudniu 2001 (bez użycia union).


-- GRUPA C


--1
Use Northwind
select ProductName, (select CategoryName from Categories as c where p.CategoryID=c.CategoryID ) as Category,unitprice,
(select avg(unitprice) from Products as P2 where P2.CategoryID=p.CategoryID) as Average,
UnitPrice-(select avg(unitprice) from Products as P2 where P2.CategoryID=p.CategoryID) as DIFF,
(Select sum(UnitPrice*quantity*(1-discount))
from [Order Details] as od
where od.ProductID=p.ProductID and od.orderid in
(select orderid from orders as o where MONTH(o.OrderDate)=3 and YEAR(o.OrderDate)=1997)) as March97
from Products as p

--2
Use Library
Select m.firstname,m.lastname,j.birth_date,am.firstname,am.lastname,a.state+' '+a.City+' '+a.street+' '+a.zip
from member as m
inner join juvenile as j
on j.member_no=m.member_no
inner join adult as a
on a.member_no=j.adult_member_no
inner join member as am
on am.member_no=a.member_no


--3 Użyte zostało in_date jako przeczytana książka
--a
Use Library
select firstname, lastname,(select count(*) from loanhist as l where l.member_no=m.member_no and MONTH(in_date)=12 and YEAR(in_date)=2001)+
 (select count(*) from loanhist as l
 inner join juvenile as j
 on j.adult_member_no=m.member_no
 where l.member_no=j.member_no and MONTH(in_date)=12 and YEAR(in_date)=2001) as bookread
from member as m
where 2<(select count(*)  from Juvenile as j where j.adult_member_no=m.member_no) and
 m.member_no in (select member_no from adult as a where state = 'AZ' )
 union
 select firstname, lastname,(select count(*) from loanhist as l where l.member_no=m.member_no and MONTH(due_date)=12 and YEAR(due_date)=2001)+
 (select count(*) from loanhist as l
 inner join juvenile as j
 on j.adult_member_no=m.member_no
 where l.member_no=j.member_no and MONTH(in_date)=12 and YEAR(in_date)=2001) as bookread
from member as m
where 3<(select count(*)  from Juvenile as j where j.adult_member_no=m.member_no) and
 m.member_no in (select member_no from adult as a where state = 'CA' )

--b

select firstname, lastname,(select count(*) from loanhist as l where l.member_no=m.member_no and MONTH(in_date)=12 and YEAR(in_date)=2001)+
 (select count(*) from loanhist as l
 inner join juvenile as j
 on j.adult_member_no=m.member_no
 where l.member_no=j.member_no and MONTH(in_date)=12 and YEAR(in_date)=2001) as bookread
from member as m
where (2<(select count(*)  from Juvenile as j where j.adult_member_no=m.member_no) and
 m.member_no in (select member_no from adult as a where state = 'AZ' )) or
 (3<(select count(*)  from Juvenile as j where j.adult_member_no=m.member_no) and
 m.member_no in (select member_no from adult as a where state = 'CA' ) )

--4
Use Northwind
select O.orderid, (select CompanyName from Customers as C where C.CustomerID=O.CustomerID) as Company,
(select Firstname+' '+lastname from Employees as E where E.Employeeid=O.Employeeid) as name,
(select sum(UnitPrice*quantity*(1-discount)) from [Order Details] as od where od.OrderID=O.OrderID)+O.Freight as Value
from Orders as O
