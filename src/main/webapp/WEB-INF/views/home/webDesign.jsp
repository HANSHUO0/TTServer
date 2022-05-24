<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>页面设计器</title>
	
    
   
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
    <style>
        .button div.dhxform_btn div.dhxform_btn_txt {
            height: 22px;
            line-height: 22px;
        }
    </style>
    <script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/Scripts/json2.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/jquery.form.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/jquery.cookie.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/DateFormat.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/Print/jquery.jqprint.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/Print/jquery.PrintArea.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/Scripts/jquery-ui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/Scripts/Designer/Designer.js"></script>
    
    <style>
    html, body {
        width: 100%;
        height: 100%;
        margin: 0px;
        overflow: hidden;
    }

  </style>

</head>
<body>

<div id="winVP" style="width:86%;height:95%;margin-left:7%;box-shadow: 0 0 6px #a0a0a0;margin-top:1.5%;overflow:scroll;"></div>
 <script>
 var o = document.getElementById('winVP');
 var w = o.clientWidth||o.offsetWidth;
 initialization(w-422);
 </script>
</body>
</html>