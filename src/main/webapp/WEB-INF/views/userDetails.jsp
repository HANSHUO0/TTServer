<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>设置我的资料</title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
  <link rel="stylesheet" href="../../../layuiadmin/layui/css/layui.css" media="all">
  <link rel="stylesheet" href="../../../layuiadmin/style/admin.css" media="all">
  <link id="layuicss-layer" rel="stylesheet" href="https://www.layui.com/admin/std/dist/layuiadmin/layui/css/modules/layer/default/layer.css?v=3.1.1" media="all">
  <style type="text/css">
		 html, body {
            width: 100%;
            height: 100px;
            margin: 0px;              
        }

  </style>
</head>
<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
      <div class="layui-col-md12">
        <div class="layui-card">
          <div class="layui-card-header" style=" text-align: center;font-size:25px">设置</div>
          <div class="layui-card-body" style="display:flex;">
				<div style="width:15%;height:500px;text-align:center;border-right:1px solid #C0C0C0;">个人资料</div>
				<div style="width:85%;height:800px;overflow-y:scroll;display:flex;">
					<div class="layui-form">
						<div class="layui-form-item" >
			              <label class="layui-form-label">手机号<h style="color:red">*</h></label>
			              <div class="layui-input-inline">
			               	<input name="mobilePhone" type="tel" value="" readonly  class="layui-input">
			              </div>
			            </div>            
			            <div class="layui-form-item">
			              <label class="layui-form-label">用户名称<h style="color:red">*</h></label>
			              <div class="layui-input-inline">
			                <input type="text" name="psnName" lay-verify="required" value=""class="layui-input">
			              </div>
			            </div>       
			            <div class="layui-form-item">
			              <label class="layui-form-label">花名</label>
			              <div class="layui-input-inline">
			                <input type="text" name="emName" value=""class="layui-input">
			              </div>
			            </div>             
			            <div class="layui-form-item">
			              <label class="layui-form-label">性别<h style="color:red">*</h></label>
			              <div class="layui-input-block">
			                <input type="radio" name="sex" value="男" title="男" >
			                <input type="radio" name="sex" value="女" title="女" >
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">婚姻<h style="color:red">*</h></label>
			              <div class="layui-input-block">
			                <input type="radio" name="marriage" value="已婚" title="已婚" >
			                <input type="radio" name="marriage" value="未婚" title="未婚" >
			              </div>
			            </div>
			            
				   		<div class="layui-form-item">
			              <label class="layui-form-label">邮箱<h style="color:red">*</h></label>
			              <div class="layui-input-inline">
			                <input type="text" name="email" value=""  autocomplete="off" lay-verify="email" autocomplete="off" class="layui-input layui-form-danger">
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">QQ号码</label>
			              <div class="layui-input-inline">
			                <input type="tel" name="qq" value=""  autocomplete="off" class="layui-input">
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">生日<h style="color:red">*</h></label>
			              <div class="layui-input-inline">
			                <input type="text" name="birthday" value="" id="birthday" autocomplete="off" class="layui-input layui-form-danger">
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">地址</label>
			              <div class="layui-input-inline">
			                <input type="text" name="address" value=""  autocomplete="off" class="layui-input">
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">身份证号<h style="color:red">*</h></label>
			              <div class="layui-input-inline">
			                <input type="text" name="identity" value=""  autocomplete="off" lay-verify="identity"  class="layui-input layui-form-danger">
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">紧急联系人</label>
			              <div class="layui-input-inline">
			                <input type="text" name="sosName" value=""  autocomplete="off" class="layui-input">
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">紧急联系方式</label>
			              <div class="layui-input-inline">
			                <input type="tel" name="sosPhone" value=""  autocomplete="off" class="layui-input">
			              </div>
			            </div>
			            <div class="layui-form-item">
			              <label class="layui-form-label">备注</label>
			              <div class="layui-input-inline">
			                <input type="text" name="signature" value=""  autocomplete="off" class="layui-input">
			              </div>
			            </div>
			            <div class="layui-form-item">
							<div class="layui-input-block">
								<button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
							</div>
			  			</div>
			        </div>
			         <div class="layui-form" >
			           	<div class="layui-form-item">
			              <label class="layui-form-label">头像</label>
			            	<img class="layui-upload-img" src="" id="ioimg" style="width:100px;height:100px;margin-bottom:10px;">
						</div>
						<div class="layui-form-item">
							<input type="text" name="headImageData" id="headImageData" value="" style="display:none">
							<button type="button" style=" float:right;" class="layui-btn layui-btn-normal" id="test1"><i class="layui-icon">&#xe67c;</i>选择图片</button>
						</div>
					</div>
				</div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="../../../layuiadmin/layui/layui.js"></script>
  <script src="/layuiadmin/jquery.js"></script>  
  <script>
  layui.config({
    base: '../../../layuiadmin/' //静态资源所在路径
  }).extend({
    index: 'lib/index' //主入口模块
  }).use(['index', 'set']);
  </script>
