<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script src="/script/jquery-1.2.6.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        var iBaseNum = 10;
        $(document).ready(function() {
            var stack = new Array()
            stack.push("a");
            stack.push("b");
            stack.push("c");
            stack.push("d");

            //            for (var i = stack.length; i < 0; i--) {
            //                alert(stack[i]);
            //                //stack[i].pop();
            //            }

            //alert(stack.toString());

            getErrorLibrary();
        });
        function getErrorLibrary() {
            $.ajax({
                url: '/service/QuestionForJson.asmx/MyErrorLabiary',
                data: '{"questionId":"-1","action":"get"}',
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
        function addNumber(n1, n2) {
            function doAddition() {
                return n1 + n2 + iBaseNum;
            }
            return doAddition();
        }
        function go() {
            alert(addNumber(10,20));
        }
        function deleteErrorLibrary(obj) {
            alert(obj == undefined);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <input type="button" onclick="go();" value="222" />
    </div>
    </form>
</body>
</html>
