--zadanie 2
-- 2)Czy są jacyś klienci, którzy nie złożyli żadnego zamówienia w 1997 roku? Jeśli tak, wyświetl ich dane adresowe. Wykonaj za pomocą operatorów:
-- a)join b)in c)exist

-- using not in
select c1.CompanyName
from Customers c1
where c1.CustomerID not in (select C.CustomerID
from Customers C
join Orders O on C.CustomerID = O.CustomerID
where year(o.OrderDate) = 1997)

-- using exist
select c1.CompanyName
from Customers c1
where not exists (select C.CustomerID
from Customers C
join Orders O on C.CustomerID = O.CustomerID
where year(o.OrderDate) = 1997 and c1.CustomerID = C.CustomerID)

-- using join
SELECT c.CompanyName, c.Address, c.City, c.PostalCode, c.Country
	FROM Customers as c LEFT JOIN Orders as o ON c.CustomerID = o.CustomerID AND YEAR(o.OrderDate)='1997'
	WHERE o.OrderDate IS NULL
