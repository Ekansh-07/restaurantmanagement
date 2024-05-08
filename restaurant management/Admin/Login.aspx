<%@ Page Language="C#" AutoEventWireup="true"  CodeBehind="Login.aspx.cs" Inherits="restaurant_management.Admin.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="/common.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&family=Figtree:ital,wght@0,300..900;1,300..900&family=Fira+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Lobster&display=swap" rel="stylesheet" />
    <style>
        body {
            background-image: linear-gradient(rgb(219, 219, 219),rgb(185, 185, 185),rgb(107, 102, 102));
            height: 93vh;
            font-family: "Fira Sans", sans-serif;
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
            background-color: rgb(220, 220, 220);
            border-radius: 20px;
            box-shadow: 0 1px 10px rgb(112, 112, 112);
            padding: 40px;
            width: 600px;
        }
        .message-box {
            position: absolute;
            top: 20%;
            left: 50%;
            transform: translate(-50%,-60%);
            background-color: white;
            color: #4CAF50;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
            min-width: 400px;
            text-align: center;
            z-index: 9999;
            display: none;
        }
        h2 {
            margin-left: 60px;
            margin-bottom: 30px;
            color: #333;
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
            background-color: rgb(94, 94, 94);
            color: #fff;
            border: none;
            border-radius: 10px;
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
    </style>
    <script>
        function setUserUrl(url, email) {
            var path = GenerateUrl(url, email);
            window.location.href = path;
        }
        function GenerateUrl(defaultPath, email) {
            var searchParams = new URLSearchParams();
            searchParams.set('email', email);
            return defaultPath + "?" + searchParams.toString();
        }
        $(document).ready(function () {

            $("#Btnsubmit").on('click', function () {
                let authDetails = {
                    email: $("#email").val(),
                    password: $("#pwd").val()
                }

                authDetailsJSON = JSON.stringify(authDetails);
                $.ajax({
                    url: '/WS.asmx/LoginUser',
                    type: "POST",
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data: JSON.stringify({ UserAuth: authDetailsJSON }),
                    success: function (response) {                     
                        res = JSON.parse(response.d)
                        if (res.result) {
                            if (res.data == 40) {
                                window.location.href = "/Support/Support.aspx";
                            }
                            else if (res.data == 10) {
                                window.location.href = "/Admin/Profile.aspx";
                            }
                            else {
                                const urlParams = new URLSearchParams(window.location.search);
                                var returnUrl = urlParams.get('rurl');
                                returnUrl = decodeURIComponent(returnUrl);
                                if (returnUrl == null || returnUrl == "null") {
                                    returnUrl = "/Admin/Profile.aspx";
                                }
                                window.location.href = returnUrl;
                            }
                        }
                        else {
                            displayMsg(res.msg);
                        }
                        $("#pwd").val("");
                    },
                    error: function (error) {
                        console.log(error);
                    }
                })
            })
        })
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container custContainer">
            <div class="row cont">
                <div class="col-md-offset-3 col-md-6">
                    <h2>LOGIN</h2>
                    <div class="">
                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" placeholder="Email Address" runat="server" />
                        </div>
                        <div class="form-group">
                            <label for="pwd" class="form-label">Password</label>
                            <input type="password" class="form-control" id="pwd" placeholder="Password" />
                        </div>
                        <button type="button" class="btn btn-primary" id="Btnsubmit">Log In</button>
                        <a href="ForgetPassword.aspx" style="margin-left:10px">Forget Password?</a>
                    </div>
                    <div>
                        <h3>New User?</h3><br/>
                        <a href="SignUp.aspx">Sign Up</a>
                    </div>
                </div>

            </div>
        </div>
        <div class="message-box"></div>
    </form>
</body>
</html>
