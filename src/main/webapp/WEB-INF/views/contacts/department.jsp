<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>通讯录</title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
	<link rel="stylesheet" href="${pageContext.request.contextPath }/layuiadmin/layui/css/layui.css" media="all">
	<script type="text/javascript" src="${pageContext.request.contextPath}/layuiadmin/layui/layui.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
	<style type="text/css">
		 html, body {
            width: 100%;
            height: 100%;
            margin: 0px;
            overflow: hidden;                    
        }
       input[type="checkbox"] {
   	 	display:none;
		} 
	</style>
</head>
<body>

<div id="test1" ></div>

<script>
	var myLayout = new dhtmlXLayoutObject({
	    parent: document.body,
	    pattern: "2U",
	    cells: [
	        { id: "a", header: true,text:'组织架构', width: 340},
	        { id: "b", header: true,text:'人员列表' }
	    ]
	});
	//pointId获取人员手机号的位置,isPeople部门下是否有人,flag显示全部,flag2显示离职,flag3显示树是否改动,flag4显示筛选flag5显示全选,h筛选框高度
	var treeId,selectId=0,pointId,workSate,isPeople=false,flag='show',flag2='show',flag3=true,flag4=true,flag5=true,h;
	//list2离职信息,sh审核,bm部门,js角色,gy雇佣,dz到职,lz离职,bh编号,gh工号,bgdh办公电话,fjh分机号,gwmc岗位名称
	 var tbar,myTBar,myPop,role,dislist,sh,bm,js,gy,dz,lz,bh,gh,bgdh,fjh,gwmc;var list2 = new Array(); 
	 
	 
	//初始化树
    var tree = myLayout.cells("a").attachTree();
    tree.setImagePath("../DHX/imgs/dhxtree_terrace/");
		
	$.ajax({
    	type: 'POST',
    	url: '${pageContext.request.contextPath}/person/selperson.action',
    	data:{groupName:window.top.getName(),userId:window.top.getID()},
    	success: function(res){
    		if(res.data){
	    		if(res.data[0].roleName =='盟主'||res.data[0].roleName =='副盟主'){
	    			role=res.data[0].roleName;
	    			tree.enableDragAndDrop(true);
	    			tree.enableSmartXMLParsing(true);
	    			tree.setDragBehavior("complex");
	    			tree.enableItemEditor(true);
	    			 myTBar = myLayout.cells("a").attachToolbar().format({
	    				Items: [
	    		            { ID: "addTree", Type: "button", Text: "增加" },           
	    		            { ID: "deleteTree", Type: "button", Text: "删除" },
	    		            { ID: "saveTree", Type: "button", Text: "保存" },
	    		            { ID: "revoke", Type: "button", Text:"撤销" },
	    		            { ID: "disrevoke", Type: "button", Text:"反撤销" },
	    		            {ID: "sep99", Type: "separator"},
	    		            { ID: "show", Type: "button", Text:"显示全部",Img:"1.png" }
	    		            ],
	    		            Spacer: "sep99", 
	    		        Action: function (id) {
	    		            if (id == "addTree") addTree();
	    		            if (id == "deleteTree") deleteTree();
	    		            if (id == "saveTree") saveTree();        
	    		            if (id == "revoke" )revoke();
	    		            if (id == "disrevoke")disrevoke();
	    		            if (id == "show")show();
	    		        }
	    			});
	    			var buttons = $('.dhxtoolbar_btn_def');
	    			buttons[buttons.length-1].style.background='#ffffff';
	    			buttons[buttons.length-1].style.border='#ffffff';
	    			
	    			 myTBar.hideItem("disrevoke");
	    			 	
	    			    tbar = myLayout.cells("b").attachToolbar().format({
	    				 Items:[	       		  
	    				        {ID: "saveGrid", Type: "button", Text: "格式保存", Img: "save.gif"},
	    				        {ID: "sep1", Type: "separator" },
	    				        {ID: "tool", Type: "button", Text: "筛选"},
	    				        {ID: "toExcel", Type: "button", Text: "导出"},
	    				        {ID: "sep2", Type: "separator" },
	    				        {ID: "pass", Type: "button", Text: "审核"},
	    				        {ID: "disPass", Type: "button", Text: "弃审"},
	    				        {ID: "sep99", Type: "separator"},
	    				        {ID: "showLeave", Type: "button", Text: "显示离职",Img:"1.png"}
	    				    ],
	    				    Spacer: "sep99", 
	    				 Action:function (id){
	    					 if(id== "saveGrid")saveGrid();
	    					 if(id== 'pass')pass();
	    					 if(id== 'disPass')disPass();
	    					 if(id=='tool')tool();	    					 
	    					 if(id =='showLeave')showLeave();
	    					 if(id=='toExcel')toExcel();
	    				 }
	    				});
	    					    			
	    			   
	    				var buttons2 = $('.dhxtoolbar_btn_def');	    				
	    				buttons2[buttons2.length-1].style.background='#ffffff';
	    				buttons2[buttons2.length-1].style.border='#ffffff';
	    						
	    				
	    		}else{
	    			role = '成员';
	    			tbar = myLayout.cells("b").attachToolbar().format({
	    				 Items:[	       		  
	    				        {ID: "saveGrid", Type: "button", Text: "格式保存", Img: "save.gif"},
	    				        {ID: "sep1", Type: "separator" },
	    				        {ID: "tool", Type: "button", Text: "筛选"},   
	    				    ],
	    				 Action:function (id){
	    					 if(id== "saveGrid")saveGrid();
	    					 if(id=='tool')tool();
	    				 }
	    				});
	    		}
    		}
    	}
   	});
	
	//加载组织树
	$.ajax({
	    	type: 'POST',
	    	url: '${pageContext.request.contextPath}/department/seldepartment.action',
	    	data:{groupID:window.top.getGroupID()},
	    	success: function(res){
	    		if(res.data[0].listData){
	    			tree.parse($.parseJSON(res.data[0].showData),"json");
	    		}else{
	    			var arr = [[1,0,window.top.getName()]];
	    			tree.parse(arr,"jsarray");	    			
	    		}
	    		setTimeout(function () {
	    			$('.standartTreeRow')[2].click();
	    		}, 1000);
	    	}
      });
	
	
	
	//阻止组织树枝移出树根
	tree.attachEvent("onDrop", function(sId, tId, id, sObject, tObject){
		flag3 = false;
		var data =  $.parseJSON(tObject.serializeTreeToJSON());
		if(data.item.length!=1){
			if(tId == 0){
		    	var data =  $.parseJSON(tObject.serializeTreeToJSON());
		    	var moveData = data.item[1];
		    	data.item.splice(1,1);
		    	if(data.item[0].item){
		    		data.item[0].item.push(moveData);
		    	}else{
		    		var arr = new Array();
		    		arr[0] = moveData;
		    		data.item[0].item = arr;
		    	}
		    	tree.deleteItem(1,true);
		    	tree.deleteItem(sId,true);
		    	tree.parse(data,"json");
		    	tree.openAllItems(1);
		    }
		}
	    
	});
	var a1,a2;
	tree.setOnEditHandler(m_func);

	function m_func(state,id,tree,value){
		if(state == 0)a1 = value;
		if(state == 2)a2 = value;
		if(a1 == a2) flag3=true;
		else
		flag3=false;
		if((state==2)&&(value=="")) {
			return false;
		}
		return true;
	
	}
	
	
	
	
	
	var myGrid = myLayout.cells("b").attachGrid();
	myGrid.setImagePath("/DHX/imgs/");
	
	//超时逐步解析
	myGrid.enableDistributedParsing(true,50,2000);
	//数据列拖拽
	myGrid.enableColumnMove(true);
	//数据行拖拽
	//myGrid.enableDragAndDrop(true);


	
	myGrid.attachEvent("onRowSelect", function(id,ind){
		selectId = id;	
	});
	
	//0,1,2列不允许拖动,不允许把列移动到0,1,2列
	myGrid.attachEvent("onBeforeCMove", function(cInd,posInd){
		if(cInd == 0 ||cInd == 1||cInd == 2)return false;
		else if(posInd== 0 ||posInd == 1||posInd == 2)return false;
		else return true;
		
	});
	
	
	
	
	
	
	//添加树
	function addTree(){
		flag3 = false;
		var treeId = tree.getSelectedItemId();
		if(treeId ==''){
			dhtmlx.alert('请选择部门');
		}else
			tree.insertNewChild(treeId,window.top.getGuid(),"未命名");		
	};
	//删除树
	function deleteTree(){
		flag3 = false;
		var treeId = tree.getSelectedItemId();
		if(isPeople){
			dhtmlx.alert('部门下有人员,不可删除');
		}else if(treeId ==''){
			dhtmlx.alert('请选择部门');
		}else if(treeId==1){
			 dhtmlx.alert("组织不可删除")
	        }else{
	        	tree.deleteItem(treeId,true);	        	
	        }
	};
	//保存树
	function saveTree(){
		tree.clearSelection(treeId);
		tree.clearSelection(tree.getParentId(treeId));
		var testJson = tree.serializeTreeToJSON();
		$.ajax({
	    	type: 'POST',
	    	url: '/department/seldepartment.action',
	    	data:{groupID:window.top.getGroupID()},
	    	success: function(res){
	    		if(res.msg == '查询成功'){
					if(res.data[0].revokeDate){
	    				var rdata = $.parseJSON(res.data[0].revokeDate).data;
	    				var sdata = tree.serializeTreeToJSON();
	    				var ldata = $.parseJSON(sdata);
	    				
						function addData(a,b){
							if(a){
								for(var i of a){
									for(var j of b){
										if(i.id == j.pId){
											if(i.item)
												i.item.push(j);
											else{
												var arr = new Array();
												arr.push(j)
												i.item = arr;
											}
										}
									}
										addData(i.item,b);	
									
								}
							}
						}
						addData(ldata.item,rdata);
	    				
						$.ajax({
	    			    	type: 'POST',
	    			    	url: '/department/editdepartment.action',
	    			    	data:{listData:JSON.stringify(ldata),showData:sdata,groupID:window.top.getGroupID()},
	    			    	success: function(res){
	    			    		if(res.msg == '修改成功')
	    			    		 dhtmlx.alert('保存成功');
	    			    		else if(res.msg == '修改失败')
	    			    			dhtmlx.alert('保存失败');
	    			    	}
	    		       	});
	    				
	    				
	    			}else{
	    				$.ajax({
	    			    	type: 'POST',
	    			    	url: '/department/editdepartment.action',
	    			    	data:{listData:testJson,showData:testJson,groupID:window.top.getGroupID()},
	    			    	success: function(res){
	    			    		if(res.msg == '修改成功')
	    			    		 dhtmlx.alert('保存成功');
	    			    		else if(res.msg == '修改失败')
	    			    			dhtmlx.alert('保存失败');
	    			    	}
	    		       	});
	    			}
	    		}    		
	    	}
       	});
		
		
	};
	//撤销树
	function revoke(){
		if(flag3){
			var treeId = tree.getSelectedItemId();
			var treeName = tree.getItemText(treeId);
			if(treeId ==''){
				dhtmlx.alert('请选择部门');
			}else if(treeId =='1'){
				dhtmlx.alert('部门不可撤销');
				}else if(isPeople){
					dhtmlx.alert('部门下有人员,不可撤销');
				}else{						
					var myDate = new Date();
					var time = myDate.getFullYear()+"-"+(parseInt(myDate.getMonth())+1)+"-"+myDate.getDate();
					var data = new Array();
					var n = tree.getItemText(treeId);
					var pid = tree.getParentId(treeId);
					var list = {'id':treeId,'poen':'1','pId':pid,'text':n,'time':time};
					function aaa(tree,treeId,time,b){
						var c = tree.getSubItems(treeId);													
						if(c!=''){
							var aData = new Array();
							for(let i of c.split(',')){
								var n = tree.getItemText(i);
								var d = {'id':i,'poen':'1','text':n,'time':time};
								aData.push(d);						
								aaa(tree,i,time,d);
							}
							b.item = aData;
						}
					}
					aaa(tree,treeId,time,list);
					
					tree.deleteItem(treeId,true);
					tree.clearSelection(pid);
					var testJson = tree.serializeTreeToJSON();
					
					$.ajax({
				    	type: 'POST',
				    	url: '/department/seldepartment.action',
				    	data:{groupID:window.top.getGroupID()},
				    	success: function(res){
				    		if(res.msg == '查询成功'){
				    			if(res.data[0].revokeDate){		    				
				    				var data = $.parseJSON(res.data[0].revokeDate);
				    				var b = data.data;
				    				b.push(list);		    							    				
			    					
				    				$.ajax({
				    			    	type: 'POST',
				    			    	url: '/department/editdepartment.action',
				    			    	data:{showData:testJson,groupID:window.top.getGroupID(),revokeDate:JSON.stringify(data)},
				    			    	success: function(res){
				    			    		if(res.msg == '修改成功')
				    			    			dhtmlx.alert('撤销成功');    			    		 
				    			    		else if(res.msg == '修改失败')
				    			    			dhtmlx.alert('撤销失败');
				    			    	}
				    		       	});	
				    			}else{
				    				var arr = new Array();
				    				arr.push(list);		    						    				
				    				
				    				var a = {data: arr};
				    				$.ajax({
				    			    	type: 'POST',
				    			    	url: '/department/editdepartment.action',
				    			    	data:{showData:testJson,groupID:window.top.getGroupID(),revokeDate:JSON.stringify(a)},
				    			    	success: function(res){
				    			    		if(res.msg == '修改成功')
				    			    			dhtmlx.alert('撤销成功');	    			    		
				    			    		else if(res.msg == '修改失败')
				    			    			dhtmlx.alert('撤销失败');
				    			    	}
				    		       	});
				    			}
				    		}    		
				    	}
			       	});	
				}
		}else
			dhtmlx.alert('修改过组织，需要先保存');
	};
	
	//显示全部树
	function show(){
		if(flag == 'show'){
			myTBar.setItemImage("show", "2.png");
			flag = 'hide';
			$.ajax({
		    	type: 'POST',
		    	url: '/department/seldepartment.action',
		    	data:{groupID:window.top.getGroupID()},
		    	success: function(res){
		    			tree.deleteItem(1,true);
		    			tree.parse($.parseJSON(res.data[0].listData),"json");
		    			tree.openAllItems(1);
		    			var treediv = $('.standartTreeRow');
		    		    var list = $.parseJSON(res.data[0].revokeDate).data;
		    		    for(var i of list){
		    		    	for(var j=0;j<treediv.length;j++){
			    				if(treediv[j].innerHTML == i.text){
			    					var br = document.createElement("span");
			    					br.innerHTML = '（已撤销）';
			    					treediv[j].parentNode.append(br);
			    					continue;
			    				}
			    			}
	    				}
		    			
		    	}
	       	});
			
		}else if(flag == 'hide'){
			myTBar.setItemImage("show", "1.png");
			flag = 'show';
			$.ajax({
		    	type: 'POST',
		    	url: '/department/seldepartment.action',
		    	data:{groupID:window.top.getGroupID()},
		    	success: function(res){
		    			tree.deleteItem(1,true);
		    			tree.parse($.parseJSON(res.data[0].showData),"json");
		    			tree.openAllItems(1);
		    	}
	       	});
		}
		
	};

	
	
	
	
	
	//反撤销
	function disrevoke(){
		var treeId = tree.getSelectedItemId();
		if(treeId ==''){
			dhtmlx.alert('请选择部门');
		}else{
			$.ajax({
		    	type: 'POST',
		    	url: '/department/seldepartment.action',
		    	data:{groupID:window.top.getGroupID()},
		    	success: function(res){
		    		var data = $.parseJSON(res.data[0].revokeDate).data;
		    		var sdata = $.parseJSON(res.data[0].showData);
		    		for(var i=0;i<data.length;i++){
		    			if(data[i].id == treeId){
		    				
		    				function addData(a,i){
		    					if(a){
									for(var q of a){
										if(q.id == i.pId){
											if(q.item)
												q.item.push(i);
											else{
												var arr = new Array();
												arr.push(i)
												q.item = arr;
											}
										}									
									addData(q.item,i);
									}
								}							
							}
		    				addData(sdata.item,data[i]);
		    				data.splice(i, 1);
		    				break;
		    			}
		    		}
	
    				var a = {data: data};
				
		    		$.ajax({
    			    	type: 'POST',
    			    	url: '/department/editdepartment.action',
    			    	data:{showData:JSON.stringify(sdata),groupID:window.top.getGroupID(),revokeDate:JSON.stringify(a)},
    			    	success: function(res){
    			    		if(res.msg == '修改成功'){
    			    			dhtmlx.alert('反撤销成功');
	    			    		myTBar.hideItem("disrevoke");
		    					myTBar.showItem("revoke");
		    					var treediv = $('.standartTreeRow');
		    					
		    					for(var i=0;i<treediv.length;i++){
		    						if(treediv[i].children[0]){
		    							if(treediv[i].children[0].innerHTML == tree.getSelectedItemText()){
		    								treediv[i].removeChild(treediv[i].children[1]);
			    						}
		    						}
		    					}
		    					
    			    		}
    			    		else if(res.msg == '修改失败')
    			    			dhtmlx.alert('反撤销失败');
    			    	}
    		       	});
		    	}	
	       	});

		}
		
	}
		
		
	
	
	
	
	//显示是否离职
	function showLeave(){
		var tools = $('.obj')[0].children[0].childNodes;
		if(flag2 == 'show'){
			tbar.setItemImage("showLeave", "2.png");
			flag2 = 'hide';

			for(var i=0;i<list2.length;i++){				
				myGrid.addRow(list2[i].id,list2[i].data);
				tools[tools.length-1].children[2].append(addButton("chat(this)","layui-icon-dialogue","沟通"));
				if(tools[tools.length-1].children[sh].innerHTML!='已拒绝')
				tools[tools.length-1].children[2].append(addButton("back(this)","layui-icon-addition","反注销"));
				
			}
			showTip();
		}else if(flag2 == 'hide'){
			tbar.setItemImage("showLeave", "1.png");
			flag2 = 'show';
			for(var i=0;i<list2.length;i++)
				myGrid.deleteRow(list2[i].id);
		}
	}
	
	
	
	
	
	
	//保存表格样式
	function saveGrid(){ 
		
		var num = myGrid.getColumnsNum();
		var width = '';
		var type = '';	
		var head='';
		var hide='';
		for(var i = 0;i<num;i++){					
			if(i == num - 1){				
				width += myGrid.getColWidth(i);				
				type += myGrid.getColType(i);
				head += myGrid.getColLabel(i);
				hide += myGrid.isColumnHidden(i);
			}
			else{
				if(myGrid.getColWidth(i)==0){width = width + '100,'}
				else
				width = width + myGrid.getColWidth(i) + ',';
				type = type + myGrid.getColType(i) +',';
				hide += myGrid.isColumnHidden(i) +',';
				if(myGrid.getColLabel(i)=='')
					head = head + '#master_checkbox,';
				else 
					head = head + myGrid.getColLabel(i) + ',';
			}
		}		
		var data = {'head':head,'width':width,'type':type,'hide':hide};

		$.ajax({
	    	type: 'POST',
	    	url: '/person/selpersontable.action',
	    	data:{groupName:window.top.getName(),userId:window.top.getID()},
	    	success: function(res){
	    		if(res.data){
	    			$.ajax({
	    		    	type: 'POST',
	    		    	url: '/person/editpersontable.action',
	    		    	data:{groupName:window.top.getName(),userId:window.top.getID(),data:JSON.stringify(data)},
	    				success: function(res){dhtmlx.alert('保存成功');}
	    	       	});
	    		}else{
	    			$.ajax({
	    		    	type: 'POST',
	    		    	url: '/person/addpersontable.action',
	    		    	data:{groupName:window.top.getName(),userId:window.top.getID(),data:JSON.stringify(data)},
	    		    	success: function(res){dhtmlx.alert('保存成功');}
	    	       	});
	    		}
	    	}
       	});
		
		
		
	};
	//工具栏
	function tool(){
		var hdr = $('.hdr')[0].children[0];
		var table = hdr.children[2];
		var xhdr = $('.xhdr')[0];		
		if(flag4){
			table.style.display = '';
			h = table.offsetHeight;
			xhdr.style.height = hdr.offsetHeight+'px';
			$('.objbox')[0].style.height = (parseInt($('.objbox')[0].style.height) - h) + 'px';
			flag4 = false;
		} else {
			table.style.display = 'none';
			xhdr.style.height = hdr.offsetHeight+'px';
			$('.objbox')[0].style.height = (parseInt($('.objbox')[0].style.height) + h) + 'px';
			flag4 = true;
		}
		
	}
	
	//聊天
	function chat(e){
		var phone = e.parentNode.parentNode.children[pointId].innerHTML;
			
	}
	
	//审核
	function pass(){

		var tools = $('.obj')[0].children[0].childNodes;
		var ids = myGrid.getCheckedRows(1);
		if(ids !=''){
			var w1 = dhtmlx.showDialog({
	            caption: '选择是否通过',
	            width: 250,
	            height: 150,
	            modal: true
	        });
			w1.layout.cells("a").dataNodes.toolbar.cont.children[1].children[0].style.display="none";
			var lay = w1.layout.cells("a");
			var myForm = lay.attachForm([{type: "button", name: "yes", value: "通过",offsetLeft:30,offsetTop:20},{type: "newcolumn"},{type: "button", name: "no", value: "拒绝",offsetLeft:30,offsetTop:20}]);
			myForm.attachEvent("onButtonClick", function(name){
			    if(name == 'yes'){
			    	for (var id of ids.split(',')){
						var i = myGrid.getRowIndex(id) + 1;
						var phone = tools[i].children[pointId].innerHTML;
						var state = tools[i].children[sh].innerHTML;
						if(state == '申请中'){
							$.ajax({
						    	type: 'POST',
						    	url: '/person/editperson.action',
						    	data:{groupName:window.top.getName(),mobilePhone:phone,state:'通过',workState:'在职'}		    	
					       	});
						}
					}
			    	 w1.close();
			    	$('.standartTreeRow')[2].click();
			    }
			    if(name == 'no'){
			    	for (var id of ids.split(',')){
						var i = myGrid.getRowIndex(id) + 1;
						var phone = tools[i].children[pointId].innerHTML;
						var state = tools[i].children[sh].innerHTML;
						if(state == '申请中'){
							$.ajax({
						    	type: 'POST',
						    	url: '/person/editperson.action',
						    	data:{groupName:window.top.getName(),mobilePhone:phone,state:'已拒绝'}		    	
					       	});
						}
					}
			    	 w1.close();
			    	$('.standartTreeRow')[2].click();
			    }
			});
		}
		
		
		
		
		
		
	}
	
	//反审核(弃审)
	function disPass(){
		var tools = $('.obj')[0].children[0].childNodes;
		var ids = myGrid.getCheckedRows(1);
		for (var id of ids.split(',')){
			var i = myGrid.getRowIndex(id) + 1;
			var phone = tools[i].children[pointId].innerHTML;
			var state = tools[i].children[sh].innerHTML;
			if(state == '通过'){
				$.ajax({
			    	type: 'POST',
			    	url: '/person/editperson.action',
			    	data:{groupName:window.top.getName(),mobilePhone:phone,state:'申请中',workState:''},
			    	success: function(res){	
			    		$('.standartTreeRow')[2].click();
			    	}
		       	});
			}
			
		}
		
	}
	
	
	
	
	
	
	
	
	//更换部门
	function change(e){
		var rId = myGrid.getRowId((parseInt(e.parentNode.parentNode.children[0].innerHTML)-1)+'');
		var w1 = dhtmlx.showDialog({
            caption: '更换部门',
            width: 350,
            height: 300,
            modal: true,
            save: function () {           
            	if(selectId==0){
            		dhtmlx.alert('未选择人员');
            	}else{
            		var depID = mytree.getSelectedItemId();
            		if(depID){
            			var phone = myGrid.rowsAr[selectId].children[pointId].innerHTML;
            			var depName = mytree.getSelectedItemText();
            			$.ajax({
            		    	type: 'POST',
            		    	url: '/person/editperson.action',
            		    	data:{groupName:window.top.getName(),mobilePhone:phone,depID:depID},
            		    	success: function(res){            		    		
            		    		dhtmlx.alert(res.msg);
            		    		myGrid.cells(rId,bm).setValue(depName);
            		    	}
            	       	});
                 	   	w1.close();

                    }else
                 	   dhtmlx.alert('未选择组织');
            	}
            	 
            }				
        });

		var lay = w1.layout.cells("a");
		var mytree = lay.attachTree();
		mytree.setImageArrays("plus","","","","plus.gif");
		mytree.setImageArrays("minus","","","","minus.gif");
		mytree.setImagePath("../DHX/imgs/dhxtree_terrace/");
		
		$.ajax({
		    	type: 'POST',
		    	url: '/department/seldepartment.action',
		    	data:{groupID:window.top.getGroupID()},
		    	success: function(res){
		    		if(res.data[0].showData){
		    			mytree.parse($.parseJSON(res.data[0].showData),"json");
		    		}else{
		    			var arr = [[1,null,window.top.getName()]];
		    			mytree.parse(arr,"jsarray");
		    		}
		    	}
	       	});
	}
	
	//注销
	function leave(e){
		var phone = e.parentNode.parentNode.children[pointId].innerHTML;
		$.ajax({
	    	type: 'POST',
	    	url: '/person/editperson.action',
	    	data:{groupName:window.top.getName(),mobilePhone:phone,workState:'离职'},
	    	success: function(res){
	    		$('.standartTreeRow')[2].click();
	    	}
       	});
	}
	
	//反注销
	function back(e){
		var phone = e.parentNode.parentNode.children[pointId].innerHTML;
		var tools = $('.obj')[0].children[0].childNodes;
		
		
		$.ajax({
	    	type: 'POST',
	    	url: '/person/editperson.action',
	    	data:{groupName:window.top.getName(),mobilePhone:phone,state:'通过',workState:'在职'},
	    	success: function(res){	
	    		tools[tools.length-1].children[2].innerHTML='';
	    		tbar.setItemImage("showLeave", "1.png");
				flag2 = 'show';
	    		$('.standartTreeRow')[2].click();
	    		
	    	}
       	});
		
	}
	
	
	
	function toExcel(){
		//myGrid.deleteColumn(0);
		//myGrid.deleteColumn(0);
		//myGrid.deleteColumn(0);
		myGrid.toExcel("https://dhtmlxgrid.appspot.com/export/excel");
	}
	
	
	
	
	//设置用户为副盟主
	function setAdmin(e){
		var phone = e.parentNode.parentNode.children[pointId].innerHTML;
		var rId = myGrid.getRowId((parseInt(e.parentNode.parentNode.children[0].innerHTML)-1)+'');
		
		$.ajax({
	    	type: 'POST',
	    	url: '/person/editperson.action',
	    	data:{groupName:window.top.getName(),mobilePhone:phone,roleName:'副盟主'},
	    	success: function(res){	
	    		myGrid.cells(rId,js).setValue('副盟主');
	    		var ico = myGrid.cells(rId,2).cell;
	    		ico.removeChild(ico.children[4]);
				ico.append(addButton("removeAdmin(this)","layui-icon-group","取消副盟主"));
	    	}
       	});
	
	}
	//取消副盟主权限
	function removeAdmin(e){
		var phone = e.parentNode.parentNode.children[pointId].innerHTML;
		var rId = myGrid.getRowId((parseInt(e.parentNode.parentNode.children[0].innerHTML)-1)+'');
		
		$.ajax({
	    	type: 'POST',
	    	url: '/person/editperson.action',
	    	data:{groupName:window.top.getName(),mobilePhone:phone,roleName:'成员'},
	    	success: function(res){	
	    		myGrid.cells(rId,js).setValue('成员');
	    		var ico = myGrid.cells(rId,2).cell;
	    		ico.removeChild(ico.children[4]);
				ico.append(addButton("setAdmin(this)","layui-icon-user","设置副盟主"));
	    	}
       	});

	}
	//盟主转让
	function changeAdmin(e){
		dhtmlx.confirm({
		    title: "转让盟主",
		    type:"提示",
		    text: "是否确定转让盟主?",
		    cancel: '否',
		    ok: '是',
		    callback: function(h) {
		    	if(h){
		    		var phone1 = e.parentNode.parentNode.children[pointId].innerHTML;
		    		$.ajax({
	    		    	type: 'POST',
	    		    	url: '/person/editpersontable.action',
	    		    	data:{groupName:window.top.getName(),userId:window.top.getID(),data:{}}	    		    	
	    	       	});
					
					$.ajax({
	    		    	type: 'POST',
	    		    	url: '/person/editpersontable.action',
	    		    	data:{groupName:window.top.getName(),phone:phone1,data:{}}	    		    	
	    	       	});
		    		$.ajax({
				    	type: 'POST',
				    	url: '/person/editperson.action',
				    	data:{groupName:window.top.getName(),mobilePhone:phone1,roleName:'盟主'},
				    	
			       	});
					var phone = e.parentNode.parentNode.parentNode.children[dislist].children[pointId].innerHTML;
					$.ajax({
				    	type: 'POST',
				    	url: '/person/editperson.action',
				    	data:{groupName:window.top.getName(),mobilePhone:phone,roleName:'成员'},
				    	success: function(res){	
				    		top.location.reload();
				    	}
			       	});
					
		    	}
		    }
		});	
	}
	
	
	//添加按钮（按钮事件，按钮图标，按钮提示字）
	function addButton(a,b,c){
		var button = document.createElement("i");
		button.setAttribute("class","layui-icon "+b);
		button.setAttribute("style","margin-right:5px");
		button.setAttribute("onclick", a);
		button.innerHTML = '<cite style="display:none">'+c+'</cite>';
		return button;
		
	}
	
	
	function chooseAll(){
		$('#checkSelcet')[0].click();
		if(flag5){
			$('#chooseAllBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk1.gif";
			flag5 = false;
		}else{
			$('#chooseAllBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk0.gif";
			flag5 = true;
		}
	}
	
	

	//点击树事件
	tree.attachEvent("onClick", function(id){
		flag5=true;
		list2=[];
		flag4 =true;
		isPeople = false;
		var ids = '';
		selectId=0;
		treeId = id;
		tree.openItem(id);
		if(myTBar){
			myTBar.hideItem("disrevoke");
			myTBar.showItem("revoke");
		}
		
		
		//树的子节点
		function getChild(e){
			if(tree.getSubItems(e) =='')
				ids = ids + e +',';		
			if(tree.getSubItems(e) !=''){
				var a = tree.getSubItems(e).split(',');
				for(let i of a){
					getChild(i);
				}
			}
		}
		getChild(id);
		if(treeId == 1)
			ids += 1;
		else
		ids=ids.slice(0,ids.length-1);
		
		
		if(role == '盟主'||role == '副盟主'){
			//动态显示撤销反撤销
			$.ajax({
		    	type: 'POST',
		    	url: '/department/seldepartment.action',
		    	data:{groupID:window.top.getGroupID()},
		    	success: function(res){
		    		if(res.data[0].revokeDate){
		    			for(var i of $.parseJSON(res.data[0].revokeDate).data){	    			
		    				if(i.id == id){
		    					myTBar.hideItem("revoke");
		    					myTBar.showItem("disrevoke");
			    			}
		    				
		    			}
		    		}
		    	}
	       	});
		}
		
		if(role == '盟主'||role == '副盟主'){
			
			$.ajax({
		    	type: 'POST',
		    	url: '/person/selpersontable.action',
		    	data:{groupName:window.top.getName(),userId:window.top.getID()},
		    	success: function(res){
		    		if(res.data){
		    			if(res.data.data){
			    			myGrid.clearAll(true);
			    			var table = $.parseJSON(res.data.data);
			    			var arr1= table.head.split(',');
			    			var head = "序号,#master_checkbox,工具列,人员编号,工号,职员姓名,花名,部门名称,角色,审核,雇佣状态,手机号,办公电话,分机号,紧急联系人,紧急联系人电话,性别,岗位名称,邮箱,生日,到职日期,离职日期,备注,QQ,婚姻状况,地址,身份证号";	
			    			var arr2 = head.split(',');
			    			var arr3 = table.hide.split(',');
			    			var att = ',,,';
			    			var att2 = 'na,na,na';
			    			for(var i = 3;i<arr1.length;i++){		    				
			    				if(i == arr1 - 1){ 					
			    					if(arr1[i] == '雇佣状态' || arr1[i] =='性别'|| arr1[i] =='审核'||arr1[i] =='婚姻状况')
			    						att +='#select_filter';			
			    					else 
			    						att +='#text_filter';
			    					if(arr1[i] == '生日' ||arr1[i] == '到职日期'||arr1[i] == '离职日期')
			    						att2 +='date';
			    					else
			    						att2 += 'str';
			    				}
			    				else{
			    					if(arr1[i] == '雇佣状态' || arr1[i] =='性别'|| arr1[i] =='审核'||arr1[i] =='婚姻状况')
			    						att +='#select_filter,';
			    					else
			    						att +='#text_filter,';
			    					
			    					if(arr1[i] == '生日' ||arr1[i] == '到职日期'||arr1[i] == '离职日期')
			    						att2 +='date,';
			    					else
			    						att2 += 'str,';
			    				}
			    				
			    				
			    			}
			    			myGrid.attachHeader(att);
			    			myGrid.setHeader(table.head);
			    			myGrid.setInitWidths(table.width);
			    			myGrid.setColTypes(table.type);
			    			myGrid.setColSorting(att2);
			    			myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
			    			myGrid.init();
			    			$('.hdr')[0].children[0].children[2].style.display='none';
			    			$('.hdr')[0].children[0].children[1].children[1].children[0];
			    			$('.hdr')[0].children[0].children[1].children[1].children[0].children[0].style.cssText='width:15px;height:15px;background:#fff';
			    			
			    			//替换原始全选框
			    			$('.hdr')[0].children[0].children[1].children[1].children[0].children[0].setAttribute("id","checkSelcet");
							var img = document.createElement("img");
							img.setAttribute("id", "chooseAllBox");
							img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
							img.setAttribute("onclick", "chooseAll()");
							$('.hdr')[0].children[0].children[1].children[1].children[0].append(img);
			    			
			    			
			    			var array = new Array();

			    			for(let a = 0;a<arr2.length;a++){
			    				if(arr3[a] == 'true'){myGrid.setColumnHidden(a,true);}
			    				if(arr1[a] =='手机号'){pointId = a;}
			    				if(arr1[a] =='审核'){sh = a;}
			    				if(arr1[a] =='部门名称'){bm = a;}
			    				if(arr1[a] =='角色'){js = a;}
			    				if(arr1[a] =='审核'){sh = a;}
			    				if(arr1[a] =='雇佣状态'){gy = a;}
			    				if(arr1[a] =='到职日期'){dz = a;}
			    				if(arr1[a] =='离职日期'){lz = a;}
			    				if(arr1[a] =='人员编号'){bh = a;}
			    				if(arr1[a] =='工号'){gh = a;}
			    				if(arr1[a] =='办公电话'){bgdh = a;}
			    				if(arr1[a] =='分机号'){fjh = a;}
			    				if(arr1[a] =='岗位名称'){gwmc = a;}
			    				array[a] = arr2.indexOf(arr1[a]);	    				
			    			}
			    			
			    			
			    			
			    			$.ajax({
			    		    	type: 'POST',
			    		    	url: '/person/selperson.action',
			    		    	data:{groupName:window.top.getName(),depID:ids},
			    		    	success: function(res){
			    		    		if(res.msg == "查询成功"){
			    		    			list2.splice(0,list2.length);
			    		    			var person = res.data;
			    		    			var rows = new Array();
			    		    			var rows2 = new Array();
			    		    			
			    		    			for(var i=0;i<person.length;i++){
			    		    				var arr3= new Array();
			    		    				
			    		    				
			    		    				person[i].depName = tree.getItemText(person[i].depID);
			    		    				var arr = [null,null,null,person[i].personNumber,person[i].jobID,person[i].psnName,person[i].emName,person[i].depName,person[i].roleName
			    		    					,person[i].state,person[i].workState,person[i].mobilePhone,person[i].workPhone,person[i].otherPhone,person[i].sosName
			    		    					,person[i].sosPhone,person[i].sex,person[i].postName,person[i].email,person[i].birthday,person[i].workDate
			    		    					,person[i].leaveDate,person[i].signature,person[i].qq,person[i].marriage,person[i].address,person[i].identity];
			    		    				for(var j=0;j<array.length;j++){
			    		    					arr3[j] = arr[array[j]];		
			    		    				}
			    		    				var k = {id:i+1,data:arr3};
			    		    				
			    		    				
		    		    					if(person[i].workState == '离职'||person[i].state=='已拒绝'){
			    		    					list2.push(k);
			    		    				}else{
			    		    					rows2.push(person[i].userId);
			    		    					rows.push(k);
			    		    					isPeople = true;
			    		    				}	
			    		    			}

		    		    				if(flag2=='hide'){
		    		    					for(let t of list2)
		    		    						rows.push(t);
		    		    				}
			    		    			
			    		    			var data = {rows};
			    		    			myGrid.parse(data,"json");
			    		    			$('.hdr')[0].children[0].children[2].children[gy].children[0].children[0].options.add(new Option('离职','离职'));	
			    		    			
			    		    			 var count=myGrid.getRowsNum();
				  						   for(var i=0;i<count;i++){
				  							   myGrid.setRowId(i,"row"+i);						   
				  							   myGrid.setUserData("row"+i,"ID",rows2[i]);
				  						   }
			    		    			
			    		    			var tools = $('.obj')[0].children[0].childNodes;
			    		    			for(var i=1;i<tools.length;i++){
			    		    				
			    		    				tools[i].children[2].append(addButton("chat(this)","layui-icon-dialogue","沟通"));
			    		    				if(tools[i].children[9].innerHTML == '通过'){	    		    				
					    		    			if(role == '盟主'){		    		    				
						    		    				if(tools[i].children[js].innerHTML !='盟主'){
						    		    					if(tools[i].children[gy].innerHTML == '离职')
						    		    						tools[i].children[2].append(addButton("back(this)","layui-icon-addition","反注销"));
						    		    					else{
						    		    						tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
								    		    				tools[i].children[2].append(addButton("leave(this)","layui-icon-close","注销"));
								    		    				
								    		    				tools[i].children[2].append(addButton("changeAdmin(this)","layui-icon-username","盟主转让"));
								    		    				if(tools[i].children[js].innerHTML =='成员'){					    		    				
									    		    				tools[i].children[2].append(addButton("setAdmin(this)","layui-icon-user","设置副盟主"));
								    		    				}
								    		    				if(tools[i].children[js].innerHTML =='副盟主'){
									    		    				tools[i].children[2].append(addButton("removeAdmin(this)","layui-icon-group","取消副盟主"));
								    		    				}
						    		    					}

						    		    				}else{
						    		    					dislist = i;
						    		    					tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
						    		    				}		    		    				
					    		    			}
				    		    				else if(role=='副盟主'){
						    		    				if(tools[i].children[js].innerHTML !='盟主'){
						    		    					tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
							    		    				tools[i].children[2].append(addButton("leave(this)","layui-icon-close","注销"));
							    		    				
						    		    				}		    	
				    		    				}
			    		    				}
			    		    			}
			    		    			
			    		    			
			    		    			$(".layui-icon").mouseover(function(e) {
			    		    			    layer.tips(e.target.children[0].innerHTML, this, {
			    		    			      tips: [1, "#000"],
			    		    			      time: 1000
			    		    			    });
			    		    			});
			    		    			 colState(table.head,role);
			    		    			 editPerson();
			    		    			

			    		    		}
			    		    	}
			    		   	});
			    			
			    		}else{
			    			var att = ",,,#text_filter,#text_filter,#text_filter,#text_filter,#select_filter,#select_filter,#select_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#select_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#select_filter,#text_filter,#text_filter";
			    			myGrid.clearAll(true);
			    			var head = "序号,#master_checkbox,工具列,人员编号,工号,职员姓名,花名,部门名称,角色,审核,雇佣状态,手机号,办公电话,分机号,紧急联系人,紧急联系人电话,性别,岗位名称,邮箱,生日,到职日期,离职日期,备注,QQ,婚姻状况,地址,身份证号";	    
			    			myGrid.setHeader(head);			    			
			    			myGrid.setInitWidths("50,50,120,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,130,100,100,100,100,100,100,150,200");
			    			myGrid.setColTypes("cntr,ch,ro,ed,ed,ro,ro,ro,ro,ro,ro,ro,ed,ed,ro,ro,ro,ed,ro,ro,ro,ro,ro,ro,ro,ro,ro");
			    			myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
			    			myGrid.setColSorting("na,na,na,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,date,date,date,str,str,str,str,str");
			    			myGrid.attachHeader(att);
			    			myGrid.enableTooltips("false,true,false");
			    			myGrid.init();
			    			
			    			$('.hdr')[0].children[0].children[2].style.display='none';	    
			    			//替换原始全选框
			    			$('.hdr')[0].children[0].children[1].children[1].children[0].children[0].setAttribute("id","checkSelcet");
							var img = document.createElement("img");
							img.setAttribute("id", "chooseAllBox");
							img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
							img.setAttribute("onclick", "chooseAll()");
							$('.hdr')[0].children[0].children[1].children[1].children[0].append(img);
			
			    			pointId = 11;sh = 9;bm =7;js=8;gy=10;dz=20;lz=21;bh=3;gh=4;bgdh=12,fjh=13;gwmc=17;

			    			$.ajax({
			    		    	type: 'POST',
			    		    	url: '/person/selperson.action',
			    		    	data:{groupName:window.top.getName(),depID:ids},
			    		    	success: function(res){
			    		    		if(res.msg == "查询成功"){
			    		    			
			    		    			list2.splice(0,list2.length);
			    		    			var person = res.data;
			    		    			var rows = new Array();
			    		    			var rows2 = new Array();
			    		    			
			    		    			for(var i=0;i<person.length;i++){
			    		    				person[i].depName = tree.getItemText(person[i].depID);
			    		    				var arr = [null,null,null,person[i].personNumber,person[i].jobID,person[i].psnName,person[i].emName,person[i].depName,person[i].roleName
			    		    					,person[i].state,person[i].workState,person[i].mobilePhone,person[i].workPhone,person[i].otherPhone,person[i].sosName
			    		    					,person[i].sosPhone,person[i].sex,person[i].postName,person[i].email,person[i].birthday,person[i].workDate
			    		    					,person[i].leaveDate,person[i].signature,person[i].qq,person[i].marriage,person[i].address,person[i].identity];
			    		    				var j = {id:i+1,data:arr};
			    		    				if(person[i].workState == '离职'||person[i].state=='已拒绝'){
			    		    					list2.push({id:'lizhi'+i,data:arr});
			    		    				}else{
			    		    					rows2.push(person[i].userId);
			    		    					rows.push(j);
			    		    					isPeople = true;
			    		    				}
			    		    			}
			    		    			
			    		    			if(flag2=='hide'){
		    		    					for(let t of list2)
		    		    						rows.push(t);
		    		    				}
			    		    			
			    		    			var data = {rows};
			    		    			myGrid.parse(data,"json");
			    		    			
			    		    			$('.hdr')[0].children[0].children[2].children[9].children[0].children[0].options.add(new Option('离职','离职'));	
			    		    			
			    		    			var count=myGrid.getRowsNum();
			  						   for(var i=0;i<count;i++){
			  							   myGrid.setRowId(i,"row"+i);						   
			  							   myGrid.setUserData("row"+i,"ID",rows2[i]);
			  						   }
			    		    			
			    		    		
			    		    			var tools = $('.obj')[0].children[0].childNodes;
			    		    			for(var i=1;i<tools.length;i++){
			    		    				
			    		    				tools[i].children[2].append(addButton("chat(this)","layui-icon-dialogue","沟通"));
			    		    				if(tools[i].children[9].innerHTML == '通过'){	    		    				
					    		    			if(role == '盟主'){		    		    				
						    		    				if(tools[i].children[8].innerHTML !='盟主'){	
						    		    					if(tools[i].children[10].innerHTML == '离职')
						    		    						tools[i].children[2].append(addButton("back(this)","layui-icon-addition","反注销"));
						    		    					else{
						    		    						tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
								    		    				tools[i].children[2].append(addButton("leave(this)","layui-icon-close","注销"));
								    		    				
								    		    				tools[i].children[2].append(addButton("changeAdmin(this)","layui-icon-username","盟主转让"));
								    		    				if(tools[i].children[8].innerHTML =='成员'){					    		    				
									    		    				tools[i].children[2].append(addButton("setAdmin(this)","layui-icon-user","设置副盟主"));
								    		    				}
								    		    				if(tools[i].children[8].innerHTML =='副盟主'){
									    		    				tools[i].children[2].append(addButton("removeAdmin(this)","layui-icon-group","取消副盟主"));
								    		    				}
						    		    					}

						    		    				}else{
						    		    					dislist = i;
						    		    					tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
						    		    				}
						    		    						    		    				
					    		    			}
				    		    				else if(role=='副盟主'){
						    		    				if(tools[i].children[8].innerHTML !='盟主'){
						    		    					tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
							    		    				tools[i].children[2].append(addButton("leave(this)","layui-icon-close","注销"));
							    		    				
						    		    				}		    	
				    		    				}
			    		    				}
			    		    			}
			    		    			$(".layui-icon").mouseover(function(e) {
			    		    			    layer.tips(e.target.children[0].innerHTML, this, {
			    		    			      tips: [1, "#000"],
			    		    			      time: 1000
			    		    			    });
			    		    			});
			    		    			 colState(head,role);
			    		    			 
			    		    			 editPerson();
			    		    		
			    		    			 
	
			    		    	 	} 

			    		    	}
			    		   	});
			    		}
		    		}else{
		    			var att = ",,,#text_filter,#text_filter,#text_filter,#text_filter,#select_filter,#select_filter,#select_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#select_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#select_filter,#text_filter,#text_filter";
		    			myGrid.clearAll(true);
		    			var head = "序号,#master_checkbox,工具列,人员编号,工号,职员姓名,花名,部门名称,角色,审核,雇佣状态,手机号,办公电话,分机号,紧急联系人,紧急联系人电话,性别,岗位名称,邮箱,生日,到职日期,离职日期,备注,QQ,婚姻状况,地址,身份证号";	    
		    			myGrid.setHeader(head);			    			
		    			myGrid.setInitWidths("50,50,120,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,130,100,100,100,100,100,100,150,200");
		    			myGrid.setColTypes("cntr,ch,ro,ed,ed,ro,ro,ro,ro,ro,ro,ro,ed,ed,ro,ro,ro,ed,ro,ro,ro,ro,ro,ro,ro,ro,ro");
		    			myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
		    			myGrid.setColSorting("na,na,na,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,date,date,date,str,str,str,str,str");
		    			myGrid.attachHeader(att);	    			
		    			myGrid.enableTooltips("false,true,false");
		    			myGrid.init();
		    			
		    			$('.hdr')[0].children[0].children[2].style.display='none';	    
		    			//替换原始全选框
		    			$('.hdr')[0].children[0].children[1].children[1].children[0].children[0].setAttribute("id","checkSelcet");
						var img = document.createElement("img");
						img.setAttribute("id", "chooseAllBox");
						img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
						img.setAttribute("onclick", "chooseAll()");
						$('.hdr')[0].children[0].children[1].children[1].children[0].append(img);
		
		    			pointId = 11;sh = 9;bm =7;js=8;gy=10;dz=20;lz=21;bh=3;gh=4;bgdh=12,fjh=13;gwmc=17;

		    			$.ajax({
		    		    	type: 'POST',
		    		    	url: '/person/selperson.action',
		    		    	data:{groupName:window.top.getName(),depID:ids},
		    		    	success: function(res){
		    		    		if(res.msg == "查询成功"){
		    		    			
		    		    			list2.splice(0,list2.length);
		    		    			var person = res.data;
		    		    			var rows = new Array();
		    		    			
		    		    			for(var i=0;i<person.length;i++){
		    		    				person[i].depName = tree.getItemText(person[i].depID);
		    		    				var arr = [null,null,null,person[i].personNumber,person[i].jobID,person[i].psnName,person[i].emName,person[i].depName,person[i].roleName
		    		    					,person[i].state,person[i].workState,person[i].mobilePhone,person[i].workPhone,person[i].otherPhone,person[i].sosName
		    		    					,person[i].sosPhone,person[i].sex,person[i].postName,person[i].email,person[i].birthday,person[i].workDate
		    		    					,person[i].leaveDate,person[i].signature,person[i].qq,person[i].marriage,person[i].address,person[i].identity];
		    		    				var j = {id:i+1,data:arr};
		    		    				if(person[i].workState == '离职'||person[i].state=='已拒绝'){
		    		    					list2.push({id:'lizhi'+i,data:arr});
		    		    				}else{
		    		    					rows.push(j);
		    		    					isPeople = true;
		    		    				}
		    		    			}
		    		    			
		    		    			if(flag2=='hide'){
	    		    					for(let t of list2)
	    		    						rows.push(t);
	    		    				}
		    		    			
		    		    			var data = {rows};
		    		    			myGrid.parse(data,"json");
		    		    			
		    		    			$('.hdr')[0].children[0].children[2].children[9].children[0].children[0].options.add(new Option('离职','离职'));	
		    		    			
		    		    			
		    		    		
		    		    			var tools = $('.obj')[0].children[0].childNodes;
		    		    			for(var i=1;i<tools.length;i++){
		    		    				
		    		    				tools[i].children[2].append(addButton("chat(this)","layui-icon-dialogue","沟通"));
		    		    				if(tools[i].children[9].innerHTML == '通过'){	    		    				
				    		    			if(role == '盟主'){		    		    				
					    		    				if(tools[i].children[8].innerHTML !='盟主'){	
					    		    					if(tools[i].children[10].innerHTML == '离职')
					    		    						tools[i].children[2].append(addButton("back(this)","layui-icon-addition","反注销"));
					    		    					else{
					    		    						tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
							    		    				tools[i].children[2].append(addButton("leave(this)","layui-icon-close","注销"));
							    		    				
							    		    				tools[i].children[2].append(addButton("changeAdmin(this)","layui-icon-username","盟主转让"));
							    		    				if(tools[i].children[8].innerHTML =='成员'){					    		    				
								    		    				tools[i].children[2].append(addButton("setAdmin(this)","layui-icon-user","设置副盟主"));
							    		    				}
							    		    				if(tools[i].children[8].innerHTML =='副盟主'){
								    		    				tools[i].children[2].append(addButton("removeAdmin(this)","layui-icon-group","取消副盟主"));
							    		    				}
					    		    					}

					    		    				}else{
					    		    					dislist = i;
					    		    					tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
					    		    				}
					    		    						    		    				
				    		    			}
			    		    				else if(role=='副盟主'){
					    		    				if(tools[i].children[8].innerHTML !='盟主'){
					    		    					tools[i].children[2].append(addButton("change(this)","layui-icon-edit","调岗"));
						    		    				tools[i].children[2].append(addButton("leave(this)","layui-icon-close","注销"));
						    		    				
					    		    				}		    	
			    		    				}
		    		    				}
		    		    			}
		    		    			$(".layui-icon").mouseover(function(e) {
		    		    			    layer.tips(e.target.children[0].innerHTML, this, {
		    		    			      tips: [1, "#000"],
		    		    			      time: 1000
		    		    			    });
		    		    			});
		    		    			 colState(head,role);
		    		    			 
		    		    			 editPerson();
		    		    			 
		    		    			 
		    		    				
		    		    	 	} 

		    		    	}
		    		   	});
		    		}
		    		
		    	}
		   	});
		}else if(role == '成员'){
			$.ajax({
		    	type: 'POST',
		    	url: '/person/selpersontable.action',
		    	data:{groupName:window.top.getName(),userId:window.top.getID()},
		    	success: function(res){
		    		if(res.data.data){
		    			myGrid.clearAll(true);
		    			var table = $.parseJSON(res.data.data);
		    			var arr1= table.head.split(',');
		    			var head = "序号,人员编号,工号,花名,职员姓名,部门名称,角色,手机号,办公电话,分机号,岗位名称,邮箱";
		    			var arr2 = head.split(',');
		    			var att = ",,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter";

		    			myGrid.attachHeader(att);
		    			myGrid.setHeader(table.head);
		    			myGrid.setInitWidths(table.width);
		    			myGrid.setColTypes(table.type);
		    			myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center");
		    			myGrid.setColSorting("na,str,str,str,str,str,str,str,str,str,str,str");
		    			myGrid.init();
		    			$('.hdr')[0].children[0].children[2].style.display='none';
		    			
		    			colState(table.head,role);
		    			var array = new Array();
		    	
		    			for(let a = 0;a<arr2.length;a++){
		    				array[a] = arr2.indexOf(arr1[a]);	    				
		    			}
		    			
		    			
		    			
		    			$.ajax({
		    		    	type: 'POST',
		    		    	url: '/person/selperson.action',
		    		    	data:{groupName:window.top.getName(),depID:ids},
		    		    	success: function(res){
		    		    		if(res.msg == "查询成功"){
		    		    			
		    		    			var person = res.data;
		    		    			var rows = new Array();
		    		    			for(var i=0;i<person.length;i++){
		    		    				var arr3= new Array();
		    		    				person[i].depName = tree.getItemText(person[i].depID);
		    		    					
		    		    				var arr = [null,person[i].personNumber,person[i].jobID,person[i].emName,person[i].psnName,person[i].depName
		    		    					,person[i].roleName,person[i].mobilePhone,person[i].workPhone,person[i].otherPhone,person[i].postName,person[i].email];
		    		    				for(var j=0;j<array.length;j++){
		    		    					arr3[j] = arr[array[j]];		
		    		    				}
		    		    				var k = {id:i+1,data:arr3};
		    		    				if(person[i].workState == '在职')
		    		    				rows.push(k);
		    		    			}
		    		    			var data = {rows};
		    		    			myGrid.parse(data,"json");
	
		    		    		}
		    		    	}
		    		   	});
		    			
		    		}else{
		    			var att = ",,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter";
		    			myGrid.clearAll(true);
		    			var head = "序号,工具列,人员编号,工号,花名,职员姓名,部门名称,角色,手机号,办公电话,分机号,岗位名称,邮箱";	    
		    			myGrid.setHeader(head);	
		    			myGrid.setInitWidths("50,50,100,100,100,100,100,100,100,100,100,100,100");
		    			myGrid.setColTypes("cntr,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
		    			myGrid.setColAlign("center,crnter,center,center,center,center,center,center,center,center,center,center,center");
		    			myGrid.setColSorting("na,,str,str,str,str,str,str,str,str,str,str,str");
		    			myGrid.attachHeader(att);	    			
		    			myGrid.init();
		    			
		    			$('.hdr')[0].children[0].children[2].style.display='none';
		    			
		    			colState(head,role);
		    			
		    			$.ajax({
		    		    	type: 'POST',
		    		    	url: '/person/selperson.action',
		    		    	data:{groupName:window.top.getName(),depID:ids},
		    		    	success: function(res){
		    		    		if(res.msg == "查询成功"){
		    		    			var person = res.data;
		    		    			var rows = new Array();
		    		    			
		    		    			for(var i=0;i<person.length;i++){		    		    				
		    		    					
		    		    				person[i].depName = tree.getItemText(person[i].depID);
		    		    				var arr = [null,null,person[i].personNumber,person[i].jobID,person[i].emName,person[i].psnName,person[i].depName
		    		    					,person[i].roleName,person[i].mobilePhone,person[i].workPhone,person[i].otherPhone,person[i].postName,person[i].email];
		    		    				var j = {id:i+1,data:arr};
		    		    				if(person[i].workState == '在职')
		    		    				rows.push(j);
		    		    			}
		    		    			var data = {rows};
		    		    			myGrid.parse(data,"json");
		    		    			
		    		    			
		    		    			var tools = $('.obj')[0].children[0].childNodes;
		    		    			for(var i=1;i<tools.length;i++)
		    		    			tools[i].children[1].append(addButton("chat(this)","layui-icon-dialogue","沟通"));
		    		    		}
		    		    	}
		    		   	});
		    		}
		    	}
		   	});
		}
	
	
		showTip();
		
		//列隐藏和显示
		function  colState(e,h){
			var td = $('.hdr')[0].children[0].children[1].children;
			var head = e.split(',');
			var data = new Array();
			
    		for(var i=0;i<td.length;i++){		
    			td[i].onmousedown = function(e){
    				if(e.button ==2){
    					data = [];
    					data.push({type: "label", label: "隐藏/显示"});
        				for(var j = 3;j<head.length;j++){	
        	    				var q = myGrid.isColumnHidden(j);
        	    				var l = {type: "checkbox", label: head[j], checked:!q, name: j,position:"label-right"};
        	        			data.push(l);	
        				}
    					if(myPop)
    					myPop.unload();
					    myPop = new dhtmlXPopup();	
					    var myForm = myPop.attachForm(data);
					    if(role=='盟主'||role=='副盟主'){
					   		myPop.show(e.x-110,0,150,300);
					   		$('.dhx_popup_dhx_terrace')[0].style.top='120px';
					   		
					    }
					    else{
					    	myPop.show(e.x+20,-135,150,250);
					    	
					    }
					   $('.dhx_popup_arrow')[0].style.display='none';
					   $('.dhx_popup_td')[0].children[0].style.height='250px';
					   $('.dhx_popup_td')[0].children[0].style.width='120px';
					   $('.dhx_popup_td')[0].children[0].style.overflowY='scroll';
					    myForm.attachEvent("onChange", function (name, value, state){
					        var num;
					        for(var i =3;i<td.length;i++){
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
		
		
		
		
		//修改表格信息
		function editPerson(){			
    		myGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue){
    		    if(stage == 2){
    		    	if(nValue != oValue){   		    		
    		    			var a,b;
        		    		var tools = $('.obj')[0].children[0].childNodes;
        		    		var head = $('.hdr')[0].children[0].children[1].children[cInd].children[0].innerHTML;
        		    		var i = myGrid.getRowIndex(rId) + 1;
        		    		var phone = tools[i].children[pointId].innerHTML;
        		    		if(head =='人员编号'){a ='personNumber';b = nValue;
	        		    		for(var j=1;j< tools.length;j++){
	        		    			if(i!=j){
	        		    				if(tools[j].children[bh].innerHTML !='&nbsp;')
	        		    					if(tools[j].children[bh].innerHTML == nValue){
	        		    						dhtmlx.alert('人员编号不能重复');
	        		    						return false;
	        		    					}	        		    					
	        		    			}
	        		    		}
        		    		}
        		    		if(head =='工号'){a ='jobID';b=nValue;
	        		    		for(var k=1;k< tools.length;k++){
	        		    			if(i!=k){
	        		    				if(tools[k].children[gh].innerHTML !='&nbsp;')
	        		    					if(tools[k].children[gh].innerHTML == nValue){
	        		    						dhtmlx.alert('工号不能重复');
	        		    						return false;
	        		    					}	        		    					
	        		    			}
	        		    		}
        		    		}
        		    		if(head =='办公电话'){a ='workPhone';b=nValue;}
        		    		if(head =='分机号'){a='otherPhoen';b=nValue;}
        		    		if(head =='岗位名称'){a='postName';b=nValue;}
        		    		$.ajax({
        				    	type: 'POST',
        				    	url: '/person/editperson.action?'+a+'='+b,
        				    	data:{groupName:window.top.getName(),mobilePhone:phone}		    	
        			       	});
        		    		return true;
    		    	}else return false;
    		    }else return true;
    		});
		}
		
	});
	
	function showTip(){
		layui.use('layer',function(){
			 var tips;
	            $('.layui-icon').on({
	                mouseenter:function(){
	                	var text = this.children[0].innerHTML;
	                    var that = this;
	                    tips =layer.tips(text,that,{tips:[2],time:0,area: 'auto'});
	                },
	                mouseleave:function(){
	                    layer.close(tips);
	                }
	            });
		 })
	}
	
</script>

</body>
</html>