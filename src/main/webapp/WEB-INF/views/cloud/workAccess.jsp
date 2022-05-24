<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>回访列表</title>
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
		<span style="font-size:x-large;margin-left:30px;">回访列表</span>
	</div>
	<div id="gridbox" style="margin-left:20px;width:calc(100% - 40px);height:calc(100% - 100px)"></div>
<script type="text/javascript">

    	var flag = true,flag2=true,layout,layouts,myGrid,myPop,h;
		var myLayout = new dhtmlXLayoutObject("gridbox", "1C");
		myLayout.cells("a").hideHeader();

		
	
		   $.ajax({
			   type: 'POST',
			   url: '/design/seldesign3.action',
			   data: {DesignName:"设计工单回访"},
			   success: function(res){		
				   var data = JSON.parse(res[0].design);
				   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);		

				   
				   myGrid = layout.lays[0].cells("a").getAttachedObject();
				   myGrid.setImagesPath("../DHX/imgs/");
				   var rowID=myGrid.getRowId(0);
				   myGrid.deleteRow(rowID);
				   
				   
				   var myToolbar = layout.lays[0].cells("a").TBar;
				   myToolbar.attachEvent("onClick", function(id){
					   if(id == 'show'){choose(myToolbar)}
					   if(id == 'returnSend'){returnSend(myGrid)}
					   if(id == 'access'){access(myGrid)}
					   if(id == 'disAccess'){disAccess(myGrid)}
					});
				  
				   myToolbar.base.children[0].style.background='#ffffff';
				   myToolbar.base.children[0].style.border='#ffffff';
				   
				   createGrid(myGrid,res);
				  
				   changeWidth(layout);
						   
			   }
			});
	
		
		
		//重派
		function returnSend(myGrid){
			var checked = myGrid.getCheckedRows(0);
			if(checked == ''){
				dhtmlx.alert('未选择复选框');
			}else{
				dhtmlx.confirm({
				    title: "重派请求",
				    type:"提示",
				    text: "是否确定重派?",
				    cancel: '否',
				    ok: '是',
				    callback: function(h) {
				    	if(h){
				    		var ids = '';
				    		for(var i of checked.split(',')){
				    			ids = ids + myGrid.getUserData(i,"ID") +','; 
				    		}
				    		ids = ids.slice(0,ids.length-1);
				    		var data = {groupID:window.top.getGroupID(),id:ids,progress:1};
				    		
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
				})
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
		            	data['progress'] = '5';
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
		
		
		function createGrid(myGrid,res){
			  var a='',att ='',ids='';
			  var data = $.parseJSON(res[0].design);				
			  for(var i of data.Context[0].Columns){
				  	  if(i.Name == 'check'){
				  		att = att + ',';
				  	  }else{
				  		att = att + '#text_filter,';
				  	  }
					  a = a + i.Label + ','; 
					  ids = ids + i.Name +',';			  													  
			  }
			 
			  a = a.slice(0,a.length-1);
			  ids = ids.slice(0,ids.length-1);
			  att = att.slice(0,att.length-1);

				//数据列拖拽
				myGrid.enableColumnMove(true);
				
				if(flag2){
					$('.hdr')[0].children[0].children[1].children[0].children[0].children[0].setAttribute("id","checkSelcet");
					var img = document.createElement("img");
					img.setAttribute("id", "chooseAllBox");					
					img.setAttribute("src","../DHX/imgs/dhxgrid_terrace/item_chk0.gif");
					img.setAttribute("onclick", "chooseAll()");
					$('.hdr')[0].children[0].children[1].children[0].children[0].append(img);
					
				}
				

				//0,1列不允许拖动,不允许把列移动到0,1列
				myGrid.attachEvent("onBeforeCMove", function(cInd,posInd){
					if(cInd == 0 ||cInd == 1)return false;
					else if(posInd== 0 ||posInd == 1)return false;
					else return true;
					
				});
				
				$.ajax({
					   type: 'POST',
					   url: '/ticket/selticketall.action',
					   data: {groupID:window.top.getGroupID(),progress:4},
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
									   if(a[i] == 'check'){
										   arr[i] = null;
									   }else
										   arr[i] = res.data[j][a[i]];							   
								   }
								   array[j] = arr;
							   } 
							   
							   myGrid.parse(array,"jsarray");						   
							   myGrid.attachHeader(att);
							   $('.hdr')[0].children[0].children[2].style.display='none';
							   
							   var count=myGrid.getRowsNum();
							   for(var i=0;i<count;i++){
								   myGrid.setRowId(i,"row"+i);
								   myGrid.setUserData("row"+i,"ID",res.data[i].id);
							   }
							  					   

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
		function choose(myToolbar){
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