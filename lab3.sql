

-- 1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż
-- 20$
USE Northwind
SELECT COUNT(*)
FROM Products
WHERE UnitPrice BETWEEN 10 AND 20

-- 2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
USE Northwind
-- TOP 1 jest niezgodny ze standardem, więc powinien być stosowany wyjątkowo.
SELECT MAX(UnitPrice)
FROM [Order Details]
WHERE UnitPrice < 20

-- 3.Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o
-- produktach sprzedawanych w butelkach (‘bottle’)
USE Northwind
SELECT MIN(UnitPrice),AVG(UnitPrice),MAX(UnitPrice)
FROM Products
WHERE QuantityPerUnit LIKE '%bottle%'

-- 4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
SELECT *
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)

-- 5. Podaj sumę/wartość zamówienia o numerze 10250
SELECT SUM(UnitPrice*Quantity*(1-Discount))
FROM [order details]
WHERE OrderId = 10250

-- #######################################################################################################################################################################

USE Northwind
SELECT *
FROM orderhist

USE Northwind
SELECT ProductID,SUM(Quantity),AVG(Quantity)
FROM [Order Details]
WHERE productid < 2
GROUP BY ProductID

-- 1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, MAX(UnitPrice) as "MAX"
from [Order Details]
group by OrderID

-- 2. Posortuj zamówienia wg maksymalnej ceny produktu
select OrderID, MAX(UnitPrice) as 'Max'
from [Order Details]
group by OrderID
order by 2 desc

-- 3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, MAX(UnitPrice) as "MAX", MIN(UnitPrice) as "MIN"
from [Order Details]
group by OrderID

-- 4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów
-- (przewoźników).
SELECT COUNT(*) as Counter, ShipVia, (SELECT CompanyName FROM Shippers WHERE ShipperID = ShipVia) AS ShipperName
FROM Orders
GROUP BY ShipVia

-- 5. Który z spedytorów był najaktywniejszy w 1997 roku.
SELECT TOP 1 COUNT(*) as Counter, ShipVia, (SELECT CompanyName FROM Shippers WHERE ShipperID = ShipVia) AS ShipperName
FROM Orders
WHERE YEAR(ShippedDate) = 1997
GROUP BY ShipVia
ORDER BY Counter DESC

-- 6 Który z spedytorów zarobił najwięcej w 1997 roku.
SELECT TOP 1 SUM(Freight) as value, ShipVia
FROM Orders
WHERE YEAR(ShippedDate) = 1997
GROUP BY ShipVia
ORDER BY value DESC
-- ################################

USE Northwind
SELECT ProductID,SUM(Quantity) AS total_quantity
FROM orderhist
GROUP BY ProductID
HAVING SUM(quantity) >= 30

-- 1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
select orderID, count(ProductID) as Count
from [Order Details]
group by orderID
having count(ProductID) > 5

-- 2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
-- (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
select CustomerID, count(OrderID), sum(Freight)
from Orders
where year(OrderDate) = 1998
group by CustomerID
having count(OrderID) > 8
order by sum(Freight) desc

-- #############

-- 1.Ile lat przepracował w firmie każdy z pracowników?
SELECT FirstName,LastName,DATEDIFF(YEAR ,HireDate,GETDATE()) AS working_time
FROM Employees

-- 2.Policz sumę lat przepracowanych przez wszystkich pracowników i średni czas pracy w firmie
SELECT SUM(DATEDIFF(YEAR ,HireDate,GETDATE())) AS date_sum ,AVG(DATEDIFF(YEAR ,HireDate,GETDATE())) AS date_avg
FROM Employees

-- 3.Dla każdego pracownika wyświetl imię, nazwisko oraz wiek
SELECT FirstName,LastName,DATEDIFF(YEAR ,BirthDate,GETDATE()) AS age
FROM Employees

-- 4.Policz średni wiek wszystkich pracowników
SELECT AVG(DATEDIFF(YEAR ,BirthDate,GETDATE())) AS avg_age
FROM Employees
-- 5.Wyświetl wszystkich pracowników, którzy mają teraz więcej niż 25 lat.
SELECT FirstName,LastName,DATEDIFF(YEAR ,BirthDate,GETDATE()) AS age
FROM Employees
WHERE DATEDIFF(YEAR ,BirthDate,GETDATE()) > 55

-- TODO

-- 6.Policz średnią liczbę miesięcy przepracowanych przez każdego pracownika
-- 7.Wyświetl dane wszystkich pracowników, którzy przepracowali w firmie co najmniej 320 miesięcy, ale nie więcej niż 333


