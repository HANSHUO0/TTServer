<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>客户档案</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/layuiadmin/layui/css/layui.css" media="all">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/layuiadmin/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
<script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
<script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
<style>
   html, body {
       width: 99%;     
       height: 100%;      
       margin: 0px;      
   }
   input[type="checkbox"] {
   	 	display:none;
	}
	a:link{color:red;}

	a:visited{color:black;}
	
	a:hover{color:blue;}
	
	a:active{color:#ccc;}
</style>

</head>

<body>

	<div style="line-height:60px;height:60px">
		<span style="font-size:x-large;margin-left:30px;">客户档案管理</span>
	</div>

	<div id="gridbox" style="margin-left:10px;width:100%;height:calc(100% - 100px)"></div>

<script type="text/javascript">
		var flag = true,flag2 = true,h,myPop,layout,myGrid,htmls=''; 
		var aa = localStorage.isSelect;
		
		var myLayout = new dhtmlXLayoutObject("gridbox", "1C");
		myLayout.cells("a").hideHeader();
		

	
		
		if(aa){
			localStorage.removeItem('isSelect');	
		}else{
			 htmls = '<div>'+
				'<button type="button" id="save" class="layui-btn-radius layui-btn-primary  layui-btn-xs " style="margin-left:10px;">'+
			  	'<i class="layui-icon" style="color:#009688;">&#x1005;</i> 格式保存</button>'+
				'<button type="button" id="add" class="layui-btn-radius layui-btn-primary  layui-btn-xs " style="margin-left:10px;">'+
			  	'<i class="layui-icon" style="color:#1E9FFF;">&#xe654;</i> 档案新建</button>'+
				'<button type="button" id="delete" class="layui-btn-radius layui-btn-primary  layui-btn-xs " style="margin-left:10px;">'+
			  	'<i class="layui-icon" style="color:#FF5722;">&#xe640;</i> 删除</button>'+
				'<button type="button" id="impot" class="layui-btn-radius layui-btn-primary  layui-btn-xs " style="margin-left:10px;">'+
			  	'<i class="layui-icon" style="color:#009688;">&#xe601;</i> 导入</button>	</div>';
		}
		
		
	   $.ajax({
		   type: 'POST',
		   url: '/design/seldesign3.action',
		   data: {DesignName:"设计客户档案管理"},
		   success: function(res){	
			   var data = JSON.parse(res[0].design);	
			   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);
			   layout.lays[0].cells("b").setText('<div type="button" style="width:20px;height:20px;margin-top:4px;"><img id="chooseBox" onclick="choose()" src="../DHX/imgs/dhxgrid_terrace/item_chk0.gif" style="margin-bottom:10px"></div>筛选'+htmls);
			   $('.dhx_cell_hdr_text')[1].children[0].style.fontSize = '17px';
			   $('.dhx_cell_hdr_text')[2].children[0].style.fontSize = '17px';
			   $('.dhx_cell_hdr_text')[2].children[0].style.display = 'flex';
			   
			   var width = layout.lays[0].cells("b").cell.clientWidth||layout.lays[0].cells("b").cell.offsetWidth;
				width -= 1;
				var height = layout.lays[0].cells("b").cell.children[1].clientHeight||layout.lays[0].cells("b").cell.children[1].offsetHeight;
				
				var tabbar = layout.lays[0].cells("b");
				var tools = layout.lays[0].cells("a").getAttachedToolbar();
				var mytree = layout.lays[0].cells("a").attachTree();
				mytree.setImagePath("../DHX/imgs/dhxtree_terrace/");
				myGrid = layout.lays[0].cells("b").getAttachedObject();
				myGrid.setImagesPath("../DHX/imgs/");
				var rowID=myGrid.getRowId(0);
				myGrid.deleteRow(rowID);
				changeWidth(layout.lays[0]);
				
				$.ajax({
			    	type: 'POST',
			    	url: '/customer/selcustomerclass.action',
			    	data:{groupName:window.top.getName(),selectID:'cCCCode'},
			    	success: function(res){
			    		if(res.data){
			    			mytree.parse($.parseJSON(res.data[0].listData),"json");
			    		}else{
			    			mytree.insertNewChild(0,1,'客户分类');
			    		}
			    	}
		      	});
				
				tools.attachEvent("onClick", function(id){
				    if(id == 'edittree'){
				    	CustomerSelect('cCCCode');
				    }
				   
				});
				var curPage = Number(tabbar.myToolbar.getItemText("pageIndex").replace(/[^0-9]/ig,""));
				var pageSize = Number(tabbar.myToolbar.getItemText("pageSize").replace(/[^0-9]/ig,""));
				createGrid(myGrid,null,res,tabbar,(curPage-1)*pageSize,pageSize);
				
				tabbar.myToolbar.attachEvent("onClick", function(e){
					  if(e != 'output-1'&& e!='output-2'&&e != 'print'){
						  curPage = Number(tabbar.myToolbar.getItemText("pageIndex").replace(/[^0-9]/ig,""));
						   pageSize = Number(tabbar.myToolbar.getItemText("pageSize").replace(/[^0-9]/ig,""));
						   myGrid.clearAll(false);
						   createGrid(myGrid,null,res,tabbar,(curPage-1)*pageSize,pageSize); 
					  } 
				   });
				
				//点击树事件
				mytree.attachEvent("onClick", function(id){
					flag2=true;
					var ids= '';
					//树的子节点
					function getChild(e){
						if(mytree.getSubItems(e) ==''){
							var name = mytree.getItemText(e);			
							ids = ids + name.split(']')[1] +',';		
						}
						if(mytree.getSubItems(e) !=''){
							if(e != '1'){
								var name = mytree.getItemText(e);
								ids = ids + name.split(']')[1] +',';					
							}
							var a = mytree.getSubItems(e).split(',');
							for(let i of a){
								getChild(i);
							}
						}
					}
					getChild(id);
					ids = ids.slice(0,ids.length-1);
					myGrid.clearAll();
					curPage = Number(tabbar.myToolbar.getItemText("pageIndex").replace(/[^0-9]/ig,""));
					pageSize = Number(tabbar.myToolbar.getItemText("pageSize").replace(/[^0-9]/ig,""));
					createGrid(myGrid,ids,res,tabbar,(curPage-1)*pageSize,pageSize);
					
					tabbar.myToolbar.attachEvent("onClick", function(e){
						  if(e != 'output-1'&& e!='output-2'&&e != 'print'){
							  curPage = Number(tabbar.myToolbar.getItemText("pageIndex").replace(/[^0-9]/ig,""));
							   pageSize = Number(tabbar.myToolbar.getItemText("pageSize").replace(/[^0-9]/ig,""));
							   myGrid.clearAll(false);
							   createGrid(myGrid,ids,res,tabbar,(curPage-1)*pageSize,pageSize); 
						  } 
					   });
					
				})
					$('#delete').click(function (){						
						var ids = myGrid.getCheckedRows(1);
						if(ids!=''){
							var w1 = dhtmlx.showDialog({
					            caption: '选择是否删除',
					            width: 250,
					            height: 150,
					            modal: true
					        });
							w1.layout.cells("a").dataNodes.toolbar.cont.children[1].children[0].style.display="none";
							w1.layout.cells("a").dataNodes.toolbar.cont.children[1].children[1].style.display="none";
							var lay = w1.layout.cells("a");
							var myForm = lay.attachForm([{type: "button", name: "yes", value: "删除",offsetLeft:30,offsetTop:20},{type: "newcolumn"},{type: "button", name: "no", value: "取消",offsetLeft:30,offsetTop:20}]);
							
							myForm.attachEvent("onButtonClick", function(name){
							    if(name == 'yes'){
							    	var arr = new Array();
							    	for (var id of ids.split(',')){
							    		var data = myGrid.getRowData(id);
										arr.push(data.cCusCode);	
										myGrid.deleteRow(id);
									}
							    	$.ajax({
										   type: 'POST',
										   url: '/customer/delcustomer.action',
										   traditional:true,
										   data: {ids:arr},
										   success: function(){											   
											   w1.close();
										   }
							    	})
							    	 
							    }
							    if(name == 'no'){
							    	 w1.close();
							    }
							});
						
						}
					})
					$('#add').click(function (){
						window.top.document.getElementById('9').click();
					})
					$('#impot').click(function (){
						   var w1 = dhtmlx.showDialog({
				            caption: '选择模板',
				            width: 600,
				            height: 400   
				      });
						  var lay = w1.layout.cells("a");
						  
						  
						  
						  $.ajax({
							   type: 'POST',
							   url: '/design/seldesign3.action',
							   data: {DesignName:"设计上传下载"},
							   success: function(res){		
								   var data = JSON.parse(res[0].design);
								   var layout2 = dhtmlx.layout(data,lay,res[0].designName);
								   var Tabbar = layout2.lays[0].cells("a").getAttachedObject();
								   
								   var html = '<form id="loadbox" action="/upload/uploadexcel.action" method="POST" enctype="multipart/form-data">'+
								   '<input type="file" id="load_xls" name="file" style="margin-top:30px;margin-left:30px;"></form>'+
								   '<div style="height:50px"><button id="inload" style="margin-left:30px;margin-top:20px;height:25px;width:70px">导入</button></div>'+
								   '<div id="errbox" style="margin-left:30px;line-height: 150px;display:flex"><p>处理结果:</p>'+
								   '<textarea  id="errText" maxlength="255" readonly style="border:0px;width:400px;height:100px;margin-left:20px;margin-top:65px"></textarea></div>'
								
								   var div = document.createElement("div");							       							       				       
							       div.innerHTML = html;
								 						      				       
							      
							       Tabbar.tabs("a0").attachObject(div);
							       							
							       $('#inload')[0].onclick = function (){
							    	   var formData = new FormData();
								        formData.append("excelFile", $("#load_xls")[0].files[0]);
								        formData.append("groupName",window.top.getName());
								        if($("#load_xls")[0].files[0].size>=10000000){
								        	 $("#errText")[0].value = '文件不能大于10MB';
								        }else{
								        	$.ajax({
									             url: "/upload/uploadexcel.action",
									             data: formData,
									             type: "post",
									             processData: false,
									             contentType: false,
									             success: function(res) {
									                 if(res.result == '导入成功')	                	
									                	 location.reload();
									                 if(res.result == '文件类型错误')
									                	 $("#errText")[0].value = '文件类型错误';
									             },
									             error: function(e) {
									            	 if(e.responseJSON.message == "Required request part 'excelFile' is not present"){
									            		 $("#errText")[0].value = '未选择文件'; 
									            	 }
									            	 var message = $.parseJSON(e.responseText).message.split("### Cause:")[1];
									            	 var cod = message.split('Duplicate entry')[1].split('for key')[0];
									            	 $("#errText")[0].value = '字段'+cod +'重复，修改后重新导入';
									            	 
									             }
									         });
								        }
							       }
							       
							       
							       var html2 = '<div style="height:100%;width:50%;display:inline-block;vertical-align:top;">'+
							       '<div style="margin-top:15px"><a id="linkModel" style="margin-left:50px;" fileName= "customerModel.xlsx">客户档案模板.xlsx</a></div>'+					       
							       '</div>'+
							       '<div style="height:100%;width:50%;display:inline-block;vertical-align:top"></div>';
							    	   
							       var div2 = document.createElement("div");
							       div2.setAttribute("style","height:100%;width:100%;");
							       div2.innerHTML = html2;
							       Tabbar.tabs("a1").attachObject(div2);
							       
							      var link = document.getElementById("linkModel");
							      link.addEventListener("click", function(e){
							    	  window.open("${pageContext.request.contextPath}/excel/customerModel.xlsx?fileName="+e.target.innerHTML);					    	 
							      });
							       
							   }
						  })
						  
						   var tool = lay.getAttachedToolbar();
						   tool.removeItem("save");
						   	  
					})
	
		   }
		});
		
	   
	   
	   function CustomerSelect(n){
			 
		   var mytree;
		   var w1 = dhtmlx.showDialog({
	            caption: '选择客户分类',
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
		    		    			 location.reload();
	    		    			}
	    		    		}else{
	    		    			$.ajax({
	    		    		    	type: 'POST',
	    		    		    	url: '/customer/addcustomerclass.action',
	    		    		    	data:{groupName:window.top.getName(),selectID:n,listData:testJson}
	    		    	      	});
	    		    			 location.reload();
	    		    		}
	    		    	}
	    	      	});
	            	
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
				   var mylayout = dhtmlx.layout(data,lay,res[0].designName);
				   mytree = sameTree(mylayout,n,tool,'客户分类');
			   }
			});
		 
	 }
	  
	   
	   function sameTree(mylayout,n,tool,title){
		 var mytree = mylayout.lays[0].cells("a").attachTree();
		 mytree.setImagePath("../DHX/imgs/dhxtree_terrace/");
		 mytree.enableDragAndDrop(true);		    		
  		 mytree.setDragBehavior("complex");
  		 mytree.enableItemEditor(true);
  		 
  		 
			 //阻止组织树枝移出树根
  		 mytree.attachEvent("onDrop", function(sId, tId, id, sObject, tObject){		    				
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
  				    	mytree.deleteItem(1,true);
  				    	mytree.deleteItem(sId,true);
  				    	mytree.parse(data,"json");
  				    	mytree.openAllItems(1);
  				    }
  				}
  			    
  			});
			 
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
			
			
			
			
		   tool.attachEvent("onClick", function(id){
			   if(id == 'add'){						    
				    var treeId = mytree.getSelectedItemId();
					if(treeId ==''){
						treeId = 1;
					}
						var cid = $("input[name='cCCid']")[0].value;
						var name = '['+ cid +']'+$("input[name='cCCidName']")[0].value;
						if(mytree.findItemIdByLabel(name,0,null)){
							dhtmlx.alert('分类已添加');
						}
						else{							
							mytree.insertNewChild(treeId,window.top.getGuid(),name);
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
			   
		   });
		   
		   var midName;
		   mytree.attachEvent("onEdit", function(state, id, tree, value){
			    if(state == 0){
			    	midName = value;
			    }					    
			    if(state == 2){
			    	if(value != midName){	    		
			    		return true;
			    	}else
			    		return false;
			    }
			    return true;
			});
		   
		   return mytree;
		 }
	   
	   
	   
	   function changeWidth(layout){
			 window.onresize = function(){				
				 var a = $('#gridbox')[0].clientWidth||$('#gridbox')[0].offsetWidth;
				   layout.cont.parentNode.parentNode.style.width = '100%';
				   layout.cont.parentNode.parentNode.parentNode.style.width = '100%';
				   layout.cont.parentNode.parentNode.parentNode.parentNode.style.width = '100%';
				   layout.cont.style.width = '100%';
				   layout.cont.parentNode.parentNode.style.height = '100%';
				   layout.cont.parentNode.parentNode.parentNode.style.height = '100%';
				   layout.cont.parentNode.parentNode.parentNode.parentNode.style.height = '100%';
				   layout.cont.style.height = '100%';
				   layout.cont.children[1].style.width = 'calc(100% - 205px)';
				   layout.cont.children[1].children[0].style.width = 'calc(100% - 7px)';
				   layout.cont.children[0].style.height = '100%';
				   layout.cont.children[0].children[1].style.height = 'calc(100% - 36px)';
				   layout.cont.children[1].style.height = '100%';
				   layout.cont.children[1].children[1].style.width = 'calc(100% - 7px)';
				   layout.cont.children[1].children[1].style.height = 'calc(100% - 60px)';
				   $('#pagingbox')[0].style.width = a-212+'px';
			   }
		 }
			
	   function createGrid(myGrid,n,res,tabbar,curPage,pageSize){
					  var a='',att ='',ids='';
					  var data = $.parseJSON(res[0].design);				
					  for(var i of data.Context[0].Columns){
						  if(i.Label != '序号' &&i.Label != '#master_checkbox'){
							  if(i.Label == '归属部门'||i.Label == '客户分类'||i.Label == '客户等级')
									att = att + '#select_filter,';
								else 
									att = att + '#text_filter,';
							  a = a + i.Label + ','; 
							  ids = ids + i.Name +',';
						  }						  													  
					  }
					 
					  a = '序号,#master_checkbox,' + a;
					  a = a.slice(0,a.length-1);
					  ids = ',,'+ids.slice(0,ids.length-1);
					  att = ',,'+att.slice(0,att.length-1);

						//数据列拖拽
						myGrid.enableColumnMove(true);
						if(n==null){
							myGrid.attachHeader(att);
						}
						
					 	

						colState(a,null);
						
						if(n==null){
							if(flag){
								$('.hdr')[0].children[0].children[2].style.display='none';
								$('.hdr')[0].children[0].children[1].children[1].children[0].children[0].setAttribute("id","checkSelcet");
								var img = document.createElement("img");
								img.setAttribute("id", "chooseAllBox");
								img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
								img.setAttribute("onclick", "chooseAll()");
								$('.hdr')[0].children[0].children[1].children[1].children[0].append(img);
								
							}
						}
						
							//0,1,2列不允许拖动,不允许把列移动到0,1,2列
							myGrid.attachEvent("onBeforeCMove", function(cInd,posInd){
								if(cInd == 0 ||cInd == 1)return false;
								else if(posInd== 0 ||posInd == 1)return false;
								else return true;
								
							});
						
						$.ajax({
							   type: 'POST',
							   url: '/customer/selcustomer.action',
							   data: {groupName:window.top.getName(),cCCCode:n},
							   success: function(res){
								   var array = new Array();
								   var a = ids.split(',');
								   var sum = res.data.length;
								   for(var j=0;j<res.data.length;j++){
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
								   var count=myGrid.getRowsNum();
								   for(var i=0;i<count;i++){
									   myGrid.setRowId(i,"row"+i);
									   myGrid.setUserData("row"+i,"ID",res.data[i].id);
								   }
								  
								   curPage = curPage?curPage:0;
								   tabbar.myToolbar.setItemText("textCell","当前："+curPage+"-"+(curPage+count)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;总数："+res.count);
								   tabbar.totalCount = count;
								  
								   
								   myGrid.attachEvent("onRowSelect", function(id,ind){
									   localStorage.removeItem('customerSelect');
									   var data = myGrid.getRowData(id);
									   localStorage.customerSelect = JSON.stringify(data);
									});
								   
								   
								   
								   if(!aa){
									   myGrid.attachEvent("onRowDblClicked", function(rId,cInd){
									       var data = myGrid.getRowData(rId);
									       localStorage.infos = JSON.stringify(data);
									       localStorage.customerID = myGrid.getUserData(rId,"ID");
									       //添加iframe标签
									       var body = document.getElementsByTagName("body");
									       if($("#editCustomer").length<1){
									    	   var div = document.createElement("div");
										       div.setAttribute("id","editCustomer");
										       div.setAttribute("style","width:100%;height:100%; position:absolute;left:0;top:0;");
										       div.innerHTML = '<iframe id="idFrame" name="idFrame" src="/view/toeditcustomermessage.action" height = "100%" width = "100%" frameborder="0" scrolling="auto"></iframe>';
										       document.body.appendChild(div);
									       }else{
									    	   $("#editCustomer")[0].parentNode.removeChild($("#editCustomer")[0]);
									    	   var div = document.createElement("div");
										       div.setAttribute("id","editCustomer");
										       div.setAttribute("style","width:100%;height:100%; position:absolute;left:0;top:0;");
										       div.innerHTML = '<iframe id="idFrame" name="idFrame" src="/view/toeditcustomermessage.action" height = "100%" width = "100%" frameborder="0" scrolling="auto"></iframe>';
										       document.body.appendChild(div);
									       }  
									   });
								   }else{
									   myGrid.setColumnHidden(1,true);
									   myGrid.attachEvent("onRowDblClicked", function(rId,cInd){
										   var data = myGrid.getRowData(rId);
										   localStorage.removeItem('customerSelect');										   
										   window.parent.$("input[name='cCusName']")[0].parentNode.children[0].value = data.cCusName;										   									   
										   window.parent.$("input[name='states']")[0].value = data.cStatus;										   
										   window.parent.$("input[name='cusVIP']")[0].value = data.cCusVIP;
										 
										   $.ajax({
											   type: 'POST',
											   url: '/customer/selcustomer.action',
											   data: {groupName:window.top.getName(),cCusCode:data.cCusCode},
											   success: function(r){
												   localStorage.customerID = r.data[0].id;
												 
												   $.ajax({
													   type: 'POST',
													   url: '/customer/selcustomereffective.action',
													   data: {groupID:window.top.getGroupID(),cCusCode:r.data[0].id},
													   success: function(res){
														   window.parent.$("select[name='product']")[0].innerHTML='';
														   window.parent.$("input[name='serialNumber']")[0].value = '';
														   window.parent.$("input[name='endDate']")[0].value = '';
														   window.parent.$("input[name='phone']")[0].value = '';
														   window.parent.$("input[name='position']")[0].value = '';
														   window.parent.$("input[name='dep']")[0].value = '';
														   window.parent.$("input[name='address']")[0].parentNode.children[0].value = '';
														   window.parent.$("input[name='cContact']")[0].parentNode.children[0].value = '';
														   if(res.length !=0){
															  for(var i of res){
																  window.parent.$("select[name='product']")[0].options.add(new Option(i.cProductName,i.cid+','+i.cEndDate));
															  }
															  window.parent.$("input[name='serialNumber']")[0].value = res[0].cid;
															  window.parent.$("input[name='endDate']")[0].value = res[0].cEndDate;
															  
														   } 
														   $.ajax({
															   type: 'POST',
															   url: '/customer/selcustomerpeople.action',
															   data: {groupID:window.top.getGroupID(),cCusCode:r.data[0].id},
															   success: function(res){
																   if(res.length!=0){
																	   window.parent.$("input[name='cContact']")[0].parentNode.children[0].value = res[0].cName;
																	   window.parent.$("input[name='phone']")[0].value = res[0].cMoblePhone;
																	   window.parent.$("input[name='position']")[0].value = res[0].cPost;
																	   window.parent.$("input[name='dep']")[0].value = res[0].cDep;
																   }
															   }
														   })
											            	$.ajax({
																   type: 'POST',
																   url: '/customer/selcustomeraddress.action',
																   data: {groupID:window.top.getGroupID(),cCusCode:r.data[0].id},
																   success: function(res){
																	   if(res.length!=0){
																		   window.parent.$("input[name='address']")[0].parentNode.children[0].value = res[0].cCusAddress;										  
																	   }
																   }
											            	})
											            	
												            var intervalId = setInterval(function () {
												            	 window.parent.$(".dhxwins_mcover")[0].remove();
																 window.parent.$(".dhxwin_active")[0].remove();  
															    clearInterval(intervalId);
															}, 200);
														  
										            															   
													   }
													});
												   
											   }
										   })

									   });
								   }
							   }
						 })

		}
	   
		//列隐藏和显示
		function  colState(e,h){
			var td = $('.hdr')[0].children[0].children[1].children;
			var head = e.split(',');
			var data = new Array();
			
	   		for(var i=0;i<td.length;i++){		
	   			td[i].onmousedown = function(e){
	   				if(e.button == 2){
	   					data = [];
	   					data.push({type: "label", label: "隐藏/显示"});
	       				for(var j = 4;j<head.length;j++){	
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
						        for(var i =2;i<td.length;i++){
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
		
		
		
		function chooseAll(){
			$('#checkSelcet')[0].click();
			if(flag2){
				$('#chooseAllBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk1.gif";
				flag2 = false;
			}else{
				$('#chooseAllBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk0.gif";
				flag2 = true;
			}
		}
		function choose(){
			var hdr = $('.hdr')[0].children[0];
			var table = hdr.children[2];
			var xhdr = $('.xhdr')[0];		
			if(flag){
				table.style.display = '';
				xhdr.style.height = hdr.offsetHeight+'px';
				h = table.offsetHeight;
				$('.objbox')[0].style.height = parseInt($('.objbox')[0].style.height) - h +'px';
				$('#chooseBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk1.gif";
				flag = false;
			}else{
				table.style.display = 'none';
				xhdr.style.height = hdr.offsetHeight+'px';
				$('.objbox')[0].style.height = parseInt($('.objbox')[0].style.height) + h +'px';
				$('#chooseBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk0.gif";
				flag = true;
			}
			
		}
</script>

</body>
</html>