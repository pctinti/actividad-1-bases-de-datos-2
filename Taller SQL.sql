CREATE TABLE BookCategories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Description TEXT
);

CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Genre VARCHAR(50),
    PublicationYear INT,
    AvailableCopies INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES BookCategories(CategoryID)
);

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    BookID INT,
    LoanDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    BookID INT,
    ReservationDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Data insertion statements

INSERT INTO BookCategories (CategoryName, Description)
VALUES 
('Fiction', 'Fictional works including novels and short stories'),
('Non-fiction', 'Books based on real facts and events'),
('Science', 'Books about scientific concepts and discoveries'),
('Technology', 'Books about technological advancements'),
('History', 'Books about historical events and figures'),
('Biography', 'Books about individuals and their lives'),
('Fantasy', 'Fictional works with magical elements'),
('Mystery', 'Books about solving crimes or puzzles'),
('Children', 'Books aimed at young readers'),
('Education', 'Books used for learning and instruction');

INSERT INTO Books (Title, Author, Genre, PublicationYear, AvailableCopies, CategoryID)
VALUES 
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 5, 1),
('Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 'Non-fiction', 2011, 3, 2),
('A Brief History of Time', 'Stephen Hawking', 'Science', 1988, 4, 3),
('The Innovators', 'Walter Isaacson', 'Technology', 2014, 2, 4),
('The Diary of a Young Girl', 'Anne Frank', 'History', 1947, 3, 5),
('Steve Jobs', 'Walter Isaacson', 'Biography', 2011, 4, 6),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy', 1997, 6, 7),
('The Girl with the Dragon Tattoo', 'Stieg Larsson', 'Mystery', 2005, 2, 8),
('Charlotte''s Web', 'E.B. White', 'Children', 1952, 7, 9),
('Introduction to Algorithms', 'Cormen et al.', 'Education', 2009, 3, 10);

INSERT INTO Users (FirstName, LastName, Email, PhoneNumber)
VALUES 
('Alice', 'Johnson', 'alice.johnson@example.com', '1234567890'),
('Bob', 'Smith', 'bob.smith@example.com', '0987654321'),
('Carol', 'Davis', 'carol.davis@example.com', '1122334455'),
('David', 'Garcia', 'david.garcia@example.com', '2233445566'),
('Eve', 'Martinez', 'eve.martinez@example.com', '3344556677'),
('Frank', 'Brown', 'frank.brown@example.com', '4455667788'),
('Grace', 'Lee', 'grace.lee@example.com', '5566778899'),
('Hank', 'Wilson', 'hank.wilson@example.com', '6677889900'),
('Ivy', 'Taylor', 'ivy.taylor@example.com', '7788990011'),
('Jack', 'Anderson', 'jack.anderson@example.com', '8899001122');

INSERT INTO Staff (FirstName, LastName, Role, Email)
VALUES 
('Laura', 'Thompson', 'Administrator', 'laura.thompson@example.com'),
('Michael', 'Rodriguez', 'Librarian', 'michael.rodriguez@example.com'),
('Nina', 'White', 'Assistant', 'nina.white@example.com'),
('Oscar', 'Clark', 'Librarian', 'oscar.clark@example.com'),
('Paul', 'Lewis', 'Administrator', 'paul.lewis@example.com'),
('Quinn', 'Walker', 'Librarian', 'quinn.walker@example.com'),
('Rachel', 'Hall', 'Assistant', 'rachel.hall@example.com'),
('Sam', 'Allen', 'Administrator', 'sam.allen@example.com'),
('Tina', 'Young', 'Librarian', 'tina.young@example.com'),
('Victor', 'King', 'Assistant', 'victor.king@example.com');

INSERT INTO Loans (UserID, BookID, LoanDate, ReturnDate)
VALUES 
(1, 1, '2024-11-01', NULL),
(2, 2, '2024-11-02', '2024-11-10'),
(3, 3, '2024-11-03', NULL),
(4, 4, '2024-11-04', '2024-11-12'),
(5, 5, '2024-11-05', NULL),
(6, 6, '2024-11-06', '2024-11-14'),
(7, 7, '2024-11-07', NULL),
(8, 8, '2024-11-08', '2024-11-16'),
(9, 9, '2024-11-09', NULL),
(10, 10, '2024-11-10', '2024-11-18');

INSERT INTO Reservations (UserID, BookID, ReservationDate, Status)
VALUES 
(1, 3, '2024-11-01', 'active'),
(2, 5, '2024-11-02', 'cancelled'),
(3, 7, '2024-11-03', 'active'),
(4, 9, '2024-11-04', 'active'),
(5, 2, '2024-11-05', 'cancelled'),
(6, 4, '2024-11-06', 'active'),
(7, 6, '2024-11-07', 'active'),
(8, 8, '2024-11-08', 'cancelled'),
(9, 10, '2024-11-09', 'active'),
(10, 1, '2024-11-10', 'active');

--Consulta 1: Usuarios que han reservado libros de categoría Fiction

SELECT FirstName, LastName
FROM Users
WHERE UserID IN (
    SELECT UserID
    FROM Reservations
    WHERE BookID IN (
        SELECT BookID
        FROM Books
        WHERE CategoryID = (
            SELECT CategoryID
            FROM BookCategories
            WHERE CategoryName = 'Fiction'
        )
    )
);

--Consulta 2: Libros que están prestados

SELECT Title, Author
FROM Books
WHERE BookID IN (
    SELECT BookID
    FROM Loans
    WHERE ReturnDate IS NULL
);

--Consulta 3: Libros reservados pero no prestados

SELECT Title
FROM Books
WHERE BookID IN (SELECT BookID FROM Reservations)
AND BookID NOT IN (SELECT BookID FROM Loans);

--Consulta 4: Libros prestados pero no reservados

SELECT Title
FROM Books
WHERE BookID IN (SELECT BookID FROM Loans)
AND BookID NOT IN (SELECT BookID FROM Reservations);

--Consulta 5: Estado de libros

SELECT Title,
CASE 
    WHEN AvailableCopies > 0 THEN 'Disponible'
    ELSE 'Agotado'
END AS Estado
FROM Books;

--Consulta 6: Clasificación de usuarios

SELECT FirstName, LastName,
CASE 
    WHEN UserID IN (SELECT UserID FROM Loans) THEN 'Activo'
    ELSE 'Sin actividad'
END AS Estado
FROM Users;

--Consultas 7: Categorías con más de 3 libros

SELECT CategoryID, COUNT(*) AS TotalLibros
FROM Books
GROUP BY CategoryID
HAVING COUNT(*) > 3;

--Consulta 8: Usuarios con más de 2 reservas

SELECT UserID, COUNT(*) AS TotalReservas
FROM Reservations
GROUP BY UserID
HAVING COUNT(*) > 2;

--Consulta 9: Usuarios y libros prestados

SELECT U.FirstName, U.LastName, B.Title
FROM Users U
INNER JOIN Loans L ON U.UserID = L.UserID
INNER JOIN Books B ON L.BookID = B.BookID;


--Consulta 10: Usuarios y libros reservados

SELECT U.FirstName, U.LastName, B.Title
FROM Users U
INNER JOIN Reservations R ON U.UserID = R.UserID
INNER JOIN Books B ON R.BookID = B.BookID;

--Consulta 11: Libros con usuario que los reservó

SELECT B.Title, U.FirstName, U.LastName
FROM Books B
LEFT JOIN Reservations R ON B.BookID = R.BookID
LEFT JOIN Users U ON R.UserID = U.UserID;


--Consulta 12: Usuarios con libros prestados

SELECT U.FirstName, U.LastName, B.Title
FROM Users U
LEFT JOIN Loans L ON U.UserID = L.UserID
LEFT JOIN Books B ON L.BookID = B.BookID;

--Consulta 13: Libros con usuarios que los reservaron

SELECT B.Title, U.FirstName, U.LastName
FROM Reservations R
RIGHT JOIN Books B ON R.BookID = B.BookID
LEFT JOIN Users U ON R.UserID = U.UserID;


--Consulta 14: Usuarios con libros prestados

SELECT U.FirstName, U.LastName, B.Title
FROM Loans L
RIGHT JOIN Users U ON L.UserID = U.UserID
LEFT JOIN Books B ON L.BookID = B.BookID;


--Consulta 15: Títulos en mayúsculas

SELECT UPPER(Title) AS Titulo
FROM Books;


--Consulta 16: Nombre completo de usuarios

SELECT CONCAT(FirstName, ' ', LastName) AS NombreCompleto
FROM Users;


--Consulta 17: Días desde la reserva

SELECT ReservationID, DATEDIFF(CURDATE(), ReservationDate) AS Dias
FROM Reservations;


--Consulta 18: Préstamos pendientes

SELECT *
FROM Loans
WHERE ReturnDate IS NULL;


--Consulta 19: Total de copias por categoría

SELECT CategoryID, SUM(AvailableCopies) AS TotalCopias
FROM Books
GROUP BY CategoryID;


--Consulta 20: Libros prestados por usuario

SELECT UserID, COUNT(*) AS TotalPrestados
FROM Loans
GROUP BY UserID;