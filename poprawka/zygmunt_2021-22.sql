-- 1
-- takie samo jak marcjan 2021-22

-- 2
use Northwind
select distinct p.ProductName,p.SupplierID,p.CategoryID
from Products p
join [Order Details] [O D] on p.ProductID = [O D].ProductID
join Orders O on [O D].OrderID = O.OrderID
where year(o.OrderDate) = 1997 and month(o.OrderDate) =  2 and day(o.OrderDate) not in (20,21,22,23,24,25)

-- 3 takie samo jak marcjan 2021-22
