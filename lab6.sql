SELECT productname, unitprice

,( SELECT AVG(unitprice) FROM products) AS average,

unitprice - ( SELECT AVG(unitprice) FROM products) as diff

FROM products



select *, unitprice - average as diff from

(SELECT productname, unitprice

,( SELECT AVG(unitprice) FROM products) AS average

FROM products) tmp
WHERE UnitPrice > average

SELECT productname, unitprice, CategoryID

,( SELECT AVG(unitprice)

FROM products as p_wew

WHERE p_zew.categoryid = p_wew.categoryid ) AS average,

unitprice - ( SELECT AVG(unitprice)

FROM products as p_wew

WHERE p_zew.categoryid = p_wew.categoryid ) as diff

FROM products as p_zew

where unitprice > ( SELECT AVG(unitprice)

FROM products as p_wew

WHERE p_zew.categoryid = p_wew.categoryid )



SELECT productname, unitprice

,( SELECT AVG(unitprice) FROM products) AS average,

unitprice - ( SELECT AVG(unitprice) FROM products) as diff

FROM products

where UnitPrice > ( SELECT AVG(unitprice) FROM products)


select *, unitprice - average from

(SELECT productname, unitprice, CategoryID

,( SELECT AVG(unitprice)

FROM products as p_wew

WHERE p_zew.categoryid = p_wew.categoryid ) AS average

FROM products as p_zew) tmp

where UnitPrice > average

select productname, unitprice, p.CategoryID, average, UnitPrice - average diff

from products p join

(select CategoryID, avg(unitprice) as average

from Products

group by CategoryID) av on p.CategoryID = av.CategoryID

where UnitPrice > average

-- nowy  keyword
select productname, unitprice, p.CategoryID, average, UnitPrice - average diff

from products p join

(select CategoryID, avg(unitprice) as average

from Products

group by CategoryID) av on p.CategoryID = av.CategoryID

where UnitPrice > average



with av as

(select CategoryID, avg(unitprice) as average

from Products

group by CategoryID)



select productname, unitprice, p.CategoryID, average, UnitPrice - average diff

from Products p join av on av.CategoryID = p.CategoryID

where UnitPrice > average





SELECT lastname, employeeid

FROM employees AS e

WHERE not EXISTS (SELECT * FROM orders AS o

WHERE e.employeeid = o.employeeid

AND o.orderdate = '9/5/97')





-- Zadania do zrobienia:
-- 1. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma United Package.
-- a)
select distinct CompanyName, Phone from Orders

join Customers on Orders.CustomerID = Customers.CustomerID

where year(ShippedDate) = 1997 and ShipVia = (select ShipperID from Shippers where CompanyName = 'United Package')
-- b)
select distinct CompanyName, Phone
from Customers
where CustomerID in (   select Orders.CustomerID
                        from Orders join Shippers S
                        on Orders.ShipVia = S.ShipperID and
                           S.CompanyName = 'United Package'
                        where year(ShippedDate) = '1997')

-- 2. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- Confections.

SELECT distinct C.CompanyName,C.Phone
FROM Customers C
JOIN Orders O on C.CustomerID = O.CustomerID
JOIN [Order Details] [O D] on O.OrderID = [O D].OrderID
JOIN Products P on P.ProductID = [O D].ProductID
JOIN Categories C2 on C2.CategoryID = P.CategoryID
and CategoryName = 'Confections'

--2.1 Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections.
select c.CompanyName, c.Phone
from Customers c
where c.CustomerID not in (select distinct o.customerid
from Orders o join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
join Categories cat on p.CategoryID = cat.CategoryID
where cat.CategoryName = 'Confections')
