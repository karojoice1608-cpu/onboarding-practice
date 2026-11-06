# Employee Directory

A simple ASP.NET Web Forms application for managing employee records
using C#, ADO.NET, and Microsoft SQL Server.

## Features

-   Add, view, edit, and delete employee records.
-   Search employees by name, email, or department.
-   Load departments dynamically from SQL Server.
-   Validate required fields and hire dates.
-   Generate the next employee ID using the current database design.

## Technologies

-   ASP.NET Web Forms
-   C#
-   .NET Framework 4.x
-   ADO.NET
-   Microsoft SQL Server
-   IIS / IIS Express

## Project Structure

``` text
EmployeeDirectory/
├── DAL/
│   └── DBConnection.cs
├── Employees.aspx
├── Employees.aspx.cs
├── Employees.aspx.designer.cs
├── Web.config
└── README.md
```

Your Visual Studio project may contain additional files and folders.

## 1. Database Setup

1.  Open SQL Server Management Studio (SSMS).
2.  Connect to your SQL Server instance.
3.  Create or select the `InternTraining` database.
4.  Create the tables below only if they do not already exist.

Example schema matching the application:

``` sql
CREATE TABLE dbo.Departments
(
    Id INT NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.Employees
(
    Id INT NOT NULL PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    DepartmentId INT NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(18, 2) NOT NULL DEFAULT (0),
    Position NVARCHAR(100) NULL,
    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentId) REFERENCES dbo.Departments(Id)
);
```

If `Position` is missing from an existing Employees table, add it:

``` sql
ALTER TABLE dbo.Employees
ADD Position NVARCHAR(100) NULL;
```

Insert sample departments if the table is empty:

``` sql
INSERT INTO dbo.Departments (Id, Name)
VALUES
    (1, 'Human Resources'),
    (2, 'Information Technology'),
    (3, 'Finance');
```

Check the data:

``` sql
SELECT * FROM dbo.Departments;
SELECT * FROM dbo.Employees;
```

Do not run the CREATE TABLE statements if the tables already exist.
Verify that the existing column names and data types match the
application.

### Employee ID note

The current application expects `Employees.Id` to be a regular `INT`
primary key, not an `IDENTITY` column. It calculates the next ID using
`MAX(Id) + 1` inside a transaction with a table lock.

Do not change `Id` to `IDENTITY` unless you also update the INSERT query
in `Employees.aspx.cs`. For a production application, an `IDENTITY(1,1)`
primary key is generally preferable; in that case, omit `Id` from the
INSERT statement.

## 2. Configure the Database Connection

Open `DAL/DBConnection.cs` and check that its connection string points
to your SQL Server instance and database.

Example using SQL Server Express and Windows Authentication:

``` csharp
using System.Data.SqlClient;

namespace EmployeeDirectory
{
    public class DBConnection
    {
        public static SqlConnection GetConnection()
        {
            string connectionString =
                @"Data Source=YOUR_SERVER_NAME\SQLEXPRESS;
                  Initial Catalog=InternTraining;
                  Integrated Security=True;
                  TrustServerCertificate=True;";

            return new SqlConnection(connectionString);
        }
    }
}
```

Replace `YOUR_SERVER_NAME\SQLEXPRESS` with the server/instance name
shown in SSMS. If `DBConnection.cs` already exists, update its
connection string rather than creating a second class.

For IIS deployment with Windows Authentication, ensure that the IIS
application pool identity has permission to access the SQL Server
database. Do not commit database passwords or other secrets to Git.

## 3. Run in Visual Studio

1.  Open the `EmployeeDirectory` solution in Visual Studio.
2.  Verify the connection string in `DBConnection.cs`.
3.  Confirm that the database and required tables exist.
4.  In Solution Explorer, right-click `Employees.aspx` and select **Set
    as Start Page**, if needed.
5.  Select **Build → Rebuild Solution**.
6.  Run using **IIS Express** or press `F5`.
7.  The Employee Directory page should open in your browser.

## 4. Deploy to IIS

1.  Build the project using the **Release** configuration.
2.  Publish the Web Forms project to a folder.
3.  Open **Internet Information Services (IIS) Manager**.
4.  Create an application pool for the application.
5.  Set **.NET CLR Version** to **v4.0** and **Managed pipeline mode**
    to **Integrated**.
6.  Create a website or application and set its physical path to the
    published folder.
7.  Assign the application pool to the website/application.
8.  Grant the application pool identity the required read and execute
    permissions on the published folder.
9.  Configure SQL Server permissions for the application pool identity
    if using Windows Authentication.
10. Verify the connection string and database access.
11. Open the website URL and test the application.

For a .NET Framework 4.x application, IIS displays the CLR setting as
`v4.0`; this is expected.

## 5. Testing Checklist

-   [ ] Department dropdown loads department names.
-   [ ] Existing employees appear in the GridView.
-   [ ] A valid employee can be added.
-   [ ] A new employee receives an unused ID.
-   [ ] An employee can be edited.
-   [ ] An employee can be deleted.
-   [ ] Search works by name.
-   [ ] Search works by email.
-   [ ] Search works by department.
-   [ ] Clear resets the form.
-   [ ] Missing or invalid required fields display a message.

## 6. Troubleshooting

### SQL Server network or instance error

-   Confirm that the SQL Server service is running.
-   Verify the server/instance name in `DBConnection.cs`.
-   Confirm that the `InternTraining` database exists.
-   Check that the application identity has database access.

### Invalid column name

Compare the SQL query column names with the actual table columns. The
application expects these Employees columns: `Id`, `FirstName`,
`LastName`, `Email`, `Position`, `DepartmentId`, `HireDate`, and
`Salary`. It expects `Id` and `Name` in Departments.

### Cannot insert NULL into column 'Id'

Confirm that the updated INSERT code is running and that it explicitly
supplies an ID. Also confirm that the table uses the expected key
design.

### Department dropdown is empty

Confirm that `dbo.Departments` contains records and that the application
is connected to the correct database.

## Notes

-   The current form does not collect salary, so new employees are
    inserted with salary `0`.
-   The entered name is split into first name and last name at the first
    space.
-   This is a learning/practice application. Add authentication,
    authorization, stronger validation, logging, and production-grade
    error handling before using it with real employee data.
