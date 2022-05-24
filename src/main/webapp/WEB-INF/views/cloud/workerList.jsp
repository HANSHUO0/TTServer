<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>工单列表</title>
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
		input[type="checkbox"] {
   	 	display:none;
	}
  	</style>
<body>
<div style="line-height:60px;height:60px">
	<span style="font-size:x-large;margin-left:30px;">工单列表</span>
</div>


<div id="gridbox" style="margin-left:20px;width:calc(100% - 40px);height:calc(100% - 100px)"></div>
<script type="text/javascript">

    	var flag=true,flaga0 = true,flaga1 = true,flaga2 = true,flaga3 = true,flaga4 = true,h,layout,layouts,myGrid,myPop,toolbar;
		var myLayout = new dhtmlXLayoutObject("gridbox", "1C");
		myLayout.cells("a").hideHeader();
		
		
		if(localStorage.sjgdlb){
			firstLogin(JSON.parse(localStorage.sjgdlb));
		}else{
			$.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"设计工单列表"},
				   success: function(res){	
					   localStorage.sjgdlb = JSON.stringify(res);
					   firstLogin(res);					   
				   }
			});
		}
		 
	
		function firstLogin(res){
			   var data = JSON.parse(res[0].design);
			   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);
			   var tabbar = layout.lays[0].cells("a").getAttachedObject();
			   changeWidth(layout);
			  
			  // role(tabbar);
			   
			   tabbar.attachEvent("onTabClick", function(id, lastId){	
				   flag = true;
				   
				   toolbar = tabbar.tabs(id).getAttachedToolbar();
				   
				   if(id == 'a4'){
					   if($('#test6').length < 1){
						   toolbar.addSpacer("spit");
						   toolbar.addButton('sreach', 10, '查询');
						   var div = document.createElement("div"); 
						   div.setAttribute('style','float: left;margin-top:2px');
						   div.innerHTML = '<select id="chooseDate" style="border: 1px solid #D3D3D3;height:27px;border-radius:5px;-webkit-appearance: none;padding-left:10px;padding-right:10px;">'+
						   '<option value="failureDate">报修日期</option><option value="sendDate">派发日期</option>'+
						   '<option value="acceptanceDate">受理日期</option><option value="caseDate">结案日期</option><option value="accessDate">回访日期</option></select>';
						   var div2 = document.createElement("div"); 
						   div2.setAttribute('style','float: left;margin-top:2px');
						   div2.innerHTML = '<input type="text" class="layui-input" id="test6" style="height:30px;margin-left:15px" placeholder=" - ">';								  
						   						  
						   toolbar.cont.children[0].append(div);
						   toolbar.cont.children[0].append(div2);

						   
						   layui.use('laydate', function(){
							   var laydate = layui.laydate;
							  
							 //日期范围
							   laydate.render({
							     elem: '#test6'
							     ,range: true
							     ,format: 'yyyy/MM/dd'
							   });
							 });
					   }

				   }
				   
				   myGrid = tabbar.tabs(id).getAttachedObject();
				   myGrid.setImagesPath("../DHX/imgs/");
				   myGrid.clearAll(false);
				   var progress = parseInt(id.replace(/[^0-9]/ig,""))+1;
				   createGrid(myGrid,res,progress,tabbar,id,null,null,null,null,null);
				   var myToolbar = tabbar.tabs(id).myToolbar;
				   myToolbar.attachEvent("onClick", function(e){
					  if(e != 'output-1'&& e!='output-2'&&e != 'print'){
						  var curPage = Number(myToolbar.getItemText("pageIndex").replace(/[^0-9]/ig,""));
						   var pageSize = Number(myToolbar.getItemText("pageSize").replace(/[^0-9]/ig,""));
						   myGrid.clearAll(false);
						   createGrid(myGrid,res,progress,tabbar,id,(curPage-1)*pageSize,pageSize,null,null,null); 
					  } 
				   });
				   toolbar.base.children[0].style.background='#ffffff';
				   toolbar.base.children[0].style.border='#ffffff';
			   });
			   
			   toolbar = tabbar.tabs("a0").getAttachedToolbar();
			   myGrid = tabbar.tabs("a0").getAttachedObject();
			   myGrid.setImagesPath("../DHX/imgs/");
			   myGrid.clearAll(false);
			   
			   createGrid(myGrid,res,1,tabbar,'a0',null,null,null,null,null);
			  tabbar.tabs("a0").myToolbar.attachEvent("onClick", function(id){
				  var a = tabbar.tabs("a0").myToolbar.getItemText("pageIndex");
				  var curPage = Number(a.replace(/[^0-9]/ig,""));
				  var pageSize = Number(id.replace(/[^0-9]/ig,""));
				  myGrid.clearAll(false);
				  createGrid(myGrid,res,1,tabbar,"a0",(curPage-1)*pageSize,pageSize,null,null,null);
			   });
			  toolbar.base.children[0].style.background='#ffffff';
			  toolbar.base.children[0].style.border='#ffffff';
		} 
		 
		 
		
		function role(tabbar){
			   tabbar.tabs("a0").getAttachedToolbar().hideItem("disRequest");
			   tabbar.tabs("a1").getAttachedToolbar().hideItem("returnSend");
			   tabbar.tabs("a2").getAttachedToolbar().hideItem("returnSend");
			   tabbar.tabs("a2").getAttachedToolbar().hideItem("changeSomeBody");
			   tabbar.tabs("a2").getAttachedToolbar().hideItem("stop");
			   tabbar.tabs("a3").getAttachedToolbar().hideItem("returnSend");
			   tabbar.tabs("a3").getAttachedToolbar().hideItem("disAccess");
			   tabbar.tabs("a3").getAttachedToolbar().hideItem("access");
			   
			   $.ajax({
				   type: 'POST',
				   url: '/role/seluserrole.action',
				   data: {userId:window.top.getID(),groupID:window.top.getGroupID()},
				   success: function(res){
					   if(res.data){
						   for(var i of res.data){
							   if(i.roleID == 'hfy'){
								   tabbar.tabs("a3").getAttachedToolbar().showItem("returnSend");
								   tabbar.tabs("a3").getAttachedToolbar().showItem("disAccess");
								   tabbar.tabs("a3").getAttachedToolbar().showItem("access");
							   }
							   if(i.roleID == 'jay'){
								   tabbar.tabs("a2").getAttachedToolbar().showItem("returnSend");
								   tabbar.tabs("a2").getAttachedToolbar().showItem("changeSomeBody");
								   tabbar.tabs("a2").getAttachedToolbar().showItem("stop");
							   }
							   if(i.roleID == 'pfy'){
								   tabbar.tabs("a0").getAttachedToolbar().showItem("disRequest");
								   tabbar.tabs("a1").getAttachedToolbar().showItem("returnSend");
							   }
						   } 
					   }
				   }
			   })
		}
		 
		 
		 
		 
		function toolbarEvent(myGrid,toolbar,num,cid){		
			
			if(toolbar.getUserData("show","isShow")!='yes'){
				toolbar.attachEvent("onClick", function(id){
				    if(id == 'disRequest'){disRequest(myGrid)}
					if(id == 'show'){show(toolbar,num,cid)}
					if(id == 'returnSend'){returnSend(myGrid)}
					if(id == 'changeSomeBody'){changeSomeBody(myGrid)}				
					if(id == 'access'){access(myGrid)}
					if(id == 'disAccess'){disAccess(myGrid)}
					if(id == 'stop'){stop(myGrid)}
					if(id == 'sreach'){sreach(myGrid)}
				});
			}
			toolbar.setUserData("show","isShow","yes");
		}
		
		
		function sreach(myGrid){
			
				myGrid.clearAll(false);
				var tabbar = layout.lays[0].cells("a").getAttachedObject();
				var myToolbar = tabbar.tabs("a4").myToolbar;
				var curPage = Number(myToolbar.getItemText("pageIndex").replace(/[^0-9]/ig,""));
				var pageSize = Number(myToolbar.getItemText("pageSize").replace(/[^0-9]/ig,""));
				
			if($('#test6')[0].value!=null&&$('#test6')[0].value!=''){	
				var obj = $("#chooseDate")[0];
				var chooseDate = obj.options[obj.selectedIndex].value;
				var test = $('#test6')[0].value;
				var test1 = test.split(" - ")[0]+' 00:00:00';
				var test2 = test.split(" - ")[1]+' 23:59:59';
				createGrid(myGrid,JSON.parse(localStorage.sjgdlb),5,tabbar,"a4",(curPage-1)*pageSize,pageSize,chooseDate,test1,test2); 
			}else{
				createGrid(myGrid,JSON.parse(localStorage.sjgdlb),5,tabbar,"a4",(curPage-1)*pageSize,pageSize,null,null,null); 
			}
		}
		
		

		//重派
		function returnSend(myGrid){
			var checked = myGrid.getCheckedRows(0);
			if(checked == ''){
				dhtmlx.alert('未选择复选框');
			}else{
				
				layui.use('layer', function(){
					var layer = layui.layer;
					  
					layer.open({
						title: '重派'
						,content: "重派原因：<input class='dhxform_textarea message' style='height:25px' type='text' />"
						,btnAlign: 'c'
						,yes: function(index, layero){
							
				    		var ids = '';
				    		for(var i of checked.split(',')){
				    			ids = ids + myGrid.getUserData(i,"ID") +','; 
				    		}
				    		ids = ids.slice(0,ids.length-1);
				    		var data = {groupID:window.top.getGroupID(),id:ids,progress:7,operationPeople:window.top.getUser().name,message:$('.message')[0].value};
				    		
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
						  }
					});     
				});              
				
				
				
			}
			
		}
		
		
		
		//回访
		function access(myGrid){
			var checked = myGrid.getCheckedRows(0);
			if(checked == ''){
				dhtmlx.alert('未选择复选框');
			}else{
				var w1 = dhtmlx.showDialog({
		            caption: '回访信息',
		            width: 850,
		            height: 350,
		            saveText: "确定",
		            save: function(){
		            	var ids = '';
			    		for(var i of checked.split(',')){
			    			ids = ids + myGrid.getUserData(i,"ID") +','; 
			    		}
			    		ids = ids.slice(0,ids.length-1);

		            	var data = {cCusName:window.top.getUser().name};
		            	data['id'] = ids;
		            	data['groupID'] = window.top.getGroupID();
		            	data['accessDate'] = $("input[name='accessDate']")[0].value;
		            	data['accessPeople'] = window.top.getID();
		            	data['accessPeopleName'] = window.top.getUser().name;
		            	data['progress'] = 5;
		            	data['overview'] = $("select[name='overview']")[0].options[$("select[name='overview']")[0].selectedIndex].innerHTML;
		            	data['feedback'] = $("textarea[name='feedback']")[0].value;
		            	 $.ajax({
			  				   type: 'POST',
			  				   url: '/ticket/editticket.action',
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
				   data: {DesignName:"设计回访信息"},
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
					   
					   $("input[name='accessPeople']")[0].value = window.top.getUser().name;
					   $("input[name='accessDate']")[0].value = Y+M+D+H+minute;
					   
					   $("select[name='overview']")[0].options.add(new Option("非常满意","5"));
					   $("select[name='overview']")[0].options.add(new Option("满意","4"));
					   $("select[name='overview']")[0].options.add(new Option("一般","3"));
					   $("select[name='overview']")[0].options.add(new Option("较差","2"));
					   $("select[name='overview']")[0].options.add(new Option("很差","1"));
					   
					   $('.dhxcombo_select_img').on('click',function(e){
						   var name = e.target.parentNode.parentNode.children[1].getAttribute('name');									
							if(name == 'processWay'){sameSelect(e,'processWay','选择处理方式','处理方式',$("input[name='processWay']")[0])}
					   })
				   }
			 })
			}
		}
		
		//转发
		function changeSomeBody(myGrid){
			var checked = myGrid.getCheckedRows(0);
			if(checked == ''){
				dhtmlx.alert('未选择复选框');
			}else if(checked.split(',').length>1){
				dhtmlx.alert('只能选择一条数据');
				}else{
					var w1 = dhtmlx.showDialog({
			            caption: '转发报修单',
			            width: 800,
			            height: 400,
			            saveText: "确定转发",
			            save: function(){
			            	if($("input[name='claimDate']")[0].value !=''&&$("input[name='finishDate']")[0].value !=''&&$("input[name='sendPeople']")[0].parentNode.children[0].value !=''){
			            		var ids = '';
					    		for(var i of checked.split(',')){
					    			ids = ids + myGrid.getUserData(i,"ID") +','; 
					    		}
					    		ids = ids.slice(0,ids.length-1);
			            		
			            		var getUserIDs = localStorage.getUserIDs;
			            		var ticketID = localStorage.ticketID;
			            		localStorage.removeItem('getUserIDs');		            		
			            		var data = {id:window.top.getGuid(),groupID:window.top.getGroupID(),ticketID:ticketID,userID:window.top.getID(),progress:6,getUserID:getUserIDs,claimDate:$("input[name='claimDate']")[0].value,finishDate:$("input[name='finishDate']")[0].value,wages:$("input[name='wages']")[0].value,otherMes:$("textarea[name='otherMes']")[0].value};
			            		data.sendDate = $("input[name='sendDate']")[0].value;
			            		data.userName = window.top.getUser().name;		            		
			            		data.getUserName = $("input[name='sendPeople']")[0].parentNode.children[0].value;
			            		data.processing2 = $("input[name='processing2']")[0].parentNode.children[0].value;
			            		
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
							    var rIdData = myGrid.getRowData(checked);
							    var date = new Date();
								var Y = date.getFullYear() + '/';
								var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '/';
								var D = date.getDate()+' ';
								if(D.length == 1) D = "0"+ D;
								var H = date.getHours() + ':';
								var minute= date.getMinutes();
								
								$("input[name='sendDate']")[0].value = Y+M+D+H+minute;
								$("input[name='legalPerson']")[0].value = window.top.getUser().name;
								$("input[name='finishDate']")[0].value = rIdData.finishDate?rIdData.finishDate:"";
								$("input[name='claimDate']")[0].value = rIdData.claimDate?rIdData.claimDate:"";
								$("input[name='wages']")[0].value = rIdData.wages?rIdData.wages:"";
								$("input[name='processing2']")[0].parentNode.children[0].value = rIdData.processing2?rIdData.processing2:"";
								$("textarea[name='otherMes']")[0].value = rIdData.otherMes?rIdData.otherMes:"";
								
							   $('.dhxcombo_select_img').on('click',function(e){
								   var name = e.target.parentNode.parentNode.children[1].getAttribute('name');		
									if(name == 'sendPeople'){sendSomebody(e)}
									if(name == 'processing2'){sameSelect(e,'processing','选择处理方式','处理方式',$("input[name='processing']")[0])}
							   })
						   }
					 }) 
				}  
		}
		
		
		//删除
		function disRequest(myGrid){
			var checked = myGrid.getCheckedRows(0);
			if(checked == ''){
				dhtmlx.alert('未选择复选框');
			}else{
				dhtmlx.confirm({
				    title: "删除请求",
				    type:"提示",
				    text: "是否确定删除?",
				    cancel: '否',
				    ok: '是',
				    callback: function(h) {
				    	if(h){
				    		var ids = '';
				    		for(var i of checked.split(',')){
				    			ids = ids + myGrid.getUserData(i,"ID") +','; 
				    		}
				    		ids = ids.slice(0,ids.length-1);
				    		$.ajax({
								   type: 'POST',
								   url: '/ticket/deleteticket.action',
								   data: {id:ids},
								   success: function(){
									   for(var i of checked.split(',')){
										   myGrid.deleteRow(i);
							    		} 
								   }
						   })
				    		
				    	}
				    }
				});
			}
			
		}
		
		//搁置
		function stop(myGrid){
			var checked = myGrid.getCheckedRows(0);
			if(checked == ''){
				dhtmlx.alert('未选择复选框');
			}else{
				
				layui.use('layer', function(){
					var layer = layui.layer;
					  
					layer.open({
						title: '搁置'
						,content: "搁置原因：<input class='dhxform_textarea message' style='height:25px' type='text' />"
						,btnAlign: 'c'
						,yes: function(index, layero){

				    		var ids = '';
				    		for(var i of checked.split(',')){
				    			ids = ids + myGrid.getUserData(i,"ID") +','; 
				    		}
				    		ids = ids.slice(0,ids.length-1);
				    		var data = {groupID:window.top.getGroupID(),id:ids,progress:8,operationPeople:window.top.getUser().name,message:$('.message')[0].value};
				    		
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
						  }
					});     
				});              

			}
		}
		
		
		
		//不回访
		function disAccess(myGrid){
			var checked = myGrid.getCheckedRows(0);
			if(checked == ''){
				dhtmlx.alert('未选择复选框');
			}else{
				dhtmlx.confirm({
				    title: "结束",
				    type:"提示",
				    text: "是否确定结束?",
				    cancel: '否',
				    ok: '是',
				    callback: function(h) {
				    	if(h){
				    		var ids = '';
				    		for(var i of checked.split(',')){
				    			ids = ids + myGrid.getUserData(i,"ID") +','; 
				    		}
				    		ids = ids.slice(0,ids.length-1);
				    		var data = {groupID:window.top.getGroupID(),cCusName:window.top.getUser().name,id:ids,progress:5};
				    		
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
				    	}
				    }
				});
			}
		}
		
		
		
		
		function createGrid(myGrid,res,progress,tabbar,id,curPage,pageSize,chooseDate,test1,test2){
			
			
			  var a='',att ='',ids='';
			  var data = $.parseJSON(res[0].design);	
			  for(var i of data.Context[progress-1].Columns){
				  if(i.Name == 'check'){
					  att = att + ',';
				  }else
					  att = att + '#text_filter,';
					  a = a + i.Label + ','; 
					  ids = ids + i.Name +',';			  													  
			  }
			 
			  a = a.slice(0,a.length-1);
			  ids = ids.slice(0,ids.length-1);
			  att = att.slice(0,att.length-1);

				//数据列拖拽
				myGrid.enableColumnMove(true);
				
				colState(a);

				
				if($('.hdr')[progress-1].children[0].children[1].children[0].children[0].children.length == 1){
					var img = document.createElement("img");
					img.setAttribute("id", "chooseAllBox"+progress);
					img.setAttribute("style", "margin-top:10px");
					img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
					img.setAttribute("onclick", "chooseAll("+progress+")");
					$('.hdr')[progress-1].children[0].children[1].children[0].children[0].append(img);
				}else{				
					$('.hdr')[progress-1].children[0].children[1].children[0].children[0].children[0].checked = false;
					$('#chooseAllBox'+progress)[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk0.gif";
				}
				
				
				
				//0列不允许拖动,不允许把列移动到0列
				myGrid.attachEvent("onBeforeCMove", function(cInd,posInd){
					if(cInd == 0)return false;
					else if(posInd== 0)return false;
					else return true;
					
				});
				
				$.ajax({
					   type: 'POST',
					   url: '/ticket/selticketall.action',
					   data: {groupID:window.top.getGroupID(),progress:progress,curPage:curPage,pageSize:pageSize,chooseDate,test1,test2},
					   success: function(res){
						   if(res.data){
							   var array = new Array();
							   var a = ids.split(',');
							   var sum = res.data.length;
							   for(var j=0;j<sum;j++){
								   res.data[j].legalPerson = res.data[j].legalPersonName;
								   res.data[j].assignee = res.data[j].assigneeName;
								   res.data[j].casePerson = res.data[j].casePersonName;
								   res.data[j].accessPeople = res.data[j].accessPeopleName;
								   var arr = new Array();
								   for(var i=0;i<a.length;i++){
									   if(a[i] == ''){
										   arr[i] = null;
									   }else
										   arr[i] = res.data[j][a[i]];							   
								   }
								   array[j] = arr;
							   } 
							   
							   myGrid.parse(array,"jsarray");	
							   if(!$('.hdr')[progress-1].children[0].children[2]){
								   myGrid.attachHeader(att);
								   $('.hdr')[progress-1].children[0].children[2].style.display='none';
							   }
							  
							   
							   var count=myGrid.getRowsNum();
							   for(var i=0;i<count;i++){
								   myGrid.setRowId(i,"row"+i);						   
								   myGrid.setUserData("row"+i,"ID",res.data[i].id);
							   }
							  					   
							   toolbarEvent(myGrid,toolbar,progress-1,id);
							   curPage = curPage?curPage:0;
							   tabbar.tabs(id).myToolbar.setItemText("textCell","当前："+curPage+"-"+(curPage+count)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;总数："+res.count);
							   tabbar.tabs(id).totalCount = count;
								   
							   myGrid.attachEvent("onRowDblClicked", function(rId,cInd){
							       localStorage.chooseRequest = myGrid.getUserData(rId,"ID");
							     
							       //添加iframe标签
							       var body = document.getElementsByTagName("body");
							       var div = document.createElement("div");
							       div.setAttribute("id","editRequest");
							       div.setAttribute("style","width:100%;height:100%; position:absolute;left:0;top:0;");
							       div.innerHTML = '<iframe id="idFrame" name="idFrame" src="/view/torequest.action" height = "100%" width = "100%" frameborder="0" scrolling="auto" " ></iframe>';
							       document.body.appendChild(div);
							   });
						   } 
					   }
				 })

			}
		
		//列隐藏和显示
		function  colState(e){
			var td = $('.hdr')[0].children[0].children[1].children;
			var head = e.split(',');
			var data = new Array();
			
	   		for(var i=0;i<td.length;i++){		
	   			td[i].onmousedown = function(e){
	   				if(e.button == 2){
	   					data = [];
	   					data.push({type: "label", label: "隐藏/显示"});
	       				for(var j = 2;j<head.length;j++){	
	       	    				var q = myGrid.isColumnHidden(j);
	       	    				var l = {type: "checkbox", label: head[j], checked:!q, name: j,position:"label-right"};
	       	        			data.push(l);	
	       				}
	   					if(myPop)
	   					myPop.unload();
						    myPop = new dhtmlXPopup();	
						    var myForm = myPop.attachForm(data);
						   
						    myPop.show(e.x-110,0,150,300);
						    $('.dhx_popup_dhx_terrace')[0].style.top='120px';	
						 
						   $('.dhx_popup_arrow')[0].style.display='none';
						   $('.dhx_popup_td')[0].children[0].style.height='250px';
						   $('.dhx_popup_td')[0].children[0].style.width='120px';
						   $('.dhx_popup_td')[0].children[0].style.overflowY='scroll';
						    myForm.attachEvent("onChange", function (name, value, state){
						        var num;
						        for(var i =0;i<td.length;i++){
						        	if(td[i].children[0].innerHTML == myForm.getItemLabel(name)){
						        		num = i;break;
						        	}
						        }
						        if(state){
						        	myGrid.setColumnHidden(i,false);
						        }else{
						        	myGrid.setColumnHidden(i,true);
						        }
						   });
	   			   }
	   			}
	   		}
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
		
		function chooseAll(e){
			$('.hdr')[e-1].children[0].children[1].children[0].children[0].children[0].click();
			if(flag){
				$('#chooseAllBox'+e)[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk1.gif";
				flag = false;
			}else{
				$('#chooseAllBox'+e)[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk0.gif";
				flag = true;
			}
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

		   return mytree;Z
		 }
		
		

		function compareData(date1,date2){
		    var oDate1 = new Date(date1);
		    var oDate2 = new Date(date2);
		    if(oDate1.getTime() > oDate2.getTime()){
		        return true;
		    } else {
		        return false;
		    }
		}

		
		
		function changeWidth(layout){
			 window.onresize = function(){								  
				   var a = $('#gridbox')[0].clientWidth||$('#gridbox')[0].offsetWidth;
				   var b = $('#gridbox')[0].clientHeight||$('#gridbox')[0].offsetHeight;
				   layout.lays[0].cells("a").cell.style.width = a+'px';
				   layout.lays[0].cells("a").cell.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[0].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[0].children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[1].style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[1].children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[2].style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[2].children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[3].style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[3].children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[4].style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[4].children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[5].style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[5].children[1].style.width = a-2+'px';
				   layout.lays[0].cells("a").cell.style.height = b+'px';
				   layout.lays[0].cells("a").cell.parentNode.style.height = b+'px';
				   layout.lays[0].cells("a").cell.children[1].style.height = b+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.style.height = b+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.parentNode.style.height = b+'px';
				   layout.lays[0].cells("a").cell.children[1].style.height = b+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].style.height = b+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[1].style.height = b-34+'px';
				   layout.lays[0].cells("a").cell.children[1].children[0].children[0].children[0].children[1].children[1].style.height = b-34-82+'px';
			   }
		 }
		
		
		
		function show(toolbar,num,cid){
			var hdr = $('.hdr')[num].children[0];
			var table = hdr.children[2];
			var xhdr = $('.xhdr')[num];	
			if(eval("flag"+cid)){
				table.style.display = '';
				xhdr.style.height = hdr.offsetHeight+'px';
				h = table.offsetHeight;
				$('.objbox')[num].style.height = parseInt($('.objbox')[0].style.height) - h +'px';
				toolbar.base.children[0].children[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk1.gif";
				switch(cid) {
			     case 'a0':
			    	 flaga0 = false;
			        break;
			     case 'a1':
			    	 flaga1 = false;
			        break;
			     case 'a2':
			    	 flaga2 = false;
			        break;
			     case 'a3':
			    	 flaga3 = false;
			        break;
			     case 'a4':
			    	 flaga4 = false;
			        break;  
				} 
				
			}else{
				table.style.display = 'none';
				xhdr.style.height = hdr.offsetHeight+'px';	
				if(num == 0)
					$('.objbox')[num].style.height = parseInt($('.objbox')[0].style.height)+ h +'px';
				else
					$('.objbox')[num].style.height = parseInt($('.objbox')[0].style.height) +'px';
				toolbar.base.children[0].children[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk0.gif";
				switch(cid) {
			     case 'a0':
			    	 flaga0 = true;
			        break;
			     case 'a1':
			    	 flaga1 = true;
			        break;
			     case 'a2':
			    	 flaga2 = true;
			        break;
			     case 'a3':
			    	 flaga3 = true;
			        break;
			     case 'a4':
			    	 flaga4 = true;
			        break;  
				} 
			}
		}

</script> 
</body>
</html>