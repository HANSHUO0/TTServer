$(function () {
    $('#grid').datagrid({
        title: "角色",
        idField: "ID",
        sortName: "ID",
        sortOrder: "asc",
        frozenColumns: getFrozenColumns(),
        columns: getColumns(),
        noheader: true,
        toolbar: getToolbar(),
    }).datagrid("loadColumns", "/Admin/GetRoles");
});
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
            { field: 'ID', title: '编码', edittype: 'text', datatype: 'text', width: 150, halign: 'center', sortable: true, hidden: true },
            { field: 'RoleName', title: '角色', edittype: 'text', datatype: 'text', width: 300, halign: 'center', sortable: true },
            { field: 'UseCount', title: '成员人数', edittype: 'text', datatype: 'text', width: 100, halign: 'center', sortable: true },
            { field: 'RoleGroup', title: '角色分类', edittype: 'text', datatype: 'text', width: 100, halign: 'center', sortable: true },
            { field: 'RoleDesc', title: '描述', edittype: 'text', datatype: 'text', width: 100, halign: 'center', sortable: true }

    ]];

    return columns;
}
/*
表格工具栏按钮  
如果是页面布局 直接 '#id'
*/
function getToolbar() {
    var tools = [
        { text: '刷新', iconCls: 'icon-reload', handler: add },
        '-',
        { text: '新增', iconCls: 'icon-add', handler: add },
        { text: '修改', iconCls: 'icon-edit', handler: edit },
        { text: '删除', iconCls: 'icon-delete', handler: del },
        { text: '详情', iconCls: 'icon-letter', handler: del },
        '-',
        { text: '权限设置', iconCls: 'icon-lock', handler: del },
        '-',
        { text: '关闭', iconCls: 'icon-exit', handler: function () { parent.currTabClose(); } },

    ];
    return tools;
};

function add() {
    $.showDialog({
        iconCls: "icon-add",
        title: "新增角色",
        width: "400px",
        height: "200px",
        url: "/Admin/AddRole/",
        callback: Refresh,
    });
}
function edit() {
    var row = $('#grid').datagrid("getSelected");
    if (row != null) {
        $.showDialog({
            iconCls: "icon-edit",
            title: "修改角色",
            width: "400px",
            height: "200px",
            url: "/Admin/EditRole/" + row.ID,
            callback: Refresh
        })
    }
    else {
        $.messager.alert("提示", "请先选择行！", 'warning');
    }
}

function del() {
    var row = $('#grid').datagrid("getSelected");
    if (row != null) {
        $.messager.confirm('提醒', '确定要删除[' + row.RoleName + ']?', function (r) {
            if (r) {
                $.ajax({
                    async: false,
                    type: "POST",
                    url: "/Admin/RemoveRole/" + row.ID,
                    dataType: "json",
                    success: function (result) {
                        Refresh();
                    },
                });
            }
        });
    }
    else {
        $.messager.alert("提示", "请先选择行！", 'warning');
    }
}
///刷新列表
function Refresh() {
    $('#grid').datagrid("reload");
}








