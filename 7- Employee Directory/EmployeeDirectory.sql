CREATE DATABASE InternTraining;
GO

USE InternTraining;
GO

CREATE TABLE Departments
(
    Id INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);
GO

INSERT INTO Departments (Id, Name)
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Development');
GO

CREATE TABLE Employees
(
    Id INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NULL,
    Email NVARCHAR(100) NOT NULL,
    Position NVARCHAR(100) NOT NULL,
    DepartmentId INT NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(18,2) DEFAULT 0,

    CONSTRAINT FK_Employees_Departments
    FOREIGN KEY (DepartmentId)
    REFERENCES Departments(Id)
);
GO