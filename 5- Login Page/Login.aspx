<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication1.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Page</title>

    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f2f2f2;
        }

        .login-box {
            width: 350px;
            margin: 80px auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px gray;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        label {
            font-weight: bold;
        }

        .textbox {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
        }

        .btn {
            width: 100%;
            padding: 10px;
            background: #0078D7;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .btn:hover {
            background: #005fa3;
        }

        .message {
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }
    </style>

</head>

<body>

<form id="form1" runat="server">

<div class="login-box">

<h2>Login</h2>

<label>Username</label>

<asp:TextBox ID="txtUsername"
    runat="server"
    CssClass="textbox">
</asp:TextBox>

<label>Password</label>

<asp:TextBox ID="txtPassword"
    runat="server"
    TextMode="Password"
    CssClass="textbox">
</asp:TextBox>

<asp:Button
    ID="btnLogin"
    runat="server"
    Text="Login"
    CssClass="btn"
    OnClick="btnLogin_Click" />

<br /><br />

<asp:Label
    ID="lblMessage"
    runat="server"
    CssClass="message">
</asp:Label>

</div>

</form>

</body>
</html>