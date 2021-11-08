-- Przykład 1
USE joindb
SELECT buyer_name, Sales.buyer_id, qty
FROM Buyers,Sales
WHERE Buyers.buyer_id = Sales.buyer_id
GO

-- Przykład 2 z aliasami
USE joindb
SELECT buyer_name, s.buyer_id, qty
FROM Buyers AS b,Sales AS s
WHERE b.buyer_id = s.buyer_id
GO

-- Użycie aliasów dla nazw tabeli

USE joindb
SELECT buyer_name,S.buyer_id,qty
FROM Buyers INNER JOIN Sales S
    ON Buyers.buyer_id = S.buyer_id
GO

-- Pzykład
USE Northwind
SELECT ProductName,CompanyName
FROM Products
INNER JOIN Suppliers S
    ON Products.SupplierID = S.SupplierID

-- Przykład
SELECT DISTINCT CompanyName, OrderDate
FROM Orders
INNER JOIN Customers C
    ON Orders.CustomerID = C.CustomerID
WHERE OrderDate > '3/1/98'

-- Przykład
SELECT CompanyName,OrderDate
FROM Customers
LEFT OUTER JOIN Orders
    ON Customers.customerid = orders.customerid

--------------------------------------------------------------------------------------------------------------------------------
-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
USE Northwind
SELECT ProductName,UnitPrice
FROM Products P INNER JOIN Suppliers S
    ON P.SupplierID = S.SupplierID
WHERE UnitPrice BETWEEN 20 AND 30

-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
-- dostarczanych przez firmę ‘Tokyo Traders’
SELECT ProductName,UnitsInStock
FROM Products P INNER JOIN Suppliers S
    ON P.SupplierID = S.SupplierID
WHERE CompanyName = 'Tokyo Traders'

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe

SELECT DISTINCT CompanyName,Address
FROM Customers C
LEFT OUTER JOIN Orders O
    ON C.CustomerID = O.CustomerID
    AND YEAR(OrderDate) = 1997
WHERE OrderDate IS NULL

-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty,
-- których aktualnie nie ma w magazynie
USE Northwind
SELECT CompanyName,Phone
    FROM Suppliers S INNER JOIN Products P
        ON S.SupplierID = P.SupplierID
WHERE UnitsInStock = 0

-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
USE library
SELECT lastname,firstname,birth_date
FROM member m INNER JOIN juvenile j
    ON m.member_no = j.member_no

-- 2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
USE library
SELECT DISTINCT title
FROM title t INNER JOIN copy c
    ON t.title_no = c.title_no
WHERE on_loan = 'Y'
-- 3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao
-- Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką
-- zapłacono karę

-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych
-- przez osobę o nazwisku: Stephen A. Graff

