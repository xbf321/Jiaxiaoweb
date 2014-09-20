<!--
var DQ="1005";
var DR="A1";
var DomainHost="http://www.jsyks.com/";
var ICOPath="ICO/";
var ExamPath="ExamBase/";
var ExamImgPath="http://img.jsyks.com/main/ExamPic/";
var needLogin=1;
var SQ_UserID="";
var SQ_UserName="";
var SQ_RealName="";
var SQ_Sex="";
var SQ_Age="0";


var ICOPathOther='http://jxks.jxedt.com/exam/exam3_img/';


//公用JS函数 开始

function b(s,tim){if (!$(s)) return; $(s).show(tim);}
function n(s,tim){if (!$(s)) return; $(s).hide(tim);}
function bn(s,tim){if (!$(s)) return; $(s).toggle(tim);}
function nb(s,tim){if (!$(s)) return; $(s).toggle(tim);}
function vv(s){if (!$(s)) return; $(s).css("visibility","visible");}
function vh(s){if (!$(s)) return; $(s).css("visibility","hidden");}

function $_()
{ 
  var elements = new Array(); 
  for (var i = 0; i < arguments.length; i++) 
  { 
    var element = arguments[i]; 
    if (typeof element == 'string') 
      element = document.getElementById(element); 
    if (arguments.length == 1) 
      return element; 
    elements.push(element); 
  } 
  return elements; 
}

function getPos(obj)
{	//输入的obj可以是字符串或对象 如果是对象ID名 请用字符串传来 本函数适应于IE/FF
	if (typeof(obj)=="string")
	{
		obj=document.getElementById(obj);
	}				
	var pos = [];
	pos[0] = obj.offsetLeft;	//X
	pos[1] = obj.offsetTop;		//Y
	while (obj = obj.offsetParent)
	{
		pos[0] += obj.offsetLeft;
		pos[1] += obj.offsetTop;
	}
	return pos;
}


if(navigator.userAgent.indexOf("MSIE")>=0)
{
	g_browserVer = 1;	//ie
}
else
{
	g_browserVer = 2;	//ff
}

var WinkI=0;
function Wink(obj,html,speed)
{
	WinkI+=1;
	if (WinkI%2==0)
	{
		document.getElementById(''+obj+'').innerHTML=html;
	}
	else
	{
		document.getElementById(''+obj+'').innerHTML='';
	}
	setTimeout(function(){Wink(obj,html,speed)},speed)
}


document.write ("<form id='Loginoutfrm' name='Loginoutfrm' target='_top' action='' method='post'>");
document.write ("<input type='hidden' name='SourceURL' value=''>");
document.write ("</form>");
function mLoginout(m)
{
	
	var thisURI=location.href;	
	//thisURI=encodeURIComponent(thisURI);
	var Address='Login.asp';
	if (m==2) 
	{
		Address='Logout.asp';
	}

	var frm=document.getElementById('Loginoutfrm');
	frm.action=Address+'?r='+Math.ceil(Math.random() * 1000000);
	frm.SourceURL.value=thisURI;
	frm.submit();
}


//公用JS函数 结束





var AutoNext='No';
function changeAutoNext(strTmp)
{
	AutoNext=strTmp;
}

