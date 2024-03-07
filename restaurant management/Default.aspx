<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="restaurant_management._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Purchase past exam questions</h2>
<asp:Label ID="lblQuantity" runat="server" Text="Quantity at £10 each" AssociatedControlID="ddlExamQuantity">

</asp:Label>
<asp:DropDownList ID="ddlExamQuantity" runat="server">
<asp:ListItem>1</asp:ListItem>
<asp:ListItem>2</asp:ListItem>
<asp:ListItem>3</asp:ListItem>
    </asp:DropDownList>
<p>Postage and packaging charges of £3.95 will be applied to your order</p>
    <p>&nbsp;</p>
<asp:Button ID="Button1" runat="server" Text="Buy Now" onclick="ButtonClick"/>
</asp:Content>
