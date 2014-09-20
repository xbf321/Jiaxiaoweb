<%@ Page Title="用户登录" Language="C#" MasterPageFile="~/Template/BaseMasterPage.master" %>

<script runat="server">
    private string _returnUrl = string.Empty;
    protected string _userName = string.Empty;
    private DateTime _expiresTime = DateTime.Now.AddDays(1);
    protected void Page_Load(object sender, EventArgs e)
    {
        _returnUrl = Jiaxiaoweb.Common.ReedRequest.GetQueryString("ReturnUrl");


        if (Page.Request.Cookies["UserEmail"] != null)
        {
            _userName = Request.Cookies["UserEmail"].Value;
        }

        if (!string.IsNullOrEmpty(Request.Form["txtRegEmail"]) && !string.IsNullOrEmpty(Request.Form["txtRegPwd"]))
        {
            //注册
            string email = Request.Form["txtRegEmail"];
            string password = Request.Form["txtRegPwd"];

            if (Jiaxiaoweb.Data.MemberRepository.IsExists(email))
            {
                this.ltMessageInfo.Text = "<div class=\"error_msg\">该用户已存在,请选择其他用户名!</div>";
                return;
            }
            else
            {
                Jiaxiaoweb.Data.MemberRepository.CreateMember(email, password);

                //登录
                LoginToCookie(email);
                if (string.IsNullOrEmpty(_returnUrl))
                {
                    Response.Redirect("/");
                }
                else
                {
                    Response.Redirect(_returnUrl);
                }
            }
        }
        if (!string.IsNullOrEmpty(Request.Form["txtLoginEmail"]) && !string.IsNullOrEmpty(Request.Form["txtLoginPwd"]))
        {
            //登录
            string email = Request.Form["txtLoginEmail"];
            string password = Request.Form["txtLoginPwd"];
            if (!Jiaxiaoweb.Data.MemberRepository.IsExists(email))
            {
                this.ltMessageInfo.Text = "<div class=\"error_msg\">该用户不存在,请重试!</div>";
                return;
            }
            else
            {
                if (Jiaxiaoweb.Data.MemberRepository.ValidatorMember(email, password))
                {
                    LoginToCookie(email);
                    if (string.IsNullOrEmpty(_returnUrl))
                    {
                        Response.Redirect("/");
                    }
                    else
                    {
                        Response.Redirect(_returnUrl);
                    }
                }
                else
                {
                    this.ltMessageInfo.Text = "<div class=\"error_msg\">密码错误,请重试!</div>";
                    return;
                }
            }
        }
    }
    protected void LoginToCookie(string email)
    {
        FormsAuthenticationTicket Ticket = new FormsAuthenticationTicket(1, email, DateTime.Now, _expiresTime, true, email, FormsAuthentication.FormsCookiePath);
        string HashTicket = FormsAuthentication.Encrypt(Ticket);

        HttpCookie lcookie = new HttpCookie(FormsAuthentication.FormsCookieName, HashTicket);
        lcookie.Expires = _expiresTime;
        //lcookie.Domain = FormsAuthentication.CookieDomain;
        Response.Cookies.Add(lcookie);

        //记录相关信息
        if (Page.Request.Cookies["UserEmail"] == null)
        {
            HttpCookie userinfo = new HttpCookie("UserEmail", email);
            userinfo.Expires = _expiresTime;
            Page.Response.Cookies.Add(userinfo);
        }
        else
        {
            Response.Cookies["UserEmail"].Value = email;
            Response.Cookies["UserEmail"].Expires = _expiresTime;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        
        .login_warpper
        {
        }
        .input_01
        {
            border: 1px solid #84a1bd;
            padding: 0px;
            height: 22px;
            line-height: 22px;
        }
        .login_left
        {
            margin-top: 10px;
        }
        .login_right
        {
            margin-top: 10px;
        }
        .login_left h2
        {
            margin-left: 20px;
            margin-bottom: 20px;
            font-weight: bolder;
            font-size: 14px;
        }
        .login_right h2
        {
            margin-left: 20px;
            margin-bottom: 20px;
            font-weight: bolder;
            font-size: 14px;
        }
        .login_child
        {
            height: 45px;
            overflow: hidden;
            width: 250px;
            padding: 0 55px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" runat="Server">
    <div class="rc_title">
        &gt;&gt; 用户登录</div>
    <div class="login_warpper">
        <asp:Literal ID="ltMessageInfo" runat="server"></asp:Literal>
        <form method="post" onsubmit="return checkRegister();">
        <div class="login_left l">
            <h2>
                注册</h2>
            <div class="login_child">
                &nbsp;&nbsp;&nbsp;Email：
                <input type="text" id="txtRegEmail" name="txtRegEmail" class="input_01" /></div>
            <div class="login_child">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;密码：<input type="password" id="txtRegPwd" name="txtRegPwd"
                    class="input_01" /></div>
            <div class="login_child">
                确认密码：<input type="password" id="txtRegConfirmPwd" name="txtRegConfirmPwd" class="input_01" /></div>
            <div class="login_child">
                <input type="submit" value="注册" /></div>
        </div>
        </form>
        <form method="post" onsubmit="return checkLogin();">
        <div class="login_right r">
            <h2>
                登录</h2>
            <div class="login_child">
                Email：<input type="text" id="txtLoginEmail" name="txtLoginEmail" value="<%=_userName %>"
                    class="input_01" /></div>
            <div class="login_child">
                &nbsp;&nbsp;密码：<input type="password" id="txtLoginPwd" name="txtLoginPwd" class="input_01" /></div>
            <div class="login_child">
                <input type="submit" value="登录" /></div>
        </div>
        </form>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" runat="Server">

    <script type="text/javascript">
        var regEmail = /^[0-9A-Za-z_]+@[0-9A-Za-z-]+(\.[a-zA-Z]+){1,}$/;
        function checkLogin() {
            var $userEmail = $("#txtLoginEmail");
            var $password = $("#txtLoginPwd");
            if ($.trim($userEmail.val()) == "") {
                alert("请输入您的Email!");
                $userEmail.focus();
                return false;
            } else {
                if (!regEmail.test($userEmail.val())) {
                    alert("邮箱地址格式错误");
                    $userEmail.focus();
                    return false;
                }
            }
            if ($.trim($password.val()) == "") {
                alert("请输入您的密码!");
                $password.focus();
                return false;
            }
            return true;
        }
        function checkRegister() {
            var $userEmail = $("#txtRegEmail");
            var $password = $("#txtRegPwd");
            var $confirmPassword = $("#txtRegConfirmPwd");
            if ($.trim($userEmail.val()) == "") {
                alert("请输入您的Email!");
                $userEmail.focus();
                return false;
            } else {
                if (!regEmail.test($userEmail.val())) {
                    alert("邮箱地址格式错误");
                    $userEmail.focus();
                    return false;
                }
            }
            if ($password.val() != $confirmPassword.val()) {
                alert("两次输入的密码不同,请重新输入");
                $password.focus();
                return false;
            }

            return true;
        }
    </script>

</asp:Content>
