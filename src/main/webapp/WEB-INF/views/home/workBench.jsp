<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>工作台</title>
 <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<link rel="stylesheet" href="${pageContext.request.contextPath}/layuiadmin/layui/css/layui.css" media="all">
<script type="text/javascript" src="${pageContext.request.contextPath}/layuiadmin/layui/layui.js"></script>
	
<style>
	#mydiv{
		
	    width: 100%;
	    height: 850px;           
	}
	#f1,#f2,#f3,#f4,#f5{
		width: 100%;
		height: 20%;
	}
</style>
	
</head>
<body>
	<div id="mydiv" >
		<div id="f1" style = "position: relative;">
			<span style = "height:100%;width:12.5%;position:absolute;">
				 <button type="button" id="cloudService" class="cloudService" onclick="cloudClick()" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">云服务</button>
				 <button type="button" id="openCloud" onclick="openCloud()" class="" style = "height:15%;width:18%;position:absolute;left:30%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">开通</button>
				 <button type="button" id="CloudDetails" class="" style = "height:15%;width:18%;position:absolute;left:56%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">了解</button>
			</span>
			<span style = "height:100%;width:12.5%;position:absolute;left:12.5%">
				 <button type="button" class="" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">合同管理</button>
				 <button type="button" class="" style = "height:15%;width:18%;position:absolute;left:30%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">开通</button>
				 <button type="button" class="" style = "height:15%;width:18%;position:absolute;left:56%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">了解</button>
			</span>
			<span style = "height:100%;width:12.5%;position:absolute;left:25%">
				 <button type="button" class="" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">项目管理</button>
				 <button type="button" class="" style = "height:15%;width:18%;position:absolute;left:30%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">开通</button>
				 <button type="button" class="" style = "height:15%;width:18%;position:absolute;left:56%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">了解</button>
			</span>
			<span style = "height:100%;width:12.5%;position:absolute;left:37.5%">
				 <button type="button" class="" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">费用管理</button>
				 <button type="button" class="" style = "height:15%;width:18%;position:absolute;left:30%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">开通</button>
				 <button type="button" class="" style = "height:15%;width:18%;position:absolute;left:56%;top:65%;font-size:smaller;border-radius: 25%;background: #28b6cc;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">了解</button>
			</span>
		</div>
		<div id="f2" style = "position: relative;">
			<span style = "height:100%;width:12.5%;position:absolute;">
				 <button type="button" class="" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #e58b00;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">人员去向</button>
			</span>
			<span style = "height:100%;width:12.5%;position:absolute;left:12.5%;">
				 <button type="button" class="" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #2eba45;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">通知公告</button>
			</span>
			<span style = "height:100%;width:12.5%;position:absolute;left:25%;">
				 <button type="button" class="" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #eae723;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">发布广告</button>
			</span>
			<span style = "height:100%;width:12.5%;position:absolute;left:37.5%;">
				 <button type="button" class="" style = "height:50%;width:43%;position:absolute;left:30%;top:15%;border-radius: 25%;font-size:xx-large;background: #d09073;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">后台管理</button>
			</span>
		</div>	
		<div id="f3"></div>
		<div id="f4"></div>
		<div id="f5"></div>
	</div>
	
	
	<script type="text/javascript">
	 function cloudClick(){  
		 window.parent.document.getElementById('4').click();
     }  
	 

	</script>
</body>
</html>