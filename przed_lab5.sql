-- 3. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urodzone przed 1 stycznia 1996

SELECT a.street
FROM adult a JOIN juvenile j ON a.member_no = j.adult_member_no
WHERE j.birth_date > '1996-01-01'

-- 4. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich członków
-- biblioteki, którzy aktualnie nie przetrzymują książek.

SELECT a.street,a.member_no
FROM adult a JOIN juvenile j ON a.member_no = j.adult_member_no
LEFT OUTER JOIN loan L ON a.member_no = l.member_no
WHERE j.birth_date > '1996-01-01' AND l.member_no is null

-- 1. Napisz polecenie które zwraca imię i nazwisko (jako pojedynczą kolumnę –
-- name), oraz informacje o adresie: ulica, miasto, stan kod (jako pojedynczą
-- kolumnę – address) dla wszystkich dorosłych członków biblioteki

SELECT (m.firstname + ' ' + m.lastname) AS name, (a.street + ' '+a.city+' '+a.zip+' '+ a.state) AS address
FROM member m
JOIN adult a on a.member_no = m.member_no

-- 2. Napisz polecenie, które zwraca: isbn, copy_no, on_loan, title, translation, cover,
-- dla książek o isbn 1, 500 i 1000. Wynik posortuj wg ISBN

SELECT l.isbn,c.copy_no,c.on_loan,t.title,i.translation,i.cover
FROM loan l
JOIN copy c on l.isbn = c.isbn and l.copy_no = c.copy_no
JOIN title t on c.title_no = t.title_no
JOIN item i on c.isbn = i.isbn
WHERE l.isbn IN (1,500,1000)

-- 3. Napisz polecenie które zwraca o użytkownikach biblioteki o nr 250, 342, i 1675
-- (dla każdego użytkownika: nr, imię i nazwisko członka biblioteki), oraz informację
-- o zarezerwowanych książkach (isbn, data)

SELECT m.member_no,m.firstname,m.lastname,l.isbn,l.out_date,l.due_date
FROM member m
JOIN loan l on m.member_no = l.member_no
WHERE m.member_no IN (250,342,1675)

-- 4. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają więcej niż
-- dwoje dzieci zapisanych do biblioteki

SELECT m.firstname + ' ' + m.lastname, COUNT(a.member_no)
FROM member m
INNER JOIN adult a on m.member_no = a.member_no
INNER JOIN  juvenile j on a.member_no = j.adult_member_no
WHERE a.state = 'AZ'
GROUP BY  m.firstname, m.lastname, m.member_no
HAVING COUNT(a.member_no) > 2

-- 1. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej
-- niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni
-- (CA) i mają więcej niż troje dzieci zapisanych do biblioteki

SELECT m.firstname + ' ' + m.lastname, COUNT(a.member_no)
FROM member m
INNER JOIN adult a on m.member_no = a.member_no
INNER JOIN  juvenile j on a.member_no = j.adult_member_no
WHERE a.state = 'AZ'
GROUP BY  m.firstname, m.lastname, m.member_no
HAVING COUNT(a.member_no) > 2
UNION
SELECT m.firstname + ' ' + m.lastname, COUNT(a.member_no)
FROM member m
INNER JOIN adult a on m.member_no = a.member_no
INNER JOIN  juvenile j on a.member_no = j.adult_member_no
WHERE a.state = 'CA'
GROUP BY  m.firstname, m.lastname, m.member_no
HAVING COUNT(a.member_no) > 3

-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz
-- nazwę klienta.
USE Northwind
SELECT SUM(oD.quantity) AS QuantitySum,C.CompanyName
FROM [Order Details] oD join Orders O on O.OrderID = oD.OrderID
JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY C.CompanyName

-- 2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczbę zamówionych jednostek jest większa niż 250
USE Northwind
SELECT SUM(oD.quantity) AS QuantitySum,C.CompanyName
FROM [Order Details] oD
join Orders O on O.OrderID = oD.OrderID
JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY C.CompanyName
HAVING SUM(oD.quantity) > 250

-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
-- klienta.

USE Northwind
SELECT SUM(oD.quantity*oD.UnitPrice*(1 - oD.Discount)) AS Price,C.CompanyName
FROM [Order Details] oD
JOIN Orders O on O.OrderID = oD.OrderID
JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY C.CompanyName
-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250.
USE Northwind
SELECT SUM(oD.quantity*oD.UnitPrice*(1 - oD.Discount)) AS Price,C.CompanyName
FROM [Order Details] oD
JOIN Orders O on O.OrderID = oD.OrderID
JOIN Customers C on O.CustomerID = C.CustomerID
GROUP BY C.CompanyName
HAVING SUM(oD.quantity) > 250

