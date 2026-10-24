using System;
using System.Configuration;
using System.Web.UI;

namespace LoginPage
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = string.Empty;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblMessage.Text = string.Empty;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            // Server-side input validation.
            if (string.IsNullOrWhiteSpace(username) ||
                string.IsNullOrEmpty(password))
            {
                ShowMessage(
                    "Please enter your username and password.",
                    false);

                return;
            }

            if (username.Length > 50 || password.Length > 128)
            {
                ShowMessage(
                    "Invalid username or password.",
                    false);

                return;
            }

            try
            {
                string expectedUsername =
                    ConfigurationManager.AppSettings["DemoUsername"];

                string passwordHash =
                    ConfigurationManager.AppSettings["DemoPasswordHash"];

                if (string.IsNullOrWhiteSpace(expectedUsername) ||
                    string.IsNullOrWhiteSpace(passwordHash))
                {
                    ShowMessage(
                        "Login is temporarily unavailable.",
                        false);

                    return;
                }

                bool usernameMatches = string.Equals(
                    username,
                    expectedUsername,
                    StringComparison.Ordinal);

                bool passwordMatches = BCrypt.Net.BCrypt.Verify(
                    password,
                    passwordHash);

                if (usernameMatches && passwordMatches)
                {
                    ShowMessage("Login successful!", true);
                }
                else
                {
                    ShowMessage(
                        "Invalid username or password.",
                        false);
                }
            }
            catch (Exception)
            {
                // Do not display exception details or passwords.
                ShowMessage(
                    "Login is temporarily unavailable.",
                    false);
            }
            finally
            {
                // Clear the password field after every attempt.
                txtPassword.Text = string.Empty;
            }
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = message;

            lblMessage.ForeColor = success
                ? System.Drawing.Color.Green
                : System.Drawing.Color.DarkRed;
        }
    }
}

