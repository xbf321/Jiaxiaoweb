<%@ Page Title="" Language="C#" MasterPageFile="~/Template/BaseMasterPage.master" %>

<script runat="server">
    protected string _returnUrl = "/";
    protected void Page_Load() {
        _returnUrl = Jiaxiaoweb.Common.ReedRequest.GetQueryString("ReturnUrl");
        FormsAuthentication.SignOut();
        Response.Redirect(_returnUrl);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" Runat="Server">
</asp:Content>

