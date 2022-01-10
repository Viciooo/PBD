-- 1
;
WITH view_ as (
    select C.CustomerID, E.EmployeeID, C.CompanyName, E.FirstName, E.LastName
    from Orders O
             join Employees E on O.EmployeeID = E.EmployeeID
             join Customers C on O.CustomerID = C.CustomerID
    where year(O.OrderDate) = '1997'
),
     cnt as (
         select EmployeeID, CustomerID, FirstName, LastName, CompanyName, count(*) as suma
         from view_
         group by EmployeeID, CustomerID, FirstName, LastName, CompanyName
     )

select CompanyName,
       (select top 1 concat(cnt.LastName, ' ', cnt.FirstName)
        from cnt
        where cnt.CompanyName = C.CompanyName
        order by suma desc) as name,
       (
           select top 1 suma
           from cnt
           where cnt.CustomerID = C.CustomerID
           order by suma desc
       )                    as suma
from Customers C

-- 2

;
with sum_per_order as (
    select O2.OrderID, SUM([O D2].Quantity * [O D2].UnitPrice * (1 - [O D2].Discount)) + O2.Freight as sum, 1 as cnt
    from Orders O2
             join [Order Details] [O D2] on O2.OrderID = [O D2].OrderID
    where year(OrderDate) = 1997
      and month(OrderDate) = 2
    group by O2.OrderID, o2.Freight
)

select E.LastName, E.FirstName, isNULL(sum(sp.cnt), 0) as cnt, isnull(sum(sp.sum), 0) as sum
from Employees E
         join Orders O on E.EmployeeID = O.EmployeeID
         left join sum_per_order sp on sp.OrderID = O.OrderID
GROUP BY E.LastName, E.FirstName


-- 3
use library
;
with children_with_adresses as (
    select m.member_no,m.firstname,m.lastname,a.zip,a.state,a.city,a.street
    from juvenile j
             join member m on m.member_no = j.member_no
             join adult a on a.member_no = j.adult_member_no
)

select c.*
from loanhist l
join children_with_adresses c on c.member_no = l.member_no
join title t on l.title_no = t.title_no
where year(l.in_date) = 2001 and month(l.in_date) = 12 and day(l.in_date) = 14 and t.title = 'Walking'




