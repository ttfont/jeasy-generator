<#assign dateTime = .now>
<!DOCTYPE html>
<html>
<head>
	<meta content="text/html;charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta http-equiv ="Pragma" content = "no-cache"/>
	<meta http-equiv="Cache-Control" content="no cache" />
	<meta http-equiv="Expires" content="0" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
	<meta name="apple-mobile-web-app-status-bar-style" content="black"/>
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<meta name="format-detection" content="telephone=no"/>
	<script src="https://cdn.bootcss.com/pace/1.0.2/pace.min.js"></script>
	<link href="https://cdn.bootcss.com/pace/1.0.2/themes/pink/pace-theme-flash.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../plugins/layui/css/layui.css">
	<script type="text/javascript" src="../plugins/layui/layui.js"></script>
	<script type="text/javascript" src="../plugins/jquery/jquery.min.js"></script>
</head>
<body>
	<div style="padding:15px;" >
	    <input type="hidden" name="id" >
		<form class="layui-form" action="">
		<#list tableClass.allFields as fields>
		 <#if fields.jdbcType == "TIMESTAMP">  
		  <div class="layui-form-item">
			<div class="layui-inline">
			  <label class="layui-form-label">${fields.remarks}</label>
			  <div class="layui-input-inline">
				<input type="text" name="${fields.fieldName}" class="layui-input" id="${fields.fieldName}LayUI">
			  </div>
			</div>
		  </div>
		<#elseif  fields.jdbcType == "TINYINT">  
		  <div class="layui-form-item">
		   <div class="layui-inline">
				<label class="layui-form-label">${fields.remarks}</label>
				<div class="layui-input-block">
				  <input type="checkbox" name="${fields.fieldName}" value="0" lay-skin="switch" lay-text="启用|禁用">
				</div>
			</div>
		  </div>
		<#elseif fields.length gte 128>  
		  <div class="layui-form-item layui-form-text">
			<label class="layui-form-label">${fields.remarks}</label>
				<div class="layui-input-block">
				  <textarea name="${fields.fieldName}" lay-verify="required" placeholder="${fields.remarks}" class="layui-textarea"></textarea>
				</div>
			
		  </div>
		<#else>  
		  <div class="layui-form-item">
			<div class="layui-inline">
			  <label class="layui-form-label">${fields.remarks}</label>
			  <div class="layui-input-inline">
				<input type="text" name="${fields.fieldName}"  lay-verify="required" class="layui-input">
			  </div>
			</div>

		  </div>
		</#if> 

		</#list>	
		 
		  <div class="layui-form-item" >
			<div class="layui-input-block">
			  <button class="layui-btn" lay-submit lay-filter="formInput">立即提交</button>
			  <button type="reset" class="layui-btn layui-btn-primary">重置</button>
			</div>
		  </div>
		</form>
 	</div>
 	 
<script>
layui.use(['form','laydate'], function(){
  var form = layui.form;
  var laydate = layui.laydate;
<#list tableClass.allFields as fields>
 <#if fields.jdbcType == "TIMESTAMP">  
   //执行一个laydate实例
  laydate.render({
     elem: '#${fields.fieldName}LayUI' //指定元素
	,format: 'yyyy-MM-dd HH:mm:ss'
  });

</#if> 
</#list>	
  
  form.on('submit(formInput)', function(data){
	layer.msg(JSON.stringify(data.field));
	
		
    
	
    return false;
  });
});
</script>

</body>
</html>
