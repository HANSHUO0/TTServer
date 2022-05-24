<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>人员通过</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/layuiadmin/layui/css/layui.css" media="all">
</head>
<body>
	<div class="layui-form layui-card-header layuiadmin-card-header-auto">
		<div class="test-table-reload-btn" style="margin-bottom: 10px;">			
			<div class="layui-inline">
				<select id="state" name="state" lay-filter="state">
					<option value="">请选择状态</option>
					<option value="0">申请中</option>
					<option value="1">已通过</option>
			        <option value="2">已拒绝</option>			     
				</select>
			</div>
			<button id="search_btn" class="layui-btn" data-type="reload">搜索</button>
		</div>
	</div>
	<table id="application" lay-filter="test"></table>

	<script type="text/html" id="barDemo">
			     
    </script>
	
	
	<script src="${pageContext.request.contextPath}/layuiadmin/layui/layui.js"></script>
	
	<script>
	    
	layui.use(['table','form'], function(){
		var table = layui.table;
		var form = layui.form;
	    var $ = layui.jquery;
		  //第一个实例
		  table.render({
		    elem: '#application'
		    ,url: '${pageContext.request.contextPath}/sp/selapplication.action?groupID='+window.top.getGroupID()
		    ,page: true //开启分页
		    ,cols: [[ //表头
		       {type: 'checkbox', fixed: 'left'}
		      ,{field: 'id',align:'center', title: 'ID',hide:true}
		      ,{field: 'applicationName',align:'center', title: '申请人'}
		      ,{field: 'applicationPhone',align:'center', title: '申请人电话'}
		      ,{field: 'state',align:'center', title: '状态',templet:function(d){
		    	  if(d.state == 0)return '申请中';if(d.state == 1)return '已通过';if(d.state == 2)return '已拒绝';}}		  
		      ,{field: 'time',align:'center', title: '申请时间',templet: function(d){
		    	  if(d.state == 0)$('#barDemo')[0].innerHTML='<a class="layui-btn layui-btn-xs" lay-event="yes">通过</a><a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="no">拒绝</a>';
		    	  else $('#barDemo')[0].innerHTML='';
		    	  return d.time;
		      }}
		      ,{fixed: 'right', title: '操作框', align:'center',toolbar: '#barDemo'}
		    ]]
		   
		  });
		  
		  
		 
		
			//搜索
			$('#search_btn').click(function(){		
				table.reload('application',{
					where:{
						state: $("#state").val()				    
					},page: {curr: 1}//从第一页开始
				});
			});//只重载数据

		//查询客户详细联系人
		var date='';
		$.post('${pageContext.request.contextPath}/sp/selectCustomerApplication.action',{groupID:window.top.getGroupID(),id:window.top.getID()},function (data){
			$.each(data,function (i,n){
				if (i==1) {
					date += '<option value="' + n.ID + '">'+n.cName+'</option>'
				}else {
					date += '<option value="' + n.ID + '">'+n.cName+'</option>'
				}
			})
		});
			
			
			table.on('tool(test)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）

				
				if(layEvent === 'yes'){ //通过
					
					layer.confirm('确定通过吗<br>' +
							'<select style="width: 80%" id="customer"><option>选择绑定客户</option>'+date+'</select>', function(index){
						if ($("#customer").val()=='选择绑定客户'){
							layer.msg('请选择需要绑定客户',{icon: 1,time: 1500});
						}else {
							$.post('${pageContext.request.contextPath}/sp/editapplication.action',
										{id:data.id,state:1,customerID:$("#customer").val(),userId: window.top.getID()},function(res){
											if(res != 0 )
												layer.msg('已通过',{icon: 1,time: 1500},function (){location.reload()});
											else
												layer.msg('服务超时，稍后再试',{icon: 2,time: 1500},function (){location.reload()});
										});
						}

						});
				}
				if(layEvent === 'no'){ //
					
					layer.confirm('确定拒绝吗', function(index){
						$.post('${pageContext.request.contextPath}/sp/editapplication.action',
								{id:data.id,state:2},function(res){
									if(res != 0 )
										layer.msg('已拒绝',{icon: 1,time: 1500},function (){location.reload()});
									else
										layer.msg('服务超时，稍后再试',{icon: 2,time: 1500},function (){location.reload()});
								});					
					});
				}
				
			});
			
	});

    </script>
	
</body>
</html>