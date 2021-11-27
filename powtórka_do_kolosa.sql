-- Losowe zadanka które wydały mi się ciekawe
-- CREDITS TO lpawlak1 podebrane częściowo z lpawlak1/pbd-lab

--## SELECTY

-- 1. Napisz polecenie select, za pomocą którego uzyskasz tytuł i numer książki
use library
SELECT title_no,Title
FROM title

-- 3. Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i
-- autora z tablicy title dla wszystkich książek, których autorem jest Charles
-- Dickens lub Jane Austen
SELECT title_no,author
FROM title
WHERE author IN ('Charles Dickens', 'Jane Austen')

-- 4. Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w
-- porządku alfabetycznym.
SELECT title
FROM title
ORDER BY title ASC

-- 1. Napisz polecenie, które:
-- – wybiera numer członka biblioteki (member_no), isbn książki (isbn) i watrość
-- naliczonej kary (fine_assessed) z tablicy loanhist dla wszystkich wypożyczeń
-- dla których naliczono karę (wartość nie NULL w kolumnie fine_assessed)
-- – stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny
-- fine_assessed
-- – stwórz alias ‘double fine’ dla tej kolumny
SELECT member_no,isbn,fine_assessed,fine_assessed*2 as [double fine]
FROM loanhist
WHERE fine_assessed IS NOT NULL AND fine_assessed != 0

-- 1. Napisz polecenie, które wybiera title i title_no z tablicy title.
-- § Wynikiem powinna być pojedyncza kolumna o formacie jak w przykładzie
-- poniżej:
-- The title is: Poems, title number 7
-- § Czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o
-- wyrażenie, które łączy 4 elementy:
-- stała znakowa ‘The title is:’
-- wartość kolumny title
-- stała znakowa ‘title number’
-- wartość kolumny title_no

SELECT CONCAT('The title is: ',title,',title number ', title_no)
FROM title

--## GROUPING

-- 1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia
-- w tablicy order details i zwraca wynik posortowany w malejącej kolejności
-- (wg wartości sprzedaży).
USE Northwind
SELECT OrderID,SUM(UnitPrice*Quantity*(1-Discount))
FROM [Order Details]
GROUP BY OrderID
ORDER BY SUM(UnitPrice*Quantity*(1-Discount)) DESC

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych
-- 10 wierszy
USE Northwind
SELECT TOP 10 OrderID,SUM(UnitPrice*Quantity*(1-Discount))
FROM [Order Details]
GROUP BY OrderID
ORDER BY SUM(UnitPrice*Quantity*(1-Discount)) DESC

-- 1. Dla każdego czytelnika podaj łączną karę, którą zapłacił w 2001
USE library
SELECT member_no,SUM(fine_paid)
FROM loanhist
WHERE year(in_date) = '2001'
group by member_no

-- 2. Który z tytułów był najczęściej wypożyczany w 2001r
-- ŻADNA DLATEGO TESTUJĘ NA 2002r
SELECT title_no,out_date,COUNT(out_date)
FROM loan
WHERE YEAR(out_date) = '2002'
GROUP BY title_no,out_date
ORDER BY COUNT(out_date) DESC

-- 3. Który z tytułów był najczęściej oddawany po terminie

-- TODO NIE MAM POMYSŁU

--## JOIN'Y

-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.

USE Northwind
SELECT P.ProductName,SUM([O D].Quantity) AS amtOrdered
FROM Products P
JOIN [Order Details] [O D] on P.ProductID = [O D].ProductID
GROUP BY P.ProductName

-- 5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika

SELECT TOP 1 E.LastName,E.FirstName, SUM([O D].Quantity*[O D].UnitPrice*(1-[O D].Discount))
FROM Employees E
JOIN Orders O on E.EmployeeID = O.EmployeeID
JOIN [Order Details] [O D] on O.OrderID = [O D].OrderID
GROUP BY E.LastName, E.FirstName
ORDER BY SUM([O D].Quantity*[O D].UnitPrice*(1-[O D].Discount)) DESC

-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
-- – Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych
-- b) którzy nie mają podwładnych