<script type="text/javascript">
		   layui.use(['form','upload','laydate'], function(){
			   var form = layui.form;
			   var $ = layui.jquery;
			   var laydate = layui.laydate;
			   var upload = layui.upload;
				
			   var a = window.top.getUser();
			   var ID = window.top.getID();


			   laydate.render({
				    elem: '#birthday' //指定元素
				  });


			   upload.render({
				   elem: '#test1'
				   ,url: '${pageContext.request.contextPath}/upload/uploadimg.action'
				   ,auto: true //选择文件后自动上传，将图片地址存到img中
				   ,bindAction: '#test9' //指向一个按钮触发上传
				   ,acceptMime: 'image/*'//只显示图片
				   ,choose: function(obj){
				     //将每次选择的文件追加到文件队列
				     var files = obj.pushFile();
				     
				     //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
				     obj.preview(function(index, file, result){
				      // console.log(index); //得到文件索引
				      // console.log(file); //得到文件对象
				      // console.log(result); //得到文件base64编码，比如图片
				       $('#ioimg').attr('src',result);
						// window.top.setImg();
				     });
				   }
			   	   ,done: function(res, index, upload){
					   if(res.code == 200){
			   	      //将res返回的图片链接保存到表单的隐藏域
			   	    	// $('#headImageData').attr('value',res.data.src);
						   $('#headImageData').val(res.data.src);
						   // upload.render();
			   	    	}



				   }
				 });      
			 		   
			   //获取性别
			   var s = $("input[name='sex']");
			   for(let i=0;i<s.length;i++){
				   if(s[i].value == a.sex){   
					   s[i].setAttribute('checked','checked');
					   form.render('radio');
				   }
			   }
			 //获取婚姻
			   var b = $("input[name='marriage']");
			   for(let j=0;j<b.length;j++){
				   if(b[j].value == a.marriage){   
					   b[j].setAttribute('checked','checked');
					   form.render('radio');
				   }
			   }
			   
			  $("input[name='psnName']")[0].value = a.name;
			  $("input[name='emName']")[0].value = a.emName;
			  $("input[name='mobilePhone']")[0].value = a.phone;
			  $("input[name='email']")[0].value = a.email;
			  $("#ioimg")[0].src = '${pageContext.request.contextPath}/img/1.jpg';
			  $("input[name='qq']")[0].value = a.qq;
			  $("input[name='identity']")[0].value = a.identity;
			  $("input[name='signature']")[0].value = a.signature;
			  $("input[name='address']")[0].value = a.address;
			  $("input[name='birthday']")[0].value = a.birthday;
			  $("input[name='sosName']")[0].value = a.sosName;
			  $("input[name='sosPhone']")[0].value = a.sosPhone;

	  form.on('submit(formDemo)', function(data){


		    data.field.ID = ID;
			data.field.HeadImageData=$('#headImageData').val();
		    $.ajax({
				   type: 'POST',
				   url: '/user/edituser.action',
				   data: data.field,
				   async:false,
				   success: function(res){
					   layer.msg('修改成功',{
						   icon: 1,
						   time: 1000
					   },function(){
						 //当你在iframe页面关闭自身时
						   var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
						   parent.layer.close(index); //再执行关闭  
						   parent.location.reload();
					   });
				   }
			   }); 
				   return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
			 });
			  
		  });
		   
		</script>

</body>
</html>