-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko
-- pracownika obsługującego zamówienie

USE Northwind
SELECT SUM(oD.quantity*oD.UnitPrice*(1 - oD.Discount)) AS Price,C.CompanyName,E.LastName,E.FirstName
FROM [Order Details] oD
JOIN Orders O on O.OrderID = oD.OrderID
JOIN Customers C on O.CustomerID = C.CustomerID
JOIN Employees E on O.EmployeeID = E.EmployeeID
GROUP BY C.CompanyName,E.LastName,E.FirstName
HAVING SUM(oD.quantity) > 250

-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.
SELECT C.CategoryName, SUM(OD.Quantity)
FROM Categories C
JOIN Products P on C.CategoryID = P.CategoryID
JOIN [Order Details] OD on P.ProductID = OD.ProductID
GROUP BY C.CategoryName

-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez
-- klientów jednostek towarów z tek kategorii.
SELECT C.CategoryName, SUM(oD.quantity*OD.UnitPrice*(1 - OD.Discount))
FROM Categories C
JOIN Products P on C.CategoryID = P.CategoryID
JOIN [Order Details] OD on P.ProductID = OD.ProductID
GROUP BY C.CategoryName

-- 3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
SELECT C.CategoryName, SUM(oD.quantity*OD.UnitPrice*(1 - OD.Discount))
FROM Categories C
JOIN Products P on C.CategoryID = P.CategoryID
JOIN [Order Details] OD on P.ProductID = OD.ProductID
GROUP BY C.CategoryName
ORDER BY 2

-- b) łącznej liczby zamówionych przez klientów jednostek towarów.
SELECT C.CategoryName, SUM(oD.quantity*OD.UnitPrice*(1 - OD.Discount))
FROM Categories C
JOIN Products P on C.CategoryID = P.CategoryID
JOIN [Order Details] OD on P.ProductID = OD.ProductID
GROUP BY C.CategoryName
ORDER BY SUM(OD.Quantity)

-- 4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
SELECT O.OrderID, SUM(oD.quantity*OD.UnitPrice*(1 - OD.Discount)+O.Freight)
FROM [Order Details] OD
JOIN Orders O on O.OrderID = OD.OrderID
GROUP BY O.OrderID

-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
SELECT S.CompanyName,SUM([O D].Quantity)
FROM [Order Details] [O D]
JOIN Orders O on [O D].OrderID = O.OrderID
JOIN Shippers S on S.ShipperID = O.ShipVia
WHERE YEAR(O.ShippedDate) = 1997
GROUP BY S.CompanyName

-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę
-- zamówień) w 1997r, podaj nazwę tego przewoźnika
SELECT TOP 1 S.CompanyName,SUM([O D].Quantity)
FROM [Order Details] [O D]
JOIN Orders O on [O D].OrderID = O.OrderID
JOIN Shippers S on S.ShipperID = O.ShipVia
WHERE YEAR(O.ShippedDate) = 1997
GROUP BY S.CompanyName
ORDER BY SUM([O D].Quantity) DESC

-- 3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
SELECT E.LastName,E.FirstName,SUM([O D].quantity*[O D].UnitPrice*(1 - [O D].Discount))
FROM Orders O
JOIN [Order Details] [O D] on O.OrderID = [O D].OrderID
JOIN Employees E on E.EmployeeID = O.EmployeeID
GROUP BY E.LastName, E.FirstName
-- 4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
-- nazwisko takiego pracownika
SELECT TOP 1 E.LastName,E.FirstName,SUM([O D].quantity*[O D].UnitPrice*(1 - [O D].Discount))
FROM Orders O
JOIN [Order Details] [O D] on O.OrderID = [O D].OrderID
JOIN Employees E on E.EmployeeID = O.EmployeeID
GROUP BY E.LastName, E.FirstName
ORDER BY SUM([O D].quantity) DESC

-- 5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
SELECT TOP 1 E.LastName,E.FirstName,SUM([O D].quantity*[O D].UnitPrice*(1 - [O D].Discount))
FROM Orders O
JOIN [Order Details] [O D] on O.OrderID = [O D].OrderID
JOIN Employees E on E.EmployeeID = O.EmployeeID
GROUP BY E.LastName, E.FirstName
ORDER BY SUM([O D].quantity*[O D].UnitPrice*(1 - [O D].Discount)) DESC



