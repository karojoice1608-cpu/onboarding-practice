using System;

namespace WebApplication1
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;


            if (string.IsNullOrWhiteSpace(username) ||
                string.IsNullOrWhiteSpace(password))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Username and Password are required.";
                return;
            }


            if (username == "admin" && password == "Password123")
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Login Successful!";
            }
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid username or password.";
            }

            txtPassword.Text = "";
        }
    }
}