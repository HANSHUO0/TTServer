<%@ page import="com.yy.entity.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>TTServer</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/layuiadmin/layui/css/layui.css"
	media="all">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/layuiadmin/style/admin.css"
	media="all">
	<style type="text/css">
		.layui-nav-child a{
			color:#FC0D00;
        }
   		.inner-container::-webkit-scrollbar {
  			display: none;
		}
		
	</style>

</head>
<body class="layui-layout-body">
	<div id="LAY_app">
		<div class="layui-layout layui-layout-admin">
			<div class="layui-header">
				<!-- 头部区域 -->
				<ul class="layui-nav layui-layout-left">					
					
					<li class="layui-nav-item" lay-unselect id="refresh"><a href="javascript:;"
						layadmin-event="refresh" title="刷新"> <i
							class="layui-icon layui-icon-refresh-3"></i>
					</a></li>
					<%--公司名称--%>
					<li class="layui-nav-item layui-hide-xs" lay-unselect style="margin-right:10px"> 
						<select id="roleId" lay-filter="roleId"  style="border: 0px;height:30px;border-radius:5px;-webkit-appearance: none;padding-left:10px;padding-right:10px;">
						</select>    
					</li>
					<li class="layui-nav-item" lay-unselect id="addgroup" style="margin-left:0px;margin-right:10px"><a
						layadmin-event="addgroup" title="创建组织"> <i
							class="layui-icon layui-icon-add-circle" style="font-size: 20px;"></i>
					</a></li>
					<li class="layui-nav-item" lay-unselect  style="margin-left:0px;margin-right:10px"><a
						layadmin-event="progress" id="progress" title="进度查询"> 
					</a></li>
					
				</ul>
				<ul class="layui-nav layui-layout-right"
					lay-filter="layadmin-layout-right">

					<%--调色--%>
					<li class="layui-nav-item layui-hide-xs" lay-unselect><a
						href="javascript:;" layadmin-event="theme"> <i
							class="layui-icon layui-icon-theme"></i>
					</a></li>
					
					<%--用户名--%>
					<li class="layui-nav-item" lay-unselect>
						<a href="javascript:;">
							<cite id="userName"></cite>
						</a>
						<dl class="layui-nav-child">						
							<dd>
								<a lay-href="">修改密码</a>
							</dd>
												
						</dl>
					</li>
				</ul>
			</div>

		
		<div class="layui-side layui-side-menu" id="menu">
				<div class="layui-side-scroll">					
					<ul class="layui-nav layui-nav-tree" lay-shrink="all" id="LAY-system-side-menu-head" lay-filter="layadmin-system-side-menu">
						<li data-name="chat" class="layui-nav-item">							
							   <img id="headImage" src="" style="width:40px;height:40px;margin-left:10px;" />
						</li>

					</ul>
					<ul class="layui-nav layui-nav-tree" lay-shrink="all"
						id="LAY-system-side-menu" <%--lay-tips="layadmin-system-side-menu"--%> style="height:75%">
						<li data-name="chat" class="layui-nav-item">
							<span class="boxFont"></span>
							<a href="javascript:;" lay-tips="沟通" lay-href="${pageContext.request.contextPath }/pay/toin.action?ID=${ID}">
							   <i class="layui-icon layui-icon-chat"></i> 
								<cite style="display:none">沟通</cite>
						    </a>
						</li>

						<li data-name="friends" class="layui-nav-item">
							<a href="javascript:;" lay-tips="通讯录" lay-href="${pageContext.request.contextPath }/view/todepartment.action"> 
							   <i class="layui-icon layui-icon-friends" ></i> 
							   <cite style="display:none">通讯录</cite>
						    </a>						   
						</li>
						
						<c:forEach var="outMenu" items="${menu }">
							<c:if test="${outMenu.parentId == 0 }">
								<li data-name="home" id="tool" class="layui-nav-item">
									<a <c:if test="${outMenu.url !='' && outMenu.url != null}">lay-href="${pageContext.request.contextPath }${outMenu.url }"</c:if>
										href="javascript:;" lay-tips="${outMenu.title }" >
										<i class="${outMenu.icon}" onmouseover="show(this)" onmouseout="out()"></i> 
								   		<cite style="display:none">${outMenu.title }</cite>						
									</a>
								
									<c:forEach var="midMenu" items="${menu}">
										<c:if test="${midMenu.parentId == outMenu.id }">
											<dl style="display:none;" >
												<dd>
													<a id="${midMenu.id}" onmouseover="showChild(this)" onmouseout="outChild()" style="color:#F0F0F0;margin-left:30px;font-size:15px" onclick="getAid(this)" 
													<c:if test="${midMenu.url !='' && midMenu.url != null}">lay-href="${pageContext.request.contextPath}${midMenu.url }"</c:if>>${midMenu.title }</a>
													<c:forEach var="innerMenu" items="${menu }">
														<c:if test="${innerMenu.parentId == midMenu.id }">
															<dl class="innerMenu" style="display:none;position:relative;margin-top:8px;">
																<dd>
																	<i class="${innerMenu.icon }" style="margin-left:30px;"></i>																
																	<a id="${innerMenu.id }" style="color:#F0F0F0;margin-right:20px;font-size:13px" onclick="getAids(this)" lay-href="${pageContext.request.contextPath }${innerMenu.url }">${innerMenu.title }</a>
																	
																</dd>
															</dl>
														</c:if>
													</c:forEach>
												</dd>
											</dl>
										</c:if>
									</c:forEach>
								</li>
							</c:if>
						</c:forEach>						
						<li data-name="set" class="layui-nav-item" style="position:fixed;width:60px;bottom:0px; ">
							<a href="javascript:;" lay-tips="设置" lay-href="${pageContext.request.contextPath }/view/todetails.action">
							   <i class="layui-icon layui-icon-set" ></i> 
							   <cite style="display:none">设置</cite>
						    </a>						   
						</li>						 
					</ul>			
				</div>
			</div>
			<!-- 页面标签 -->
			<div class="layadmin-pagetabs" id="LAY_app_tabs">
				<div class="layui-icon layadmin-tabs-control layui-icon-prev"
					layadmin-event="leftPage"></div>
				<div class="layui-icon layadmin-tabs-control layui-icon-next"
					layadmin-event="rightPage"></div>
				<div class="layui-icon layadmin-tabs-control layui-icon-down" >
					<ul class="layui-nav layadmin-tabs-select"
						lay-filter="layadmin-pagetabs-nav">
						<li class="layui-nav-item" >
						<a href="javascript:;"></a>
							<dl class="layui-nav-child ">
								<dd>
									<a layadmin-event="closeThisTabs" style="color:blue;z-index: 99" >关闭当前标签页</a>
								</dd>
								<dd>
									<a layadmin-event="closeOtherTabs">关闭其它标签页</a>
								</dd>
								<dd>
									<a layadmin-event="closeAllTabs">关闭全部标签页</a>
								</dd>
							</dl>
						</li>
					</ul>
				</div>
				<div class="layui-tab" lay-unauto lay-allowClose="true" lay-filter="layadmin-layout-tabs">
					<ul class="layui-tab-title" id="LAY_app_tabsheader">
						<li lay-id="console.jsp" lay-attr="console.jsp" class="layui-this"><i
							class="layui-icon layui-icon-home"></i></li>
					</ul>
				</div>
			</div>


			<!-- 主体内容 -->
			<div class="layui-body" id="LAY_app_body">
				<div class="layadmin-tabsbody-item layui-show">				
				</div>
			</div>

			
		</div>
		
		<!-- 悬浮 -->
		<div class="shade" style="display:none;width:200px;height:500px;" onmouseover="show()" onmouseout="out()">
			<ul  style="overflow: hidden;width:100%;">
				<li  class="inner-container" style="width:150px;height:450px;overflow-y:scroll;scrollbar-width: none;">
				</li>
			</ul>
		</div>
		
		<div class="shadeSed" style="display:none;" onmouseover="showChild()" onmouseout="outChild()">
			<ul  style="height:450px;display:flex;">
				<li style="width:150px;height:450px;border-right:1px dashed #D8D8D8">
					<p style="margin-left:40px;margin-top:40px;color:#ffffff;">基础设置</p>	
				</li>
				<li style="width:150px;height:450px;border-right:1px dashed #D8D8D8">
					<p style="margin-left:40px;margin-top:40px;color:#ffffff;">日常业务</p>
				</li>
				<li style="width:150px;height:450px;border-right:1px dashed #D8D8D8">
					<p style="margin-left:40px;margin-top:40px;color:#ffffff;">报表统计</p>
				</li>
			</ul>
		</div>
	</div>

	<script src="${pageContext.request.contextPath }/layuiadmin/layui/layui.js"></script>
	<script src="${pageContext.request.contextPath }/layuiadmin/jquery.js"></script>
	

	<script>

		showUnRead();

		layui.config({
			base : '${pageContext.request.contextPath }/layuiadmin/' //静态资源所在路径
		}).extend({
			index : 'lib/index' //主入口模块
		}).use('index');
		
		//根据缩放比例还原
		//var t = window.devicePixelRatio;console.log(t)
		//document.body.style.zoom =1/t;



		$('#userName')[0].innerHTML='${User.psnName}';
		var localTest = layui.data('test');
		var id = '${ID}';

		//获取图片地址
		var path = '${HeadImageData}';
		// console.log(path);
		//加载图片
		$('#headImage').attr('src',"/img/"+path);

		//用户的组织	
		$.ajax({
		    	type: 'POST',
		    	url: '${pageContext.request.contextPath}/group/selgroup.action',
		    	data:{ID:'${ID}',IsDel:0},
		    	success: function(res){

		    		var html = ''; 
		    		for (var r of res.data){
		    			if(r.cgroupName == localTest[id]){
		    				$('#roleId')[0].setAttribute("aaa",localTest[id]);
		    				html += '<option value="'+r.id+'" selected>'+r.cgroupName+'</option>';
		    			}
		    			else {
		    				html += '<option value="'+r.id+'">'+r.cgroupName+'</option>';
    					}
		    		}
		    	
		    		$('#roleId').append(html); //将HTML追加下拉框里	    		
		    		isTrueUrl();
		    	}
		  });
		
		
		
		
		function isTrueUrl(){
			var urls = location.href;
			if(urls.split('cGroupName=').length<2){
				var localTest = layui.data('test');
				if(localTest[id]){
					var url = location.href + '&cGroupName='+ localTest[id];
					location.replace(url);
				}else{
					var sel= document.getElementById('roleId');
					var val = sel.options[0].innerHTML;
					var url = location.href + '&cGroupName='+ val;
					location.replace(url);
				}
				
			}
		    
		}
		
		

		var timer = null,title =null,timer2 = null,title2 =null;
		function show(e){


			if(timer) clearTimeout(timer);
		    var width =  $('.layui-side-menu')[0].clientWidth;
		    var color = $('#menu').css('background-color');			
			var b = $('.shade')[0].children[0].children[0].children;
	    	if(b){	    		
	    		if(title != e.parentNode){
					for(let i=0;i<b.length;i=0){
						b[0].style.display="none";
						b[0].style.position = "";
						title.appendChild(b[0]);	
					}
	    		}
			}
			
			title = e.parentNode.parentNode;
			var num = siblings(e.parentNode).length;
		    if(num!=0){
		    	$('.shade')[0].style.cssText='background-color:'+color+';width:150px;height:500px;position:absolute;left:'+width+'px;top:90px;z-index: 99999;';		 	
		    	for(let t of siblings(e.parentNode)){
		    		var add = document.createElement("dl");
		    		add = t;
		    		$('.shade')[0].children[0].children[0].appendChild(add);		    		
		    	}
		    	var a = $('.shade')[0].children[0].children[0].children;
		    	for(let i of a){
		    		i.style.cssText = "display:block;position:relative;margin-top:20px;height:30px;background-color:"+color;    		
		    	}
		    }
		   
		  }
		
		function out(){	    
			timer = setTimeout(function(){
		    	var b = $('.shade')[0].children[0].children[0].children;
		    	if(b){
					for(let i=0;i<b.length;i=0){
						b[0].style.display="none";
						title.appendChild(b[0]);			
					}
				}
		    	$('.shade')[0].style.display = 'none';
		    },200);
 		}
		
		function showChild(e){
			 if(timer) clearTimeout(timer);
			 if(timer2) clearTimeout(timer2);
			
			 var a = $('.shadeSed')[0].children[0].children;
			 var b = $('.shadeSed')[0].children[0].children[0].children;
			 if(b.length>1){
				if(title != e.parentNode){
					for(let j of a){
						var k = j.children;
						for(let i=1;i<k.length;i=1){
							k[1].style.display="none";
							k[1].style.position = "";
							title2.appendChild(k[1]);	
						}
					}
					
	    		}
			}
			title2 = e.parentNode;
			 
			 var color = $('#menu').css('background-color');
			 var width =  $('.layui-side-menu')[0].clientWidth + $('.shade')[0].clientWidth;
				var num = e.parentNode.children.length;
			    if(num!=1){
			    	if(e.children.length ==0){
			    		var button = document.createElement("i");
						button.setAttribute("class","layui-icon layui-icon-triangle-r");
						button.setAttribute("style","margin-left:40px");
						e.append(button);
			    	}
			    	
			    	$('.shadeSed')[0].style.cssText='background-color:#B0B0B0;width:450px;height:500px;position:absolute;left:'+width+'px;top:90px;z-index: 99999;';		 	
			    	for(var i=1;i<num;i++){
			    		var add = document.createElement("dl");
			    		add = e.parentNode.children[1];
			    		var name = add.children[0].children[1].innerHTML;
			    		add.style.cssText = "display:block;position:relative;margin-top:20px;height:20px;background-color:#B0B0B0s"; 
			    		if(name=='客户档案'||name=='新增客户'||name=='有效期维护'||name=='积分规则'||name=='参数设置'||name=='定义自增规则')
			    			$('.shadeSed')[0].children[0].children[0].append(add);	
			    		if(name=='服务请求'||name=='工单派发'||name=='工单受理'||name=='工单回访'||name=='投诉受理')
				    		$('.shadeSed')[0].children[0].children[1].append(add);
			    		if(name=='服务看板'||name=='工单列表'||name=='积分统计'||name=='到期查询'||name=='投诉分析')
				    		$('.shadeSed')[0].children[0].children[2].append(add);	
			    	}
			    	
			    }
		}
		
		
		
		
		function outChild(){
			timer2 = setTimeout(function(){
				 if(title2.children[0].children[0]){
					 title2.children[0].children[0].remove();
				 }
				 var a = $('.shadeSed')[0].children[0].children;
				 var b = $('.shadeSed')[0].children[0].children[0].children;
				 if(b.length>1){		
						for(let j of a){
							var k = j.children;
							for(let i=1;i<k.length;i=1){
								k[1].style.display="none";
								k[1].style.position = "";
								title2.appendChild(k[1]);	
							}
						}
				}
		    	
		    	$('.shadeSed')[0].style.display = 'none';
		    	timer = setTimeout(function(){
			    	var b = $('.shade')[0].children[0].children[0].children;
			    	if(b){
						for(let i=0;i<b.length;i=0){
							b[0].style.display="none";
							title.appendChild(b[0]);			
						}
					}
			    	$('.shade')[0].style.display = 'none';
			    },500);
		    },500);
			
		}
		

		function siblings(elm) {
			var a = [];
			var p = elm.parentNode.children;
				for(var i =0,pl= p.length;i<pl;i++) {
					if(p[i] !== elm) a.push(p[i]);
				}
			return a;
		}
		function getID(){
			return '${ID}';
		}

		function setNews(str) {
			if (str === "99+"){
				$(".boxFont").text("99+")
			}else {
				$(".boxFont").text(Number(str) + Number($(".boxFont").text()));
			}
			if (Number($(".boxFont").text()) <= 0 || $(".boxFont").text() === 'NaN'){
				$(".boxFont").text('')
			}
		}
		
		function getUser(){
			var a = {name:'${User.psnName}',email:'${User.email}',phone:'${User.mobilePhone}',img:'${User.headImageData}',sex:'${User.sex}',qq:'${User.qq}'
					,birthday:'${User.birthday}',identity:'${User.identity}',signature:'${User.signature}',address:'${User.address}',marriage:'${User.marriage}'
					,sosName:'${User.sosName}',sosPhone:'${User.sosPhone}',emName:'${User.emName}'}
			return a;
		}
		
		
		function getName(){
			var groupName = $('#roleId')[0].options[$('#roleId')[0].selectedIndex].innerHTML;
			return groupName;
		}
		function getGroupID(){
			return $('#roleId')[0].options[$('#roleId')[0].selectedIndex].value;
		}
		var title;
		function getTitle(){
			return title;
		}
		function getGuid() {
			    var s = [];
			    var hexDigits = "0123456789ABCDEF";
			    for (var i = 0; i < 36; i++) {
			        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
			    }
			    s[14] = "4";  
			    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  
			    s[8] = s[13] = s[18] = s[23] = "-";
			 
			    var uuid = s.join("");
			    return uuid;		
		}

		function getAid(e){
			var b = $('.shade')[0].children[0].children[0].children;
	    	if(b){
				for(let i=0;i<b.length;i=0){
					b[0].style.display="none";
					title.appendChild(b[0]);			
				}
			}
	    	$('.shade')[0].style.display = 'none';
		}
		function getAids(e){
			var a = $('.shadeSed')[0].children[0].children;
			 var b = $('.shadeSed')[0].children[0].children[0].children;
			 if(b.length>1){		
					for(let j of a){
						var k = j.children;
						for(let i=1;i<k.length;i=1){
							k[1].style.display="none";
							k[1].style.position = "";
							title2.appendChild(k[1]);	
						}
					}
			}
	    	
	    	$('.shadeSed')[0].style.display = 'none';
		}
			
		
		$("#roleId").change(function(){
			
			var groupName = $('#roleId')[0].options[$('#roleId')[0].selectedIndex].innerHTML;
			layui.data('test', {
				  key: id
				  ,value: groupName
			});
			var url = location.href.split("&")[0] + '&cGroupName='+ groupName;
			location.replace(url);
		 });

		function setImg(src){
			$('#headImage').prop('src',"${pageContext.request.contextPath}/img/"+src);
		}

		//上线显示未读
		function showUnRead() {
			$(".boxFont").text('')
			$.ajax({
				url:'/pay/message.action',
				type:'POST',
				data: {ID:'${ID}'},
				success:function (res){
					// console.log(res)
					var num = 0;
					$.each(res,function (i,n){
							num += n.count;
					})
					if (num != 0)
						$(".boxFont").text(num)
				}
			});
		}


		//上线
		var url = "ws://" + window.location.host + "/webSocketOneToOne/" + getID() + ",123";
		websocket = new WebSocket(url);

		//接收到消息的回调方法
		websocket.onmessage = function(event) {
			setNews(1);
		}



	</script>

</body>
</html>


