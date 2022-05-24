var myLayout;
var myToolbar
var myTree;
var myGrid;
var myPager;
var myPop1;
var myPop2
$(function () {
    var myLayout = new dhtmlXLayoutObject({
        parent: document.body,
        pattern: "2U",
        cells: [
            { id: "a", header: false, width: 250 },
            { id: "b", header: false },
        ]
    });


    myToolbar = myLayout.cells("a").attachToolbar({
        icons_path: "/DHX/imgs/dhxtoolbar_terrace/",
    });

    myToolbar.addButton("add", 2, "", "add.png");
    myToolbar.addButton("edit", 3, "", "edit.png");
    myToolbar.addButton("del", 4, "", "del.png", "del.png");

    myPop1 =dhtmlx.popup({
        bar: myToolbar,
        id: "add",
        onShow: function () {
            var id = myTree.getSelectedItemId();
            myPop1.options.url = '/Admin/AddDict/' +id;
        },
        hasSubmit: true,
        success: function () { myTree.loadJson(); }
    });
    myPop2 =dhtmlx.popup({
        bar: myToolbar,
        id: "edit",
        onShow: function () {
            var id = myTree.getSelectedItemId();
            if (!id || id.length==0 ) {
                dhtmlx.error("请选择节点！");
                return;
            }
            myPop2.options.url = '/Admin/EditDict/' + id;
        }
    });
    myToolbar.attachEvent("onClick", function (id) {
        switch (id) {
            case "del":
                var id = myTree.getSelectedItemId();
                if (id) {
                    if (myTree.getAllSubItems(id).length > 0) {
                        dhtmlx.alert("非末级目录，不能删除！");
                        return false;
                    }
                    var attr = myTree.getUserData(id, "attr");
                    var text = myTree.getItemText(id);
                    if (attr.IsSys) {
                        dhtmlx.alert("系统内置目录，不能删除！");
                        return false;
                    }
                    dhtmlx.confirm({
                        text: "确定要删除[" + text + "]?",
                        callback: function (result) {
                            if (result) {
                                $.ajax({
                                    type: "POST",
                                    url: "/Admin/RemoveDict/" + id,
                                    success: function (data) {
                                        myTree.loadJson();
                                    },
                                });
                            }
                        }
                    });
                }
                else { dhtmlx.alert("请选择要删除的词典!"); }
                break;
        }
    });

    var myToolbar = myLayout.cells("b").attachToolbar();
    myToolbar.setIconsPath("/DHX/imgs/dhxtoolbar_terrace/");
    myToolbar.addButton("reload", 1, "刷新", "open.gif", "open_dis.gif");
    myToolbar.addSeparator("step1", 11);
    myToolbar.addButton("add", 2, "新增", "new.gif", "new_dis.gif");
    myToolbar.addButton("edit", 3, "修改", "edit.png", "edit.png");
    myToolbar.addButton("del", 4, "删除", "del.png", "del.png");
    myToolbar.addSeparator("step", 5);
    myToolbar.addButton("exit", 6, "关闭", "exit.png", "exit.png");


    myToolbar.attachEvent("onClick", function (id) {
        switch (id) {
            case "reload":
                myGrid.loadJson();
                break;
            case "close":
                top.closeActiveTab();
                break;
            case "add":
                dhtmlx.showDialog({
                    header: false,
                    minmax: false,
                    url: "/Admin/AddDictItem/" + myTree.getSelectedItemId()
                });
                break;
            case "edit":
                var id = myGrid.getValue(null, "ID");
                if (id == null) {
                    dhtmlx.alert("请选择词典类目！");
                    return false;
                }
                dhtmlx.showDialog({
                    minmax: false,
                    url: "/Admin/EditDictItem/" + id
                });
                break
            case "del":
                var text = myGrid.getValue(null, "ItemName");
                if (text == null) {
                    dhtmlx.alert("请选择词典类目！");
                    return false;
                }
                dhtmlx.confirm({
                    type: "confirm",
                    text: "确定要删除[" + text + "]?",
                    callback: function (result) {
                        if (result) {
                            var id = myGrid.getValue(null, "ID");
                            $.ajax({
                                type: "POST",
                                url: "/Admin/RemoveDict/" + id,
                                success: function (data) {
                                    if (data.Success) myGrid.loadJson();
                                    dhtmlx.alert(data);
                                },
                            });
                        }
                    }
                });
                break;
            default:
                break;
        }
    });


    myGrid = myLayout.cells("b").attachGrid().format({
        autowidth: false,
        url: "/Admin/GetDictItems",
        remote: false,
        orders: [
            { Name: 'ItemCode', Desc: false },
            { Name: 'ItemName', Desc: true }
        ],
        columns: [
            { Name: "ID", Width: 120, InputType: "ro", DataType: "str", Align: "left", Label: "ID", Hidden: true },
            { Name: "ItemCode", Width: 150, InputType: "ro", DataType: "str", Align: "left", Label: "编码", Header: "编码AA" },
            { Name: "ItemName", Width: 250, InputType: "ro", DataType: "str", Align: "center", Label: "名称", Frozen: false },
            { Name: "ItemValue", Width: 150, InputType: "ro", DataType: "str", Align: "left", Label: "值" },
            { Name: "ItemValue1", Width: 150, InputType: "co", DataType: "str", Align: "left", Label: "值", Options: [{ Text: "A", Value: "AA" }] },
            { Name: "ItemValue2", Width: 150, InputType: "ro", DataType: "str", Align: "left", Label: "值" },
            { Name: "ItemValue3", Width: 150, InputType: "ro", DataType: "str", Align: "left", Label: "值" },
            { Name: "ItemValue4", Width: 150, InputType: "ro", DataType: "str", Align: "left", Label: "值" },
            { Name: "ItemValue5", Width: 150, InputType: "ro", DataType: "str", Align: "left", Label: "值" },
        ]

    });


    var filter = [
        { Name: 'SysDictID', Op: 'equal', Value: '-1' }
    ];
    var orders = [
        { Name: 'ItemCode', Desc: false }
    ];

    myPager = myLayout.cells("b").pager({
        pageSize: 20,
        height: 34,
        target: myGrid,
        query: filter,
        order: orders
    });
    //var orders = [
    //   { field: 'ItemCode', desc: false }
    //];
    //pager.load();


    myTree = myLayout.cells("a").attachTree().format({
        action: function (id) {
            var text = this.getItemText(id);
            var attr = this.getUserData(id, "attr");
            var filter = [
                { Name: 'SysDictID', Op: 'equal', Value: id }
            ];
            myPager.load(filter);
        },
        url: '/admin/GetDicts'
    });

});




