
/*

<script>
*/

$('#ViewExamCount').text(ExamCount);
$('#order').attr('maxlength', ExamCount.toString().length);

var ExamKssj = 45;
var ExamM = ExamKssj; ExamS = 0; ExamEnter = 0;
function AutoTime() {
    if (ExamS == -1) {
        ExamM -= 1;
        ExamS = 59;
    }
    if (ExamM == -1 || ExamEnter == 1) {
        ExamSubmit();
        return false;
    }
    var Emm, Ess;
    Emm = '0' + ExamM;
    Ess = '0' + ExamS;
    if (Emm.length == 3) { Emm = ExamM };
    if (Ess.length == 3) { Ess = ExamS };
    $('#ViewTime').html('<b>' + Emm + ':' + Ess + '</b>');
    ExamS -= 1;
    setTimeout("AutoTime()", 1000)
}


var orderTmp = 1;
var orderPre = 0;
var orderNext = 0;
function gotoExam(order) {
    if (isNaN(order)) { $('#order').attr('value', ''); return false; };
    order = Math.abs(order);

    if (order < 1 || order > ExamCount) { $('#order').attr('value', ''); $('#order').attr('title', '题号输入超出范围!'); return false; }

    //进度框显示Css控制 -> 对上一次的判断显示	
    ExamOrderViewStatus(orderTmp);
    //进度框显示Css控制 -> 对上一次的判断显示

    orderTmp = order;

    //进度框显示Css控制 -> 对本题的显示为当前答题
    $('#EOV' + order).attr('class', 'ExamOrderViewHover');
    //进度框显示Css控制 -> 对本次的显示为当前答题

    $('#order').attr('title', '');
    $('#order').attr('value', order);

    var ExamID = myExamID[order];
    var ExamTx = myExamTx[order];
    var CntHtml = myExamCnt[order];
    var ImgHtml = myExamImg[order];
    var ExamKey = myExamDaRight[order];

    if (ImgHtml != '') {
        ImgHtml = "<div style='width:200px;text-align:left;padding-top:8px;' class='fr'><img src='" + ExamImgPath + ImgHtml + "'></div>";
    }
    $('#WinContent').html("<div class='fl L18'><b>" + order + ".</b>&nbsp;&nbsp;" + CntHtml + "</div>" + ImgHtml);

    if (ExamTx == 1) {
        tx = ExamTx; b('#TX1'); n('#TX2')
    }
    else if (ExamTx = 2) {
        tx = ExamTx; n('#TX1'); b('#TX2')
    }


    var YouKeyVal = myExamDaSelect[order];
    if (YouKeyVal == '' || YouKeyVal == undefined) {
        $('#YouKey').html('&nbsp;');
    }
    else {
        $('#YouKey').html(YouKeyVal);
    }

    orderPre = order - 1;
    orderNext = order + 1;
    if (order == 1) {
        b('#Key_PreNext1');
        n('#Key_PreNext2');
        n('#Key_PreNext3');
    }
    else if (order == ExamCount) {
        n('#Key_PreNext1');
        n('#Key_PreNext2');
        b('#Key_PreNext3');
    }
    else {
        n('#Key_PreNext1');
        b('#Key_PreNext2');
        n('#Key_PreNext3');
    }

    //计算百分比 开始
    var bfb = order / ExamCount;
    bfb = bfb * 1000;
    bfb = Math.round(bfb);
    if (bfb < 1) { bfb = 1 };

    bfb = bfb / 10 + '%';
    $('#jd').html(bfb);
    $('#lxjd').attr('title', '练习进度: ' + bfb);

    $('#lxjd1').width(bfb);
    //计算百分比 结束

}



function gotoKey(key) {
    myExamDaSelect[orderTmp] = key; 	//将本次答案记入数组
    $('#YouKey').html(key); 			//显示本题您的答案

    AutoNextExam(); 					//下一题
}


function ExamOrderViewStatus(EOVorder) {
    //进度框显示控制
    var daTmp = myExamDaSelect[EOVorder];
    if (daTmp != '&nbsp;' && daTmp != ' ' && daTmp != '') { $('#EOV' + EOVorder).attr('class', 'ExamOrderViewVisited'); } else { $('#EOV' + EOVorder).attr('class', 'ExamOrderViewWait'); }
}


