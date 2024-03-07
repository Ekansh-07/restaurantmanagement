<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDetails.aspx.cs" Inherits="restaurant_management.Customers.OrderDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">
    <script>
        function makeTable() {
            $("#orderTable").bootstrapTable({
                classes: 'table table-borderless',
                cache: true,
                editable: true,
                sidePagination: 'client',
                pageSize: 10,
                pageList: [10, 20, 50],
                showFooter: true,
                columns:
                    [
                        {
                            field: 'name',
                            title: 'Dish Name',
                            width: "150",
                            footerFormatter: `Total:`
                        },
                        {
                            field: 'image_url',
                            title: 'Image',
                            formatter: function (value, row, index) {
                                return '<img src="' + value + '" width="150" height="150">'
                            }
                        },
                        {
                            field: 'net_price',
                            title: 'Total',
                            width: "150",
                            formatter: calPrice,
                            footerFormatter: calTotalPrice
                        },
                        {
                            field: 'button1',
                            title: '',
                            width: "150",
                            formatter: function (value, row, index) {
                                return `
                    <button type="button" class="btn btn-primary" data-row="${row.id}" style="margin-right:10px">+</button>
                    <span class="quantity" data-row="${row.id}">${row.qty}</span>
                    <button type="button" class="btn btn-danger" data-row="${row.id}">-</button>`;
                            },
                            events:
                            {
                                'click .btn-primary': function (e, value, row, index) {
                                    var currentQuant = parseInt($(`.quantity[data-row="${row.id}"]`).text()) || 0;
                                    var newQuant = currentQuant + 1;
                                    $(`.quantity[data-row="${row.id}"]`).text(newQuant);
                                    handleCartUpdate(row.id, newQuant);
                                },
                                'click .btn-danger': function (e, value, row, index) {
                                    var currentQuant = parseInt($(`.quantity[data-row="${row.id}"]`).text()) || 0;
                                    var newQuant = currentQuant > 1 ? currentQuant - 1 : 0;
                                    $(`.quantity[data-row="${row.id}"]`).text(newQuant);
                                    handleCartUpdate(row.id, newQuant);
                                }
                            }
                        }

                    ]
            });
        }
        function loadTable() {
            console.log(userSessionInfo.userId);
            $.ajax({
                url: '../WS2.asmx/GetUserCartDetails',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ curUser: userSessionInfo.userId }),
                success: function (response) {
                    var menuList = JSON.parse(response.d);

                    menuList = menuList.filter((val) => {
                        return val.qty > 0;
                    });
                    if (menuList.length == 0)
                        window.location.href = "/Customers/CustomerMenu.aspx";
                    $("#orderTable").bootstrapTable('load', menuList);
                    calNetPayable();
                    let temp = "Total amount to be paid :" + new Intl.NumberFormat('en-IN', {
                        style: 'currency', currency: 'INR'
                    }).format(netBill.Total);
                    console.log(temp);
                    $("#totalPayment").text(temp);
                }
            })
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Sidebar" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container m-3" id="orderTableContainer">
        <h2>Orders</h2>

        <table id ="orderTable">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
</asp:Content>
