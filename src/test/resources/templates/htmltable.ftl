<#assign dateTime = .now> 
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<title>表格操作 - layui</title>
<link rel="stylesheet" type="text/css" href="plugins/layui/css/layui.css">
<style>
body{padding: 10px; /*overflow-y: scroll;*/}
</style>
</head>
<body>
<form class="layui-form layui-form-pane" action="">

  <div class="layui-form-item">
<#list tableClass.allFields as fields>
<#if fields.jdbcType == "TIMESTAMP">  
	<div class="layui-inline">
      <label class="layui-form-label">${fields.remarks}</label>
      <div class="layui-input-inline">
        <input type="text" name="${fields.fieldName}" class="layui-input" id="${fields.fieldName}LayUI">
      </div>
	</div>			
<#elseif fields.length lte 64>  
	<div class="layui-inline">
      <label class="layui-form-label">${fields.remarks}</label>
      <div class="layui-input-inline">
        <input type="text" name="${fields.fieldName}" class="layui-input">
      </div>
	</div>			
</#if>
</#list>
	<div class="layui-inline">
      <button class="layui-btn" lay-submit="" lay-filter="search">搜索</button>
      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
    </div>
  </div>
</form>

<div class="layui-btn-group" id="lbglayer">
  <button class="layui-btn" data-method="setAdd" ><i class="layui-icon">&#xe654;</i>新增</button>
  <button class="layui-btn" data-method="setEdit"><i class="layui-icon">&#xe642;</i>修改</button>
  <button class="layui-btn layui-btn-danger"  data-method="setDel"><i class="layui-icon">&#xe640;</i>批量删除</button>
  <button class="layui-btn" data-method="setRefresh"><i class="layui-icon">&#x1002;</i>刷新</button>
  
</div>

<table id="tb1" lay-filter="tb1"></table>

<script type="text/html" id="barTable">
  <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>
  <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<script type="text/javascript" src="plugins/layui/layui.js"></script>
<script>
layui.use(['table','layer','laydate'], function(){
  var table = layui.table;
  var $ = layui.jquery;
  var layer = layui.layer; 
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
  //渲染
  var tableObj = table.render({
    elem: '#tb1'
    ,height: "full-139"
    ,url: 'json/demo1.json'
    ,page:true
    ,limit: 10
	,limits:[10,20,30]
    ,cols: [[
       {type: 'numbers',title:'#',fixed: 'left'} 
	  ,{type: 'checkbox',fixed: 'left'}
<#list tableClass.allFields as fields>
 	  ,{field:'${fields.fieldName}', title:'${fields.remarks}', width:150}
</#list>
      ,{title:'操作', width:162,fixed: 'right', toolbar: '#barTable'}
    ]]
	,id:'idTable'
	
	,text: {
		none: '暂无相关数据' //默认：无数据。注：该属性为 layui 2.2.5 开始新增
    }
	
  });
        //监听工具条
		table.on('tool(tb1)', function(obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
			var data = obj.data //获得当前行数据
			, layEvent = obj.event; //获得 lay-event 对应的值
			if (layEvent === 'detail') {
				layer.alert(JSON.stringify(data));

			} else if (layEvent === 'del') {
				layer.confirm('真的删除行么', function(index) {
					obj.del(); //删除对应行（tr）的DOM结构
					layer.close(index);
					//向服务端发送删除指令
				});
			} else if (layEvent === 'edit') {
				layer.msg('编辑操作');
			}
		});

		//触发事件
		var active = {
			setAdd : function() {
				var that = this;
				//多窗口模式，层叠置顶
				layer.open({
					type : 2 //此处以iframe举例
					,
					title : '新增',
					area : [ '800px', '600px' ],
					shade : 0.3,
					maxmin : true,
					offset : 'auto',
					content : 'views/edit2.html',
					zIndex : layer.zIndex
				//重点1

				});
			},
			setEdit : function() {
				var that = this;
				//多窗口模式，层叠置顶
				var checkStatus = table.checkStatus('idTable')
				//多窗口模式，层叠置顶
				var data = checkStatus.data;
				if (data.length != 1) {
					layer.msg('请选择一行修改！');
					return false;
				}

				var rows = data[0];

				layer.open({
					type : 2 ,//此处以iframe举例
					title : '修改',
					area : [ '800px', '600px' ],
					shade : 0.3,
					maxmin : true,
					offset : 'auto',
					content : 'views/edit.html?v1=i',
					zIndex : layer.zIndex, //重点1
					
					success : function(layero, index) {
						var body = layer.getChildFrame('body', index);//建立父子联系
						var iframeWin = window[layero.find('iframe')[0]['name']];
						
						$.each(rows, function(k, v) {
						    var that = body.find('[name="'+k+'"]');
							
							if(that.get(0).tagName=="INPUT"){
								if(that.attr('type')=="radio"){
									that.each(function(i,item){ 										
										if($(item).val()==v){  											
											$(item).attr('checked',true);  
											iframeWin.layui.form.render('radio');    
										}  
									});  
								} else if(that.attr('type')=="checkbox"){
									if(that.attr('lay-skin')=="switch"){//lay-skin="switch"
									    if(v > 0){											
											that.val(v);
											that.attr('checked',true); 
										}else{
											that.val(v);										
											that.attr('checked',false); 
										}																								
									}else{
										that.each(function(i,item){ 																
											if($.inArray($(item).val(),v)!=-1){
												$(item).attr('checked',true); 
																							
											}
											
										});  
									}
									iframeWin.layui.form.render('checkbox');   
								}else{
									that.val(v);
								}
							}
							
							if(that.get(0).tagName=="SELECT"){
								console.info("select "+v);
								that.val(v);
								iframeWin.layui.form.render('select');
							}
							
							if(that.get(0).tagName=="TEXTAREA"){								
								that.val(v);								
							}
														
						});

					}
				});
			},
			setDel : function() {
				var that = this;
				var checkStatus = table.checkStatus('idTable')
				//多窗口模式，层叠置顶
				var data = checkStatus.data;
				layer.confirm('已选择 ' + data.length + ' 条，真的要批量删除么？', function(
						index) {
					layer.alert(JSON.stringify(data));
					layer.close(index);
					//向服务端发送删除指令
				});
			},
			setRefresh : function() {
				var that = this;
				tableObj.reload({
					where : { //设定异步数据接口的额外参数，任意设
						aaaaaa : 'xxx',
						bbb : 'yyy'
					//…
					},
					page : {
						curr : 1
					//重新从第 1 页开始
					}
				});

			}

		};

		$('#lbglayer .layui-btn').on('click', function() {
			var othis = $(this), method = othis.data('method');
			active[method] ? active[method].call(this, othis) : '';
		});

	});
</script>
</body>
</html>
