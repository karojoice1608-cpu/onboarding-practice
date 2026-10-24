Task 5 – Login Page

About the Project

This project is a simple login page created using ASP.NET Web Forms and C#.

Users can enter their username and password to log in. The application checks the entered details on the server and displays a success message if they are correct. If the details are incorrect, it displays an error message.

The password is hidden while typing and is verified using BCrypt password hashing.

Technologies Used

* ASP.NET Web Forms
* C#
* .NET Framework 4.7.2
* BCrypt.Net-Next
* IIS (Internet Information Services)

How to Run the Project in Visual Studio

1. Open the project in Visual Studio.
2. Make sure the required NuGet packages are installed.
3. Build the project using **Build → Build Solution**.
4. Set the login project as the startup project.
5. Press `Ctrl + F5` to run the application.
6. The login page will open in your browser.

How to Run the Project in IIS

IIS allows you to run the website locally without starting it directly from Visual Studio.

Step 1: Enable IIS

1. Open Windows Search and type **Turn Windows features on or off**.
2. Find and enable **Internet Information Services**.
3. Enable the required ASP.NET and .NET Framework features.
4. Click **OK** and wait for Windows to finish installing them.

Step 2: Publish the Project

1. Open the project in Visual Studio.
2. Right-click the login project and select **Publish**.
3. Choose **Folder** as the publishing option.
4. Select a folder such as `C:\PublishedApps\LoginPage`.
5. Click **Publish**.

Step 3: Configure IIS

1. Press `Windows + R`.
2. Type `inetmgr` and press Enter.
3. In IIS Manager, right-click **Application Pools** and select **Add Application Pool**.
4. Enter `LoginPagePool` as the name.
5. Select **.NET CLR Version v4.0** and **Integrated** pipeline mode.
6. Right-click **Sites** and select **Add Website**.
7. Enter `LoginPage` as the site name.
8. Select the published folder as the physical path.
9. Assign the `LoginPagePool` application pool.
10. Set an available port, such as `8080`, and click **OK**.

Step 4: Set Folder Permissions

The IIS application pool needs permission to read the website files.

1. Open the published folder in File Explorer.
2. Right-click the folder and select **Properties → Security**.
3. Add `IIS AppPool\LoginPagePool`.
4. Allow **Read & execute** permissions.
5. Apply the changes.

Do not give write permission to the entire website folder unless it is necessary.

### Step 5: Open the Website

Start the website in IIS Manager and open this address in your browser:

`http://localhost:8080/Login.aspx`

If you configured a different port, replace `8080` with that port.

About the Project

This project is a simple login page created using ASP.NET Web Forms and C#.

Users can enter their username and password to log in. The application checks the entered details on the server and displays a success message if they are correct. If the details are incorrect, it displays an error message.

The password is hidden while typing and is verified using BCrypt password hashing.

Technologies Used

ASP.NET Web Forms

C#

.NET Framework 4.7.2

BCrypt.Net-Next

IIS (Internet Information Services)

How to Run the Project in Visual Studio

Open the project in Visual Studio.

Make sure the required NuGet packages are installed.

Build the project using Build → Build Solution.

Set the login project as the startup project.

Press Ctrl + F5 to run the application.

The login page will open in your browser.

How to Run the Project in IIS

IIS allows you to run the website locally without starting it directly from Visual Studio.

Step 1: Enable IIS

Open Windows Search and type Turn Windows features on or off.

Find and enable Internet Information Services.

Enable the required ASP.NET and .NET Framework features.

Click OK and wait for Windows to finish installing them.

Step 2: Publish the Project

Open the project in Visual Studio.

Right-click the login project and select Publish.

Choose Folder as the publishing option.

Select a folder such as C:\PublishedApps\LoginPage.

Click Publish.

Step 3: Configure IIS

Press Windows + R.

Type inetmgr and press Enter.

In IIS Manager, right-click Application Pools and select Add Application Pool.

Enter LoginPagePool as the name.

Select .NET CLR Version v4.0 and Integrated pipeline mode.

Right-click Sites and select Add Website.

Enter LoginPage as the site name.

Select the published folder as the physical path.

Assign the LoginPagePool application pool.

Set an available port, such as 8080, and click OK.

Step 4: Set Folder Permissions

The IIS application pool needs permission to read the website files.

Open the published folder in File Explorer.

Right-click the folder and select Properties → Security.

Add IIS AppPool\LoginPagePool.

Allow Read & execute permissions.

Apply the changes.

Do not give write permission to the entire website folder unless it is necessary.

Step 5: Open the Website

Start the website in IIS Manager and open this address in your browser:

http://localhost:8080/Login.aspx

If you configured a different port, replace 8080 with that port.

Test Login Details

For testing, use the following details:

Username: admin

Password: Password123

If the details are correct, the page displays a success message. If they are incorrect, it displays a general error message.

Security

The application validates the username and password on the server. It uses BCrypt to verify the password without storing it as plain text.

The demo account is only for this exercise. A real application should store user accounts and password hashes securely in a database. It should also use HTTPS and appropriate access controls.

Conclusion

This project demonstrates how to create a basic login page using ASP.NET Web Forms and C#. It also explains how to validate login details and run the application locally using IIS.