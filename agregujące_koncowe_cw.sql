-- 1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia
-- w tablicy order details i zwraca wynik posortowany w malejącej kolejności
-- (wg wartości sprzedaży).
USE Northwind
SELECT SUM(UnitPrice * Quantity * (1 - Discount)) AS "val", OrderID
FROM [Order Details]
GROUP BY OrderID
ORDER BY 1 DESC

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych
-- 10 wierszy

USE Northwind
SELECT TOP 10 SUM(UnitPrice * Quantity * (1 - Discount)) AS "val", OrderID
FROM [Order Details]
GROUP BY OrderID
ORDER BY 1 DESC

-- 3. Zmodyfikuj zapytanie z punktu 2., tak aby zwracało 10 pierwszych
-- produktów wliczając równorzędne. Porównaj wyniki.

USE Northwind
SELECT TOP 10 WITH TIES SUM(UnitPrice * Quantity * (1 - Discount)) AS "val", OrderID
FROM [Order Details]
GROUP BY OrderID
ORDER BY 1 DESC

-- 1. Podaj liczbę zamówionych jednostek produktów dla produktów o
-- identyfikatorze < 3
USE Northwind
SELECT SUM(Quantity) AS "WYNIK"
FROM [Order Details]
WHERE [Order Details].ProductID < 3


-- 2. Zmodyfikuj zapytanie z punktu 1. tak aby podawało liczbę
-- zamówionych jednostek produktu dla wszystkich produktów
USE Northwind
SELECT SUM(Quantity) AS "WYNIK", ProductID
FROM [Order Details]
WHERE [Order Details].ProductID < 3
GROUP BY ProductID


-- 3. Podaj KOSZT dla każdego zamówienia, dla którego
-- łączna liczba zamawianych jednostek produktów jest > 250
USE Northwind
SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) AS "wynik"
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(Quantity) > 250

-- 1. Napisz polecenie, które oblicza sumaryczną liczbę zamówionych
-- towarów i porządkuje wg productid i orderid oraz wykonuje
-- kalkulacje rollup.

SELECT ProductID, OrderID, SUM(Quantity)
FROM [Order Details]
GROUP BY ProductID, OrderID
WITH ROLLUP

-- 2. Zmodyfikuj zapytanie z punktu 1., tak aby ograniczyć wynik tylko do
-- produktu o numerze 50.

SELECT ProductID, OrderID, SUM(Quantity)
FROM [Order Details]
WHERE ProductID = 50
GROUP BY ProductID, OrderID
WITH ROLLUP

-- 3. Jakie jest znaczenie wartości null w kolumnie productid i orderid?

-- -> Oznacza to, że dla wszystkich ProductID i dla wszystkich OrderID dany jest wynik

-- 4. Zmodyfikuj polecenie z punktu 1. używając operator cube zamiast
-- rollup. Użyj również funkcji GROUPING na kolumnach productid i
-- orderid do rozróżnienia między sumarycznymi i szczegółowymi
-- wierszami w zbiorze

SELECT GROUPING(ProductID)AS "groupProductID",ProductID, GROUPING(OrderID)AS "groupProductID",OrderID, SUM(Quantity)
FROM [Order Details]
GROUP BY ProductID, OrderID
WITH CUBE

-- 5. Które wiersze są podsumowaniami?
--  -> TO JEST TEN GROUPING te w których jest 1 no bo jest NULL

-- Które podsumowują według produktu, a które według zamówienia?

-- no grouping(ProductId) po produkt id itd XD co za pytanie
