<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>新增客户界面设计</title>
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
	        background:#F8F8F8;
	        display:flex;
	    }
	
  	</style>
  	
	<script type="text/javascript">
    $(function () {
		var DesignData,myDataView,layout;
		var myLayout = new dhtmlXLayoutObject({
	        parent: document.body,
	        pattern: "3T",
	        cells: [
	            { id: "a", header: false},
	            { id: "b", header: false, fix_size: [true, true]},
	            { id: "c", header: false}
	        ]
	    });	 
		myLayout.cells("a").setHeight(50);
		
		myLayout.cells("b").setWidth(200);
		 
		 
		 var myTabbar = myLayout.cells("b").attachTabbar({
		        close_button: false,
		        arrows_mode: 'auto',
		        tabs: [{ id: "a2", text: "内容设计", width:200,active: true, close: false }]	        
		    });

		 var myToolbar = myLayout.cells("a").attachToolbar();
		 myToolbar.setIconsPath("${pageContext.request.contextPath}/DHX/imgs/dhxtoolbar_terrace/");
		 myToolbar.format({
		        Items: [
		            { ID: "printView", Type: "button", Text: "打印设置",Img: "print.gif" },	
		            { ID: "sep1", Type: "separator" },
		            { ID: "save", Type: "button", Text: "保存",Img: "save.gif"},
		            { ID: "sep2", Type: "separator" },
		            { ID: "back", Type: "button", Text: "返回",Img: "cancel.png"},
		        ],
		        Action: function (id) {
		            if (id == "printView") {
		            	location.href="${pageContext.request.contextPath}/view/tocustomerprint.action";
		            }
		            if (id == "save") {	  	            	
		               $.ajax({
		    			   type: 'POST',
		    			   url: '/customer/selcustomerdesign.action',
		    			   data: {groupName:window.top.getName(),userID:window.top.getID()},
		    			   success: function(res){
		    				   if(res.data){
		    					   $.ajax({
		    						   type: 'POST',
		    						   url: '/customer/editcustomerdesign.action',
		    						   data: {groupName:window.top.getName(),userID:window.top.getID(),design:JSON.stringify(DesignData)},
		    						   success: function(res){	
		    							   dhtmlx.alert('保存成功');
		    						   }
		    					});
		    				   }else{
		    					   var title ='基本信息,附加信息,联系人,地址,关联公司,回访地址,续签记录,服务有效期维护,';
		    					   $.ajax({
		    						   type: 'POST',
		    						   url: '/customer/addcustomerdesign.action',
		    						   data: {groupName:window.top.getName(),userID:window.top.getID(),design:JSON.stringify(DesignData),positioningBar:title},
		    						   success: function(res){		
		    							   dhtmlx.alert('保存成功');
		    						   }
		    					});
		    				   }
		    			   }
		    		  });
		            }
		            if (id == "back"){
		            	location.href="${pageContext.request.contextPath}/view/toaddcustomer.action";
		            }
		           
		        }
		    });
		 
	
		 
		 myDataView = myTabbar.tabs("a2").attachDataView({
		        type: {
		            template: "#Name# <br>[#Label#] : ",
		            padding: 5,
		            height: 40
		        },
		        drag: true
		    });
			
		 $.ajax({
			   type: 'POST',
			   url: '/customer/selcustomerdesign.action',
			   data: {groupName:window.top.getName(),userID:window.top.getID()},
			   success: function(res){
				   if(res.data){
					   DesignData = JSON.parse(res.data[0].design); 					   					   
					   init(DesignData); 
					   changeHeight(layout);
					   changeWidth(layout);
					   layout.lays[0].cells("f").collapse();
					   layout.lays[0].cells("g").collapse();
				   }else{
					   $.ajax({
						   type: 'POST',
						   url: '/design/seldesign3.action',
						   data: {DesignName:"设计客户档案"},
						   success: function(res){		
							   DesignData = JSON.parse(res[0].design); 					   					   
							   init(DesignData); 
							   changeHeight(layout);
							   changeWidth(layout);
							   layout.lays[0].cells("f").collapse();
							   layout.lays[0].cells("g").collapse();
						   }
					});
				   }
			   }
		});
		 
		 
		    
		    
		    
		    myLayout.cells("c").attachObject("see");
		    var dhxWins = new dhtmlXWindows({ viewport: { object: "seeBox" } });
		 
		    /*整体布局表头预览判断*/
		    var clientData = {
		        ID: "",
		        DesignName: "",
		        TableName: "",
		        Controller: "",
		        ViewName: "",
		    };
		    var a = $('#seeBox')[0].clientWidth||$('#see')[0].offsetWidth;
		    var viewWin = dhxWins.createWindow({
		        id: "view",
		        width: a,
		        height: 2300,
		        resize: false,
		        modal: false,
		        header: false,
		        caption: "",
		        park: false,
		        move: false
		    });
		    
			function init(DesignData) {
		        
		        myDataView.parse(DesignData.Context, "json");
		        //创建视图窗口
		        changeView(DesignData);
		        
		       
		    }
		    
		    

		    function createDropForm(lay) {
		        if (lay.layout_Type == "layout" || lay.layout_Type == "accordion") {
		            lay.layout_This.forEachItem(function (cell) {
		                if (cell.context_This) {
		                    createDragControl(cell);
		                }
		                else {
		                    createDropForm(cell);
		                }
		            });
		        }
		        if (lay.layout_Type == "tabbar") {
		            lay.layout_This.forEachTab(function (cell) {
		                if (cell.context_This) {
		                    createDragControl(cell);
		                }
		                else {
		                    createDropForm(cell);
		                }
		            });
		        }
		    }
		    function createDragControl(cell) {
		        if (cell.context_Type == "form") {
		            dhtmlx.DragControl.addDrop(cell.context_This.cont, {
		                onDrop: function (source, target, d, e) {
		                    var context = dhtmlx.DragControl.getContext();
		                    var data = dhtmlx.find(DesignData.Context, "Name", context.Name);
		                    if (data) {

		                        if (e.target == target.targetForm.cont) {
		                            //智能对齐
		                            //找到前面的元素， 以坐标判断  
		                            var x = e.offsetX;
		                            var y = e.offsetY;
		                            for (var i = 0; i < target.targetForm.Names.length; i++) {
		                                var name = target.targetForm.Names[i];
		                                var item = dhtmlx.find(DesignData.Context, "Name", name);
		                                if (Math.abs(e.offsetX - item.OffsetX) < 10) x = item.OffsetX;
		                                if (Math.abs(e.offsetY - item.OffsetY) < 10) y = item.OffsetY;
		                            }
		                            target.targetForm.Names.push(context.Name);
		                            data.IsView = true;
		                            data.OffsetX = x;
		                            data.OffsetY = y;
		                            changeView(DesignData);
		                        }

		                    }
		                }
		            }, true);
		            //为form里的内容增加拖动
		            for (var i = 0; i < cell.context_This.Names.length; i++) {
		                var name = cell.context_This.Names[i];
		                var o = cell.context_This._getItemByName("block_" + name);
		                o.targetName = name;
		                o.targetForm = cell.context_This;
		                o.onmousedown = function (e) { e.preventDefault() };
		                o.ondblclick = function (e) { createContextForm(this.targetName); }
		                dhtmlx.DragControl.addDrag(o, {
		                    onDrag: function (c, g) {
		                        if (c.targetForm) {
		                            //移出界面 删除
		                            var context = c.targetForm.Names;
		                            dhtmlx.remove(context, "Name", c.targetName);
		                            var data = dhtmlx.find(DesignData.Context, "Name", c.targetName);
		                            if (data) data.IsView = false;
		                        }
		                        dhtmlx.DragControl._drag_context = { Name: c.targetName, source: c, from: c };
		                        var el = c.targetForm._getItemByName("block_" + c.targetName);

		                        return el.innerHTML;
		                    }
		                });
		            }
		        }
		        else {
		            var name = cell.context_This.Names[0];
		            var o = cell.cell;
		            o.targetName = name;
		            o.targetForm = cell.context_This;
		            o.onmousedown = function (event) {
		                if (document.all) { //判断IE浏览器
		                    window.event.returnValue = false;
		                }
		                else {
		                    event.preventDefault();
		                };
		            };
		            o.ondblclick = function (e) { createContextForm(this.targetName); }
		            dhtmlx.DragControl.addDrag(o, {
		                onDrag: function (c, g) {
		                    if (c.targetForm) {
		                        //移出界面 删除
		                        var context = c.targetForm.Names;
		                        dhtmlx.remove(context, "Name", c.targetName);
		                        var data = dhtmlx.find(DesignData.Context, "Name", c.targetName);
		                        if (data) data.IsView = false;
		                    }
		                    dhtmlx.DragControl._drag_context = { Name: c.targetName, source: c, from: c };
		                    return "<div style='" + c.style.cssText + "'>" + c.innerHTML + "</div>"
		                }
		            });

		        }
		    }
		    
		    

		    
		    
		    function createContextForm(name) {
		        var text = "新增内容";
		        var bAdd = true;
		        var data = dhtmlx.find(DesignData.Context, "Name", name);
		        if (data) {
		            text = "修改内容";
		            bAdd = false;
		        }
		        else {
		            data = {};
		        }
		        if (typeof (data.Label) == "undefined") data.Label = "";
		        if (typeof (data.DataType) == "undefined") data.DataType = "str";
		        if (typeof (data.InputType) == "undefined") data.InputType = "input";
		        if (typeof (data.DefaultValue) == "undefined") data.DefaultValue = "";
		        if (typeof (data.Required) == "undefined") data.Required = false;
		        if (typeof (data.Name) == "undefined") data.Name = "";
		        if (typeof (data.MaxLength) == "undefined") data.MaxLength = "20";
		        if (typeof (data.Precision) == "undefined") data.Precision = "0";
		        if (typeof (data.Sequence) == "undefined") data.Sequence = "1";
		        if (typeof (data.Disable) == "undefined") data.Disable = false;
		        if (typeof (data.Hidden) == "undefined") data.Hidden = false;
		        if (typeof (data.InputWidth) == "undefined") data.InputWidth = "120";
		        if (typeof (data.InputHeight) == "undefined") data.InputHeight = "16";
		        if (typeof (data.LabelWidth) == "undefined") data.LabelWidth = "";
		        if (typeof (data.LabelHeight) == "undefined") data.LabelHeight = "";
		        if (typeof (data.IsFull) == "undefined") data.IsFull = false;
		        if (typeof (data.Position) == "undefined") data.Position = "label-left";
		        if (typeof (data.OffsetLeft) == "undefined") data.OffsetLeft = "20";
		        if (typeof (data.OffsetRight) == "undefined") data.OffsetRight = "20";
		        if (typeof (data.OffsetTop) == "undefined") data.OffsetTop = "0";
		        if (typeof (data.HasPager) == "undefined") data.HasPager = false;
		        function initformData(data) {
		            formStructure = [
		                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 150, offsetLeft: 0, labelAlign: "right" },
		                {
		                    type: "fieldset", label: "数据类型", width: 530, offsetLeft: 20, list: [
		                    	{ type: "input", name: "Name", value: data.Name, label: "字段",disabled:true },
		                    	{ type: "input", name: "Label", value: data.Label, label: "默认名称",disabled:true },
		                    	{ type: "newcolumn", offset: 40 },
		                        { type: "input", name: "Explain", value: data.Explain, label: "显示名称" },
		                        {
		                            type: "block", width: 220,blockOffset: 0, list: [
		                            	{ type: "input", name: "MaxLength", value: data.MaxLength, width: 40, label: "数据长度" },
		                            	{ type: "newcolumn", offset: 20 },
		                            	{ type: "checkbox", name: "Required", checked: data.Required, label: "必输", labelWidth: 65 }		                            	
		                            ]
		                        }
		                    ]
		                },
		                {
		                    type: "fieldset", label: "UI设置", width: 530, offsetLeft: 20, list: [
		                        
		                        {
		                            type: "block", width: 220, blockOffset: 0, list: [
		                                { type: "checkbox", name: "Disable", checked: data.Disable, label: "禁止编辑" },
		                                { type: "newcolumn", offset: 20 },
		                                { type: "checkbox", name: "Hidden", checked: data.Hidden, label: "是否隐藏", labelWidth: 85 }
		                            ]
		                        },
		                        
		                        {
		                            type: "block", width: 220, blockOffset: 0, list: [
		                                {
		                                    type: "select", name: "Position", inputWidth: 50, value: data.Position, label: "标题方式", options: [
		                                        { text: "左边", value: "label-left" },
		                                        { text: "右边", value: "label-right" },
		                                        { text: "上面", value: "label-top" }
		                                    ]
		                                },
		                                { type: "newcolumn", offset: 20 },
		                                { type: "input", name: "OffsetTop", value: data.OffsetTop, label: "上边距", width: 35, labelWidth: 40 }
		                            ]
		                        },
		                        {
		                            type: "block", width: 220, blockOffset: 0, list: [
		                                {
		                                    type: "select", name: "InputType", value: data.InputType, width: 80, label: "元素类型", options: [
		                                        { text: "单行框", value: "input" },
		                                        { text: "多行框", value: "textarea" },
		                                        { text: "单选框", value: "combo" },
		                                        { text: "多选框", value: "multiselect" },
		                                        { text: "真假框", value: "checkbox" },
		                                        { text: "参照框", value: "browe" },
		                                        { text: "表格", value: "grid" },
		                                        { text: "树形", value: "tree" },
		                                        { text: "表格树", value: "treeview" },
		                                        { text: "列表", value: "list" },
		                                        { text: "数据视图", value: "view" },
		                                        { text: "长日期", value: "calendar1" },
		                                        { text: "短日期", value: "calendar2" },
		                                        { text: "颜色框", value: "colorpicker" },
		                                        { text: "富文本", value: "editor" },
		                                        { text: "隐藏字段", value: "hidden" },
		                                        { text: "图片", value: "image" },
		                                        { text: "文字", value: "label" },
		                                        { text: "密码框", value: "password" },
		                                        { text: "文件框", value: "file" },
		                                        { text: "上传组件", value: "upload" },
		                                        { text: "子页面", value: "frame" },
		                                        { text: "按钮", value: "button" },
		                                        { text: "年度", value: "year" },
		                                        { text: "月份", value: "month" },
		                                    ]
		                                },
		                                { type: "newcolumn", offset: 5 },
		                                { type: "button", name: "btnSet", value: "表格设置", className: "button", width: 60 }
		                            ]
		                        },
		                        { type: "newcolumn", offset: 5 },
		                        {
		                            type: "block", width: 220, blockOffset: 0, list: [
		                                { type: "input", name: "LabelWidth", value: data.LabelWidth, label: "标题框宽", width: 35 },
		                                { type: "newcolumn", offset: 20 },
		                                { type: "input", name: "LabelHeight", value: data.LabelHeight, label: "标题框高", width: 35, labelWidth: 55 }
		                            ]
		                        },
		                        
		                        {
		                            type: "block", width: 220, blockOffset: 0, list: [
		                                { type: "input", name: "InputWidth", value: data.InputWidth, label: "输入框宽", width: 35 },
		                                { type: "newcolumn", offset: 20 },
		                                { type: "input", name: "InputHeight", value: data.InputHeight, label: "输入框高", width: 35, labelWidth: 55 }
		                            ]
		                        }
		                    ]
		                }
		            ];
		            return formStructure;
		        }
		        var w1 = dhtmlx.showDialog({
		            caption: text,
		            width: 600,
		            height: 500,
		            save: function () {
		                var formData = contextForm.getFormData();
		                if (!formData.Name) {
		                    dhtmlx.error("字段必须有值！");
		                    return;
		                }

		                var result = dhtmlx.find(DesignData.Context, "Name", formData.Name);
		                if (bAdd && result) {
		                    dhtmlx.confirm({
		                        text: "字段已经存在了，是否覆盖原来的?",
		                        callback: function (result) {
		                            if (result) {
		                                contextSaveAs(formData);
		                                w1.close();
		                            };
		                        }
		                    });
		                }
		                else {
		                    contextSaveAs(formData);
		                    w1.close();
		                }

		            }
		        });
		        var contextForm = w1.layout.cells("a").attachForm(initformData(data));
		       
		        
		        contextForm.attachEvent("onButtonClick", function (name) {
		            if (name == "btnSet") {
		                var inputtype = this.getItemValue("InputType");
		                if (inputtype == "grid") {
		                    if (!data.Columns) data.Columns = [];
		                    var w1 = dhtmlx.configureDhxGrid(data.Columns, function (o) {
		                        data.Columns = o;
		                    });		                   
		                }
		                else {
		                    dhtmlx.alert("不是表格容器！");
		                }
		            }
		        });
		    }
		    function contextSaveAs(data) {
		        if (!DesignData.Context) DesignData.Context = [];
		        var result = dhtmlx.find(DesignData.Context, "Name", data.Name);
		        if (result)
		            $.extend(result, data);
		        else
		            DesignData.Context.push(data);

		        myDataView.clearAll();
		        myDataView.parse(DesignData.Context, "json");
		        changeView(DesignData);
		    }
		    function contextRemove(data) {
		        dhtmlx.remove(DesignData.Context, "Name", data.Name);
		        myDataView.clearAll();
		        myDataView.parse(DesignData.Context, "json");
		    }
		    

		    myDataView.attachEvent("onBeforeDrag", function (context, ev) {
		        var id = context.start;
		        context.Name = this.get(id).Name;
		        var data = dhtmlx.find(DesignData.Context, "Name", context.Name);     
		        if (data && !data.IsView) return true;
		        return false;
		    });
		    
		    myDataView.attachEvent("onItemDblClick", function (id, ev, html) {
		        createContextForm(this.get(id).Name);
		        
		        return true;
		    });
		    myDataView.attachEvent("onAfterDrop", function (context, ev) {
		        if (context.from != context.to) {
		            var data = dhtmlx.find(DesignData.Context, "Name", context.Name);
		            if (data) {
		                data.IsView = false;
		                changeView(DesignData);
		            }
		        }
		    });

		    function addEvent(events, ev) {
		        var reslut = getEvent(events, ev.Text);
		        if (reslut != null) {
		            reslut.Value = ev.Value;
		        }
		        else {
		            events.push(ev);
		        }
		    }
		    function getEvent(events, name) {
		        for (var i = 0; i < events.length; i++) {
		            if (events[i].Text == name) {
		                return events[i];
		            }
		        }
		        return null;
		    }
		    function delEvent(events, name) {
		        for (var i = 0; i < events.length; i++) {
		            if (events[i].Text == name) {
		                events.splice(i, 1);
		                break;
		            }
		        }
		    }

		    function changeView(DesignData) {
		        changeName(DesignData);
		        
		       layout = dhtmlx.layout(DesignData, viewWin);
		        createDropForm(viewWin);
		      
		    }
		    var ss = 1000;
		    function changeName(a) {
		       
		        if (a.Child && a.Child.length != 0) {
		            for (let i = 0; i < a.Child.length; i++) {
		                if (a.Child[i].Height)
		                    ss += parseInt(a.Child[i].Height);
		                if(a.Child[i].Child)
		                	changeName(a.Child[i].Child);
		            }
		        }
		        else {
		            for (let i = 0; i < a.length; i++) {
		                if (a[i].Height)
		                    ss += parseInt(a[i].Height);
		            }
		        }
		    }  
		    function changeHeight(layout){
		    	 layout.lays[0].attachEvent("onPanelResizeFinish", function(ids){	    		 
					   for(var i of ids){
						   
						   var height = parseInt(layout.lays[0].cells(i).cell.style.height) + '';
						   var title = layout.lays[0].cells(i).getText();
						   for(var j of DesignData.Child){
							   if(j.Text == title){
								   j.Height = height;
							   } 
						   }
					   }
					});
		    } 
		    function changeWidth(layout){
				 window.onresize = function(){

					   var a = (document.body.offsetWidth-212)*0.88;
					   a = a - 35;
					   $('#seeBox')[0].children[0].style.width = a+45 +'px';
					   layout.lays[0].cells("a").cell.style.width = a +'px';
					   layout.lays[0].cells("a").cell.children[1].style.width = a-8+'px';
					   layout.lays[0].cells("a").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("a").cell.parentNode.style.width = a+'px';
					   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("a").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("b").cell.style.width = a+'px';
					   layout.lays[0].cells("b").cell.children[1].style.width = a-8+'px';
					   layout.lays[0].cells("b").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("c").cell.style.width = a+'px';
					   layout.lays[0].cells("c").cell.children[1].style.width = a-10+'px';
					   layout.lays[0].cells("c").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("d").cell.style.width = a+'px';
					   layout.lays[0].cells("d").cell.children[1].style.width = a-10+'px';
					   layout.lays[0].cells("d").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("e").cell.style.width = a+'px';
					   layout.lays[0].cells("e").cell.children[1].style.width = a-10+'px';
					   layout.lays[0].cells("e").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("f").cell.style.width = a+'px';
					   layout.lays[0].cells("f").cell.children[1].style.width = a-8+'px';
					   layout.lays[0].cells("f").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("g").cell.style.width = a+'px';
					   layout.lays[0].cells("g").cell.children[1].style.width = a-8+'px';
					   layout.lays[0].cells("g").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("h").cell.style.width = a+'px';
					   layout.lays[0].cells("h").cell.children[1].style.width = a-10+'px';
					   layout.lays[0].cells("h").cell.children[0].style.width = a-8+'px';
					   layout.lays[0].cells("b").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("b").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("c").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("c").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("c").cell.children[2].style.width = a-8+'px';
					   layout.lays[0].cells("d").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("d").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("d").cell.children[2].style.width = a-8+'px';
					   layout.lays[0].cells("e").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("e").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("e").cell.children[2].style.width = a-8+'px';
					   layout.lays[0].cells("f").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("f").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("g").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("g").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("h").cell.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("h").cell.parentNode.parentNode.parentNode.parentNode.style.width = a+'px';
					   layout.lays[0].cells("h").cell.children[2].style.width = a-8+'px';
				   }
			 }
		   
    });

</script>
</head>
<body>
	<div id = "see" style = "width:100%;height:100%;overflow: auto;background:#E0E0E0;">
		<div id ="seeBox" style="width:88%;height:2300px;margin-left:5%;margin-top:2.5%;margin-bottom:2.5%;box-shadow: 0 0 6px #a0a0a0;"></div>
	</div>
</body>
</html>