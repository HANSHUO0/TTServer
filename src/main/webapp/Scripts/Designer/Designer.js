
function initialization(w) {

    //设计数据， 所有设计的数据都应该存放在这个数据里，为json对象 ，可以保存,重现
    //此数据是一个树形结构的。 每个节点都应该有type, type:layout , cell , tabbar 等容器类型
    // 每个type 对应一个 propertyData的节点
    // 
    var DesignData = {
        Text: "主页面",
        Pattern: "3E",
        Type: "layout",
        Child: [
            { Type: "cell", Text: "页签一" },
            { Type: "cell", Text: "页签二" },
            {
                Type: "tabbar",
                Text: "页签三",
                Pattern: "3E",
                Count: 2,
                Child: []
            },
        ],
        Context: [
            { Label: 'a', Name: '输入框A', InputType: "input" },
            { Label: 'b', Name: '输入框B', InputType: "input" },
            { Label: 'c', Name: '输入框C', InputType: "input" },
            { Label: 'd', Name: '输入框D', InputType: "input" } 
        ]
    };
    /*整体布局*/
    var myLayout = new dhtmlXLayoutObject({
        parent: document.body,
        pattern: "3T",
        cells: [
            { id: "a", header: false, height: 10, fix_size: [true, true] },
            { id: "b", header: false },
            { id: "c", header: false,width:200,fix_size: [false, false]}
        ]
    });
    var aa = myLayout,bb;
    /*整体布局表头栏目*/
    var myTBar = myLayout.cells("a").attachToolbar().format({
        Items: [
            { ID: "new", Type: "button", Text: "新建", Img: "new.gif" },
            { ID: "open", Type: "button", Text: "打开", Img: "open.gif" },
            { ID: "save", Type: "button", Text: "保存", Img: "save.gif" },
            { ID: "sep1", Type: "separator" },
            { ID: "preview", Type: "button", Text: "预览", Img: "preview.png" },
            { ID: "build", Type: "button", Text: "创建表", Img: "build.png" },
            { ID: "sep2", Type: "separator" },
            { ID: "release", Type: "button", Text: "发布", Img: "export.png" },
            { ID: "unsubscribe", Type: "button", Text: "取消发布", Img: "import.png" },
            { ID: "sep99", Type: "separator" },
            { ID: "saveToCookie", Type: "button", Text: "暂存", Img: "save.gif" },
            { ID: "loadFromCookie", Type: "button", Text: "恢复", Img: "save.gif" }
        ],
        Spacer: "sep99",
        Action: function (id) {
            if (id == "save") save();
            if (id == "open") open();
            if (id == "build") build();
            if (id == "new") {
                dhtmlx.confirm({
                    text: "确定要重新开始创建？",
                    callback: function (result) {
                        if (!result) return;
                        DesignData = {
                            Text: "主页面",
                            Pattern: "3E",
                            Type: "layout",
                            Child: [
                                { Type: "cell", Text: "a" },
                                { Type: "cell", Text: "b" },
                                { Type: "cell", Text: "c" }
                            ]
                        };
                        init();
                    }
                });
            }
            if (id == 'saveToCookie') {
                var storage = window.localStorage;
                storage.setItem("DesignData", JSON.stringify(DesignData));
                alert("已经暂存");

            }
            if (id == "loadFromCookie") {
                var storage = window.localStorage;
                s = storage.getItem("DesignData");
                DesignData = JSON.parse(s);
                init();
                alert("恢复了");
            }
            if (id == "preview") {
                if (clientData.DesignName) {
                	if(window.parent.document.getElementById("go")){
                		window.parent.document.getElementById("go").remove();
                	}
                	var dt = window.parent.document.getElementById("tool");
                 	
                 	var dd = document.createElement('dl'); 
                	dd.innerHTML= '<a id=go lay-href=/view/togo.action?designName='+clientData.DesignName+'>预览界面</a>';
                	dt.append(dd);
                	
                	window.parent.document.getElementById("go").click(); 
                   
                }
                else { 
                    dhtmlx.alert("请先保存！")
                }
            }
            if(id == 'release'){
            	
            	$.ajax({
        		    	type: 'POST',
        		    	url: '/menu/selusergroup.action',
        		    	data:{UserID:window.top.getID(),cGroupName:window.top.getName()},
        		    	success: function(res){
        		    		var array = new Array();
        		    		for(var i=0;i<res.length;i++){
        		    			var arr = new Array();
        		    			arr[0] = res[i].id;
        		    			arr[1] = parseInt(res[i].parentId);
        		    			arr[2] = res[i].title;
        		    			array[i] = arr;
        		    		}
                  		  	
        		    		let w2 = dhtmlx.showDialog({
        	                     caption: '选择目录发布',
        	                     width: 300,
        	                     height: 400,
        	                     modal: true,
        	                     saveText: "确定",
        	                     save: function () {
        	                    	var name = form.getItemValue("p_name");
        	                    	var choose = tree.getSelectedItemText();
        	                    	if(choose!=''&choose!=null){
        	                    		
        	                    		$.ajax({
            	            		    	type: 'POST',
            	            		    	url: '/menu/addmenugroup.action',
            	            		    	data:{UserID:window.top.getID(),choose:choose,GroupID:window.top.getGroupID(),addName:name,AddData:JSON.stringify(DesignData)},
            	            		    	success: function(res){
            	            		    		alert("发布成功"); 
            	                      		  	w2.close();
            	                      		  	window.top.location.reload();
            	            		    	}
            	                    	});
        	                    	}
        	                    	
        	                     }
        	                 });
        		    		var lay = w2.layout.cells("a");
        		    		var myLayout = new dhtmlXLayoutObject({
        		                parent: lay,  
        		                pattern: "2E",
        		                cells: [
        		                    { id: "a", header: false, height: 30, fix_size: [true, true] },
        		                    { id: "b", header: false }
        		                ]
        		            });
        		    		var formStructure = [{type:"input",name:"p_name",label:"标题",required:true}];
        	            	var form = myLayout.cells("a").attachForm(formStructure);
        		    		
        	            	var tree = myLayout.cells("b").attachTree();
        	            	tree.setImagePath("/DHX/imgs/dhxtree_terrace/");
        	            	tree.parse(array,"jsarray");
        		    		
        		    	}
            		  });
	
            	
            }
            if(id == 'unsubscribe'){
            	
            }
        }
    });
    /*整体布局表头预览判断*/
    var clientData = {
        ID: "",
        DesignName: "",
        TableName: "",
        Controller: "",
        ViewName: "",
    };
    /*整体布局表头保存*/
    function save() {

        var w1 = dhtmlx.showDialog({
            caption: '保存设计',
            width: 350,
            height: 300,
            modal: true,
            save: function () {
                saveForm.save();
            }
        });
        var lay = w1.layout.cells("a");

        var saveForm = lay.attachForm([
            { type: "settings", position: "label-left", labelWidth: 100, inputWidth: 150, labelAlign: "right" },
            { type: "input", name: "DesignName", value: clientData.DesignName, label: "设计名称：", required: true },
            { type: "input", name: "PageTitle", value: clientData.PageTitle, label: "页面名称：", required: true },
            { type: "input", name: "TableName", value: clientData.TableName, label: "数据库表：", required: true },
            { type: "input", name: "Controller", value: clientData.Controller, label: "控制器名：", required: true },
            { type: "input", name: "ViewName", value: clientData.ViewName, label: "视图名称：", required: true },
            { type: "input", name: "UserName", value: clientData.UserName, label: "创建人：", required: true }
        ]);
        saveForm.save = function () {
            $.cleanJson(DesignData);
            $.extend(clientData, saveForm.getFormData(), { Design: JSON.stringify(DesignData) });
            if (!check()) return;   
            var PositioningBar = document.getElementById("PositioningBar");
            if(PositioningBar){
            	var barName = '';
            	for(var i = 0;i < DesignData.Child.length;i++){
            		barName = barName + DesignData.Child[i].Text + ',';
            	}
            	
            	clientData.PositioningBar = barName;
            }
            console.log(clientData)
            //添加到数据库
        	$.ajax({
				   type: 'POST',
				   url: '/design/adddesign.action',
				   data: clientData,
				   
				   success: function(res){		
					   alert("已经保存");
					   w1.close();
				   }
			});
        }
    }
    /*整体布局表头打开*/
    function open() {
        var w1 = dhtmlx.showDialog({
            caption: 'UI列表',
            width: 820,
            height: 450,
            modal: true,
            saveText: "删除",
            save: function () {
                var name = grid.getValue(null, "DesignName");
                var id = grid.getValue(null, "ID");
                $.confirm("确定要删除[" + name + "]？", function () {
                	//删除
                	$.ajax({
     				   type: 'PUT',
     				   url: '/design/editdesign.action' ,
     				   data: {cid: id,IsDel: 1},
     				   
     				   success: function(res){    					   
     					  alert("删除成功");
     					 
                		  w1.close();
     				   }
     			   })
                });
            }
        });
        var lay = w1.layout.cells("a");
        var grid = lay.attachGrid().format({
            autowidth: false,
    
            remote: false,
            orders: [
                { Order: 'CreateDate', Desc: true }
            ],
            columns: [
                { Name: "ID", Width: 100, InputType: "ro", DataType: "str", Align: "left", Label: "ID", Hidden: true },
                { Name: "DesignName", Width: 120, InputType: "ro", DataType: "str", Align: "left", Label: "设计名称", },
                { Name: "PageTitle", Width: 120, InputType: "ro", DataType: "str", Align: "left", Label: "页面名称", },
                { Name: "TableName", Width: 120, InputType: "ro", DataType: "str", Align: "left", Label: "数据库表" },
                { Name: "Controller", Width: 120, InputType: "ro", DataType: "str", Align: "middle", Label: "控制器" },
                { Name: "ViewName", Width: 120, InputType: "ro", DataType: "str", Align: "middle", Label: "视图" },
                { Name: "CreateDate", Width: 150, InputType: "ro", DataType: "str", Align: "left", Label: "创建时间" },
                { Name: "CreateUserName", Width: 100, InputType: "ro", DataType: "str", Align: "middle", Label: "创建人" }
            ]
        });
       var list = new Array(); 
       var arr = new Array();
        
        //获取design
        $.ajax({
			   type: 'POST',
			   url: '/design/seldesign.action' ,
			   data:{},
			   success: function(res){	 
				   grid.parse(res,"json");
				   arr = res.rows;
				   for(var i=0;i<res.rows.length;i++){
					   list.push(res.rows[i].data[8]);
				   }
			   }
		   })
       
        grid.attachEvent("onRowDblClicked", function (rId, cInd) { 
            var name = this.cells(rId, cInd).getValue();
            var data = list[rId-1];
           
            clientData.DesignName = arr[rId-1].data[1];
            clientData.TableName = arr[rId-1].data[3];
            clientData.Controller = arr[rId-1].data[4];
            clientData.ViewName = arr[rId-1].data[5];
                
            if (data) {
                DesignData = JSON.parse(data);
                init();
            }
            w1.close();
        });
        lay.pager({
            pageSize: 20,
            height: 34,
            target: grid,
            orders: [{ Order: 'CreateDate', Desc: true }]
        }).load();

    }
    /*整体布局表头保存判断*/
    function check() {
        if (!clientData.DesignName || clientData.DesignName.length == 0) {
            dhtmlx.error("请输入设计名称!");
            return false;
        }
        if (!clientData.PageTitle || clientData.PageTitle.length == 0) {
            dhtmlx.error("请输入页面名称!");
            return false;
        }
        if (!clientData.TableName || clientData.TableName.length == 0) {
            dhtmlx.error("请输入数据库表!");
            return false;
        }
        if (!clientData.Controller || clientData.Controller.length == 0) {
            dhtmlx.error("请输入控制器名!");
            return false;
        }
        if (!clientData.ViewName || clientData.ViewName.length == 0) {
            dhtmlx.error("请输入视图名称!");
            return false;
        }
        if (!clientData.UserName || clientData.UserName.length == 0) {
            dhtmlx.error("请输入创建人!");
            return false;
        }
        return true;
    }
    /*整体布局表头创建*/
    function build() {
        var w1 = dhtmlx.showDialog({
            caption: '保存并创建',
            width: 350,
            height: 350,
            modal: true,
            saveText: "创建",
            save: function () {
                saveForm.save();
            }
        });
        var lay = w1.layout.cells("a");

        var saveForm = lay.attachForm([
            { type: "settings", position: "label-left", labelWidth: 100, inputWidth: 150, labelAlign: "right" },
            { type: "input", name: "DesignName", value: clientData.DesignName, label: "设计名称：", required: true },
            { type: "input", name: "PageTitle", value: clientData.PageTitle, label: "页面名称：", required: true },
            { type: "input", name: "TableName", value: clientData.TableName, label: "数据库表：", required: true },
            { type: "input", name: "Controller", value: clientData.Controller, label: "控制器名：", required: true },
            { type: "input", name: "ViewName", value: clientData.ViewName, label: "视图名称：", required: true },
            { type: "input", name: "UserName", value: clientData.UserName, label: "创建人：", required: true },
            {
                type: "block", width: 280, blockOffset: 0, list: [
                    { type: "checkbox", name: "CreateTable", checked: clientData.CreateTable, label: "创建数据表：" },
                    { type: "newcolumn", offset: 0 },
                    { type: "checkbox", name: "CreateTable", checked: clientData.CreateModel, label: "创建实体类：" },
                ]
            },
            {
                type: "block", width: 280, blockOffset: 0, list: [
                    { type: "checkbox", name: "CreateController", checked: clientData.CreateController, label: "创建控制器：" },
                    { type: "newcolumn", offset: 0 },
                    { type: "checkbox", name: "CreateView", checked: clientData.CreateView, label: "创建视图页：" }
                ]
            }
        ]);
        saveForm.save = function () {
            $.cleanJson(DesignData);
            $.extend(clientData, saveForm.getFormData(), { Design: JSON.stringify(DesignData) });
            if (!check()) return;
            if (clientData.CreateTable == 0)
                clientData.CreateTable = false;
            else
                clientData.CreateTable = true;

            if (clientData.CreateController == 0)
                clientData.CreateController = false;
            else
                clientData.CreateController = true;

            if (clientData.CreateView == 0)
                clientData.CreateView = false;
            else
                clientData.CreateView = true;
            
            if (clientData.CreateModel == 0)
                clientData.CreateModel = false;
            else
                clientData.CreateModel = true;

            $.ajax({
                type: "POST",
                url: '/design/adddesign.action',
                data: clientData,
                beforeSend: function () { saveForm.progressOn(); },
                complete: function () { saveForm.progressOff(); },
                success: function (response) {
                    if (response.Success) {
                        dhtmlx.alert(response.Message);
                    }
                    else {
                        dhtmlx.error(response.Message);
                    }
                }
            });
               var num = $('.dhxform_textarea');
			   var data = {};
			   var className = '';
			   var maxLength = '';
			   if(num.length!=0&&num){
				   for(var i=0;i<num.length;i++){
					   
					   data[num[i].name] = num[i].value;
					   
					   if(i == num.length-1){
						   className += num[i].name;
				   		   maxLength += num[i].maxLength;
					   }
					   else{
					 	   className = className + num[i].name + ',';
					   	   maxLength = maxLength + num[i].maxLength + ',';
					   }
				   }
				   $.ajax({
					  type: 'POST',
					   url: '/design/createmysql.action',
					   data: {className:className,maxLength:maxLength},
				       success: function(res){
							
					   }
				   });
			  }
            
        }
    }

   
    
    
    myLayout = myLayout.cells("b").attachLayout({
        pattern: "2U",
        cells: [
            { id: "a", header: true, text: "页面设计", width: 250 },
            { id: "b", header: false, text: "页面预览",  fix_size: [null, null] }
        ]
    });
    bb =  myLayout.cells("b");
    //创建预览页
    myLayout.cells("b").attachObject("winVP");
    var dhxWins = new dhtmlXWindows({ viewport: { object: "winVP" } });
    

    //创建设计页签
    var myTabbar = myLayout.cells("a").attachTabbar({
        close_button: false,
        arrows_mode: 'auto',
        tabs: [
            { id: "a1", text: "布局设计", active: true, close: false },
            { id: "a2", text: "内容设计", close: false }
        ]
    });

    myTabbar.tabs("a2").attachToolbar().format({
        Items: [
            { ID: "new", Type: "button", Text: "新建" },
            { ID: "edit", Type: "button", Text: "修改" },
            { ID: "del", Type: "button", Text: "删除" },
            { ID: "load", Type: "button", Text: "导入" }
        ],
        Action: function (id) {
            if (id == "new") createContextForm();
            if (id == "edit") {
                var id = myDataView.getSelected();
                if (id) {
                    var data = myDataView.get(id);
                    createContextForm(data);
                }
                else {
                    dhtmlx.alert("请先选择内容，在点修改！");
                }
            }
            if (id == "del") {
                var ids = myDataView.getSelected(true);
                if (ids.length > 0) {
                    dhtmlx.confirm({
                        text: "确定要删除?",
                        callback: function (result) {
                            if (result) {
                                for (var i = 0; i < ids.length; i++) {
                                    var id = ids[i];
                                    var data = myDataView.get(id);
                                    contextRemove(data);
                                }
                            };
                        }
                    });
                }
                else {
                    dhtmlx.alert("请先选择内容，在点删除！");
                }



            }
            if (id == "load") createLoadForm(getFeilds);
        }
    });

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
                            changeView();
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
                        { type: "input", name: "Name", value: data.Name, label: "字段" },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                {
                                    type: "select", name: "DataType", value: data.DataType, width: 50, label: "数据类型", options: [
                                        { text: "文本", value: "str" },
                                        { text: "数字", value: "int" },
                                        { text: "日期", value: "date" },
                                        { text: "真假", value: "bool" }
                                    ]
                                },
                                { type: "newcolumn", offset: 0 },
                                { type: "input", name: "DefaultValue", value: data.DefaultValue, labelWidth: 40, inputWidth: 55, label: "默认" },
                            ]
                        },
                        { type: "input", name: "Explain", value: data.Explain, label: "描述" },
                        { type: "newcolumn", offset: 40 },
                        { type: "input", name: "Label", value: data.Label, label: "名称" },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "MaxLength", value: data.MaxLength, width: 40, label: "数据长度" },
                                { type: "newcolumn", offset: 0 },
                                { type: "input", name: "Precision", value: data.Precision, width: 40, labelWidth: 65, label: "精度" }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "Sequence", value: data.Sequence, width: 40, label: "输入顺序" },
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
                                {
                                    type: "select", name: "InputType", value: data.InputType, width: 70, label: "元素类型", options: [
                                        { text: "单行框", value: "input" },
                                        { text: "多行框", value: "textarea" },
                                        { text: "下拉框", value: "select" },
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
                                { type: "newcolumn", offset: 20 },
                                { type: "button", name: "btnSet", value: "设置", className: "button", width: 50 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "checkbox", name: "Disable", checked: data.Disable, label: "禁止编辑" },
                                { type: "newcolumn", offset: 20 },
                                { type: "checkbox", name: "Hidden", checked: data.Hidden, label: "是否隐藏", labelWidth: 85 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "InputWidth", value: data.InputWidth, label: "输入框宽", width: 35 },
                                { type: "newcolumn", offset: 20 },
                                { type: "input", name: "InputHeight", value: data.InputHeight, label: "输入框高", width: 35, labelWidth: 55 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "LabelWidth", value: data.LabelWidth, label: "标题框宽", width: 35 },
                                { type: "newcolumn", offset: 20 },
                                { type: "input", name: "LabelHeight", value: data.LabelHeight, label: "标题框高", width: 35, labelWidth: 55 }
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
                        { type: "input", name: "Tooltip", value: data.Tooltip, label: "提示信息" },
                        { type: "newcolumn", offset: 40 },
                        { type: "input", name: "DataUrl", value: data.DataUrl, label: "取数地址" },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "button", name: "btnDataOps", value: "可选参数", className: "button", width: 80 },
                                { type: "newcolumn", offset: 20 },
                                { type: "button", name: "btnUserData", value: "用户数据", className: "button", width: 80 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "checkbox", name: "IsFull", checked: data.IsFull, label: "填充到父容器", labelWidth: 80 },
                                { type: "newcolumn", offset: 20 },
                                { type: "checkbox", name: "HasPager", checked: data.HasPager, label: "带分页", labelWidth: 55 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "OffsetX", value: data.OffsetX, label: "左边距", width: 35 },
                                { type: "newcolumn", offset: 20 },
                                { type: "input", name: "OffsetY", value: data.OffsetY, label: "上边距", width: 35, labelWidth: 55 }
                            ]
                        },
                        { type: "input", name: "ClassName", value: data.ClassName, label: "样式类名", tooltip: "classname" },
                        { type: "input", name: "Style", value: data.Style, label: "用户样式", tooltip: "style" }
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
            if (name == "btnDataOps") {
                if (!data.Options) data.Options = [];
                dhtmlx.nameValues(data.Options, function (o) {
                    data.Options = o;
                });
            }
            if (name == "btnUserData") {
                if (!data.UserData) data.UserData = [];
                dhtmlx.nameValues(data.UserData, function (o) {
                    data.UserData = o;
                });
            }

            if (name == "btnSet") {
                var inputtype = this.getItemValue("InputType");
                if (inputtype == "grid") {
                    if (!data.Columns) data.Columns = [];
                    var w1 = dhtmlx.configureDhxGrid(data.Columns, function (o) {
                        data.Columns = o;
                    });
                    w1.toolbar.addItem({ ID: "load", Pos: 1, Type: "button", Text: "导入" });
                    w1.toolbar.attachEvent("onclick", function (id) {
                        if (id == "load") {
                            createLoadForm(function (table) {
                                $.ajax({
                                    type: "POST",
                                    url: "/Designer/GetFeilds/" + table,
                                    success: function (response) {
                                        if (response.Success) {
                                            for (var i = 0; i < response.Result.length; i++) {
                                                var d = response.Result[i];
                                                if (d.DataType == 'str') d.InputType = 'ro';
                                                if (d.DataType == 'int') d.InputType = 'edncl';
                                                if (d.DataType == 'date') d.InputType = 'dhxCalendar';
                                                if (d.DataType == 'bool') d.InputType = 'ch';
                                            }

                                            w1.dhxGrid.clearAll();
                                            w1.dhxGrid.parse(response.Result, "js");
                                        }
                                    }
                                });
                            });
                        }
                        return true;
                    });
                }
                else {
                    dhtmlx.alert("容器才需要设置！");
                }
            }
        });
    } function createContextForm(name) {
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
                        { type: "input", name: "Name", value: data.Name, label: "字段" },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                {
                                    type: "select", name: "DataType", value: data.DataType, width: 50, label: "数据类型", options: [
                                        { text: "文本", value: "str" },
                                        { text: "数字", value: "int" },
                                        { text: "日期", value: "date" },
                                        { text: "真假", value: "bool" }
                                    ]
                                },
                                { type: "newcolumn", offset: 0 },
                                { type: "input", name: "DefaultValue", value: data.DefaultValue, labelWidth: 40, inputWidth: 55, label: "默认" },
                            ]
                        },
                        { type: "input", name: "Explain", value: data.Explain, label: "显示名称" },
                        { type: "newcolumn", offset: 40 },
                        { type: "input", name: "Label", value: data.Label, label: "默认名称" },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "MaxLength", value: data.MaxLength, width: 40, label: "数据长度" },
                                { type: "newcolumn", offset: 0 },
                                { type: "input", name: "Precision", value: data.Precision, width: 40, labelWidth: 65, label: "精度" }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "Sequence", value: data.Sequence, width: 40, label: "输入顺序" },
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
                                {
                                    type: "select", name: "InputType", value: data.InputType, width: 70, label: "元素类型", options: [
                                        { text: "单行框", value: "input" },
                                        { text: "多行框", value: "textarea" },
                                        { text: "下拉框", value: "select" },
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
                                { type: "newcolumn", offset: 20 },
                                { type: "button", name: "btnSet", value: "设置", className: "button", width: 50 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "checkbox", name: "Disable", checked: data.Disable, label: "禁止编辑" },
                                { type: "newcolumn", offset: 20 },
                                { type: "checkbox", name: "Hidden", checked: data.Hidden, label: "是否隐藏", labelWidth: 85 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "InputWidth", value: data.InputWidth, label: "输入框宽", width: 35 },
                                { type: "newcolumn", offset: 20 },
                                { type: "input", name: "InputHeight", value: data.InputHeight, label: "输入框高", width: 35, labelWidth: 55 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "LabelWidth", value: data.LabelWidth, label: "标题框宽", width: 35 },
                                { type: "newcolumn", offset: 20 },
                                { type: "input", name: "LabelHeight", value: data.LabelHeight, label: "标题框高", width: 35, labelWidth: 55 }
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
                        { type: "input", name: "Tooltip", value: data.Tooltip, label: "提示信息" },
                        { type: "newcolumn", offset: 40 },
                        { type: "input", name: "DataUrl", value: data.DataUrl, label: "取数地址" },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "button", name: "btnDataOps", value: "可选参数", className: "button", width: 80 },
                                { type: "newcolumn", offset: 20 },
                                { type: "button", name: "btnUserData", value: "用户数据", className: "button", width: 80 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "checkbox", name: "IsFull", checked: data.IsFull, label: "填充到父容器", labelWidth: 80 },
                                { type: "newcolumn", offset: 20 },
                                { type: "checkbox", name: "HasPager", checked: data.HasPager, label: "带分页", labelWidth: 55 }
                            ]
                        },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { type: "input", name: "OffsetX", value: data.OffsetX, label: "左边距", width: 35 },
                                { type: "newcolumn", offset: 20 },
                                { type: "input", name: "OffsetY", value: data.OffsetY, label: "上边距", width: 35, labelWidth: 55 }
                            ]
                        },
                        { type: "input", name: "ClassName", value: data.ClassName, label: "样式类名", tooltip: "classname" },
                        { type: "input", name: "Style", value: data.Style, label: "用户样式", tooltip: "style" }
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
            if (name == "btnDataOps") {
                if (!data.Options) data.Options = [];
                dhtmlx.nameValues(data.Options, function (o) {
                    data.Options = o;
                });
            }
            if (name == "btnUserData") {
                if (!data.UserData) data.UserData = [];
                dhtmlx.nameValues(data.UserData, function (o) {
                    data.UserData = o;
                });
            }

            if (name == "btnSet") {
                var inputtype = this.getItemValue("InputType");
                if (inputtype == "grid") {
                    if (!data.Columns) data.Columns = [];
                    var w1 = dhtmlx.configureDhxGrid(data.Columns, function (o) {
                        data.Columns = o;
                    });
                    w1.toolbar.addItem({ ID: "load", Pos: 1, Type: "button", Text: "导入" });
                    w1.toolbar.attachEvent("onclick", function (id) {
                        if (id == "load") {
                            createLoadForm(function (table) {
                                $.ajax({
                                    type: "POST",
                                    url: "/Designer/GetFeilds/" + table,
                                    success: function (response) {
                                        if (response.Success) {
                                            for (var i = 0; i < response.Result.length; i++) {
                                                var d = response.Result[i];
                                                if (d.DataType == 'str') d.InputType = 'ro';
                                                if (d.DataType == 'int') d.InputType = 'edncl';
                                                if (d.DataType == 'date') d.InputType = 'dhxCalendar';
                                                if (d.DataType == 'bool') d.InputType = 'ch';
                                            }

                                            w1.dhxGrid.clearAll();
                                            w1.dhxGrid.parse(response.Result, "js");
                                        }
                                    }
                                });
                            });
                        }
                        return true;
                    });
                }
                else {
                    dhtmlx.alert("容器才需要设置！");
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
        changeView();
    }
    function contextRemove(data) {
        dhtmlx.remove(DesignData.Context, "Name", data.Name);
        myDataView.clearAll();
        myDataView.parse(DesignData.Context, "json");
    }
    function createLoadForm(callback) {
        var w1 = dhtmlx.showDialog({
            caption: '导入数据表字段',
            width: 500,
            height: 450,
            modal: true,
            saveText: "确定",
            save: function () {
                var name = grid.getValue(null, "Name");
                if (callback) callback(name);
                w1.close();
            }
        });
        var lay = w1.layout.cells("a");
        var grid = lay.attachGrid().format({
            autowidth: false,
            remote: false,
            orders: [
                { Name: 'CreateDate', Desc: false }
            ],
            columns: [
                { Name: "Name", Width: 180, InputType: "ro", DataType: "str", Align: "left", Label: "表名" },
                { Name: "Desc", Width: 250, InputType: "ro", DataType: "str", Align: "left", Label: "说明" },
            ]
        });
        
        
        //导入UI
        $.ajax({
			   type: 'POST',
			   url: '/design/seldesign2.action' ,
			   success: function(res){	   
				   grid.parse(res,"json");
				  
			   }
		   })
       
		
		   
		   
        grid.attachEvent("onRowDblClicked", function (rId, cInd) {
            var name = this.getValue(rId, "Name");
            if (callback) callback(name);
            w1.close();
        });

    }

    function getFeilds(table) {
        $.ajax({
            type: "POST",
            url: '/design/seldesign2.action',
            data:{TableName: table},
            success: function (response) {
            	var data = JSON.parse(response.rows[0].data[2]);
            	
                if (data) {
                    clientData.TableName = table;
                    DesignData.Context = data.Context;
                   
                    init();
                }
            }
        });
    }

    myDataView = myTabbar.tabs("a2").attachDataView({
        type: {
            template: "#Name# <br>[#Label#] : ",
            padding: 5,
            height: 40
        },
        drag: true
    });

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
                changeView();
            }
        }
    });




    //创建布局设计页面
    myLayout = myTabbar.tabs("a1").attachLayout({
        pattern: "2E",
        cells: [
            { id: "a", header: false, text: "布局", height: 200 },
            { id: "b", header: true, text: "属性" }
        ]
    });

    //初始化布局树
    layoutTree = myLayout.cells("a").attachTree();
    layoutTree.setImagePath("/DHX/imgs/dhxtree_terrace/");
    layoutTree.enableDragAndDrop(true);

    //布局类型
    function basePatterns() {
        var patterns = [];
        var listPatterns = myLayout.listPatterns();
        for (var i = 0; i < listPatterns.length; i++) {
            patterns.push({
                text: listPatterns[i],
                value: listPatterns[i]
            });
        }
        return patterns;
    }
    function basePropertyFormData(data) {
        ///各类型的属性数据 用于创建属性页面来调整参数
        var formData = {
            layout: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "right" },
                {
                    name: "Type", label: "类型", type: "select", value: data.Type, options: [
                        { text: "单元格", value: "cell" },
                        { text: "布局页", value: "layout" },
                        { text: "页签", value: "tabbar" },
                        { text: "手风琴", value: "accordion" }
                    ]
                },
                { name: "Text", label: "标题", type: "input", value: data.Text },
                { name: "Pattern", label: "模式", type: "select", value: data.Pattern, options: basePatterns() }
            ],
            cell: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "right" },
                {
                    type: "block", width: 220, blockOffset: 5, list: [
                        {
                            name: "Type", label: "类型", type: "select", value: data.Type, options: [
                                { text: "单元格", value: "cell" },
                                { text: "布局页", value: "layout" },
                                { text: "页签", value: "tabbar" },
                                { text: "手风琴", value: "accordion" }
                            ]
                        },
                        { name: "Text", label: "标题", type: "input", value: data.Text },
                        { name: "Header", label: "显示标题", checked: true, type: "checkbox", checked: data.Header ? data.Header : true },
                        { name: "Collapsed_Text", label: "折叠标题", type: "input", value: data.Collapsed_Text },
                        {
                            type: "block", width: 220, blockOffset: 0, list: [
                                { name: "Width", label: "宽度", type: "input", value: data.Width, width: 40 },
                                { type: "newcolumn", offset: 1 },
                                { name: "Height", label: "高度", type: "input", value: data.Height, width: 40, labelWidth: 40 }
                            ]
                        },
                        { name: "Collapse", label: "是否折叠", type: "checkbox", checked: data.Collapse },
                        {
                            type: "block", width: 200, blockOffset: 0, list: [
                                { name: "Fix_Width", label: "固定宽度", type: "checkbox", checked: data.Fix_Width },
                                { type: "newcolumn", offset: 20 },
                                { name: "Fix_Height", label: "固定高度", type: "checkbox", checked: data.Fix_Height }
                            ]
                        },
                        { name: "HasStatus", label: "有状态栏", type: "checkbox", checked: data.HasStatus },
                        { name: "StatusHeight", label: "状态栏高", type: "input", width: 50, value: data.StatusHeight, },
                        { name: "StatusText", label: "状态文本", type: "input", value: data.StatusText },
                        {
                            type: "block", width: 200, blockOffset: 0, list: [
                                { name: "HasToolbar", label: "有工具条", type: "checkbox", checked: data.HasToolbar },
                                { type: "newcolumn", offset: 20 },
                                { name: "ToobarItems", label: "设置", type: "button", className: "button", value: "设置" }
                            ]
                        }
                       
                    ]
                }
            ],
            tabbar: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "right" },
                {
                    name: "Type", label: "类型", type: "select", value: data.Type, options: [
                        { text: "单元格", value: "cell" },
                        { text: "布局页", value: "layout" },
                        { text: "页签", value: "tabbar" },
                        { text: "手风琴", value: "accordion" }
                    ]
                },
                {
                    name: "Mode", label: "页签位置", type: "select", value: data.Mode, options: [
                        { text: "上面", value: "top" },
                        { text: "下面", value: "bottom" }
                    ]
                },
                {
                    name: "Align", label: "对齐", type: "select", value: data.Align, options: [
                        { text: "靠左", value: "left" },
                        { text: "举重", value: "right" },
                        { text: "靠右", value: "" }
                    ]
                },
                { name: "Close_Button", label: "关闭按钮", checked: data.Close_Button, type: "checkbox" },
                { name: "Content_zone", label: "内容区域", checked: data.Content_zone, type: "checkbox" },
                {
                    name: "Arrows_Mode", label: "左右箭头", type: "select", value: data.Arrows_Mode, options: [
                        { text: "自动", value: "auto" },
                        { text: "显示", value: "always" }
                    ]
                },
                {
                    name: "Count", label: "页签数量", value: 2, type: "select", value: data.Count, options: [
                        { text: "1", value: "1" },
                        { text: "2", value: "2" },
                        { text: "3", value: "3" },
                        { text: "4", value: "4" },
                        { text: "5", value: "5" },
                        { text: "6", value: "6" },
                        { text: "7", value: "7" },
                        { text: "8", value: "8" }
                    ]
                }
            ],
            tab: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "right" },
                {
                    type: "block", width: 220, blockOffset: 5, list: [
                        {
                            name: "Type", label: "类型", type: "select", value: data.Type, options: [
                                { text: "单元格", value: "tab" },
                                { text: "布局页", value: "layout" },
                                { text: "页签", value: "tabbar" },
                                { text: "手风琴", value: "accordion" }
                            ]
                        },
                        { name: "Text", label: "标题", type: "input", value: data.Text },
                        { name: "Width", label: "宽度", type: "input", value: data.Width, width: 50 },
                        { name: "Close", label: "能关闭", checked: data.Close, type: "checkbox" },
                        { name: "Active", label: "是否激活", checked: data.Active, type: "checkbox" },
                        { name: "Enabled", label: "可用", checked: data.Enabled, type: "checkbox" },
                        { name: "HasStatus", label: "有状态栏", type: "checkbox", checked: data.HasStatus },
                        { name: "StatusHeight", label: "状态栏高", type: "input", width: 50, value: data.StatusHeight },
                        { name: "StatusText", label: "状态文本", type: "input", value: data.StatusText },
                        {
                            type: "block", width: 200, blockOffset: 0, list: [
                                { name: "HasToolbar", label: "有工具条", type: "checkbox", checked: data.HasToolbar },
                                { type: "newcolumn", offset: 20 },
                                { name: "ToobarItems", label: "设置", type: "button", className: "button", value: "设置" }
                            ]
                        }
                    ]
                }
            ],
            accordion: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "right" },
                {
                    name: "Type", label: "类型", type: "select", value: data.Type, options: [
                        { text: "单元格", value: "cell" },
                        { text: "布局页", value: "layout" },
                        { text: "页签", value: "tabbar" },
                        { text: "手风琴", value: "accordion" }
                    ]
                },
                {
                    name: "Count", label: "页签数量", value: 2, type: "select", value: data.Count, options: [
                        { text: "1", value: "1" },
                        { text: "2", value: "2" },
                        { text: "3", value: "3" },
                        { text: "4", value: "4" },
                        { text: "5", value: "5" },
                        { text: "6", value: "6" },
                        { text: "7", value: "7" },
                        { text: "8", value: "8" }
                    ]
                }
            ],
            item: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "right" },
                {
                    type: "block", width: 220, blockOffset: 5, list: [
                        {
                            name: "Type", label: "类型", type: "select", value: data.Type, options: [
                                { text: "单元格", value: "item" },
                                { text: "布局页", value: "layout" },
                                { text: "页签", value: "tabbar" },
                                { text: "手风琴", value: "accordion" }
                            ]
                        },
                        { name: "Text", label: "标题", type: "input", value: data.Text },
                        { name: "Icon", label: "图标", type: "input", value: data.Icon },
                        { name: "Open", label: "是否展开", checked: data.Open, type: "checkbox" },
                        { name: "Height", label: "高度", type: "input", value: data.Height },
                        { name: "HasStatus", label: "有状态栏", type: "checkbox", checked: data.HasStatus },
                        { name: "StatusHeight", label: "状态栏高", type: "input", width: 50, value: data.StatusHeight },
                        { name: "StatusText", label: "状态文本", type: "input", value: data.StatusText },
                        {
                            type: "block", width: 200, blockOffset: 0, list: [
                                { name: "HasToolbar", label: "有工具条", type: "checkbox", checked: data.HasToolbar },
                                { type: "newcolumn", offset: 20 },
                                { name: "ToobarItems", label: "设置", type: "button", className: "button", value: "设置" }
                            ]
                        }
                    ]
                }
            ]

        };
        return formData[data.Type];
    }
    function baseEventFormData(data) {
        var formdata = {
            layout: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "left" },
                {
                    type: "block", width: 220, blockOffset: 5, list: [
                        { type: "label", label: "事件" },
                        { type: "checkbox", name: "Collapse", position: "label-right", checked: data.Collapse, label: "折叠" },
                        { type: "checkbox", name: "ContentLoaded", position: "label-right", checked: data.ContentLoaded, label: "内容加载" },
                        { type: "checkbox", name: "DblClick", position: "label-right", checked: data.DblClick, label: "双击" },
                        { type: "checkbox", name: "Dock", position: "label-right", checked: data.Dock, label: "停靠窗口" },
                        { type: "checkbox", name: "Expand", position: "label-right", checked: data.Expand, label: "窗口展开" },
                        { type: "checkbox", name: "PanelResizeFinish", position: "label-right", checked: data.PanelResizeFinish, label: "单元调整" },
                        { type: "checkbox", name: "ResizeFinish", position: "label-right", checked: data.ResizeFinish, label: "布局调整" },
                        { type: "checkbox", name: "Undock", position: "label-right", checked: data.Undock, label: "脱离窗口" },
                        { type: "newcolumn", offset: 20 },
                        { type: "label", label: "代码" },
                        { type: "button", name: "OnCollapse", value: "代码", className: "button", userdata: { def: "function(name){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnContentLoaded", value: "代码", className: "button", userdata: { def: "function(id){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnDblClick", value: "代码", className: "button", userdata: { def: "function(name){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnDock", value: "代码", className: "button", userdata: { def: "function(name){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnExpand", value: "代码", className: "button", userdata: { def: "function(name){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnPanelResizeFinish", value: "代码", className: "button", userdata: { def: "function(names){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnResizeFinish", value: "代码", className: "button", userdata: { def: "function(){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnUndock", value: "代码", className: "button", userdata: { def: "function(name){ \r\n\r\n\r\n}" } }
                    ]
                }
            ],
            cell: [],
            tabbar: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "left" },
                {
                    type: "block", width: 220, blockOffset: 5, list: [
                        { type: "label", label: "事件" },
                        { type: "checkbox", name: "ContentLoaded", position: "label-right", checked: data.ContentLoaded, label: "内容加载" },
                        { type: "checkbox", name: "Select", position: "label-right", checked: data.Select, label: "被选中" },
                        { type: "checkbox", name: "TabClick", position: "label-right", checked: data.TabClick, label: "点击标签 " },
                        { type: "checkbox", name: "TabClose", position: "label-right", checked: data.TabClose, label: "关闭按钮" },
                        { type: "checkbox", name: "XLE", position: "label-right", checked: data.XLE, label: "数据呈现" },
                        { type: "newcolumn", offset: 20 },
                        { type: "label", label: "代码" },
                        { type: "button", name: "OnContentLoaded", value: "代码", className: "button", userdata: { def: "function(id){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnSelect", value: "代码", className: "button", userdata: { def: "function(id, lastId){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnTabClick", value: "代码", className: "button", userdata: { def: "function(id, lastId){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnTabClose", value: "代码", className: "button", userdata: { def: "function(id){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnXLE", value: "代码", className: "button", userdata: { def: "function(name){ \r\n\r\n\r\n}" } }
                    ]
                }
            ],
            tab: [],
            accordion: [
                { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "left" },
                {
                    type: "block", width: 220, blockOffset: 5, list: [
                        { type: "label", label: "事件" },
                        { type: "checkbox", name: "Active", position: "label-right", checked: data.Active, label: "激活" },
                        { type: "checkbox", name: "BeforeActive", position: "label-right", checked: data.BeforeActive, label: "激活前" },
                        { type: "checkbox", name: "BeforeDrag", position: "label-right", checked: data.BeforeDrag, label: "拖动前 " },
                        { type: "checkbox", name: "ContentLoaded", position: "label-right", checked: data.ContentLoaded, label: "数据加载" },
                        { type: "checkbox", name: "Dock", position: "label-right", checked: data.Dock, label: "窗口停靠" },
                        { type: "checkbox", name: "Drop", position: "label-right", checked: data.Drop, label: "拖动" },
                        { type: "checkbox", name: "UnDock", position: "label-right", checked: data.UnDock, label: "窗口分离" },
                        { type: "checkbox", name: "XLE", position: "label-right", checked: data.XLE, label: "数据呈现" },
                        { type: "newcolumn", offset: 20 },
                        { type: "label", label: "代码" },
                        { type: "button", name: "OnActive", value: "代码", className: "button", userdata: { def: "function(id, state){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnBeforeActive", value: "代码", className: "button", userdata: { def: "function(id, state){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnBeforeDrag", value: "代码", className: "button", userdata: { def: "function(id, index){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnContentLoaded", value: "代码", className: "button", userdata: { def: "function(id){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnDock", value: "代码", className: "button", userdata: { def: "function(id){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnDrop", value: "代码", className: "button", userdata: { def: "function(id, indexOld, indexNew){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnUnDock", value: "代码", className: "button", userdata: { def: "function(id){ \r\n\r\n\r\n}" } },
                        { type: "button", name: "OnXLE", value: "代码", className: "button", userdata: { def: "function(){ \r\n\r\n\r\n}" } }
                    ]
                }
            ],
            item: []
        };
        return formdata[data.Type];
    }


    //创建一个布局树节点
    function createLayoutTreeNode(pid, data, nid) {
        //当前树节点类型
        var img = data.Type + ".png";
        var nodeId;
        if (typeof (nid) == "undefined") {
            nodeId = $.newGuid();
            layoutTree.insertNewChild(pid, nodeId, data.Text, function (tid) {
                var useDate = layoutTree.getUserData(tid, "Data");
                var pFormData = basePropertyFormData(useDate);
                var eFormData = baseEventFormData(useDate);
                if(useDate.Text == "主页面"){
                	var arr1 = {name:"PositioningBar",label: "导航栏",type:"checkbox"};
                	var a = document.getElementById("PositioningBar");
                	if(a){
                		arr1 = {name:"PositioningBar",label: "导航栏",type:"checkbox",checked:true};
                	}
                	
                	pFormData[pFormData.length] = arr1;
                	
                }
                ///如果是父节点 禁止改变类型
                pFormData[1].disabled = layoutTree.getParentId(tid) == "0";
                createPropertyForm(pFormData,useDate.Child);
                createEventForm(eFormData);
            }, img, img, img);
        }
        else {
            nodeId = nid;
            layoutTree.setItemImage(nid, img);
            layoutTree.setItemText(nid, data.Text);

        }
        layoutTree.setUserData(nodeId, "Data", data);
        var childCount = 0;
        if (data.Type == "layout") childCount = parseInt(data.Pattern.substring(0, 1));
        if (data.Type == "tabbar") childCount = data.Count;
        if (data.Type == "accordion") childCount = data.Count;

        if (!data.Child) data.Child = [];
        if (data.Child.length > childCount)
            data.Child.length = childCount;
        else {
            var ctype = "cell";
            if (data.Type == "tabbar") ctype = "tab";
            if (data.Type == "accordion") ctype = "item";
            for (var i = data.Child.length; i < childCount; i++) {
                data.Child.push({
                    Text: "abcdefgh".substring(i, i + 1),
                    Type: ctype
                });
            }
        }
        layoutTree.deleteChildItems(nodeId);
        for (var i = 0; i < data.Child.length; i++) {
            createLayoutTreeNode(nodeId, data.Child[i]);
        }
        return nodeId;
    }

    //创建设计页签
    var myTabbar = myLayout.cells("b").attachTabbar({
        close_button: false,
        arrows_mode: 'auto',
        tabs: [
            { id: "a1", text: "属性", active: true, close: false },
            { id: "a2", text: "事件", close: false }
        ]
    });

    //创建一个属性表单
    var propertyForm = myTabbar.tabs("a1").attachForm({});
  
    
    function createPropertyForm(data,pageName) {
        propertyForm.unload();
        propertyForm = null;
          
        propertyForm = myTabbar.tabs("a1").attachForm(data);

        propertyForm.attachEvent("onChange", function (name, value, state) {
            var treeNodeId = layoutTree.getSelectedItemId();
            var userData = layoutTree.getUserData(treeNodeId, "Data");
            if (userData != null) {
                var type = propertyForm.getItemType(name);
                if (type == "checkbox" || type == "radio"){
                    userData[name] = state;
                    if(name == 'PositioningBar'&& userData[name] == true){                  	
                    	var a = document.getElementById("winVP");
                    	a.style.cssText = "width:86%;height:95%;margin-left:10%;box-shadow: 0 0 6px #a0a0a0;margin-top:1.5%;overflow:scroll;";              
                    	var box = $(".dhx_cell_layout")[6];                                	
                    	var dom = document.createElement('div'); 
                    	dom.id = "PositioningBar";
                    	dom.style.cssText = "width:10%;height:95%;margin-top:1.5%;";                   	
                    	box.appendChild(dom);
                    	showPositioningBar(dom,pageName);
                    }      
                    if(name == 'PositioningBar'&& userData[name] == false){
                    	var a = document.getElementById("winVP");
                    	a.scrollTop = 0;
                    	a.style.cssText = "width:86%;height:95%;margin-left:7%;box-shadow: 0 0 6px #a0a0a0;margin-top:1.5%;overflow:scroll;";                   
                    		document.getElementById("PositioningBar").remove();                         			
                    }                   
                }
                else
                    userData[name] = value;
            }

            //如果改变了类型或者模式或者数量
            if (name == "Type" || name == "Pattern" || name == "Count") {
                //设置默认值
                if (typeof (userData.Pattern) == "undefined") userData.Pattern = "2E";
                if (typeof (userData.Count) == "undefined") userData.Count = "2";
                var ctype = "cell";
                if (userData.Type == "tabbar") ctype = "tab";
                if (userData.Type == "accordion") ctype = "item";
                if (typeof (userData.Child) == "undefined") {
                    userData.Child = [];
                    userData.Child.push({ Type: ctype, Text: "a" });
                    userData.Child.push({ Type: ctype, Text: "b" });
                }
                for (var i = 0; i < userData.Child.length; i++) {
                    if (userData.Child[i].Type == "cell" || userData.Child[i].Type == "tab" || userData.Child[i].Type == "item") {
                        userData.Child[i].Type = ctype;
                    }
                }
                var pid = layoutTree.getParentId(treeNodeId);
                treeNodeId = createLayoutTreeNode(pid, userData, treeNodeId);
                layoutTree.selectItem(treeNodeId, true, true);
                var box = document.getElementById("PositioningBar");
                if(box){
                	propertyForm.setItemValue(PositioningBar, true);
                	box.innerHTML='';
                	showPositioningBar(box,userData.Child);
                }
               
            }
            if (name == "Text") {
                layoutTree.setItemText(treeNodeId, value);
            }
            changeView();

        });
        propertyForm.attachEvent("onButtonClick", function (name) {

            var w1 = dhtmlx.showDialog({
                caption: "工具条设置",
                width: 700,
                height: 400,
                save: save
            });
            function save() {
                userData.ToolbarItems = toolbar.ToolbarItems;
                w1.close();
                changeView();
            }
            var lay = w1.layout.cells("a").attachLayout({
                pattern: "2E",
                cells: [
                    { id: "a", header: true, text: "设置" },
                    { id: "b", header: true, text: "工具条预览", height: 100 }
                ]
            });
            var toolbar = lay.cells("b").attachToolbar({ icons_path: "/DHX/imgs/dhxtoolbar_terrace/" });
            var treeNodeId = layoutTree.getSelectedItemId();
            var userData = layoutTree.getUserData(treeNodeId, "Data");
            if (userData && userData.ToolbarItems) {
                toolbar.addItems(userData.ToolbarItems);
            }
            function initformData() {
                formStructure = [
                    { type: "settings", position: "label-left", labelWidth: 60, inputWidth: 120, labelAlign: "right" },
                    {
                        type: "block", width: 660, blockOffset: 5, list: [
                            { type: "input", name: "ID", value: "", label: "ID" },

                            { type: "input", name: "Img", value: "", label: "活动图标" },
                            {
                                type: "block", width: 200, blockOffset: 0, list: [
                                    { type: "checkbox", name: "Enabled", checked: true, label: "可用" },
                                    { type: "newcolumn", offset: 20 },
                                    { type: "checkbox", name: "Hidden", checked: false, label: "隐藏" }
                                ]
                            },
                            { type: "newcolumn", offset: 20 },
                            { type: "input", name: "Text", value: "", label: "名称" },
                            { type: "input", name: "ImgDis", value: "", label: "失效图片" },
                            {
                                type: "block", width: 200, blockOffset: 0, list: [
                                    { type: "input", name: "Width", value: "70", label: "宽度", width: 40 },
                                    { type: "newcolumn", offset: 0 },
                                    { type: "input", name: "Pos", value: "", label: "位置", width: 40, labelWidth: 40 }
                                ]
                            },
                            { type: "newcolumn", offset: 20 },
                            {
                                type: "select", name: "Type", value: "", label: "类型", options: [
                                    { text: "按钮", value: "button" },
                                    { text: "下拉菜单", value: "buttonselect" },
                                    { text: "分割线", value: "separator" },
                                    { text: "输入框", value: "input" },
                                    { text: "文本", value: "text" }
                                ]
                            },
                            { type: "input", name: "Title", value: "", label: "提示" },
                            { type: "button", name: "addbaseL", value: "按钮L" },
                            { type: "button", name: "addbaseH", value: "按钮H" },
                            { type: "button", name: "addbases", value: "按钮B" },
                            { type: "hidden", name: "Action", value: "" },
                        ]
                    },
                    { type: "newcolumn", offset: 20 },
                    {
                        type: "block", width: 620, blockOffset: 5, offsetTop: 20, list: [
                            { type: "button", name: "add", value: "新增" },
                            { type: "newcolumn", offset: 20 },
                            { type: "select", name: "Node", width: "70", label: "节点", offsetTop: 10, options: [{ text: "", value: "" }] },
                            { type: "newcolumn", offset: 0 },
                            { type: "button", name: "del", value: "删除", disabled: true },
                            { type: "newcolumn", offset: 0 },
                            { type: "button", name: "addc", value: "增为子项", disabled: true },
                            { type: "newcolumn", offset: 20 },
                            { type: "button", name: "onAction", value: "事件代码", disabled: true },
                            { type: "newcolumn", offset: 10 },
                            { type: "button", name: "onUserData", value: "用户数据", disabled: true }
                        ]
                    }
                ];
                return formStructure;
            }

            var designForm = lay.cells("a").attachForm(initformData());

            function reloadOptions() {
                if (toolbar && toolbar.ToolbarItems) {
                    var opts = [{ text: "", value: "" }];
                    for (var i = 0; i < toolbar.ToolbarItems.length; i++) {
                        opts.push({
                            text: toolbar.ToolbarItems[i].Text,
                            value: toolbar.ToolbarItems[i].ID
                        });
                    }
                    designForm.reloadOptions("Node", opts);
                }
            }

            reloadOptions();

            designForm.attachEvent("onChange", function (name, value, state) {
                if (name == "Node") {
                    if (value) {
                        designForm.enableItem("del");
                        designForm.enableItem("addc");
                        designForm.enableItem("onAction");
                        designForm.enableItem("onUserData");
                        designForm.setFormData(dhtmlx.find(toolbar.ToolbarItems, "ID", value));
                    }
                    else {
                        designForm.disableItem("del");
                        designForm.disableItem("addc");
                        designForm.disableItem("onAction");
                        designForm.disableItem("onUserData");
                    }

                }
            });
            designForm.attachEvent("onButtonClick", function (name) {
                if (name == "onAction") {
                    var text = "点击事件代码";
                    var node = designForm.getItemValue("Node");
                    var nodeItem = toolbar.getToolBarItem(node);
                    var code = nodeItem.Action;
                    var w1 = dhtmlx.showDialog({
                        caption: text,
                        width: 702,
                        height: 400,
                        save: function () {
                            var code = eventCodeForm.getItemValue("code");
                            nodeItem.Action = code;
                            w1.close();
                        }
                    });
                    if (code.length == 0) code = "function(){ \r\n\r\n\r\n}";
                    formStructure = [
                        { type: "input", name: "code", value: code, rows: 18, width: 670 },
                    ];
                    var eventCodeForm = w1.layout.cells("a").attachForm(formStructure);
                }
                if (name == "onUserData") {
                    var node = designForm.getItemValue("Node");
                    var nodeItem = toolbar.getToolBarItem(node);
                    if (!nodeItem.UserData) nodeItem.UserData = [];
                    dhtmlx.nameValues(nodeItem.UserData, function (o) {
                        nodeItem.UserData = o;
                    });
                }
                if (name == "add") {
                    var formData = designForm.getFormData();
                    formData.Node = null;
                    toolbar.addItem(formData);
                }
                if (name == "del") {
                    var id = designForm.getItemValue("ID");
                    toolbar.deleteItem(id);
                    designForm.disableItem("del");
                    designForm.disableItem("addc");
                    designForm.disableItem("onAction");
                }

                if (name == "addc") {
                    var formData = designForm.getFormData();
                    if (formData.Node) {
                        toolbar.addItem(formData);
                    }
                    else {
                        dhtmlx.alert("请选父节点！");
                        return;
                    }
                }
                if (name == "addbaseL") {
                    toolbar.addItems([
                        { ID: "print", Text: "打印", Type: "button", Img: "print.png", Pos: 1 },
                        { ID: "preview", Text: "预览", Type: "button", Img: "preview.png", Pos: 2 },
                        { ID: "import", Text: "导入", Type: "button", Img: "import.png", Pos: 3 },
                        { ID: "export", Text: "导出", Type: "button", Img: "export.png", Pos: 4 },
                        { ID: "step1", Type: "separator", Pos: 5 },
                        { ID: "add", Text: "增加", Type: "button", Img: "add.png", Pos: 10 },
                        { ID: "edit", Text: "修改", Type: "button", Img: "edit.png", Pos: 12 },
                        { ID: "del", Text: "删除", Type: "button", Img: "del.png", Pos: 14 },
                        { ID: "step2", Type: "separator", Pos: 30 },
                        { ID: "refresh", Text: "刷新", Type: "button", Img: "refresh.png", Pos: 45 },
                        { ID: "help", Text: "帮助", Type: "button", Img: "help.png", Pos: 48 },
                        { ID: "exit", Text: "关闭", Type: "button", Img: "exit.png", Pos: 50 },
                    ]);
                }
                if (name == "addbaseH") {
                    toolbar.addItems([
                        { ID: "add", Text: "增加", Type: "button", Img: "add.png", Pos: 10 },
                        { ID: "edit", Text: "修改", Type: "button", Img: "edit.png", Pos: 12 },
                        { ID: "del", Text: "删除", Type: "button", Img: "del.png", Pos: 14 },
                        { ID: "save", Text: "保存", Type: "button", Img: "save.png", Pos: 16 },
                        { ID: "step2", Type: "separator", Pos: 30 },
                        { ID: "frist", Text: "", Type: "button", Img: "ar_left_abs.gif", Pos: 31 },
                        { ID: "forward", Text: "", Type: "button", Img: "ar_left.gif", Pos: 32 },
                        { ID: "next", Text: "", Type: "button", Img: "ar_right.gif", Pos: 33 },
                        { ID: "last", Text: "", Type: "button", Img: "ar_right_abs.gif", Pos: 34 },
                        { ID: "step3", Type: "separator", Pos: 40 },
                        { ID: "refresh", Text: "刷新", Type: "button", Img: "refresh.png", Pos: 45 },
                        { ID: "help", Text: "帮助", Type: "button", Img: "help.png", Pos: 48 },
                        { ID: "exit", Text: "关闭", Type: "button", Img: "exit.png", Pos: 50 },
                    ]);
                }
                if (name == "addbases") {
                    toolbar.addItems([

                        { ID: "edits", Text: "修改", Type: "button", Img: "edit.png", Pos: 1 },
                        { ID: "step1", Type: "separator", Pos: 2 },
                        { ID: "adds", Text: "增行", Type: "button", Img: "AddRow.gif", Pos: 3 },
                        { ID: "dels", Text: "删行", Type: "button", Img: "DelLine.gif", Pos: 4 },
                        { ID: "saves", Text: "保存", Type: "button", Img: "save.png", Pos: 5 },
                        { ID: "step2", Type: "separator", Pos: 6 },
                        { ID: "refresh", Text: "刷新", Type: "button", Img: "refresh.png", Pos: 7 },
                    ]);
                }
                if (name != "onAction" && name != "onAction") {
                    var opts = [{ text: "", value: "" }];
                    for (var i = 0; i < toolbar.ToolbarItems.length; i++) {
                        opts.push({
                            text: toolbar.ToolbarItems[i].Text,
                            value: toolbar.ToolbarItems[i].ID
                        });
                    }
                    designForm.reloadOptions("Node", opts);
                }
            });

        });
    }
    //创建一个事件表单
    var eventForm = myTabbar.tabs("a2").attachForm({});
    function createEventForm(data) {
        eventForm.unload();
        eventForm = null;
        eventForm = myTabbar.tabs("a2").attachForm(data);
        eventForm.attachEvent("onChange", function (name, value, state) {
            var treeNodeId = layoutTree.getSelectedItemId();
            var userData = layoutTree.getUserData(treeNodeId, "Data");
            if (userData != null) {
                if (!userData.Events) userData.Events = [];
                var events = userData.Events;
                var evname = "On" + name;
                if (state) {
                    var code = eventForm.getUserData(evname, "def");
                    addEvent(events, { Text: evname, Value: code });
                }
                else {
                    delEvent(events, evname);
                }
            }
            changeView();
        });
        eventForm.attachEvent("onButtonClick", function (name) {
            var treeNodeId = layoutTree.getSelectedItemId();
            var userData = layoutTree.getUserData(treeNodeId, "Data");

            var text = eventForm.getItemLabel(name.substring(2));
            text += "事件代码";
            var code = userData[name];
            if (!code) code = eventForm.getUserData(name, "def");
            var w1 = dhtmlx.showDialog({
                caption: text,
                width: 702,
                height: 400,
                save: function () {
                    var code = eventCodeForm.getItemValue("code");
                    eventForm.setUserData(name, "def", code);
                    var n = name.substring(2);
                    var checked = eventForm.getItemValue(n);
                    if (checked == 1) {
                        if (!userData.Events) userData.Events = [];
                        addEvent(userData.Events, { Text: name, Value: code });
                    }
                    w1.close();
                    changeView();
                }
            });
            formStructure = [
                { type: "input", name: "code", value: code, rows: 18, width: 670 },
            ];
            var eventCodeForm = w1.layout.cells("a").attachForm(formStructure);
        });
    }

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

    function changeView() {
        changeName(DesignData);
        
        dhtmlx.layout(DesignData, viewWin);
        createDropForm(viewWin);

    }
    var ss = 1000;
    function changeName(a) {
        var isArray = function (b) {
            return Object.prototype.toString.call(b) == '[object Array]';
        };
        if (isArray(a.Child) && a.Child.length) {
            for (let i = 0; i < a.Child.length; i++) {
                if (a.Child[i].Height)
                    ss += parseInt(a.Child[i].Height);
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
    
    
    function showPositioningBar(dom,data){
    	
    	var formStructure = new Array();
    	for(var i = 0;i < data.length;i++){   
    		
    		var html = {type:"button",name:i+1,width:80,offsetLeft:20,offsetTop:20, value:data[i].Text};
    		formStructure.push(html);
        	
    	}
    	//添加导航栏
    	var myForm = new dhtmlXForm(dom,formStructure);
    	
    	
    	myForm.attachEvent("onButtonClick", function(id){
    		var model = dhxWins.vp.children[0].children[2].children[0].children[0].children[0];
    	    var first = model.children[0].clientHeight;
    	    var model2 = model.children[1].children[1].children[0].children[0];
    	    if(id >= 3){
    	    	var model3 = model2.children[1].children[1].children[0].children[0];
    	    }
    	    if(id >= 4){
    	    	var model4 = model3.children[1].children[1].children[0].children[0];
    	    }
    	    if(id > 5){
    	    	var model5 = model4.children[1].children[1].children[0].children[0];
    	    	var height5 = model5.children[0].clientHeight;
    	    }
    	    if(id > 6){
    	    	var model6 = model5.children[1].children[1].children[0].children[0];
    	    }
    	    if(id > 7){
    	    	var model7 = model6.children[1].children[1].children[0].children[0];
    	    }
    	    switch(id){
	    	    case 1:{
	    	    	document.getElementById("winVP").scrollTop = 0;
	    	    	break;
	    	    }
	    	    case 2:{
	    	    	document.getElementById("winVP").scrollTop = first+20;
	    	    	break;
	    	    }
	    	    case 3:{
	    	    	document.getElementById("winVP").scrollTop = first + model2.children[0].clientHeight + 30;
	    	    	break;
	    	    }
	    	    case 4:{
	    	    	document.getElementById("winVP").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight + 40;
	    	    	break;
	    	    }
	    	    case 5:{
	    	    	document.getElementById("winVP").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
	    	    	+ model4.children[0].clientHeight + 50;
	    	    	break;
	    	    }
	    	    case 6:{
	    	    	document.getElementById("winVP").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
	    	    	+ model4.children[0].clientHeight + height5 + 60;
	    	    	break;
	    	    }
	    	    case 7:{
	    	    	document.getElementById("winVP").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
	    	    	+ model4.children[0].clientHeight + height5 + model6.children[0].clientHeight + 70;
	    	    	break;
	    	    }
	    	    case 8:{
	    	    	document.getElementById("winVP").scrollTop = first + model2.children[0].clientHeight + model3.children[0].clientHeight 
	    	    	+ model4.children[0].clientHeight + height5 + model6.children[0].clientHeight + model7.children[0].clientHeight + 80;
	    	    	break;
	    	    }
    	    }
    	  
    	});
    }
   
 
    
    
    
    var viewWin = dhxWins.createWindow({
        id: "view",
        width: w,
        height: 2700,
        resize: false,
        modal: false,
        header: false,
        caption: "",
        park: false,
        move: false
    });
    function init() {
        //加载数据
        myDataView.clearAll();
        myDataView.parse(DesignData.Context, "json");
        layoutTree.deleteChildItems(0);
        //创建主布局树节点
        var layoutTreeRootId = createLayoutTreeNode(0, DesignData);

        //创建视图窗口
        changeView();
    }

    init();
    
    window.onresize = function(){
    	//var a = document.body.offsetWidth-486;console.log(a)
    	//aa.cells("c").setWidth(200);
    	
    	//$('#winVP')[0].parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.style.width = a+260 +'px';
    	//$('#winVP')[0].parentNode.parentNode.parentNode.parentNode.parentNode.style.width = a+260 +'px';
    	//$('#winVP')[0].parentNode.parentNode.parentNode.style.width = a+260 +'px';
    	//$('#winVP')[0].parentNode.parentNode.style.width = a +'px';
    	//$('#winVP')[0].parentNode.style.width = a +'px';
    	//$('#winVP')[0].style.width = a*0.86 +'px';
    	//aa.cells("b").cell.parentNode.children[2].style.left= a+262+'px';
    	
    	
    	
    	
    	//$('#winVP')[0].children[0].style.width = a*0.9 +'px';
    }
    
    
};
