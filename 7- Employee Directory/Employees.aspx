<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Employees.aspx.cs"
    Inherits="EmployeeDirectory.Employees" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">

    <title>Employee Directory</title>

    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fc;
            color: #172b45;
        }

        .container {
            max-width: 1000px;
            margin: 70px auto;
            padding: 20px;
        }

        h1 {
            margin-bottom: 10px;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 7px;
        }

        input, select {
            width: 100%;
            padding: 11px;
            border: 1px solid #d4dce8;
            border-radius: 6px;
            font-size: 14px;
        }

        .buttons {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        .btn {
            border: none;
            padding: 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            flex: 1;
        }

        .primary {
            background: #2864e8;
            color: white;
        }

        .secondary {
            background: #e2e8f0;
            color: #172b45;
        }

        .search {
            max-width: 370px;
            margin: 15px 0;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th {
            background: #edf4fc;
            text-align: left;
        }

        th, td {
            padding: 12px;
            border: 1px solid #d6deea;
        }

        .action-btn {
            padding: 7px 15px;
            border: 1px solid #d4dce8;
            border-radius: 5px;
            cursor: pointer;
            margin: 3px;
        }

        .message {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        .error-message {
            color: #dc2626;
            font-size: 13px;
            display: block;
            margin-top: 5px;
        }

        .validation-summary {
            color: #dc2626;
            background: #fef2f2;
            padding: 12px;
            border-radius: 6px;
            margin-top: 15px;
            display: none;
        }

        @media(max-width: 650px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .container {
                margin: 20px auto;
            }
        }
    </style>

    <script type="text/javascript">

        document.addEventListener("DOMContentLoaded", function () {

            const form = document.getElementById("form1");

            const name = document.getElementById("txtName");
            const email = document.getElementById("txtEmail");
            const position = document.getElementById("txtPosition");
            const department = document.getElementById("ddlDepartment");
            const hireDate = document.getElementById("txtHireDate");
            const saveButton = document.getElementById("btnSave");
            const clearButton = document.getElementById("btnClear");

            const summary = document.getElementById("validationSummary");

            if (!form || !name || !email || !position ||
                !department || !hireDate || !saveButton) {
                return;
            }

            function showError(field, message) {

                const errorElement = document.getElementById(
                    field.id + "Error"
                );

                if (errorElement) {
                    errorElement.textContent = message;
                }

                field.style.borderColor = message ? "#dc2626" : "#d4dce8";

            }

            function validateName() {

                const value = name.value.trim();

                if (value === "") {
                    showError(name, "Name is required.");
                    return false;
                }

                if (!/^[A-Za-z]+(?:[ '-][A-Za-z]+)*$/.test(value)) {
                    showError(name, "Enter a valid name using letters only.");
                    return false;
                }

                showError(name, "");
                return true;
            }

            function validateEmail() {

                const value = email.value.trim();

                if (value === "") {
                    showError(email, "Email is required.");
                    return false;
                }

                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                    showError(email, "Enter a valid email address.");
                    return false;
                }

                showError(email, "");
                return true;
            }

            function validatePosition() {

                if (position.value.trim() === "") {
                    showError(position, "Position is required.");
                    return false;
                }

                showError(position, "");
                return true;
            }

            function validateDepartment() {

                if (department.value === "") {
                    showError(department, "Please select a department.");
                    return false;
                }

                showError(department, "");
                return true;
            }

            function validateHireDate() {

                const value = hireDate.value;

                if (value === "") {
                    showError(hireDate, "Hire date is required.");
                    return false;
                }

                const selectedDate = new Date(value + "T00:00:00");

                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (isNaN(selectedDate.getTime())) {
                    showError(hireDate, "Enter a valid hire date.");
                    return false;
                }

                if (selectedDate > today) {
                    showError(hireDate, "Hire date cannot be in the future.");
                    return false;
                }

                showError(hireDate, "");
                return true;
            }

            // Validate fields while typing or changing values.

            name.addEventListener("input", validateName);
            email.addEventListener("input", validateEmail);
            position.addEventListener("input", validatePosition);
            department.addEventListener("change", validateDepartment);
            hireDate.addEventListener("change", validateHireDate);

            // Validate before submitting the form.

            saveButton.addEventListener("click", function (event) {

                const isNameValid = validateName();
                const isEmailValid = validateEmail();
                const isPositionValid = validatePosition();
                const isDepartmentValid = validateDepartment();
                const isHireDateValid = validateHireDate();

                const isFormValid =
                    isNameValid &&
                    isEmailValid &&
                    isPositionValid &&
                    isDepartmentValid &&
                    isHireDateValid;

                if (!isFormValid) {

                    event.preventDefault();

                    summary.style.display = "block";
                    summary.textContent =
                        "Please correct the errors before submitting.";

                } else {

                    summary.style.display = "none";

                }

            });

            // Clear validation messages when Clear is clicked.

            if (clearButton) {

                clearButton.addEventListener("click", function () {

                    document.querySelectorAll(".error-message")
                        .forEach(function (element) {
                            element.textContent = "";
                        });

                    document.querySelectorAll(".form-grid input, .form-grid select")
                        .forEach(function (element) {
                            element.style.borderColor = "#d4dce8";
                        });

                    summary.style.display = "none";

                });

            }

        });

    </script>

</head>

<body>

<form id="form1" runat="server">

<div class="container">

    <h1>Employee Directory</h1>

    <p class="subtitle">
        Manage your employee records in one place.
    </p>

    <div class="card">

        <h2>Add Employee</h2>

        <asp:HiddenField ID="hfEmployeeId" runat="server" />

        <div class="form-grid">

            <div>
                <label>Name</label>

                <asp:TextBox ID="txtName"
                    runat="server"
                    ClientIDMode="Static"
                    placeholder="Enter employee name">
                </asp:TextBox>

                <span id="txtNameError" class="error-message"></span>
            </div>

            <div>
                <label>Email</label>

                <asp:TextBox ID="txtEmail"
                    runat="server"
                    ClientIDMode="Static"
                    TextMode="Email"
                    placeholder="Enter email">
                </asp:TextBox>

                <span id="txtEmailError" class="error-message"></span>
            </div>

            <div>
                <label>Position</label>

                <asp:TextBox ID="txtPosition"
                    runat="server"
                    ClientIDMode="Static"
                    placeholder="Enter position">
                </asp:TextBox>

                <span id="txtPositionError" class="error-message"></span>
            </div>

            <div>
                <label>Department</label>

                <asp:DropDownList ID="ddlDepartment"
                    runat="server"
                    ClientIDMode="Static">
                </asp:DropDownList>

                <span id="ddlDepartmentError" class="error-message"></span>
            </div>

            <div>
                <label>Hire Date</label>

                <asp:TextBox ID="txtHireDate"
                    runat="server"
                    ClientIDMode="Static"
                    TextMode="Date">
                </asp:TextBox>

                <span id="txtHireDateError" class="error-message"></span>
            </div>

        </div>

        <div id="validationSummary" class="validation-summary"></div>

        <div class="buttons">

            <asp:Button ID="btnSave"
                runat="server"
                ClientIDMode="Static"
                Text="Add Employee"
                CssClass="btn primary"
                OnClick="btnSave_Click" />

            <asp:Button ID="btnClear"
                runat="server"
                ClientIDMode="Static"
                Text="Clear"
                CssClass="btn secondary"
                CausesValidation="false"
                OnClick="btnClear_Click" />

        </div>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="message">
        </asp:Label>

    </div>

    <div class="card">

        <h2>All Employees</h2>

        <asp:TextBox ID="txtSearch"
            runat="server"
            CssClass="search"
            placeholder="Search by name or department..."
            AutoPostBack="true"
            OnTextChanged="txtSearch_TextChanged">
        </asp:TextBox>

        <div class="table-container">

            <asp:GridView ID="gvEmployees"
                runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="Id"
                OnRowCommand="gvEmployees_RowCommand"
                EmptyDataText="No employees found."
                Width="100%">

                <Columns>

                    <asp:BoundField DataField="Id" HeaderText="ID" />

                    <asp:BoundField DataField="FullName" HeaderText="Name" />

                    <asp:BoundField DataField="Email" HeaderText="Email" />

                    <asp:BoundField DataField="Position" HeaderText="Position" />

                    <asp:BoundField DataField="DepartmentName" HeaderText="Department" />

                    <asp:BoundField
                        DataField="HireDate"
                        HeaderText="Hire Date"
                        DataFormatString="{0:dd-MMM-yyyy}" />

                    <asp:TemplateField HeaderText="Actions">

                        <ItemTemplate>

                            <asp:Button
                                runat="server"
                                Text="Edit"
                                CssClass="action-btn"
                                CommandName="EditEmployee"
                                CommandArgument='<%# Eval("Id") %>' />

                            <asp:Button
                                runat="server"
                                Text="Delete"
                                CssClass="action-btn"
                                CommandName="DeleteEmployee"
                                CommandArgument='<%# Eval("Id") %>'
                                OnClientClick="return confirm('Are you sure you want to delete this employee?');" />

                        </ItemTemplate>

                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

    </div>

</div>

</form>

</body>
</html>