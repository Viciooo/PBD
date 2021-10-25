

-- 1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż
-- 20$
USE Northwind
SELECT COUNT(*)
FROM Products
WHERE UnitPrice BETWEEN 10 AND 20

-- 2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
USE Northwind
SELECT TOP 1 UnitPrice,ProductID
FROM [Order Details]
WHERE UnitPrice < 20
ORDER BY UnitPrice DESC

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
