<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="restaurant_management.Customers.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .userp {
            padding: 2vh;
            margin-left: auto;
        }

        .form-control {
            max-width: 600px;
        }



        .card-container {
            max-width: 500px;
            margin: 0 auto;
            margin-top: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .edit-icon {
            float: right;
            margin-top: -40px;
            margin-right: -10px;
            cursor: pointer;
        }

        .form-group {
            margin-bottom: 20px;
        }

        #sidebarlist {
            list-style-type: none;
            margin-top: 20px;
            padding-left: 0;
        }

            #sidebarlist li {
                cursor: pointer;
                background-color: rgb(144, 144, 144);
                padding: 10px;
                margin-bottom: 10px;
                border-radius: 5px;
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            }
    </style>

    <script>
        $(document).ready(function () {
            if (userSessionInfo.userId == 0) window.location.href = "/Admin/Login";
            loadUserData();
            loadAddresses();
            urlhash = window.location.hash;

            $("#basicInfoOption").on("click", () => {
                $("#basicdetails").show();
                $("#addresscontainer").hide();
                $("#updatePwd").hide();
            });

            $("#addressOption").on("click", () => {
                $("#addresscontainer").show();
                $("#basicdetails").hide();
                $("#updatePwd").hide();
            });
            $("#passwordOption").on("click", () => {
                $("#addresscontainer").hide();
                $("#basicdetails").hide();
                $("#updatePwd").show();
            });
            if (urlhash == "#address") {
                $("#addressOption").click();
            }

            $("#pwdBtn").on('click', function () {
                let oldPwd = $('#editPwd').val();
                let newPwd = $('#editNewPwd').val();
                let cnfPwd = $('#cnfNewPwd').val();
                let msgBox = $('#msgBox');
                if (oldPwd == '' || newPwd == '' || cnfPwd == '') {
                    msgBox.text('Empty fields are not allowed');
                }
                else if (newPwd != cnfPwd) {
                    msgBox.text('New Password and Confirm Password are not same');
                }
                data = {
                    oldPwd: oldPwd,
                    newPwd: newPwd,
                    email: userSessionInfo.email
                }
                dataJson = JSON.stringify(data);
                $.ajax({
                    url: '../WS.asmx/SetUserPwd',
                    type: "POST",
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data: JSON.stringify({ userData: dataJson }),
                    success: function (res) {
                        if (res.d)
                            msgBox.text('Password Updated Successfully');
                        else {
                            msgBox.text('Wrong Password Entered');
                        }
                    }
                })
                setTimeout(() => {
                    msgBox.text('');
                }, 2000)
            })

            $("#editbtn").on('click', () => {
                $("#editfname").removeAttr('disabled');
                $("#editlname").removeAttr('disabled');
                $("#editcontact").removeAttr('disabled');
                $("#editbtn").hide();
                $("#savebtn").show();
            })

            $("#savebtn").on('click', () => {
                $fname = $("#editfname");
                $lname = $("#editlname");
                $phone = $("#editcontact");

                data = {
                    id: userSessionInfo.userId,
                    fname: $fname.val(),
                    lname: $lname.val(),
                    phone: $phone.val()
                }

                dataJson = JSON.stringify(data);
                $.ajax({
                    url: '../WS.asmx/UpdateUserDetails',
                    type: "POST",
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data: JSON.stringify({ UserDetails: dataJson }),
                    success: function (res) {
                        displayMsg("Details updated successfully");
                        loadUserData();
                    }
                })
                $fname.attr('disabled', true); 
                $lname.attr('disabled', true); 
                $phone.attr('disabled', true); 
                $("#editbtn").show();
                $("#savebtn").hide();
            })
        })

        function registerBootstrapTable(dataList) {
            $('#addresstable').bootstrapTable({
                cache: true,
                striped: false,
                searchable: true,
                pagination: true,
                editable: true,
                search: true,
                showColumns: true,
                sidePagination: "server",
                showSave: false,
                columns: [
                    {
                        field: 'fname',
                        title: 'First Name',
                        align: 'center',
                        formatter: `<labal> ${fname}`
                    },
                    {
                        field: 'lname',
                        title: 'Last Name',
                        align: 'center',
                    },
                    {
                        field: 'email',
                        title: 'Email',
                        align: 'center',
                    },
                    {
                        field: 'role',
                        title: 'Role',
                        align: 'center',
                    },
                ]
            });
        }

        function loadUserData() {
            $.ajax({
                url: '../WS.asmx/UserData',
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ id: userSessionInfo.userId }),
                success: function (res) {
                    data = JSON.parse(res.d);
                    console.log(data);
                    $("#editfname").val(data.fname);
                    $("#editlname").val(data.lname);
                    $("#editcontact").val(JSON.parse(data.phone));
                }
            })
        }

        function loadAddresses() {
            $.ajax({
                url: '../WS.asmx/GetAddresses',
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ userId: userSessionInfo.userId }),
                success: function (res) {
                    let adrData = JSON.parse(res.d);
                    $("#useraddress").bootstrapTable('load', adrData);
                }
            })
            $("#useraddress").bootstrapTable({
                cache: true,
                striped: true,
                pagination: true,
                editable: true,
                sidePagination: 'client',
                useRowAttrFunc: true,
                pageSize: 10,
                pageList: [10, 20, 50],
                maintainSelected: true,
                search: false,
                showColumns: false,
                showSave: false,
                columns: [
                    {
                        field: 'address',
                        title: 'Address',
                    },

                    {
                        field: 'delete',

                        formatter: `<button type = "button" class="btn-delete btn-danger" >Delete</button>`,
                        events: {
                            'click .btn-delete': function (e, value, row, index) {

                                $.ajax({
                                    type: 'POST',
                                    url: '../WS.asmx/DeleteAddress',
                                    contentType: 'application/json; charset=utf-8',
                                    data: JSON.stringify({ addressId: row.id }),
                                    dataType: 'json',
                                    success: function (res) {
                                        if (res.d) {
                                            displayMsg("Address Deleted successfully!!");
                                            loadTable(userId);

                                        }

                                    },
                                    error: function () {
                                        console.log('error occured');
                                    }

                                })
                                $('#useraddress').bootstrapTable('remove', {
                                    field: 'id',
                                    values: [row.id]
                                });

                            }
                        }
                    }
                ]

            });
        }

        function saveAddress() {
            addressData = $("#editadd1").val() + " " +
                $("#editadd2").val() + " " +
                $("#editadd3").val() + " " +
                $("#editadd5").val() + " " +
                $("#editadd6").val() + " " + $("#editadd4").val();
            console.log(addressData);
            $.ajax({
                url: '../WS.asmx/AddAddress',
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ userId: userSessionInfo.userId, address: addressData }),
                success: function (res) {
                    displayMsg("New Address saved");
                    loadAddresses();
                }
            })
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Sidebar" runat="server">

    <li id="basicInfoOption">Personal Info</li>
    <li id="addressOption">Address</li>
    <li id="passwordOption">Update Password</li>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">


    <div class="card-container" id="basicdetails">
        <h2>Edit Profile</h2>
        <div class="form">
            <div class="row">

                <div class="form-group">
                    <label for="editfname" class="form-label">First Name</label>
                    <input class="form-control edit" id="editfname" type="text" placeholder="First Name" disabled />
                </div>
                <div class="form-group">
                    <label for="editlname" class="form-label">Last Name</label>
                    <input class="form-control edit" id="editlname" type="text" placeholder="Last Name" disabled />
                </div>
                <div class="form-group">
                    <label for="editContact" class="form-label">Contact details</label>
                    <input class="form-control edit" id="editcontact" type="number" value="" placeholder="Phone Number" disabled />
                </div>

                <div class="form-group">
                    <button type="button" class="btn btn-primary" id="editbtn">Edit Details</button>
                    <button type="button" class="btn btn-success" id="savebtn" style="display: none">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div class="card-container" id="updatePwd" style="display: none">
        <h2>Change Password</h2>
        <div class="form">
            <div class="row">

                <div class="form-group">
                    <label for="editfname" class="form-label">Old Password</label>
                    <input class="form-control edit" id="editPwd" type="password" />
                </div>
                <div class="form-group">
                    <label for="editlname" class="form-label">New Password</label>
                    <input class="form-control edit" id="editNewPwd" type="password" />
                </div>
                <div class="form-group">
                    <label for="editContact" class="form-label">Confirm Password</label>
                    <input class="form-control edit" id="cnfNewPwd" type="password" value="" />
                </div>

                <div class="form-group">
                    <button type="button" class="btn btn-primary" id="pwdBtn">Submit</button>
                    <a href="/Admin/ForgetPassword.aspx">Forget Password?</a>
                </div>
            </div>
        </div>
        <div id="msgBox"></div>
    </div>

    <div class="container" id="addresscontainer" style="display: none">
        <h2>Saved Addresses</h2>

        <table id="useraddress">
            <thead></thead>
            <tbody></tbody>
        </table>
        <button type="button" data-target="#addressModal" data-toggle="modal">Add New Address</button>
    </div>
    <div class="modal fade" id="addressModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="editModalLabel">Add new Address</h3>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Address Details:</label>
                        <div class="input-group">
                            <input class="form-control edit" id="editadd1" type="text" placeholder="House No./Flat No." />
                            <input class="form-control edit" id="editadd2" type="text" placeholder="Colony/Society/Locality" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <input class="form-control edit" id="editadd3" type="text" placeholder="City" />
                            <input class="form-control edit" id="editadd4" type="text" placeholder="PinCode" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <input class="form-control edit" id="editadd5" type="text" placeholder="State" />
                            <input class="form-control edit" id="editadd6" type="text" placeholder="Country" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button id="saveaddress" data-dismiss="modal" type="button" class="btn btn-primary" onclick="saveAddress()">Save changes</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
