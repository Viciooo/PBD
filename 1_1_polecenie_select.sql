-- SELECT keyword

-- 1. Wybierz nazwy i adresy wszystkich klientów:

SELECT CompanyName,Address,City,Region,PostalCode,Country FROM Customers

-- 2. Wybierz nazwiska i numery telefonów pracowników:

SELECT LastName, HomePhone FROM Employees

-- 3. Wybierz nazwy i ceny produktów:

SELECT ProductName, UnitPrice FROM Products

-- 4. Pokaż wszystkie kategorie produktów (nazwy i opisy):

SELECT CategoryName, Description FROM Categories

-- 5. Pokaż nazwy i adresy stron www dostawców:

SELECT CompanyName, HomePage from Suppliers
	
-- WHERE keyword	

-- 1. Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie:

SELECT CompanyName, Country, Region, City, PostalCode, Address FROM Customers WHERE City = 'London'

-- 2. Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii:

SELECT CompanyName, Country, Region, City, PostalCode, Address FROM Customers WHERE Country = 'France' or Country = 'Spain'

-- 3. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00:

SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice >= 20.00 AND UnitPrice <= 30.00

-- 4. Wybierz nazwy i ceny produktów z kategorii ‘meat’:

SELECT ProductName, UnitPrice FROM Products WHERE CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Meat/Poultry')

-- 5. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’:

SELECT SupplierID FROM Suppliers WHERE CompanyName = 'Tokyo Traders' SELECT ProductName, UnitsInStock FROM Products WHERE SupplierID = 4

-- 6. Wybierz nazwy produktów których nie ma w magazynie:

SELECT ProductName FROM Products WHERE UnitsInStock = 0
	
-- LIKE keyword	

-- 1. Szukamy informacji o produktach sprzedawanych w butelkach (‘bottle’):

SELECT ProductName FROM Products WHERE QuantityPerUnit LIKE '%bottle%'

-- 2. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę z zakresu od B do L:

SELECT Title FROM Employees WHERE LastName LIKE '[B-L]%'

-- 3. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę B lub L:

SELECT Title,LastName FROM Employees WHERE LastName LIKE '[BL]%'

-- 4. Znajdź nazwy kategorii, które w opisie zawierają przecinek:

SELECT CategoryName FROM Categories WHERE Categories.Description LIKE '%,%'

-- 5. Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo ‘Store’:

SELECT CompanyName FROM Customers WHERE CompanyName LIKE '%Store%'
	
-- Zakres wartości - ćwiczenie	

-- 1. Szukamy informacji o produktach o cenach mniejszych niż 10 lub większych niż 20:

SELECT ProductName,UnitPrice FROM Products WHERE UnitPrice < 10 OR UnitPrice > 20

-- 2. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00:

SELECT ProductName,UnitPrice FROM Products WHERE UnitPrice BETWEEN 20 AND 30
	
-- Warunki logiczne - ćwiczenie

-- 1. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan) lub we Włoszech (Italy):

SELECT CompanyName,Country FROM Customers WHERE Country = 'Japan' OR Country='Italy'

-- 1. Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer
-- klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem
-- odbiorcy jest Argentyna:

SELECT OrderID,OrderDate,CustomerID
FROM Orders
WHERE ShipCountry = 'Argentina' AND (ShippedDate > GETDATE() OR ShippedDate IS NULL)

-- ORDER BY - ćwiczenie

-- 1. Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w
-- ramach danego kraju nazwy firm posortuj alfabetycznie:

SELECT Country,CompanyName FROM Customers ORDER BY Country,CompanyName ASC

-- 2. Wybierz informację o produktach (grupa, nazwa, cena), produkty posortuj wg
-- grup a w grupach malejąco wg ceny:

SELECT ProductName,UnitPrice,CategoryID FROM Products ORDER BY CategoryID,UnitPrice DESC 

-- 3. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan)
-- lub we Włoszech (Italy), wyniki posortuj tak jak w pkt 1

SELECT CompanyName,Country FROM Customers WHERE Country IN ('Japan','Italy') ORDER BY Country,CompanyName ASC

-- Ćwiczenie

-- 1. Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze
-- 10250:

SELECT UnitPrice * Quantity *(1-Discount) 
AS thePrice
FROM [Order Details] 
WHERE OrderID = '10250'

-- 2. Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą
-- kolumnę zawierającą nr telefonu i nr faksu w formacie
-- (numer telefonu i faksu mają być oddzielone przecinkiem):

SELECT CompanyName, Phone + ',' + isnull(Fax, 'NULL') AS ContactUs
FROM Suppliers


