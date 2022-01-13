-- Gliwa kolokwium z SQL 2015/2016 (30min (?))

-- GR.1

-- 1. Podać ID klienta, który złożył co najmniej jedno zamówienie w 1997 i nie złożył żadnego zamówienia
-- w 1996. Podać tylko tych klientów których ID zaczyna się na literę L. Bez podzapytań. Do każdego ID
-- dodatkowo podać nazwę firmy.
use Northwind
;
with not_a_client_in_1996 as (
    select CustomerID, OrderDate
    from Orders
    where year(OrderDate) != 1996
),
     proper_client as (
         select distinct CustomerID
         from not_a_client_in_1996
         where year(OrderDate) = 1997
     )
select C.CustomerID, CompanyName
from proper_client pc
         join Customers C on C.CustomerID = pc.CustomerID
where left(PC.CustomerID, 1) = 'L'

-- 2. Wypisać zamówienia, których koszt jest mniejszy niż połowa maksymalnej ceny jednostkowej
-- produktów z kategorii "Seafood". Do każdego zamówienia podać ten koszt.
select DISTINCT O2.OrderID, [O D].UnitPrice
from Orders O2
         join [Order Details] [O D] on O2.OrderID = [O D].OrderID
where [O D].UnitPrice < (select max(O.UnitPrice / 2)
                         from [Order Details] O
                                  join Products P on O.ProductID = P.ProductID
                                  join Categories C on C.CategoryID = P.CategoryID
                         where C.CategoryName = 'Seafood')


-- 3. Podać imię i nazwisko (razem) pracowników, którzy mają podwładnych. Bez join'ów.

select distinct concat(e.FirstName, ' ', e.LastName) as name
from Employees e
where e.EmployeeID in (select e1.ReportsTo
                       from Employees e1)


-- 4. Podać imię i nazwisko (w jednej kolumnie) pracownika, który obsłużył zamówienie o największej
-- wartości w 1998 roku. Należy także podać wartość tego zamówienia.

;with tmp as (
    select E.EmployeeID,sum(od.Quantity*od.UnitPrice*(1-od.Discount))+o.Freight as sum
    from Orders O
    join [Order Details] od on O.OrderID = od.OrderID
    join Employees E on O.EmployeeID = E.EmployeeID
    group by E.EmployeeID,o.Freight
), money_per_employee as (
    select t.EmployeeID,sum(t.sum) as money_earned
    from tmp t
    group by t.EmployeeID
)
select top 1 concat(e.FirstName,' ',e.LastName) as name,mpe.money_earned
from Employees e
join money_per_employee mpe on e.EmployeeID = mpe.EmployeeID
order by mpe.money_earned desc

-- ####################################################################################################################

-- GR.2

-- 1. Wyświetl CustomerID klientów, którzy mają więcej niż 25 zamówień. Użyj podzapytań.
select distinct CustomerID
from Orders o
where (select count(*) from Orders o1 where o1.CustomerID = o.CustomerID) > 25

-- 2. Podaj OrderID i cenę przesyłki, dla tego zamówienia, którego cena przesyłki jest większa niż średnia
-- opłata za wszystkie przesyłki i była wysłana do Londynu.

select OrderID
from Orders
where ShipCity = 'London' and Freight > (
    select sum(Freight)/count(Freight)
    from Orders
)

-- 3. Wypisz CustomerID klientów, którzy nie zamówili nic w 1997 roku oraz ich CustomerID nie kończy się
-- na A oraz C. Użyj mechanizmu podzapytań.

;with not_ordered_in_1997 as (
    select CustomerID
    from Orders
    where CustomerID not in (
    select CustomerID
    from Orders
    where year(OrderDate) = 1997
)
)


select distinct n.CustomerID
from Orders o
join not_ordered_in_1997 n on n.CustomerID = o.CustomerID
where right(n.CustomerID,1) != 'A' AND right(n.CustomerID,1) != 'C'

-- 4. Podaj imię i nazwisko (w jednej kolumnie) pracowników, którzy mają więcej niż 3 podwładnych. Nie
-- używaj mechanizmu podzapytań.

;with amount_of_leaves_under_him as (
    select e.EmployeeID,count(*) as amt_of_sub_employees
    from Employees e
    join Employees e1 on e.EmployeeID = e1.ReportsTo
    group by e.EmployeeID
)
select concat(e.FirstName,' ',e.LastName) as name
from Employees e
join amount_of_leaves_under_him a on a.EmployeeID = e.EmployeeID
where a.amt_of_sub_employees > 3
