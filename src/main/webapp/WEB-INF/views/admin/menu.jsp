<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>树组件</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/DHX/dhtmlx.css" media="" />
	<script src="${pageContext.request.contextPath }/layuiadmin/layui/layui.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath }/layuiadmin/layui/css/layui.css" media="all">
    <script src="${pageContext.request.contextPath}/DHX/dhtmlx.js"></script>
    <script src="${pageContext.request.contextPath }/layuiadmin/jquery.js"></script>
    <style type="text/css">
		body{
			display: flex;
		}
	}
		
	</style>
</head>
<body>
  <div style="width:30%;height:100%" id ="treeBox">
  
  </div>
  <div style="width:50%;height:100%;">
  <form class="layui-form" id="frm">
		<div id="test1"></div>
		<div class="layui-form-item">
			<div class="layui-input-block">
				<button class="layui-btn" lay-submit lay-filter="edRole">立即提交</button>
				<button type="reset" class="layui-btn layui-btn-primary">重置</button>
			</div>
		</div>
	</form>
	</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/layuiadmin/layui/layui.js"></script>


  <script>
  
  
 
  var mytree = new dhtmlXTreeObject("treeBox","100%","100%",0);
  mytree.setImagePath("../DHX/imgs/dhxtree_terrace/");
  mytree.enableCheckBoxes(false, false);
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
				    			
				    		}
				    		
				    	}
		   		})				   		
	    	}
     });
  
  
	mytree.attachEvent("onClick", function(id){
		layui.use(['tree','form'], function(){
		    var tree = layui.tree;
		    var form = layui.form;
			var $ = layui.jquery;

			
		    //渲染
		    	$.ajax({
					type: 'POST',
					url: '${pageContext.request.contextPath}/menu/selmenugroup.action',				
					data: {UserID:id, cGroupName:window.top.getName()},
					success: function(res){
						
						var inst1 = tree.render({
							elem: '#test1',
							data: res,
							id: 'test1',
							showCheckbox: true
						})
					}
								
		    	})
		    	
		    layui.use('form', function(){
		    	form.on('submit(edRole)', function(data){   		
		    		var checkData = tree.getChecked("test1");
		    		var menuids = '';
		    		for(let menu of checkData){
		    			menuids = menuids + menu.id +',';
		    			
		    			for(let children of menu.children){
		    				menuids = menuids + children.id +',';
		    				 	if(children.children.length != 0){
		    				 		for(let children2 of children.children){
		    				 			menuids = menuids + children2.id + ',';
		    				 		}	
		    				 	}	
		    			}
		    		}
		 			
		    		menuids = menuids.slice(0,menuids.length-1);
		    		
		   			$.ajax({
		       			type: 'POST',
		       			url: '${pageContext.request.contextPath}/menu/editmenu.action',				
		       			data: {UserID:id, GroupID:window.top.getGroupID(),Menuids:menuids},
		       			success: function(res){
		       			 layer.msg('修改成功',{
							   icon: 1,
							   time: 1000
						   },function(){
							   var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
							   parent.layer.close(index); //再执行关闭  
						   })
		       			  
		       			}
		       						
		           	})
		    			return false;
		    			
		    		}); 
		    	 });
		    	
		});
	});
  
  
  
  
 
  </script>
</body>
</html>