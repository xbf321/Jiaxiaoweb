<%@ Control Language="C#" ClassName="Uc_ExerciseScript" %>

<script type="text/javascript">
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
    //下一题
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

        //显示问题
        getAscQuestionJson(_questionIdsObject[_currentQuestionIndex].questionid);

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

        //更新问题浏览数
        updateExamQuestionClickCount(_currentQuestionObject.questionid);

    }

    //我的选择
    function gotoKey(answer) {

        $("#txtMyAnswer").val(answer);

        //
        if (_rightAnswer != answer) {
        
            //显示答案的Icon(对或错)
            showAnswerIcon(false);
            if (_autoShowRightAnswer) {
                //是否显示正确答案
                $("#exam_rightAnswer").show();
            }

            //更新ErrorCount
            updateExamQuestionErrorCount(_currentQuestionObject.questionid);

            //添加我的错题集
            addErrorLibrary(_currentQuestionObject.questionid);
            
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

