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

/* Style for the modal body */
.modal-body {
    background-color: #f8f9fa;
    padding: 30px;
    border-radius: 10px;
}

/* Style for the title */
.modal-title {
    color: #343a40;
    font-size: 24px;
}

/* Style for the close button */
.close {
    color: #6c757d;
    font-size: 24px;
}

/* Style for the reason input container */
#reasonInput {
    margin-top: 20px;
}

/* Style for the textarea */
textarea {
    width: 100%;
    height: 100px;
    padding: 12px;
    border: 1px solid #ced4da;
    border-radius: 6px;
    resize: none;
    font-size: 16px;
    background-color: #f8f9fa;
    transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

/* Style for the textarea focus */
textarea:focus {
    border-color: #4e73df;
    outline: 0;
    box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
}

/* Style for the modal footer */
.modal-footer {
    justify-content: flex-end;
    border-top: none;
    padding-top: 20px;
}

/* Style for the close button in the modal footer */
.modal-footer .btn-secondary {
    background-color: #6c757d;
    color: #fff;
    border: none;
    padding: 12px 24px;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

/* Style for the close button on hover */
.modal-footer .btn-secondary:hover {
    background-color: #5a6268;
}

/* Style for the modal content */
.modal-content {
    border: none;
    background: linear-gradient(to bottom, #ffffff, #f8f9fa);
    box-shadow: 0px 0px 40px 0px rgba(0, 0, 0, 0.1);
}

/* Style for the modal dialog */
.modal-dialog {
    max-width: 800px;
}

/* Style for the modal header */
.modal-header {
    border-bottom: none;
    padding-bottom: 0;
}

</style>
    <script>
        var itemList; 
        var refundObj = {}
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
                clickToExpand: true, 
                columns:
                    [
                        {
                            field: 'id',
                            title: 'Order ID',
                            detailFormatter: idFormatter,
                            
                        },
                        {
                            field: 'order_cost',
                            title: 'Cost',    
                            detailFormatter: idFormatter,
                        },
                        {
                            field: 'address',
                            title: 'Delivery Address',
                            detailFormatter: idFormatter,
                        },
                        {
                            field: 'order_status',
                            title: 'Order Status',
                            detailFormatter: idFormatter,
                        },
                       
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
                    ar = 
                    $("#orderTable").bootstrapTable('load', orderList);                 
                }
            })
        }

        function idFormatter(idx) {
            $table = $("#orderTable");
            let row = $table.bootstrapTable('getData')[idx];
            
            items = itemList.filter((val) => {
               return val.order_id == row.id;
            })     
            const orderContainer = $('<div class="container"></div>');
            const list = $('<ul><li><div class="item-container"><span>Name</span><span>Quantity</span><span>Price</span></ul>');
           
            items.forEach((item, index) => {
                console.log(item)
                var itemHTML = '<li><div class="item-container"><span>'
                    + item.name + '</span><span>' + item.qty +
                    '</span><span>' + item.cost;
                if (row.order_status_id == 400 )
                {
                    if (item.status_id == 0)
                        itemHTML += `</span><button type ="button" class="refund" id=${item.id} data-toggle="modal" data-target="#refundModal">Refund</button></div></li>`;
                    else if (item.status_id == 600)
                        itemHTML += `</span><button type ="button" class="refund btn btn-primary" id=${item.id} disabled>Initiated</button></div></li>`;
                    else if (item.status_id == 700)
                        itemHTML += `</span><button type ="button" class="refund btn btn-success" id=${item.id} disabled>Received Refund</button></div></li>`;
                }
                list.append(itemHTML);
            });
            orderContainer.append(list);  
           
            return orderContainer.html();
        }

        function handleRefund() {
            let reason = $("#reasonInput").val();
            refundObj.reason = reason;
            refundObj.email = userSessionInfo.email;
            refundObjJSON = JSON.stringify(refundObj);
            $.ajax({
                url: '../WS2.asmx/InitiateRefund',
                type: "POST",
                contentType: 'application/json;charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ ob: refundObjJSON }),
                success: function (response) {
                    
                }
            })
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
            $(document).on('click', '.refund', function () {
                var itemId = $(this).attr('id');
                var itemDetail = itemList.find((val) => val.id == itemId);
                refundObj.item = itemDetail; 
            });         
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

    <div class="modal fade" id="refundModal" tabindex="-1" role="dialog" aria-labelledby="refundModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="refundModalLabel">Make a Search</h3>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <h2 >Refund Request</h2>
                <p>Kindly enter reason of refund</p>
                <div >
                     <textarea id="reasonInput"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="handleRefund()">Submit</button>
                <button type="button" class="btn btn-dark" data-dismiss="modal" >Close</button>
            </div>
        </div>
    </div>
</div>
</asp:Content>
