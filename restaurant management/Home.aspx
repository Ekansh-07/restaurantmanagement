<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="restaurant_management.Home" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Trirong:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
    <style>
        .trirong-thin {
            font-family: "Trirong", serif;
            font-weight: 100;
            font-style: normal;
        }

        .trirong-extralight {
            font-family: "Trirong", serif;
            font-weight: 200;
            font-style: normal;
        }

        .trirong-light {
            font-family: "Trirong", serif;
            font-weight: 300;
            font-style: normal;
        }

        .trirong-regular {
            font-family: "Trirong", serif;
            font-weight: 400;
            font-style: normal;
        }

        .trirong-medium {
            font-family: "Trirong", serif;
            font-weight: 500;
            font-style: normal;
        }

        .trirong-semibold {
            font-family: "Trirong", serif;
            font-weight: 600;
            font-style: normal;
        }

        .trirong-bold {
            font-family: "Trirong", serif;
            font-weight: 700;
            font-style: normal;
        }

        .trirong-extrabold {
            font-family: "Trirong", serif;
            font-weight: 800;
            font-style: normal;
        }

        .trirong-black {
            font-family: "Trirong", serif;
            font-weight: 900;
            font-style: normal;
        }

        .trirong-thin-italic {
            font-family: "Trirong", serif;
            font-weight: 100;
            font-style: italic;
        }

        .trirong-extralight-italic {
            font-family: "Trirong", serif;
            font-weight: 200;
            font-style: italic;
        }

        .trirong-light-italic {
            font-family: "Trirong", serif;
            font-weight: 300;
            font-style: italic;
        }

        .trirong-regular-italic {
            font-family: "Trirong", serif;
            font-weight: 400;
            font-style: italic;
        }

        .trirong-medium-italic {
            font-family: "Trirong", serif;
            font-weight: 500;
            font-style: italic;
        }

        .trirong-semibold-italic {
            font-family: "Trirong", serif;
            font-weight: 600;
            font-style: italic;
        }

        .trirong-bold-italic {
            font-family: "Trirong", serif;
            font-weight: 700;
            font-style: italic;
        }

        .trirong-extrabold-italic {
            font-family: "Trirong", serif;
            font-weight: 800;
            font-style: italic;
        }

        .trirong-black-italic {
            font-family: "Trirong", serif;
            font-weight: 900;
            font-style: italic;
        }

        body, html {
            height: 100%;
            font-family: "Trirong";
        }



        .parallax {
            min-height: 100vh;
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            display: flex;
            flex-direction: row;
            justify-content: center;
            text-align: center;
        }

        .parallax-1 {
            background-image: url("/images/signup.jpg");
        }

        .buffer {
            height: 200px;
            width: 100%;
            background-color: rgb(52, 52, 52);
        }

        .parallax-2 {
            background-image: url("/images/homebg.jpg");
        }
    </style>
</head>
<body>
    <section class="parallax parallax-1">
        <h2 class="trirong-bold-italic">This is an example</h2>
    </section>
    <section class="buffer"></section>
    <section class="parallax parallax-2">

        <div class=""><a href="/Customers/CustomerMenu.aspx">Order Now</a></div>
    </section>

</body>
</html>
