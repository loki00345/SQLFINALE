create database Bookstore2
use Bookstore2


create table Countries
(
id int not null primary key identity(1,1),
Name nvarchar(50) not null check(Name != ' ')
)

create table Authors
(
id int not null primary key identity(1,1),
Name nvarchar(50) not null check(Name != ' '),
Surname nvarchar(50) not null check(Surname != ' '),
CountryId int not null foreign key (CountryId) references Countries(id)
)

create table Themes
(
id int primary key not null identity(1,1),
Name nvarchar(100) not null check(Name != ''),
)

create table Shops
(
id int not null primary key identity(1,1),
Name nvarchar(50) not null check(Name != ' '),
CountryId int not null foreign key (CountryId) references Countries(id)
)

create table Books
(
id int primary key not null identity(1,1),
Name nvarchar(50) not null check(Name != ''),
Pages int not null check(Pages != 0),
Price money not null check(Price !< 0),
PublishDate date not null check(PublishDate <= GETDATE()),
AuthorId int not null foreign key (AuthorId) references Authors(id),
ThemeId int not null foreign key (ThemeId) references Themes(id)
)

create table Sales
(
id int not null primary key identity(1,1),
Price money not null check(Price >= 0),
Quantity int not null check(Quantity > 0),
SaleDate date check(SaleDate <= GETDATE()) default(GETDATE()),
BookId int not null foreign key (BookId) references Books(id),
ShopId int not null foreign key (ShopId) references Shops(id)
)

insert into Countries (Name)
values
('USA'),
('Brazil'),
('UK')

insert into Authors (Name, Surname, CountryId)
values
('John', 'Pork', 2),
('Jin', 'Park', 3),
('Mat', 'Pat', 1)

insert into Themes (Name)
values
('Detective'),
('Computer sience'),
('Fantasy')

insert into Books (Name, Pages, Price, PublishDate, AuthorId, ThemeId)
values
('Detective', 470, 100, '2010-10-17', 2, 1),
('Book', 555, 300, '2019-10-13', 2 , 3),
('Microsoft moment', 670, 532, '2021-10-14', 1, 2 ),
('Windows', 123, 432, '2010-10-12', 3, 1)

insert into Shops (Name, CountryId)
values
('Target', 1),
('UkSTore', 3),
('Walmart', 2)

insert into Sales (Price, Quantity, SaleDate, BookId, ShopId)
values
(1000, 30,'2010-10-13',1,1),
(1400, 10,'2010-10-13',2,3),
(1100, 130,'2010-10-13',3,2),
(1111, 131,'2010-10-13',4,3)


select Name, Pages from Books where Pages > 500 and Pages < 650

select Name from Books where Name like '%A%' or Name like '%Z%'

select Name from Books where Name like '%Microsoft%' and Name not like '&Windows&'

select 
    b.Name as BookName,
    t.Name as Theme,
    CONCAT(a.Name, ' ', a.Surname) as AuthorFullName
from
    Books b
join
    Authors a on b.AuthorId = a.id
join
    Themes t on b.ThemeId = t.id
where
    b.Price / b.Pages < 0.65;

select b.name as bookname, t.name as theme, count(s.id) as salescount from books b join themes t on b.themeid = t.id join sales s on b.id = s.bookid where t.name = 'Detective' group by b.name, t.name having count(s.id) > 30;




SELECT 
    Name AS BookName
FROM 
    Books
WHERE 
    LEN(Name) - LEN(REPLACE(Name, ' ', '')) = 3;



select 
    b.name as bookname, 
    t.name as theme, 
    concat(a.name, ' ', a.surname) as authorfullname, 
    s.price as price, 
    s.quantity as salescount, 
    sh.name as shopname
from 
    books b
join 
    themes t on b.themeid = t.id
join 
    authors a on b.authorid = a.id
join 
    sales s on b.id = s.bookid
join 
    shops sh on s.shopid = sh.id
where 
    b.name not like '%a%' and
    t.name != 'Computer sience' and
    concat(a.name, ' ', a.surname) != 'Mat Pat' and
    s.price between 10 and 20 and
    s.quantity >= 8 and
    sh.countryid not in (select id from countries where name in ('USA', 'UK'));



select 
    t.name as theme,
    sum(b.pages) as totalpages
from 
    themes t
join 
    books b on t.id = b.themeid
group by 
    t.name;



select 
    concat(a.name, ' ', a.surname) as authorfullname,
    count(*) as totalbooks,
    sum(b.pages) as totalpages
from 
    authors a
join 
    books b on a.id = b.authorid
group by 
    concat(a.name, ' ', a.surname);



select top 1
    b.name as bookname,
    b.pages as pagecount
from
    books b
join
    themes t on b.themeid = t.id
where
    t.name = 'Computer sience'
order by
    b.pages desc;



select 
    t.name as theme,
    avg(b.pages) as avgpagecount
from 
    books b
join 
    themes t on b.themeid = t.id
group by 
    t.name
having 
    avg(b.pages) <= 400;



select 
    t.name as theme,
    sum(b.pages) as totalpages
from 
    books b
join 
    themes t on b.themeid = t.id
where 
    t.name in ('Computer sience', 'Administration', 'Fantasy') and
    b.pages > 400
group by 
    t.name;



SELECT
    s.Name AS ShopName,
    c.Name AS Country,
    SUM(sal.Price * sal.Quantity) AS TotalRevenue
FROM
    Sales AS sal
INNER JOIN
    Shops AS s ON sal.ShopId = s.id
INNER JOIN
    Countries AS c ON s.CountryId = c.id
GROUP BY
    s.Name, c.Name;



SELECT 'Number of authors' AS "Indicator", COUNT(*) AS "Value" FROM Authors;
SELECT 'Number of books' AS "Indicator", COUNT(*) AS "Value" FROM Books;
SELECT 'Average sale price' AS "Indicator", FORMAT(AVG(Price), 'N2') + N' UAH' AS "Value" FROM Sales WHERE Price IS NOT NULL;
SELECT 'Average number of pages' AS "Indicator", FORMAT(AVG(Pages), 'N1') AS "Value" FROM Books;



SELECT TOP 1
    SH.Name AS ShopName,
    SUM(S.Price * S.Quantity) AS TotalRevenue
FROM 
    Sales as S
JOIN 
    Shops SH ON S.ShopId = SH.Id
GROUP BY 
    SH.Name
HAVING 
    SUM(S.Price * S.Quantity) > 0
ORDER BY 
    TotalRevenue DESC;





