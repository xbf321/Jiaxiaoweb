<%@ Page Title="我的错题集" Language="C#" MasterPageFile="~/Template/BaseMasterPage.master" %>

<script runat="server">
    private int action = 1;
    protected const string COOKIENAME = "ErrorLibrary";
    protected void Page_Load(object sender, EventArgs e)
    {
        action = Jiaxiaoweb.Common.ReedRequest.GetQueryInt("action", 1);
        if (action > 2 || action < 0)
        {
            action = 1;
        }

        if (action == 1)
        {
            //本机错题
            if (HttpContext.Current.Request.Cookies[COOKIENAME] != null)
            {
                string[] _myErrorLibraryQuestionIds = HttpContext.Current.Request.Cookies[COOKIENAME]["myErrorLibraryQuestionId"].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                System.Collections.Generic.List<int> questionIds = new System.Collections.Generic.List<int>();
                foreach (string s in _myErrorLibraryQuestionIds)
                {
                    if (!string.IsNullOrEmpty(s))
                    {
                        int q = Convert.ToInt32(s);
                        if (q > 0)
                        {
                            questionIds.Add(q);
                        }
                    }
                }

                System.Collections.Generic.IList<Jiaxiaoweb.Entities.ExamQuestion> examQuestionList = new System.Collections.Generic.List<Jiaxiaoweb.Entities.ExamQuestion>();

                Jiaxiaoweb.Entities.ExamQuestion examQuestion = null;
                foreach (int q in questionIds)
                {
                    examQuestion = Jiaxiaoweb.Data.ExamQuestionRepository.GetExamQuestionByQuestionId(q);
                    if (examQuestion != null)
                    {
                        examQuestionList.Add(examQuestion);
                    }
                }

                rptLocalErrorLibraryList.DataSource = examQuestionList;
                rptLocalErrorLibraryList.DataBind();

            }
        }
        if (action == 2)
        {
            //网络错题
            if (Request.IsAuthenticated)
            {
                Jiaxiaoweb.Entities.Member member = Jiaxiaoweb.Data.MemberRepository.MemberInfo(User.Identity.Name);
                this.rptWebErrorLibraryList.DataSource = Jiaxiaoweb.Data.ExamQuestionRepository.GetErrorLibraryQuestionList(member.UserID);
                this.rptWebErrorLibraryList.DataBind();
            }
        }
    }
    protected string GetAnswerList(object o)
    {
        StringBuilder sbText = new StringBuilder();
        System.Collections.Generic.IList<Jiaxiaoweb.Entities.ExamAnswer> answerList = o as System.Collections.Generic.IList<Jiaxiaoweb.Entities.ExamAnswer>;
        if (o != null)
        {
            foreach (Jiaxiaoweb.Entities.ExamAnswer item in answerList)
            {
                sbText.AppendFormat("{0}<br />", item.AnswerName);
            }
        }
        return sbText.ToString();
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .desc
        {
            padding: 5px;
            margin-left: 23px;
        }
        .error_operate_nav
        {
            margin-bottom: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" runat="Server">
    <div class="rc_title">
        &gt;&gt; 我的错题集:</div>
    <div class="tab_nav">
        <ul>
            <li class="<%= action==1 ?"on":"off" %>"><a href="?action=1">本机错题</a></li>
            <li class="<%= action==2 ?"on":"off" %>"><a href="?action=2">网络错题</a></li>
        </ul>
    </div>
    <%if (action == 1)
      {%>
    <div class="desc">
        本机错题集是存储在你当前使用的计算机上的错题集，换了计算机这些错题集就会看不到了。
        <br />
        <%--您的本机错题集最后一次更新的时间是:2009-09-17 17:45:28<br />--%>
        错题数：<span id="span_ErrorLibraryCount"><%=this.rptLocalErrorLibraryList.Items.Count%></span>题</div>
    <div class="error_operate_nav">
        <a href="javascript:void(0);" onclick="deleteAll();">清空我的所有错题集</a>
    </div>
    <table cellspacing="0" cellpadding="5" bordercolor="#888888" width="100%" bgcolor="#ffffff"
        border="1" id="error_table">
        <tr bgcolor="#f2f2f2" height="25" align="center">
            <td width="35">
                <b>序号</b>
            </td>
            <td>
                <b>试题内容</b>
            </td>
            <td width="55">
                <b>标准答案</b>
            </td>
            <td width="55">
                <b>操作</b>
            </td>
        </tr>
        <asp:Repeater ID="rptLocalErrorLibraryList" runat="server">
            <ItemTemplate>
                <tr id="Tr_<%#Eval("QuestionID") %>">
                    <td align="center">
                        <%#Container.ItemIndex + 1 %>
                    </td>
                    <td>
                        <div class="l" style="margin: 10px 0px 10px 10px;">
                            <%#Eval("QuestionName") %><br />
                            <%#GetAnswerList(Eval("AnswerList"))%>
                        </div>
                        <div class="r">
                            <%#Eval("QuestionPhoto") %>
                        </div>
                        <div class="clear">
                        </div>
                        <div style="margin: 0px 10px 10px 10px; padding: 10px; background-color: #f2f2f2;">
                            <b>本题分析：</b><br />
                            <%#Eval("QuestionRemark") %>
                        </div>
                    </td>
                    <td align="center">
                        <%#Eval("RightAnswerString")%>
                    </td>
                    <td align="center">
                        <a href="javascript:void(0);" onclick="d('<%#Eval("QuestionID") %>')">删掉</a>
                    </td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
    </table>
    <%}
      else
      { %>
    <div class="desc">
        网络错题集是存储在网站服务器上的错题集，换了计算机这些错题集照样存在，可以看得到。<br />
        错题数：<span id="span_ErrorLibraryCount"><%=this.rptWebErrorLibraryList.Items.Count%></span>题</div>
    <%if (Request.IsAuthenticated)
      {%>
    <table cellspacing="0" cellpadding="5" bordercolor="#888888" width="100%" bgcolor="#ffffff"
        border="1" id="error_table">
        <tr bgcolor="#f2f2f2" height="25" align="center">
            <td width="35">
                <b>序号</b>
            </td>
            <td>
                <b>试题内容</b>
            </td>
            <td width="55">
                <b>标准答案</b>
            </td>
            <td width="55">
                <b>操作</b>
            </td>
            <asp:Repeater ID="rptWebErrorLibraryList" runat="server">
                <ItemTemplate>
                    <tr id="Tr_<%#Eval("QuestionID") %>">
                        <td align="center">
                            <%#Container.ItemIndex + 1 %>
                        </td>
                        <td>
                            <div class="l" style="margin: 10px 0px 10px 10px;">
                                <%#Eval("QuestionName") %><br />
                                <%#GetAnswerList(Eval("AnswerList"))%>
                            </div>
                            <div class="r">
                                <%#Eval("QuestionPhoto") %>
                            </div>
                            <div class="clear">
                            </div>
                            <div style="margin: 0px 10px 10px 10px; padding: 10px; background-color: #f2f2f2;">
                                <b>本题分析：</b><br />
                                <%#Eval("QuestionRemark") %>
                            </div>
                        </td>
                        <td align="center">
                            <%#Eval("RightAnswerString")%>
                        </td>
                        <td align="center">
                            <a href="javascript:void(0);" onclick="d('<%#Eval("QuestionID") %>')">删掉</a>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tr>
    </table>
    <%}
      else
      { %>
    <div class="error_msg">
        使用网络错题集，需要您先登录后方可使用；<br />
        点击<a href="javascript:login()">这里</a>登录</div>
    <%} %>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" runat="Server">

    <script type="text/javascript">
        function d(q) {
            if (!window.confirm('确定要删除该错题纪录吗?\r\n注意：\r\n『如果您没有登录,就会删除本机错题纪录,否则则删除网络错题纪录!』\r\n请谨慎操作!')) {
                return;
            }
            var $ErrorCount = $('#span_ErrorLibraryCount');
            var $Tr = $("#Tr_" + q);
            var c = parseInt($ErrorCount.text());
            c = c - 1;
            $ErrorCount.text(c);
            $Tr.hide();
            deleteErrorLibrary(q);

        }
        function deleteAll() {
            if (!window.confirm('确定要删除所有的错题纪录吗?\r\n注意：\r\n『如果您没有登录,就会删除本机所有错题纪录,否则则删除所有网络错题纪录!』\r\n请谨慎操作!')) {
                return;
            }

            $('#span_ErrorLibraryCount').text(0);
            $('#error_table').hide();

            deleteErrorLibrary();
        }
    </script>

</asp:Content>