-- a) odp
SELECT  E.LastName,E.FirstName,SUM([O D].Quantity*[O D].UnitPrice*(1-[O D].Discount))
FROM Employees E
JOIN Orders O on E.EmployeeID = O.EmployeeID
JOIN Employees E2 on E2.ReportsTo = E.EmployeeID
JOIN [Order Details] [O D] on O.OrderID = [O D].OrderID
WHERE E2.EmployeeID IS NOT NULL
GROUP BY E.LastName, E.FirstName

-- b) którzy nie mają podwładnych
SELECT  E.LastName,E.FirstName,SUM([O D].Quantity*[O D].UnitPrice*(1-[O D].Discount))
FROM Employees E
JOIN Orders O on E.EmployeeID = O.EmployeeID
LEFT JOIN Employees E2 on E2.ReportsTo = E.EmployeeID
JOIN [Order Details] [O D] on O.OrderID = [O D].OrderID
WHERE E2.EmployeeID IS NULL
GROUP BY E.LastName, E.FirstName

-- Podzapytania

--3 Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections.
select c.CompanyName, c.Phone
from Customers c
where c.CustomerID not in (select distinct o.customerid
                            from Orders o join [Order Details] od on o.OrderID = od.OrderID
                            join Products p on od.ProductID = p.ProductID
                            join Categories cat on p.CategoryID = cat.CategoryID
                            where cat.CategoryName = 'Confections')

-- Ćwiczenie 2

-- 1. Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek

select p.ProductName,
       (select max(od.Quantity) from [Order Details] od where od.ProductID = p.productid) as maxi
from Products p

-- 2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu

select p.productid
from Products p
where p.UnitPrice < (select avg(p1.UnitPrice) as price from Products p1)

-- 3. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej kategorii


;
with srednie(categoryId, average) as (select p.CategoryId, avg(p.UnitPrice)
                                      from Products p
                                      group by p.CategoryId)

select s.*, p.UnitPrice, p.ProductName
from Products p
         join srednie s on s.categoryId = p.CategoryID
where s.average > p.UnitPrice

-- Ćwiczenie 3

-- 1. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich produktów oraz różnicę między ceną produktu a średnią ceną wszystkich produktów
;with myAvg(categoryId,average) as (select CategoryID,avg(UnitPrice)
    from Products
    group by CategoryID)

select P.ProductName,P.UnitPrice,m.average,p.UnitPrice - m.average
from Products P
join myAvg m on m.categoryId = P.CategoryID

-- 2. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a średnią ceną wszystkich produktów danej kategorii

;WITH avgCategoryPrice(CategoryID,thisAvg) as
    (SELECT C.CategoryID,AVG(P.UnitPrice)
    FROM Categories C
    JOIN Products P on C.CategoryID = P.CategoryID
    GROUP BY C.CategoryID)
(
SELECT P.CategoryID,P.ProductName,P.UnitPrice,a.thisAvg,P.UnitPrice - a.thisAvg
FROM Products P
JOIN avgCategoryPrice a on a.CategoryID = P.CategoryID)

-- Ćwiczenie 4

-- 1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)

select sum((1 - od.Discount) * od.UnitPrice * od.Quantity) +
       (select o.Freight from Orders o where o.OrderID = od.OrderID) as suma,
       od.OrderID
from [Order Details] od
where od.OrderID = 10250
group by od.OrderID

-- 2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za przesyłkę)

select sum((1 - od.Discount) * od.UnitPrice * od.Quantity) +
       (select o.Freight from Orders o where o.OrderID = od.OrderID) as suma,
       od.OrderID
from [Order Details] od
group by od.OrderID

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe

;
with klienci(id) as (select CustomerID from Orders where YEAR(OrderDate) = 1997)

select CompanyName, City
from Customers
where CustomerID in (select id from klienci)


-- 4. Podaj produkty kupowane przez więcej niż jednego klienta

;
with orders_with_f(id) as (select ProductID from [Order Details] od group by ProductID having count(OrderID) > 1)

select *
from Products
where ProductID in (select id from orders_with_f)


-- Ćwiczenie 5
-- TODO ZROBIĆ SAMEMU
-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień uwzględnij cenę za przesyłkę
;
with suma(id, suma) as (select od.OrderID,
                               sum((1 - od.Discount) * od.UnitPrice * od.Quantity) +
                               (select o.Freight from Orders o where o.OrderID = od.OrderID)
                        from [Order Details] od
                        group by od.OrderID)

