<%@ Page Language="C#" MasterPageFile="~/Template/BaseMasterPage.master" EnableViewState="false" %>

<%@ Register Src="~/App_UserControl/Uc_ExerciseContent.ascx" TagName="Uc_ExerciseContent"
    TagPrefix="uc1" %>
<%@ Register Src="~/App_UserControl/Uc_QuestionRemark.ascx" TagName="Uc_QuestionRemark"
    TagPrefix="uc1" %>
<%@ Register Src="~/App_UserControl/Uc_ExerciseScript.ascx" TagName="Uc_ExerciseScript"
    TagPrefix="uc1" %>

<script runat="server">
    protected int driverId = 1;
    protected string categories = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        driverId = Jiaxiaoweb.Common.ReedRequest.GetQueryInt("d", 1);
        categories = Jiaxiaoweb.Common.ReedRequest.GetQueryString("c");

        if (!Jiaxiaoweb.Common.Utils.IsExistInDriverArray(driverId))
        {
            driverId = 1;
        }

        string dirverTypeText = Jiaxiaoweb.Common.EnumHelper.GetEnumDescriptionFromDataTableByValue(driverId, typeof(Jiaxiaoweb.Common.DriverType));
        this.Page.Title = string.Format("{0}--随机出题练习", dirverTypeText);
        this.ltDriverType.Text = dirverTypeText;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" runat="Server">
    <div class="rc_title">
        &gt;&gt; 随机出题练习:<asp:Literal ID="ltDriverType" runat="server"></asp:Literal></div>
    <uc1:Uc_ExerciseContent ID="exerciseContent" runat="server" />
    <uc1:Uc_QuestionRemark ID="questionRemark" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" runat="Server">

    <script type="text/javascript">
        $(document).ready(function() {


            //初始化Click Event
            //是否自动给出正确答案
            $("#autoShowRightAnswer").click(function() {
                changeAutoShowQuestion(this.checked);
            });
            if (_autoShowRightAnswer) {
                $("#autoShowRightAnswer").attr("checked", true);
            }
            //自动下一题设置
            $("#ddlAutoNext").change(function() {
                changeAutoNext(this.value);
            });
            $("#txtCurrentPageNumber").keyup(function() {
                gotoQuestion(this.value);
            });
            $("#txtCurrentPageNumber").keypress(function(e) {
                if (e.which < 48 || e.which > 57) {
                    e.returnValue = false;
                }

            });
            $("#btnkey_pre").click(function() {
                forwardQuestion();
            });
            $("#btnkey_next").click(function() {
                nextQuestion();
            });

            getAscQuestionIdsJson('<%=driverId %>', '<%=categories %>');
        });
        //获得该驾照类型所有的问题的ID
        function getAscQuestionIdsJson(dirverId, categories) {
            $.ajax({
                url: '/service/QuestionForJson.asmx/Sjlx',
                data: '{"driverId":"' + dirverId + '","categories":"' + categories + '"}',
                type: 'post',
                dataType: 'json',
                cache: false,
                contentType: 'application/json; charset=utf8',
                success: function(data) {
                    var json = eval('(' + data.d + ')');
                    globalExam(json);
                },
                error: function(xhr) {
                    alert('({"Error":' + xhr.d.responseText + '})');
                }
            });
        }
    </script>

    <uc1:Uc_ExerciseScript ID="Uc_ExerciseScript1" runat="server" />
</asp:Content>
