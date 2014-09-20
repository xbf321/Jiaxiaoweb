<%@ Page Language="C#" MasterPageFile="~/Template/BaseMasterPage.master"
    AutoEventWireup="true" EnableViewState="false" %>
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
        this.Page.Title = string.Format("{0}--˳�������ϰ", dirverTypeText);
        this.ltDriverType.Text = dirverTypeText;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" runat="Server">
    <div class="rc_title">
        &gt;&gt; ˳�������ϰ:<asp:Literal ID="ltDriverType" runat="server"></asp:Literal></div>
    <uc1:Uc_ExerciseContent ID="exerciseContent" runat="server" />
    <uc1:Uc_QuestionRemark ID="questionRemark" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" runat="Server">

    <script type="text/javascript">
        //Init
        $(document).ready(function() {          


            //��ʼ��Click Event
            //�Ƿ��Զ�������ȷ��
            $("#autoShowRightAnswer").click(function() {
                changeAutoShowQuestion(this.checked);
            });
            if (_autoShowRightAnswer) {
                $("#autoShowRightAnswer").attr("checked", true);
            }
            //�Զ���һ������
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
        //��øü����������е������ID
        function getAscQuestionIdsJson(dirverId,categories) {
            $.ajax({
                url: '/service/QuestionForJson.asmx/Sxlx',
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
