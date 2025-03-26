<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ForgotPassword.aspx.vb" Inherits="Logistic_Management.ForgotPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 300px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-control {
            width: 100%;
            height: 40px;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
        }
        .btn {
            width: 100%;
            height: 40px;
            padding: 10px;
            font-size: 16px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 10px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #3e8e41;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Forgot Password</h2>
            <div class="form-group">
                <asp:Label ID="lblEmail" runat="server" Text="Email:"></asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="Email is required" ControlToValidate="txtEmail"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn"  />
            </div>
            <div class="form-group">
                <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>


And here is the code-behind in VB.NET:


Imports System.Data.SqlClient

Partial Class ForgotPassword
    Inherits System.Web.UI.Page

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("LogisticManagementSystemConnectionString").ConnectionString
        Dim sqlConnection As New SqlConnection(connectionString)

        Dim sqlCommand As New SqlCommand("SELECT * FROM Users WHERE Email = @Email", sqlConnection)
        sqlCommand.Parameters.AddWithValue("@Email", txtEmail.Text)

        sqlConnection.Open()
        Dim sqlDataReader As SqlDataReader = sqlCommand.ExecuteReader()

        If sqlDataReader.Read() Then
            ' Generate a new password and update the user's password
            Dim newPassword As String = GenerateRandomPassword()
            Dim updateSqlCommand As New SqlCommand("UPDATE Users SET Password = @Password WHERE Email = @Email", sqlConnection)
            updateSqlCommand.Parameters.AddWithValue("@Password", newPassword)
            updateSqlCommand.Parameters.AddWithValue("@Email", txtEmail.Text)
            updateSqlCommand.ExecuteNonQuery()

            ' Send an email to the user with the new password
            SendEmail(txtEmail.Text, "New Password", "Your new password is: " & newPassword)

            lblMessage.Text = "A new password has been sent to your email address."
        Else
            lblMessage.Text = "Email address not found."
        End If

        sqlConnection.Close()
    End Sub

    Private Function GenerateRandomPassword() As String
        ' Generate a random password
        Dim password As String = ""
        Dim chars As String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        Dim random As New Random()

        For i As Integer = 0 To 12
            password &= chars(random.Next(0, chars.Length))
        Next

        Return password
    End Function

    Private Sub SendEmail(toAddress As String, subject As String, body As String)
        ' Send an email using the System.Net.Mail namespace
        Dim mailMessage As New MailMessage()
        mailMessage.To.Add(toAddress)
        mailMessage.Subject = subject
        mailMessage.Body = body
        mailMessage.IsBodyHtml = False

        Dim smtpClient As New SmtpClient()
        smtpClient.Host = "smtp.gmail.com"
        smtpClient.Port = 587
        smtpClient.EnableSsl = True
        smtpClient.C