function addDict() {
    var node = $('#tt').tree("getSelected");
    var id = node == null ? "" : node.id;
    $.showDialog({
        iconCls: "icon-add",
        title: "新增词典",
        width: "400px",
        height: "300px",
        url: "/Admin/AddDict/" + id,
        success: function () { loadDict(); $("[tabindex=0]").focus(); },
    });
}
function editDic() {
    var node = $('#tt').tree("getSelected");
    if (node != null) {
        $.showDialog({
            iconCls: "icon-edit",
            title: "修改词典",
            width: "400px",
            height: "300px",
            url: "/Admin/EditDict/" + node.id,
            success: function () { loadDict(); $("[tabindex=0]").focus(); },
        })
    }
    else {
        $.messager.alert("提示", "请先选择行！", 'warning');
    }
}
function delDict() {
    var node = $('#tt').tree("getSelected");
    if (node != null) {

        if (!$('#tt').tree("isLeaf", node.target)) {
            $.messager.alert("提示", "非末级目录，不能删除！", 'warning');
            return false;
        }
        if (node.attributes.IsSys) {
            $.messager.alert("提示", "系统内置目录，不能删除！", 'warning');
            return false;
        }
        $.messager.confirm('提醒', '确定要删除[' + node.text + ']?', function (r) {
            if (r) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/RemoveDict/" + node.id,
                    success: function (data) {
                        if (data.Success) loadDict();
                        alertMessage(data);
                    },
                });
            }
        });
    }
    else {
        $.messager.alert("提示", "请先选择行！", 'warning');
    }
}
function loadDict() {
    $('#tt').tree({
        url: '/admin/GetDicts',
        onSelect: function (node) {
            loadGrid();
        },
    });
}
//列设置  可以从服务端取 datagrid("loadColumns");
function getFrozenColumns() {
    var columns = [[
        { field: 'ck', checkbox: true, title: '选择' }
    ]];
    return columns;
}
//列设置  可以从服务端取 datagrid("loadColumns");
function getColumns() {
    var columns = [[
            { field: 'ItemCode', title: '编码', edittype: 'text', datatype: 'text', width: 100, halign: 'center', sortable: true },
            { field: 'ItemName', title: '名称', edittype: 'text', datatype: 'text', width: 200, halign: 'center', sortable: true },
            { field: 'ItemValue', title: '值', edittype: 'text', datatype: 'text', width: 200, halign: 'center', sortable: true },
            { field: 'CreateUserName', title: '创建人', edittype: 'text', datatype: 'text', width: 150, halign: 'center', sortable: true },
            { field: 'CreateDate', title: '创建时间', edittype: 'text', datatype: 'text', width: 150, halign: 'center', sortable: true, formatter: Common.DateTimeFormatter },
            { field: 'ModifyUserName', title: '修改人', edittype: 'text', datatype: 'text', width: 150, halign: 'center', sortable: true },
            { field: 'ModifyDate', title: '修改时间', edittype: 'text', datatype: 'text', width: 150, halign: 'center', sortable: true, formatter: Common.DateTimeFormatter },
    ]];

    return columns;
}
/*
表格工具栏按钮  
如果是页面布局 直接 '#id'
*/
function getToolbar() {
    var tools = [
        { text: '刷新', iconCls: 'icon-reload', handler: loadGrid },
        '-',
        { text: '新增', iconCls: 'icon-add', handler: addItem },
        { text: '修改', iconCls: 'icon-edit', handler: editItem },
        { text: '删除', iconCls: 'icon-delete', handler: delItem },
        '-',
        { text: '关闭', iconCls: 'icon-exit', handler: function () { parent.currTabClose(); } },

    ];
    return tools;
};

