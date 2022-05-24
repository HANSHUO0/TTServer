<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>档案编码设计</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
    <script type="text/javascript">
    var layout;
    $(function () {
		var myLayout = new dhtmlXLayoutObject("see", "1C");
									 
			   $.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"设计档案编码设置"},
				   success: function(res){		
					   var data = JSON.parse(res[0].design);
					   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);
					   var toolbar = layout.lays[0].cells("b").getAttachedToolbar();
					   
					   toolbar.attachEvent("onClick", function(id){
						   if(id == 'saves'){
							   if(tree.getSelectedItemText() ==''){
								   dhtmlx.alert('未选择基础档案');
							   }else if($("input[name='cLongText1']")[0].value ==''||$("input[name='cFirstNum']")[0].value==''||$("input[name='cNumlong']")[0].value==''){
								   dhtmlx.alert('流水号信息不能为空');
							   }else{
								   var data = {};
								   data['cArchivesName'] = tree.getSelectedItemText();
								   data['groupName'] = window.top.getName();
								   data['createUserID'] = window.top.getID();
								   data['cFirst'] = $("select[name='cFirst']")[0].value;
								   data['cSecond'] = $("select[name='cSecond']")[0].value;
								   data['cThird'] = $("select[name='cThird']")[0].value;
								   data['cLongText1'] = $("input[name='cLongText1']")[0].value;
								   data['cLongText2'] = $("input[name='cLongText2']")[0].value;
								   data['cLongText3'] = $("input[name='cLongText3']")[0].value;
								   data['cLongText4'] = $("input[name='cLongText4']")[0].value;
								   data['cFirstNum'] = $("input[name='cFirstNum']")[0].value;
								   data['cNumlong'] = $("input[name='cNumlong']")[0].value;
								   data['cFirstName'] = $("input[name='cFirstName']")[0].value;
								   data['cSecondName'] = $("input[name='cSecondName']")[0].value;
								   data['cThirdName'] = $("input[name='cThirdName']")[0].value;
								   data['cShowNum'] = $("input[name='cShowNum']")[0].value;
								   $.ajax({
									   type: 'POST',
									   url: '/increaserules/selincreaserules.action',
									   data: data,
									   success: function(res){	
										  if(res.data){
											  $.ajax({
												   type: 'POST',
												   url: '/increaserules/editincreaserules.action',
												   data: data,
												   success: function(res){	
													   dhtmlx.alert('保存成功');
												   }
												})
										  }else{
											  $.ajax({
												   type: 'POST',
												   url: '/increaserules/addincreaserules.action',
												   data: data,
												   success: function(res){	
													   dhtmlx.alert('保存成功');
												   }
												})
										  }
										  
									   }
									})
								 
								  
							   }
						   }
					   })
					   
					   var tree = layout.lays[0].cells("a").attachTree();
					   tree.setImageArrays("plus","","","","plus.gif");
					   tree.setImageArrays("minus","","","","minus.gif");
					   tree.setImagePath("../DHX/imgs/dhxtree_terrace/");
					   var data = {"id":"0", "item":[{ "id":"976590D2-70EE-49D9-9750-7FEA963F321C","open":"1","text":"基础档案","item":[{ 
					"id":"7566EAC0-016A-4AA1-986C-D09104533FF4","text":"人员档案"},{ "id":"494031CE-BCD4-494E-8988-7CCE00F52811",  "text":"新增客户"}]}]};
					   tree.parse(data,"json");
					   
					    //点击树事件
		    			tree.attachEvent("onClick", function(id){
		    				if(id != "1"){
		    					selectChange($("select[name='cFirst']"),$("input[name='cLongText1']"),$("input[name='cFirstName']"));
		    					selectChange($("select[name='cThird']"),$("input[name='cLongText3']"),$("input[name='cThirdName']"));
		    					selectChange($("select[name='cSecond']"),$("input[name='cLongText2']"),$("input[name='cSecondName']"));
		    					
								   $.ajax({
									   type: 'POST',
									   url: '/increaserules/selincreaserules.action',
									   data: {cArchivesName:tree.getSelectedItemText(),groupName:window.top.getName()},
									   success: function(res){	
										  if(res.data){
											  for(var i of $("select[name='cFirst']")[0].options){
												  if(i.value == res.data[0].cfirst){
													  i.selected = true;																						  
													  break;
												  }
											  }
											  for(var i of $("select[name='cSecond']")[0].options){
												  if(i.value == res.data[0].csecond){
													  i.selected = true;													 											 
													  break;
												  }
											  }
											  for(var i of $("select[name='cThird']")[0].options){
												  if(i.value == res.data[0].cthird){
													  i.selected = true;													 
													  break;
												  }
											  }
											  $("input[name='cLongText1']")[0].value = res.data[0].clongText1;
											  $("input[name='cLongText2']")[0].value = res.data[0].clongText2;
											  $("input[name='cLongText3']")[0].value = res.data[0].clongText3;
											  $("input[name='cLongText4']")[0].value = res.data[0].clongText4;
											  $("input[name='cNumlong']")[0].value = res.data[0].cnumlong;
											  $("input[name='cFirstNum']")[0].value = res.data[0].cfirstNum;
											  $("input[name='cFirstName']")[0].value = res.data[0].cfirstName;
											  $("input[name='cSecondName']")[0].value = res.data[0].csecondName;
											  $("input[name='cThirdName']")[0].value = res.data[0].cthirdName;
											  $("input[name='cShowNum']")[0].value = res.data[0].cshowNum;
										  }else{
											  $("input[name='cLongText1']")[0].value = '0';
											  $("input[name='cLongText2']")[0].value = '0';
											  $("input[name='cLongText3']")[0].value = '0';
											  $("input[name='cLongText4']")[0].value = '';
											  $("input[name='cNumlong']")[0].value = '';
											  $("input[name='cFirstNum']")[0].value = '';
											  $("input[name='cFirstName']")[0].value = '';
											  $("input[name='cSecondName']")[0].value = '';
											  $("input[name='cThirdName']")[0].value = '';
											  $("input[name='cShowNum']")[0].value = '';
										  }
									   }
								   })
								   
		    					var flag = true,flag2=true,flag3=true;
		    					jtlong($("input[name='cLongText1']"),flag);
		    					jtlong($("input[name='cLongText2']"),flag2);
		    					jtlong($("input[name='cLongText3']"),flag3);
		    					xiushuihao();
		    				}		    				
		    			}) 
		    		  
					   window.onresize = function(){
						   var a = $('#see')[0].clientWidth||$('#see')[0].offsetWidth;
						   layout.lays[0].cells("b").cell.parentNode.style.width = a+'px';
						   layout.lays[0].cells("b").cell.parentNode.parentNode.parentNode.style.width = a+'px';
						   layout.lays[0].cells("b").cell.children[2].style.width = (a-300)+'px';
						   layout.lays[0].cells("b").cell.style.width = (a-300)+'px';
						   myLayout.cells("a").cell.parentNode.style.width = a +'px';
						   myLayout.cells("a").cell.style.width = a +'px';
					   }
					   
				   }
				});
		   
		
		
		 function selectChange(a,b,c){
			 a[0].options.length=0;
			 a[0].add(new Option('',''));
			 a[0].add(new Option("客户分类编码","cCCCode")); 
			 a[0].add(new Option("归属地区编码","cDCCode"));
			 a[0].add(new Option("部门分类编码","cDepCode"));
			 a[0].add(new Option("客户等级编码","cCusVIP"));
			 a[0].add(new Option("客户来源编码","cInfoSource"));
			 a.change(function(){
				   var index = a[0].selectedIndex;
				   var text = a[0].options[index].text;
				   c[0].value = text;
				   if(text=='')
					   b[0].value = 0;
				   else					   
				   	   b[0].value = 2;
				  
				   var starNum = parseInt($("input[name='cLongText1']")[0].value) +parseInt($("input[name='cLongText2']")[0].value) +parseInt($("input[name='cLongText3']")[0].value);
				  
				   var starText='';
	           		for(var i =0;i<starNum;i++){
	           			starText += '*';
	           		} 
	           		var lsNum = $("input[name='cShowNum']")[0].value;
	  
	           		if(lsNum!=''){
	           			$("input[name='cShowNum']")[0].value = starText +lsNum.replace(/[^0-9]/ig,"");
	           		}
	           		else
	           			$("input[name='cShowNum']")[0].value = starText;
				 });	
		 }
		
		function jtlong(a,flag){
			a.on('compositionstart',function(){
	            flag = false;
	        })
	         a.on('compositionend',function(){
	            flag = true;
	        })
	         a.on('input',function(){
	            setTimeout(function(){
	                if(flag){                    
	                	var starNum = parseInt($("input[name='cLongText1']")[0].value) +parseInt($("input[name='cLongText2']")[0].value) +parseInt($("input[name='cLongText3']")[0].value);
		           		var starText='';
		           		for(var i =0;i<starNum;i++){
		           			starText += '*';
		           		}
		           		$("input[name='cShowNum']")[0].value = starText + $("input[name='cShowNum']")[0].value.replace(/[^0-9]/ig,"");
	                }
	            },0)
	        })
		}
		
		function xiushuihao(){
			 var flag = true,flag2=true,flag3=true;
			 onlyOnce($("input[name='cLongText4']"),$("input[name='cLongText4']"),$("input[name='cFirstNum']"),$("input[name='cNumlong']"),flag);
			 onlyOnce($("input[name='cFirstNum']"),$("input[name='cLongText4']"),$("input[name='cFirstNum']"),$("input[name='cNumlong']"),flag2);
			 onlyOnce($("input[name='cNumlong']"),$("input[name='cLongText4']"),$("input[name='cFirstNum']"),$("input[name='cNumlong']"),flag3);
		}
		function onlyOnce(a1,a,b,c,flag){
			a1.on('compositionstart',function(){
	            flag = false;
	        })
	         a1.on('compositionend',function(){
	            flag = true;
	        })
	         a1.on('input',function(){
	            setTimeout(function(){
	                if(flag){                    
	                    if((b[0].value)!=''&&c[0].value!=''){
	                    	var length = b[0].value.length;
	                    	if(parseInt(a[0].value)>=parseInt(length)){
	                    		var num = parseInt(a[0].value) - parseInt(length);
	                    		var number='';
	                    		for(var i =0;i<num;i++){
	                    			number += '0';
	                    		}
	                    		var starNum = parseInt($("input[name='cLongText1']")[0].value) +parseInt($("input[name='cLongText2']")[0].value) +parseInt($("input[name='cLongText3']")[0].value);
	                    		var starText='';
	                    		for(var i =0;i<starNum;i++){
	                    			starText += '*';
	                    		}
	                    		
	                    		$("input[name='cShowNum']")[0].value = starText + number + b[0].value;
	                    	}
	                    }
	                }
	            },0)
	        })
		}
    })
    </script>
<body>
<div id = "see" style = "width:100%;height:600px;overflow: auto;background:#E0E0E0;"></div>
</body>
</html>