function AutoNextExam()
{	
	try
	{
		if(AutoNext== "0")
		{
			setTimeout('gotoExam(orderNext)',10);
		}
		else if(AutoNext== "1")
		{
			setTimeout('gotoExam(orderNext)',1000);
		}
		else if(AutoNext== "2")
		{
			setTimeout('gotoExam(orderNext)',2000);
		}
		else if(AutoNext== "5")
		{
			setTimeout('gotoExam(orderNext)',5000);
		}
		else if(AutoNext== "8")
		{
			setTimeout('gotoExam(orderNext)',8000);
		}
		else if(AutoNext== "10")
		{
			setTimeout('gotoExam(orderNext)',10000);
		}
		else
		{
			return false;
		}
	}
	catch(e)
	{
	}
}
	






	function selectDiquOpen()
	{
		$('#selectDiquJT').attr('src','PIC/jt2.gif');
		if ($('#selectDiqu').html()=='')
		{
			$.get("set.asp",{read: "y", m: "Diqu"} ,function(data){$('#selectDiqu').html(data);},"html");
		}
		selectDriveClose();
		$('#selectDiqu').show();
	}
	function selectDiquClose()
	{
		$('#selectDiquJT').attr('src','PIC/jt1.gif');
		$('#selectDiqu').hide();
	}

	function selectDriveOpen()
	{
		$('#selectDriveJT').attr('src','PIC/jt2.gif');
		if ($('#selectDrive').html()=='')
		{
			$.get("set.asp",{read: "y", m: "DriveType"} ,function(data){$('#selectDrive').html(data);},"html");
		}
		selectDiquClose();
		$('#selectDrive').show();
	}
	function selectDriveClose()
	{
		$('#selectDriveJT').attr('src','PIC/jt1.gif');
		$('#selectDrive').hide();
	}

	function setDiqu(ll,nn)
	{
		try
		{
			if (DQ!='') {$('#D'+DQ+'').css({ "color": "", "font-weight": "100" });$('#D'+DQ+'').attr('class','blue14');};

			DQ=ll;
			$('#D'+ll+'').css({ "color": "#DA0C00", "font-weight": "bold" });
		}
		catch (e)
		{
		}
	}
	function saveDiqu(ll,nn,cc)
	{
		$('#qhMsg').html('题库切换处理中..');
		$.get("set.asp",{save: "y", m: "diqu", l: ll, n: escape(nn), c: cc } ,function(data){saveDQChange(data,ll,nn);});
	}
	function saveDQChange(d,ll,nn)
	{
		if (d=="1")
		{
			setDiqu(ll,nn);
			try
			{
				if (location.href.indexOf('zjlx.asp')>0 || location.href.indexOf('sxlx.asp')>0 || location.href.indexOf('sjlx.asp')>0 || location.href.indexOf('mnks.asp')>0 || location.href.indexOf('test.asp')>0)
				{
					setTimeout('window.location=location.href;',500);
				}

				setTimeout("$('#qhMsg').html('<font color=red>"+nn+" 切换成功！</font>');",500);
				setTimeout("$('#qhMsg').html('');",1500);
				$('#ViewDiqu').html('<font color=red>'+nn.replace('题库','')+'题库</font>');
				setTimeout("$('#ViewDiqu').html('"+nn.replace('题库','')+"题库');",1500);
				selectDiquClose();
			}
			catch (e)
			{
			}
		}
	}

	function setDriver(s)
	{
		try
		{
			if (DR!='') {$('#DRV'+DR+'').removeClass();$('#DRV'+DR+'').addClass("DT0");}
			DR=s;
			$('#DRV'+s+'').removeClass();
			$('#DRV'+s+'').addClass("DT1");
		}
		catch (e)
		{
		}
	}
	function saveDR(s)
	{
		$.get("set.asp",{save: "y", m: "DriveType", DriveType: s } ,function(data){saveDRChange(data,s);});
	}
	function saveDRChange(d,s)
	{
		if (d=="1")
		{
			setDriver(s);

			try
			{
				if (location.href.indexOf('zjlx.asp')>0 || location.href.indexOf('sxlx.asp')>0 || location.href.indexOf('sjlx.asp')>0 || location.href.indexOf('mnks.asp')>0 || location.href.indexOf('test.asp')>0)
				{
					setTimeout('window.location=location.href;',500);
				}

				$('#ViewDriveType').html('<font color=red>'+s+'</font>');
				setTimeout("$('#ViewDriveType').html('"+s+"');",1500);
				selectDriveClose();
			}
			catch (e)
			{
			}
		}
	}



//-->