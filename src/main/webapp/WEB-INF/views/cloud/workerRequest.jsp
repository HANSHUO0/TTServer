<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>服务请求</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
	<script src="${pageContext.request.contextPath }/layuiadmin/layui/layui.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath }/layuiadmin/layui/css/layui.css" media="all">
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
    
	
    <style>
	    html, body {
	        width: 100%;
	        height: 100%;
	        margin: 0px;
	        overflow: hidden;	       
	        background: #eaeaea;
	    }
		
		select {
			appearance:none;
		    -moz-appearance:none;
		    -webkit-appearance:none;
		    background: url("/DHX/imgs/dhxcombo_terrace/dhxcombo_arrow_down.gif") no-repeat scroll right 5px center transparent;
			padding-right: 15px;
		}

		#seeBox {
			width:83%;
			height:2200px;
			margin-left:12%;
			margin-bottom:3%;
			background: #ffffff;
			box-shadow: 0 0 10px #000000;
			font-size:25px;
			text-align:center;		
		}
  	</style>
  	
  	
	
	<script type="text/javascript">
	
$(function () {
	//var t = window.devicePixelRatio;
	//document.body.style.zoom =1/t;
	
	 
	
	
    	var customerID,length,layout,layouts,myForm;
		var myLayout = new dhtmlXLayoutObject("see", "1C");
		myLayout.cells("a").hideHeader();
		myLayout.cells("a").setHeight(2000);		
		
	   $.ajax({
		   type: 'POST',
		   url: '/design/seldesign3.action',
		   data: {DesignName:"设计故障报修"},
		   success: function(res){		
			   var data = JSON.parse(res[0].design);
			   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);		
			   layout.lays[0].cells("a").hideArrow();							  
			   layout.lays[0].cells("a").cell.style.height = '750px';
			   layout.lays[0].cells("a").cell.children[1].style.height = '700px';
			   
			   startLogin();
			   changeWidth(layout,layouts);
			   selectFL();							   
		   }
		});
	
			
		
		
		
		 layouts = new dhtmlXLayoutObject("toolbar", "1C");
		 layouts.cells("a").hideHeader();

		 var myToolbar = layouts.cells("a").attachToolbar();
		 myToolbar.setIconsPath("${pageContext.request.contextPath}/DHX/imgs/dhxtoolbar_terrace/");
		 myToolbar.format({
			 Items:[{ID: "print", Type: "button", Text: "打印布局", Img: "print.gif"},
			        {ID: "designview", Type: "button", Text: "页面布局", Img: "open.gif"},
			        {ID: "sep1", Type: "separator" },
			        {ID: "out", Type: "button",Text: "输出", Img: "output.png"},
			        {ID: "sep2", Type: "separator" },
			        {ID: "save", Type: "button", Text: "保存并新增", Img: "save.gif"},
			        {ID: "save2", Type: "button", Text: "保存并关闭", Img: "save.gif"},
			        {ID: "save3", Type: "button", Text: "修改保存", Img: "save.gif"},
			        {ID: "sep3", Type: "separator" },
			        {ID: "add", Type: "button", Text: "新增", Img: "add.gif"},
			        {ID: "sep4", Type: "separator" },
			        {ID: "sendSomebody", Type: "button", Text: "派发"},
			        {ID: "accept", Type: "button", Text: "受理"},
			        {ID: "returnSend", Type: "button", Text: "重派"},
			        {ID: "changeSomeBody", Type: "button", Text: "转发"},
			        {ID: "finish", Type: "button", Text: "结案"},
			        {ID: "sep5", Type: "separator" },
			        {ID: "selmove", Type: "button", Text: "进度查询"},
			        {ID: "close", Type: "button", Text: "退出"},
			        {ID: "sep99", Type: "separator" },
			        {ID: "input", Type: "input",Width:"100"},
			        {ID: "find", Type: "button",Img: "search.gif"},
			        {ID: "sep6", Type: "separator" },
			        {ID: "first", Type: "button",Img: "ar_left_abs.gif"},
			        {ID: "forward", Type: "button", Img: "ar_left.gif"},
			        {ID: "next", Type: "button", Img: "ar_right.gif"},
			        {ID: "last", Type: "button", Img: "ar_right_abs.gif"}],
			 Spacer: "sep99",
			 Action:function (id){
				 if(id == 'print'){
					 
				   }
				   if(id == 'out'){
						 
				   }				  
				   if(id == 'add'){				   
					   addNewTage();
				   }
				   if(id == 'find'){
					  var cid = myToolbar.getValue("input");
					  $.ajax({
					    	type: 'POST',
					    	url: '/ticket/selticketend.action',
					    	data:{groupID:window.top.getGroupID(),userID:window.top.getID(),cid:cid},
					    	success: function(res){
					    		if(res.data){
					    			sameStart(res);
					    		}else{
					    			dhtmlx.alert('无此工单!');
					    		}
					    		
					    	}
				      	});
				   }
				   if(id == 'selmove'){
					  window.top.document.getElementById('progress').click();
					  
				   }
				   if(id == 'sendSomebody'){
					   if($(".status")[1].style.color !='red'){
						   dhtmlx.alert('不是派发工单!');
					   }else{
						   sendView(null);
					   }			 					  
				   }
				   if(id == 'returnSend'){
					   if($(".status")[3].style.color =='red'||$(".status")[4].style.color=='red'){
						    returnView();
					   }else{
						   dhtmlx.alert('不是受理或者待回访工单!');
					   }	
				   }
				   if(id == 'changeSomeBody'){
					   if($(".status")[3].style.color =='red'){
						   sendView('change');
					   }
				   }
				   if(id == 'finish'){
					   if($(".status")[3].style.color !='red'){
						   dhtmlx.alert('不是待结案工单!');
					   }else{
						   acceptView();
					   }
				   }
				   if(id == 'accept'){
					   if($(".status")[1].style.color =='red'){
						   acceptfunction();
					   }else if($(".status")[2].style.color =='red'){
						   if($("input[name='sendPeople']")[0].value.indexOf(window.top.getUser().name)!=-1){
							   acceptfunction();
						   }
					   }
				   }
				   if(id == 'save2'){
					   
					   if($("input[name='failureDate']")[0].value !=''&&$("input[name='cCusName']")[0].parentNode.children[0].value!=''&&$("input[name='registerPeople']")[0].value!=''&&$("input[name='cContact']")[0].parentNode.children[0].value!=''&&$("input[name='processing']")[0].parentNode.children[0].value!=''&&$("input[name='appointmentDate']")[0].value!=''&&$("input[name='faultType']")[0].parentNode.children[0].value!=''&&$("textarea[name='description']")[0].value!=''){					   
						   var data = getData();						  
						   $.ajax({
							  type: 'POST',
							   url: '/ticket/addticket.action',
							   data: data,
							   success: function(res){
								   window.top.document.getElementsByClassName("layui-this")[1].children[1].click();
							   }
						   });
					   }else{
						   dhtmlx.alert('必填项不能为空');
					   }
					   
				   }
					if(id == 'save3'){
					   
					   if($("input[name='failureDate']")[0].value !=''&&$("input[name='cCusName']")[0].parentNode.children[0].value!=''&&$("input[name='registerPeople']")[0].value!=''&&$("input[name='cContact']")[0].parentNode.children[0].value!=''&&$("input[name='processing']")[0].parentNode.children[0].value!=''&&$("input[name='appointmentDate']")[0].value!=''&&$("input[name='faultType']")[0].parentNode.children[0].value!=''&&$("textarea[name='description']")[0].value!=''){					   
						   var data = getData();						  
						   data.id = localStorage.ticketID;
						   data.progress = 0;
						   
						   $.ajax({
								   type: 'POST',
								   url: '/ticket/editticket.action',
								   data: data,
								   success: function(){
									   location.reload();
								   }
						   })
					   }else{
						   dhtmlx.alert('必填项不能为空');
					   }   
				   }
				   if(id == 'save'){ 
					   if($("input[name='failureDate']")[0].value !=''&&$("input[name='cCusName']")[0].parentNode.children[0].value!=''&&$("input[name='registerPeople']")[0].value!=''&&$("input[name='cContact']")[0].parentNode.children[0].value!=''&&$("input[name='processing']")[0].parentNode.children[0].value!=''&&$("input[name='appointmentDate']")[0].value!=''&&$("input[name='faultType']")[0].parentNode.children[0].value!=''&&$("textarea[name='description']")[0].value!=''){					   
						   var data = getData();					  
						   $.ajax({
								  type: 'POST',
								   url: '/ticket/addticket.action',
								   data: data,
								   success: function(res){
									   addNewTage();
								   }
							   });
					   }else{
						   dhtmlx.alert('必填项不能为空');
					   }
				   }
				   if(id == 'close'){		
					   
					   if(window.parent.id!=null&&window.parent.id!=''){
						   var choose = window.parent.document.getElementsByClassName('layui-this');
						   choose[choose.length-1].children[1].click();  
					   }else{
						   window.parent.location.reload();
						   parent.$("#editRequest").remove();	
					   }
					   
					  
				   }
				   if(id == 'first'){
					   $.ajax({
					    	type: 'POST',
					    	url: '/ticket/selticketfirst.action',
					    	data:{groupID:window.top.getGroupID(),userID:window.top.getID()},
					    	success: function(res){
					    		if(res.data){				    			
					    			sameStart(res);
					    		}
					    		
					    	}
				      	});
				   }
				   if(id == 'forward'){
					   $.ajax({
					    	type: 'POST',
					    	url: '/ticket/selticketforword.action',
					    	data:{groupID:window.top.getGroupID(),cid:$("input[name='cid']")[0].value},
					    	success: function(res){
					    		if(res.data){
					    			sameStart(res);
					    		}else{
					    			dhtmlx.alert('已经是第一页');
					    		}
					    		
					    	}
				      	});
				   }
				   if(id == 'next'){
					   $.ajax({
					    	type: 'POST',
					    	url: '/ticket/selticketnext.action',
					    	data:{groupID:window.top.getGroupID(),userID:window.top.getID(),cid:$("input[name='cid']")[0].value},
					    	success: function(res){
					    		if(res.data){
					    			sameStart(res);
					    		}else{
					    			dhtmlx.alert('已经是最后一页');
					    		}
					    	}
				      	});
				   }
				   if(id == 'last'){
					   $.ajax({
					    	type: 'POST',
					    	url: '/ticket/selticketend.action',
					    	data:{groupID:window.top.getGroupID(),userID:window.top.getID()},
					    	success: function(res){
					    		if(res.data){
					    			sameStart(res);
					    		}
					    		
					    	}
				      	});
				   }
			 }
		 })
		
		 $("div[dir='ltr']")[1].children[0].style.paddingTop = 0;
		 $("div[dir='ltr']")[1].children[0].style.paddingLeft = 0;
		 $("div[dir='ltr']")[1].children[0].style.paddingRight = 0;
		 $("div[dir='ltr']")[1].children[0].style.paddingBottom = 0;
		 $("div[dir='ltr']")[1].children[0].style.height = "28px";
		 $("div[dir='ltr']")[1].children[0].children[0].style.height="20px";
		 $("div[dir='ltr']")[1].children[0].children[0].style.fontSize="15px";
		 
		 
		 function getData(){
			 
				   	   
			   var data = {};
			   data['id'] = localStorage.ptmID;
			   data['userID']= window.top.getID();
			   data['groupID'] = window.top.getGroupID();
			   data['progress'] = '1';
			   data['type'] = '故障报修';
			   if($("select[name='product']")[0].options[$("select[name='product']")[0].selectedIndex])
			   data['product'] = $("select[name='product']")[0].options[$("select[name='product']")[0].selectedIndex].innerHTML;
			   data['cid'] = $("input[name='cid']")[0].value;
			   data['address'] = $("input[name='address']")[0].parentNode.children[0].value;
			   data['failureDate'] = $("input[name='failureDate']")[0].value;
			   data['customerID'] = localStorage.customerID;
			   data['cCusName'] = $("input[name='cCusName']")[0].parentNode.children[0].value;
			   data['cContact'] = $("input[name='cContact']")[0].parentNode.children[0].value;
			   data['registerPeople'] = $("input[name='registerPeople']")[0].value;
			   data['states'] = $("input[name='states']")[0].value;
			   data['cusVIP'] = $("input[name='cusVIP']")[0].value;
			   data['phone'] = $("input[name='phone']")[0].value;
			   data['position'] = $("input[name='position']")[0].value;
			   data['dep'] = $("input[name='dep']")[0].value;
			   data['processing'] = $("input[name='processing']")[0].parentNode.children[0].value;
			   data['appointmentDate'] = $("input[name='appointmentDate']")[0].value;
			   data['emergency'] = $("input[name='emergency']")[0].parentNode.children[0].value;
			   data['faultType'] = $("input[name='faultType']")[0].parentNode.children[0].value;
			   data['serialNumber'] = $("input[name='serialNumber']")[0].value;
			   data['endDate'] = $("input[name='endDate']")[0].value;
			   data['inSources'] = $("input[name='inSources']")[0].parentNode.children[0].value;
			   data['description'] = $("textarea[name='description']")[0].value;
			   return data;
		 }
		 
		 
		 function acceptfunction(){
			 var data = $.parseJSON(localStorage.ticket);
			  
			    var ticketID = data.id;
	      		var data = {id:window.top.getGuid(),groupID:window.top.getGroupID(),ticketID:ticketID,userName:window.top.getUser().name,assignee:window.top.getID(),progress:3};	
	      		var date = new Date();
	      		var Y = date.getFullYear() + '/';
				var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '/';
				var D = date.getDate()+' ';
				if(D.length == 1) D = "0"+ D;
				var H = date.getHours() + ':';
				var minute= date.getMinutes();
				data.acceptanceDate = Y+M+D+H+minute;
	      		
				$.ajax({
		 			   type: 'POST',
		 			   url: '/ticket/addticketaccept.action',
		 			   data: data,
		 			   success: function(res){
		 				  location.reload();
		 			   }
		       	})
		 }
		 
		 
		 function sendView(e){
			 var w1 = dhtmlx.showDialog({
		            caption: e==null?'派发报修单':"转发保修单",
		            width: 800,
		            height: 400,
		            saveText: e==null?"确定派发":"确定转发",
		            save: function(){
		            	if($("input[name='claimDate']")[1].value !=''&&$("input[name='finishDate']")[1].value !=''&&$("input[name='sendPeople']")[1].parentNode.children[0].value !=''){
		            		var getUserIDs = localStorage.getUserIDs;
		            		var ticketID = localStorage.ticketID;
		            		localStorage.removeItem('getUserIDs');		            		
		            		var data = {id:window.top.getGuid(),groupID:window.top.getGroupID(),ticketID:ticketID,userID:window.top.getID(),progress:6,getUserID:getUserIDs,claimDate:$("input[name='claimDate']")[1].value,finishDate:$("input[name='finishDate']")[1].value,wages:$("input[name='wages']")[1].value,otherMes:$("textarea[name='otherMes']")[1].value};
		            		data.endDate = $("input[name='endDate']")[0].value;
		            		data.sendDate = $("input[name='sendDate']")[1].value;
		            		data.userName = window.top.getUser().name;		            		
		            		data.getUserName = $("input[name='sendPeople']")[1].parentNode.children[0].value;
		            		data.processing2 = $("input[name='processing2']")[1].parentNode.children[0].value;
		            		if(e==null){
		            			data.isDel = '0';
		            			 $.ajax({
				      				   type: 'POST',
				      				   url: '/ticket/addticketprogress.action',
				      				   data: data,
				      				   success: function(res){		      					   					 
				      					 location.reload();
				      				   }
				            	})
		            		}else if(e=='change'){
		            			data.isDel = '2';
		            			$.ajax({
				      				   type: 'POST',
				      				   url: '/ticket/changeticketprogress.action',
				      				   data: data,
				      				   success: function(res){		      					   					 
				      					 location.reload();
				      				   }
				            	})
		            		}
		            	}
		            	
		            }
			 })
			 var lay = w1.layout.cells("a");
			 var tool = lay.getAttachedToolbar();
			 $.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"设计派发信息"},
				   success: function(res){		
					   var data = JSON.parse(res[0].design);
					   dhtmlx.layout(data,lay,res[0].designName);
					   
					   var date = new Date();
						var Y = date.getFullYear() + '/';
						var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '/';
						var D = date.getDate()+' ';
						if(D.length == 1) D = "0"+ D;
						var H = date.getHours() + ':';
						var minute= date.getMinutes();

						$("input[name='sendDate']")[1].value = Y+M+D+H+minute;
						$("input[name='legalPerson']")[1].value = $("input[name='registerPeople']")[0].value;
						$("input[name='claimDate']")[1].value = $("input[name='appointmentDate']")[0].value;
						$("input[name='finishDate']")[1].value = $("input[name='appointmentDate']")[0].value;
						
					   $('.dhxcombo_select_img').on('click',function(e){
						   var name = e.target.parentNode.parentNode.children[1].getAttribute('name');					
							if(name == 'sendPeople'){sendSomebody(e)}
							if(name == 'processing2'){sameSelect(e,'processing','选择处理方式','处理方式',$("input[name='processing']")[0])}
					   })
				   }
			 })
		 }
		 
		 
		 
		 function returnView(){
			 var ticketID = localStorage.ticketID;
			 layui.use('layer', function(){
					var layer = layui.layer;
					  
					layer.open({
						title: '重派'
						,content: "重派原因：<input class='dhxform_textarea message' style='height:25px' type='text' />"
						,btnAlign: 'c'
						,yes: function(index, layero){
							
				    		
				    		var data = {groupID:window.top.getGroupID(),id:ticketID,progress:7,operationPeople:window.top.getUser().name,message:$('.message')[0].value};
				    		
						    $.ajax({
								   type: 'POST',
								   url: '/ticket/editticket.action',
								   data: data,
								   success: function(){
									   for(var i of checked.split(',')){
										   myGrid.deleteRow(i);
							    		} 
								   }
						   })
						    layer.close(index); 
						    location.reload();
						  }
					});     
				});
		 }
		 
		 function acceptView(){
			 var w1 = dhtmlx.showDialog({
		            caption: '结案信息',
		            width: 850,
		            height: 400,
		            saveText: "确定结案",
		            save: function(){	
		            	var ticketID = localStorage.ticketID;         		   
	            		var data = {id:window.top.getGuid(),groupID:window.top.getGroupID(),ticketID:ticketID,casePerson:window.top.getID(),progress:4,errorReason:$("textarea[name='errorReason']")[1].value,solve:$("textarea[name='solve']")[1].value};			            		
	            		data.userName = window.top.getUser().name;            		
	            		data.processing3 = $("input[name='processing3']")[1].parentNode.children[0].value;
	            		data.caseDate = $("input[name='caseDate']")[1].value;
	            		data.integral = $("input[name='integral']")[1].value;
	            		
	            		$.ajax({
	     				   type: 'POST',
	     				   url: '/ticket/editticketaccept.action',
	     				   data: data,
	     				   success: function(res){
	     					  location.reload();
	     				   }
	            		})
	            		
		            }
			 })
			 var lay = w1.layout.cells("a");
			 var tool = lay.getAttachedToolbar();
			 $.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"设计结案信息"},
				   success: function(res){		
					   var data = JSON.parse(res[0].design);
					   dhtmlx.layout(data,lay,res[0].designName);
					   
					   	var date = new Date();
						var Y = date.getFullYear() + '/';
						var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '/';
						var D = date.getDate()+' ';
						if(D.length == 1) D = "0"+ D;
						var H = date.getHours() + ':';
						var minute= date.getMinutes();
						
						$("input[name='assignee']")[1].value = $("input[name='assignee']")[0].value;
						$("input[name='acceptanceDate']")[1].value = $("input[name='acceptanceDate']")[0].value;
						$("input[name='caseDate']")[1].value = Y+M+D+H+minute;
						$("input[name='casePerson']")[1].value = window.top.getUser().name;
						
					   $('.dhxcombo_select_img').on('click',function(e){
						   var name = e.target.parentNode.parentNode.children[1].getAttribute('name');														
							if(name == 'processing3'){sameSelect(e,'processing','选择处理方式','处理方式',$("input[name='processing3']")[0])}
					   })
				   }
			 })
		 
		 }
		 		 
		 
		 
		 function sendSomebody(e){
			 var mytree
			   var w1 = dhtmlx.showDialog({
		            caption: '选择人员',
		            width: 500,
		            height: 400,
		            saveText: "确定",
		            save: function () {	          	
		            	var names ='';
						if(mytree.getAllChecked().length != 0){
							localStorage.getUserIDs = mytree.getAllChecked();
							for(var i of mytree.getAllChecked().split(',')){
								names = names + mytree.getItemText(i) +';';
							}
							e.target.parentNode.parentNode.children[0].value = names;	
						}else
							e.target.parentNode.parentNode.children[0].value = '';
								
						w1.close();
             		}
		       });
			   var lay = w1.layout.cells("a");
			   var tool = lay.getAttachedToolbar();
			   tool.addSeparator('sp1', 1);
			   tool.addInput("Psnbox",1,"",100);
			   tool.addButton('localization',2, '查询', null, null);
			   $('.dhxtoolbar_input')[0].style.cssText = 'width:100px;font-size:15px;margin-top:0px;';
			   $('.dhxtoolbar_input')[0].setAttribute('placeholder','输入人员名称');
			   $('.dhxtoolbar_input')[0].parentNode.style.border = '0px';
			   $('.dhxtoolbar_input')[0].parentNode.style.backgroundColor = '#ffffff';
			   
			   
			   tool.attachEvent("onClick", function(id){				  
				   if(id == 'localization'){			    
				    	var name = $('.dhxtoolbar_input')[1].value;
				    	mytree.closeAllItems();
			    		 $.ajax({
		   				    	type: 'POST',
		   				    	url: '/person/selperson.action',
		   				    	data:{groupName:window.top.getName(),psnName:name,workState:'在职'},
		   				    	success: function(res){
		   				    		for(var i of res.data){
		   				    			mytree.openItem(i.depID);
		   				    		}
		   				    		
		   				    	}
					   		})			
				    }
			   });
			  
			   var mylayout = new dhtmlXLayoutObject({
				   parent:     lay,    
				   pattern:    "1C",           
				   cells: [{id:"a",text:"人员分类"}]
			   });	
			   
			   mytree = mylayout.cells("a").attachTree();
			   mytree.setImagePath("../DHX/imgs/dhxtree_terrace/");
			   mytree.enableCheckBoxes(false, true);
			   
			   
			 //加载组织树
 			$.ajax({
 			    	type: 'POST',
 			    	url: '${pageContext.request.contextPath}/department/seldepartment.action',
 			    	data:{groupID:window.top.getGroupID()},
 			    	success: function(res){
 			    		if(res.data[0].listData){
 			    			mytree.parse($.parseJSON(res.data[0].showData),"json");
 			    		}else{
 			    			var arr = [[1,0,res.data[0].groupName]];
 			    			mytree.parse(arr,"jsarray");	    			
 			    		}
	   			    	 $.ajax({
	   				    	type: 'POST',
	   				    	url: '/person/selperson.action',
	   				    	data:{groupName:window.top.getName(),workState:'在职'},
	   				    	success: function(res){
	   				    		for(var i of res.data){
	   				    			mytree.insertNewChild(i.depID,i.userId,i.psnName);
	   				    			mytree.showItemCheckbox(i.userId, true);
	   				    		}
	   				    		
	   				    	}
				   		})				   		
 			    	}
 		      });
		 }
		 
		 
		 
		 
		 
		 
		 function changeWidth(layout,layouts){
			 window.onresize = function(){				
				   layouts.cont.style.width = '100%';
				   layouts.cont.children[0].style.width = '100%';
				   layouts.cont.children[0].children[2].style.width = '100%';
				   var a = $('#see')[0].clientWidth||$('#see')[0].offsetWidth;
				   layout.lays[0].cells("a").cell.style.width = a+'px';
				   layout.lays[0].cells("a").cell.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   }
		 }
		
		 
		 function selectFL(){
			 
			 
			 $('.dhxcombo_select_img').on('click',function(e){
					var name = e.target.parentNode.parentNode.children[1].getAttribute('name');						
					if(name == 'cCusName'){CustomerSelect(e,name)}	
					if(name == 'cContact'){cContactSelect(e,name)}
					if(name == 'faultType'){faultTypeSelect(e,name)}
					if(name == 'address'){addressSelect(e,name)}
					if(name == 'processing'){sameSelect(e,name,'选择处理方式','处理方式',$("input[name='processing']")[0])}
					if(name == 'emergency'){sameSelect(e,name,'选择紧急程度','紧急程度',$("input[name='emergency']")[0])}
					if(name == 'inSources'){sameSelect(e,name,'选择信息来源','讯息来源',$("input[name='inSources']")[0])}
			 })
			 
		 }		
		function addressSelect(e,n){
			var cusName = $("input[name='cCusName']")[0].parentNode.children[0].value;
			if(cusName ==''){
				dhtmlx.alert('请选择客户名称');
			}else{
				customerID = localStorage.customerID;
				var grid;
				var w1 = dhtmlx.showDialog({
		            caption: '选择地址',
		            width: 800,
		            height: 500,
		            saveText: "确定",
		            save: function () {
		            	if(grid.getSelectedRowId()){
		            		var selectData = grid.getRowData(grid.getSelectedRowId());
			            	$("input[name='address']")[0].parentNode.children[0].value = selectData.cCusAddress;		            	
							w1.close();
		            	}else
		            		dhtmlx.alert('请选择地址');	
	         		}
		      	});
				var lay = w1.layout.cells("a");
				 $.ajax({
					   type: 'POST',
					   url: '/design/seldesign3.action',
					   data: {DesignName:"设计地址"},
					   success: function(res){
						   var data = JSON.parse(res[0].design);
						   var mylayout = dhtmlx.layout(data,lay,res[0].designName);
						   grid = mylayout.lays[0].cells("a").getAttachedObject();
						   grid.deleteRow(grid.getRowId(0));
						   
						   
						   var toolbar = mylayout.lays[0].cells("a").getAttachedToolbar();
							
							toolbar.attachEvent("onClick", function(id){
							    if(id == 'adds'){
							    	var newId = (new Date()).valueOf();
							    	grid.addRow(newId,"");
							    }
							    if(id == 'dels'){
							    	var rowId = grid.getSelectedRowId();
							    	grid.deleteRow(rowId);
							    }			    
							    if(id == 'saves'){
							    	$.ajax({
					    		    	type: 'POST',
					    		    	url: '/customer/delcustomeraddress.action',
					    		    	data:{groupID:window.top.getGroupID(),cCusCode:customerID}					    		   
						    		})
							    		var count = grid.getRowsNum();			    	
								    	for(var i = 0;i< count;i++){
								    		var rowId = grid.getRowId(i);
									    	var data2 = grid.getRowData(rowId);					    						    		
									    	data2['groupName'] = window.top.getName();
									    	data2['cCusCode'] = customerID;
									    	$.ajax({
							    		    	type: 'POST',
							    		    	url: '/customer/addcustomeraddress.action',
							    		    	data:data2,					    		    	
							    		    	error: function(e) {
							   	            	 var message = $.parseJSON(e.responseText).message.split("### Cause:")[1];
								            	 var cod = message.split('Duplicate entry')[1].split('for key')[0];
								            	 dhtmlx.alert("姓名"+cod +'重复，修改后重新添加');
								             	}
								    		})
									    	
								    	}							    	
							    }
							});
							
							$.ajax({
								   type: 'POST',
								   url: '/customer/selcustomeraddress.action',
								   data: {groupID:window.top.getGroupID(),cCusCode:customerID},
								   success: function(r){
									 var array = new Array();
								     var att = ',cSupUnit,cCusAddress,isDefault';
									 var arr2 = att.split(',');
								     for(const i of r){
								    	 var arr = new Array();
										 for(const j of arr2){
											 if(j&&i[j]!=null){
												 arr.push(i[j]);
											 }else
												 arr.push('');
										 }
									 	array.push(arr);
									 }
									 grid.parse(array,"jsarray");
								   }
								});
						   
					   }
				 })
			}
		}
		
		
		
		function cContactSelect(e,n){
			var cusName = $("input[name='cCusName']")[0].parentNode.children[0].value;
			if(cusName ==''){
				dhtmlx.alert('请选择客户名称');
			}else{
				customerID = localStorage.customerID;
				var grid;
				var w1 = dhtmlx.showDialog({
		            caption: '选择联系人',
		            width: 800,
		            height: 500,
		            saveText: "确定",
		            save: function () {
		            	if(grid.getSelectedRowId()){
		            		var selectData = grid.getRowData(grid.getSelectedRowId());
			            	$("input[name='cContact']")[0].parentNode.children[0].value = selectData.cName;
			            	$("input[name='phone']")[0].value = selectData.cMoblePhone;
			            	if(!selectData.cDep)selectData.cDep='';
			            	$("input[name='dep']")[0].value = selectData.cDep;
			            	if(!selectData.cPost)selectData.cPost = '';
			            	$("input[name='position']")[0].value = selectData.cPost;
							w1.close();
		            	}else
		            		dhtmlx.alert('请选择联系人');
	         		}
		      	});
				var lay = w1.layout.cells("a");
				 $.ajax({
					   type: 'POST',
					   url: '/design/seldesign3.action',
					   data: {DesignName:"设计联系人"},
					   success: function(res){
						   var data = JSON.parse(res[0].design);
						   mylayout = dhtmlx.layout(data,lay,res[0].designName);
						   grid = mylayout.lays[0].cells("a").getAttachedObject();
						   grid.deleteRow(grid.getRowId(0));
						   editPeople(grid);
						   
						   var toolbar = mylayout.lays[0].cells("a").getAttachedToolbar();
							
							toolbar.attachEvent("onClick", function(id){
							    if(id == 'adds'){
							    	var newId = (new Date()).valueOf();
							    	grid.addRow(newId,"");
							    }
							    if(id == 'dels'){
							    	var rowId = grid.getSelectedRowId();
							    	grid.deleteRow(rowId);
							    }			    
							    if(id == 'saves'){
							    	$.ajax({
					    		    	type: 'POST',
					    		    	url: '/customer/delcustomerpeople.action',
					    		    	data:{groupID:window.top.getGroupID(),cCusCode:customerID}					    		   
						    		})
						    		var count = grid.getRowsNum();			    	
							    	for(var i = 0;i< count;i++){
							    		var rowId = grid.getRowId(i);
								    	var data2 = grid.getRowData(rowId);					    						    		
								    	
								    	
								    		if(!data2.cMoblePhone&&!data2.cState){
									    		dhtmlx.alert('手机1和状态不能为空');
									    		data = [];
									    		break;
									    	}else{
									    		data2['cAge'] = $('.objbox')[1].children[0].children[0].children[i+1].children[11].innerHTML;
									    		if(data2.cAge == '&nbsp;'){data2.cAge = '';}
									    		data2['cCusCode'] = customerID;
									    		data2['groupName'] = window.top.getName();
									    		
									    		$.ajax({
								    		    	type: 'POST',
								    		    	url: '/customer/addcustomerpeople.action',
								    		    	data:data2,					    		    	
								    		    	error: function(e) {
								   	            	 var message = $.parseJSON(e.responseText).message.split("### Cause:")[1];
									            	 var cod = message.split('Duplicate entry')[1].split('for key')[0];
									            	 dhtmlx.alert("姓名"+cod +'重复，修改后重新添加');
									             	}
									    		})
									    	}
								    	
							    	}								    	
							    }
							});
						   
						   
						   $.ajax({
							   type: 'POST',
							   url: '/customer/selcustomerpeople.action',
							   data: {groupID:window.top.getGroupID(),cCusCode:customerID},
							   success: function(r){
								 var array = new Array();
							     var att = ',choose,cName,cClub,cDep,cPost,cPhone,cMoblePhone,cQQ,cMoblePhone2,cZR,cBridthday,cAge,cSex,cLike,cMove,cFriend,cEmail,cState';
								 var arr2 = att.split(',');
							     for(var i=0;i<r.length;i++){
							    	 var arr = new Array();
									 for(const j of arr2){
										 if(j!=''&&r[i][j]!=null){
											 arr.push(r[i][j]);
										 }else if(j == 'choose')
											 arr.push('<i class="layui-icon layui-icon-release" onclick="chooseRid()" title="选择"></i>');
										 	else
												arr.push("");
									 }
								 	array.push(arr);
								 }
							    
								 grid.parse(array,"jsarray");
								 
							   }
							});

					   }
				 })
			}
	
		}
		
		
		
		
		function CustomerSelect(e,n){
			localStorage.isSelect = true;
			var myGrid;
			var w1 = dhtmlx.showDialog({
	            caption: '选择客户名',
	            width: 1000,
	            height: 600,
	            saveText: "确定",
	            save: function () {
	            	
	            	var selectData = $.parseJSON(localStorage.customerSelect);
	            	localStorage.removeItem('customerSelect');
	            	$("input[name='cCusName']")[0].parentNode.children[0].value = selectData.cCusName;	            	
	            	$("input[name='states']")[0].value = selectData.cStatus;	            		            	
	            	$("input[name='cusVIP']")[0].value = selectData.cCusVIP;
	            	
	            	 $.ajax({
						   type: 'POST',
						   url: '/customer/selcustomer.action',
						   data: {groupName:window.top.getName(),cCusCode:selectData.cCusCode},
						   success: function(r){
							   localStorage.customerID = r.data[0].id;
							   $.ajax({
								   type: 'POST',
								   url: '/customer/selcustomereffective.action',
								   data: {groupID:window.top.getGroupID(),cCusCode:r.data[0].id},
								   success: function(res){
									   	  $("select[name='product']")[0].innerHTML='';
										  $("input[name='serialNumber']")[0].value = '';
										  $("input[name='endDate']")[0].value = '';
										  $("input[name='phone']")[0].value = '';
										  $("input[name='position']")[0].value = '';
										  $("input[name='dep']")[0].value = '';
										  $("input[name='address']")[0].parentNode.children[0].value = '';
										  $("input[name='cContact']")[0].parentNode.children[0].value = '';
										  
									   if(res.length !=0){
										  
										  for(var i of res){
											  $("select[name='product']")[0].options.add(new Option(i.cProductName,i.cid+','+i.cEndDate));
										  }
										  $("input[name='serialNumber']")[0].value = res[0].cid;
										  $("input[name='endDate']")[0].value = res[0].cEndDate;
									   }  
								   }
								});
							   $.ajax({
								   type: 'POST',
								   url: '/customer/selcustomerpeople.action',
								   data: {groupID:window.top.getGroupID(),cCusCode:r.data[0].id},
								   success: function(res){
									   
									   if(res.length!=0){
										   localStorage.cContact = res[0].id;
										   $("input[name='cContact']")[0].parentNode.children[0].value = res[0].cName;
										   $("input[name='phone']")[0].value = res[0].cMoblePhone;
										   $("input[name='position']")[0].value = res[0].cPost;
										   $("input[name='dep']")[0].value = res[0].cDep;
									   }
								   }
							   })
			            	$.ajax({
								   type: 'POST',
								   url: '/customer/selcustomeraddress.action',
								   data: {groupID:window.top.getGroupID(),cCusCode:r.data[0].id},
								   success: function(res){
									   if(res.length!=0){
										   localStorage.address = res[0].id;
										   $("input[name='address']")[0].parentNode.children[0].value = res[0].cCusAddress;
										   for(var i of res){
											   if(i.isDefault == '1'){
												   localStorage.address = i.id;
												   $("input[name='address']")[0].parentNode.children[0].value = i.cCusAddress;
												   break;
											   }
										   }
										   										  
									   }
								   }
			            	})
						   }
	            	 })
	            	 
	            	
					w1.close();
         		}
	      	});
			 var lay = w1.layout.cells("a");

		       //添加iframe标签		      
		       var div = document.createElement("div");
		       div.setAttribute("id","editCustomer");
		       div.setAttribute("style","width:100%;height:100%; position:absolute;left:0;top:0;");
		       div.innerHTML = '<iframe id="idFrame" name="idFrame" src="/view/tocustomer.action" height = "100%" width = "100%" frameborder="0" scrolling="auto" " ></iframe>';
		       lay.cell.children[2].appendChild(div);
			
		}
				
		function faultTypeSelect(e,n){
			   var mytree;
			   var w1 = dhtmlx.showDialog({
		            caption: '选择故障类型',
		            width: 600,
		            height: 400,
		            saveText: "确定",
		            save: function () {
		            	var treeId = mytree.getSelectedItemId();
						var name = mytree.getItemText(treeId);
						mytree.clearSelection(treeId);
		            	var testJson = mytree.serializeTreeToJSON();
		            			            	
		            	
		            	$.ajax({
		    		    	type: 'POST',
		    		    	url: '/customer/selcustomerclass.action',
		    		    	data:{groupName:window.top.getName(),selectID:n},
		    		    	success: function(res){
		    		    		if(res.data){
		    		    			if(res.data[0].listData != testJson){
			    		    			$.ajax({
			    		    		    	type: 'POST',
			    		    		    	url: '/customer/editcustomerclass.action',
			    		    		    	data:{groupName:window.top.getName(),selectID:n,listData:testJson}		    		    		    	
			    		    	      	});
		    		    			}
		    		    		}else{
		    		    			$.ajax({
		    		    		    	type: 'POST',
		    		    		    	url: '/customer/addcustomerclass.action',
		    		    		    	data:{groupName:window.top.getName(),selectID:n,listData:testJson}
		    		    	      	});
		    		    		}
		    		    	}
		    	      	});
		            	if(name != 0){
							if(treeId != 1){
								e.target.parentNode.parentNode.children[0].value = name.split("]")[1];
								e.target.parentNode.parentNode.children[1].setAttribute('cid',name.split(']')[0].substr(1));
							}
		            	}
						w1.close();
          		}
		      });
			   var lay = w1.layout.cells("a");
			   var tool = lay.getAttachedToolbar();
			   tool.addSeparator('sp1', 1);
			   tool.addButton('add',1, '添加', null, null);
			   tool.addButton('cut',2, '删除', null, null);
			   
			   tool.addSeparator('sp1', 1);
			   tool.addInput("Psnbox",1,"",100);
			   tool.addButton('localization',2, '查询', null, null);
			   $('.dhxtoolbar_input')[0].style.cssText = 'width:100px;font-size:15px;margin-top:0px;';
			   $('.dhxtoolbar_input')[0].setAttribute('placeholder','输入故障名称');
			   $('.dhxtoolbar_input')[0].parentNode.style.border = '0px';
			   $('.dhxtoolbar_input')[0].parentNode.style.backgroundColor = '#ffffff';
			   
			   $.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"分类"},
				   success: function(res){		
					   var data = JSON.parse(res[0].design);
					   var mylayout = dhtmlx.layout(data,lay,res[0].designName);
					   mytree = sameTree(mylayout,n,tool,'故障分类',w1,$("input[name='faultType']")[0]);
				   }
				});
		}
		
		
		function sameSelect(e,n,caption,firstText,changebox){
			var mytree;
			   var w1 = dhtmlx.showDialog({
		            caption: caption,
		            width: 600,
		            height: 400,
		            saveText: "确定",
		            save: function () {
		            	var treeId = mytree.getSelectedItemId();
						var name = mytree.getItemText(treeId);
						mytree.clearSelection(treeId);
		            	var testJson = mytree.serializeTreeToJSON();
		            			            	
		            	
		            	$.ajax({
		    		    	type: 'POST',
		    		    	url: '/customer/selcustomerclass.action',
		    		    	data:{groupName:window.top.getName(),selectID:n},
		    		    	success: function(res){
		    		    		if(res.data){
		    		    			if(res.data[0].listData != testJson){
			    		    			$.ajax({
			    		    		    	type: 'POST',
			    		    		    	url: '/customer/editcustomerclass.action',
			    		    		    	data:{groupName:window.top.getName(),selectID:n,listData:testJson}		    		    		    	
			    		    	      	});
		    		    			}
		    		    		}else{
		    		    			$.ajax({
		    		    		    	type: 'POST',
		    		    		    	url: '/customer/addcustomerclass.action',
		    		    		    	data:{groupName:window.top.getName(),selectID:n,listData:testJson}
		    		    	      	});
		    		    		}
		    		    	}
		    	      	});
		            	if(name != 0){
							if(treeId != 1){
								e.target.parentNode.parentNode.children[0].value = name.split("]")[1];
								e.target.parentNode.parentNode.children[1].setAttribute('cid',name.split(']')[0].substr(1));
							}
		            	}
						w1.close();
  				}
		      });
			   var lay = w1.layout.cells("a");
			   var tool = lay.getAttachedToolbar();
			   tool.addSeparator('sp1', 1);
			   tool.addButton('add',1, '添加', null, null);
			   tool.addButton('cut',2, '删除', null, null);
			   

			   $.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"分类"},
				   success: function(res){		
					   var data = JSON.parse(res[0].design);
					   mylayout = dhtmlx.layout(data,lay,res[0].designName);
					   mytree = sameTree(mylayout,n,tool,firstText,w1,changebox);
				   }
				});
		}
		
		
		
		function sameTree(mylayout,n,tool,title,w1,show){
			 var mytree = mylayout.lays[0].cells("a").attachTree();
			 mytree.setImagePath("../DHX/imgs/dhxtree_terrace/");
			
   	 
   		//点击树事件
			mytree.attachEvent("onClick", function(id){
				if(id == "1"){
					$("input[name='cCCid']")[0].value = null;
    				$("input[name='cCCidName']")[0].value = null;
				}else{
				var arr = mytree.getItemText(id).split("]");
				arr[0] = arr[0].substr(1);
				$("input[name='cCCid']")[0].value = arr[0];
				$("input[name='cCCidName']")[0].value = arr[1];
				}
			})
			
			$.ajax({
		    	type: 'POST',
		    	url: '/customer/selcustomerclass.action',
		    	data:{groupName:window.top.getName(),selectID:n},
		    	success: function(res){
		    		if(res.data){
		    			mytree.parse($.parseJSON(res.data[0].listData),"json");
		    		}else{
		    			mytree.insertNewChild(0,1,title);
		    		}
		    	}
	      	});
			
			
			mytree.attachEvent("onDblClick", function(id){
				show.parentNode.children[0].value = mytree.getItemText(id).split(']')[1];
				w1.close();
			    return null;
			});
			
		   tool.attachEvent("onClick", function(id){
			   if(id == 'add'){						    				    
						var cid = $("input[name='cCCid']")[0].value;
						var name = '['+ cid +']'+$("input[name='cCCidName']")[0].value;
						if(mytree.findItemIdByLabel(name,0,null)){
							dhtmlx.alert('分类已添加');
						}
						else{							
							mytree.insertNewChild(1,window.top.getGuid(),name);
						}
					
			   }
			   if(id == 'cut'){
				   var treeId = mytree.getSelectedItemId();
					if(treeId ==''){								
						dhtmlx.alert('请选择'+title);
					}else if(treeId == 1){
						dhtmlx.alert('不可删除根目录');
							}else{
				        mytree.deleteItem(treeId,true);	        	
				    }
			   }
			   if(id == 'localization'){
				   	var name = $('.dhxtoolbar_input')[0].value;
				   	if(name!=''){				   		
				   		$.ajax({
					    	type: 'POST',
					    	url: '/customer/selcustomerclass.action',
					    	data:{groupName:window.top.getName(),selectID:n},
					    	success: function(res){
					    		if(res.data){
					    			mytree.deleteItem(1);
					    			mytree.parse($.parseJSON(res.data[0].listData),"json");
					    			var arr = new Array();
							   		for(var i of mytree.getAllSubItems(1).split(',')){	   		
								   		if(mytree.getItemText(i).includes(name)){
								   			arr.push(mytree.getItemText(i));
								   		}
								   	}
							   		mytree.deleteItem(1);
							   		mytree.insertNewChild(0,1,'故障分类');
							   		for(var j of arr)
							   			mytree.insertNewChild(1,window.top.getGuid(),j);
					    		}
					    	}
				      	});
				   		
				   		
				   	}else{				   		
				   		$.ajax({
					    	type: 'POST',
					    	url: '/customer/selcustomerclass.action',
					    	data:{groupName:window.top.getName(),selectID:n},
					    	success: function(res){
					    		if(res.data){
					    			mytree.deleteItem(1);
					    			mytree.parse($.parseJSON(res.data[0].listData),"json");
					    		}else{
					    			mytree.insertNewChild(0,1,title);
					    		}
					    	}
				      	});
				   	}	
			    } 
		   });
 
		   return mytree;
		 }
		
		function startLogin(){

			if(localStorage.chooseRequest){
				$.ajax({
			    	type: 'POST',
			    	url: '/ticket/selticketend.action',
			    	data:{id:localStorage.chooseRequest},
			    	success: function(res){
			    		if(res){
			    			 localStorage.removeItem("chooseRequest");
			    			sameStart(res);
			    		}
			    		
			    	}
		      	});
			}else{
				$.ajax({
			    	type: 'POST',
			    	url: '/ticket/selticketend.action',
			    	data:{groupID:window.top.getGroupID()},
			    	success: function(res){
			    		if(res){
			    			sameStart(res);
			    		}
			    		
			    	}
		      	});
			}
			
		}
		
		
		
		function showToolbar(){
			if($(".status")[1].style.color == "red"){				
				myToolbar.hideItem("returnSend");
				myToolbar.showItem("sendSomebody");	
				if($("input[name='registerPeople']")[0].value == window.top.getUser().name){
					myToolbar.showItem("accept");
				}
				showToolbar11();
			}
			if($(".status")[3].style.color == "red"){
				myToolbar.hideItem("accept");
				myToolbar.hideItem("sendSomebody");
				myToolbar.hideItem("returnSend");
				
				if($("input[name='assignee']")[0].value == window.top.getUser().name){
					myToolbar.hideItem("accept");
					myToolbar.showItem("returnSend");
					myToolbar.showItem("changeSomeBody");
					myToolbar.showItem("finish");
				}
			}
			if($(".status")[4].style.color == "red"){
				myToolbar.hideItem("accept");
				myToolbar.showItem("returnSend");
				showToolbar11();
			}
		    			
		} 
		
		
		
		function showToolbar11(){
			$.ajax({
				   type: 'POST',
				   url: '/role/seluserrole.action',
				   data: {userId:window.top.getID(),groupID:window.top.getGroupID()},
				   success: function(res){
					    
					   if(res.data){					   
						   for(var i of res.data){
							   if(i.roleID == 'hfy'){								   
									myToolbar.showItem("returnSend");
									//myToolbar.showItem("finish");
							   }
							   if(i.roleID == 'pfy'){
								    myToolbar.showItem("sendSomebody");	
							   }
						   } 
					   }
				   }
			   })
		    
			
		} 
		
		
		function sameStart(res){
			myToolbar.hideItem("save");
	        myToolbar.hideItem("save2");
	        //myToolbar.hideItem("add");
		    myToolbar.hideItem("sendSomebody");
			myToolbar.hideItem("returnSend");
			myToolbar.hideItem("changeSomeBody");
			myToolbar.hideItem("finish");
			localStorage.ptmID = window.top.getGuid();
			if($('.layui-upload').length<1){
				var parBox = layout.lays[0].cells("a").cell.children[1].children[0].children[0];
				var div = document.createElement("div");
				div.setAttribute("class","layui-upload");
				div.setAttribute("style","position: relative;left: 30px;top: 500px;width:1000px;height:300px");
				div.innerHTML = '<button type="button" class="layui-btn layui-btn-normal" id="testList">选择文件</button>'
				+'<button type="button" class="layui-btn" id="testListAction" style="margin-left:30px;">开始上传</button><div class="layui-upload-list">'
				+'<div class="layui-upload-list"><table class="layui-table"><thead><tr><th>文件名</th><th>大小</th><th>状态</th><th>操作</th></tr></thead>'
				+'<tbody id="demoList"></tbody></table></div>';
				parBox.append(div);
			}
			
			//$("textarea[name='description']")[0].setAttribute("id","demo");
			//$("textarea[name='description']")[0].removeAttribute("class");
			//$("textarea[name='description']")[0].parentNode.style.width="1000px";
			
			layui.use(['upload','layedit','element'], function(){
				  var upload = layui.upload;
			//	  var layedit = layui.layedit;
				  var element = layui.element;
				 
				 
				  
			//	  layedit.set({
			//		  uploadImage: {
			//		    url: '/upload/uploadimg.action' 
			//		    ,type: 'post' 
			//		  }
			//	  });
				  
			//	  var index = layedit.build('demo',{height:200,hideTool:['link','unlink']}); 
				  
				
				  //console.log($("textarea[name='description']")[0].value = layedit.getText(index));
			//	  $('.layui-layedit-iframe')[0].children[0].contentWindow.document.addEventListener("paste", function (e){
			//		 var length = e.path.length;
					  //dhtmlx.alert(length);
					// var text = e.path[e.path.length-4].innerHTML;console.log(text)
					 // dhtmlx.alert(text);
			//		});
				  
				  
				//多文件列表示例
				  var demoListView = $('#demoList')
				  ,uploadListIns = upload.render({
				    elem: '#testList'
				    ,url: '/upload/uploadimg.action' //改成您自己的上传接口
				    ,accept: 'file'
				    ,size: 10240
				    ,multiple: true
				    ,auto: false
				    ,bindAction: '#testListAction'	
			    	, before: function (obj){
		                //自定页
		                layer.open({
		                    type: 1,
		                    title: "上传进度", //不显示标题
		                    //closeBtn: 0, //不显示关闭按钮
		                    skin: 'layui-layer-demo', //样式类名
		                    area: ['420px', 'auto'], //宽高
		                    content: '<div style="margin: 10px 20px;"><div class="layui-progress layui-progress-big" lay-showpercent="true" lay-filter="uploadfile"><div class="layui-progress-bar" lay-percent="" id="uploadfile"></div></div><p><span id="uploadfilemsg">正在上传</span></p></div>',
		                    success: function (layero, index)
		                    {
		                        layer.setTop(layero); //重点2
		                    }
		                });
		                element.render();
		            }
			    	,progress: function(n, elem){
					    var percent = n + '%' //获取进度百分比
					    $("#uploadfile").attr("lay-percent", percent);
		                element.render();
					    //element.progress('demo', percent); //可配合 layui 进度条元素使用
					    
					  }
				    ,choose: function(obj){   console.log(obj)
				      var files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列
				      //读取本地文件
				      obj.preview(function(index, file, result){
				        var tr = $(['<tr id="upload-'+ index +'">'
				          ,'<td>'+ file.name +'</td>'
				          ,'<td>'+ (file.size/1024).toFixed(1) +'kb</td>'
				          ,'<td>等待上传</td>'
				          ,'<td>'
				            ,'<button class="layui-btn layui-btn-xs demo-reload layui-hide">重传</button>'
				            ,'<button class="layui-btn layui-btn-xs layui-btn-danger demo-delete">删除</button>'
				          ,'</td>'
				        ,'</tr>'].join(''));
				        
				        //单个重传
				        tr.find('.demo-reload').on('click', function(){
				          obj.upload(index, file);
				        });
				        
				        //删除
				        tr.find('.demo-delete').on('click', function(){
				          delete files[index]; //删除对应的文件
				          tr.remove();
				          uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
				        });
				        
				        demoListView.append(tr);
				      });
				    }
				  
				    ,done: function(res, index, upload){console.log(res)
				      if(res.Data){ //上传成功
				        var tr = demoListView.find('tr#upload-'+ index),tds = tr.children();
			      
				        tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
				        tds.eq(3).html(''); //清空操作
				        
			    	    $.ajax({type: 'POST',
			    		     url: '/upload/addfile.action',
						     data: {ticketID:localStorage.ptmID,attName:res.Data,fileSize:tds.eq(1)[0].innerHTML,fileName:tds.eq(0)[0].innerHTML}
			    	    })
				        //layer.closeAll('loading');
				        return delete this.files[index]; //删除文件队列已经上传成功的文件
				      }
				      this.error(index, upload);
				    }
				    ,error: function(index, upload){
				      var tr = demoListView.find('tr#upload-'+ index)
				      ,tds = tr.children();
				      tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
				      tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
				      //layer.closeAll('loading');
				    }
				  });

				
			})


			if(res == null){		
				myToolbar.showItem("save");
		        myToolbar.showItem("save2");
		        myToolbar.hideItem("add");
		        myToolbar.hideItem("save3");
		        
				$('#testList')[0].style.display = '';
				$('#testListAction')[0].style.display = '';
				$(".status").each(function (e){
					if(e == 0){
						$(".status")[e].style.color = "red";
					}else
						$(".status")[e].style.color = "black";
				})
				showToolbar();
				stateHeight(1);
				$('#demoList')[0].innerHTML = '';
				
				
				$("input[name='cid']")[0].value = '';		    		
	    		$("input[name='appointmentDate']")[0].value = '';
	    		$("input[name='cusVIP']")[0].value = '';
	    		$("input[name='serialNumber']")[0].value = '';
	    		$("input[name='phone']")[0].value = '';
	    		$("input[name='states']")[0].value = '';
	    		$("input[name='dep']")[0].value = '';
	    		$("input[name='position']")[0].value = '';
	    		$("input[name='endDate']")[0].value = '';
	    		$("input[name='failureDate']")[0].value = '';
	    		$("input[name='registerPeople']")[0].value = '';
	    		
	    		$("textarea[name='description']")[0].value = '';	    	
	    		//window.frames['LAY_layedit_2'].document.body.innerHTML ='';
	    		
	    		
	    		$("select[name='product']")[0].innerHTML = '';
	    		$("input[name='cCusName']")[0].parentNode.children[0].value = '';
	    		$("input[name='processing']")[0].parentNode.children[0].value = '';
	    		$("input[name='faultType']")[0].parentNode.children[0].value = '';
	    		$("input[name='cContact']")[0].parentNode.children[0].value = '';		    				    		
	    		$("input[name='address']")[0].parentNode.children[0].value = '';
	    		$("input[name='emergency']")[0].parentNode.children[0].value = '';
	    		$("input[name='inSources']")[0].parentNode.children[0].value = '';
	    		$("select[name='product']")[0].value = '';
	    		
	    		$("input[name='legalPerson']")[0].value = '';
	    		$("input[name='sendPeople']")[0].value = '';
	    		$("input[name='sendDate']")[0].value = '';
	    		$("input[name='claimDate']")[0].value = '';
	    		$("input[name='wages']")[0].value = '';
	    		$("input[name='processing2']")[0].parentNode.children[0].value = '';  
	    		$("input[name='finishDate']")[0].value = '';
	    		$("textarea[name='otherMes']")[0].value = '';
	
	    		$("input[name='assignee']")[0].value = '';
	    		$("input[name='acceptanceDate']")[0].value = '';
	    		$("input[name='processing3']")[0].parentNode.children[0].value = '';  
	    		$("textarea[name='solve']")[0].value = '';
	    		$("textarea[name='errorReason']")[0].value = '';
	    		$("input[name='casePerson']")[0].value = '';
	    		$("input[name='caseDate']")[0].value = '';
	    		$("input[name='integral']")[0].value = '';
	    		
	    		$("input[name='accessDate']")[0].value = '';
	    		$("input[name='overview']")[0].parentNode.children[0].value = '';
	    		$("textarea[name='feedback']")[0].value = '';
	    		
	    		
			}else{
				
				$('#testList')[0].style.display = 'none';
				$('#testListAction')[0].style.display = 'none';
				localStorage.ticket = JSON.stringify(res.data[0]);
				$(".status").each(function (e){
					if(e == res.data[0].progress){
						$(".status")[e].style.color = "red";
					}else
						$(".status")[e].style.color = "black";
				})
				
				stateHeight(res.data[0].progress);
				localStorage.ticketID = res.data[0].id;
				$("input[name='cid']")[0].value = res.data[0].cid;		    		
	    		$("input[name='appointmentDate']")[0].value = res.data[0].appointmentDate;
	    		$("input[name='cusVIP']")[0].value = res.data[0].cusVIP;
	    		$("input[name='serialNumber']")[0].value = res.data[0].serialNumber;
	    		$("input[name='phone']")[0].value = res.data[0].phone;
	    		$("input[name='states']")[0].value = res.data[0].states;
	    		$("input[name='dep']")[0].value = res.data[0].dep;
	    		$("input[name='position']")[0].value = res.data[0].position;
	    		$("input[name='endDate']")[0].value = res.data[0].endDate;
	    		$("input[name='failureDate']")[0].value = res.data[0].failureDate;
	    		$("input[name='registerPeople']")[0].value = res.data[0].registerPeople;
	    		
	    		$("textarea[name='description']")[0].value = res.data[0].description;
	    		//window.frames['LAY_layedit_2'].document.body.innerHTML = res.data[0].description;
	    			
	    		$("select[name='product']")[0].options.add(new Option(res.data[0].product));
	    		$("input[name='cCusName']")[0].parentNode.children[0].value = res.data[0].cCusName;
	    		$("input[name='processing']")[0].parentNode.children[0].value = res.data[0].processing;
	    		$("input[name='faultType']")[0].parentNode.children[0].value = res.data[0].faultType;
	    		$("input[name='cContact']")[0].parentNode.children[0].value = res.data[0].cContact;		    				    		
	    		$("input[name='address']")[0].parentNode.children[0].value = res.data[0].address;
	    		$("input[name='emergency']")[0].parentNode.children[0].value = res.data[0].emergency;
	    		$("input[name='inSources']")[0].parentNode.children[0].value = res.data[0].inSources;
	    		
	    		$("select[name='product']")[0].options.length = 0;
	    		$("select[name='product']")[0].options.add(new Option(res.data[0].product,res.data[0].product));
	    		
	    		$("input[name='legalPerson']")[0].value = res.data[0].legalPersonName;
	    		$("input[name='sendPeople']")[0].value = res.data[0].sendPerson;
	    		$("input[name='sendDate']")[0].value = res.data[0].sendDate;
	    		$("input[name='claimDate']")[0].value = res.data[0].claimDate;
	    		$("input[name='wages']")[0].value = res.data[0].wages;
	    		$("input[name='processing2']")[0].parentNode.children[0].value = res.data[0].processing2;  
	    		$("input[name='finishDate']")[0].value = res.data[0].finishDate;
	    		$("textarea[name='otherMes']")[0].value = res.data[0].otherMes;
	
	    		$("input[name='assignee']")[0].value = res.data[0].assigneeName;
	    		$("input[name='acceptanceDate']")[0].value = res.data[0].acceptanceDate;
	    		$("input[name='processing3']")[0].parentNode.children[0].value = res.data[0].processing3;  
	    		$("textarea[name='solve']")[0].value = res.data[0].solve;
	    		$("textarea[name='errorReason']")[0].value = res.data[0].errorReason;
	    		$("input[name='casePerson']")[0].value = res.data[0].casePersonName;
	    		$("input[name='caseDate']")[0].value = res.data[0].caseDate;
	    		$("input[name='integral']")[0].value = res.data[0].integral;
	    		
	    		$("input[name='accessPeople']")[0].value = res.data[0].accessPeopleName;
	    		$("input[name='accessDate']")[0].value = res.data[0].accessDate;
	    		$("input[name='overview']")[0].parentNode.children[0].value = res.data[0].overview;
	    		$("textarea[name='feedback']")[0].value = res.data[0].feedback;
	    		
	    		$('#demoList')[0].innerHTML='';
	    		showToolbar();
	    		 $.ajax({type: 'POST',
	    		     url: '/upload/selfile.action',
				     data: {ticketID:localStorage.ticketID},
				     success: function(r){
				    	 if(r.length>0){
				    		 var demoListView = $('#demoList')[0];
						    	for(var i of r){
						    		var html = '<td>'+ i.fileName +'</td><td>'+i.fileSize+'</td><td>已上传</td><td>'
							            +'<button class="layui-btn layui-btn-xs demo-upload" onclick="uploadFile(this)">下载</button>'
										+'<button class="layui-btn layui-btn-xs layui-btn-danger demo-delete" onclick="deleteFile(this)">删除</button></td>';
							        var tr = document.createElement("tr");
						    		tr.setAttribute("id",i.id);	
						    		tr.setAttribute("attName",i.attName);	
						    		tr.innerHTML = html;
						    		demoListView.append(tr);
						    	}
				    	 }
				    	
				     }
	    	    })
	    		
			}
			
		}
		
		
		function stateHeight(e){
			if(e == 1){
				layout.lays[0].cells("a").cell.parentNode.children[1].style.display='none';
				layout.lays[0].cells("a").cell.parentNode.children[2].style.display='none';
				$("#see")[0].style.height = '850px';
				$("#seeBox")[0].style.height = '900px';
				$("#see")[0].children[0].style.height = '800px';
				$("#see")[0].children[0].children[0].style.height = '800px';
			}
			if(e==2){
				layout.lays[0].cells("a").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("a").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("b").cell.parentNode.children[1].style.display='none';
				layout.lays[0].cells("b").cell.parentNode.children[2].style.display='none';
				$("#seeBox")[0].style.height = '1200px';
				$("#see")[0].style.height = '1150px';
				$("#see")[0].children[0].style.height = '1100px';
				$("#see")[0].children[0].children[0].style.height = '1100px';
			}
			if(e == 3){
				layout.lays[0].cells("a").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("a").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("b").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("b").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("c").cell.parentNode.children[1].style.display='none';
				layout.lays[0].cells("c").cell.parentNode.children[2].style.display='none';
				$("#seeBox")[0].style.height = '1580px';
				$("#see")[0].style.height = '1550px';
				$("#see")[0].children[0].style.height = '1500px';
				$("#see")[0].children[0].children[0].style.height = '1500px';
			}
			if(e == 4){
				layout.lays[0].cells("a").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("a").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("b").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("b").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("c").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("c").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("d").cell.parentNode.children[1].style.display='none';
				layout.lays[0].cells("d").cell.parentNode.children[2].style.display='none';
				$("#seeBox")[0].style.height = '2000px';
				$("#see")[0].style.height = '1950px';
				$("#see")[0].children[0].style.height = '1900px';
				$("#see")[0].children[0].children[0].style.height = '1900px';
			}if(e == 5){
				layout.lays[0].cells("a").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("a").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("b").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("b").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("c").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("c").cell.parentNode.children[2].style.display='';
				layout.lays[0].cells("d").cell.parentNode.children[1].style.display='';
				layout.lays[0].cells("d").cell.parentNode.children[2].style.display='';
				
				$("#seeBox")[0].style.height = '2200px';
				$("#see")[0].style.height = '2150px';
				$("#see")[0].children[0].style.height = '2100px';
				$("#see")[0].children[0].children[0].style.height = '2100px';
			}
			  
			   
		}
		
		
		function addNewTage(){
			sameStart();
			$("select[name='product']").change(function(){
				var message = $("select[name='product']")[0].options[$("select[name='product']")[0].selectedIndex].value;
	   			$("input[name='serialNumber']")[0].value = message.split(',')[0];
	   			$("input[name='endDate']")[0].value = message.split(',')[1];
			});
			$("input[name='registerPeople']")[0].value = window.top.getUser().name;
			
			$("input[name='phone']").blur(function(){
				if($("input[name='phone']")[0].value!= ''){
					if(!isPhoneNumber($("input[name='phone']")[0].value)){
						$("input[name='phone']")[0].value = '';
	    				dhtmlx.alert('输入正确的手机号');   	
	    			}
				}
				
			})
			
			var date = new Date();
			var Y = date.getFullYear() + '/';
			var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '/';
			var D = date.getDate();
			if(D.length == 1) D = "0"+ D;
			$("input[name='failureDate']")[0].value = Y+M+D;
			$.ajax({
				  type: 'POST',
				   url: '/ticket/selticketnum.action',
				   data: {groupID:window.top.getGroupID(),cid:date.getFullYear()},
				   success: function(r){
 						if(r){
						   var ls = '';
						   var num = r +1 +'';
						   for(var i=0;i<6-num.length;i++){
							   ls += '0';
						   }
						   ls+=num;
						   ls = date.getFullYear() + ls;
						   $("input[name='cid']")[0].value = ls;
 						}else
 							$("input[name='cid']")[0].value = date.getFullYear() +'000001';
 						
 						jtlong($($("input[name='cCusName']")[0].parentNode.children[0]));
				   }
			});					
		}
		
		
		function jtlong(a){
			a.on({
			    keyup : function(e){        
			        var flag = e.target.isNeedPrevent;
			        if(flag)  return;     
			        response() ;
			        e.target.keyEvent = false ;
			        
			    },
			    keydown : function(e){
			        e.target.keyEvent = true ; 
			    },
			    input : function(e){
			        if(!e.target.keyEvent){
			            response()
			        }        
			    },
			    compositionstart : function(e){
			        e.target.isNeedPrevent = true ;
			    },
			    compositionend : function(e){
			        e.target.isNeedPrevent = false;
			        
			    }
			})
			function response(){
				var b = $("input[name='cCusName']")[0].parentNode.children[0];
				$.ajax({
    				  type: 'POST',
    				   url: '/customer/selcustomer.action',
    				   data: {groupName:window.top.getName(),cCusName:b.value},
    				   success: function(r){
    					   $("#customerBox")[0].innerHTML = '';
	      					var reactObj = b.getBoundingClientRect();
	      					$("#customerBox")[0].style.cssText = "background:#ffffff;border:1px solid;font-size:13px;line-height:20px;position: absolute;left:"+(reactObj.left-5)+"px;top:"+(reactObj.top+24)+"px";
	      					if(r.data){
	      						var length=0;
	      						if(r.data.length>10){
	      							length = 10;
	      						}else{
	      							length = r.data.length;
	      						}
	      						for(var i =0;i<length;i++){
	      						   var div = document.createElement("div");
	      					       div.setAttribute("id","cusName"+i);	      					      
	      					  	   div.setAttribute("cStatus",r.data[i].cStatus);	      					 	   	      					 	 
	      					       div.setAttribute("cCusVIP",r.data[i].cCusVIP);
	      					       div.setAttribute("cCusCode",r.data[i].id);
	      					       div.setAttribute("style","width:230px;height:20px;text-align:left;margin-left:10px");
	      					       div.onclick = function (e){
	      					    	    customerID = e.target.getAttribute("cCusCode");
		      					    	$("input[name='cCusName']")[0].parentNode.children[0].value = e.target.innerHTML;      			            	
		      			            	$("input[name='states']")[0].value = e.target.getAttribute("cStatus");		      			            	
		      			            	$("input[name='cusVIP']")[0].value = e.target.getAttribute("cCusVIP");
		      			            	
		      			            	 $.ajax({
											   type: 'POST',
											   url: '/customer/selcustomereffective.action',
											   data: {groupID:window.top.getGroupID(),cCusCode:e.target.getAttribute("cCusCode")},
											   success: function(res){
												   $("select[name='product']")[0].innerHTML='';
												   $("input[name='serialNumber']")[0].value = '';
												   $("input[name='endDate']")[0].value = '';
												   $("input[name='phone']")[0].value = '';
												  $("input[name='position']")[0].value = '';
												  $("input[name='dep']")[0].value = '';
												  $("input[name='address']")[0].parentNode.children[0].value = '';
												  $("input[name='cContact']")[0].parentNode.children[0].value = '';
												   if(res.length !=0){
													  for(var i of res){
														  $("select[name='product']")[0].options.add(new Option(i.cProductName,i.cid+','+i.cEndDate));
													  }
													  $("input[name='serialNumber']")[0].value = res[0].cid;
													  $("input[name='endDate']")[0].value = res[0].cEndDate;
													  
												   } 
												  
											   }
											});
		      			            	 
		      			            	 $.ajax({
											   type: 'POST',
											   url: '/customer/selcustomerpeople.action',
											   data: {groupID:window.top.getGroupID(),cCusCode:e.target.getAttribute("cCusCode")},
											   success: function(res){
												   if(res.length!=0){
													   $("input[name='cContact']")[0].parentNode.children[0].value = res[0].cName;
													   $("input[name='phone']")[0].value = res[0].cMoblePhone;
													   $("input[name='position']")[0].value = res[0].cPost;
													   $("input[name='dep']")[0].value = res[0].cDep;
												   }
											   }
										   })
						            	$.ajax({
											   type: 'POST',
											   url: '/customer/selcustomeraddress.action',
											   data: {groupID:window.top.getGroupID(),cCusCode:e.target.getAttribute("cCusCode")},
											   success: function(res){
												   if(res.length!=0){
													   $("input[name='address']")[0].parentNode.children[0].value = res[0].cCusAddress;										  
												   }
											   }
						            	})
	      					       }
	      					      
	      					       div.innerHTML = r.data[i].cCusName;
	      					       $("#customerBox")[0].appendChild(div);
	      						}
	      					}
    				   }
        		})
			}
			
 			a.blur(function(){
 				setTimeout(function(){
 					$("#customerBox")[0].style.cssText = "display:none";
 	 				$("#customerBox")[0].innerHTML = '';
 				},400)
 				
			})
		}
 function editPeople(grid){
			 grid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue){
				 if(stage == 1){
					if(cInd == 2){
						var a = $('.dhx_combo_select');
						a[0].style.height = '80px';
						a[0].children[0].remove();
						a[0].options.add(new Option('执行层','执行层'));
						a[0].options.add(new Option('中间层','中间层'));	
						a[0].options.add(new Option('决策层','决策层'));	
						a[0].options.add(new Option('第三方机构','第三方机构'));	
					}
					if(cInd == 17){
						var a = $('.dhx_combo_select');
						a[0].style.height = '50px';
						a[0].children[0].remove();
						a[0].options.add(new Option('在职','在职'));
						a[0].options.add(new Option('离职','离职'));		
					}
					if(cInd == 12){
						var a = $('.dhx_combo_select');
						a[0].style.height = '50px';
						a[0].children[0].remove();
						a[0].options.add(new Option('男','男'));
						a[0].options.add(new Option('女','女'));						 
					}
					 
				 }
				 if(stage == 2){
	    		    	if(nValue != oValue){   	    		
	    		    		if(cInd == 6){
	    		    			if(!isPhoneNumber(nValue)){
	    		    				dhtmlx.alert('输入正确的手机号');
	    					    	return false;
	    		    			}
	    		    		}
	    		    		if(cInd == 10){
	    		    				var d = new Date();
	    		    	            var now = d.getFullYear() + '/' + (d.getMonth() + 1) +'/' + d.getDate();
	    		    	            
	    		    				var days = getDays(now,nValue);
	    		    				if(days >= 0){
	    		    					grid.cellById(rId,cInd+1).cell.innerHTML = getAge(nValue);
	    		    				}else{
	    		    					dhtmlx.alert('选择的生日不能大于今日日期');
		    					    	return false;
	    		    				}
	    		    			}
	    		    		if(cInd == 16){
	    		    			if(!checkEmail(nValue)){
	    		    				dhtmlx.alert('输入正确的邮箱');
	    					    	return false;
	    		    			}
	    		    		}
	        		    		return true;
	    		    	}else return false;
	    		    }else return true;
			 });	
		 }
 function getDays(date1 , date2){
	    
     var date1Str = date1.split("/");        
     var date2Str = date2.split("/");
     var text1 = date1Str[0] + '-' +date1Str[1] +'-' +date1Str[2];
     var text2 = date2Str[0] + '-' +date2Str[1] +'-' +date2Str[2];
     var flag = compareDate(text1,text2);
     if(flag){
     	var date1Obj = new Date(date1Str[0],(date1Str[1]-1),date1Str[2]);
         var date2Obj = new Date(date2Str[0],(date2Str[1]-1),date2Str[2]);
         var t1 = date1Obj.getTime();
         var t2 = date2Obj.getTime();
         var dateTime = 1000*60*60*24; //每一天的毫秒数
       
         var minusDays = Math.floor(((t2-t1)/dateTime));//计算出两个日期的天数差
         var days = Math.abs(minusDays);//取绝对值
         return days;
     }else
     	return -1; 
 }
 function compareDate(dateTime1,dateTime2){
     var formatDate1 = new Date(dateTime1);
     var formatDate2 = new Date(dateTime2);
     if(formatDate1 >= formatDate2)
         return true;
     else
         return false;
 }
 function getAge(strAge) {
     var birArr = strAge.split("/");
     var birYear = birArr[0];
     var birMonth = birArr[1];
     var birDay = birArr[2];

     d = new Date();
     var nowYear = d.getFullYear();
     var nowMonth = d.getMonth() + 1; 
     var nowDay = d.getDate();
     var returnAge;

     if (birArr == null) {
         return false
     };
     var d = new Date(birYear, birMonth - 1, birDay);
	     if (d.getFullYear() == birYear && (d.getMonth() + 1) == birMonth && d.getDate() == birDay) {
	         if (nowYear == birYear) {
	             returnAge = 0;  
	         } else {
	             var ageDiff = nowYear - birYear; 
	             if (ageDiff > 0) {
	                 if (nowMonth == birMonth) {
	                     var dayDiff = nowDay - birDay; 
	                     if (dayDiff < 0) {
	                         returnAge = ageDiff - 1;
	                     } else {
	                         returnAge = ageDiff;
	                     }
	                 } else {
	                     var monthDiff = nowMonth - birMonth; 
	                     if (monthDiff < 0) {
	                         returnAge = ageDiff - 1;
	                     } else {
	                         returnAge = ageDiff;
	                     }
	                 }
	             } else {
	                 return  -1; 
	             }
	         }
	         return returnAge;
	     } 
	 }

	function isPhoneNumber(tel) {
	  var reg =/^0?1[3|4|5|6|7|8][0-9]\d{8}$/;
	  return reg.test(tel);
	}
	function checkEmail(email){
		　　var myReg=/^[a-zA-Z0-9_-]+@([a-zA-Z0-9]+\.)+(com|cn|net|org)$/;
		　　if(myReg.test(email)){
		　　　　return true;
		　　}else{
		　　　　return false;
			}
	}
		
    })
		
	function deleteFile(e){
		dhtmlx.confirm({
		    title: "删除附件",
		    type:"提示",
		    text: "是否确定删除?",
		    cancel: '否',
		    ok: '是',
		    callback: function(h) {
		    	if(h){		    
		    		var div = e.parentNode.parentNode;
		    		 $.ajax({type: 'POST',
		    		     url: '/upload/deletefile.action',
					     data: {id:div.getAttribute("id")},
					     success:function(){
					    	 div.parentNode.removeChild(div);
					     }
		    	    })
		    	}
		    }
		})
		
	}
  	
  	function uploadFile(e){
  		var fileName = e.parentNode.parentNode.children[0].innerHTML;
  		var attName = e.parentNode.parentNode.getAttribute("attName");  		
  		window.open("${pageContext.request.contextPath }/imgs/"+attName+"?fileName="+fileName);
  		//window.top.document.getElementById("upload").click();
  		
 // 	        var url = "${pageContext.request.contextPath }/imgs/"+attName+"?fileName="+fileName;
 // 	        var a = document.createElement('a');
//  	        a.href = url;
//  	        a.target="_blank";
//  	        a.download = ''
//  	        a.click();
  	}

    
</script> 
<body>
<div id = "toolbar" style="height:50px;width:100%;background: #F8F8F8;"></div>
<div id="postBar" style="height:90%;margin-top:1%;width:99%;overflow:auto;">
	<div id ="seeBox" >
		<div>		
			<div style="height:40px;line-height:50px">服务工单 </div>
			<div style="height:20px;font-size:12px;text-align:right;margin-right:40px;">
				<span>状态：</span>
				<span class="status">请求</span>
				<span >-</span>
				<span class="status">待派发</span>
				<span>-</span>
				<span class="status">待受理</span>
				<span>-</span>
				<span class="status">待结案</span>
				<span>-</span>
				<span class="status">待回访</span>
				<span>-</span>
				<span class="status">关闭</span>
			</div>
		</div>		
		<div id = "see" style="width:94%;margin-left:3%;margin-right:4%;height:2100px;text-align:left;"></div>
		<div id = "customerBox"></div>
	</div>
</div>

</body>
</html>