document.write("<form id='gatherfrm' name='gatherfrm' target='ifrm' action='mnks_gather.asp?RM=" + Math.ceil(Math.random() * 1000) + "' method='post'>");
document.write("<input type='hidden' name='ExamDiquID' value=''>");
document.write("<input type='hidden' name='DriveType' value=''>");
document.write("<input type='hidden' name='BeginDT' value=''>");
document.write("<input type='hidden' name='ExamIDs' value=''>");
document.write("<input type='hidden' name='ExamKeys' value=''>");
document.write("<input type='hidden' name='Keys' value=''>");
document.write("<input type='hidden' name='ExamErrIDs' value=''>");
document.write("<input type='hidden' name='ExamErrKeys' value=''>");
document.write("<input type='hidden' name='Point' value=''>");
document.write("<input type='hidden' name='Code' value=''>");
document.write("</form>");

document.write("<form id='Listfrm' name='Listfrm' action='mnks.asp' method='post'>");
document.write("<input type='hidden' name='ReExam' value='Y'>");
document.write("</form>");

document.write("<form id='CTJfrm' name='CTJfrm' target='ifrm' action='ctj.asp?RM=" + Math.ceil(Math.random() * 1000) + "' method='post'>");
document.write("<input type='hidden' name='m' value='mnksadd'>");
document.write("<input type='hidden' name='IDs' value=''>");
document.write("</form>");

