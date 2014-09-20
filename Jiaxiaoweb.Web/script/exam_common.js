var _totalQuestions = 0;
var _autoShowRightAnswer = false;       //是否自动给出正确答案
var _autoNext = -1;                     //默认为手动
var _prePageNumber = 0;                 //上一题的题号
var _currentPageNumber = 1;             //当前为第一题,从1开始
var _currentQuestionIndex = 0;          //当前问题的索引号,从0开始
var _nextPageNumber = 0;                //下一题的题号
var _tempPageNumber = 1;                //临时的题号,用于两个题号交换
var _questionIdsObject;                 //所有问题的ID集合对象
var _currentQuestionObject;             //当前问题对象
var _rightAnswer;                       //正确答案
var _mySelectAnswerArray;               //我选择的答案，数组类型
var _rightAnswerArray = new Array();    //正确答案,数组类型
var _totalFirstRightRate = 0;           //首次答对的总数
var _totalDoneRate = 0;                 //做过题的总数
var _questionRemark = "";               //试题说明
var _questionType = 1;                  //问题类型 1:选择题 2:判断题
var Th = 0, Tm = 0, Ts = 0;
function login() {
    window.location.href = "/login.aspx?ReturnUrl=" + escape(window.location.href);
}
function logout() {
    window.location.href = "/logout.aspx?returnurl=" + escape(window.location.href);
}
function register() {
    window.location.href = "/login.aspx?ReturnUrl=" + escape(window.location.href);
}
function autoTime() {
    Ts += 1;
    if (Ts == 60) { Tm += 1; Ts = 0; }
    if (Tm == 60) { Th += 1; Tm = 0; }
    var hh, mm, ss;
    hh = '0' + Th; mm = '0' + Tm; ss = '0' + Ts;
    if (hh.length == 3) { hh = Th };
    if (mm.length == 3) { mm = Tm };
    if (ss.length == 3) { ss = Ts };
    $('#exam_time').html(hh + ':' + mm + ':' + ss);
    setTimeout("autoTime()", 1000);
}
//显示答案的图标(正确或者错误)
function showAnswerIcon(flag) {
    var _imgUrl = "";
    if (!flag) {
        _imgUrl = "<img src=\"/images/icon_error.gif\" alt=\"错\" />";
    } else {
        _imgUrl = "<img src=\"/images/icon_right.gif\" alt=\"对\" />";
    }
    $("#exam_question_answer_icon").html(_imgUrl);
}
//自动下一题设置
function autoNextQuestion() {
    try {
        if (_autoNext == 0) {
            setTimeout('gotoQuestion(_nextPageNumber)', 10);
        } else if (_autoNext == 1) {
            setTimeout('gotoQuestion(_nextPageNumber)', 1000);
        } else if (_autoNext == 2) {
            setTimeout('gotoQuestion(_nextPageNumber)', 2000);
        } else if (_autoNext == 5) {
            setTimeout('gotoQuestion(_nextPageNumber)', 5000);
        } else if (_autoNext == 8) {
            setTimeout('gotoQuestion(_nextPageNumber)', 8000);
        } else if (_autoNext == 10) {
            setTimeout('gotoQuestion(_nextPageNumber)', 10000);
        } else {
            return false;
        }
    } catch (e) {
        alert(e);
    }
}
function changeAutoNext(i) {
    _autoNext = i;
}
//是否自动给出正确答案
function changeAutoShowQuestion(flag) {
    _autoShowRightAnswer = flag;
}


//显示试题分析说明
function showQuestionRemark() {

    content = _questionRemark;
    /*if (content == undefined || content == "") {
    content = "Sorry!该题暂时没有说明!<br />我们会尽快对该题说明补充完整。";
    }
    */
    var left = $("#btnshowQuestionRemark").offset().left;
    var top = $("#btnshowQuestionRemark").offset().top + 12;
    $("#exam_questionRemark").css({ "left": left + "px", "top": top + "px" });
    $("#exam_questionRemark").toggle();
    $("#exam_questionRemarkContent").html(content);

}

function forwardQuestion() {
    if (_prePageNumber >= 1) {
        gotoQuestion(_prePageNumber);
    }
}
function nextQuestion() {
    if (_nextPageNumber <= _totalQuestions) {
        gotoQuestion(_nextPageNumber);
    }
}

function deleteErrorLibrary(questionId) {
    if (typeof questionId == 'undefined') {
        questionId = -1;
    }
    $.post("/service/QuestionForJson.asmx/MyErrorLabiary", { action: "delete", questionId: questionId });
}
function addErrorLibrary(questionId) {
    $.ajax({
        url: '/service/QuestionForJson.asmx/MyErrorLabiary',
        data: '{"questionId":"' + questionId + '","action":"add"}',
        type: 'post',
        dataType: 'json',
        cache: false,
        contentType: 'application/json; charset=utf8',
        success: function(data) {
            var json = eval('(' + data.d + ')');
            //alert(json.flag);
        }
    });
}

function updateExamQuestionClickCount(questionId) {
    $.post("/service/QuestionForJson.asmx/UpdateExamQuestionClickCount", { questionId: questionId });
}
function updateExamQuestionErrorCount(questionId) {
    $.post("/service/QuestionForJson.asmx/UpdateExamQuestionErrorCount", { questionId: questionId });
}


//HotKeys

//交卷,Enter
$(document).bind('keydown', 'return', function(evt) {
    if (window.confirm("确定要交卷吗？")) {
        e = 1;
    }
    return false;
});

//A
$(document).bind('keydown', 'a', function(evt) {
    if (_questionType == 1) { gotoKey('A'); }
    if (_questionType == 2) { gotoKey('对'); }
    return false;
});

//B
$(document).bind('keydown', 'b', function(evt) {
    if (_questionType == 1) { gotoKey('B'); }
    if (_questionType == 2) { gotoKey('错'); }
    return false;
});

//C
$(document).bind('keydown', 'c', function(evt) {
    if (_questionType == 1) { gotoKey('C'); }
    return false;
});

//D
$(document).bind('keydown', 'd', function(evt) {
    if (_questionType == 1) { gotoKey('D'); }
    return false;
});

//上一题 小键盘-号,←↑
$(document).bind('keydown', 'pageup', function(evt) {
    forwardQuestion();
    return false;
});
$(document).bind('keydown', 'up', function(evt) {
    forwardQuestion();
    return false;
});
$(document).bind('keydown', 'left', function(evt) {
    forwardQuestion();
    return false;
});

//下一题  小键盘+号,→↓
$(document).bind('keydown', 'pagedown', function(evt) {
    nextQuestion();
    return false;
});
$(document).bind('keydown', 'down', function(evt) {
    nextQuestion();
    return false;
});
$(document).bind('keydown', 'right', function(evt) {
    nextQuestion();
    return false;
});

//H,Z,X打开答题帮助
$(document).bind('keydown', 'f1', function(evt) {
    showQuestionRemark();
    return false;
});
$(document).bind('keydown', 'h', function(evt) {
    showQuestionRemark();
    return false;
});
$(document).bind('keydown', 'z', function(evt) {
    showQuestionRemark();
    return false;
});
$(document).bind('keydown', 'x', function(evt) {
    showQuestionRemark();
    return false;
});