function addItem() {
    var node = $('#tt').tree("getSelected");
    var id = node == null ? "" : node.id;
    $.showDialog({
        iconCls: "icon-add",
        title: "新增词典项目",
        width: "400px",
        height: "300px",
        url: "/Admin/AddDictItem/" + id,
        success: function () { loadGrid(); $("[tabindex=0]").focus(); },
        onLoad: function () {
            var o = $('#ItemValue').textbox('textbox');
            $('#ItemValue').textbox('textbox').bind('focus', function () {
                if (!this.value) {
                    this.value = $('#ItemName').textbox('getValue');
                }
            });
        },
    });
}
function editItem() {
    var row = $('#grid').datagrid("getSelected");
    if (row != null) {
        $.showDialog({
            iconCls: "icon-edit",
            title: "修改词典项目",
            width: "400px",
            height: "300px",
            url: "/Admin/EditDictItem/" + row.ID,
            success: function () { loadGrid(); $("[tabindex=0]").focus(); },
        })
    }
    else {
        $.messager.alert("提示", "请先选择行！", 'warning');
    }
}
function delItem() {
    var row = $('#grid').datagrid("getSelected");
    if (row != null) {
        $.messager.confirm('提醒', '确定要删除[' + row.ItemName + ']?', function (r) {
            if (r) {
                $.ajax({
                    type: "POST",
                    url: "/Admin/RemoveDictItem/" + row.ID,
                    success: function (data) {
                        if (data.Success) loadGrid();
                        alertMessage(data);
                    },
                });
            }
        });
    }
    else {
        $.messager.alert("提示", "请先选择行！", 'warning');
    }
}
function loadGrid() {
    var node = $('#tt').tree("getSelected");
    var id = node == null ? "" : node.id;
    var text = node == null ? "" : node.text;
    var filter = [
                {
                    field: 'SysDictID',
                    op: 'equal',
                    value: id
                }];
    $('#grid').datagrid({
        title: "词典目录:" + text,
        queryParams: { queryParams: JSON.stringify(filter) },
        url: "/Admin/GetDictItems"
    });

}







