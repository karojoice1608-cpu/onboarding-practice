using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

namespace EmployeeDirectory
{
    public partial class Employees : System.Web.UI.Page
    {
        // =========================================
        // PAGE LOAD
        // =========================================

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDepartments();
                LoadEmployees();
            }
        }


        // =========================================
        // 1. LOAD DEPARTMENTS
        // =========================================

        private void LoadDepartments()
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                string query = @"
                    SELECT Id, Name
                    FROM dbo.Departments
                    ORDER BY Name";

                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    ddlDepartment.DataSource = dt;
                    ddlDepartment.DataTextField = "Name";
                    ddlDepartment.DataValueField = "Id";
                    ddlDepartment.DataBind();
                }
            }

            ddlDepartment.Items.Insert(
                0,
                new ListItem("-- Select Department --", "")
            );
        }


        // =========================================
        // 2. DISPLAY / SEARCH EMPLOYEES
        // =========================================

        private void LoadEmployees()
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                string query = @"
                    SELECT
                        e.Id,
                        e.FirstName + ' ' + e.LastName AS FullName,
                        e.Email,
                        e.Position,
                        d.Name AS DepartmentName,
                        e.HireDate,
                        e.DepartmentId
                    FROM dbo.Employees e
                    INNER JOIN dbo.Departments d
                        ON e.DepartmentId = d.Id
                    WHERE
                        e.FirstName LIKE @Search
                        OR e.LastName LIKE @Search
                        OR e.Email LIKE @Search
                        OR d.Name LIKE @Search
                    ORDER BY e.Id DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.NVarChar,
                        100
                    ).Value = "%" + txtSearch.Text.Trim() + "%";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();

                        da.Fill(dt);

                        gvEmployees.DataSource = dt;
                        gvEmployees.DataBind();
                    }
                }
            }
        }


        // =========================================
        // 3. ADD / UPDATE EMPLOYEE
        // =========================================

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // -------------------------------------
            // GET FORM VALUES
            // -------------------------------------

            string fullName = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string position = txtPosition.Text.Trim();
            string selectedDepartment = ddlDepartment.SelectedValue;
            string dateText = txtHireDate.Text.Trim();


            // -------------------------------------
            // VALIDATION 1: REQUIRED FIELDS
            // -------------------------------------

            if (string.IsNullOrWhiteSpace(fullName) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(position) ||
                string.IsNullOrWhiteSpace(selectedDepartment) ||
                string.IsNullOrWhiteSpace(dateText))
            {
                lblMessage.Text = "Please fill all fields.";
                return;
            }


            // -------------------------------------
            // VALIDATION 2: NAME
            // -------------------------------------

            if (!Regex.IsMatch(
                fullName,
                @"^[A-Za-z]+(?:[ '-][A-Za-z]+)*$"))
            {
                lblMessage.Text =
                    "Name can contain only letters, spaces, hyphens and apostrophes.";

                return;
            }


            // -------------------------------------
            // SPLIT FIRST NAME AND LAST NAME
            // -------------------------------------

            string[] names = fullName.Split(
                new char[] { ' ' },
                2,
                StringSplitOptions.RemoveEmptyEntries
            );

            string firstName = names[0];

            string lastName = names.Length > 1
                ? names[1].Trim()
                : "";


            // -------------------------------------
            // VALIDATION 3: FIRST NAME LENGTH
            // -------------------------------------

            if (firstName.Length > 50)
            {
                lblMessage.Text =
                    "First name cannot exceed 50 characters.";

                return;
            }


            // -------------------------------------
            // VALIDATION 4: LAST NAME LENGTH
            // -------------------------------------

            if (lastName.Length > 50)
            {
                lblMessage.Text =
                    "Last name cannot exceed 50 characters.";

                return;
            }


            // -------------------------------------
            // VALIDATION 5: EMAIL
            // -------------------------------------

            if (email.Length > 100 ||
                !Regex.IsMatch(
                    email,
                    @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblMessage.Text =
                    "Please enter a valid email address.";

                return;
            }


            // -------------------------------------
            // VALIDATION 6: POSITION
            // -------------------------------------

            if (position.Length > 100 ||
                !Regex.IsMatch(
                    position,
                    @"^[A-Za-z][A-Za-z0-9 &.,()/-]*$"))
            {
                lblMessage.Text =
                    "Please enter a valid position.";

                return;
            }


            // -------------------------------------
            // VALIDATION 7: DEPARTMENT ID
            // -------------------------------------

            int departmentId;

            if (!int.TryParse(
                selectedDepartment,
                out departmentId) ||
                departmentId <= 0)
            {
                lblMessage.Text =
                    "Please select a valid department.";

                return;
            }


            // -------------------------------------
            // VALIDATION 8: HIRE DATE FORMAT
            // -------------------------------------

            DateTime hireDate;

            if (!DateTime.TryParseExact(
                dateText,
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out hireDate))
            {
                lblMessage.Text =
                    "Please enter a valid hire date.";

                return;
            }


            // -------------------------------------
            // VALIDATION 9: FUTURE HIRE DATE
            // -------------------------------------

            if (hireDate.Date > DateTime.Today)
            {
                lblMessage.Text =
                    "Hire date cannot be in the future.";

                return;
            }


            // -------------------------------------
            // VALIDATION 10: EMPLOYEE ID
            // -------------------------------------

            bool isNewEmployee =
                string.IsNullOrEmpty(hfEmployeeId.Value);

            int employeeId = 0;

            if (!isNewEmployee)
            {
                if (!int.TryParse(
                    hfEmployeeId.Value,
                    out employeeId) ||
                    employeeId <= 0)
                {
                    lblMessage.Text =
                        "Invalid employee record.";

                    return;
                }
            }


            // -------------------------------------
            // DATABASE OPERATION
            // -------------------------------------

            using (SqlConnection con = DBConnection.GetConnection())
            {
                con.Open();


                // ---------------------------------
                // VALIDATE DEPARTMENT EXISTS
                // ---------------------------------

                string departmentQuery = @"
                    SELECT COUNT(*)
                    FROM dbo.Departments
                    WHERE Id = @DepartmentId";

                using (SqlCommand departmentCmd =
                    new SqlCommand(departmentQuery, con))
                {
                    departmentCmd.Parameters.Add(
                        "@DepartmentId",
                        SqlDbType.Int
                    ).Value = departmentId;

                    int departmentExists =
                        Convert.ToInt32(
                            departmentCmd.ExecuteScalar()
                        );

                    if (departmentExists == 0)
                    {
                        lblMessage.Text =
                            "Selected department does not exist.";

                        return;
                    }
                }


                // =================================
                // INSERT NEW EMPLOYEE
                // =================================

                if (isNewEmployee)
                {
                    string query = @"
                        INSERT INTO dbo.Employees
                        (
                            Id,
                            FirstName,
                            LastName,
                            Email,
                            Position,
                            DepartmentId,
                            HireDate,
                            Salary
                        )
                        SELECT
                            ISNULL(MAX(Id), 0) + 1,
                            @FirstName,
                            @LastName,
                            @Email,
                            @Position,
                            @DepartmentId,
                            @HireDate,
                            0
                        FROM dbo.Employees WITH (TABLOCKX, HOLDLOCK)";


                    using (SqlTransaction transaction =
                        con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        try
                        {
                            using (SqlCommand cmd =
                                new SqlCommand(query, con, transaction))
                            {
                                AddEmployeeParameters(
                                    cmd,
                                    firstName,
                                    lastName,
                                    email,
                                    position,
                                    departmentId,
                                    hireDate
                                );

                                cmd.ExecuteNonQuery();
                            }

                            transaction.Commit();

                            lblMessage.Text =
                                "Employee added successfully!";
                        }
                        catch
                        {
                            transaction.Rollback();

                            throw;
                        }
                    }
                }


                // =================================
                // UPDATE EXISTING EMPLOYEE
                // =================================

                else
                {
                    string query = @"
                        UPDATE dbo.Employees
                        SET
                            FirstName = @FirstName,
                            LastName = @LastName,
                            Email = @Email,
                            Position = @Position,
                            DepartmentId = @DepartmentId,
                            HireDate = @HireDate
                        WHERE Id = @Id";


                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        AddEmployeeParameters(
                            cmd,
                            firstName,
                            lastName,
                            email,
                            position,
                            departmentId,
                            hireDate
                        );

                        cmd.Parameters.Add(
                            "@Id",
                            SqlDbType.Int
                        ).Value = employeeId;

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            lblMessage.Text =
                                "Employee updated successfully!";
                        }
                        else
                        {
                            lblMessage.Text =
                                "Employee record not found.";
                        }
                    }
                }
            }

            // -------------------------------------
            // CLEAR FORM AND RELOAD GRID
            // -------------------------------------

            ClearForm();

            LoadEmployees();
        }


        // =========================================
        // COMMON EMPLOYEE PARAMETERS
        // =========================================

        private void AddEmployeeParameters(
            SqlCommand cmd,
            string firstName,
            string lastName,
            string email,
            string position,
            int departmentId,
            DateTime hireDate)
        {
            cmd.Parameters.Add(
                "@FirstName",
                SqlDbType.NVarChar,
                50
            ).Value = firstName;

            cmd.Parameters.Add(
                "@LastName",
                SqlDbType.NVarChar,
                50
            ).Value = lastName;

            cmd.Parameters.Add(
                "@Email",
                SqlDbType.NVarChar,
                100
            ).Value = email;

            cmd.Parameters.Add(
                "@Position",
                SqlDbType.NVarChar,
                100
            ).Value = position;

            cmd.Parameters.Add(
                "@DepartmentId",
                SqlDbType.Int
            ).Value = departmentId;

            cmd.Parameters.Add(
                "@HireDate",
                SqlDbType.Date
            ).Value = hireDate;
        }


        // =========================================
        // 4. EDIT AND DELETE EMPLOYEE
        // =========================================

        protected void gvEmployees_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            int employeeId;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out employeeId) ||
                employeeId <= 0)
            {
                return;
            }

            if (e.CommandName == "EditEmployee")
            {
                LoadEmployeeForEdit(employeeId);
            }
            else if (e.CommandName == "DeleteEmployee")
            {
                DeleteEmployee(employeeId);
            }
        }


        // =========================================
        // 5. LOAD EMPLOYEE DETAILS FOR EDIT
        // =========================================

        private void LoadEmployeeForEdit(int id)
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                string query = @"
                    SELECT *
                    FROM dbo.Employees
                    WHERE Id = @Id";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Id",
                        SqlDbType.Int
                    ).Value = id;

                    con.Open();

                    using (SqlDataReader dr =
                        cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfEmployeeId.Value =
                                id.ToString();

                            txtName.Text =
                                dr["FirstName"].ToString() + " " +
                                dr["LastName"].ToString();

                            txtEmail.Text =
                                dr["Email"].ToString();

                            txtPosition.Text =
                                dr["Position"].ToString();

                            ddlDepartment.SelectedValue =
                                dr["DepartmentId"].ToString();

                            txtHireDate.Text =
                                Convert.ToDateTime(
                                    dr["HireDate"]
                                ).ToString("yyyy-MM-dd");

                            btnSave.Text =
                                "Update Employee";

                            lblMessage.Text =
                                "Editing employee record.";
                        }
                    }
                }
            }
        }


        // =========================================
        // 6. DELETE EMPLOYEE
        // =========================================

        private void DeleteEmployee(int id)
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                string query = @"
                    DELETE FROM dbo.Employees
                    WHERE Id = @Id";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.Add(
                        "@Id",
                        SqlDbType.Int
                    ).Value = id;

                    con.Open();

                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text =
                "Employee deleted successfully!";

            ClearForm();

            LoadEmployees();
        }


        // =========================================
        // 7. SEARCH EMPLOYEES
        // =========================================

        protected void txtSearch_TextChanged(
            object sender,
            EventArgs e)
        {
            LoadEmployees();
        }


        // =========================================
        // 8. CLEAR FORM
        // =========================================

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            ClearForm();

            lblMessage.Text = "";

            LoadEmployees();
        }


        // =========================================
        // CLEAR ALL INPUT FIELDS
        // =========================================

        private void ClearForm()
        {
            hfEmployeeId.Value = "";

            txtName.Text = "";

            txtEmail.Text = "";

            txtPosition.Text = "";

            txtHireDate.Text = "";

            if (ddlDepartment.Items.Count > 0)
            {
                ddlDepartment.SelectedIndex = 0;
            }

            btnSave.Text = "Add Employee";
        }
    }
}