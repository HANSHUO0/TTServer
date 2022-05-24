<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>新增客户</title>
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
	
  	</style>
  	
	<script type="text/javascript">
	
    $(function () {
		
    	var customerID,length,layout,layouts,buttonCSS = "margin-top:20%;width:80%;height:5%;border-radius: 5px;border:none;";
		var myLayout = new dhtmlXLayoutObject("see", "1C");
		myLayout.cells("a").hideHeader();
		myLayout.cells("a").setHeight(2600);
		
		$.ajax({
			   type: 'POST',
			   url: '/customer/selcustomerdesign.action',
			   data: {groupName:window.top.getName(),userID:window.top.getID()},
			   success: function(res){
				   if(res.data){
					  var data = JSON.parse(res.data[0].design);
					  layout = dhtmlx.layout(data,myLayout.cells("a"),"客户档案");
					  
					  if(res.data[0].positioningBar!=null&&res.data[0].positioningBar!=''){
							 bar(res.data[0].positioningBar);
					   }
					  
					  
					  editPeople(layout);
					  editFW(layout);
					  buttonEvent(layout.lays[0].cells("c"));
					  buttonEvent(layout.lays[0].cells("d"));
					  buttonEvent(layout.lays[0].cells("e"));
					  buttonEvent(layout.lays[0].cells("h"));
					  layout.lays[0].cells("f").collapse();
					  layout.lays[0].cells("g").collapse();
					  layout.lays[0].cells("f").hideArrow();
					  layout.lays[0].cells("g").hideArrow();
					  selectFL();
					  changeWidth(layout,layouts);
					  startlogin(layout);
				   }else{
					   $.ajax({
						   type: 'POST',
						   url: '/design/seldesign3.action',
						   data: {DesignName:"设计客户档案"},
						   success: function(res){		
							   var data = JSON.parse(res[0].design);
							   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);					   
							   
							   if(res[0].positioningBar!=null&&res[0].positioningBar!=''){
									 bar(res[0].positioningBar);
							   }
							   
							   $("input[name='cStatus']")[0].setAttribute("readonly","readonly");					 
							   
							   editPeople(layout);
							   editFW(layout);
							   buttonEvent(layout.lays[0].cells("c"));
							   buttonEvent(layout.lays[0].cells("d"));
							   buttonEvent(layout.lays[0].cells("e"));
							   buttonEvent(layout.lays[0].cells("h"));
							   layout.lays[0].cells("f").collapse();
							   layout.lays[0].cells("f").hideArrow();
							   layout.lays[0].cells("g").collapse();
							   layout.lays[0].cells("g").hideArrow();
							   selectFL();
							   changeWidth(layout,layouts);
							   startlogin(layout);
						   }
						});
				   }
			   }
		});
			
		
		
		function bar(e){
			 var box = document.getElementById("seeBox");
			  box.style.cssText = "width:83%;height:2230px;margin-left:12%;margin-top:1%;margin-bottom:3%;background: #ffffff;box-shadow: 0 0 10px #000000;";	
			  
			  var page = myLayout.cells("a").getAttachedObject();
			  for(var i =0;i< page.items.length;i++){
			  	page.items[i].cell.style.width = box.offsetWidth -20 +"px";
			  	if(page.items[i].cell.children[2]){
			  		page.items[i].cell.children[2].children[0].style.width = box.offsetWidth -20 +"px";
				  	
			  	}
			  	if(page.items[i].cell.children[1].children[0]){
			  		page.items[i].cell.children[1].style.width = box.offsetWidth -19 +"px";
			  	}
			  	
			  }
			  var dom = document.createElement('div'); 
		       	  dom.id = "PositioningBar";
		       	  dom.style.cssText = "width:9%;height:90%;margin-left:2%;position:absolute;";                   	
		       	  document.getElementById("postBar").appendChild(dom);
		       	  $("#PositioningBar").after($("#seeBox"));
		       	  
		       	  var list = e.split(",");
		       	  length = list.length-1;
		       	  for(var i = 0;i < list.length-1;i++){
		       		  
		       		  var button = document.createElement("input");
		       		  button.setAttribute("type", "button");
		       		  button.setAttribute("value", list[i]);
		       		  button.setAttribute("id", i+1);
		       		  button.style.cssText = "margin-top:20%;width:80%;height:5%;border-radius: 5px;border:none;";
		       		  button.onclick = function(event) {b1(event);};        
		       		  
		       		  document.getElementById("PositioningBar").appendChild(button);
		       		  
		       		  $("#1").click(function(){		                    		
		               	document.getElementById("1").style.cssText = "margin-top:20%;width:80%;height:5%;border-radius: 5px;border:none;background:#66CC33";
		              });
		
		       	  }
			   
		}
		
		
		
		
		
        function b1(event){
			
			 var i = event.target.id;
			 i = parseInt(i);

			 var a = document.getElementById("see");
			 var model = a.children[0].children[0].children[1].children[0].children[0];
			 var first = model.children[0].clientHeight;
			 var model2 = model.children[1].children[1].children[0].children[0];
			 if(length >= 3){
	   	    	var model3 = model2.children[1].children[1].children[0].children[0];
	   	    }
	   	    if(length >= 4){
	   	    	var model4 = model3.children[1].children[1].children[0].children[0];
	   	    }
	   	    if(length > 5){
	   	    	var model5 = model4.children[1].children[1].children[0].children[0];
	   	    	var height5 = model5.children[0].clientHeight;
	   	    }
	   	    if(length > 6){
	   	    	var model6 = model5.children[1].children[1].children[0].children[0];
	   	    }
	   	    if(length > 7){
	   	    	var model7 = model6.children[1].children[1].children[0].children[0];
	   	    }
	    	    switch(i){
		    	    case 1:{
		    	    	document.getElementById("postBar").scrollTop = 0;
		    	    	break;
		    	    }
		    	    case 2:{
		    	    	document.getElementById("postBar").scrollTop = first+10;
		    	    	break;
		    	    }
		    	    case 3:{
		    	    	document.getElementById("postBar").scrollTop = first + model2.children[0].clientHeight + 20;
		    	    	break;
		    	    }
		    	    case 4:{
		    	    	document.getElementById("postBar").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight + 30;
		    	    	break;
		    	    }
		    	    case 5:{
		    	    	document.getElementById("postBar").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + 40;
		    	    	break;
		    	    }
		    	    case 6:{
		    	    	document.getElementById("postBar").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + height5 + 50;
		    	    	break;
		    	    }
		    	    case 7:{
		    	    	document.getElementById("postBar").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + height5 + model6.children[0].clientHeight + 60;
		    	    	break;
		    	    }
		    	    case 8:{
		    	    	document.getElementById("postBar").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + height5 + model6.children[0].clientHeight + model7.children[0].clientHeight + 70;
		    	    	break;
		    	    }
	    	    }
		}
        

        function buttonLength(o){
        	for(var i=1;i<=length;i++){
        		if(i == o){
        			document.getElementById(i).style.cssText = "margin-top:20%;width:80%;height:5%;border-radius: 5px;border:none;background:#66CC33";
        		}
        		else{
        			document.getElementById(i).style.cssText = buttonCSS;
        		}
        	}
        }
        
        
		$('#postBar').scroll(function(event){
			 var toTop = $('#postBar').scrollTop();
			
			 var a = document.getElementById("see");
			 var model = a.children[0].children[0].children[1].children[0].children[0];
			 var first = model.children[0].clientHeight; 
			 var model2 = model.children[1].children[1].children[0].children[0];
			 var first2 = model2.children[0].clientHeight;
			 if(length >= 3){
	   	    	var model3 = model2.children[1].children[1].children[0].children[0];
	   	    	var height3 = model3.children[0].clientHeight;
	   	    }
	   	    if(length >= 4){
	   	    	var model4 = model3.children[1].children[1].children[0].children[0];
	   	    	var height4 = model4.children[0].clientHeight;
	   	    }
	   	    if(length > 5){
	   	    	var model5 = model4.children[1].children[1].children[0].children[0];
	   	    	var height5 = model5.children[0].clientHeight;
	   	    }
	   	    if(length > 6){
	   	    	var model6 = model5.children[1].children[1].children[0].children[0];
	   	    	var height6 = model6.children[0].clientHeight;
	   	    }
	   	    if(length > 7){
	   	    	var model7 = model6.children[1].children[1].children[0].children[0];
	   	    	var height7 = model7.children[0].clientHeight;
	   	    }
	   	    
	   	    if(toTop < first +9){
	   	    	buttonLength(1);
	   	    }
	   	    if(first+9 < toTop && toTop < first+first2 && length >=2){
	   	    	if(document.getElementById("3"))
	   	    	document.getElementById("3").style.cssText = buttonCSS;
	   	    	buttonLength(2);
	   	    }
	   	    if(first+first2+19 < toTop && toTop < first+first2+height3 && length >=3){
	   	    	if(document.getElementById("4"))
	   	    	document.getElementById("4").style.cssText = buttonCSS;
	   	    	buttonLength(3);
	   	    }
		   	if(first+first2+height3+29 < toTop && toTop < first+first2+height3+height4 && length >=4){
	   	    	if(document.getElementById("5"))
	   	    	document.getElementById("5").style.cssText = buttonCSS;
	   	    	buttonLength(4);
		   	}
		   	if(first+first2+height3+height4+39 < toTop && toTop < first+first2+height3+height4+height5 && length >=5){
	   	    	if(document.getElementById("6"))
	   	    	document.getElementById("6").style.cssText = buttonCSS;
	   	    	buttonLength(5);
		   	}
		   	if(first+first2+height3+height4+height5 < toTop && toTop < first+first2+height3+height4+height5+height6 && length >=6){
	   	    	if(document.getElementById("7"))
	   	    	document.getElementById("7").style.cssText = buttonCSS;
	   	    	buttonLength(6);
		   	}
		   	if(first+first2+height3+height4+height5+height6 <= toTop && toTop < first+first2+height3+height4+height5+height6+height7 && length >=7){
	   	    	if(document.getElementById("8"))
	   	    	document.getElementById("8").style.cssText = buttonCSS;
	   	    	buttonLength(7);
		   	}
		   	if( toTop > 2000){	 	    	
		   		buttonLength(8);
		   	}
	     });
		
		
		 layouts = new dhtmlXLayoutObject("toolbar", "1C");
		 layouts.cells("a").hideHeader();

		 var myToolbar = layouts.cells("a").attachToolbar();
		 myToolbar.setIconsPath("${pageContext.request.contextPath}/DHX/imgs/dhxtoolbar_terrace/");
		 myToolbar.addItems([
		        {ID: "printView", Type: "button", Text: "打印设置", Img: "print.gif"},
		        {ID: "sep1", Type: "separator" },
		        {ID: "designView", Type: "button",Text: "页面设计", Img: "open.gif"},
		        {ID: "sep2", Type: "separator" },
		        {ID: "save", Type: "button", Text: "保存", Img: "save.gif"},		       
		    ]);
		 
		 
		 
		 myToolbar.attachEvent("onClick", function(id){
			   if(id == 'printView'){
				   location.href="${pageContext.request.contextPath}/view/tocustomerprint.action";
			   }
			   if(id == 'designView'){
				   location.href="${pageContext.request.contextPath}/view/toeditcustomer.action";
			   }
			   if(id == 'save'){ 
				   var cCusCode = $("input[name='cCusCode']")[0].value;
				   if(cCusCode !=''){
					   var num = $('.dhxform_textarea');
				   	   var num2 = $('.dhxcombo_input');
					   var data = {};
					   data['groupName'] = window.top.getName();
					   var className = '';
					  // var maxLength = '';
					   if(num&&num.length!=0){
						   for(var i=0;i<num.length;i++){
							   
							   data[num[i].name] = num[i].value;
							   
							   if(i == num.length-1){
								   className += num[i].name;
						   		  // maxLength += num[i].maxLength;
							   }
							   else{
							 	   className = className + num[i].name + ',';
							   	  // maxLength = maxLength + num[i].maxLength + ',';
							   }
						   }
					   }
					   if(num2&&num2.length!=0){
						   for(var i=0;i<num2.length;i++){
							   data[num2[i].parentNode.children[1].name] = num2[i].parentNode.children[1].value;
							   if(i == num2.length-1){
								   className += num2[i].parentNode.children[1].name;
							   }
							   else{
							 	   className = className + num2[i].parentNode.children[1].name + ',';
							   }
						   }
					   }
					$.ajax({
						  type: 'POST',
						   url: '/customer/addcustomer.action',
						   data: data,
						   success: function(res){
							   if(res.id)
								customerID = res.id;						   
							  // location.reload();
						   }
					   });
					
					  // $.ajax({
						//   type: 'POST',
						//   url: '/design/createmysql.action',
						//   data: {className:className,maxLength:maxLength},
						//   success: function(res){
								
						//   }
					  // });
				   }else
					   dhtmlx.alert('客户编码不能为空');  
			   }
			});
		 function editPeople(layout){
			 
			 var grid = layout.lays[0].cells("c").getAttachedObject();
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
					if(cInd == 3){
						var a = $('.dhx_combo_select');
						//$.ajax({
	    			    //	type: 'POST',
	    			    //	url: '${pageContext.request.contextPath}/department/seldepartment.action',
	    			    //	data:{groupName:window.top.getName()},
	    			    ///	success: function(res){	
	    			    //	}
	    		      	//});
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
		 
		 
		 
		 
		 
		 
		 function editFW(layout){			 
			 var grid = layout.lays[0].cells("h").getAttachedObject();
			 grid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue){
				 if(stage == 1){
					 if(cInd == 2){
							var a = $('.dhx_combo_select');							
							a[0].children[0].remove();
							a[0].options.add(new Option('U8','U8'));
							a[0].options.add(new Option('T3','T3'));
							a[0].options.add(new Option('T+','T+'));
							a[0].options.add(new Option('T6','T6'));
							a[0].options.add(new Option('OA','OA'));
							a[0].options.add(new Option('其他','其他'));
						}
				 }
				 if(stage == 2){
	    		    	if(nValue != oValue){   		    		
	    		    			if(cInd == 5){
	    		    				var start = grid.cellById(rId,cInd-2).cell.innerHTML;
	    		    				if( start != '&nbsp;'){
	    		    					var days = getDays(nValue,start);	    		    					
	    		    					if(days >= 0)
	    		    						grid.cellById(rId,cInd-1).cell.innerHTML = days;
	    		    					else{
	    		    						dhtmlx.alert('选择的日期不能小于开始日期');
	    		    					    return false;
	    		    					}
	    		    				}
	    		    			}
								if(cInd == 3){
									var end = grid.cellById(rId,cInd+2).cell.innerHTML;
									if( end != '&nbsp;'){
	    		    					var days = getDays(end,nValue);	    		    					
	    		    					if(days >= 0)
	    		    						grid.cellById(rId,cInd+1).cell.innerHTML = days;
	    		    					else{
	    		    						dhtmlx.alert('选择的日期不能大于截止日期');
	    		    					    return false;
	    		    					}
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
		 function buttonEvent(myLayout){
			var toolbar = myLayout.getAttachedToolbar();
			var grid = myLayout.getAttachedObject(); 
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
			    	var cCusCode = $("input[name='cCusCode']")[0].value;
			    	if(cCusCode ==''){
			    		dhtmlx.alert('客户编码不能为空');		
			    	}else if(customerID){
			    		var count = grid.getRowsNum();			    	
				    	for(var i = 0;i< count;i++){
				    		var rowId = grid.getRowId(i);
					    	var data2 = grid.getRowData(rowId);					    						    		
					    	data2['title'] = myLayout.getText();
					    	if(data2.title == '联系人'){
					    		if(!data2.cMoblePhone&&!data2.cState){
						    		dhtmlx.alert('手机1和状态不能为空');
						    		data = [];
						    		break;
						    	}else{
						    		data2['cAge'] = $('.objbox')[0].children[0].children[0].children[1].children[10].innerHTML;
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
					    	if(data2.title == '地址'){
					    		data2['cCusCode'] = customerID;
					    		data2['groupName'] = window.top.getName();
					    		
					    		$.ajax({
				    		    	type: 'POST',
				    		    	url: '/customer/addcustomeraddress.action',
				    		    	data:data2,
				    		    	success: function(res){
				    		    		dhtmlx.alert('添加成功');
				    		    	}
					    		})
					    	}
					    	if(data2.title == '关联公司'){
					    		data2['cCusCode'] = customerID;
					    		data2['groupName'] = window.top.getName();
					    		
					    		$.ajax({
				    		    	type: 'POST',
				    		    	url: '/customer/addcustomerassociation.action',
				    		    	data:data2,
				    		    	success: function(res){
				    		    		dhtmlx.alert('添加成功');
				    		    	}
					    		})
					    	}
					    	if(data2.title == '服务有效期维护'){
					    		data2['cEffective'] = $('.objbox')[4].children[0].children[0].children[1].children[4].innerHTML;
					    		data2['cCusCode'] = customerID;
					    		data2['groupName'] = window.top.getName();
					    		
					    		$.ajax({
				    		    	type: 'POST',
				    		    	url: '/customer/addcustomereffective.action',
				    		    	data:data2,
				    		    	success: function(res){
				    		    		dhtmlx.alert('添加成功');
				    		    	}
					    		})
					    	}
				    	}
			    	}else{
			    		dhtmlx.alert('需要先保存客户信息');
			    	}			    	
			    }
			});
		 }
		 function selectFL(){
			 $('.dhxcombo_select_img').on('click',function(e){
					var name = e.target.parentNode.parentNode.children[1].getAttribute('name');
					
					if(name == 'cCCCode'){CustomerSelect(e,name)}
					if(name == 'cDepCode'){DepSelect(e,name)}
					if(name == 'cPsnCode'){PsnSelect(e,name)}
					if(name == 'cDCCode'){DcSelect(e,name)}
					if(name == 'cCusVIP'){CusVIPSelect(e,name)}
					if(name == 'cInfoSource'){InfoSource(e,name)}
					if(name == 'cTrade'){TradeSelect(e,name)}
			 })
			
		 }
		 
		 
		 function TradeSelect(e,n){
			  var mytree;
			   var w1 = dhtmlx.showDialog({
		            caption: '选择所属行业',
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
					   mytree = sameTree(mylayout,n,tool,'所属行业');
				   }
				});
		 }
		 
		 function InfoSource(e,n){
			   var mytree;
			   var w1 = dhtmlx.showDialog({
		            caption: '选择客户来源',
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
		            	cusCode();
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
					   mytree = sameTree(mylayout,n,tool,'客户来源');
				   }
				});
		 }
		 
		 function CusVIPSelect(e,n){
			   var mytree;
			   var w1 = dhtmlx.showDialog({
		            caption: '选择客户等级',
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
		            	
		            	cusCode();
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
					   mytree = sameTree(mylayout,n,tool,'客户等级');
				   }
				});
		 }
		 
		 
		 
		 
		 function DcSelect(e,n){
			   var mytree
			   var w1 = dhtmlx.showDialog({
		            caption: '选择地区',
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
		            	
		            	cusCode();
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
					   mytree = sameTree(mylayout,n,tool,'所属地区');
				   }
				});
			   
			   
		 }
		 
		 
		 
		 function PsnSelect(e,name){
			   var mytree
			   var w1 = dhtmlx.showDialog({
		            caption: '选择人员',
		            width: 500,
		            height: 400,
		            saveText: "确定",
		            save: function () {	            	
						var names ='';
						if(mytree.getAllChecked().length != 0){
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
			   tool.addButton('localization',2, '查找', null, null);
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
	   				    		var names2 = e.target.parentNode.parentNode.children[0].value;
	   				    		if(names2 !=''){
	   				    			var arr = names2.split(';');
	   				    			for(var i=0;i<arr.length-1;i++){
	   				    				var id = mytree.findItemIdByLabel(arr[i],1,null);
	   				    				mytree.setCheck(id,1);
	   				    			}
	   				    		}
	   				    	}
				   		})				   		
   			    	}
   		      });
			   
			  
		 } 
		 
		 
		 
		 function DepSelect(e){
			 var mytree;
			   var w1 = dhtmlx.showDialog({
		            caption: '选择部门分类',
		            width: 400,
		            height: 400,
		            saveText: "确定",
		            save: function () {
		            	var treeId = mytree.getSelectedItemId();
						var name = mytree.getItemText(treeId);
						if(name != 0){
							if(treeId != 1){
								e.target.parentNode.parentNode.children[0].value = name.split("]")[1];
								e.target.parentNode.parentNode.children[1].setAttribute('cid',name.split(']')[0].substr(1));
							}
		            	}	
						cusCode();
						w1.close();
                 }
		        });
			   var lay = w1.layout.cells("a");
			   
			   var mylayout = new dhtmlXLayoutObject({
				   parent:     lay,    
				   pattern:    "1C",           
				   cells: [{id:"a",text:"部门分类"}]
			   });			 
			   mytree = createTree2(mylayout);
			
		 }
		 
		 
		 function CustomerSelect(e,n){
			  
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
							if(treeId != 1)
								e.target.parentNode.parentNode.children[0].value = name.split("]")[1];
								e.target.parentNode.parentNode.children[1].setAttribute('cid',name.split(']')[0].substr(1));
		            	}
		            	cusCode();
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
		 
		 
		 function createTree2(mylayout){
			 var mytree = mylayout.cells("a").attachTree();
			 mytree.setImagePath("../DHX/imgs/dhxtree_terrace/");

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
    			    		
    			    	}
    		      });
		   return mytree;
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
		 
		 
		 function changeWidth(layout,layouts){
			 window.onresize = function(){				
				   layouts.cont.style.width = '100%';
				   layouts.cont.children[0].style.width = '100%';
				   layouts.cont.children[0].children[2].style.width = '100%';
				   startlogin(layout);
			   }
		 }
		 function startlogin(layout){
			   var a = $('#see')[0].clientWidth||$('#see')[0].offsetWidth;
			   layout.lays[0].cells("a").cell.style.width = a+'px';
			   layout.lays[0].cells("a").cell.parentNode.style.width = a+'px';
			   layout.lays[0].cells("a").cell.children[1].style.width = a-2+'px';
			   layout.lays[0].cells("b").cell.style.width = a+'px';
			   layout.lays[0].cells("b").cell.children[1].style.width = a-2+'px';
			   layout.lays[0].cells("c").cell.style.width = a+'px';
			   layout.lays[0].cells("c").cell.children[1].style.width = a-14+'px';
			   layout.lays[0].cells("c").cell.children[2].style.width = a-2+'px';
			   layout.lays[0].cells("c").cell.children[2].children[0].style.width = a+'px';
			   layout.lays[0].cells("d").cell.style.width = a+'px';
			   layout.lays[0].cells("d").cell.children[1].style.width = a-14+'px';
			   layout.lays[0].cells("e").cell.style.width = a+'px';
			   layout.lays[0].cells("e").cell.children[1].style.width = a-14+'px';
			   layout.lays[0].cells("f").cell.style.width = a+'px';
			   layout.lays[0].cells("f").cell.children[1].style.width = a-2+'px';
			   layout.lays[0].cells("g").cell.style.width = a+'px';
			   layout.lays[0].cells("g").cell.children[1].style.width = a-2+'px';
			   layout.lays[0].cells("h").cell.style.width = a+'px';
			   layout.lays[0].cells("h").cell.children[1].style.width = a-14+'px';
			   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("b").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("b").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("c").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("c").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("c").cell.children[2].style.width = a-2+'px';
			   layout.lays[0].cells("d").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("d").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("d").cell.children[2].style.width = a-2+'px';
			   layout.lays[0].cells("e").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("e").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("e").cell.children[2].style.width = a-2+'px';
			   layout.lays[0].cells("f").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("f").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("g").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("g").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("h").cell.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("h").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
			   layout.lays[0].cells("h").cell.children[2].style.width = a-2+'px';
		 }
		
		  
		  
		 function cusCode(){

			 $.ajax({
				   type: 'POST',
				   url: '/increaserules/selincreaserules.action',
				   data: {cArchivesName:document.title,groupName:window.top.getName()},
				   success: function(res){
					   if(res.data[0].cfirst !=''&&res.data[0].csecond ==''&&res.data[0].cthird ==''){
						   getOneCode(res.data[0].cfirst,res);
					   }
					   if(res.data[0].cfirst ==''&&res.data[0].csecond !=''&&res.data[0].cthird ==''){
						   getOneCode(res.data[0].csecond,res);
					   }
					   if(res.data[0].cfirst ==''&&res.data[0].csecond ==''&&res.data[0].cthird !==''){
						   getOneCode(res.data[0].cthird,res);
					   }
					   if(res.data[0].cfirst !=''&&res.data[0].csecond !=''&&res.data[0].cthird ==''){
						   getTowCode(res.data[0].cfirst,res.data[0].csecond,res);
					   }
					   if(res.data[0].cfirst !=''&&res.data[0].csecond ==''&&res.data[0].cthird !=''){
						   getTowCode(res.data[0].cfirst,res.data[0].cthird,res);
					   }
					   if(res.data[0].cfirst ==''&&res.data[0].csecond !=''&&res.data[0].cthird !=''){
						   getOneCode(res.data[0].csecond,res.data[0].cthird,res);
					   }
					   if(res.data[0].cfirst !=''&&res.data[0].csecond !=''&&res.data[0].cthird !=''){
						   getThreeCode(res.data[0].cfirst,res.data[0].csecond,res.data[0].cthird,res);
					   }
				   }
			 })
		 }
		 
		 function getThreeCode(a,b,c,res){
			 var num1 = $("input[name='"+a+"']")[0].getAttribute('cid');
			   if(num1){
			      if(parseInt(res.data[0].clongText1)>num1.length){
			    	  var i = parseInt(res.data[0].clongText1)-num1.length;
			    	  for(var j=0;j<i;j++){
			    		  num1 = '0'+num1;
			    	  }
			      }
			   }
			   var num2 = $("input[name='"+b+"']")[0].getAttribute('cid');
			   if(num2){
			      if(parseInt(res.data[0].clongText2)>num2.length){
			    	  var i = parseInt(res.data[0].clongText2)-num2.length;
			    	  for(var j=0;j<i;j++){
			    		  num2 = '0'+num2;
			    	  }
			      }
			   }
			   var num3 = $("input[name='"+c+"']")[0].getAttribute('cid');
			   if(num3){
			      if(parseInt(res.data[0].clongText3)>num3.length){
			    	  var i = parseInt(res.data[0].clongText3)-num3.length;
			    	  for(var j=0;j<i;j++){
			    		  num3 = '0'+num3;
			    	  }
			      }
			   }
			   getLsNum(res.data[0],num1+num2+num3);
		 }
		 
		 
		 function getTowCode(a,b,res){
			 var num1 = $("input[name='"+a+"']")[0].getAttribute('cid');
			   if(num1){
			      if(parseInt(res.data[0].clongText1)>num1.length){
			    	  var i = parseInt(res.data[0].clongText1)-num1.length;
			    	  for(var j=0;j<i;j++){
			    		  num1 = '0'+num1;
			    	  }
			      }
			   }
			   var num2 = $("input[name='"+b+"']")[0].getAttribute('cid');
			   if(num2){
			      if(parseInt(res.data[0].clongText2)>num2.length){
			    	  var i = parseInt(res.data[0].clongText2)-num2.length;
			    	  for(var j=0;j<i;j++){
			    		  num2 = '0'+num2;
			    	  }
			      }
			   }
			   getLsNum(res.data[0],num1+num2);
		 }
		 
		 
		 function getOneCode(a,res){
			 var num1 = $("input[name='"+a+"']")[0].getAttribute('cid');
			   if(num1){
			      if(parseInt(res.data[0].clongText1)>num1.length){
			    	  var i = parseInt(res.data[0].clongText1)-num1.length;
			    	  for(var j=0;j<i;j++){
			    		  num1 = '0'+num1;
			    	  }
			      }
			   }
			getLsNum(res.data[0],num1);  
		 }
		 
		 function getLsNum(data,num1){
			 $.ajax({
				   type: 'POST',
				   url: '/customer/selcustomer.action',
				   data: {groupName:window.top.getName()},
				   success: function(r){
					   if(r.count){
						   
						   var ls = parseInt(data.cfirstNum) + parseInt(data.cnumlong)*r.count;
						   if(parseInt(data.clongText4)-(ls+'').length>0){
							   for(var i=0;i<parseInt(data.clongText4)-(ls+'').length+1;i++){
								   ls = '0'+ls;
							   }
							   num1 += ls;
							   $("input[name='cCusCode']")[0].value = num1;
						   }

					   }else{						  
						   var ls = '';
						   for(var i=0;i<parseInt(data.clongText4)-data.cfirstNum.length;i++){
							   ls = '0'+ls;
						   }
						   ls += data.cfirstNum;
						   num1 += ls;
						   $("input[name='cCusCode']")[0].value = num1;
					   }
				   }
			   })
		 }
    });
    
 
	
</script> 
<body>
<div id = "toolbar" style="height:50px;width:100%;background: #F8F8F8;"></div>
<div id="postBar" style="height:90%;margin-top:1%;width:99%;display:flex;overflow:auto;">
	<div id ="seeBox" style="width:83%;height:2230px;margin-left:12%;margin-bottom:3%;background: #ffffff;box-shadow: 0 0 10px #000000;">
		<div id = "see" style="width:94%;margin-left:3%;margin-right:4%;margin-top:40px;height:2160px;">	
		</div>
	</div>
</div>
</body>
</html>