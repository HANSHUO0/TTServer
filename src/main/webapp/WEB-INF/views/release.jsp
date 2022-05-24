<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/fonts/font_awesome/css/font-awesome.min.css" media="" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
  	<script src="${pageContext.request.contextPath}/layuiadmin/jquery.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/Scripts/json2.js"></script>
  	<script src="${pageContext.request.contextPath}/Scripts/jquery.form.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/jquery.cookie.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/DateFormat.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/Scripts/jquery-ui.js"></script>
    <style>
	    html, body {
	        width: 100%;
	        height: 100%;
	        margin: 0px;
	        overflow:auto;
	        background:#F8F8F8;
	        display:flex;
	    }
	
  	</style>
	<script type="text/javascript">
		$(function () {
		
			var length;
			var myLayout = new dhtmlXLayoutObject("see", "1C");
			myLayout.cells("a").hideHeader();
			myLayout.cells("a").setHeight(3000);	
			$.ajax({
		    	type: 'POST',
		    	url: '/menu/selgroupdata.action',
		    	data:{UserID:window.top.getID(),cGroupName:window.top.getName(),title:window.top.getTitle()},
		    	success: function(res){
		    		var data = JSON.parse(res);
					var layout = dhtmlx.layout(data,myLayout.cells("a"),data.designName);				
		    	}
        	});
			  
		});
	
	</script>
</head>
<body>
<div id ="seeBox" style="width:75%;height:2800px;margin-left:15%;margin-top:2.5%;margin-bottom:2%;box-shadow: 0 0 10px #a0a0a0;">
	<div id = "see" style="width:100%;height:2800px;"> </div>
</div>

</body>
</html>