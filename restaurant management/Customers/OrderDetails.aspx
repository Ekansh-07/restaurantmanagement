<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDetails.aspx.cs" Inherits="restaurant_management.Customers.OrderDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">
    <style>
body {
  font-family: Arial, sans-serif;
  background-color: #f5f5f5;
}

ul {
  list-style-type: none;
  padding: 0;
}

.item-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 20px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 15px;
}

.item-container span {
  flex: 1;
}

.item-container button {
  background-color: #ff7f50;
  color: #fff;
  border: none;
  padding: 8px 16px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.item-container button:hover {
  background-color: #ff6347;
}

.item-container span:not(:last-child) {
  margin-right: 10px;
}
</style>
    <script>
        var itemList; 
        function makeTable() {
            $("#orderTable").bootstrapTable({
                classes: 'table table-borderless',
                cache: true,
                editable: true,
                sidePagination: 'client',
                pageSize: 10,
                pageList: [10, 20, 50],
                showFooter: true,
                detailView: true,
                detailViewByClick: true,
                detailViewIcon: false,
                columns:
                    [
                        {
                            field: 'id',
                            title: 'Order ID',
                            detailFormatter:idFormatter 
                        },
                        {
                            field: 'order_cost',
                            title: 'Cost',                         
                        },
                        {
                            field: 'address',
                            title: 'Delivery Address'
                        },
                        {
                            field: 'order_status',
                            title: 'Order Status'
                        },
                        //{
                        //    field: 'button1',
                        //    title: '',
                        //    width: "150",
                            
                        //}

                    ]
            });
        }
        function loadTable() {
            $.ajax({
                url: '../WS2.asmx/GetOrderList',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ curUser: userSessionInfo.userId }),
                success: function (response) {
                    var orderList = JSON.parse(response.d);
                    console.log(orderList)
                    $("#orderTable").bootstrapTable('load', orderList);                 
                }
            })
        }

        function idFormatter(idx) {
            let row = $("#orderTable").bootstrapTable('getData')[idx];
            items = itemList.filter((val) => {
               return val.order_id == row.id;
            })     
            const orderContainer = $('<div class="container"></div>');
            const list = $('<ul><li><div class="item-container"><span>Name</span><span>Quantity</span><span>Price</span></ul>');
           
            items.forEach((item, index) => {
                var itemHTML = '<li><div class="item-container"><span>'
                    + item.name + '</span><span>' + item.qty +
                    '</span><span>' + item.cost + '</span><button>Refund</button></div></li>';
                list.append(itemHTML);
            });
            orderContainer.append(list);
            return orderContainer.html();
        }

        $(document).ready(function () {
            makeTable();
            loadTable();
            $.ajax({
                url: '../WS2.asmx/GetOrderItemList',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ userId: userSessionInfo.userId }),
                success: function (response) {
                    itemList = JSON.parse(response.d);
                    console.log(itemList)

                }
            })
        })
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
