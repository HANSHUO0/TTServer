$(function () {
    $('#myTable').datagrid({
        url: '/AjaxCustomer/List.cspx',
        onSortColumn: loadGrid
    });
    var p = $('#myTable').datagrid('getPager');
    $(p).pagination({
        buttons: [{
            iconCls: 'icon-Grid-Search',
            handler: function () {
                CustomFilter($('#myTable'));
            }
        }, '-', {
            iconCls: 'icon-Grid-Column',
            handler: function () {
                showDataGridSettleDialog($('#myTable'));
            }
        }],
        onSelectPage: loadGrid
    });

    var panel = $('#myTable').datagrid("getPanel");
    panel.panel({
        tools: [{
            iconCls: 'icon-Grid-Search',
            handler: function () { CustomFilter($('#myTable')); }
        }, '-', {
            iconCls: 'icon-Grid-Column',
            handler: function () { showDataGridSettleDialog($('#myTable')); }
        }]
    });



    //  退出按钮 
    $("#btnExit").click(function () { parent.currTabClose(); });
    //  刷新按钮 
    $("#btnRefresh").click(function () { parent.currTabRefresh(); });

    //  导出按钮 
    $("#btnExport").click(function () {
        $.messager.confirm('提醒', '确定要导出到Excel文件?', function (r) {
            if (r) {
                parent.SaveAsFile($('#myTable'));
            }
        });
    });

    //  打印按钮 
    $("#btnPrint").click(function () {
        parent.Priverw('客户列表', $('#myTable').parent().find(".datagrid-view2").html());
    });

    // 过滤器
    var searchMenu = $("<div style='width: 120px'></div>");
    var columnsFields = $('#myTable').datagrid('getColumnFields');
    for (var i = 1; i < columnsFields.length; i++) {
        var title = $('#myTable').datagrid('getColumnOption', columnsFields[i]).title.trim();
        var field = $('#myTable').datagrid('getColumnOption', columnsFields[i]).field.trim();

        var divItem = $("<div>" + title + "</div>");
        divItem.attr("field", field);
        divItem.appendTo(searchMenu);
    }
    $('#btnSearch').searchbox({
        width: 300,
        searcher: function (value, name) {
            loadGrid(false);
        },
        menu: searchMenu,
        prompt: '请输入过滤条件'
    });
});
///加载数据
function loadGrid(reload) {

    //是否有过滤器
    var filterValue = $('#btnSearch').searchbox("getValue");
    var filterName = $('#btnSearch').searchbox("getName");
    var filterFeild = "";
    var columnsFields = $('#myTable').datagrid('getColumnFields');
    for (var i = 1; i < columnsFields.length; i++) {
        var title = $('#myTable').datagrid('getColumnOption', columnsFields[i]).title.trim();
        if (title == filterName) {
            filterFeild = $('#myTable').datagrid('getColumnOption', columnsFields[i]).field.trim();
            break;
        }
    }
    var filters = [];
    filters.push({
        Field: filterFeild,
        Method: '匹配',
        Value: filterValue
    });

    //判断是否要重新开始
    var op = $('#myTable').datagrid("options");
    var method = "reload";
    if (reload == false) {
        method = "load";
        op.pageNumber = 1;
    }
    $('#myTable').datagrid(method, {
        PageIndex: op.pageNumber,
        PageSize: op.pageSize,
        SortName: op.sortName,
        SortOrder: op.sortOrder,
        Filters: filters
    });
}

