<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>组织</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/layuiadmin/layui/css/layui.css"
	media="all">
</head>
<body>
	<div class="layui-form layui-card-header layuiadmin-card-header-auto">
		<div class="test-table-reload-btn" style="margin-bottom: 10px;">			
			<div class="layui-inline">
				<select id="isDel" name="isDel" lay-filter="isDel">
					<option value="">请选择状态</option>
					<option value="0">已通过</option>
			        <option value="1">申请中</option>
			        <option value="2">已拒绝</option>			     
				</select>
			</div>
			<button id="search_btn" class="layui-btn" data-type="reload">搜索</button>
		</div>
	</div>
	<table id="group" lay-filter="test"></table>

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
		    elem: '#group'
		    ,url: '${pageContext.request.contextPath}/group/selgroup.action'
		    ,page: true //开启分页
		    ,cols: [[ //表头
		       {type: 'checkbox', fixed: 'left'}
		      ,{field: 'cgroupName',align:'center', title: '组织名'}
		      ,{field: 'cgroupAdmin',align:'center', title: '申请人',width:100}
		      ,{field: 'cgroupAdmin',align:'center', title: '管理员',width:100}
		      ,{field: 'cgroupCode',align:'center', title: '组织识别号',width:100}
		      ,{field: 'cgroupPeople',align:'center', title: '组织负责人',width:100}
		      ,{field: 'cgroupPhone',align:'center', title: '联系电话'}
		      ,{field: 'isDel',align:'center', title: '状态',width:80,templet:function(d){
		    	  if(d.isDel == 0)return '已通过';if(d.isDel == 1)return '申请中';if(d.isDel == 2)return '已拒绝';}}
		      ,{field: 'cgroupImg',align:'center', title: '营业执照',width:90,templet: function(d){
		    	  return '<img class="layui-upload-img"  id="ioimg" width="40" height="40"/>'
		      }}
		      ,{field: 'cgroupAddress',align:'center', title: '地址'}
		      ,{field: 'createDate',align:'center', title: '申请时间',templet: function(d){
		    	  if(d.isDel == 1)$('#barDemo')[0].innerHTML='<a class="layui-btn layui-btn-xs" lay-event="yes">通过</a><a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="no">拒绝</a>';
		    	  else $('#barDemo')[0].innerHTML='';
		    	  return d.createDate;
		      }}
		      ,{fixed: 'right', title: '操作框', align:'center',toolbar: '#barDemo'}
		    ]]
		   
		  });
		  
		  
		  var status;
		 	form.on('select(isDel)', function(data){
		    	status = data.value;
		    });
		
			//搜索
			$('#search_btn').click(function(){		
				table.reload('group',{
					where:{
						isDel: status				    
					},page: {curr: 1}//从第一页开始
				});
			});//只重载数据
			
			
			
			table.on('tool(test)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				
				if(layEvent === 'yes'){ //通过
					
					layer.confirm('确定通过吗', function(index){
						$.post('${pageContext.request.contextPath}/group/editgroup.action',
									{IsDel:0,cGroupCode:data.cgroupCode,cGroupName:data.cgroupName},function(res){
										if(res.msg == '修改成功')
											layer.msg('审核通过',{icon: 1,time: 1500},function (){location.reload()});
										else
											layer.msg('服务超时，稍后再试',{icon: 2,time: 1500},function (){location.reload()});
									});
						});
				}
				if(layEvent === 'no'){ //通过
					
					layer.confirm('确定拒绝吗', function(index){
						$.post('${pageContext.request.contextPath}/group/editgroup.action',
									{IsDel:2,cGroupCode:data.cgroupCode},function(res){
										if(res.msg == '修改成功')
											layer.msg('拒绝成功',{icon: 1,time: 1500},function (){location.reload()});
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