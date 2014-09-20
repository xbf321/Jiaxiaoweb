<%@ Page Language="C#" MasterPageFile="~/Template/BaseMasterPage.master" %>

<script runat="server">
    protected int driverId = 1;
    protected int provinceId = -1;
    protected string provinceName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        driverId = Jiaxiaoweb.Common.ReedRequest.GetQueryInt("d", 1);
        provinceId = Jiaxiaoweb.Common.ReedRequest.GetQueryInt("p", -1);
        if (!Jiaxiaoweb.Common.Utils.IsExistInDriverArray(driverId))
        {
            driverId = 1;
        }
        switch(provinceId){
            case 69:
                provinceName = "四川省";
                break;
            case 59:
                provinceName = "陕西省";
                break;
            case 7:
                provinceName = "江苏省";
                break;
            case 80:
                provinceName = "重庆省";
                break;
            case -1:
                provinceName = string.Empty;
                break;
        }

        string dirverTypeText = Jiaxiaoweb.Common.EnumHelper.GetEnumDescriptionFromDataTableByValue(driverId, typeof(Jiaxiaoweb.Common.DriverType));
        this.Page.Title = string.Format("{0}--{1}模拟考试", dirverTypeText,provinceName);
        this.ltDriverType.Text = dirverTypeText;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .border
        {
            border: 1px solid #4D7BAE;
        }
        #exam_questionView
        {
            width: 775px;
            height: 92px;
            border-left: 1px solid #4D7BAE;
            border-bottom: 1px solid #4D7BAE;
            text-align: center;
            margin-top: 10px;
        }
        .exam_questionView_Wait, .exam_questionView_Hover, .exam_questionView_Visited
        {
            width: 30px;
            height: 22px;
            float: left;
            font-size: 12px;
            font-family: arial;
            border-top: 1px solid #4D7BAE;
            border-right: 1px solid #4D7BAE;
            line-height: 22px;
        }
        .exam_questionView_Wait
        {
            cursor: pointer;
        }
        .exam_questionView_Hover
        {
            background-color: #4D7BAE;
            color: #FFFFFF;
            font-weight: bold;
            cursor: default;
        }
        .exam_questionView_Visited
        {
            background-color: #98B4D1;
            color: #000000;
            cursor: pointer;
        }
        #exam_finish_result_wrapper
        {
            display: none;
            width: 600px;
            margin: 0 auto;
        }
        #exam_finish_result_nav
        {
            width: 90%;
            margin-top: 18px;
        }
        #exam_finish_result_nav
        {
            text-align:center;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" runat="Server">
    <div class="rc_title">
        &gt;&gt; <%=this.provinceName %>模拟考试:<asp:Literal ID="ltDriverType" runat="server"></asp:Literal></div>
    <div id="exam_loading">
        <img src="/images/loading_blue_big.gif" alt="正在载入....." />
    </div>
    <div id="exam_question_wrapper">
        <div class="exam_question_nav_wrapper">
            <div style="width: 350px;" class="l">
                共计<span id="exam_questioncount">0</span>题</div>
            <div id="exam_time" class="l">
            </div>
            <div style="text-align: right;" class="r">
                转到<input id="txtCurrentPageNumber" value="1" class="currentPageNumber" />题</div>
        </div>
        <div class="clear">
        </div>
        <div class="exam_question_item">
            <div id="exam_questionname" class="l">
            </div>
            <div id="exam_questionphoto" class="r">
            </div>
            <div class="clear">
            </div>
        </div>
        <div class="clear">
        </div>
        <div class="exam_question_nav_wrapper">
            <div class="l">
                您的答案：<input type="text" id="txtMyAnswer" class="txtmyanswer" /><span id="exam_question_answer_icon"></span>&nbsp;&nbsp;&nbsp;&nbsp;
                <span id="exam_rightAnswer"></span>&nbsp;&nbsp;&nbsp;&nbsp;做题快捷键:<span style="color:Red;">交卷[Enter],上一题[←|↑],下一题[→|↓],帮助[H|Z|X]</span>
            </div>
            <div class="r">
                <div id="choiceOption">
                    <img src="/images/Key_A.gif" alt="A" onclick="gotoKey('A');" />
                    <img src="/images/Key_B.gif" alt="B" onclick="gotoKey('B');" />
                    <img src="/images/Key_C.gif" alt="C" onclick="gotoKey('C');" />
                    <img src="/images/Key_D.gif" alt="D" onclick="gotoKey('D');" />
                </div>
                <div id="judementOption">
                    <img src="/images/Key_Right.gif" alt="对" onclick="gotoKey('对');" />
                    <img src="/images/Key_Error.gif" alt="错" onclick="gotoKey('错');" />
                </div>
            </div>
        </div>
        <div class="clear">
        </div>
        <div class="exam_question_nav_wrapper">
            <div class="l">
                进度：<span id="exam_processValue">0%</span></div>
            <div class="r">
                <img id="btnkey_pre" src="/images/key_pre_1.gif" alt="上一题" />&nbsp;&nbsp;
                <img id="btnkey_next" src="/images/key_next_1.gif" alt="下一题" />&nbsp;&nbsp;<img id="btnkey_finish"
                    src="/images/Key_finish.gif" alt="交卷" /></div>
        </div>
        <div class="clear">
        </div>
        <div id="exam_processer">
            <div class="exam_processContent" id="exam_processContent">
            </div>
        </div>
        <div class="clear">
        </div>
        <div id="exam_questionView">

            <script type="text/javascript">
                for (ii = 1; ii <= 100; ii++) {
                    document.write('<div id="exam_questionView_' + ii + '" class="exam_questionView_Wait" onclick="gotoQuestion(\'' + ii + '\')">' + ii + '</div>')
                }
            </script>

        </div>
        <div class="clear">
        </div>
        <div class="exam_question_nav_wrapper ">
            <table border="0" cellpadding="0" cellspacing="0" class="margin_top10">
                <tr>
                    <td width="8%">
                        <table width="30" border="0" cellpadding="0" cellspacing="0" class="border">
                            <tr>
                                <td height="18">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="13%">
                        未答题
                    </td>
                    <td width="7%">
                        <table width="30" border="0" cellpadding="0" cellspacing="0" class="border">
                            <tr>
                                <td height="18" bgcolor="#4D7BAE">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="14%">
                        当前答题
                    </td>
                    <td width="6%">
                        <table width="30" border="0" cellpadding="0" cellspacing="0" class="border">
                            <tr>
                                <td height="18" bgcolor="#98B4D1">
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="52%">
                        已答题
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div id="exam_finish_result_wrapper">
        <!--是否通过 Start-->
        <div id="exam_finish_result_1">
        </div>
        <!--是否通过 End-->
        <div id="exam_finish_result_nav">
            <input type="button" value="所有试题" onclick="examResultShow('all');" />
            <input type="button" value="答对题一览" onclick="examResultShow('right');" />
            <input type="button" value="答错题一览" onclick="examResultShow('error');" />
            <input type="button" value="重新出题" title="重新出一套新的试卷供您模拟" onclick="newExam();" />
            <%--<div style="margin: 10px 0px 10px 0px;">
                <a href='javascript:void(0);' onclick="document.getElementById('CTJfrm').submit();"
                    class='blue12' style='color: blue;'>将答错题全部加入我的错题集</a><span id="ctjMsg" class="f12"
                        style='color: gray;'></span> <a href='ctj.asp' class='blue12' style='color: blue;'>管理我的错题集</a></div>--%>
        </div>
        <!--所有试题 Start-->
        <div id="exam_finish_result_2">
        </div>
        <!--所有试题 End-->
        <!--答对题 Start-->
        <div id="exam_finish_result_3">
        </div>
        <!--答对题 End-->
        <!--答错题 Start-->
        <div id="exam_finish_result_4">
        </div>
        <!--答错题 End-->
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" runat="Server">

    <script type="text/javascript">
        var m = 1; s = 0; e = 0;
        function autoTime() {
            if (s == -1) {
                m -= 1;
                s = 59;
            }
            if (m == -1 || e == 1) {
                if (m == -1) {
                    $("#exam_time").html('<img src="/images/timeover.gif" height="22">');
                }
                finishExam();
                return false;
            }
            var mm, ss;
            mm = '0' + m;
            ss = '0' + s;
            if (mm.length == 3) {
                mm = m
            };
            if (ss.length == 3) { ss = s };
            $("#exam_time").html('<b>' + mm + ':' + ss + '</b>');
            s -= 1;
            setTimeout("autoTime()", 1000)
        }
        $(document).ready(function() {

            $("#btnkey_finish").click(function() {
                if (window.confirm("确定要交卷吗？")) {
                    e = 1;
                }
            });
            $("#btnkey_pre").click(function() {
                forwardQuestion();
            });
            $("#btnkey_next").click(function() {
                nextQuestion();
            });
            $("#txtCurrentPageNumber").keyup(function() {
                gotoQuestion(this.value);
            });
            $("#txtCurrentPageNumber").keypress(function(e) {
                if (e.which < 48 || e.which > 57) {
                    e.returnValue = false;
                }

            });

            getAscMnksQuestionIdsJson('<%=driverId %>', '<%=provinceId %>');
        });
        //获得该驾照类型所有的问题的ID
        function getAscMnksQuestionIdsJson(dirverId,provinceId) {
            $.ajax({
            url: '/service/QuestionForJson.asmx/Mnks',
                data: '{"driverId":"' + dirverId + '","provinceId":"'+provinceId+'"}',
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
        function globalExam(data) {
            //初始化
            _questionIdsObject = data.examquestions;
            _totalQuestions = data.examquestioncount;
            _mySelectAnswerArray = new Array(_totalQuestions);


            $("#exam_questioncount").html(_totalQuestions);

            //首次载入默认第一题
            gotoQuestion(_tempPageNumber);
            $("#exam_loading").hide();
            $("#exam_question_wrapper").show();
            //开始计时
            autoTime();

            fillRightAnswerArray(_questionIdsObject);
        }
        //Fill Right Answer Array
        function fillRightAnswerArray(data) {
            for (var i = 0; i < data.length; i++) {
                _rightAnswerArray[i] = data[i].rightanswerstring;
            }
        }
        function gotoQuestion(pageNumber) {
            if (isNaN(pageNumber)) {
                _currentPageNumber = pageNumber = 1;
            }
            pageNumber = Math.abs(pageNumber);

            if (pageNumber <= 1) {
                pageNumber = 1;
            }
            if (pageNumber >= _totalQuestions) {
                pageNumber = _totalQuestions;
            }
            //进度框显示Css控制 -> 对上一次的判断显示
            setQuestionView(_tempPageNumber);
            //进度框显示Css控制 -> 对上一次的判断显示


            _currentPageNumber = _tempPageNumber = pageNumber;
            _currentQuestionIndex = _currentPageNumber - 1;
            _prePageNumber = _currentPageNumber - 1;
            _nextPageNumber = _currentPageNumber + 1;

            $("#txtCurrentPageNumber").val(_currentPageNumber);

            if (_currentPageNumber <= 1) {
                $("#btnkey_pre").attr("src", "/images/key_pre_1.gif");
                $("#btnkey_next").attr("src", "/images/key_next_2.gif");
            } else if (_currentPageNumber >= _totalQuestions) {
                $("#btnkey_pre").attr("src", "/images/key_pre_2.gif");
                $("#btnkey_next").attr("src", "/images/key_next_1.gif");
            } else {
                $("#btnkey_pre").attr("src", "/images/key_pre_2.gif");
                $("#btnkey_next").attr("src", "/images/key_next_2.gif");
            }

            //进度框显示Css控制 -> 对本题的显示为当前答题
            $('#exam_questionView_' + pageNumber).attr('class', 'exam_questionView_Hover');
            //进度框显示Css控制 -> 对本次的显示为当前答题

            //计算进度 开始
            var _tempProcess = _currentPageNumber / _totalQuestions;
            _tempProcess = _tempProcess * 1000;
            _tempProcess = Math.round(_tempProcess);
            if (_tempProcess < 1) { _tempProcess = 1 }

            _tempProcess = _tempProcess / 10 + '%';
            $('#exam_processValue').html(_tempProcess);

            $('#exam_processContent').width(_tempProcess);
            //计算进度 结束
            showQuestion(_questionIdsObject[pageNumber - 1]);

        }
        //显示问题
        function showQuestion(data) {
            _currentQuestionObject = data;
            _currentPageNumber = parseInt($("#txtCurrentPageNumber").val());
            var questionName = "<b>" + _currentPageNumber + "</b>、" + _currentQuestionObject.questionname;

            //设置问题名称
            $("#exam_questionname").html(questionName);

            //设置问题图片
            var _quesitonPhoto = _currentQuestionObject.questionphoto;
            if ($.trim(_quesitonPhoto) != '') {
                $("#exam_questionphoto").html('<img src="' + _quesitonPhoto + '" />');
            } else {
                $("#exam_questionphoto").html('');
            }

            //问题类型
            _questionType = _currentQuestionObject.questiontype;
            if (_questionType == 1) {
                //选择题
                $("#judementOption").hide();
                $("#choiceOption").show();
            }
            if (_questionType == 2) {
                //判断题
                $("#choiceOption").hide();
                $("#judementOption").show();
            }

            //显示我之前是否回答过该题
            var _myAnswer = _mySelectAnswerArray[_currentQuestionIndex];
            if (_myAnswer != undefined && _myAnswer != "") {
                $("#txtMyAnswer").val(_myAnswer);
            } else {
                $("#txtMyAnswer").val("");
            }

            //更新问题浏览数
            updateExamQuestionClickCount(_currentQuestionObject.questionid);
        }
        function gotoKey(answer) {

            //设置我自己的问题
            _mySelectAnswerArray[_currentQuestionIndex] = answer;

            $("#txtMyAnswer").val(answer);

            //自动下一题
            autoNextQuestion();
        }
        function setQuestionView(pageNumber) {
            //进度框显示控制
            var _tempMyAnswer = _mySelectAnswerArray[pageNumber - 1];
            if (_tempMyAnswer == undefined || _tempMyAnswer == '') {
                $('#exam_questionView_' + pageNumber).attr('class', 'exam_questionView_Wait');
            } else {
                $('#exam_questionView_' + pageNumber).attr('class', 'exam_questionView_Visited');
            }
        }


        //交卷
        var _exam_finish_result_1_text;             //是否通过
        var _exam_finish_result_2_table_text;       //所有试题
        var _exam_finish_result_3_table_text;       //答对题
        var _exam_finish_result_4_table_text;       //答错题
        var _exam_finish_result_print_table_text;   //打印
        function finishExam() {
            $("#exam_question_wrapper").hide();
            $("#exam_finish_result_wrapper").show();

            var _point = 0;     //分数
            _exam_finish_result_2_table_text = _exam_finish_result_3_table_text
                                             = _exam_finish_result_4_table_text
                                             = '<table cellspacing="0" cellpadding="5" bordercolor="#888888" width="100%" bgcolor="#ffffff" border="1">' +
                                                '<tr bgcolor="#f2f2f2" height="25" align="center">' +
                                                '<td width="35">题号</td>' +
                                                '<td>试题内容</td>' +
                                                '<td width="55">标准答案</td>' +
                                                '<td width="55">您的答案</td>' +
                                                '</tr>';
            _exam_finish_result_print_table_text = '<table cellpadding="6" cellspacing="0" border="0" width="100%">' +
                                                '<tr>' +
                                                '<td colspan="4" align="right">本套试卷由（<a href="http://www.jiaxiaoweb.com">www.jiaxiaoweb.com</a>）提供</td>' +
                                                '</tr>' +
                                                '<tr>' +
                                                '<td colspan="4" align="center"><input type="button" onclick="print();" value="打印"></td>' +
                                                '</tr>' +
                                                '</table>';

            for (var _i = 0; _i < _totalQuestions; _i++) {
                var _tempSigleTr;
                var _myAnswer = _mySelectAnswerArray[_i];
                if (_myAnswer == undefined || _myAnswer == '') {
                    _myAnswer = '';
                }
                var _questionPhoto = _questionIdsObject[_i].questionphoto;
                var _questionName = _questionIdsObject[_i].questionname;
                _rightAnswer = _rightAnswerArray[_i];
                if (_questionPhoto != "") {
                    _questionPhoto = '<img src="' + _questionPhoto + '" alt="' + _questionName + '" />';
                }

                _tempSigleTr = '<tr>' +
                            '<td align="center">' + (_i + 1) + '</td>' +
                            '<td><div class="l" style="padding:10px;">' + _questionName + '</div>' +
                            '<div class="r">' + _questionPhoto + '</div>' +
                            '</td>' +
                            '<td align="center">' + _rightAnswer + '</td>' +
                            '<td align="center">';

                if (_myAnswer == _rightAnswer) {
                    //正确
                    _point++;  //加一分
                    _tempSigleTr += _myAnswer +
                                    '<img src="/images/icon_right.gif" alt="正确" />';
                    _exam_finish_result_3_table_text += _tempSigleTr +
                                                        '</td>' +
                                                        '</tr>';

                } else {
                    _tempSigleTr += _myAnswer +
                                    '<img src="/images/icon_error.gif" alt="错误" />';
                    _exam_finish_result_4_table_text += _tempSigleTr +
                                                        '</td>' +
                                                        '</tr>';
                }

                _tempSigleTr += '</td>' +
                                '</tr>';
                _exam_finish_result_2_table_text += _tempSigleTr;
            }



            _exam_finish_result_2_table_text += '</table>' + _exam_finish_result_print_table_text;
            _exam_finish_result_3_table_text += '</table>' + _exam_finish_result_print_table_text;
            _exam_finish_result_4_table_text += '</table>' + _exam_finish_result_print_table_text;


            if (_point >= 90) {
                //通过
                _exam_finish_result_1_text = '<div class="l"><img src="/images/exam_pass.gif" alt="已通过" /></div>' +
                                 ' <div><img src="/images/exam_pass_text.gif" alt="已通过" />' +
                                 '<div style="padding-top: 10px; font-size: 27px;">您的得分：<b>' + _point + '</b>分</div></div>';
            } else {
                //未通过
                _exam_finish_result_1_text = '<div class="l"><img src="/images/exam_nopass.gif" alt="未通过" /></div>' +
                                 ' <div><img src="/images/exam_nopass_text.gif" alt="未通过" />' +
                                 '<div style="padding-top: 10px; font-size: 27px;">您的得分：<font color="red"><b>' + _point + '</b></font>分</div></div>';
            }

            $("#exam_finish_result_1").html(_exam_finish_result_1_text);
            setTimeout("examResultShow('all')", 100);

        }
        function examResultShow(obj) {
            var _$r2 = $('#exam_finish_result_2');
            var _$r3 = $('#exam_finish_result_3');
            var _$r4 = $('#exam_finish_result_4');

            if ($.trim(_$r2.html()) == "") { _$r2.html(_exam_finish_result_2_table_text); }
            if ($.trim(_$r3.html()) == "") { _$r3.html(_exam_finish_result_3_table_text); }
            if ($.trim(_$r4.html()) == "") { _$r4.html(_exam_finish_result_4_table_text); }       
            
            

            _$r2.hide();
            _$r3.hide();
            _$r4.hide();
           
            if (obj == 'all') {
                _$r2.show();
            }
            else if (obj == 'right') {
                _$r3.show();
            }
            else if (obj == 'error') {
                _$r4.show();
            }
        }
        function newExam() {
            window.location.href = window.location.href;
        }

        
    </script>

</asp:Content>
