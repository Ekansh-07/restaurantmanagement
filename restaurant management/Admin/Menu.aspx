<%@ Page Title="" Language="C#" Async="true" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Menu.aspx.cs" Inherits="restaurant_management.Menu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Script" runat="server">
    <style>
        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }


    </style>
    <script>
        var tempStorage;
        $(document).ready(function () {
            if (userSessionInfo.roleId == 0) window.location.href = "../Admin/Login";
            makeTable();
            loadTable();
            if (userSessionInfo.roleId == 30) { 
                $("#btnAdd").show();
                $("#searchToggle").show();
            }
            $('#handlesearch').on('keypress', (e) => {
                let key = e.key;
                if (key != null && key.toLowerCase() == 'enter') {
                    e.preventDefault();
                    getSearched();
                }
            })
            $("#searchToggle").on('click', () => {
                $("#searchItem").val('');
                $("#searchResTable").bootstrapTable('removeAll');
                $("#rname").val('');
                $("#rdes").val('');
                $("#rprice").val('');               
                $('[name="roption"]').val().prop('checked', false);
                $("#dishImage").val('');                
            })
        })

        function loadTable() {
            $.ajax({
                url: '../WS.asmx/GetDishes',
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                success: function (response) {
                    var menuList = JSON.parse(response.d);
                    $("#menu").bootstrapTable('load', menuList);
                }
            })
        }


        function makeTable() {
            $("#menu").bootstrapTable({
                height: "500",
                cache: true,
                striped: true,
                pagination: true,
                clickToEdit: true,
                sidePagination: 'client',
                useRowAttrFunc: true,
                pageSize: 10,
                pageList: [10, 20, 50],
                maintainSelected: true,
                search: false,
                showColumns: false,
                showSave: false,
                classes: 'table table-borderless',
                columns: [
                    {
                        field: 'name',
                        title: 'Dish Name',
                        width: "200"
                    },
                    {
                        field: 'image_url',
                        title: 'Image',
                        formatter: function (value, row, index) {
                            return '<img src="' + value + '" width="200" height="200">'
                        }
                    },
                    {
                        field: 'description',
                        title: 'Description',
                        width: "40",
                        widthUnit: "%",
                        editable: {
                            type: 'text',
                            title: 'Enter Title',
                            validate: function (value) {
                                if (!value) {
                                    return 'Title is required';
                                }
                            }
                        }
                    },
                    {
                        field: 'price',
                        title: 'Price',
                        width: "150",
                    },
                    {
                        field: 'status',
                        title: 'Status'
                    },
                    {
                        field: 'ChefDel',
                        title: '',
                        formatter: chefDelFormatter,
                        visible: userSessionInfo.roleId == 30
                    },
                    {
                        field: 'adminConfirm',
                        title: '',
                        formatter: confirmFormatter,
                        visible: userSessionInfo.roleId == 10
                    },
                    {
                        field: 'adminReject',
                        title: '',
                        formatter: rejectFormatter,
                        visible: userSessionInfo.roleId == 10
                    }

                ]

            });

            $("#searchResTable").bootstrapTable({
                height: 600,
                width: 600,
                cache: true,
                pagination: true,
                columns: [
                    {
                        field: 'title',
                        title: 'Name',
                    },
                    {
                        field: 'image',
                        title: '',
                        formatter: function (value, row, index) {
                            return '<img src="' + value + '" width="200" height="200">'
                        }
                    },
                    {
                        field: 'Add',
                        title: '',
                        formatter: btnFormatter
                    }
                ]
            })

        }

        function btnFormatter(val, row, idx) {
            return `<button type="button" class= "btn btn-success" data-toggle="modal" data-target="#recipeModal" onclick= searchAdd(${idx})>Get Information</button>`
        }

        function chefDelFormatter(val, row, idx) {
            if (row.status_id == 20)
                return `<button type="button" class= "btn btn-warning" onclick = "handleChefDelete(${idx})">Revoke</button>`
            else
                return `<button type="button" class= "btn btn-danger" onclick = "handleChefDelete(${idx})">Delete</button>`
        }

        function confirmFormatter(val, row, idx) {
            if (row.status_id != 30)
                return `<button type="button" class= "btn btn-primary" onclick = "handleAdminConfirm(${idx})">Approve</button>`
            else
                return `<button type="button" class= "btn btn-primary" data-toggle="modal" data-target="#recipeModal" onclick = "handleAdminEdit(${idx})">Edit</button>`
        }

        function rejectFormatter(val, row, idx) {
            if (row.status_id != 30)
                return `<button type="button" class= "btn btn-danger" onclick = "handleAdminReject(${idx})">Reject</button>`
            else
                return `<button type="button" class= "btn btn-primary" onclick = "handleAdminReject(${idx})">Delete</button>`

        }
        function searchAdd(idx) {
            let row = $("#searchResTable").bootstrapTable('getData')[idx];

            $.ajax({
                url: '../WS.asmx/GetRecipeInfo',
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ id: row.id }),
                success: function (response) {
                    data = JSON.parse(response.d);
                    console.log(data);
                    $("#rname").val(data.title);
                    $("#rdes").val(data.summary);
                    $("#rprice").val(data.pricePerServing);
                    let rval = data.vegetarian ? 10 : 20;
                    $('input:radio[value=' + rval + ']').prop('checked', true);
                    $("#dishImage").val(row.image);                
                }
            })
        }
        function handleAdd() {
            recipe = {
                name: $("#rname").val(),
                description: $("#rdes").val(),
                price: $("#rprice").val(),
                category_id: $('[name="roption"]').val(),
                image_url: $("#dishImage").val()
            };
            addRecipe(recipe);
        }
        function addRecipe(recipe) {        
            let uri;
            if (userSessionInfo.roleId == 30)
                uri = '../WS.asmx/AddRecipe'
            if (userSessionInfo.roleId == 10) {
                uri = '../WS.asmx/UpdateDishStatus';
                recipe.status_id = tempStorage.status_id;
                recipe.id = tempStorage.id;
            }
            recipeJSON = JSON.stringify(recipe);
            $.ajax({
                url: uri,
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ dish: recipeJSON }),
                success: function (res) {
                    if (res.d) {
                        if (userSessionInfo.roleId == 10)
                            displayMsg("Updated Successfully");
                        else
                            displayMsg("Recipe added. Await confirmation");
                    }
                    loadTable();
                }
            })
        }

        function handleChefDelete(idx) {
            let row = $("#menu").bootstrapTable('getData')[idx];
            uri = '';
            if (row.status_id == 10)
                uri = '../WS.asmx/DeleteDishStatus';
            else if (row.status_id == 30) {
                uri = '../WS.asmx/UpdateDishStatus';
                row.status_id = 20;
            }
            else if (row.status_id == 20) {
                uri = '../WS.asmx/UpdateDishStatus';
                row.status_id = 30;
            }
            dishJSON = JSON.stringify(row);
            $.ajax({
                url: uri,
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ dish: dishJSON }),
                success: function (response) {
                    if (response.d)
                        loadTable();
                }
            })
        }

        function handleAdminConfirm(idx) {
            let uri = '';
            let row = $("#menu").bootstrapTable('getData')[idx];
            if (row.status_id == 10) {
                row.status_id = 30;
                uri = '../WS.asmx/UpdateDishStatus'
            }
            else if (row.status_id == 20) {
                row.status_id = 30;
                uri = '../WS.asmx/DeleteDishStatus'
            }
            dishJSON = JSON.stringify(row);
            $.ajax({
                url: uri,
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ dish: dishJSON }),
                success: function (response) {
                    if (response.d)
                        loadTable();
                }
            })
        }

        function handleAdminReject(idx) {
            let row = $("#menu").bootstrapTable('getData')[idx];
            let uri = '';
            if (row.status_id == 20) {
                row.status_id = 30;
                uri = '../WS.asmx/UpdateDishStatus'
            }

            else if (row.status_id == 10 || row.status_id == 30) {
                uri = '../WS.asmx/DeleteDishStatus'
            }
            dishJSON = JSON.stringify(row);
            $.ajax({
                url: uri,
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ dish: dishJSON }),
                success: function (response) {
                    if (response.d)
                        loadTable();
                }
            })
        }

        function handleAdminEdit(idx) {
            let row = $("#menu").bootstrapTable('getData')[idx];
            tempStorage = $("#menu").bootstrapTable('getData')[idx];

            var recipe = {
                name: $("#rname").val(row.name),
                description: $("#rdes").val(row.description),
                price: $("#rprice").val(row.price),
                category_id: $('[name="roption"]').val(row.category_id),
                image_url: $("#dishImage").val(row.image_url)
            }

        }

        function formatRow(row, index) {
            return {
                classes: 'card mb-3',
                css: { "width": "18rem" },
                onclick: 'console.log("You clicked row ' + index + '")',
                attr: {
                    'data-id': row.id
                }
            };
        }

        function getSearched() {
            dish = $("#searchItem").val();
            $.ajax({
                url: '../WS.asmx/getSearchData',
                type: "POST",
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: JSON.stringify({ query: dish }),
                success: function (response) {
                    console.log(response);
                    data = JSON.parse(response.d);
                    $("#searchResTable").bootstrapTable('load', data.results);
                }
            })
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Sidebar" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mb-5 d-flex flex-column align-items-center justify-content-center">
        <h2>Menu</h2>
        <div id="menuBtns">
        <button id="btnAdd" type="button" class="btn btn-dark" data-toggle="modal" data-target="#recipeModal" style="display: none">Add</button>
        <button type="button" id="searchToggle" class="btn btn-success" data-toggle="modal" data-target="#searchModal" style="display: none">Get Inspired</button>
        </div>
    </div>
    <div class="modal fade" id="searchModal" tabindex="-1" role="dialog" aria-labelledby="searchModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="searchModalLabel">Make a Search</h3>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="handlesearch">
                         <input type="text" id="searchItem" placeholder="Search" />
                         <button type="button" onclick="getSearched()"><i class="fa fa-search"></i></button>
                    </div>
                   

                    <table id="searchResTable">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" >Close</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="recipeModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="editModalLabel">Add new Dish</h3>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <div class="form-group">
                            <label class="form-label">Name:</label>
                            <input class="form-control edit" id="rname" type="text" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description:</label>
                        <input class="form-control edit" id="rdes" type="text" />

                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <input class="" type="radio" name="roption" value="10" />
                        <lable>Veg</lable>
                        <input class="" type="radio" name="roption" value="20" />
                        <lable>Non-Veg</lable>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Price:</label>
                        <input class="form-control edit" id="rprice" type="number" />
                    </div>
                    <div class="form-group">
                        <label for="dishImage">Add image url:</label>
                        <input class="form-control" id="dishImage" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button id="savedish" data-dismiss="modal" type="button" class="btn btn-primary" onclick="handleAdd()">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div id="btable">
        <table id="menu" style=" border-top: 1px solid black;">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
</asp:Content>
