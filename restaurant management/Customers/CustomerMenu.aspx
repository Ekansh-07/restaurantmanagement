<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerMenu.aspx.cs" Inherits="restaurant_management.Customers.CustomerMenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">

    <style>
        .switch input {
          display: none;
      }
 
      /* Style the slider */
      .switch .slider {
          position: relative;
          display: inline-block;
          width: 50px;
          height: 20px;
          background-color: #A076F9;
          border-radius: 34px;
          transition: background-color 0.3s;
      }
 
          /* Style the slider handle */
          .switch .slider:before {
              position: absolute;
              content: "";
              height: 15px;
              width: 15px;
              left: 4px;
              top:2px;
              background-color: white;
              border-radius: 50%;
              transition: transform 0.3s;
          }
 
      /* Move the slider handle when the checkbox is checked */
      .switch input:checked + .slider:before {
          transform: translateX(26px);
      }
 
      /* Style the on/off labels */
      .toggle-label {
          display: inline-block;
          vertical-align: middle;
          margin: 10px;
      }
 
      /* Adjust the position of labels */
      .toggle-container {
          display: flex;
          align-items: center;
      }
    </style>
    <script>
        cart = {};
        $(document).ready(function () {
            makeTable();
            loadTable();
            loadCart();
            $('#toggle-vegetarian').on('change', function () {
                var filterValue = $('#toggle-vegetarian').prop('checked') ? 20:10;
                $('#menu').bootstrapTable('filterBy', {
                    category_id: filterValue
                });
            })
        })


        function hasCart() {
            JSON.stringify(cart) == "{}" ? $("#cartBtn").hide() : $("#cartBtn").show();
        }

        function loadTable() {
            $.ajax({
                url: '../WS.asmx/GetCustomerDishes',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                success: function (response) {
                    var menuList = JSON.parse(response.d);
                    console.log(menuList);
                    $("#menu").bootstrapTable('load', menuList);
                }
            })
        }
        function loadCart() {
            $.ajax({
                url: '../WS2.asmx/GetUserCart',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ curUser: userSessionInfo.userId }),
                success: function (response) {
                    items = JSON.parse(response.d);
                    cart = items.Items;
                    console.log(cart);
                    if (cart == null || JSON.stringify(cart) == "{}") {
                        cart = {};
                        $("#cartBtn").hide();
                    }
                    else {
                        for (item in cart) {
                            console.log(cart[item]);
                            $(`.quantity[data-row="${item}"]`).text(cart[item])
                        }
                    }
                }
            })
        }
        function makeTable() {
            $("#menu").bootstrapTable({
                classes: 'table table-borderless',
                cache: true,
                editable: true,
                sidePagination: 'client',
                showRefresh: true, 
                pageSize: 10,
                pageList: [10, 20, 50],
                maintainSelected: true,
                search: true,
                showSave: false,
                columns:
                    [
                        {
                            field: 'name',
                            title: 'Dish Name',
                            width: "150"
                        },
                        {
                            field: 'image_url',
                            title: 'Image',
                            formatter: function (value, row, index) {
                                return '<img src="' + value + '" width="150" height="150">'
                            }
                        },
                        {
                            field: 'description',
                            title: 'Description',
                            width: "400"
                        },
                        {
                            field: 'price',
                            title: 'Price',
                            width: "150"
                        },
                        {
                            field: 'button1',
                            title: '',
                            width: "150",
                            formatter: function (value, row, index) {
                                return `
                                    <button type="button" class="btn btn-primary" data-row="${row.id}" style="margin-right:10px">+</button>
                                    <span class="quantity" data-row="${row.id}">0</span>
                                    <button type="button" class="btn btn-danger" data-row="${row.id}">-</button>`;
                            },
                            events:
                            {
                                'click .btn-primary': function (e, value, row, index) {
                                    var currentQuant = (cart != null && cart[row.id] != null) ? cart[row.id] : 0;
                                    var newQuant = currentQuant + 1;
                                    cart[row.id] = newQuant;
                                    $(`.quantity[data-row="${row.id}"]`).text(cart[row.id]);
                                    hasCart();
                                },
                                'click .btn-danger': function (e, value, row, index) {
                                    var currentQuant = parseInt($(`.quantity[data-row="${row.id}"]`).text()) || 0;
                                    if (currentQuant > 1) {
                                        var newQuant = currentQuant - 1;
                                        cart[row.id] = newQuant;
                                        $(`.quantity[data-row="${row.id}"]`).text(cart[row.id]);
                                    }
                                    else {
                                        delete cart[row.id];
                                        $(`.quantity[data-row="${row.id}"]`).text(0);
                                        hasCart();
                                    }
                                }
                            }
                        }
                    ]
            });
        }

        function handlePlaceOrder() {

            userOrderInfo = {
                user_id: userSessionInfo.userId,
                Items: cart
            };
            console.log(userOrderInfo)
            userOrderInfoJSON = JSON.stringify(userOrderInfo);
            $.ajax({
                url: '../WS2.asmx/MapOrders',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ cart: userOrderInfoJSON }),
                success: function (response) {
                    if (response.d) {
                        menu = {};
                        window.location.href = "/Customers/CustomerOrder.aspx"
                    }
                }
            })

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Sidebar" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="table-responsive">
        <centre>
            <h2>Menu!!!</h2>
            <div class="toggle-container col-md-4">
                <label class="toggle-label">Veg</label>
                <label class="switch">
                    <input type="checkbox" id="toggle-vegetarian">
                    <span class="slider round"></span>
                </label>
                <label class="toggle-label">Non-Veg</label>
            </div>
            <table class="table table-bordered table-striped">
                <tbody id="menu">
                </tbody>
            </table>
        </centre>
        <button type="button" class="btn btn-dark" onclick="handlePlaceOrder()" id="cartBtn">Add To Cart</button>
    </div>
</asp:Content>
