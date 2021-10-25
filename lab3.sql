

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