select p.firstname, p.lastname, sum(suma.suma)
from Employees p
         join Orders o on p.EmployeeID = o.EmployeeID
         join suma on suma.id = o.OrderID
group by p.firstname, p.lastname

-- 2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika

;
with sumaFiltered(id, suma) as (select od.OrderID,
                                       sum((1 - od.Discount) * od.UnitPrice * od.Quantity) + o.Freight
                                from [Order Details] od
                                         join Orders o on od.OrderID = o.OrderID and YEAR(o.ShippedDate) = 1997
                                group by od.OrderID, o.Freight)

select top 1 p.firstname, p.lastname, sum(suma.suma) as bestSuma
from Employees p
         join Orders o on p.EmployeeID = o.EmployeeID
         join sumaFiltered suma on suma.id = o.OrderID
group by p.firstname, p.lastname
order by bestSuma

-- 3. Ogranicz wynik z pkt 1 tylko do pracowników
-- a) którzy mają podwładnych
;
with suma(id, suma) as (select od.OrderID,
                               sum((1 - od.Discount) * od.UnitPrice * od.Quantity) +
                               (select o.Freight from Orders o where o.OrderID = od.OrderID)
                        from [Order Details] od
                        group by od.OrderID),
     podwladny(id) as (select e2.ReportsTo from Employees e2 where e2.ReportsTo is not NULL)

select p.firstname, p.lastname, sum(suma.suma)
from Employees p
         join Orders o on p.EmployeeID = o.EmployeeID
         join suma on suma.id = o.OrderID
where p.EmployeeID in (select id from podwladny)
group by p.firstname, p.lastname, p.EmployeeID


-- b) którzy nie mają podwładnych

;
with suma(id, suma) as (select od.OrderID,
                               sum((1 - od.Discount) * od.UnitPrice * od.Quantity) +
                               (select o.Freight from Orders o where o.OrderID = od.OrderID)
                        from [Order Details] od
                        group by od.OrderID),
     podwladny(id) as (select e2.ReportsTo from Employees e2 where e2.ReportsTo is not NULL)

select p.firstname, p.lastname, sum(suma.suma)
from Employees p
         join Orders o on p.EmployeeID = o.EmployeeID
         join suma on suma.id = o.OrderID
where p.EmployeeID not in (select id from podwladny)
group by p.firstname, p.lastname, p.EmployeeID

-- 4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę ostatnio obsłużonego zamówienia

-- z podwładnymi
;
with suma(id, suma) as (select od.OrderID,
                               sum((1 - od.Discount) * od.UnitPrice * od.Quantity) +
                               (select o.Freight from Orders o where o.OrderID = od.OrderID)
                        from [Order Details] od
                        group by od.OrderID),
     podwladny(id) as (select e2.ReportsTo from Employees e2 where e2.ReportsTo is not NULL)

select p.firstname,
       p.lastname,
       sum(suma.suma) as suma,
       (select top 1 o2.OrderDate
        from Orders o2
        where o2.EmployeeID = p.EmployeeID
        order by o2.OrderDate desc) as lastOrder
from Employees p
         join Orders o on p.EmployeeID = o.EmployeeID
         join suma on suma.id = o.OrderID
where p.EmployeeID in (select id from podwladny)
group by p.firstname, p.lastname, p.EmployeeID


-- z podwladnymi

;
with suma(id, suma) as (select od.OrderID,
                               sum((1 - od.Discount) * od.UnitPrice * od.Quantity) +
                               (select o.Freight from Orders o where o.OrderID = od.OrderID)
                        from [Order Details] od
                        group by od.OrderID),
     podwladny(id) as (select e2.ReportsTo from Employees e2 where e2.ReportsTo is not NULL)

select p.firstname,
       p.lastname,
       sum(suma.suma) as suma,
       (select top 1 o2.OrderDate
        from Orders o2
        where o2.EmployeeID = p.EmployeeID
        order by o2.OrderDate desc) as lastOrder
from Employees p
         join Orders o on p.EmployeeID = o.EmployeeID
         join suma on suma.id = o.OrderID
where p.EmployeeID not in (select id from podwladny)
group by p.firstname, p.lastname, p.EmployeeID
