<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>部门权限</title>
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
	        padding-top:10px;
	        overflow: hidden;
	        background: #eaeaea;
	    }
		
  	</style>
<body>

<div id="gridbox" style="margin-left:20px;width:calc(100% - 40px);height:calc(100% - 40px)"></div>
<script type="text/javascript">
  		var layout;
		var myLayout = new dhtmlXLayoutObject("gridbox", "1C");
		myLayout.cells("a").hideHeader();

		   $.ajax({
			   type: 'POST',
			   url: '/design/seldesign3.action',
			   data: {DesignName:"设计部门权限"},
			   success: function(res){		
				   var data = JSON.parse(res[0].design);
				   layout = dhtmlx.layout(data,myLayout.cells("a"),res[0].designName);
				  
				   var tree = layout.lays[0].cells("a").attachTree();
				   tree.setImagePath("../DHX/imgs/dhxtree_terrace/");
				   
				 	//加载组织树
					$.ajax({
					    	type: 'POST',
					    	url: '${pageContext.request.contextPath}/department/seldepartment.action',
					    	data:{groupID:window.top.getGroupID()},
					    	success: function(res){
					    		if(res.data[0].listData){
					    			tree.parse($.parseJSON(res.data[0].showData),"json");
					    		}
					    	}
				      });
				 	
					   var tree2 = layout.lays[0].cells("b").attachTree();
					   tree2.setImagePath("../DHX/imgs/dhxtree_terrace/");
					   tree2.setIconsPath(""); 
					   tree2.enableCheckBoxes(true, true);
					   
					   var treeArray = new Array(["1","0","部门权限"],["bxy","1","报修员"],["hfy","1","回访员"]);	
					   tree2.parse(treeArray, "jsarray");
					   tree2.showItemCheckbox("1", false);
					   tree2.openAllItems("1");
					   
					   
					   tree.attachEvent("onClick", function(id){
						   $.ajax({
						    	type: 'POST',
						    	url: '/role/selrole.action',
						    	data:{groupID:window.top.getGroupID(),depID:id},
						    	success: function(res){
						    		if(res.data){
						    			for(var i of tree2.getAllChecked().split(',')){
						    				tree2.setCheck(i,0);
						    			}
						    			for(var i of res.data){
						    				tree2.setCheck(i.roleID,1);
						    			}					    			
						    		}else{
						    			for(var i of tree2.getAllChecked().split(',')){
						    				tree2.setCheck(i,0);
						    			}
						    		}
						    	}
					    	})
					   })
					   
					   var myToolbar = layout.lays[0].cells("b").TBar;
					   myToolbar.attachEvent("onClick", function(id){
							if(id == 'saves'){
								if(tree.getSelectedItemId()!=''){						    		
						    		$.ajax({
								    	type: 'POST',
								    	url: '/role/editrole.action',
								    	data:{groupID:window.top.getGroupID(),depID:tree.getSelectedItemId(),ids:tree2.getAllChecked()}
						    		})
						    	}else{
						    		dhtmlx.alert('未选择部门!');
						    	}
							}   
					   });
			   }
			});
	
		


</script> 
</body>
</html>