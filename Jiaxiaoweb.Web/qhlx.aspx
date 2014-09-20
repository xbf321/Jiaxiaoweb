<%@ Page Language="C#" MasterPageFile="~/Template/BaseMasterPage.master" EnableViewState="false" %>

<%@ Register Src="~/App_UserControl/Uc_ExerciseContent.ascx" TagName="Uc_ExerciseContent"
    TagPrefix="uc1" %>
<%@ Register Src="~/App_UserControl/Uc_QuestionRemark.ascx" TagName="Uc_QuestionRemark"
    TagPrefix="uc1" %>

<script runat="server">
    protected int totalCount = 100;
    protected int exerciseType = 1; //1:顺序 2:随机
    protected string strExerciseType = "顺序";
    protected void Page_Load(object sender, EventArgs e)
    {
        totalCount = Jiaxiaoweb.Common.ReedRequest.GetQueryInt("c", 100);
        exerciseType = Jiaxiaoweb.Common.ReedRequest.GetQueryInt("e", 1);

        if(exerciseType == 2){
            strExerciseType = "随机";
        }
        
        this.Page.Title = string.Format("强化练习{0}道-{1}--强化出题练习",totalCount,strExerciseType);
        ltDesc.Text = string.Format("强化{0}-{1}",totalCount,strExerciseType);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainRight" runat="Server">
    <div class="rc_title">
        &gt;&gt; 强化出题练习:<asp:Literal ID="ltDesc" runat="server"></asp:Literal></div>
    <uc1:Uc_ExerciseContent ID="exerciseContent" runat="server" />
    <uc1:Uc_QuestionRemark ID="questionRemark" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterScript" runat="Server">

    <script type="text/javascript">
        $(document).ready(function() {
            getAscQuestionIdsJson('<%=totalCount %>', '<%=exerciseType %>');


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
        });



        //获得该驾照类型所有的问题的ID
        function getAscQuestionIdsJson(totalCount, exerciseType) {
            $.ajax({
                url: '/service/QuestionForJson.asmx/Qhlx',
                data: '{"totalCount":"' + totalCount + '","exerciseType":"' + exerciseType + '"}',
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
        //根据QuestionID,获得该问题信息
        function getAscQuestionJson(q) {
            $.ajax({
                url: '/service/QuestionForJson.asmx/GetQuestionEntity',
                data: '{"questionId":"' + q + '"}',
                type: 'post',
                dataType: 'json',
                cache: false,
                contentType: 'application/json; charset=utf8',
                success: function(data) {
                    var json = eval('(' + data.d + ')');
                    showQuestion(json);
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
            gotoQuestion(1);
            $("#exam_loading").hide();
            $("#exam_question_wrapper").show();
            //开始计时
            autoTime();
        }
        //显示问题
        function showQuestion(data) {

            _currentQuestionObject = data;
            _rightAnswer = _currentQuestionObject.rightanswerstring;
            _questionRemark = _currentQuestionObject.questionremark;
            _currentPageNumber = parseInt($("#txtCurrentPageNumber").val());
            var questionName = "<b>" + _currentPageNumber + "</b>、" + _currentQuestionObject.questionname
            //设置问题名称
            $("#exam_questionname").html(questionName);

            //设置问题图片
            var _quesitonPhoto = _currentQuestionObject.questionphoto;
            if ($.trim(_quesitonPhoto) != '') {
                $("#exam_questionphoto").html('<img src="' + _quesitonPhoto + '" />');
            } else {
                $("#exam_questionphoto").html('');
            }


            //设置正确答案
            $("#exam_rightAnswer").html("正确答案：" + _rightAnswer);

            //显示我之前是否回答过该题
            var _myAnswer = _mySelectAnswerArray[_currentQuestionIndex];
            if (_myAnswer != undefined && _myAnswer != "") {
                $("#txtMyAnswer").val(_myAnswer);

                if (_myAnswer != _rightAnswer) {
                    showAnswerIcon(false);
                    if (_autoShowRightAnswer) {
                        $("#exam_rightAnswer").show();
                    }
                } else {
                    showAnswerIcon(true);
                    $("#exam_rightAnswer").hide();
                }
            } else {
                $("#exam_question_answer_icon").html("");
                $("#txtMyAnswer").val("");
                $("#exam_rightAnswer").hide();
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
            _currentPageNumber = pageNumber;
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


            //计算进度 开始
            var _tempProcess = _currentPageNumber / _totalQuestions;
            _tempProcess = _tempProcess * 1000;
            _tempProcess = Math.round(_tempProcess);
            if (_tempProcess < 1) { _tempProcess = 1 }

            _tempProcess = _tempProcess / 10 + '%';
            $('#exam_processValue').html(_tempProcess);

            $('#exam_processContent').width(_tempProcess);
            //计算进度 结束

            getAscQuestionJson(_questionIdsObject[_currentQuestionIndex].questionid);

        }
        //自己选择的答案
        function gotoKey(answer) {

            $("#txtMyAnswer").val(answer);

            //显示正确答案
            if (_rightAnswer != answer) {
                showAnswerIcon(false);
                if (_autoShowRightAnswer) {
                    $("#exam_rightAnswer").show();
                }
            } else {
                showAnswerIcon(true);
                $("#exam_rightAnswer").hide();
            }

            //计算首正率
            var _tempMyAnswerValue = _mySelectAnswerArray[_currentQuestionIndex];
            if (_tempMyAnswerValue == undefined || _tempMyAnswerValue == "") {
                //为空
                //说明为第一次回答该题
                _totalDoneRate += 1;
                if (answer == _rightAnswer) {
                    _totalFirstRightRate += 1;
                }
                var _tempRateValue = Math.round((_totalFirstRightRate / _totalDoneRate) * 1000);
                $("#exam_firstRightRate").html((_tempRateValue / 10) + "%");
            }


            //设置我自己的问题
            _mySelectAnswerArray[_currentQuestionIndex] = answer;

            //自动下一题
            autoNextQuestion();

        }       
        
    </script>

</asp:Content>
