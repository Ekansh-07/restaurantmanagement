<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminOrder.aspx.cs" Inherits="restaurant_management.Admin.AdminOrder" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">
    <style>
        .activerow {
            background-color: rgb(255, 231, 182);
        }
    </style>
    <script>

        var orderList = [];
        var selectedIds = [];

       

        function registerMoreInfoBootstrapTable() {
            $("#moreInfoTable").bootstrapTable({
                //url: '/WebService1.asmx/getOrderDetailsAdmin',
                cache: true,
                striped: true,
                clickToSelect: false,
                pagination: false,
                showFooter: true,
                editable: true,
                pageSize: 10,
                pageList: [10, 20, 50],
                pageList: [10, 20, 50],
                showSave: false,
                classes: 'table table-borderless',
                //detailView: true,
                //detailViewByClick: true,
                //detailViewIcon: false,
                //detailFormatter: detailFormatterMoreDetails,
                columns: [
       

                    {
                        field: 'item_id',
                        title: 'Dish Id',
                        align: 'center',
                    },
                    {
                        field: 'name',
                        title: 'Dish Name',
                        align: 'center',
                    },

                    {
                        field: 'qty',
                        title: 'Quantity',
                        align: 'center',

                    },

                ]
            });
        }
        
        function registerBootstrapTable(tableid) {

            $("#"+tableid).bootstrapTable({
                cache: true,
                striped: true,
                clickToSelect:false,
                pagination: false,
                showFooter: true,
                height: 400,
                editable: true,
                search: true,
                showSave: false,
                classes: 'table table-borderless',
                columns: [
                    {
                        field: 'checkbox',
                        title: '<input type="checkbox" id="selectAllOrders" name="selectAllOrdersCheckBox"/>',
                        formatter: checkboxFormatter,                   
                    },
                  
                    {
                        field: 'id',
                        title: 'Order Id',
                        align: 'center',
                    },
                    {
                        field: 'user_id',
                        title: 'User Id',
                        align: 'center',
                    },

                    {
                        field: 'name',
                        title: 'User name',
                        align: 'center',

                    },
                    {
                        field: 'order_date',
                        title: 'Order date',
                        align: 'center',
                        formatter: dateFormatter
                    },
                    {
                        field: 'order_status',
                        title: 'Order Status',
                        align: 'center',

                    },
                    {
                        field: 'address',
                        title: 'Delivered Address',
                        align: 'center',

                    },
                    {
                        field: 'order_cost',
                        title: 'Amount',
                        align: 'center',

                    },
                    {
                        field: 'moreinfo',
                        title: '<i class="bi bi-info-circle"></i>',
                        formatter: moreDetailsIconFormatter
                    },
                ]
            });
        }

        function dateFormatter(value, row, index){
            options = {
                year: "numeric",
                month: "numeric",
                day: "numeric",
                hour: "numeric",
                minute: "numeric",
                second: "numeric",
                hour12: false,
                timeZone: "Asia/Kolkata",
            };
            date = new Date(Date.parse(row.order_date));
            date = new Intl.DateTimeFormat("en-US", options).format(date);
            return `${date}`;
        }

        function moreDetailsIconFormatter(value,row,index) {
            return `
            <button type="button" onclick="clickOnMoreDetailsIcon(${index})" class="btn btn-warning moreDetailsIcon" data-toggle="modal" data-target="#moreDetailsModal"><i class="bi bi-info-circle"></i></button>`;
        }
        function clickOnMoreDetailsIcon(idx) {
            row = $("#orderDetailsTable").bootstrapTable('getData')[idx];
            $.ajax({
                url: '/WS2.asmx/GetOrderItemList',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({userId: row.user_id }),
                success: function (response) {
                    var list = JSON.parse(response.d); 
                    list = list.filter((el) => {
                        return el.order_id == row.id; 
                    })
                    $("#moreInfoTable").bootstrapTable('load',list);
                }
            })
            $("#orderDetailsTable tbody tr").removeClass("activerow");
            $(this).addClass("activerow");  
            
        }
        function checkboxFormatter(value,row,index) {
            return `<input class="selectOption" value = '${row.id}' type="checkbox" name="selectRowCheckBox"/>`;
        }
      
        function loadTable() {
            $.ajax({
                url: '/WS2.asmx/GetAllOrders',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                success: function (response) {
                    var list = JSON.parse(response.d);
                    $("#orderDetailsTable").bootstrapTable('load', list);
                }
            })
        }
        function filterOrder() {
            $("#allOrders").on("click", () => {
                window.location.reload();
            });
            $("#pendingOrders").on("click", () => {
                $("#orderDetailsTable").bootstrapTable('filterBy', {
                    order_status_id: 100
                });
            });
            $("#outForDelivery").on("click", () => {
                selectedIds = [];
                $("#orderDetailsTable").bootstrapTable('filterBy', {
                    order_status_id: 300
                });
            });
            $("#acceptedOrders").on("click", () => {
                selectedIds = [];
                $("#orderDetailsTable").bootstrapTable('filterBy', {
                    order_status_id: 200
                });
            });
            $("#delivered").on("click", () => {
                selectedIds = [];
                $("#orderDetailsTable").bootstrapTable('filterBy', {
                    order_status_id: 400
                });
            });
            $("#rejected").on("click", () => {
                selectedIds = [];
                $("#orderDetailsTable").bootstrapTable('filterBy', {
                    order_status_id: 700
                });
            });
        }
      
        function handleSelectAllOrders() {
            if ($("#selectAllOrders").is(":checked")){
                $('input[name="selectRowCheckBox"]').prop('checked', true);
            }
            else {
                $('input[name="selectRowCheckBox"]').prop('checked',false);
            }
        }
        function afterGetDetails(data) {
            obj = JSON.parse(data);
            console.log(obj);
            $.each(obj, (idx, value) => {
                item = `<option value=${value.role_Id}>${value.email} (${value.fName})</option>`
                if (value.role_Id == 30) {
                    $("#assignChefOption").append(item);
                }
                else {
                    $("#assignDeliveryOption").append(item);
                }
            });
        }

        function assignOrders() {
            order = {
                chef_id: $("#assignChefOption").val(),
                deliveryGuy_id: $("#assignDeliveryOption").val()
            };
           
            orderJSON = JSON.stringify(order);
            dataToSendJSON = JSON.stringify({
                orderList: orderJSON,
                order_ids: selectedIds
            });
        }
        function afterGetMoreDetails(data) {
            obj = JSON.parse(data);
            $("#moreInfoTable").bootstrapTable("load", obj);
        }
        $(document).ready(() => {
            if (userSessionInfo.roleId == 20) window.location.href = "../Error.aspx";
            registerBootstrapTable("orderDetailsTable");
            registerMoreInfoBootstrapTable();
            filterOrder();
            loadTable()
            $("#selectAllOrders").on("click", () => {
                handleSelectAllOrders();
            });
            $("#acceptOrderBtn").on("click", () => {
              list = []; 
                $('input[name="selectRowCheckBox"]:checked').each(function () {
                    list.push(this.value);
                });
                if (list.length == 0) {
                    displayMsg("No order selected");
                }
                else {

                    listJSON = JSON.stringify(list);
                    $.ajax({
                        url: '/WS2.asmx/AcceptOrders',
                        type: "POST",
                        contentType: 'application/json;charset=utf-8',
                        dataType: "json",
                        data: JSON.stringify({ orders: listJSON }),
                        success: function (response) {
                            if (response)
                            window.location.reload();
                        }
                    })
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Sidebar" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">

        <div class="cont">
            <h2>Order Details</h2>
        </div>
        <div class="filter">
            <input type="radio" id="allOrders" name="all" checked="checked"/>
            <label for="allOrders" class="cont">All</label>
            <input type="radio" id="pendingOrders" name="all" />
            <label for="pendingOrders" class="cont">Pending for Approval</label>
            <input type="radio" id="acceptedOrders" name="all" />
            <label for="acceptedOrders" class="cont">Accepted Orders</label>
            <input type="radio" id="outForDelivery" name="all" />
            <label for="outForDelivery" class="cont">Out for Delivery</label>
            <input type="radio" id="delivered" name="all" />
            <label for="delivered" class="cont">Delivered</label>
            <input type="radio" id="rejected" name="all" />
            <label for="rejected" class="cont">Rejected</label>
        </div>
        <div class="table-responsive">
            <table id="orderDetailsTable">               
            </table>
            <div class="cont">
                <button type="button" class="btn btn-info" id="acceptOrderBtn">Accept Orders</button>
            </div>
        </div>
        
    </div>
    <%-- More Details Order --%>
    <div class="modal fade" id="moreDetailsModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog  modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">

                <h3 class="modal-title" id="">More Info</h3>

                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body">
                
                
                <button type="button" class="btn-sm btn-info" id="orderDetailsInfoBtn">Order Details</button>
                <div class="card cont d-none" id="orderDeatilsInfoDiv">

                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">Order ID</label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="orderIdInput" class="orderDetailsInput" disabled />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">User ID</label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="userIdInput" class="orderDetailsInput" disabled />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">User Name</label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="userNameInput" class="orderDetailsInput" disabled />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">Order Status</label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="orderStatusInput" class="orderDetailsInput" disabled />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">Delivery Address Details</label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="addressInput" class="orderDetailsInput" disabled />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">Amount Paid </label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="amountInput" class="orderDetailsInput" disabled />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">Transaction ID</label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="orderTransactionId" class="orderDetailsInput" disabled />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-sm-5">
                            <label class="form-group">Payer ID</label>
                        </div>
                        <div class="col-sm-7">
                            <input value="" id="payerId" class="orderDetailsInput" disabled />
                        </div>
                    </div>
                </div>
            </div>
            <div class="table-responsive" id="moreDetailsTableDiv">
                <table id="moreInfoTable">
                </table>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
</asp:Content>
