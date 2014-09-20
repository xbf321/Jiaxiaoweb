/*

<script>
*/

var myExamID = new Array(ExamCount);
var myExamCnt = new Array(ExamCount);
var myExamImg = new Array(ExamCount);
var myExamTx = new Array(ExamCount);
var myExamDaRight = new Array(ExamCount);
var myExamDaSelect = new Array(ExamCount);
var myExamNote = new Array(ExamCount);

for (ExmC in myExamPageID) {
    myExamID[ExmC] = '';
    myExamCnt[ExmC] = '';
    myExamImg[ExmC] = '';
    myExamTx[ExmC] = '';
    myExamDaRight[ExmC] = '';
    myExamDaSelect[ExmC] = '';
    myExamNote[ExmC] = '';
}


var Th = 0, Tm = 0, Ts = 0;
function AutoTime() {
    Ts += 1;
    if (Ts == 60) { Tm += 1; Ts = 0; }
    if (Tm == 60) { Th += 1; Tm = 0; }
    var hh, mm, ss;
    hh = '0' + Th; mm = '0' + Tm; ss = '0' + Ts;
    if (hh.length == 3) { hh = Th };
    if (mm.length == 3) { mm = Tm };
    if (ss.length == 3) { ss = Ts };
    $('#ViewTime').html(hh + ':' + mm + ':' + ss);
    setTimeout("AutoTime()", 1000);
}


document.write("<object id='FlashPlayerRight' width='0' height='0' classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab' align='middle' SWLIVECONNECT='true'>");
document.write("<param name='allowScriptAccess' value='sameDomain' />");
document.write("<param name='movie' value='" + ICOPath + "Right.swf' />");
document.write("<param name='quality' value='high'  />");
document.write("<param name='WMode' value='Transparent' >");
document.write("<embed src='" + ICOPath + "Right.swf' width='0' height='0' quality='high' WMode='Transparent' pluginspage='http://www.macromedia.com/go/getflashplayer' name='toy_80' type='application/x-shockwave-flash' allowScriptAccess='sameDomain' swLiveConnect='true'></embed>");
document.write("</object>");

document.write("<object id='FlashPlayerError' width='0' height='0' classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab' align='middle' SWLIVECONNECT='true'>");
document.write("<param name='allowScriptAccess' value='sameDomain' />");
document.write("<param name='movie' value='" + ICOPath + "Error.swf' />");
document.write("<param name='quality' value='high'  />");
document.write("<param name='WMode' value='Transparent' >");
document.write("<embed src='" + ICOPath + "Error.swf' width='0' height='0' quality='high' WMode='Transparent' pluginspage='http://www.macromedia.com/go/getflashplayer' name='toy_80' type='application/x-shockwave-flash' allowScriptAccess='sameDomain' swLiveConnect='true'></embed>");
document.write("</object>");


var AutoVoice = "No"
function PlayVoice(m) {
    try {
        if (AutoVoice != "No") {
            if (m == '1') {
                document.getElementById("FlashPlayerRight").play();
            }
            else {
                document.getElementById("FlashPlayerError").play();
            }
        }
    }
    catch (e)
	{ }
}

function changeAutoVoice(strTmp) {
    if (strTmp == true) {
        AutoVoice = "Yes"
        document.getElementById('AutoVoiceImg').src = ICOPath + "AutoVoice1.gif";
    }
    else {
        AutoVoice = "No"
        document.getElementById('AutoVoiceImg').src = ICOPath + "AutoVoice2.gif";
    }
}

var AutoKey = "Yes";
function changeAutoKey(strTmp) {
    if (strTmp == true) {
        AutoKey = "Yes"
    }
    else {
        AutoKey = "No"
    }
}




