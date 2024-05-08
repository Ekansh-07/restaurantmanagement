<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="restaurant_management.Home" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Trirong:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="/Scripts/jquery-3.4.1.min.js"></script>
    <script src ="common.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
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

        /* Your CSS Styles Here */
.parallax-1 {
    background-image: linear-gradient(45deg,rgb(70, 75, 75, 0.80),rgb(100, 100, 100, 0.65)), url("/images/home.jpg");
    color: white;
}

.wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh; /* Adjust this value to control the height of the wrapper */
}

.exquisite {
    font-family: "Trirong", serif;
    font-weight: 700;
    font-style: italic;
    /* Add any other styles you want for the "exquisite" text */
}
h1.text-center {
   position:absolute;
   top:1%;
}



        .buffer {
            height: 100px;
            width: 100%;
            background-color: rgb(52, 52, 52);
        }

        .parallax-2 {
            background: rgb(0 0 0);
            color: white;
        }

        .with-blur-backdrop {
            -webkit-backdrop-filter: blur(2px);
            backdrop-filter: blur(2px);
            width: 100%;
        }

           .wrapper{
               display:flex;
               flex-direction:column;
               justify-content:space-around;
           }

           .user-buttons{
               width:20%;
               color: white;
               display:flex;
               justify-content:space-around
           }
           button {
  --c: black;
  
  box-shadow: 0 0 0 .1em inset var(--c); 
  --_g: linear-gradient(var(--c) 0 0) no-repeat;
  background: 
    var(--_g) calc(var(--_p,0%) - 100%) 0%,
    var(--_g) calc(200% - var(--_p,0%)) 0%,
    var(--_g) calc(var(--_p,0%) - 100%) 100%,
    var(--_g) calc(200% - var(--_p,0%)) 100%;
  background-size: 50.5% calc(var(--_p,0%)/2 + .5%);
  outline-offset: .1em;
  transition: background-size .4s, background-position 0s .4s;
}
button:hover {
  --_p: 100%;
  transition: background-position .4s, background-size 0s;
}
button:active {
  box-shadow: 0 0  inset #0009; 
  background-color: var(--c);
  color: white;
}

button {
  font-family: system-ui, sans-serif;
  font-size: 2rem;
  cursor: pointer;
  padding: .1em .6em;
  font-weight: bold;  
  border: none;
}
           

        
    </style>

    <script>
        $(document).ready(function () {
            loadTodaySpecial();
            
        });

        function menuRedirect() {
            window.location.href = "/Customers/CustomerMenu.aspx";
        }

        function profileRedirect() {
            window.location.href = "/Customers/Profile.aspx";
        }

        function supportRedirect() {
            window.location.href = "/Support/CustomerSupport.aspx";
        }

        function loadTodaySpecial() {
            callgetajax('POST', '../WS.asmx/GetSpecialDish', function (data) {
                data = JSON.parse(data); 
                $dish = $("#dish-header"); 
                $dish.children(".title").children("h2").html(data.name);
                $dish.children(".title").children("p").html(formatter(data.price));
                $dish.children("img").prop("src", data.image_url);
                $("#dish-description").text(data.description);
            })
        }
    </script>
</head>
<body>
    <section class="parallax parallax-1">
         <div class="trirong-bold-italic wrapper with-blur-backdrop">
        <h1 class="text-center">Foodzie</h1>
       
            <h2>Live<br />
                Laugh<br />
                Eat<br />
                And Make Memories.<br />
            </h2>

        <div class="user-buttons">
            <button id="b1" onclick="menuRedirect()">Check Menu</button>
            <button id="b2" onclick ="profileRedirect()">Visit Profile</button>
            <button id="b3" onclick ="supportRedirect()">Need Help?</button>
        </div>
        </div>
    </section>
    <section class="buffer"></section>
     <section class="parallax parallax-2">
         
        <div class="main-container">
            <section > 
            <h1>Today's Special</h1>
            <div id="dish-container" class=" d-flex flex-row">
                <div id="dish-header">
                        <img src="#" />
                        <div class="title">
                        <h2>Dish Title</h2>
                    <p>Price</p>
                    </div>
                </div>
                <div id ="dish-description" >
                    Description 
                </div>
            </div>
            </section>
             <section>
     <h2>Image Gallery</h2>
 </section>
            <a href="/Customers/CustomerMenu.aspx">Order Now</a>
        </div>

    </section>
   
</body>
</html>
