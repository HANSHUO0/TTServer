<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>服务派发</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
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
		<span style="font-size:x-large;margin-left:30px;">工单派发</span>
	</div>
	<div id="gridbox" style="margin-left:20px;width:calc(100% - 40px);height:calc(100% - 100px)"></div>
<script type="text/javascript">

    	var flag = true,flag2 = true,layout,layouts,myGrid,myPop,myToolbar;
		var myLayout = new dhtmlXLayoutObject("gridbox", "1C");
		myLayout.cells("a").hideHeader();
		
		
		
	   $.ajax({
		   type: 'POST',
		   url: '/design/seldesign3.action',
		   data: {DesignName:"设计工单派发"},
		   success: function(res){		
			   var data = JSON.parse(res[0].design);
			   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);		
			   
			   
			   changeWidth(layout);
			   
			   myGrid = layout.lays[0].cells("a").getAttachedObject();
			   myGrid.setImagesPath("../DHX/imgs/");
			   var rowID=myGrid.getRowId(0);
			   myGrid.deleteRow(rowID);
			   
			   myToolbar = layout.lays[0].cells("a").TBar;
			   myToolbar.attachEvent("onClick", function(id){
				    if(id == 'sendSomebody'){
				    	if(myGrid.getCheckedRows(1)!=''){
				    		sendView(myGrid.getCheckedRows(1));
				    	}else{
				    		dhtmlx.alert('复选框未勾选!');
				    	}
				    }
				    if(id == 'show'){
				    	choose();
				    }
				});
			  
			   myToolbar.base.children[0].style.background='#ffffff';
			   myToolbar.base.children[0].style.border='#ffffff';
			   
			   createGrid(myGrid,res);
	
			   //changeWidth(layout,layouts);
						   
		   }
		});

		
		
		 function sendView(e){
			 var w1 = dhtmlx.showDialog({
		            caption: '派发报修单',
		            width: 800,
		            height: 400,
		            saveText: "确定派发",
		            save: function(){
		            	if($("input[name='claimDate']")[0].value !=''&&$("input[name='finishDate']")[0].value !=''&&$("input[name='sendPeople']")[0].parentNode.children[0].value !=''){
		            		var getUserIDs = localStorage.getUserIDs;
		            		var ticketID = localStorage.ticketID;
		            		localStorage.removeItem('getUserIDs');
		            		localStorage.removeItem('ticketID');
		            		var data = {groupID:window.top.getGroupID(),ticketID:ticketID,userID:window.top.getID(),progress:2,getUserID:getUserIDs,claimDate:$("input[name='claimDate']")[0].value,finishDate:$("input[name='finishDate']")[0].value,wages:$("input[name='wages']")[0].value,otherMes:$("textarea[name='otherMes']")[0].value};
		            		data.sendDate = $("input[name='sendDate']")[0].value;
		            		data.userName = window.top.getUser().name;
		            		data.isDel = 0;
		            		data.getUserName = $("input[name='sendPeople']")[0].parentNode.children[0].value;
		            		data.processing2 = $("input[name='processing2']")[0].parentNode.children[0].value;
		            		$.ajax({
			      				   type: 'POST',
			      				   url: '/ticket/addticketprogress.action',
			      				   data: data,
			      				   success: function(res){		      					   					 
			      					 location.reload();
			      				   }
			            	})
		            	}else{
		            		dhtmlx.alert('必填项不能为空!');
		            	}	
		            }
			 })
			 var ticketID = '';
			 for(var i of e.split(',')){
				ticketID = ticketID + myGrid.getUserData(i,"ID")+',';
			 }
			 ticketID = ticketID.slice(0,ticketID.length-1);
			 localStorage.ticketID = ticketID;
			 			
			 
			 
			 var lay = w1.layout.cells("a");
			 var tool = lay.getAttachedToolbar();
			 $.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"设计派发信息"},
				   success: function(res){		
					   var data = JSON.parse(res[0].design);
					   layout = dhtmlx.layout(data,lay,res[0].designName);
					   
					   var date = new Date();
						var Y = date.getFullYear() + '/';
						var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '/';
						var D = date.getDate()+' ';
						if(D.length == 1) D = "0"+ D;
						var H = date.getHours() + ':';
						var minute= date.getMinutes();

						$("input[name='sendDate']")[0].value = Y+M+D+H+minute;
						$("input[name='legalPerson']")[0].value = window.top.getUser().name;
					
						
						
						$("input[name='claimDate']").blur(function(e){  
							var flag = compareDate($("input[name='claimDate']")[0].value,$("input[name='finishDate']")[0].value);
					        if(flag){
					        	$("input[name='claimDate']")[0].value = $("input[name='finishDate']")[0].value;
					        	dhtmlx.alert('处理日期不能大于完成日期');
					        }
						});  
						
						$("input[name='finishDate']").blur(function(e){  
							var flag = compareDate($("input[name='claimDate']")[0].value,$("input[name='finishDate']")[0].value);
					        if(flag){
					        	$("input[name='finishDate']")[0].value = $("input[name='claimDate']")[0].value;
					        	dhtmlx.alert('完成日期不能小于处理日期');
					        }
						});  
						
					   $('.dhxcombo_select_img').on('click',function(e){
						   var name = e.target.parentNode.parentNode.children[1].getAttribute('name');						
							if(name == 'sendPeople'){sendSomebody(e)}
							if(name == 'processing2'){sameSelect(e,'processing','选择处理方式','处理方式',$("input[name='processing']")[0])}
					   })
				   }
			 })
		 }
		
		 function compareDate(dateTime1,dateTime2){
		     var formatDate1 = new Date(dateTime1);
		     var formatDate2 = new Date(dateTime2);
		     if(formatDate1.getTime() > formatDate2.getTime())
		         return true;
		     else
		         return false;
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
				    	var name = $('.dhxtoolbar_input')[0].value;
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
						   var mylayout = dhtmlx.layout(data,lay,res[0].designName);
						   mytree = sameTree(mylayout,n,tool,firstText,w1,changebox);
					   }
					});
			}
		 
		 
		function createGrid(myGrid,res){
			  var a='',att ='',ids='';
			  var data = $.parseJSON(res[0].design);				
			  for(var i of data.Context[0].Columns){
				  if(i.Label != '序号' &&i.Label != '#master_checkbox'){
					  if(i.Label == '处理方式'||i.Label == '产品'||i.Label == '紧急程度')
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
				
				myGrid.attachHeader(att);
				
							 
				colState(a);
				
				
				if(flag){
					$('.hdr')[0].children[0].children[2].style.display='none';
					$('.hdr')[0].children[0].children[1].children[1].children[0].children[0].setAttribute("id","checkSelcet");
					var img = document.createElement("img");
					img.setAttribute("id", "chooseAllBox");
					img.setAttribute("style", "margin-top:10px");
					img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
					img.setAttribute("onclick", "chooseAll()");
					$('.hdr')[0].children[0].children[1].children[1].children[0].append(img);
					
				}
				
				
					//0,1列不允许拖动,不允许把列移动到0,1列
					myGrid.attachEvent("onBeforeCMove", function(cInd,posInd){
						if(cInd == 0 ||cInd == 1)return false;
						else if(posInd== 0 ||posInd == 1)return false;
						else return true;
						
					});
				
				$.ajax({
					   type: 'POST',
					   url: '/ticket/selticket.action',
					   data: {groupID:window.top.getGroupID(),progress:1},
					   success: function(res){
						   if(res.data){
							   var array = new Array();
							   var a = ids.split(',');
							   var sum = res.data.length;
							   for(var j=0;j<sum;j++){
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
							  					   
							  
							   
							   myGrid.attachEvent("onRowSelect", function(id,ind){
								   localStorage.removeItem('customerSelect');
								   var data = myGrid.getRowData(id);
								   //localStorage.customerSelect = JSON.stringify(data);
								});
							   
							   
							   
							   
								   myGrid.attachEvent("onRowDblClicked", function(rId,cInd){
								       var data = myGrid.getRowData(rId);
								       //localStorage.infos = JSON.stringify(data);
								     
								       //添加iframe标签
								       var body = document.getElementsByTagName("body");
								       var div = document.createElement("div");
								       div.setAttribute("id","editCustomer");
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
				$("input[name='processing2']")[0].parentNode.children[0].value = mytree.getItemText(id).split(']')[1];
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
		
		
		function changeWidth(layout){
			 window.onresize = function(){								  
				   var a = $('#gridbox')[0].clientWidth||$('#gridbox')[0].offsetWidth;
				   var b = $('#gridbox')[0].clientHeight||$('#gridbox')[0].offsetHeight;
				   layout.lays[0].cells("a").cell.style.width = a+'px';
				   layout.lays[0].cells("a").cell.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
				   layout.lays[0].cells("a").cell.children[1].style.width = a-14+'px';				   
				   layout.lays[0].cells("a").cell.children[2].style.width = a-2+'px';		   
				   layout.lays[0].cells("a").cell.style.height = b+'px';
				   layout.lays[0].cells("a").cell.parentNode.style.height = b+'px';				   
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.style.height = b+'px';
				   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.parentNode.style.height = b+'px';
				   layout.lays[0].cells("a").cell.children[2].style.height = b-81+'px';				 
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
				myToolbar.setItemImage("show", "/item_chk1.gif");
				flag = false;
			}else{
				table.style.display = 'none';
				xhdr.style.height = hdr.offsetHeight+'px';
				$('.objbox')[0].style.height = parseInt($('.objbox')[0].style.height) + h +'px';
				myToolbar.setItemImage("show", "/item_chk0.gif");
				flag = true;
			}
			
		}
</script> 
</body>
</html>