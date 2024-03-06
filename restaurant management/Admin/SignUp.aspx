<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="restaurant_management.Admin.SignUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous" />
    <link href="~/favicon.icon" rel="shortcut icon" type="image/x-icon" />
    <style>
        /* Custom CSS for the form */

body{
    background-color:#F1EAFF;
}
/* Custom CSS for the form */
.container {
    margin-top: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 80vh;
   

}

.cont {
    background-color: white;
    border-radius: 20px;
    box-shadow: 0 1px 10px rgb(231, 207, 239);
    padding: 40px;
    width: 600px;
}
     
h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #333;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.form-group {
    margin-bottom: 25px;
}

.form-label {
    font-weight: bold;
    color: #555;
}

.form-control {
    border-radius: 10px;
    border: none;
    padding: 15px;
    width: 100%;
    background-color: #f9f9f9;
    color: #333;
    font-size: 16px;
}

.form-control:focus {
    outline: none;
    background-color: #e0e0e0;
}

.btn-primary {
    background-color: #6c5ce7;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 15px 25px;
    cursor: pointer;
    font-size: 16px;
    transition: background-color 0.3s ease;
}

.btn-primary:hover {
    background-color: #4a3cb1;
}

.btn-primary:active {
    transform: translateY(1px);
}

.box{
    margin-bottom: 20px; 
}
    </style>
    <script>
        $(document).ready(() => {

            $("#btnSubmit").on('click', function () {

                let fname = $("#fname").val();
                let lname = $("#lname").val();
                let email = $("#email").val();
                let pwd = $("#pwd").val();
                let cnfPwd = $("#cnfPwd").val();

                if (pwd !== cnfPwd) {
                    alert("Password do not match");
                }
                else {
                    UserDetails = {
                        fname: fname,
                        lname: lname,
                        email: email
                    }
                    UserAuth = {
                        email: email,
                        password: pwd
                    }

                    UserDetailsJSON = JSON.stringify(UserDetails);
                    UserAuthJSON = JSON.stringify(UserAuth);

                    $.ajax({
                        url: '../WS.asmx/SetUser',
                        type: "POST",
                        contentType: 'application/json; charset=utf-8',
                        dataType: "json",
                        data: JSON.stringify({ UserDetails: UserDetailsJSON, UserAuth: UserAuthJSON }),
                        success: function (response) {
                            alert(response.d); 
                            window.location.href = "/Admin/Login.aspx";
                        },
                        error: function (error) {
                            console.log(error);
                        }
                    })
                }
            })
        })

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container custContainer">
            <div class="row cont">
                <div class="col-md-offset-3 col-md-6">
                    <h2>SIGN UP</h2>
                    <div class="box">
                        <div class="form-group">
                            <label for="fname" class ="form-label">First Name</label>
                            <input type="text" class="form-control" id="fname" placeholder="First Name" />
                        </div>
                        <div class="form-group">
                            <label for="lname" class ="form-label">Last Name</label>
                            <input type="text" class="form-control" id="lname" placeholder="Last Name" />
                        </div>
                        <div class="form-group">
                            <label for="email" class ="form-label">Email</label>
                            <input type="email" class="form-control" id="email" placeholder="Email Address" />
                        </div>
                        <div class="form-group">
                            <label for="pwd" class ="form-label">Password</label>
                            <input type="password" class="form-control" id="pwd" placeholder="Password" />
                        </div>
                        <div class="form-group">
                            <label for="cnfPwd" class ="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="cnfPwd" placeholder="Confirm Password" />
                        </div>
                        <button type="button" class="btn btn-primary" id="btnSubmit">Sign Up</button>
                    </div>
                    <p style="font-size:medium">Already a user?  </p><a href="Login.aspx">Login</a>
                </div>

            </div>
        </div>
    </form>
</body>
</html>

