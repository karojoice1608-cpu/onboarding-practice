# Task 5 – ASP.NET Login Page (Validated Login Form)

## Project Description
This project demonstrates a simple ASP.NET Web Forms login page with server-side validation. The application accepts a username and password, validates the input, and displays appropriate messages based on the login credentials.

## Features
- User-friendly login interface
- Server-side validation
- Required field validation
- Username and password verification
- Success and error messages
- Password field masking

## Technologies Used
- ASP.NET Web Forms (.NET Framework)
- C#
- HTML
- CSS

## Project Structure

```
WebApplication1/
│
├── Login.aspx
├── Login.aspx.cs
├── Login.aspx.designer.cs
├── Web.config
└── packages.config
```

## Default Login Credentials

**Username**
```
admin
```

**Password**
```
Password123
```

## Validation Rules
- Username cannot be empty.
- Password cannot be empty.
- Correct credentials display:
  ```
  Login Successful!
  ```
- Incorrect credentials display:
  ```
  Invalid username or password.
  ```

## How to Run

1. Open the project in Visual Studio.
2. Build the solution (Ctrl + Shift + B).
3. Press **F5** or click **IIS Express**.
4. The browser will open the login page.
5. Enter the credentials and test the application.

## Test Cases

| Username | Password | Expected Result |
|----------|----------|-----------------|
| admin | Password123 | Login Successful! |
| admin | wrong123 | Invalid username or password. |
| user | Password123 | Invalid username or password. |
| *(empty)* | *(empty)* | Username and Password are required. |

## Author
Karolin

## Task Status
✔ Completed