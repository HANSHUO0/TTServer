<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>云服务</title>
 <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<link rel="stylesheet" href="${pageContext.request.contextPath}/layuiadmin/layui/css/layui.css" media="all">
<script type="text/javascript" src="${pageContext.request.contextPath}/layuiadmin/layui/layui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/layuiadmin/createTab.js"></script>
<style>
	#mydiv{		
	    width: 1500px;
	    height: 850px;           
		}
</style>
</head>
<body>
	<div id="mydiv">
		<div style="width:100%;height:8%;font-size:xx-large;position: relative;">
			<p style="position:absolute;left:2.5%;top:20%;">云服务</p>
		</div>
		<div style="width:100%;height:3%;position: relative;">
			<p style="position:absolute;left:2.5%;top:20%;">基础设置</p>
		</div>
		<div style="width:95%;height:15%;border-top: 5px solid #4202f1;position: relative;left:2.5%" >
			<span style = "height:100%;width:10%;position:absolute;">
				<button onclick="customerClick();" style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">客户档案</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:10%;">
				<button onclick="addCustomerClick();" style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">新增客户</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:20%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">有效期维护</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:30%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">积分规则</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:40%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #4202f1;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">参数设置</button>
			</span>
		</div>
		<div style="width:100%;height:3%;position: relative;">
			<p style="position:absolute;left:2.5%;top:20%;">日常业务</p>
		</div>
		<div style="width:95%;height:15%;border-top: 5px solid #e58b00;position: relative;left:2.5%">
			<span style = "height:100%;width:10%;position:absolute;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #e58b00;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">服务请求</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:10%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #e58b00;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">工单派发</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:20%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #e58b00;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">工单受理</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:30%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #e58b00;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">工单回访</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:40%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #e58b00;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">投诉受理</button>
			</span>
		</div>
		<div style="width:100%;height:3%;position: relative;">
			<p style="position:absolute;left:2.5%;top:20%;">报表统计</p>
		</div>
		<div style="width:95%;height:15%;border-top: 5px solid #2eba45;position: relative;left:2.5%">
			<span style = "height:100%;width:10%;position:absolute;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #2eba45;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">服务看板</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:10%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #2eba45;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">工单列表</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:20%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #2eba45;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">积分统计</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:30%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #2eba45;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">到期查询</button>
			</span>
			<span style = "height:100%;width:10%;position:absolute;left:40%;">
				<button style = "height:50%;width:50%;position:absolute;left:25%;top:25%;border-radius: 25%;font-size:x-large;background: #2eba45;color:#ffffff;border-color:#ffffff;box-shadow: 5px 5px 5px #888888;">投诉分析</button>
			</span>
		</div>
	</div>
	<script type="text/javascript">
	 function customerClick(){ 
		var a = window.parent.document.getElementById("8").click();	
     }  
	 
	 function addCustomerClick(){
		var a = window.parent.document.getElementById("9").click();		
	 }
	</script>
</body>
</html>