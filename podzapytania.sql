-- 1. Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek
select distinct ProductID, Quantity
from [Order Details] as [O D 1]
where Quantity = (select max(Quantity)
                  from [Order Details] as [O D 2]
                  where [O D 1].ProductID = [O D 2].ProductID)

-- 2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
SELECT ProductName
FROM Products
WHERE UnitPrice < (SELECT AVG(UnitPrice)
                   FROM Products)

-- 3. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
-- danej kategorii

SELECT ProductName, UnitPrice
FROM Products P2
WHERE UnitPrice < (SELECT AVG(UnitPrice)
                   FROM Products P
                   WHERE P2.CategoryID = P.CategoryID)

-- 1. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich
-- produktów oraz różnicę między ceną produktu a średnią ceną wszystkich
-- produktów
with av as
         (select CategoryID, avg(UnitPrice) as average
          from Products
          group by CategoryID)

SELECT ProductName, UnitPrice, average, UnitPrice - average AS diff
from Products p
         join av on av.CategoryID = p.CategoryID


-- 2. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią
-- cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a
-- średnią ceną wszystkich produktów danej kategorii
select (select CategoryName from Categories C where C.CategoryID = P1.CategoryID),
       ProductName,
       UnitPrice,
       (select avg(UnitPrice) from Products P2 where P1.CategoryID = P2.CategoryID),
       UnitPrice - (select avg(UnitPrice) from Products P3 where P1.CategoryID = P3.CategoryID)
from Products P1


-- 1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)
SELECT SUM(UnitPrice*Quantity*(1-Discount))+(SELECT Freight
    FROM Orders O
    WHERE O.OrderID='10250')
FROM [Order Details] [O D]
WHERE [O D].OrderID = '10250'
-- 2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za
-- przesyłkę)

-- SELECT SUM(UnitPrice*Quantity*(1-Discount))+(SELECT Freight
--     FROM Orders O
--     WHERE O.OrderID=[O D].OrderID)
-- FROM [Order Details] [O D]

select OrderID, (select sum(UnitPrice * Quantity * (1 - Discount)) from [Order Details]) + Freight
from Orders
group by OrderID, Freight
order by (select sum(UnitPrice * Quantity * (1 - Discount)) from [Order Details]) + Freight

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe
SELECT CompanyName,address
from Customers C
where CustomerID NOT IN (SELECT CustomerID FROM Orders O WHERE YEAR(OrderDate) = '1997' AND O.CustomerID = C.CustomerID)
-- 4. Podaj produkty kupowane przez więcej niż jednego klienta
-- A)
SELECT ProductID, count(CustomerID) as ilosc_klientow
FROM [order details]

INNER JOIN Orders ON Orders.OrderID=[order details].OrderID

GROUP BY ProductID

HAVING count(CustomerID)>1

ORDER BY 2
-- B)
select ProductName
from Products
where ProductID in (select ProductID
                    from [Order Details]
                    where OrderID in (select OrderID from Orders))
  and (select count(CustomerID) from Orders) >= 2
group by ProductName

-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień
-- uwzględnij cenę za przesyłkę

-- 2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
-- 3. Ogranicz wynik z pkt 1 tylko do pracowników
-- a) którzy mają podwładnych
-- b) którzy nie mają podwładnych
-- 4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę
-- ostatnio obsłużonego zamówienia
