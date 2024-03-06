<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="restaurant_management.Admin.ResetPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous" />
   
    <script>
        $(document).ready(function () {
            
        })
    </script>
</head>
<body>
    
    <form id="form1" runat="server">
        <div class="container m-5">
            <div class="card" style="width:200px">
                <div class="card-header">
                </div>
                <div class="card-body">
                    <asp:Label ID="Email" runat="server" />
                    <div class="form-group ">
                        <label class="form-label">New Password</label>
                        <asp:TextBox TextMode="Password" class="form-control" ID="newPwd" runat="server" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Confirm Password</label>
                        <asp:TextBox TextMode="Password" class="form-control" ID="cnfPwd" runat="server" />
                    </div>
                      <asp:Button class="btn btn-success " ID="Button1" runat="server" Text="Set Password" onclick="SetPassword"/>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
