<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgetPassword.aspx.cs" Inherits="restaurant_management.Admin.ForgetPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous" />

</head>
<body>
    <form id="form1" runat="server">
        <div class="container ">
            <div class="row d-flex align-items-center justify-content-center">
                <div class="col-md-6 mx-auto">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col">
                                    <center>
                                        <img width="150px" src="../images/user.png" />
                                    </center>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col">
                                    <center>
                                        <h3>Reset Password</h3>
                                    </center>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col">
                                    <center>
                                        <hr>
                                    </center>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col">

                                    <div class="form-group ">
                                        <label>Email</label>
                                        <asp:TextBox CssClass="form-control" ID="emailTextBox" runat="server" placeholder="Email"></asp:TextBox>
                                    </div>

                                    <div class="form-group ">
                                        <asp:Button class="btn btn-success btn-lg btn-block btnBlockCustom" ID="Button1" runat="server" Text="Send Mail" OnClick="Button1_Click" />
                                    </div>

                                </div>
                                <div class="col">

                                    <div class="form-group ">
                                        <asp:Label runat="server" ID="otpLabel" Visible="false">OTP</asp:Label>
                                        <asp:TextBox CssClass="form-control" ID="otpBox" runat="server" placeholder="OTP" Visible="false"></asp:TextBox>
                                    </div>

                                    <div class="form-group ">
                                        <asp:Button class="btn btn-primary" ID="Button2" runat="server" Text="Verify OTP" Visible="false" OnClick="Button2_Click" />
                                    </div>

                                </div>
                            </div>


                        </div>
                    </div>
                    <a href="Login.aspx">< < Back to Login</a><br />
                    <br />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
