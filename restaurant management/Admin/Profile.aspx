<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="restaurant_management.Admin.Profile" EnableViewState="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">
    <style>
        .container {
        }

        .form-group {
            margin-bottom: 25px;
            width: 600px;
        }
    </style>
    <script>

        function loadRoles() {
            $.ajax({
                url: "/WS.asmx/GetRoles",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                success: function (response) {
                    var dataList = JSON.parse(response.d).filter((val) => val.id != userSessionInfo.roleId);
                    console.log(dataList)
                    dataList.forEach((ob) => {
                        let option = `<option value = ${ob.id}>${ob.role_name}</option> `
                        $("#modRole").append(option);

                    })
                },
                error: function (error) {
                    displayMsg(error.responseText);
                }
            });
        }
        $(document).ready(function () {
            if (userSessionInfo.roleId != 10) window.location.href = "../Customers/Profile.aspx";
            registerBootstrapTable();
            loadTable();
            loadRoles();
        })
        function loadTable() {
            $.ajax({
                url: "/WS.asmx/UsersData",
                type: "POST",
                contentType: "application/json",
                dataType: "json",
                success: function (response) {
                    console.log(userSessionInfo.userId)
                    var dataList = JSON.parse(response.d).filter((val) => val.Id != userSessionInfo.userId);
                    $('#UserList').bootstrapTable('load', dataList);
                },
                error: function (error) {
                    displayMsg(error.responseText);
                }
            });
        }


        function registerBootstrapTable(dataList) {
            $('#UserList').bootstrapTable({
                cache: true,
                striped: false,
                pagination: true,
                editable: true,
                search: true,
                showColumns: true,
                showSave: false,
                columns: [
                    {
                        field: 'fname',
                        title: 'First Name',
                        align: 'center',
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
                    {
                        field: 'Edit',
                        formatter: `<button type="button" class="btn btn-secondary edit" data-target="#editModal" data-toggle="modal">Edit</button>`,
                        events: updateEvent

                    }

                ]
            })
        }
        window.updateEvent = {
            'click .edit': function (e, value, row, index) {
                console.log(row);
                $("#modFname").val(row.fname);
                $("#modLname").val(row.lname);
                $("#modEmail").val(row.email);
                $("#saveChangesButton").off("click").on("click", function () {
                    UserInfo = {
                        Id: row.Id,
                        fname: $("#modFname").val(),
                        lname: $("#modLname").val(),
                        email: $("#modEmail").val(),
                        phone: row.phone,
                        roleId: $("#modRole").val()
                    }

                    UserInfoJSON = JSON.stringify(UserInfo);
                    $.ajax({
                        type: 'POST',
                        url: '/WS.asmx/AssignRole',
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify({ userDetail: UserInfoJSON }),
                        dataType: 'json',
                        success: function (res) {
                            if (res.d)
                                displayMsg("Data Updated successfully");
                            loadTable();
                        },
                        error: function () {
                            console.log('error occured');
                        }
                    })
                })
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container content-body">
        <div class="table-responsive">
            <table class="table table-bordered table-striped" id="UserList">
                <thead>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel">Edit Information</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="modFname">First Name</label>
                        <input type="text" class="form-control" id="modFname">
                    </div>
                    <div class="form-group">
                        <label for="modLname">Last Name</label>
                        <input type="text" class="form-control" id="modLname">
                    </div>
                    <div class="form-group">
                        <label for="modEmail">Email</label>
                        <input type="text" class="form-control" id="modEmail">
                    </div>
                    <div class="form-group">
                        <label for="modRole">Role</label>
                        <select class="form-control" id="modRole">
                        </select>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button id="saveChangesButton" type="button" class="btn btn-primary" data-dismiss="modal">Save changes</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
