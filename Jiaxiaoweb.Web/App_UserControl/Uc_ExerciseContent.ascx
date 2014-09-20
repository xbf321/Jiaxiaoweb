<%@ Control Language="C#" ClassName="Uc_ExerciseContent" %>
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
        <div id="exam_question_item_nav" style="margin:5px 0px 10px 0px;">
            <a href="javascript:void(0);" onclick="showQuestionRemark();" id="btnshowQuestionRemark"
                class="blue">查看试题分析</a>&nbsp;&nbsp;&nbsp;&nbsp;<%--<a href="javascript:void(0);" onclick="deleteErrorLibrary(1645);">删除错题集</a>--%></div>
    </div>
    <div class="exam_question_nav_wrapper">
        <div class="l">
            您的答案<input type="text" id="txtMyAnswer" class="txtmyanswer" /><span id="exam_question_answer_icon"></span>&nbsp;&nbsp;&nbsp;&nbsp;
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
        <input type="checkbox" id="autoShowRightAnswer" name="autoShowRightAnswer" />自动给出正确答案&nbsp;&nbsp;&nbsp;答完本题后
        <select name='ddlAutoNext' id="ddlAutoNext">
            <option value='-1'>手动</option>
            <option value='0'>立即</option>
            <option value='1'>1秒后</option>
            <option value='2'>2秒后</option>
            <option value='5'>5秒后</option>
            <option value='8'>8秒后</option>
            <option value='10'>10秒后</option>
        </select>
        跳转到下一题
    </div>
    <div class="clear">
    </div>
    <div class="exam_question_nav_wrapper">
        <div class="l" style="width: 350px;">
            首正率：<span id="exam_firstRightRate">0%</span></div>
        <div class="l">
            进度：<span id="exam_processValue">0%</span></div>
        <div class="r">
            <img id="btnkey_pre" src="/images/key_pre_1.gif" alt="上一题" />&nbsp;&nbsp;
            <img id="btnkey_next" src="/images/key_next_1.gif" alt="下一题" /></div>
    </div>
    <div class="clear">
    </div>
    <div id="exam_processer">
        <div class="exam_processContent" id="exam_processContent">
        </div>
    </div>
</div>
