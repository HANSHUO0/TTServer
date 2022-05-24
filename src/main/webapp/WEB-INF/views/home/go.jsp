<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>预览界面</title>

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/fonts/font_awesome/css/font-awesome.min.css" media="" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
  	<script src="${pageContext.request.contextPath}/layuiadmin/jquery.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/jquery.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/Scripts/json2.js"></script>
  	<script src="${pageContext.request.contextPath}/Scripts/jquery.form.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/jquery.cookie.js"></script>
    <script src="${pageContext.request.contextPath}/Scripts/DateFormat.js"></script>
 	<script src="${pageContext.request.contextPath}/Scripts/spin.js"></script>
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.extensions.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/Scripts/jquery-ui.js"></script>
    <style>
	    html, body {
	        width: 100%;
	        height: 100%;
	        margin: 0px;
	        overflow:auto;
	        background:#F8F8F8;
	        display:flex;
	    }
	
  	</style>
  	
	<script type="text/javascript">
    $(function () {

    	var length;
		var myLayout = new dhtmlXLayoutObject("see", "1C");
		myLayout.cells("a").hideHeader();
		myLayout.cells("a").setHeight(3000);
		$.ajax({
				   type: 'POST',
				   url: '/design/seldesign3.action',
				   data: {DesignName:"${data}"},
				   
				   success: function(res){		
					   var data = JSON.parse(res[0].design);
					   var layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);					   
					  
					   if(res[0].positioningBar!=null&&res[0].positioningBar!=''){
							  var box = document.getElementById("seeBox");
							  box.style.cssText = "width:75%;height:2800px;margin-top:2.5%;margin-bottom:2%;box-shadow: 0 0 10px #a0a0a0;";	
							  
							  var page = myLayout.cells("a").getAttachedObject();
							  for(var i =0;i< page.items.length;i++){
							  	page.items[i].cell.style.width = box.offsetWidth -20 +"px";
							  	if(page.items[i].cell.children[2]){
							  		page.items[i].cell.children[2].children[0].style.width = box.offsetWidth -20 +"px";
								  	//page.items[i].cell.children[2].style.width = box.offsetWidth -20 +"px";
							  	}
							  	if(page.items[i].cell.children[1].children[0]){
							  		page.items[i].cell.children[1].style.width = box.offsetWidth -19 +"px";
							  	}
							  	
							  }
							  var dom = document.createElement('div'); 
	                    	  dom.id = "PositioningBar";
	                    	  dom.style.cssText = "width:9%;height:90%;margin-left:10%;margin-top:2.5%;";                   	
	                    	  document.body.appendChild(dom);
	                    	  $("#PositioningBar").after($("#seeBox"));
	                    	  
	                    	  var list = res[0].positioningBar.split(",");
	                    	  length = list.length-1;
	                    	  for(var i = 0;i < list.length-1;i++){
	                    		  
	                    		  var button = document.createElement("input");
	                    		  button.setAttribute("type", "button");
	                    		  button.setAttribute("value", list[i]);
	                    		  button.setAttribute("id", i+1);
	                    		  button.style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
	                    		  button.onclick = function(event) {b1(event);};        
	                    		  
	                    		  document.getElementById("PositioningBar").appendChild(button);

	                    		  $("#1").click(function(){		                    		
		                    		 document.getElementById("1").style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;background:#66CC33";
		                   		   });
	                    	  }
					   }
					   
					   
					 
					   
				   }
			});
		
		
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
		    	    	document.getElementById("seeBox").scrollTop = 0;
		    	    	break;
		    	    }
		    	    case 2:{
		    	    	document.getElementById("seeBox").scrollTop = first+10;
		    	    	break;
		    	    }
		    	    case 3:{
		    	    	document.getElementById("seeBox").scrollTop = first + model2.children[0].clientHeight + 20;
		    	    	break;
		    	    }
		    	    case 4:{
		    	    	document.getElementById("seeBox").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight + 30;
		    	    	break;
		    	    }
		    	    case 5:{
		    	    	document.getElementById("seeBox").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + 40;
		    	    	break;
		    	    }
		    	    case 6:{
		    	    	document.getElementById("seeBox").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + height5 + 50;
		    	    	break;
		    	    }
		    	    case 7:{
		    	    	document.getElementById("seeBox").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + height5 + model6.children[0].clientHeight + 60;
		    	    	break;
		    	    }
		    	    case 8:{
		    	    	document.getElementById("seeBox").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
		    	    	+ model4.children[0].clientHeight + height5 + model6.children[0].clientHeight + model7.children[0].clientHeight + 70;
		    	    	break;
		    	    }
	    	    }
		}
        
        
        
        function buttonLength(o){
        	for(var i=1;i<=length;i++){
        		if(i == o){
        			document.getElementById(i).style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;background:#66CC33";
        		}
        		else{
        			document.getElementById(i).style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
        		}
        	}
        }
        
        

		$('#seeBox').scroll(function(event){
			 var toTop = $('#seeBox').scrollTop();
			 
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
	   	    	document.getElementById("3").style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
	   	    	buttonLength(2);
	   	    }
	   	    if(first+first2+19 < toTop && toTop < first+first2+height3 && length >=3){
	   	    	if(document.getElementById("4"))
	   	    	document.getElementById("4").style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
	   	    	buttonLength(3);
	   	    }
		   	if(first+first2+height3+29 < toTop && toTop < first+first2+height3+height4 && length >=4){
	   	    	if(document.getElementById("5"))
	   	    	document.getElementById("5").style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
	   	    	buttonLength(4);
		   	}
		   	if(first+first2+height3+height4+39 < toTop && toTop < first+first2+height3+height4+height5 && length >=5){
	   	    	if(document.getElementById("6"))
	   	    	document.getElementById("6").style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
	   	    	buttonLength(5);
		   	}
		   	if(first+first2+height3+height4+height5 < toTop && toTop < first+first2+height3+height4+height5+height6 && length >=6){
	   	    	if(document.getElementById("7"))
	   	    	document.getElementById("7").style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
	   	    	buttonLength(6);
		   	}
		   	if(first+first2+height3+height4+height5+height6 <= toTop && toTop < first+first2+height3+height4+height5+height6+height7 && length >=7){
	   	    	if(document.getElementById("8"))
	   	    	document.getElementById("8").style.cssText = "margin-top:20%;width:90%;height:5%;border-radius: 5px;border:none;";
	   	    	buttonLength(7);
		   	}
		   	if( toTop > 2100){	   	    	
		   		buttonLength(8);
		   	}
	     });
        
    });

</script>
</head>
<body>
<div id ="seeBox" style="width:75%;height:2800px;margin-left:15%;margin-top:2.5%;margin-bottom:2%;box-shadow: 0 0 10px #a0a0a0;">
	<div id = "see" style="width:100%;height:2800px;"> </div>
</div>

</body>
</html>