var orderTmp = 1;
var orderPre = 0;
var orderNext = 0;
function gotoExam(order) {
    if (isNaN(order)) { $('#order').attr('value', ''); return false; };
    order = Math.abs(order);

    if (order < 1 || order > ExamCount) { $('#order').attr('value', ''); $('#order').attr('title', '题号输入超出范围!'); return false; }

    orderTmp = order;

    $('#order').attr('title', '');
    $('#order').attr('value', order);
    $('#ctjMsg').html('');


    var ExamID = myExamID[order];
    var ExamTx = myExamTx[order];
    var CntHtml = myExamCnt[order];
    var ImgHtml = myExamImg[order];
    var ExamKey = myExamDaRight[order];

    //$('#ContentNR').html('缓存!'+myExamPageID[order]);

    if (CntHtml == '') {
        //$('#ContentNR').html('新读取!'+myExamPageID[order]);
        try {
            var strTmp = $.ajax({
                type: "GET",
                url: ExamPath + myExamPageID[order] + ".txt",
                timeout: 2000,
                async: false,
                dataType: "json"
            }).responseText;
            //$('#ContentNR').html(ExamPath+myExamPageID[order]+".txt");
            //$('#WinContent').html(strTmp);
            var JSONs = eval(strTmp);
            ExamID = JSONs[0]; myExamID[order] = ExamID;
            ExamTx = JSONs[1]; myExamTx[order] = ExamTx;
            CntHtml = JSONs[2]; myExamCnt[order] = CntHtml;
            ImgHtml = JSONs[3]; myExamImg[order] = ImgHtml;
            ExamKey = JSONs[4]; myExamDaRight[order] = ExamKey;
        }
        catch (e) {
        }
    }
    if (ImgHtml != '') {
        ImgHtml = "<div style='width:200px;text-align:left;padding-top:8px;' class='fr'><img src='" + ExamImgPath + ImgHtml + "'></div>";
    }
    //$('#ContentNR').html($('#ContentNR').html()+" PageID:"+myExamPageID[order]+" ExamID:"+myExamID[order]+"");
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
        n('#YouKeyICORight');
        n('#YouKeyICOError');
        $('#RightKey').html('');
    }
    else {
        var RightKeyVal = ExamKey;
        $('#YouKey').html(YouKeyVal);
        if (YouKeyVal == RightKeyVal) {
            b('#YouKeyICORight');
            n('#YouKeyICOError');
            $('#RightKey').html('');
        }
        else {
            n('#YouKeyICORight');
            b('#YouKeyICOError');
            if (AutoKey == 'Yes') { $('#RightKey').html('<span title="正确的答案是“' + RightKeyVal + '”" style="cursor:help;font-size:14px;">正确答案：<b>' + RightKeyVal + '</b></span>'); } else { $('#RightKey').html(''); };
        }
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
    if (bfb < 1) { bfb = 1 }

    bfb = bfb / 10 + '%';
    $('#jd').html(bfb);
    $('#lxjd').attr('title', '练习进度: ' + bfb);

    $('#lxjd1').width(bfb);
    //计算百分比 结束

    if ($('#ExamNotes').css("display") == 'block') { openExamNotes(); } //如果试题分析窗口打开则跟着试题自动读取分析
}


var szl_x = 0;
var szl_y = 0;
function gotoKey(key) {
    $('#YouKey').html(key);
    var RightKeyVal = myExamDaRight[orderTmp];
    if (RightKeyVal == key) {
        PlayVoice('1');
        b('#YouKeyICORight');
        n('#YouKeyICOError');
        $('#RightKey').html('');
        $('#ctjMsg').html('');
    }
    else {
        PlayVoice('0');
        n('#YouKeyICORight');
        b('#YouKeyICOError');
        if (AutoKey == 'Yes') { $('#RightKey').html('<span title="正确的答案是“' + RightKeyVal + '”" style="cursor:help;font-size:14px;">正确答案：<b>' + RightKeyVal + '</b></span>'); } else { $('#RightKey').html(''); };

        //自动加入我的错题集		
        AddCTJ();
    }

    var YouKeyVal = myExamDaSelect[orderTmp];
    if (YouKeyVal == '' || YouKeyVal == undefined) {	//您的答案为空 则表示第一次答 计算首正率
        szl_y += 1;
        if (RightKeyVal == key) { szl_x += 1; };
        var szlMsg = Math.round((szl_x / szl_y) * 1000);
        $('#szl').html(szlMsg / 10 + '%');
    }
    myExamDaSelect[orderTmp] = key; 	//将本次答案记入数组

    AutoNextExam(); //下一题
}

function AddCTJ() {
    //加入错题集
    $("#ctjMsg").html("");
    $.get("CTJ.asp", { m: "add", id: myExamID[orderTmp] },
	  function(data) {
	      $("#ctjMsg").html("&nbsp;" + data);
	      setTimeout('$("#ctjMsg").html("");', 200)
	  });
}


document.write("<form id='taolunfrm' name='taolunfrm' target='_blank' action='http://bbs.jsyks.com/taolun.asp' method='post'>");
document.write("<input type='hidden' name='id' value=''>");
document.write("</form>");
function taolun() {
    //打开试题讨论
    document.getElementById('taolunfrm').id.value = myExamPageID[orderTmp];
    document.getElementById('taolunfrm').submit();
}


//打开/关闭试题分析开始
function openExamNotes() {
    b('#ExamNotes');
    $('#ExamNotesContent').html("暂无分析,试题分析整理中...<BR><BR>您可以先<a href='' class='Service' onclick='taolun();return false;'>查看本题讨论</a>");

    var thisNote = myExamNote[orderTmp];
    if (thisNote == 'Not') {
        //$('#ContentNR').html('不存在');
    }
    else if (thisNote != '') {	//$('#ContentNR').html('缓存');
        $('#ExamNotesContent').html(thisNote);
    }
    else {	//$('#ContentNR').html('新');
        myExamNote[orderTmp] = 'Not';
        $.get("ExamNotes/" + myExamPageID[orderTmp] + ".txt", function(data) {
            //$('#ContentNR').html('新的!');
            //$('#ContentNR').html(data);
            $('#ExamNotesContent').html(data);
            myExamNote[orderTmp] = data;
        });
    }
}

function closeExamNotes() {
    /*
    $("#ExamNotes").hide(400,function(){
    $('#ExamNotesContent').html('');
    });
    */
    $("#ExamNotes").slideUp(100);
    //$('#ExamNotesContent').html('');
    //n('#ExamNotes');	
}
//打开/关闭试题分析结束



function ExamStart() {
    gotoExam(1);
    AutoTime();
    LoadSuccess = "Y";
}



ExamStart();
//setTimeout("ExamStart()",1500);

//$('#WinWait').toggle(600);