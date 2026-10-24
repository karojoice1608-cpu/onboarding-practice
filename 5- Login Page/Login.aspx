<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs"
    Inherits="LoginPage.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <title>Secure Login</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f1f5f9;
            font-family: Arial, sans-serif;
        }

        .login-card {
            width: 100%;
            max-width: 400px;
            padding: 35px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
        }

        h1 {
            margin: 0 0 8px;
            color: #172554;
            text-align: center;
        }

        .subtitle {
            margin-bottom: 28px;
            color: #64748b;
            text-align: center;
        }

        .field {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-weight: bold;
        }

        .input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 15px;
        }

        .input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .login-button {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .login-button:hover {
            background: #1d4ed8;
        }

        .message {
            display: block;
            margin-top: 18px;
            text-align: center;
            line-height: 1.5;
        }

        .security-note {
            margin-top: 22px;
            color: #64748b;
            font-size: 12px;
            text-align: center;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">

        <main class="login-card">

            <h1>Welcome Back</h1>

            <p class="subtitle">
                Sign in to continue
            </p>

            <div class="field">
                <asp:Label
                    ID="lblUsername"
                    runat="server"
                    AssociatedControlID="txtUsername"
                    Text="Username">
                </asp:Label>

                <asp:TextBox
                    ID="txtUsername"
                    runat="server"
                    CssClass="input"
                    MaxLength="50"
                    autocomplete="username">
                </asp:TextBox>
            </div>

            <div class="field">
                <asp:Label
                    ID="lblPassword"
                    runat="server"
                    AssociatedControlID="txtPassword"
                    Text="Password">
                </asp:Label>

                <asp:TextBox
                    ID="txtPassword"
                    runat="server"
                    CssClass="input"
                    TextMode="Password"
                    MaxLength="128"
                    autocomplete="current-password">
                </asp:TextBox>
            </div>

            <asp:Button
                ID="btnLogin"
                runat="server"
                Text="Login"
                CssClass="login-button"
                OnClick="btnLogin_Click"
                CausesValidation="true" />

            <asp:Label
                ID="lblMessage"
                runat="server"
                CssClass="message"
                role="status"
                aria-live="polite">
            </asp:Label>

            <p class="security-note">
                Your password will not be displayed on the screen.
            </p>

        </main>

    </form>
</body>
</html>


