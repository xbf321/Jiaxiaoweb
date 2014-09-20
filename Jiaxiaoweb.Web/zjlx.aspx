<%@ Page Language="C#" MasterPageFile="~/Template/BaseMasterPage.master" EnableViewState="false" %>

<script runat="server">
    protected int _dirverType = 1;
    protected bool _isContainerParent = false;
    protected int _categoryId = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        _dirverType = Jiaxiaoweb.Common.ReedRequest.GetQueryInt("d", 1);
        switch (_dirverType)
        {
            //小车
            case (int)Jiaxiaoweb.Common.DriverType.Car:
                _isContainerParent = false;
                _categoryId = 1;
                break;
            //客车
            case (int)Jiaxiaoweb.Common.DriverType.Coach:
                _isContainerParent = true;
                _categoryId = 11;
                break;
            //货车
            case (int)Jiaxiaoweb.Common.DriverType.Truck:
                _isContainerParent = true;
                _categoryId = 10;
                break;
            //吊车电瓶车
            case (int)Jiaxiaoweb.Common.DriverType.Crane:
                _isContainerParent = true;
                _categoryId = 12;
                break;
        }

        this.ltDriverType.Text = Jiaxiaoweb.Common.EnumHelper.GetEnumDescriptionFromDataTableByValue(_dirverType, typeof(Jiaxiaoweb.Common.DriverType));

        InitTable();


        this.Page.Title = this.ltDriverType.Text + "-章节选择";
    }

    protected void InitTable()
    {
        System.Collections.Generic.IList<Jiaxiaoweb.Entities.ExamCategory> examCategoryList = Jiaxiaoweb.Data.ExamCategoryRepository.GetExamCategoryListByParentId(_categoryId, _isContainerParent);
        StringBuilder sbTable = new StringBuilder();
        foreach (Jiaxiaoweb.Entities.ExamCategory item in examCategoryList)
        {
            sbTable.Append("<tr>" + Environment.NewLine);

            switch (_dirverType)
            {
                case (int)Jiaxiaoweb.Common.DriverType.Car:
                    if (item.ParentID == _categoryId)
                    {
                        sbTable.Append("<td colspan=\"4\">" + Environment.NewLine);
                        sbTable.AppendFormat("&nbsp;&nbsp;<b>{0}</b>（{1}题）", item.CategoryName, Jiaxiaoweb.Data.ExamQuestionRepository.GetQuestionCountByCategoryId(_dirverType, item.CategoryID, Jiaxiaoweb.Common.QuestionType.All));
                        sbTable.Append("</td>" + Environment.NewLine);
                    }
                    else
                    {
                        sbTable.Append("<td>" + Environment.NewLine);
                        sbTable.AppendFormat("&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" class=\"select_all\" id=\"{1}\" value=\"{1}\" />{0}", item.CategoryName, item.CategoryID);
                        sbTable.Append("</td>" + Environment.NewLine);

                        sbTable.Append("<td class=\"font_center\">");
                        sbTable.AppendFormat("{0}题", Jiaxiaoweb.Data.ExamQuestionRepository.GetQuestionCountByCategoryId(_dirverType, item.CategoryID, Jiaxiaoweb.Common.QuestionType.All));
                        sbTable.Append("</td>");

                        sbTable.Append("<td class=\"font_center\" width=\"10%\">" + Environment.NewLine);
                        sbTable.AppendFormat("<a href=\"/sxlx.aspx?d={0}&c={1}\" title=\"顺序练习\">顺序练习</a>", _dirverType, item.CategoryID);
                        sbTable.Append("</td>" + Environment.NewLine);
                        sbTable.Append("<td class=\"font_center\" width=\"10%\">" + Environment.NewLine);
                        sbTable.AppendFormat("<a href=\"/sjlx.aspx?d={0}&c={1}\" title=\"随机练习\">随机练习</a>", _dirverType, item.CategoryID);
                        sbTable.Append("</td>" + Environment.NewLine);
                    }
                    break;
                case (int)Jiaxiaoweb.Common.DriverType.Coach:
                case (int)Jiaxiaoweb.Common.DriverType.Truck:
                case (int)Jiaxiaoweb.Common.DriverType.Crane:
                    sbTable.Append("<td>");
                    sbTable.AppendFormat("&nbsp;&nbsp;<input type=\"checkbox\" class=\"select_all\" id=\"{1}\" value=\"{1}\" />{0}", item.CategoryName, item.CategoryID);
                    sbTable.Append("</td>");

                    sbTable.Append("<td class=\"font_center\">");
                    sbTable.AppendFormat("{0}题", Jiaxiaoweb.Data.ExamQuestionRepository.GetQuestionCountByCategoryId(_dirverType, item.CategoryID, Jiaxiaoweb.Common.QuestionType.All));
                    sbTable.Append("</td>");

                    sbTable.Append("<td class=\"font_center\" width=\"10%\">" + Environment.NewLine);
                    sbTable.AppendFormat("<a href=\"/sxlx.aspx?d={0}&c={1}\" title=\"顺序练习\">顺序练习</a>", _dirverType, item.CategoryID);
                    sbTable.Append("</td>" + Environment.NewLine);
                    sbTable.Append("<td class=\"font_center\" width=\"10%\">" + Environment.NewLine);
                    sbTable.AppendFormat("<a href=\"/sjlx.aspx?d={0}&c={1}\" title=\"随机练习\">随机练习</a>", _dirverType, item.CategoryID);
                    sbTable.Append("</td>" + Environment.NewLine);
                    break;
            }
            sbTable.Append("</tr>" + Environment.NewLine);
        }

        this.ltTr.Text = sbTable.ToString();
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .zl
        {
            border: 1px #ccc solid;
            margin-top: 10px;
        }
        .zl td
        {
            border-bottom: 1px #ccc solid;
            line-height: 20pt;
        }
        .none
        {
            border-bottom: 1px #ccc solid;
            color: #26699D;
        }
        .font_g14
        {
            color: #333;
            font-size: 14px;
            font-weight: bold;
        }
        .font_f14
        {
            font-size: 14px;
            padding-top: 5px;
        }
        .font_center
        {
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" runat="Server">
    <div class="rc_title">
        &gt;&gt; 章节选择:<asp:Literal ID="ltDriverType" runat="server"></asp:Literal></div>
    <table align="center" cellpadding="0" cellspacing="0" class="zl" border="0" width="100%">
        <tr>
            <td width="70%" align="center" class="font_g14">
                章节
            </td>
            <td width="10%" align="center" class="font_g14">
                题量
            </td>
            <td colspan="2" align="center" class="font_g14">
                操作
            </td>
        </tr>
        <asp:Literal ID="ltTr" runat="server"></asp:Literal>
        <tr>
            <td colspan="3">
                <b>
                    <input type="checkbox" id="cbSelectAll" />全选/取消全选</b>&nbsp;&nbsp;对选中的章节进行&nbsp;&nbsp;<input
                        type="button" id="btnSxlx" value="顺序出题练习" />&nbsp;&nbsp;或&nbsp;&nbsp;<input type="button"
                            id="btnSjlx" value="随机出题练习" />
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" runat="Server">

    <script type="text/javascript">

        $(document).ready(function() {
            $("#cbSelectAll").click(function() {
                selectAll(this);
            });

            $("#btnSxlx").click(function() {
                var _selectedCategoryId = "";
                $(" .select_all").each(function() {
                    if ($(this).attr("checked")) {
                        var _value = $(this).attr("value");
                        _selectedCategoryId += _value + ",";
                    }
                });

                if (_selectedCategoryId == "" || _selectedCategoryId == ",") {
                    alert("请您选择章节!");
                } else {
                    window.location.href = '/sxlx.aspx?d=<%=_dirverType %>&c=' + _selectedCategoryId;
                }
            });
            $("#btnSjlx").click(function() {
                var _selectedCategoryId = "";
                $(" .select_all").each(function() {
                    if ($(this).attr("checked")) {
                        var _value = $(this).attr("value");
                        _selectedCategoryId += _value + ",";
                    }
                });

                if (_selectedCategoryId == "" || _selectedCategoryId == ",") {
                    alert("请您选择章节!");
                } else {
                    window.location.href = '/sjlx.aspx?d=<%=_dirverType %>&c=' + _selectedCategoryId;
                }
            });
        });
        function selectAll(obj) {
            var _isChecked = $('input[@id="' + obj.id + '"]').attr("checked");

            if (_isChecked) {
                $(" .select_all").each(function() {
                    $(this).attr("checked", true);
                });
            } else {
                $(" .select_all").each(function() {
                    $(this).attr("checked", false);
                });
            }

        }
    </script>

</asp:Content>
