<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>工单受理</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath }/layuiadmin/layui/css/layui.css" media="all">
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
		<span style="font-size:x-large;margin-left:30px;">工单受理</span>
	</div>
	<div id="gridbox" style="margin-left:20px;width:calc(100% - 40px);height:calc(100% - 100px)"></div>
<script type="text/javascript">

    	var layout,layouts,myGrid,flag=true,flag2=true,myToolbar;
		var myLayout = new dhtmlXLayoutObject("gridbox", "1C");
		myLayout.cells("a").hideHeader();
		

	   $.ajax({
		   type: 'POST',
		   url: '/design/seldesign3.action',
		   data: {DesignName:"设计工单受理"},
		   success: function(res){		
			   var data = JSON.parse(res[0].design);
			   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);		
			   
			   myGrid = layout.lays[0].cells("a").getAttachedObject();
			   myGrid.setImagesPath("../DHX/imgs/");
			   var rowID=myGrid.getRowId(0);
			   myGrid.deleteRow(rowID);
			   
			   
			   myToolbar = layout.lays[0].cells("a").TBar;
			   myToolbar.base.children[0].style.background='#ffffff';
			   myToolbar.base.children[0].style.border='#ffffff';
			   
			   myToolbar.attachEvent("onClick", function(id){
				    if(id == 'show'){choose();}
				    if(id == 'accept'){
				    	if(myGrid.getCheckedRows(0)!=''){
				    		if(myGrid.getCheckedRows(0).split(',').length>1){
				    			dhtmlx.alert('只能勾选一条!');
				    		}else if(myGrid.getRowData(myGrid.getCheckedRows(0)).accept != '待受理'){
				    			dhtmlx.alert('只能勾选待受理!');
				    		}else{
				    			accept(myGrid.getCheckedRows(0));
				    		}
				    	}else{
				    		dhtmlx.alert('复选框未勾选!');
				    	}
				    }
				    if(id == 'disAccept'){
				    	
				    }
				    if(id == 'stop'){
				    	
				    }				   
				    if(id == 'returnSend'){
				    	
				    }
				    if(id == 'changeSomeBody'){
				    	
				    }
				});

			   createGrid(myGrid,res);

			   changeWidth(layout);
			   					   
		   }
		});
		
	

		 
		function createGrid(myGrid,res){
			  var a='',att ='',ids='';
			  var data = $.parseJSON(res[0].design);				
			  for(var i of data.Context[0].Columns){
				  	if(i.Label == '#master_checkbox')
					  att = att + ',';
				  	else if(i.Label == '紧急程度'||i.Label == '受理')
				  		att = att + '#select_filter,';
				  	else
				  		att = att + '#text_filter,';
					  a = a + i.Label + ','; 
					  ids = ids + i.Name +',';			  													  
			  }
			 
			  a = a.slice(0,a.length-1);
			  ids = ids.slice(0,ids.length-1);
			  att = att.slice(0,att.length-1);

				
			  if(flag){
					$('.hdr')[0].children[0].children[1].children[0].children[0].children[0].setAttribute("id","checkSelcet");
					var img = document.createElement("img");
					img.setAttribute("id", "chooseAllBox");					
					img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
					img.setAttribute("onclick", "chooseAll()");
					$('.hdr')[0].children[0].children[1].children[0].children[0].append(img);
					
				}
			  
			  
			  
				
				$.ajax({
					   type: 'POST',
					   url: '/ticket/selticketaccept.action',
					   data: {groupID:window.top.getGroupID(),getUserID:window.top.getID()},
					   success: function(res){
						   var array = new Array();
						   var a = ids.split(',');
						   var sum = res.length;
						   for(var j=0;j<sum;j++){
							   var arr = new Array();
							   for(var i=0;i<a.length;i++){
								   if(a[i] == ''){
									   arr[i] = null;
								   }else if(a[i] == 'accept'){
										   if(res[j].isDel == "0"){
											   arr[i] = '待受理';
										   }
										   if(res[j].isDel == "1"){
											   arr[i] = '已受理';
										   }
										   if(res[j].isDel == "2"){
											   arr[i] = '已废弃';
										   }
										   if(res[j].isDel == "3"){
											   arr[i] = '已拒绝';
										   }
								   		}else{
								   			arr[i] = res[j][a[i]];
								   		}   									   
							   }
							   array[j] = arr;
						   } 
						  
						   myGrid.parse(array,"jsarray");						   
						   myGrid.attachHeader(att);
						   
						   var count=myGrid.getRowsNum();
						   for(var i=0;i<count;i++){
							   myGrid.setRowId(i,"row"+i);
							   myGrid.setUserData("row"+i,"ID",res[i].id);
						   }
						   
						   
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
				 })

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
		
		
		
		function accept(e){
				

   		    var ticketID = myGrid.getUserData(e,'ID');
      		var data = {id:window.top.getGuid(),groupID:window.top.getGroupID(),ticketID:ticketID,assignee:window.top.getID(),userName:window.top.getUser().name,progress:3};	
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
		function chooseAll(){
			$('#checkSelcet')[0].click();
			if(flag){
				$('#chooseAllBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk1.gif";
				flag = false;
			}else{
				$('#chooseAllBox')[0].src = "../DHX/imgs/dhxgrid_terrace/item_chk0.gif";
				flag = true;
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