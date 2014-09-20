function zzk_go() {
    var keystr = encodeURIComponent(document.getElementById('q').value);
    window.location = "http://zzk.cnblogs.com/s?w=" + keystr;
}
function zzk_go_enter(event) {
    if (event.keyCode == 13) {
        zzk_go();
        return false;
    }
}

function google_search() {
    var keystr = encodeURIComponent(document.getElementById('google_keyword').value);
    window.location = "/search.aspx?keyword=" + keystr;
}
function google_search_enter(event) {
    if (event.keyCode == 13) {
        google_search();
        return false;
    }
}

/* Digg Begin */
var currentDiggType;
var currentDiggEntryId;

function DiggIt(entryId, blogId, diggType) {
    currentDiggEntryId = entryId;
    ShowDiggMsg('提交中...');
    currentDiggType = diggType;
    $.ajax({
        url: '/ws/digg.asmx/digg',
        data: '{entryId:' + entryId + ',blogId:' + blogId + ',diggType:' + diggType + '}',
        type: 'post',
        dataType: 'json',
        contentType: 'application/json; charset=utf8',
        success: function(data) {
            ShowDiggMsg('');
            if (data.d == -1) {
                location.href = "http://passport.cnblogs.com/login.aspx?ReturnUrl=" + location.href;
            }
            else if (data.d == -2) {
                if (confirm("您已经评价过该文章！要取消评价吗？")) {
                    CancelDigg(entryId);
                }
            }
            else if (data.d == 0) {
                alert('操作失败，请与管理员联系！');
            }
            else {
                
                if (diggType == 1) {
                    $("#digg_count_" + entryId).html(parseInt($("#digg_count_" + entryId).html()) + 1);
                }
                else if (diggType == 2) {
                    $("#bury_count_" + entryId).html(parseInt($("#bury_count_" + entryId).html()) + 1);
                }
                ShowDiggMsg('提交成功');
            }
        },
        error: function(xhr) {
            alert("提交出错，请重试。错误信息：" + xhr.responseText);
        }
    });
}


function CancelDigg(entryId) {
    ShowDiggMsg('操作中...');
    $.ajax({
        url: '/ws/digg.asmx/CancelDigg2',
        data: '{entryId:' + entryId + '}',
        type: 'post',
        dataType: 'json',
        contentType: 'application/json; charset=utf8',
        success: function(data) {
            if (data.d) {
                if (data.d == 1) {
                    $("#digg_count_" + entryId).html(parseInt($("#digg_count_" + entryId).html()) - 1);
                }
                else if (data.d == 2) {
                    $("#bury_count_" + entryId).html(parseInt($("#bury_count_" + entryId).html()) - 1);
                }
                ShowDiggMsg('取消成功');
            }
        },
        error: function(xhr) {
            alert("提交出错，请重试。错误信息：" + xhr.responseText);
        }
    });
}

function ShowDiggMsg(msg) {
    $("#digg_tip_" + currentDiggEntryId).css("color", "red");
    $("#digg_tip_" + currentDiggEntryId).html(msg);
}

function AjaxPost(url, postData, successFunc) {
    $.ajax({
        url: url,
        data: postData,
        type: 'post',
        dataType: 'json',
        contentType: 'application/json; charset=utf8',
        success: function(data) {
            if (data.d) {
                successFunc(data.d);
            }
        }
    });
}

function GetDiggCount() {
    var entryIdList = $("#span_entryid_list").html();
    $.ajax({
        url: '/wcf/DiggService.svc/GetDiggCountList',
        data: '{"entryIdList":"' + entryIdList + '"}',
        type: 'post',
        dataType: 'json',
        contentType: 'text/json',
        success: function(data) {
            if (data.d) {
                var entryIdArray = entryIdList.split(',');
                var diggCountArray = data.d.split(',');
                for (var i = 0; i < diggCountArray.length; i++) {
                    $("#digg_count_" + entryIdArray[i]).html(diggCountArray[i]);                    
                }
            }
        }
    });
}

function GetFeedbackCount() {
    var entryIdList = $("#span_entryid_list").html();
    $.ajax({
    url: '/ws/BlogPost.asmx/GetFeedbackCountList',
        data: '{entryIdList:"' + entryIdList + '"}',
        type: 'post',
        dataType: 'json',
        contentType: 'application/json; charset=utf8',
        success: function(data) {
            if (data.d) {
                var entryIdArray = entryIdList.split(',');
                var feedbackCountArray = data.d.split(',');
                for (var i = 0; i < entryIdArray.length; i++) {
                    $("#feedback_count_" + entryIdArray[i]).html(feedbackCountArray[i]);
                }
            }
        }
    });
}

function GetViewCount() {
    var entryIdList = $("#span_entryid_list").html();
    $.ajax({
    url: '/ws/BlogPost.asmx/GetViewCountList',
        data: '{entryIdList:"' + entryIdList + '"}',
        type: 'post',
        dataType: 'json',
        contentType: 'application/json; charset=utf8',
        success: function(data) {
            if (data.d) {
                var entryIdArray = entryIdList.split(',');
                var viewCountArray = data.d.split(',');
                for (var i = 0; i < entryIdArray.length; i++) {
                    $("#viewcount_" + entryIdArray[i]).html(viewCountArray[i]);
                }
            }
        }
    });
}

/* Digg End */

function setTab(name, content_name, current, count) {
	for (i = 1; i <= count; i++) {
		var title = document.getElementById(name + i);
		var content = document.getElementById(content_name + i);
		title.className = i == current ? "current" : "";
		content.className = i == current ? "block_show" : "block_hidden";
	}
}

function showOrderLink() {
	document.getElementById("order_link").style.borderColor = "#ccc";
	document.getElementById("order_link_content").style.display = "";
}
function hideOrderLink() {
	document.getElementById("order_link").style.borderColor = "white";
	document.getElementById("order_link_content").style.display = "none";
}

function cateShow(index) {
    document.getElementById("cate_content_block_" + index).style.display = 'block';
    document.getElementById("cate_item_" + index).className = 'cate_item_hover';
}
function cateHidden(index) {
    document.getElementById("cate_content_block_" + index).style.display = 'none';
    document.getElementById("cate_item_" + index).className = '';
}