function showDataGridSettleDialog(grid) {

    var divDialog = $("<div></div>");
    var tableHTML = '<table fit="true"><thead>' +
        '<th field="Title" width="120" align="left">列名</th>' +
        '<th field="IsVis" width="40"  align="center">可见</th>' +
        '<th field="IsFix" width="40"  align="center">固定</th>' +
        '<th field="Width" width="60" align="right">宽度</th>' +
        '<th field="Field" width="60" align="center">顺序</th>' +
        '</thead></table>';
    var table = $(tableHTML);
    table.appendTo(divDialog);
    table.datagrid({
        singleSelect: true,
        pagination: false,
        rownumbers: true,
        onDblClickCell: function (rowIndex, field, value) {
            // 这段代码是// 对某个单元格赋值
            if (field == "IsVis" || field == "IsFix") {
                var rows = table.datagrid("getRows");
                rows[rowIndex][field] = !value;
                // 刷新该行, 只有刷新了才有效果
                table.datagrid('endEdit', rowIndex);
                table.datagrid('refreshRow', rowIndex);
            }
            if (field == "Width") {
                table.datagrid('beginEdit', rowIndex);
                var editor = table.datagrid("getEditor", { index: rowIndex, field: field });
                editor.target.focus();
            }
        },
        onSelect: function (rowIndex, rowData) {
            table.datagrid("acceptChanges");
        }
    });
    ///格式化 数据列的显示形式
    table.datagrid('getColumnOption', "IsVis").formatter = function (value, rowData, rowIndex) {
        return value ? '√' : '×';
    };
    table.datagrid('getColumnOption', "IsFix").formatter = function (value, rowData, rowIndex) {
        return value ? '√' : '×';
    };
    table.datagrid('getColumnOption', "Field").formatter = function (value, rowData, rowIndex) {
        var up = '<a href="#" onclick="moveUp_DataGridRow(this,' + rowIndex + ')"><img border=0 src="/themes/icons/Fill-Up.ico" /></a>';
        var down = '<a href="#" onclick="moveDown_DataGridRow(this,' + rowIndex + ')"><img border=0 src="/themes/icons/Fill-Down.ico" /></a>';
        return up + down;
    };

    //.panel

    table.datagrid('getColumnOption', "Width").editor = { type: 'numberbox', required: true };



    // 从grid 得到列设置的数据并加载
    table.datagrid("loadData", getDataGridSettleData(grid));

    //显示对话框
    divDialog.dialog({
        title: '列设置',
        iconCls: 'icon-Grid-Column',
        width: 450,
        height: 400,
        modal: true,
        buttons: [{
            text: 'Ok',
            iconCls: 'icon-ok',
            handler: function () {
                var rows = table.datagrid("getRows");
                setDataGridSettle(grid, rows);
                divDialog.dialog('close');
            }
        }, {
            text: 'Cancel',
            handler: function () {
                divDialog.dialog('close');
            }
        }]
    });


}

function CustomFilter(grid) {
    alert(grid.datagrid('getColumnOption', 'CusName').width);
    grid.datagrid('getColumnOption', 'CusName').width = 100;
    grid.datagrid();
}

function SaveDataGridSettle(grid) {

}
function setDataGridSettle(grid, rows) {

    //得到所有列
    var columnsFields = grid.datagrid('getColumnFields', true);
    columnsFields = columnsFields.concat(grid.datagrid('getColumnFields'));
    var fixColumns = [];
    var nofixColumns = [];
    // rows是按照顺序排序的
    for (var i = 0; i < rows.length; i++) {
        var op = grid.datagrid('getColumnOption', rows[i].Field);
        op.hidden = rows[i].IsVis;
        op.width = rows[i].Width;
    }
    $('#myTable').datagrid({
        url: '/AjaxCustomer/List.cspx',
        onSortColumn: loadGrid
    });
}

//从datagrid里取得列配置的数据集合
function getDataGridSettleData(grid) {
    var datas = [];
    var columnsFields = grid.datagrid('getColumnFields', true); // get frozen columns
    for (var i = 1; i < columnsFields.length; i++) {
        var title = grid.datagrid('getColumnOption', columnsFields[i]).title.trim();
        var field = grid.datagrid('getColumnOption', columnsFields[i]).field;
        var hidden = grid.datagrid('getColumnOption', columnsFields[i]).hidden;
        var width = grid.datagrid('getColumnOption', columnsFields[i]).width;
        datas.push({
            Title: title,
            Field: field,
            IsVis: !hidden,
            IsFix: true,
            Width: width
        });
    }
    var columnsFields = grid.datagrid('getColumnFields'); // get unfrozen columns
    for (var i = 1; i < columnsFields.length; i++) {
        var title = grid.datagrid('getColumnOption', columnsFields[i]).title.trim();
        var field = grid.datagrid('getColumnOption', columnsFields[i]).field;
        var hidden = grid.datagrid('getColumnOption', columnsFields[i]).hidden;
        var width = grid.datagrid('getColumnOption', columnsFields[i]).width;
        datas.push({
            Title: title,
            Field: field,
            IsVis: !hidden,
            IsFix: false,
            Width: width
        });
    }
    return datas;
}
// datagrid行上移  e是按钮事件 按钮在表格里
function moveUp_DataGridRow(e, rowIndex) {
    if (rowIndex <= 0) return;
    var p = $(e).parents(".datagrid-view");
    var t = p.children("table");
    var rows = t.datagrid("getRows");
    var data = rows[rowIndex];
    rows[rowIndex] = rows[rowIndex - 1];
    rows[rowIndex - 1] = data;
    t.datagrid("acceptChanges");
    t.datagrid('refreshRow', rowIndex - 1);
    t.datagrid('refreshRow', rowIndex);
};
// datagrid行下移 e是按钮事件 按钮在表格里
function moveDown_DataGridRow(e, rowIndex) {
    var p = $(e).parents(".datagrid-view");
    var t = p.children("table");
    var rows = t.datagrid("getRows");
    if (rowIndex >= rows.length - 1) return;
    var data = rows[rowIndex];
    rows[rowIndex] = rows[rowIndex + 1];
    rows[rowIndex + 1] = data;
    t.datagrid("acceptChanges");
    t.datagrid('refreshRow', rowIndex + 1);
    t.datagrid('refreshRow', rowIndex);

}
 