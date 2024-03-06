<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerOrder.aspx.cs" Inherits="restaurant_management.Customers.CustomerOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">
    <style>
        #addMore, #addAdrs {
            margin:20px;
            width: 150px;
        }

        #info {
            border: 0;
            background: none;
            width: 100px;
        }
        #orderCharges{
            margin-top : 50px;
            display:flex; 
            flex-direction:column;
        }

        #customToast {
            display: none;
            position: absolute;
            bottom: 100px;
            margin-left: 12%;
            max-width: 300px;
            background-color: #333;
            color: #fff;
            padding: 15px;
            border-radius: 5px;
            z-index: 9999;
        }
       
    </style>
    <script>
        netBill = {}
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
                url: '../WS2.asmx/GetUserOrder',
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
                    }).format( netBill.Total);
                    console.log(temp);
                    $("#totalPayment").text(temp);
                }
            })
        }

        function calPrice(e, row, idx, val) {
            cur_price = row.price * row.qty;
            return `<div>${cur_price}</div>`;
        }

        function calTotalPrice(data) {
            let net = 0;
            data.forEach((d) => net += (d.price * d.qty))
           netBill.cost = net;
            return net;
        }       
        function calNetPayable() {

            netBill.gst = netBill.cost * 0.05;
            netBill.delivery = netBill.cost >1000?0:20;
            netBill.Total = netBill.gst + netBill.cost + netBill.delivery;
            let formatter = new Intl.NumberFormat('en-IN', {
                style: 'currency', currency: 'INR'
            })

            $("#orderDetailsPriceInput").val(formatter.format(netBill.cost));
            $("#orderDetailsGstChargesInput").val(formatter.format(netBill.gst));
            $("#orderDetailsDeliveryChargesInput").val(formatter.format(netBill.delivery));
            $("#orderDetailsTotalAmountInput").val(formatter.format(netBill.Total)); 
        }
        function handleCartUpdate(dishId, qty) {

            updatedOrder = {
                user_id: userSessionInfo.userId,
                Items: {}
            }
            updatedOrder.Items[dishId] = qty;
            updatedOrderJSON = JSON.stringify(updatedOrder);
            $.ajax({
                url: '../WS2.asmx/UpdateOrders',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ curOrder: updatedOrderJSON }),
                success: function (response) {
                    if (response.d) {
                        loadTable();

                    }
                }
            })
        }
        function loadAddress() {
            $.ajax({
                url: '../WS.asmx/GetAddresses',
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ userId: userSessionInfo.userId }),
                success: function (res) {
                    let adrData = JSON.parse(res.d);
                    console.log(adrData);
                    $("#addressTable").bootstrapTable('load', adrData);
                    adrData.forEach((val) => {
                        let box = `<input type ="checkbox" value=${val.id} name=${"c" + val.id} />
                                    <label>${val.address}</label></br>`;
                        $("#adrsContainer").append(box);
                    })
                }
            })
        }

        function setAddress(idx) {
            let row = $("#addressTable").bootstrapTable('getData')[idx];
            $("#selectedAddress").html(row.address);
        }
        function addrBtn(val, row, idx) {
            rowJson = JSON.stringify(row);
            return '<button type="button" class="btn btn-warning" onclick="setAddress(' + idx + ')" data-dismiss="modal">Select</button>';


        }
        

        $(document).ready(function () {
            makeTable();
           loadTable();
            loadAddress();
            $("#addMore").on('click', () => {
                window.location.href = "/Customers/CustomerMenu.aspx";
            })
            $("#adrsContainer").on('change', 'input[type=checkbox]', (e) => {
                $(`input[name!=${e.target.name}]`).prop('checked', false);
            })
            $("#addAdrs").on('click', () => {
                window.location.href = "/Customers/Profile#address";
            })
            $("#info").mouseover(function () {

                calNetPayable();
            })
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Sidebar" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <%--Order Display--%>
    <div class="row d-flex align-items-center justify-content-center">
        <table id="orderTable">
            <thead></thead>
            <tbody></tbody>
        </table>
        <button type="button" class="btn btn-secondary" id="addMore">Add More Items </button>
    </div>
   <%--Address Display--%>
  <%--  <div class="row d-flex align-items-center justify-content-center">
        <h3>Select Address:</h3>
        <div id="adrsContainer">
        </div>
        <button type="button" class="btn btn-primary" id="addAdrs">Add New Address</button>
    </div>--%>

    <%--Order Cost--%>
    <div class="cont">
     <div class="card">
         <div class="card-header">
             <h5>Order Details</h5>
         </div>
         <div class="card-body">
             <div class="row">
                 <div class="col-sm-5">
                     <label class= "form-group">Total price</label>
                 </div>
                 <div class="col-sm-7">
                     <input value= ""  id="orderDetailsPriceInput" class="orderDetailsInput" disabled/>
                 </div>
             </div>
             <div class="row">
                 <div class="col-sm-5">
                     <label class="form-group">Gst Charges(5%)</label>
                 </div>
                 <div class="col-sm-7">
                     <input value="" id="orderDetailsGstChargesInput" class="orderDetailsInput" disabled />
                 </div>
             </div>
             <div class="row">
                 <div class="col-sm-5">
                     <label class="form-group">Delivery Charges(Free Delivery with minimum order of Rs 1000)</label>
                 </div>
                 <div class="col-sm-7">
                     <input value="" id="orderDetailsDeliveryChargesInput" class="orderDetailsInput" disabled />
                 </div>
             </div>
             <div class="row">
                 <div class="col-sm-5">
                     <label class="form-group">Amount to Pay</label>
                 </div>
                 <div class="col-sm-7">
                     <input value="" id="orderDetailsTotalAmountInput" class="orderDetailsInput" disabled />
                 </div>
             </div>
             <div class="row">
                 <div class="col-sm-5">
                     <button type="button" class="btn-xs btn-primary" data-toggle="modal" data-target="#addressSelectionModal" id="addressSelectBtn">Proceed to address selection </button>
                 </div>
                 <div class="col-sm-7">
                     <textarea id="selectedAddress" class="orderDetailsInput"></textarea>
                 </div>
             </div>
         </div>
     </div>
 </div>
    <%--Payment Methods--%>
    <div class="row">

    </div>
    <%--Address Modal--%>
    <div class="modal fade" id="addressSelectionModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="">Select Address</h3>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                    <table class="" id="addressTable" data-toggle="table">
                        <thead>
                            <tr>
                                <th data-field ="address"></th>
                                <th data-field ="btn" data-formatter ="addrBtn">                
                                   
                                </th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal" data-target="#addressModal" id="addAdrs">Add new address</button>
                
            </div>
        </div>
    </div>
</div>
</asp:Content>
