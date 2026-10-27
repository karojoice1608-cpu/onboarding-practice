<%@ Language="VBScript" %>
<%
Option Explicit

Dim requestMethod
Dim username
Dim message
Dim errorMessage

requestMethod = UCase(Request.ServerVariables("REQUEST_METHOD"))

username = ""
message = ""
errorMessage = ""

If requestMethod = "POST" Then

    username = Trim(Request.Form("username"))
    message = Trim(Request.Form("message"))

    ' Validate the name
    If username = "" Then
        errorMessage = "Please enter your name."

    ElseIf Len(username) > 100 Then
        errorMessage = "Name cannot exceed 100 characters."

    ElseIf Not IsValidName(username) Then
        errorMessage = "Name must contain only English letters and spaces."

    ' Validate the feedback
    ElseIf message = "" Then
        errorMessage = "Please enter your feedback."

    ElseIf Len(message) > 2000 Then
        errorMessage = "Feedback cannot exceed 2000 characters."

    End If

End If

' Function to validate the name
Function IsValidName(nameValue)

    Dim regex

    Set regex = New RegExp

    regex.Pattern = "^[A-Za-z ]+$"
    regex.Global = False
    regex.IgnoreCase = False

    IsValidName = regex.Test(nameValue)

    Set regex = Nothing

End Function
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Feedback Form</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #1f3c88;
            margin: 0;
            padding: 40px 15px;
        }

        /* Main form container */

        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        h1 {
            text-align: center;
            color: #1f3c88;
        }

        p {
            color: #555555;
            line-height: 1.6;
        }

        label {
            display: block;
            margin-top: 18px;
            margin-bottom: 8px;
            font-weight: bold;
            color: #222222;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #cccccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 15px;
            font-family: Arial, sans-serif;
        }

        input[type="text"]:focus,
        textarea:focus {
            outline: none;
            border-color: #1f3c88;
            box-shadow: 0 0 4px rgba(31, 60, 136, 0.3);
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        /* Submit button */

        button {
            width: 100%;
            margin-top: 20px;
            padding: 12px;
            background-color: #1f3c88;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #14285c;
        }

        /* Error message box */

        .error {
            margin-top: 25px;
            padding: 15px;
            background-color: #fdeaea;
            color: #b00020;
            border-left: 5px solid #dc3545;
            border-radius: 5px;
            overflow-wrap: anywhere;
        }

        /* Separate Thank You box */

        .result {
            margin-top: 30px;
            padding: 25px;
            background-color: #1f3c88;
            color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            overflow-wrap: anywhere;
        }

        .result h2 {
            color: #ffffff;
            margin-top: 0;
            margin-bottom: 20px;
        }

        .result p {
            color: #ffffff;
            line-height: 1.7;
        }

        .result strong {
            color: #ffffff;
        }

        .message-text {
            color: #ffffff;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            line-height: 1.6;
        }

        /* Mobile responsive design */

        @media (max-width: 480px) {

            body {
                padding: 20px 12px;
            }

            .container {
                padding: 20px;
            }

            .result {
                padding: 20px;
            }

        }

    </style>

    <script>

        // Validate the name before submitting

        function validateName() {

            var nameField = document.getElementById("username");
            var name = nameField.value.trim();

            if (name === "") {

                alert("Please enter your name.");

                nameField.focus();

                return false;
            }

            if (!/^[A-Za-z ]+$/.test(name)) {

                alert(
                    "Name must contain only English letters and spaces. Numbers and special characters are not allowed."
                );

                nameField.focus();

                return false;
            }

            return true;
        }

    </script>

</head>

<body>

    <!-- Main white container -->

    <div class="container">

        <h1>Feedback Form</h1>

        <p>
            Please enter your name and feedback using the form below.
        </p>

        <!-- Feedback form -->

        <form
            method="POST"
            action="feedback.asp"
            onsubmit="return validateName();"
        >

            <label for="username">Your Name:</label>

            <input
                type="text"
                id="username"
                name="username"
                maxlength="100"
                pattern="[A-Za-z ]+"
                title="Enter English letters and spaces only."
                value="<%= Server.HTMLEncode(username) %>"
                required
            >

            <label for="message">Your Feedback:</label>

            <textarea
                id="message"
                name="message"
                maxlength="2000"
                required
            ><%= Server.HTMLEncode(message) %></textarea>

            <button type="submit">
                Submit Feedback
            </button>

        </form>

        <!-- Display validation errors or successful submission -->

        <%
        If requestMethod = "POST" Then

            If errorMessage <> "" Then
        %>

                <!-- Error message -->

                <div class="error">

                    <strong>Error:</strong>

                    <%= Server.HTMLEncode(errorMessage) %>

                </div>

        <%
            Else
        %>

                <!-- Separate blue Thank You box -->

                <div class="result">

                    <h2>Thank You for Your Feedback!</h2>

                    <p>
                        <strong>Name:</strong>
                        <%= Server.HTMLEncode(username) %>
                    </p>

                    <p>
                        <strong>Your Feedback:</strong>
                    </p>

                    <div class="message-text"><%= Server.HTMLEncode(message) %></div>

                    <p>
                        <strong>Server Time:</strong>
                        <%= Server.HTMLEncode(CStr(Now())) %>
                    </p>

                </div>

        <%
            End If

        End If
        %>

    </div>

</body>

</html>