var ExamResultStr = '';
var ExamViewAllStr = '';
var ExamViewRightStr = '';
var ExamViewErrStr = '';
function ExamSubmit() {
    //对试卷进行处理
    var ExamViewStr = '';
    var ExamViewRightStrTmp = '';
    var ExamViewErrStrTmp = '';
    var ExamErrIDs = '';
    var ExamErrKeys = '';
    var YouKeys = '';

    n('#ExamRoom');
    b('#ExamResult');

    var Point = 0;
    for (var k = 1; k <= ExamCount; k++) {
        var YouKeyVal = myExamDaSelect[k];
        var PICTmp = myExamImg[k];
        var Result = "";
        if (PICTmp != '') { PICTmp = '<table align=right><tr><td><img src=' + ExamImgPath + PICTmp + ' width=100></td></tr></table>'; }
        ExamViewRightStrTmp = '';
        ExamViewErrStrTmp = '';
        if (YouKeyVal == myExamDaRight[k]) {
            Point++;
            Result = '<img src=' + ICOPathOther + 'key_right.gif>';
            ExamViewRightStrTmp = '<tr align=center bgcolor=#FFFFFF height=30><td class=f12><b>' + k + '</b></td><td align=left valign=top class=f12><div style="float:left;line-height:150%;">' + myExamCnt[k] + '</div><div style="float:right;">' + PICTmp + '</div></td><td ><table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%"><tr><td align=center class=f12>' + myExamDaRight[k] + '</td></tr><tr><td height=16 align=right></td></tr></table></td><td ><table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%"><tr><td align=center class=f12>' + YouKeyVal + '</td></tr><tr><td height=16 align=right></td></tr></table></td></tr>';
            ExamViewRightStr += ExamViewRightStrTmp;
        }
        else {
            Result = '<img src=' + ICOPathOther + 'key_error.gif>';
            ExamViewErrStrTmp = '<tr align=center bgcolor=#FFFFFF height=30><td class=f12><b>' + k + '</b></td><td align=left valign=top class=f12><div style="float:left;line-height:150%;">' + myExamCnt[k] + '</div><div style="float:right;">' + PICTmp + '</div></td><td ><table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%"><tr><td align=center class=f12>' + myExamDaRight[k] + '</td></tr><tr><td height=16 align=right></td></tr></table></td><td ><table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%"><tr><td align=center class=f12>' + YouKeyVal + '</td></tr><tr><td height=16 align=right><img src=' + ICOPathOther + 'Key_Error.GIF></td></tr></table></td></tr>';
            ExamViewErrStr += ExamViewErrStrTmp;
            ExamErrIDs += ',' + myExamID[k];
            ExamErrKeys += ',' + YouKeyVal;
        }
        ExamResultStr += '<tr bgcolor="#FFFFFF" align=center><td width="50" class=f12><b>' + k + '</b></td><td width="100" class=f12><b>' + myExamDaRight[k] + '</b></td><td width="100" class=f12>' + YouKeyVal + '</td><td width="50" class=f12>' + Result + '</td></tr>';
        ExamViewAllStr = ExamViewAllStr + ExamViewRightStrTmp + ExamViewErrStrTmp;
        YouKeys += ',' + YouKeyVal;
    }

    var df_fsVal = '';
    if (Point >= 90) {
        b('#imgPass');
        b('#imgPass2');
        df_fsVal = '<font color=red><b>' + Point + '</b></font>';
    }
    else {
        b('#imgNoPass');
        b('#imgNoPass2');
        df_fsVal = '<b>' + Point + '</b>';
    }
    $('#df_fs').html(df_fsVal);


    ExamResultStr = '<table border="0" width="450" bgcolor="#000000" cellspacing="1" cellpadding="3" align="center">'
					+ '<tr align=center height=22 bgcolor="#F2F2F2" style="font-weight: bold;font-size:12px;"><td width="50">题号</td><td width="100">标准答案</td><td width="100">您的答案</td> <td width="50">结果</td></tr>'
					+ ExamResultStr
					+ '<tr bgcolor="#FFFFFF"><td width="100%" colspan="4" align="center">得分：<b>' + Point + '</b></td></tr>'
					+ '</table><BR><BR>';

    ExamViewStr += '<table cellspacing=0 cellpadding=5 width=520 align=center bgcolor=#FFFFFF border=1 bordercolor=#888888 style="border-collapse:collapse;">';
    ExamViewStr += '<tr align=center height=22 bgcolor="#F2F2F2" class="f12"><td width=35><B>题号</B></td><td width="*"><B>试题内容</B></td><td width=55><B>标准答案</B></td><td width=55><B>您的答案</B></td></tr>';

    var PrintStr = '</table><table width="520" align=center height=20><tr><td align=right class=f12>本套试卷由驾驶员考试网（www.jsyks.com）提供</td></table><BR><input type=button class=f12 value="打印试卷" onclick="print();"><BR><BR>';

    ExamViewAllStr = ExamViewStr + ExamViewAllStr + PrintStr;
    ExamViewRightStr = ExamViewStr + ExamViewRightStr + PrintStr;
    ExamViewErrStr = ExamViewStr + ExamViewErrStr + PrintStr;


    setTimeout("ResultShow('all')", 100);

    document.getElementById('CTJfrm').IDs.value = ExamErrIDs; 	//错题集

    document.getElementById('gatherfrm').ExamDiquID.value = DQ;
    document.getElementById('gatherfrm').DriveType.value = DR;
    document.getElementById('gatherfrm').BeginDT.value = gather_BeginDT;
    document.getElementById('gatherfrm').ExamIDs.value = ExamIDs;
    document.getElementById('gatherfrm').ExamKeys.value = ExamKeys;
    document.getElementById('gatherfrm').Keys.value = YouKeys;
    document.getElementById('gatherfrm').ExamErrIDs.value = ExamErrIDs;
    document.getElementById('gatherfrm').ExamErrKeys.value = ExamErrKeys;
    document.getElementById('gatherfrm').Point.value = Point;
    document.getElementById('gatherfrm').Code.value = gather_Code;
    document.getElementById('gatherfrm').submit();

    //交卷后的广告显示
    try {
        ExamSubmitAD();
    }
    catch (e) {
    }

}

function ResultShow(m) {
    if ($('#Result1').html() == '') { $('#Result1').html(ExamResultStr); };
    if ($('#Result2').html() == '') { $('#Result2').html(ExamViewAllStr); };
    if ($('#Result3').html() == '') { $('#Result3').html(ExamViewRightStr); };
    if ($('#Result4').html() == '') { $('#Result4').html(ExamViewErrStr); };
    n('#Result1');
    n('#Result2');
    n('#Result3');
    n('#Result4');
    if (m == 'jb') {
        b('#Result1');
    }
    else if (m == 'all') {
        b('#Result2');
    }
    else if (m == 'right') {
        b('#Result3');
    }
    else if (m == 'err') {
        b('#Result4');
    }
}

function ExamStart() {
    b('#WinAnswer');
    b('#WinPlan');

    gotoExam(1);
    AutoTime();
    LoadSuccess = 'Y';
}

ExamStart();
