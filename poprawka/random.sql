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

-- Podaj listę członków biblioteki (imię, nazwisko) mieszkających w Arizonie (AZ), którzy mają
-- więcej niż dwoje dzieci zapisanych do biblioteki oraz takich, którzy mieszkają w Kalifornii (CA)
-- i mają więcej niż troje dzieci zapisanych do bibliotek. Dla każdej z tych osób podaj liczbę książek
-- przeczytanych (oddanych) przez daną osobę i jej dzieci w grudniu 2001 (użyj operatora union).
use library
;
with parents_kid_amount as (
    select a2.member_no, count(*) as kids_amount
    from adult a2
             join juvenile j on a2.member_no = j.adult_member_no
    group by a2.member_no
)
        ,
     parents_from_AZ as (
         select a.member_no, m.firstname, m.lastname
         from adult a
                  join member m on m.member_no = a.member_no
                  join parents_kid_amount pka on a.member_no = pka.member_no
         where pka.kids_amount > 2
           and a.state = 'AZ'
     ),
     parents_from_CA as (
         select a.member_no, m.firstname, m.lastname
         from adult a
                  join member m on m.member_no = a.member_no
                  join parents_kid_amount pka on a.member_no = pka.member_no
         where pka.kids_amount > 3
           and a.state = 'CA'),
     amount_of_child_books as (
         select a3.member_no, count(*) as cnt
         from adult a3
                  join juvenile j2 on a3.member_no = j2.adult_member_no
                  join loanhist l on j2.member_no = l.member_no
         where year(l.in_date) = 2001
           and month(l.in_date) = 12
         group by a3.member_no
     ),
     amount_of_books_per_adult as (
         select a4.member_no, count(*) cnt
         from adult a4
                  join loanhist l2 on a4.member_no = l2.member_no
         where year(l2.in_date) = 2001
           and month(l2.in_date) = 12
         group by a4.member_no
     )
    (select pfA.*, isnull(aobpa.cnt, 0) + isnull(aocb.cnt, 0) amt_of_books
     from parents_from_AZ pfA
              left join amount_of_books_per_adult aobpa on pfA.member_no = aobpa.member_no
              left join amount_of_child_books aocb on pfA.member_no = aocb.member_no)
union
(
    select pfC.*, isnull(aobpa.cnt, 0) + isnull(aocb.cnt, 0) amt_of_books
    from parents_from_CA pfC
             left join amount_of_books_per_adult aobpa on pfC.member_no = aobpa.member_no
             left join amount_of_child_books aocb on pfC.member_no = aocb.member_no
)

--1)
-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki. Interesuje nas imię, nazwisko,
-- data urodzenia dziecka, adres zamieszkania, imię i nazwisko rodzica oraz liczba aktualnie wypożyczonych książek.

;
with amt_of_books as (
    select j2.member_no, count(*) as amtOfBooks
    from juvenile j2
             join loanhist l on j2.member_no = l.member_no
    group by j2.member_no
)

select m.member_no               as childID,
       m.firstname               as childName,
       m.lastname                as childSurname,
       j.birth_date,
       m1.firstname              as parentName,
       m1.lastname               as parentSurname,
       a.state,
       a.street,
       a.city,
       a.zip,
       isnull(aob.amtOfBooks, 0) as amtOfBooks
from juvenile j
         join adult a on j.adult_member_no = a.member_no
         join member m on m.member_no = j.member_no
         join member m1 on a.member_no = m1.member_no
         left join amt_of_books aob on j.member_no = aob.member_no

--2)
-- Dla każdego pracownika (imie i nazwisko) podaj łączną wartość zamówień obsłużonych
-- przez tego pracownika (z ceną za przesyłkę). * Uwzględnij tylko pracowników, którzy nie mają podwładnych.

use Northwind
;
with employee_leaf as (
    select e.EmployeeID, e.FirstName, e.LastName
    from Employees e
             left join Employees e1 on e1.ReportsTo = e.EmployeeID
    where e1.EmployeeID is null
),
     employee_boss as (
         select e.EmployeeID
         from Employees e
                  left join Employees e1 on e1.EmployeeID = e.ReportsTo
         where e1.EmployeeID is null
     ),
     money_from_orders as (
         select el.EmployeeID, sum([O D].Quantity * [O D].UnitPrice * (1 - [O D].Discount)) + o.Freight as sum
         from Orders o
                  join [Order Details] [O D] on o.OrderID = [O D].OrderID
                  join employee_leaf el on o.EmployeeID = el.EmployeeID
         GROUP BY el.EmployeeID,o.Freight
     )
select distinct el.FirstName, el.LastName,sum(mfo.sum) as money_generated
from employee_leaf el
join money_from_orders mfo on el.EmployeeID = mfo.EmployeeID
group by el.FirstName, el.LastName


--3)
-- Czy są jacyś klienci, którzy nie złożyli żadnego zamówienia w 1997, jeśli tak pokaż
-- ich nazwy i dane adresowe (3 wersje - join, in, exists).

-- było u zygmunt 2021-22

