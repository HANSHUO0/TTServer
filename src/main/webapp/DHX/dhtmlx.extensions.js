
Array.prototype.contains = function (needle) {
    for (i in this) {
        if (this[i] == needle) return true;
    }
    return false;
}

$.ajaxSetup({
    cache: false,
    timeout: 600000,
    beforeSend: function () {
        if (window.spinner) {
            window.spinner.stop();
            window.spinner = null;
        }
        window.spinner = new Spinner().spin();
        document.body.appendChild(window.spinner.el);
    },
    complete: function () {
        if (window.spinner) {
            window.spinner.stop();
            window.spinner = null;
        }
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {
        if (typeof (errorThrown) != "undefined")
            dhtmlx.alert({
                title: "错误",
                type: "confirm-warning",
                text: "调用服务器失败。<br />" + errorThrown
            });
        else {
            var error = "<b style='color: #f00'>" + XMLHttpRequest.status + "  " + XMLHttpRequest.statusText + "</b>";
            var start = XMLHttpRequest.responseText.indexOf("<title>");
            var end = XMLHttpRequest.responseText.indexOf("</title>");
            if (start > 0 && end > start)
                error += "<br /><br />" + XMLHttpRequest.responseText.substring(start + 7, end);
            dhtmlx.alert({
                title: "错误",
                type: "confirm-warning",
                text: "调用服务器失败。<br />" + error
            });
        }
    }
});
dhtmlXGridObject.prototype.format = function (options) {

    if (typeof (options.path) == "undefined") this.setImagePath("/DHX/imgs/");
    if (typeof (options.autowidth) != "undefined") this.enableAutoWidth(options.autowidth);
    if (typeof (options.orders) != "undefined") this.Orders = options.orders;
    if (typeof (options.filter) != "undefined") this.Filter = options.filter;
    if (typeof (options.url) != "undefined") this.dhxGridDataUrl = options.url;
    this.formatOptsEx = options;
    this.gridName = options.name;
    //从服务器上取的表结构
    if (options.remote) {
        var spinner = new Spinner().spin();
        this.entBox.appendChild(spinner.el);
        $.ajax({
            async: false,
            type: "POST",
            url: "/Home/GetUseConfig",
            data: { url: this.dhxGridDataUrl },
            dataType: "json",
            complete: function () { spinner.stop(); },
            error: function () { spinner.stop(); },
            success: function (result) {
                if (result) {
                    options.columns = JSON.parse(result);
                }
                spinner.stop();
            }
        });
    }

    if (typeof (options.columns) != "undefined") {
        this.columnsFacts = [];
        var header = [], ids = [], widths = [], aligns = [], types = [], sorts = [], vis = [], headerEX = [];
        var fixColumns = -1;
        for (var i = 0; i < options.columns.length; i++) {
            var column = options.columns[i];
            var headLable = "";
            if (typeof (column.Header) != "undefined") {
                headLable = column.Header;
            }
            else {
                headLable = column.Label;
            }
            if (options.header == true) {
                var hIndex = column.Name.indexOf('-');
                if (headLable == column.Name && hIndex > 0) headLable = headLable.substring(hIndex + 1);
                if (hIndex > 0) {
                    var h = column.Name.substring(0, hIndex);
                    if (header.indexOf(h) >= 0) {
                        headerEX.push(headLable);
                        header.push("#cspan");
                    }
                    else {
                        header.push(h);
                        headerEX.push(headLable);
                    }
                }
                else {
                    header.push(headLable);
                    headerEX.push("#rspan");
                }
            }
            else {
                header.push(headLable);
            }

            this.columnsFacts.push(column.Label);
            ids.push(column.Name);
            widths.push(column.Width ? column.Width : 100);
            aligns.push(column.Align ? column.Align : "left");
            types.push(column.InputType);
            sorts.push(column.DataType);
            vis.push(column.Hidden ? "true" : "false");
            if (column.Frozen == true) { fixColumns = i; }
            if ((typeof (column.Options) != "undefined") && (column.InputType == "co" || column.InputType == "coro" || column.InputType == "combo")) {
                var combobox = this.getCombo(i);
                for (var j = 0; j < column.Options.length; j++) {
                    var op = column.Options[j];
                    combobox.put(op.Value, op.Text);
                }
            }
            if (typeof (column.Options) != "undefined" && column.InputType == "clist") {
                var list = [];
                for (var j = 0; j < column.Options.length; j++) {
                    var op = column.Options[j];
                    list.push(op.Text);
                }
                this.registerCList(i, list);
            }
            if (column.DataType == "int" && column.Precision) {
                var p = parseInt(column.Precision);
                var formatting = "0,000";
                if (p > 0) {
                    formatting += ".";
                    formatting += "00000000".substring(0, p);
                }
                this.setNumberFormat(formatting, i, ".", ",");
            }
        }
        this.formatOpts = options;

        this.setHeader(header.join(","));
        if (options.header == true) this.attachHeader(headerEX.join(","));
        this.setColumnIds(ids.join(","));
        this.setInitWidths(widths.join(","));
        this.setColAlign(aligns.join(","));
        this.setColTypes(types.join(","));
        this.setColSorting(sorts.join(","));


        //this.setStyle(
        //    "border-right:1px solid #9BC1D5;border-bottom:1px solid #9BC1D5",
        //    "border-right:1px solid #9BC1D5;border-bottom:1px solid #9BC1D5",
        //    "border-right:1px solid #9BC1D5;border-bottom:1px solid #9BC1D5",
        //    "border-right:1px solid #9BC1D5;border-bottom:1px solid #9BC1D5");
        if (fixColumns >= 0) { this.splitAt(fixColumns + 1); }

        this.init();
        this.setColumnsVisibility(vis.join(","));
        this.setDateFormat("%Y/%m/%d", "%Y/%m/%d");
        //this.enableEditEvents(true, false, true);
        if (options.add) {
            this.attachEvent("onLastRow", function () {
                if (this.isEditable) this.addRow($.newGuid(), this.newRow());
            });
            this.attachEvent("onKeyPress", function (code, cFlag, sFlag) {

                if (code == "173" && sFlag && this.isEditable) {
                    var count = this.getRowsNum();
                    if (count <= 1) return true;
                    this.deleteSelectedRows();
                    var colNum = this.getColumnsNum();
                    var oidCol = -1;
                    for (var i = 0; i < colNum; i++) {
                        var type = this.getColType(i);
                        if (type == "cntr") {
                            oidCol = i;
                            break;
                        }
                    }
                    for (var i = 0; i < count  ; i++) {
                        var rowID = this.getRowId(i);
                        this.cells(rowID, oidCol).setValue(i + 1);
                        if (i == 0) this.selectRowById(this.getRowId(0));
                    }


                }
                if (code == "61" && sFlag && this.isEditable) this.newRow();

                return true;
            });
        }
        if (!options.remote) {
            this.attachEvent("onResizeEnd", function (obj) { this.saveSizeToCookie(this.gridName); });
            this.loadSizeFromCookie(this.gridName);
        }
    }
    return this;

};
dhtmlXGridObject.prototype.autoSum = function (fields, idx) {

    if (!idx) idx = 0
    if (fields) {
        fields = "," + fields + ",";
        var footerC = []
        var footerS = [];
        for (var col = 0; col < this.formatOpts.columns.length; col++) {
            var column = this.formatOpts.columns[col];
            if (fields.indexOf("," + column.Name + ",") >= 0)
                footerC.push("#stat_total");
            else
                footerC.push("");
            footerS.push("text-align:" + (column.Align ? column.Align : "left") + "; border: 1px solid #a4bed4; ");
        }
        footerC[idx] = "合计";
        this.attachFooter(footerC, footerS);
    }
    else {
        var footerC = []
        var footerS = [];
        for (var col = 0; col < this.formatOpts.columns.length; col++) {
            var column = this.formatOpts.columns[col];
            if (column.DataType == "int")
                footerC.push("#stat_total");
            else
                footerC.push("");
            footerS.push("text-align:" + (column.Align ? column.Align : "left") + "; border: 1px solid #a4bed4;border-width: 1px 1px 0px;");

        }
        footerC[idx] = "合计";
        this.attachFooter(footerC, footerS);
    }
    for (var col = 0; col < this.ftr.rows[0].cells.length; col++) {
        if (this.formatOpts.columns[col].Hidden == true) {
            this.ftr.rows[0].cells[col].style.display = 'none';
            this.ftr.rows[1].cells[col].style.display = 'none';
        }
    }
    this.HasSum = true;
}
dhtmlXGridObject.prototype.getRowData = function (rId) {

    if (typeof (rId) == "undefined") { rId = this.getSelectedRowId(); }
    var rowIndex = this.getRowIndex(rId);
    var data = {};
    if (this.dhxGridData && this.dhxGridData.data && this.dhxGridData.data.length > rowIndex) {
        data = this.dhxGridData.data[rowIndex];
    }
    var colNum = this.getColumnsNum();
    for (var i = 0; i < colNum; i++) {
        var colId = this.getColumnId(i);
        var type = this.getColType(i);

        var u = this.getUserData(rId, colId);
        if (u) {
            data[colId] = u;
        }
        else {
            if (type == "ch") {
                data[colId] = this.cells(rId, i).isChecked();
            }
            else {
                data[colId] = this.cells(rId, i).getValue();
            }
        }
    }

    return $.cleanJson(data);

}
dhtmlXGridObject.prototype.getData = function () {
    var datas = [];
    for (var i = 0; i < this.getRowsNum() ; i++) {
        var rowID = this.getRowId(i);
        datas.push(this.getRowData(rowID));
    }

    //this.forEachRow(function (rId) {
    //    datas.push(this.getRowData(rId));
    //});


    return datas;
}

dhtmlXGridObject.prototype.newRow = function () {
    var data = [];
    if (this.formatOpts && this.formatOpts.columns) {
        for (var i = 0; i < this.formatOpts.columns.length; i++) {
            var column = this.formatOpts.columns[i];
            if (column.DefaultValue) {
                data.push(column.DefaultValue);
            }
            else {
                if (column.DataType == "bool") {
                    data.push(false);
                }
                else {
                    data.push('');
                }
            }
        }
    }
    else {
        dhtmlx.alert("好像不行！");
    }
    var rId = this.getSelectedRowId();
    if (rId) {
        var id = this.getRowIndex(rId);
        this.addRow(this.uid(), data, id + 1);
    }
    else {
        this.addRow(this.uid(), data);
    }
}
dhtmlXGridObject.prototype.configure = function (cfgGrid) {
    cfgGrid.target = this;
    cfgGrid.format({
        autowidth: false,
        name: "DCE0027C-DA4F-4B0A-B8D8-88054911076F",
        columns: [
            { Name: "Name", Label: "ID", Width: 80, InputType: "ro", Align: "left", Hidden: true },
            { Name: "Label", Label: "名称", Width: 80, InputType: "ro", Align: "left", Hidden: true },
            { Name: "InputType", Label: "显示类型", Width: 80, InputType: "ro", Align: "left", Hidden: true },
            { Name: "DataType", Label: "数据类型", Width: 80, InputType: "ro", Align: "left", Hidden: true },
            { Name: "Header", Label: "列名", Width: 120, InputType: "ed", Align: "left" },
            {
                Name: "Align", Label: "对齐方式", Width: '60', InputType: "coro", Align: "left",
                Options: [
                    { Text: '靠左', Value: 'left' },
                    { Text: '居中', Value: 'center' },
                    { Text: '靠右', Value: 'right' },
                ]
            },
            { Name: "Width", Label: "列宽", Width: '60', InputType: "ed", Align: "right" },
            { Name: "Hidden", Label: "是否显示", Width: '60', InputType: "ch", Align: "center" },
            { Name: "Frozen", Label: "是否固定", Width: '60', InputType: "ch", Align: "center" },
            {
                Name: "Order", Label: "默认排序", Width: '60', InputType: "coro", Align: "center",
                Options: [
                    { Text: '否', Value: 'none' },
                    { Text: '升序', Value: 'asc' },
                    { Text: '降序', Value: 'desc' },
                ]
            },
            { Name: "up", Label: "位置", Width: '40', InputType: "ro", Align: "right" },
            { Name: "down", Label: "#cspan", Width: '40', InputType: "ro", Align: "left" }
        ]
    });

    var colNum = this.getColumnsNum();
    var cfgData = {};
    cfgData.data = [];
    var fixColunmIndex = -1;
    if (this._fake) {
        fixColunmIndex = this._fake._cCount - 1;
    }
    for (var i = 0; i < colNum; i++) {

        var id = this.getColumnId(i);
        var fieldOrder = "none";
        if (this.defaultOrders) {
            for (var j = 0; j < this.defaultOrders.length; j++) {
                var order = this.defaultOrders[j];
                if (order.field == id) {
                    fieldOrder = order.desc ? "desc" : "asc";
                    break;
                }
            }
        }
        cfgData.data.push({
            Name: this.getColumnId(i),
            Label: this.columnsFacts[i],
            InputType: this.getColType(i),
            Header: this.getColLabel(i, 0),
            Align: this.cellAlign[i],
            Width: this.getColWidth(i),
            Hidden: !this.isColumnHidden(i),
            DataType: this.fldSort[i],
            Frozen: fixColunmIndex == i,
            Order: fieldOrder,
            up: "<span style='cursor:pointer'><i class='fa fa-arrow-up'></i></span>",
            down: "<span style='cursor:pointer'><i class='fa fa-arrow-down'></i></span>"
        });
    }
    cfgGrid.clearAll();
    cfgGrid.parse(cfgData, "js");
    cfgGrid.dhxGridData = cfgData;

    cfgGrid.forEachRow(function (rId) {
        var rowIndex = this.getRowIndex(rId);
        var headerColIndex = this.getColIndexById("Header");
        this.cells(rId, headerColIndex).setAttribute('title', this.target.columnsFacts[rowIndex]);
    });

    cfgGrid.attachEvent("onCellChanged", function (rId, cInd, nValue) {
        var rowIndex = this.getRowIndex(rId);
        var cId = this.getColumnId(cInd);

        if (cId == "Name") {
            this.target.setColumnId(rowIndex, nValue);
            this.target.clearAll();
            this.target.parse(this.target.dhxGridData, "js");
        }
        if (cId == "Header") {
            this.target.setColumnLabel(rowIndex, nValue);
            this.target.clearAll();
            this.target.parse(this.target.dhxGridData, "js");
        }
        if (cId == "Align") {
            this.target.cellAlign[rowIndex] = nValue;
            this.target.forEachRow(function (id) { this.cells(id, rowIndex).setHorAlign(nValue.substring(0, 1)); });
        }
        if (cId == "Width") { this.target.setColWidth(rowIndex, nValue); }
        if (cId == "Hidden") {
            this.target.setColumnHidden(rowIndex, nValue == "0" ? true : false);
            if (nValue == 1) {
                var widthColIndex = this.getColIndexById("Width");
                var w = this.cells(rId, widthColIndex).getValue();
                if (parseInt(w) <= 0) {
                    this.cells(rId, widthColIndex).setValue(100);
                }
            }
        }
        if (cId == "Frozen") {
            if (nValue == 1) {
                var count = this.getRowsNum();
                for (var i = 0; i < count; i++) {
                    if (i != rowIndex) {
                        var rr = this.getRowId(i);
                        if (this.cells(rr, cInd).getValue() == 1) {
                            this.cells(rr, cInd).setValue(0);
                        }
                    }
                }
            }
            this.target.formatOpts.columns[rowIndex].frozen == (nValue == 1);
            dhtmlx.message("保存后生效！");

        }
        if (cId == "Order") {
            var orders = [];
            var count = this.getRowsNum();
            var fieldColIndex = this.getColIndexById("Name");
            var orderColIndex = this.getColIndexById("Order");
            for (var i = 0; i < count; i++) {
                var rId = this.getRowId(i);
                var field = this.cells(rId, fieldColIndex).getValue();
                var order = this.cells(rId, orderColIndex).getValue();
                if (order != "none") {
                    orders.push({ Name: field, Desc: "desc" == order });
                }
            }
            this.target.defaultOrders = orders;
        }
        this.needSave = true;
    });
    cfgGrid.attachEvent("onBeforeSorting", function (ind, type, direction) { return false; });
    cfgGrid.attachEvent("onRowSelect", function (rid, cind) {
        var rowIndex = this.getRowIndex(rid);
        var cId = this.getColumnId(cind);
        if (cId == "up") {  //up
            if (rowIndex == 0) return;
            this.moveRowUp(rid);

            this.target.moveColumn(rowIndex, rowIndex - 1);
        }
        if (cId == "down") { //down
            var count = this.getRowsNum();
            if (rowIndex >= count - 1) return;
            this.moveRowDown(rid);
            this.target.moveColumn(rowIndex, rowIndex + 2);
        }
        return true;
    });
};
dhtmlXGridObject.prototype.loadJson = function (url, data, reset) {

    if (typeof (url) != "undefined") this.dhxGridDataUrl = url;
    if (typeof (reset) == "undefined") reset = true;
    var href = this.dhxGridDataUrl;
    if (!href) return;

    if (href.indexOf("?") < 0)
        href += "?";
    else
        href += "&";
    href += "rnd=" + new Date();

    var _thisAjaxGrid = this;
    var pagerData = {
        Filter: this.Filter,
        Orders: this.Orders,
        PageSize: -1,
        PageIndex: -1
    };
    if (data && data.Filter) {
        pagerData.Filter = data.Filter;
        delete data.Filter;
    }
    if (data && data.Orders) {
        pagerData.Orders = data.Orders;
        delete data.Orders;
    }
    if (this.pager) {
        if (reset == true) this.pager.pageIndex = 1;
        pagerData.PageSize = this.pager.pageSize;
        pagerData.PageIndex = this.pager.pageIndex;
    }
    if (!this.postData) this.postData = {};
    $.extend(this.postData, data);
    this.postData.pager = pagerData;
    $.ajax({
        url: href,
        type: "POST",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify(this.postData),
        async: true,
        beforeSend: function () { _thisAjaxGrid.progressOn(); },
        complete: function () { _thisAjaxGrid.progressOff(); },
        success: function (response) {
            if (response.Success) {
                var ajaxData = response.Result;
                if (_thisAjaxGrid.lay && ajaxData.design) {
                    var o = _thisAjaxGrid.This;
                    var pLay = _thisAjaxGrid.lay;
                    var ItemName = _thisAjaxGrid.ItemName;
                    var gridName = _thisAjaxGrid.gridName;
                    pLay.detachObject();
                    _thisAjaxGrid = pLay.attachGrid();
                    o[ItemName] = _thisAjaxGrid;
                    _thisAjaxGrid.ItemName = ItemName;
                    _thisAjaxGrid.This = o;
                    _thisAjaxGrid.format({
                        columns: ajaxData.design,
                        header: ajaxData.header,
                        name: gridName,
                    });
                }
                if (ajaxData.data) {
                    _thisAjaxGrid.totalCount = ajaxData.total_count;
                    _thisAjaxGrid.dhxGridData = ajaxData;
                    _thisAjaxGrid.clearAll();
                    ajaxData.total_count = ajaxData.data.length;
                    _thisAjaxGrid.parse(ajaxData, "js");
                    if (_thisAjaxGrid.pager != null) {
                        _thisAjaxGrid.pager.setTotal(_thisAjaxGrid.totalCount);
                    }
                    if (_thisAjaxGrid.Orders && _thisAjaxGrid.Orders.length > 0) {
                        var order = _thisAjaxGrid.Orders[0];
                        var ind = _thisAjaxGrid.getColIndexById(order.Name);
                        _thisAjaxGrid.setSortImgState(true, ind, order.Desc ? "desc" : "asc");
                    }
                }
                else {
                    _thisAjaxGrid.setData(ajaxData);
                }
            }
            else {
                dhtmlx.error(response.Message);
            }

        }
    });
    return _thisAjaxGrid;
}
dhtmlXGridObject.prototype.setData = function (data) {
    var ajaxData = {
        total_count: data.length,
        data: data
    };
    this.totalCount = ajaxData.total_count;
    this.dhxGridData = ajaxData;
    this.clearAll();
    this.parse(ajaxData, "js");
}
dhtmlXGridObject.prototype.toExcelExt = function (url) {


    if (this.pager == null || this.pager.pageCount <= 1)
        this.toExcelByData(this.dhxGridData.data);
    else {
        var href = this.dhxGridDataUrl;
        if (!href) return;
        if (href.indexOf("?") < 0)
            href += "?";
        else
            href += "&";
        href += "rnd=" + new Date();
        var pagerData = {
            Filter: this.Filter,
            Orders: this.Orders,
            PageSize: -1,
            PageIndex: -1
        };
        var data = {};
        $.extend(data, this.postData)
        data.pager = pagerData;
        var _ajaxGrid = this;
        $.ajaxPost(href, data, function (result) {
            _ajaxGrid.toExcelByData(result.data);
        });

    }


}
dhtmlXGridObject.prototype.toExcelByData = function (data, name) {
    var xml = "<rows profile='color'";
    var name = this.gridName;
    if (name) {
        if (name.indexOf(".") > 0) name = name.substring(0, name.indexOf("."));
        xml += " sheetname='" + name + "'";
    }
    xml += ">";
    xml += "<head><columns>";
    var colNum = this.getColumnsNum();
    for (var i = 0; i < colNum; i++) {
        xml += "<column  width='" + this.getColWidth(i) + "' ";
        xml += "align='" + this.cellAlign[i] + "' ";
        xml += "type='" + this.getColType(i) + "' ";
        xml += "hidden='" + this.isColumnHidden(i) + "' ";
        xml += "sort='" + this.fldSort[i] + "' ";
        xml += "color=''  id='" + this.getColumnId(i) + "'>";
        xml += "<![CDATA[" + this.getColLabel(i, 0) + "]]>";
        xml += "</column>";
    }
    xml += "</columns></head>";
    if (typeof (data) != "undefined") {
        for (var i = 0; i < data.length ; i++) {
            xml += "<row>";
            for (var j = 0; j < colNum; j++) {
                var id = this.getColumnId(j);
                var cellText = "";
                if (typeof (data[i][id]) != "undefined") cellText = data[i][id];
                if (this.getColType(j) == "cntr") cellText = (i + 1);
                xml += "<cell><![CDATA[" + cellText + "]]></cell>";
            }
            xml += "</row>";
        }
    }
    //-- 合计
    if (this.HasSum == true) {
        xml += "<row>";
        for (var j = 0; j < colNum; j++) {
            xml += "<cell><![CDATA[" + this.getFooterLabel(j) + "]]></cell>";
        }
        xml += "</row>";
    }
    xml += "</rows>"
//    var url = '/Home/ToExcel';
//    if (!document.getElementById("ifr")) {
//        var h = document.createElement("iframe");
//        h.style.display = "none";
//        h.setAttribute("name", "dhx_export_iframe");
//        h.setAttribute("src", "");
//        h.setAttribute("id", "dhx_export_iframe");
//        document.body.appendChild(h)
//    }
//    var target = ' target="dhx_export_iframe"';
//    var y = document.createElement("div");
//    y.style.display = "none";
//    document.body.appendChild(y);
//    var j = "form_" + this.uid();
//    y.innerHTML = '<form id="' + j + '" method="post" action="' + url + '" accept-charset="utf-8"  enctype="application/x-www-form-urlencoded"' + target + '><input type="hidden" name="grid_xml" id="grid_xml"/> </form>';
//    document.getElementById(j).firstChild.value = encodeURIComponent(xml);
//    document.getElementById(j).submit();
//    y.parentNode.removeChild(y);
}

dhtmlXGridObject.prototype.getValue = function (rId, cId) {
    if (rId == null) { rId = this.getSelectedRowId(); }
    if (rId == null) { return null; }
    var cind = this.getColIndexById(cId);
    if (cind) {
        return this.cells(rId, cind).getValue();
    }
    else {
        var rdata = this.getRowData(rId);
        return rdata[cId];
    }
}

dhtmlXGridObject.prototype.progressOn = function () {
    if (this.spinner) {
        this.spinner.stop();
        this.spinner = null;
    }
    this.spinner = new Spinner().spin();
    this.entBox.appendChild(this.spinner.el);
}
dhtmlXGridObject.prototype.progressOff = function () {
    if (this.spinner) {
        this.spinner.stop();
        this.spinner = null;
    }
}

dhtmlXCellObject.prototype.pager = function (options) {

    this.target = options.target;
    this.target.dhxGridData = {};
    this.target.pager = this;

    var args = {
        pageSize: 50,
        height: 34
    };
    var options = $.extend({}, args, options);
    this.pageSize = options.pageSize;
    this.totalCount = 0;
    this.pageIndex = 1;
    this.pageCount = 0;

    if (typeof (options.target) == "undefined") {
        dhtmlx.alert("参数未定义！");
        return;
    }
    if (typeof (options.url) != "undefined") {
        this.target.dhxGridDataUrl = options.url;
        return;
    }

    if (typeof (options.filter) != "undefined") {
        this.target.Filter = options.filter;
    }

    if (typeof (options.orders) != "undefined") {
        this.target.Orders = options.orders;
    }


    this.statusBar = this.attachStatusBar({ height: options.height });
    var objID = $.newGuid();
    this.ObjectID = objID;
    html = "<div id='" + objID + "'></div>";
    this.statusBar.setText(html);

    this.myToolbar = new dhtmlXToolbarObject({
        parent: objID,
        icons_path: "/DHX/imgs/dhxtoolbar_terrace/"
    });

    this.myToolbar.addButton("frist", 0, "", "ar_left_abs.gif", "ar_left_abs_dis.gif");
    this.myToolbar.addButton("forward", 1, "", "ar_left.gif", "ar_left_dis.gif");
    this.myToolbar.addText("textCell", 2, "");
    this.myToolbar.setWidth("textCell", 200);
    this.myToolbar.addButton("next", 3, "", "ar_right.gif", "ar_right_dis.gif");
    this.myToolbar.addButton("last", 4, "", "ar_right_abs.gif", "ar_right_abs_dis.gif");
    this.myToolbar.addSeparator("sep1", 5);
    this.myToolbar.addButtonSelect("pageIndex", 6, "第1页", new Array(), "paging_pages.gif", "paging_pages.gif", true, true, 10);
    this.myToolbar.addSeparator("sep5", 20);
    this.myToolbar.addButtonSelect("pageSize", 30, "每页" + this.pageSize + "行", new Array(), "paging_rows.gif", "paging_rows.gif");
    this.myToolbar.addListOption("pageSize", "pageSize-5", 30, "button", "每页5行", "paging_rows.gif");
    this.myToolbar.addListOption("pageSize", "pageSize-10", 31, "button", "每页10行", "paging_rows.gif");
    this.myToolbar.addListOption("pageSize", "pageSize-20", 32, "button", "每页20行", "paging_rows.gif");
    this.myToolbar.addListOption("pageSize", "pageSize-50", 33, "button", "每页50行", "paging_rows.gif");
    this.myToolbar.addListOption("pageSize", "pageSize-100", 34, "button", "每页100行", "paging_rows.gif");
    this.myToolbar.addListOption("pageSize", "pageSize-500", 35, "button", "每页500行", "paging_rows.gif");
    //this.myToolbar.addListOption("pageSize", "pageSize-999", 36, "button", "显示全部", "paging_rows.gif");
    this.myToolbar.addSpacer("pageSize");
    this.myToolbar.addSeparator("sep6", 40);
    this.myToolbar.addButton("tabConfig", 50, "列设置", "config.png", "config.png");

    this.myToolbar.addSeparator("sep7", 60);
    this.myToolbar.addButton("print", 70, "打印", "print.png", "print.png");

    this.myToolbar.addSeparator("sep8", 80);
    this.myToolbar.addButtonSelect("output", 90, "导出", new Array(), "output.png", "output.png");
    this.myToolbar.addListOption("output", "output-1", 30, "button", "导出当前页", "output.png");
    this.myToolbar.addListOption("output", "output-2", 31, "button", "导出所有页", "output.png");

    var myPopup = new dhtmlXPopup({
        toolbar: this.myToolbar,
        id: "tabConfig"
    });
    var cfgGrig = null;
    myPopup.target = this.target;
    myPopup.attachEvent("onShow", function (id) {
        if (cfgGrig == null) {
            var lay = myPopup.attachLayout(540, 300, "1C");
            lay.cells("a").hideHeader();
            lay.cells("a").attachToolbar().format({
                Items: [
                   { ID: "def", Type: "button", Text: "恢复默认" },
                   { ID: "save", Type: "button", Text: "保存" },
                   { ID: "exit", Type: "button", Text: "关闭" }
                ],
                Spacer: "def",
                Action: function (id) {
                    if (id == "exit") myPopup.hide();
                    if (id == "def") {
                        myPopup.target.saveSizeToCookie(myPopup.target.gridName, "expires=Fri, 31-Dec-2010 23:59:59 GMT");
                        $.ajaxPost('/Home/RemoveUseConfig', { url: myPopup.target.gridName }, function () {
                            window.location.reload();
                        });
                    }
                    if (id == "save") {
                        var rows = cfgGrig.getData();
                        for (var i = 0; i < rows.length; i++) {
                            rows[i].up = "";
                            rows[i].down = "";
                            rows[i].hidden = (rows[i].hidden == 0);
                            rows[i].frozen = (rows[i].frozen == 1);
                        }
                        var data = { url: myPopup.target.gridName, datas: JSON.stringify(rows) };
                        $.ajaxPost('/Home/SaveUserConfig', data, function () {
                            window.location.reload();
                        });
                    }
                }
            });
            cfgGrig = lay.cells("a").attachGrid();
            this.target.configure(cfgGrig);
        }
    });
    myPopup.attachEvent("onBeforeHide", function (type, ev, id) { return false; });


    this.myToolbar.addInput("inputPageIndex", 6, "1", 40);
    this.myToolbar.addButton("goPageIndex", 7, "Go", "redo.gif", "redo.gif");
    this.myToolbar.setUserData("frist", "data", this);
    this.myToolbar.hideItem("inputPageIndex");
    this.myToolbar.hideItem("goPageIndex");
    this.myToolbar.disableItem("frist");
    this.myToolbar.disableItem("forward");
    this.myToolbar.disableItem("next");
    this.myToolbar.disableItem("last");

    if (this.target.formatOpts && !this.target.formatOpts.remote) this.myToolbar.hideItem("tabConfig");

    this.myToolbar.attachEvent("onClick", function (id) {
        var pager = this.getUserData("frist", "data");
        switch (id) {
            case "print":
                pager.target.printView();
                break;
            case "frist":
                pager.setPageIndex(1);;
                break;
            case "forward":
                var p = pager.pageIndex - 1;
                pager.setPageIndex(p > 0 ? p : 1);
                break;
            case "next":
                var p = pager.pageIndex - 0 + 1;
                if (p > pager.pageCount) p = pager.pageCount;
                pager.setPageIndex(p);
                break;
            case "last":
                var p = pager.pageCount;
                pager.setPageIndex(p > 0 ? p : 1);
                break;
            case "goPageIndex":
                var input = this.getInput("inputPageIndex");
                var n = Number(input.value);
                if (n) { pager.setPageIndex(n); }
                break;
            case "output-1":
            	var l = pager.cell.children[2].children[0].children[1].children[0].children[0];
            	var ids = [];
            	for(var i = 1; i< l.children.length; i++){
            		ids.push(parseInt(l.children[i].children[0].innerText));
            	}
            	
            	$.ajax({
	    			type: 'POST',
	    			url: '/excel/out.action',				
	    			data: {ids: ids},
	    			traditional: true
	    			});
            	
               
                break;
            case "output-2":
                pager.target.toExcel('/excel/toexcelall.action');
                break;
            default:
                if (id.substring(0, 9) == "pageSize-") {
                    var size = id.substring(9);
                    pager.setPageSize(size);
                    return;
                }
                if (id.substring(0, 10) == "pageIndex-") {
                    var idx = id.substring(10);
                    pager.setPageIndex(idx);
                }
                break;
        }
    });

    this.calcPageCount = function () {
        if (this.pageSize == "999") {
            this.pageCount = 1;
        }
        else {
            this.pageCount = Math.ceil(this.totalCount / this.pageSize);
        }
        var items = this.myToolbar.getAllListOptions("pageIndex");
        for (var i = 0; i < items.length; i++) {
            this.myToolbar.removeListOption("pageIndex", items[i]);
        }
        for (var i = 1; i <= this.pageCount; i++) {
            var text = "第" + i + "页";
            this.myToolbar.addListOption("pageIndex", "pageIndex-" + i, 100 + i, "button", text, "paging_pages.gif");
        }
        if (this.pageCount > 20) {
            this.myToolbar.showItem("inputPageIndex");
            this.myToolbar.showItem("goPageIndex");

        }
        else {
            this.myToolbar.hideItem("inputPageIndex");
            this.myToolbar.hideItem("goPageIndex");
        }
    };
    this.setBtn = function () {
        if (this.totalCount == 0) {
            this.myToolbar.disableItem("frist");
            this.myToolbar.disableItem("forward");
            this.myToolbar.disableItem("next");
            this.myToolbar.disableItem("last");
            return;
        }
        if (this.pageIndex > 1) {
            this.myToolbar.enableItem("frist");
            this.myToolbar.enableItem("forward");
        }
        else {
            this.myToolbar.disableItem("frist");
            this.myToolbar.disableItem("forward");
        }
        if (this.pageIndex < this.pageCount) {
            this.myToolbar.enableItem("next");
            this.myToolbar.enableItem("last");
        }
        else {
            this.myToolbar.disableItem("next");
            this.myToolbar.disableItem("last");
        }


    }
    this.setPageSize = function (pagesize) {
        this.pageSize = pagesize;
        this.calcPageCount();
        if (this.pageIndex > this.pageCount) {
            this.pageIndex = this.pageCount;
        }
        if (this.pageIndex < 1) {
            this.pageIndex = 1;
        }
        this.target.loadJson(this.dhxGridDataUrl, {}, false);
        this.showText();
    }
    this.setPageIndex = function (idx) {
        if (idx > this.pageCount) idx = this.pageCount;
        if (idx < 1) idx = 1;
        this.pageIndex = idx;
        this.target.loadJson(this.dhxGridDataUrl, {}, false);
        this.showText();
    }
    this.setTotal = function (count) {
        this.totalCount = count;
        this.calcPageCount();
        this.setBtn();
        this.showText();
    }
    this.showText = function () {
        this.setBtn();
        var s = (this.pageIndex - 1) * this.pageSize;
        var text = "当前：" + s + "-";
        s = this.pageIndex * this.pageSize;
        if (this.pageIndex >= this.pageCount) {
            s = this.totalCount;
        }
        text += s;
        text += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;总数：" + this.totalCount;
        this.myToolbar.setItemText("textCell", text);

        var text = "每页" + this.pageSize + "行";
        if (this.pageSize == 999) {
            text = "显示全部";
        }
        this.myToolbar.setItemText("pageSize", text);
        var idx = parseInt(this.pageIndex);
        var text = "第" + idx + "页";
        this.myToolbar.setItemText("pageIndex", text);
    };


    this.load = function (data) {
        this.target.loadJson(this.target.dhxGridDataUrl, data);
        this.showText();
    };



    this.target.attachEvent("onBeforeSorting", function (ind, type, direction) { return false; });
    this.target.attachEvent("onHeaderClick", function (ind, obj) {
        var colName = this.getColumnId(ind);
        var flag = false;
        $.each(this.formatOpts.columns, function (i, column) {
            if (column.Name == colName) {
                flag = column.Order == "asc" || column.Order == "desc";
                return;
            }
        });
        if (!flag) return false;
        var state = this.getSortingState();
        var direction = "asc";
        if (state.length > 0) {
            if (state[0] == ind && state[1] == "asc") direction = "des";
        }
        this.target.Orders = [{ Name: colName, Desc: direction != "asc" }];
        this.pager.load();
        return false;
    });
    return this;
};

dhtmlXTreeObject.prototype.format = function (options) {
    if (options.action) this.setOnClickHandler(options.action);
    if (options.url) this.loadJson(options.url, options.postData, options.success);
    return this;
}
dhtmlXTreeObject.prototype.loadJson = function (url, postData, success) {
    this.setImagePath("/DHX/imgs/dhxTree/");
    if (typeof (url) != "undefined") { this.url = url; }
    var _thisAjaxTree = this;
    _thisAjaxTree.deleteChildItems(0)
    _thisAjaxTree.loadChild = function (pid, rows) {
        for (var i = 0; i < rows.length; i++) {
            var node = rows[i];
            var t = this.insertNewChild(pid, node.id, node.text);
            this.setUserData(node.id, "Model", node.attributes);
            this.setCheck(node.id, node.checked);
            this.loadChild(node.id, node.children);
        }
    };
    _thisAjaxTree.success = success;

    $.ajax({
        url: this.url,
        contentType: "application/json",
        type: "POST",
        dataType: "json",
        data: JSON.stringify(postData),
        async: true,
        beforeSend: function () { _thisAjaxTree.progressOn(); },
        complete: function () { _thisAjaxTree.progressOff(); },
        success: function (response) {
            if (response.Success) {
                var data = response.Result;
                for (var i = 0; i < data.length; i++) {
                    var node = data[i];
                    var t = _thisAjaxTree.insertNewChild(0, node.id, node.text);
                    _thisAjaxTree.setCheck(node.id, node.checked);
                    _thisAjaxTree.setUserData(node.id, "Model", node.attributes);
                    _thisAjaxTree.loadChild(node.id, node.children);
                    if (node.state == "closed") _thisAjaxTree.closeItem(node.id);
                }
                _thisAjaxTree.JsonData = data;
                if (_thisAjaxTree.success) _thisAjaxTree.success(data);
            }
            else {
                dhtmlx.error(response.Message);
            }
        }
    });
};

dhtmlXTreeObject.prototype.progressOn = function () {
    if (this.spinner) {
        this.spinner.stop();
        this.spinner = null;
    }
    this.spinner = new Spinner().spin();
    this.allTree.appendChild(this.spinner.el);
}
dhtmlXTreeObject.prototype.progressOff = function () {
    if (this.spinner) {
        this.spinner.stop();
        this.spinner = null;
    }
}

dhtmlXTreeObject.prototype.getModel = function (id) {
    var selectid = id;
    if (!selectid) selectid = this.getSelectedItemId();
    var data = {};
    return $.extend(data, this.getUserData(selectid, "Model"));
}


dhtmlXToolbarObject.prototype.addItem = function (options) {

    if (typeof (options.ID) == "undefined" || options.ID.length == 0) {
        dhtmlx.alert("ID未定义！");
        return;
    }
    var items = this.getAllitems();
    for (var i = 0; i < items.length; i++) {
        if (items[i].toLowerCase() == options.ID.toLowerCase()) {
            dhtmlx.alert("ID重复！");
            return;
        }
    }
    if (!options.Pos) options.Pos = null;
    if (!options.Img) options.Img = null;
    if (!options.ImgDis) options.ImgDis = options.Img;

    if (options.Node) {
        if (options.Type != "separator") options.Type = "button";
        this.addListOption(options.Node, options.ID, options.Pos, options.Type, options.Text, options.Img);
    }
    else if (options.Type == "button") this.addButton(options.ID, options.Pos, options.Text, options.Img, options.ImgDis);
    else if (options.Type == "buttonselect") this.addButtonSelect(options.ID, options.Pos, options.Text, [], options.Img, options.ImgDis, true, true, 20, "select");
    else if (options.Type == "input") this.addInput(options.ID, options.Pos, "", options.Width ? options.Width : 70);
    else if (options.Type == "text") this.addText(options.ID, options.Pos, options.Text);
    else if (options.Type == "separator") this.addSeparator(options.ID, options.Pos);

    if (options.Node) {
        if (options.Hidden) this.hideListOption(options.Node, options.ID);
        if (options.Enabled == false) this.disableListOption(options.Node, options.ID);
        if (options.Title) this.setListOptionToolTip(options.Node, options.Title);
        if (options.UserData) {
            for (var i = 0; i < options.UserData.length; i++) {
                this.setListOptionUserData(options.Node, options.ID, options.UserData[i].Text, options.UserData[i].Value);
            }
        }
    }
    else {
        if (options.Hidden) this.hideItem(options.ID);
        if (options.Enabled == false) this.disableItem(options.ID);
        if (options.Title) this.setItemToolTip(options.Title);
        if (options.UserData) {
            for (var i = 0; i < options.UserData.length; i++) {
                this.setUserData(options.id, options.UserData[i].Text, options.UserData[i].Value);
            }
        }
    }

    if (options.Action) {
        this.attachEvent("onClick", function (id) {
            if (id.toLowerCase() == options.ID.toLowerCase()) {
                var fn;
                eval("fn = " + options.Action);
                fn();
            }
        });
    }

    if (typeof (this.ToolbarItems) == "undefined") this.ToolbarItems = [];
    this.ToolbarItems.push(options);

}
dhtmlXToolbarObject.prototype.addItems = function (items) {
    if (items) {
        for (var i = 0; i < items.length; i++) {
            this.addItem(items[i]);
        }
    }
}
dhtmlXToolbarObject.prototype.deleteItem = function (id) {
    if (typeof (id) == "undefined" || id.length == 0) {
        dhtmlx.alert("ID未指定！");
        return;
    }
    var pid = this.getParentId(id);
    if (pid == null)
        this.removeItem(id);
    else
        this.removeListOption(pid, id);
    for (var i = 0; i < this.ToolbarItems.length; i++) {
        if (this.ToolbarItems[i].ID.toLowerCase() == id.toLowerCase()) {
            this.ToolbarItems.splice(i, 1);
            break;
        }
    }
}
dhtmlXToolbarObject.prototype.getToolBarItem = function (id) {
    if (this.ToolbarItems) {
        for (var i = 0; i < this.ToolbarItems.length; i++) {
            if (this.ToolbarItems[i].ID.toLowerCase() == id.toLowerCase()) return this.ToolbarItems[i];
        }
    }
    return null;
}
dhtmlXToolbarObject.prototype.getAllitems = function () {
    var items = [];
    var tool = this;
    function doWithItem(itemid) {
        items.push(itemid);
        ids = tool.getAllListOptions(itemid);
        if (ids) items = items.concat(ids);
    }
    this.forEachItem(doWithItem);
    return items;
}
dhtmlXToolbarObject.prototype.format = function (options) {
    this.setIconsPath("/DHX/imgs/dhxtoolbar_terrace/");
    if (options.Items) this.addItems(options.Items)
    if (options.Action) this.attachEvent("onclick", options.Action);
    if (options.Spacer) this.addSpacer(options.Spacer);


    return this;
}

dhtmlXForm.prototype.progressOn = function () {
    if (this.spinner) {
        this.spinner.spin();
    }
    else {
        this.spinner = new Spinner().spin();
    }
    this.cont.appendChild(this.spinner.el);
}
dhtmlXForm.prototype.progressOff = function () {
    if (this.spinner) {
        this.spinner.stop();
        this.spinner = null;
    }
}

dhtmlx.showDialog = function (options) {

    if (typeof (options.width) == "undefined") options.width = 600;
    if (typeof (options.height) == "undefined") options.height = 400;
    if (options.full == true) {
        options.width = $(window).width();
        options.height = $(window).height();
    }

    if (options.width < 150) options.width = 600;
    if (options.height < 100) options.height = 400;
    if (typeof (options.left) == "undefined") { options.left = ($(window).width() - options.width) / 2; }
    if (typeof (options.top) == "undefined") { options.top = ($(window).height() - options.height) / 2; }
    if (typeof (options.center) == "undefined") { options.center = true; }
    if (typeof (options.move) == "undefined") { options.move = true; }
    if (typeof (options.park) == "undefined") { options.park = true; }
    if (typeof (options.resize) == "undefined") { options.resize = true; }
    if (typeof (options.modal) == "undefined") { options.modal = true; }
    if (typeof (options.caption) == "undefined") { options.caption = ""; }
    if (typeof (options.header) == "undefined") { options.header = false; }
    if (typeof (options.saveText) == "undefined") { options.saveText = "保存"; }

    var dhxWins = new dhtmlXWindows();
    if (document.body.clientWidth < options.width || document.body.clientHeight < options.height) dhxWins.attachViewportTo(parent.document.body);

    var w1 = dhxWins.createWindow({
        id: "A" + new Date(),
        left: options.left,
        top: options.top,
        width: options.width,
        height: options.height,
        center: options.center,
        move: options.move,
        park: options.park,
        resize: options.resize,
        modal: options.modal,
        caption: options.caption,
        header: options.header
    });
    if (typeof (options.close) != "undefined" && options.close == false) { w1.button("close").hide(); }
    if (typeof (options.minmax) != "undefined" && options.minmax == false) { w1.button("minmax").hide(); }
    if (typeof (options.park) != "undefined" && options.park == false) { w1.button("park").hide(); }
    w1.options = options;
    var lay = w1.attachLayout({
        pattern: "1C",
        cells: [{ id: "a", header: false, text: "" }]
    });
    if (options.header == false) {
        var toolbar = lay.cells("a").attachToolbar({
            icons_path: "/DHX/imgs/dhxtoolbar_terrace/"
        });
        toolbar.addText("title", 0, options.caption);
        toolbar.addSpacer("title");

        if (options.saveText) toolbar.addButton("save", 1, options.saveText);
        toolbar.addButton("exit", 2, "关闭");

        w1.getData = function () {
            return w1.iframe.contentWindow.Layout.getData();
        }
        w1.save = function () {
            var postData = w1.iframe.contentWindow.Layout.getData();
            $.ajaxPost(w1.options.url, postData, w1.options.callback);
        }
        if (typeof (options.save) != "undefined") w1.save = options.save;
        toolbar.target = w1;
        toolbar.attachEvent("onClick", function (id) {
            if (id == "exit") { this.target.close(); }
            if (id == "save") { this.target.save(); }
        });
        w1.toolbar = toolbar;
        $(w1.toolbar.cont).mousedown(function (event) {
            var offset = $(this).closest(".dhxwin_active").offset();
            x1 = event.clientX - offset.left;
            y1 = event.clientY - offset.top;
            $(this).mousemove(function (event) {
                $(this).closest(".dhxwin_active").css("left", (event.clientX - x1) + "px");
                $(this).closest(".dhxwin_active").css("top", (event.clientY - y1) + "px");
            });
            $(this).mouseup(function (event) {
                $(this).unbind("mousemove");
            });
        });
    }
    if (typeof (options.url) != "undefined") {
        lay.attachEvent("onContentLoaded", function (id) {
            var ifr = lay.cells(id).getFrame();
            ifr.contentWindow.FrameDialog = w1;
            if (typeof (ifr.contentWindow.dialogResult) == "undefined") {
                ifr.contentWindow.dialogResult = function () {
                    this.parent.dialogData = this.Layout.getData();
                    return this.parent.dialogData;
                }
            }
            w1.iframe = ifr;
        });
        lay.cells("a").attachURL(options.url, false, options.postData);
    }
    w1.layout = lay;


    return w1;
}

dhtmlx.popup = function (options) {

    if (typeof (options.width) == "undefined") options.width = 400;
    if (typeof (options.height) == "undefined") options.height = 300;
    if (typeof (options.full) != "undefined" && options.full == true) {
        options.width = $(window).width();
        options.height = $(window).height();
    }

    var pop = new dhtmlXPopup({
        toolbar: options.bar,
        id: options.id
    });
    pop.options = options;
    pop.lay = null;
    if (typeof (options.onShow) != "undefined") { pop.attachEvent("onShow", options.onShow); };
    pop.attachEvent("onShow", function () {
        if (this.lay != null) {
            if (this.options.hasSubmit) {
                this.lay = pop.attachLayout(this.options.width, this.options.height, "2E");
                this.lay.cells("b").hideHeader();
                this.lay.cells("b").setHeight(50);
                formData = [
                   { type: "button", name: "sumbit", value: "提交", offsetLeft: this.options.width - 200 },
                   { type: "newcolumn" },
                   { type: "button", name: "close", value: "关闭" }
                ];
                var myForm = this.lay.cells("b").attachForm(formData);
                myForm.attachEvent("onButtonClick", function (id) {
                    if (id == "sumbit") {
                        var ifr = lay.cells("a").getFrame();
                        $(ifr.contentWindow.document).find("form").ajaxSubmit({
                            success: function (data) {
                                if (data.Success) {
                                    if (typeof (pop.options.success) == "undefined") {
                                        pop.options.success();
                                        dhtmlx.alert(data.Message);
                                    }
                                }
                                else {
                                    dhtmlx.alert({
                                        text: data.Message,
                                        callback: function () { window.setTimeout("pop.show();", 1000); }
                                    });
                                }
                            }
                        });
                    }
                    else if (id == "close") {
                        pop.hide();
                    }
                });
            }
            else {
                this.lay = this.lay.attachLayout(this.options.width, this.options.height, "1C");
            }
            this.lay.cells("a").hideHeader();
            this.lay.cells("a").fixSize(true, true);
        }
        if (this.options.url) this.lay.cells("a").attachURL(this.options.url);
    });
    return pop;
};

$.newGuid = function () {
    var guid = "";
    for (var i = 1; i <= 32; i++) {
        var n = Math.floor(Math.random() * 16.0).toString(16);
        guid += n;
        if ((i == 8) || (i == 12) || (i == 16) || (i == 20))
            guid += "-";
    }
    return guid;
}

dhtmlx.layout = function (design, container, name) {

    var _self = {};
    _self.name = name;
    _self.formData = {};
    _self.designData = design;
    _self.forms = [];
    _self.grids = [];
    _self.tbars = [];
    _self.sbars = [];
    _self.tabs = [];
    _self.accs = [];
    _self.lays = [];
    _self.getData = function () {
        for (var i = 0; i < _self.forms.length; i++) {
            var form = _self.forms[i];
            $.extend(_self.formData, form.getFormData());
            form.forEachItem(function (name) {
                var type = form.getItemType(name);
                if (type == "checkbox") {
                    _self.formData[name] = form.isItemChecked(name);
                }
            });
        }
        for (var i = 0; i < _self.grids.length; i++) {
            var name = _self.grids[i];
            _self.formData[name] = _self[name].getData();
        }
        _self.formData.__DesignName = _self.name
        return _self.formData;
    };
    _self.setData = function (data) {
        _self.formData = data;
        for (var i = 0; i < _self.forms.length; i++) {
            var form = _self.forms[i];
            var fdata = form.getFormData();
            for (var k in fdata) {
                var t = form.getItemType(k);
                if (data[k]) {
                    if (t == "calendar") {
                        fdata[k] = new Date(data[k]).format("yyyy-MM-dd");
                    }
                    else {
                        fdata[k] = data[k];
                    }
                }
                else {
                    if (data.hasOwnProperty(k)) fdata[k] = '';
                }
            }
            form.setFormData(fdata);
        }
        for (var i = 0; i < _self.grids.length; i++) {
            var name = _self.grids[i];
            var g = _self[name];
            if (data[name] && g) g.setData(data[name]);
        }
    }
    _self.setItem = function (name, value) {
        for (var i = 0; i < _self.forms.length; i++) {
            var form = _self.forms[i];
            if (form.isItem(name)) {
                form.setItemValue(name, value);
                break;
            }
        }
    }
    _self.save = function (url, callback) {
        if (!_self.check()) return
        $.ajax({
            type: "POST",
            url: url,
            data: _self.getData(),
            success: function (response) {
                if (response.Success) {
                    _self.lock();
                    dhtmlx.alert(response.Message);
                    if (callback) callback(response.Result);
                }
                else {
                    dhtmlx.error(response.Message);
                }
            }
        });
    }
    _self.check = function () {
        var data = _self.getData();
        for (var i = 0; i < design.Context.length; i++) {
            var field = design.Context[i];
            if (field.Required) {
                if (!data[field.Name] || data[field.Name].length == 0) {
                    dhtmlx.error(field.Label + "是必输项");
                    return false;
                }
            }
        }
        return true;
    }

    function getNavData() {
        var data = _self.getData();
        return { DesignName: _self.name, ID: data.ID };
    }

    _self.loadJson = function (url, data, callback) {
        $.ajax({
            type: "POST",
            url: url,
            data: data,
            success: function (response) {
                if (response.Success) {
                    var result = response.Result;
                    if (result) {
                        _self.setData(result);
                        _self.lock();
                        if (callback) callback(result);
                    }
                }
            }
        });
    }

    _self.goFrist = function () { _self.loadJson("/Designer/GoFristRdcord/", getNavData()); }
    _self.goLast = function () { _self.loadJson("/Designer/GoLastRdcord/", getNavData()); }
    _self.goForward = function () { _self.loadJson("/Designer/GoForwardRdcord/", getNavData()); }
    _self.goNext = function () { _self.loadJson("/Designer/GoNextRdcord/", getNavData()); }

    _self.remove = function (url, callback) {
        var d = _self.getData();
        if (!d || !d.ID) {
            dhtmlx.error("无数据！");
            return;
        }
        dhtmlx.confirm({
            text: "确定要删除数据？",
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: "POST",
                        url: url + "/" + d.ID,
                        success: function (response) {
                            if (response.Success) {
                                _self.clearData();
                                dhtmlx.alert(response.Message);
                                if (callback) callback(response.Result);
                            }
                            else {
                                dhtmlx.error(response.Message);
                            }
                        }
                    });
                }
            }
        });


    }
    _self.add = function () {
        _self.clearData();
        _self.unlock();
    }
    _self.edit = function () {
        _self.unlock();
    }
    _self.clearData = function () {
        var data = _self.getData();
        for (key in data) {
            data[key] = "";
        }
        _self.setData(data);
        for (var i = 0; i < _self.grids.length; i++) {
            var name = _self.grids[i];
            var g = _self[name];
            if (g) g.clearAll();
        }
    }

    _self.lock = function () {
        for (var i = 0; i < _self.forms.length; i++) {
            var form = _self.forms[i];
            if (form) form.lock();
        }

        for (var i = 0; i < _self.grids.length ; i++) {
            var gn = _self.grids[i];
            var g = _self[gn];
            g.setEditable(false);
        }
    }
    _self.unlock = function () {
        for (var i = 0; i < _self.forms.length; i++) {
            var form = _self.forms[i];
            form.unlock();
        }
        for (var i = 0; i < _self.grids.length ; i++) {
            var gn = _self.grids[i];
            var g = _self[gn];
            g.setEditable(true);
            var count = g.getRowsNum();
            if (count < 1) g.newRow();
        }
        _self.unlockBtn("save");
    }

    _self.lockBtn = function (name) {
        for (var i = 0; i < _self.tbars.length; i++) {
            var tool = _self.tbars[i];
            if (tool) tool.disableItem(name);
        }
    }

    _self.unlockBtn = function (name) {
        for (var i = 0; i < _self.tbars.length; i++) {
            var tool = _self.tbars[i];
            tool.enableItem(name);
        }
    }

 _self.hideBtn = function (name) {
        for (var i = 0; i < _self.tbars.length; i++) {
            var tool = _self.tbars[i];
            if (tool) tool.hideItem(name);
        }
    }

    _self.showBtn = function (name) {
        for (var i = 0; i < _self.tbars.length; i++) {
            var tool = _self.tbars[i];
            tool.showItem(name);
        }
    }
    _self.hideToolbarItem = function (name) {

        for (var i = 0; i < _self.tbars.length; i++) {
            var tool = _self.tbars[i];
            tool.forEachItem(function (itemId) {
                if (itemId == name) {
                    tool.enableItem(name);
                    tool.hideItem(name);
                }
            });
        }
    }

    _self.combo = function (name, url, textName, valueName) {
        for (var i = 0; i < _self.forms.length; i++) {
            var form = _self.forms[i];
            var textFeild = textName;
            var valueFeild = valueName;

            var dhxCombo = form.getCombo(name);
            if (dhxCombo) {
                $.ajax({
                    async: false,
                    type: "get",
                    url: url,
                    success: function (response) {
                        if (response.Success) {
                            var data = response.Result.data;
                            var opts = [];
                            if (!dhxCombo.Required) { opts.push({ text: '', value: '' }); }
                            for (var i = 0; i < data.length; i++) {
                                var d = data[i];
                                opts.push({ text: d[textFeild], value: d[valueFeild] });
                            }
                            form.reloadOptions(name, opts);
                        }
                        else {
                            dhtmlx.error(response.Message);
                        }
                    }
                });


            }
        }

    }

    if (container && container.detachObject) container.detachObject(true);


    _self.layout = createView(container, design);

    function createGrid(g, item) {

        if (item.Columns && item.Columns.length > 0) {

            var formatData = {
                add: !item.Disable,
                columns: item.Columns,
                name: _self.name + '.' + item.Name
            };
            if (item.DataUrl && item.DataUrl.length > 0) {
                formatData.remote = true;
                formatData.url = item.DataUrl;
            }
            g.format(formatData);
            if (!item.Disable) {
                g.newRow();
            }
            g.setEditable(!item.Disable);
            g.attachEvent("broweClick", function (r, c, v, column, grid, e) {
                var h = _self.callEvent("gridBroweClick", [r, c, v, column, grid, e]);
                if (h && _self.gridBroweClick) {
                    _self.gridBroweClick(r, c, v, column, grid, e);
                    return true;
                }
            });
            g.attachEvent("onKeyPress", function (code, cFlag, sFlag) {
                return _self.callEvent("gridKeyPress", [code, cFlag, sFlag, this]);
            });
            g.attachEvent("onRowDblClicked", function (rId, cInd) {
                return _self.callEvent("gridDblClick", [rId, cInd, this]);

            });
            g.attachEvent("onRowSelect", function (id, ind) {
                return _self.callEvent("gridSelect", [id, ind, this]);
            });
        }
        _self.grids.push(item.Name);
        _self[item.Name] = g;
        g.This = _self;
        g.ItemName = item.Name;

    }

    function createTree(t, item) {
        var formatData = {};
        if (item.DataUrl && item.DataUrl.length > 0) {
            formatData.url = item.DataUrl;
        }
        t.format(formatData);
        _self[item.Name] = t;
    }

    function createForm(layout, data) {

        if (!data.Names) data.Names = [];
        //如果是填充到容器 （只能有1个填充到容器）
        if (data.Names.length == 1) {
            var name = data.Names[0];
            var item = dhtmlx.find(_self.designData.Context, "Name", name);
            if (item && item.IsFull) {
                if (item.InputType == "grid") {
                    layout.context_This = layout.attachGrid();
                    createGrid(layout.context_This, item);
                    if (item.HasPager) layout.pager({ target: layout.context_This });

                }
                if (item.InputType == "tree") {
                    layout.context_This = layout.attachTree();
                    createTree(layout.context_This, item);
                }
                if (item.InputType == "treeview") layout.context_This = layout.attachTreeView();
                if (item.InputType == "view") layout.context_This = layout.attachDataView();
                if (item.InputType == "list") layout.context_This = layout.attachList();
                if (item.InputType == "treegrid") layout.context_This = layout.attachGrid();
                if (item.InputType == "frame") {
                    var postData = {};
                    for (var j = 0; j < item.UserData.length; j++) {
                        postData[item.UserData[j].Text] = item.UserData[j].Value;
                    }
                    layout.attachURL(item.DataUrl, null, postData);
                }
                layout.context_Type = item.InputType;
                layout.context_This.Names = data.Names;
                layout.context_Objs = {};
                layout.context_Objs[item.Name] = layout.context_This;
                layout.context_This.lay = layout;
                return;
            }
        }



        var datas = [];
        for (var i = 0; i < data.Names.length; i++) {
            var name = data.Names[i];
            var item = dhtmlx.find(_self.designData.Context, "Name", name);

            var el = {
                type: item.InputType,
                name: item.Name,
                label: item.Label,
                inputWidth: item.InputWidth ? item.InputWidth : 120,
                inputHeight: item.InputHeight ? item.InputHeight : 16,
                hidden: item.Hidden ? item.Hidden : false,
                disabled: item.Disable ? item.Disable : false,
                required: item.Required ? item.Required : false,
                value: item.DefaultValue ? item.DefaultValue : "",
                maxLength: item.MaxLength ? item.MaxLength : 20,
                labelWidth: item.LabelWidth ? item.LabelWidth : "80",
                labelHeight: item.LabelHeight ? item.LabelHeight : "",
                tooltip: item.Tooltip ? item.Tooltip : "",
                position: item.Position ? item.Position : "label-left"
            };
            if (item.Style && item.Style.length > 0) el.style = item.Style;
            if (item.ClassName && item.ClassName.length > 0) el.className = item.ClassName;
            if (!item.OffsetTop) item.OffsetTop = 0;
            if (!el.inputWidth || el.inputWidth.length == 0) el.inputWidth = 120;
            if (!el.inputHeight || el.inputHeight.length == 0) el.inputHeight = 16;
            if (item.InputType == "textarea") {
                el.type = "input";
                el.rows = item.InputHeight / 16;
            }
            if (item.InputType == "calendar1") {
                el.type = "calendar";
                el.dateFormat = "%Y/%m/%d %H:%i";
            }
            if (item.InputType == "calendar2") {
                el.type = "calendar";
                el.dateFormat = "%Y/%m/%d";
                //el.value = new Date().format("yyyy-MM-dd");
            }
            if (item.Precision) {
                var l = parseInt(item.Precision);
                if (l > 0) el.numberFormat = "0,000." + "0000000".substring(0, l);
            }
            if (item.InputType == "label") el.label = item.DefaultValue;
            if (item.InputType == "button") {
                el.value = item.Label;
                el.className += ' form-btn';
                el.width = item.InputWidth;
            }

            if (item.InputType == "image") {
                el.url = item.DataUrl;
                el.imageWidth = item.InputWidth;
                el.imageHeight = item.InputHeight;
            }
            if (item.InputType == "grid" ||
                item.InputType == "tree" ||
                item.InputType == "treeview" ||
                item.InputType == "view" ||
                item.InputType == "list" ||
                item.InputType == "treegrid") {
                el.type = "container";
            }
            if (item.InputType == "year") {
                el.type = "input";
                if (item.DefaultValue)
                    el.value = item.DefaultValue;
                else
                    el.value = new Date().getFullYear();
            }
            if (item.InputType == "month") {
                el.type = "combo";
                el.options = [];
                var def = new Date().getMonth() + 1;
                if (item.DefaultValue) var def = item.DefaultValue;
                el.value = item.DefaultValue;
                for (var j = 1; j <= 12; j++) {
                    el.options.push({
                        text: j,
                        value: j,
                        selected: def == j
                    });
                }
            }
            if (item.InputType == "checkbox") {
                el.checked = item.DefaultValue == "1" || item.DefaultValue == "true";
            }
            if (item.Options) {
                el.options = [];
                for (var j = 0; j < item.Options.length; j++) {
                    el.options.push({
                        text: item.Options[j].Text,
                        value: item.Options[j].Value
                    });
                }
            }
            if (item.UserData) {
                el.userdata = {};
                for (var j = 0; j < item.UserData.length; j++) {
                    el.userdata[item.UserData[j].Text] = item.UserData[j].Value;
                }
            }
            var w = parseInt(el.inputWidth) + parseInt(el.labelWidth) + 10;
            if (item.InputType == "browe") {
                el.type = "input";
                el.inputWidth = el.inputWidth - 30;
                var itemData = {
                    type: "block", name: "block_" + item.Name, width: w, offsetLeft: 0, blockOffset: 0, offsetTop: item.OffsetTop, list: [
                        el,
                        itemData = { type: "newcolumn", offset: 0 },
                        {
                            type: "button", name: "btn" + item.Name, value: "", className: "form-browe", userdata: { target: item.Name }
                        }
                    ]
                };
                datas.push(itemData);
            }
            else {
                var itemData = {
                    type: "block", name: "block_" + item.Name, width: w, style: 'A', offsetLeft: 0, blockOffset: 0, offsetTop: item.OffsetTop, list: [
                        el
                    ]
                };
                datas.push(itemData);
            }
        }
        layout.context_Type = "form"
        layout.context_This = layout.attachForm(datas);
        layout.context_This.Names = data.Names;

        layout.context_Objs = {};
        layout.context_This.cont.targetForm = layout.context_This;

        for (var i = 0; i < data.Names.length; i++) {
            var name = data.Names[i];
            var item = dhtmlx.find(_self.designData.Context, "Name", name);
            var block = layout.context_This._getItemByName("block_" + item.Name);
            if (block) {
                block.style.left = item.OffsetX + "px";
                block.style.top = item.OffsetY + "px";
                block.style.position = 'absolute';
            }
        }


        for (var i = 0; i < data.Names.length; i++) {
            var name = data.Names[i];
            var item = dhtmlx.find(_self.designData.Context, "Name", name);
            if (item.InputType == "grid") {
                layout.context_Objs[item.Name] = new dhtmlXGridObject(layout.context_This.getContainer(item.Name));
                if (!item.Columns) item.Columns = [];
                createGrid(layout.context_Objs[item.Name], item);
            }
            if (item.InputType == "tree") {
                layout.context_Objs[item.Name] = new dhtmlXTreeObject(layout.context_This.getContainer(item.Name));
                createTree(layout.context_Objs[item.Name], item);
            }
            if (item.InputType == "treeview") layout.context_Objs[item.Name] = new dhtmlXTreeView(layout.context_This.getContainer(item.Name));
            if (item.InputType == "view") layout.context_Objs[item.Name] = new dhtmlXDataView(layout.context_This.getContainer(item.Name));
            if (item.InputType == "list") layout.context_Objs[item.Name] = new dhtmlXList(layout.context_This.getContainer(item.Name));
            if (item.InputType == "treegrid") layout.context_Objs[item.name] = new dhtmlXGridObject(layout.context_This.getContainer(item.Name));
            if (item.InputType == "frame") dhtmlx.alert("子页面必须填充到父容器！");

        }
        layout.context_This.attachEvent("onChange", function (name, value, state) { _self.callEvent("onChange", [name, value, state, this]); });
        layout.context_This.attachEvent("onKeyDown", function (inp, ev, name, value) { _self.callEvent("onKeyDown", [inp, ev, name, value, this]); });
        layout.context_This.attachEvent("onKeyUp", function (inp, ev, name, value) { _self.callEvent("onKeyUp", [inp, ev, name, value, this]); });
        layout.context_This.attachEvent("onButtonClick", function (name) {
            var targetName = this.getUserData(name, "target");
            if (targetName) {
                var item = dhtmlx.find(_self.designData.Context, "Name", targetName);
                var h = _self.callEvent("broweClick", [targetName, this, item]);
                if (h && _self.broweClick) {
                    _self.broweClick(targetName, this, item);
                }
            } else {
                var item = dhtmlx.find(_self.designData.Context, "Name", name);
                _self.callEvent("buttonClick", [name, this, item]);
            }
        });
        _self.forms.push(layout.context_This);

    }

    function createView(layout, data) {
        if (data.Type == "layout")
            return createLayout(layout, data);
        else if (data.Type == "tabbar")
            return createTabbar(layout, data);
        else if (data.Type == "accordion")
            return createAccordion(layout, data);
        else
            return createForm(layout, data);
    }

    function createLayout(layout, data) {

        var cells = [];
        for (var i = 0; i < data.Child.length; i++) {
            var cell = data.Child[i];
            cells.push({
                id: "abcdefgh".substring(i, i + 1),
                text: typeof (cell.Text) != "undefined" ? cell.Text : "",
                collapsed_text: typeof (cell.Collapsed_Text) != "undefined" ? cell.Collapsed_Text : "",
                header: typeof (cell.Header) != "undefined" ? cell.Header : true,
                width: typeof (cell.Width) != "undefined" ? cell.Width : null,
                height: typeof (cell.Height) != "undefined" ? cell.Height : null,
                collapse: typeof (cell.Collapse) != "undefined" ? cell.Collapse : false,
                fix_size: [typeof (cell.Fix_Width) != "undefined" ? cell.Fix_Width : null, typeof (cell.Fix_Height) != "undefined" ? cell.Fix_Height : null]
            });
        }
        var lay
        if (!layout || layout.tagName == 'BODY') {
            lay = new dhtmlXLayoutObject({
                parent: document.body,
                pattern: data.Pattern,
                cells: cells
            });
            layout = lay;

        }
        else {
            lay = layout.attachLayout({
                pattern: data.Pattern,
                cells: cells
            });
        }
        attachEvent(lay, data);
        for (var i = 0; i < data.Child.length; i++) {
            var cell = data.Child[i];
            var names = "abcdefghijklmn"
            var id = names.substring(i, i + 1);
            if (cell.HasStatus) {
                lay.cells(id).Sbar = lay.cells(id).attachStatusBar({
                    text: typeof (cell.StatusText) != "undefined" ? cell.StatusText : "",
                    height: typeof (cell.StatusHeight) != "undefined" ? cell.StatusHeight : 10
                });
                _self.tbars.push(lay.cells(id).Sbar);
            }
            if (cell.HasToolbar) {
                lay.cells(id).TBar = lay.cells(id).attachToolbar({
                    icons_path: "/DHX/imgs/dhxtoolbar_terrace/"
                });
                lay.cells(id).TBar.id = id;
                lay.cells(id).TBar.addItems(cell.ToolbarItems);
                addToolBarClick(lay.cells(id).TBar);
                _self.tbars.push(lay.cells(id).TBar);
            }
            
            
         
            
            
            
            var newID = $.newGuid();
            $(lay.cells(id).cell).find(".dhx_cell_cont_layout").attr("id", newID);
            lay.cells(id).id = newID;
            createView(lay.cells(id), cell);
        }
        layout.layout_Data = data;
        layout.layout_Type = "layout";
        layout.layout_This = lay;
        _self.lays.push(lay);
        return lay;
    }

    function addToolBarClick(toolbar) {
        toolbar.attachEvent("onClick", function (id) {
            var h = _self.callEvent("toolbarClick", [id, this]);
            if (h && _self.toolbarClick) {
                _self.toolbarClick(id, this);
                return true;
            }
        });
    }

    function createTabbar(layout, data) {
        var tabs = [];
        for (var i = 0; i < data.Child.length; i++) {
            var tab = data.Child[i];
            tabs.push({
                id: "a" + i.toString(),
                text: typeof (tab.Text) != "undefined" ? tab.Text : "a" + i.toString(),
                width: typeof (tab.Width) != "undefined" ? tab.Width : 120,
                close: typeof (tab.Close) != "undefined" ? tab.Close : false,
                enabled: typeof (tab.Enabled) != "undefined" ? tab.Enabled : true,
                active: typeof (tab.Active) != "undefined" ? tab.Active : (i == 0)
            });
        }
        var lay = layout.attachTabbar({
            mode: data.Mode,
            align: data.Align,
            close_button: typeof (data.Close_Button) != "undefined" ? data.Close_Button : true,
            content_zone: typeof (data.Content_Zone) != "undefined" ? data.Content_Zone : true,
            arrows_mode: typeof (data.Arrows_Mode) != "undefined" ? data.Arrows_Mode : "auto",
            tabs: tabs
        });
        attachEvent(lay, data);
        for (var i = 0; i < data.Child.length; i++) {
            var cell = data.Child[i];
            var id = "a" + i.toString();
            if (cell.HasStatus) {
                lay.tabs(id).SBar = lay.tabs(id).attachStatusBar({
                    text: typeof (cell.StatusText) != "undefined" ? cell.StatusText : "",
                    height: typeof (cell.StatusHeight) != "undefined" ? cell.StatusHeight : 10
                });
                _self.sbars.push(lay.tabs(id).SBar);
            }
            if (cell.HasToolbar) {
                lay.tabs(id).TBar = lay.cells(id).attachToolbar({
                    icons_path: "/DHX/imgs/dhxtoolbar_terrace/"
                });
                lay.cells(id).TBar.id = id;
                lay.tabs(id).TBar.addItems(cell.ToolbarItems);
                addToolBarClick(lay.tabs(id).TBar);
                _self.tbars.push(lay.tabs(id).TBar);
            }
        
            
            
            
            
            
            
            var newID = $.newGuid();
            $(lay.tabs(id).cell).find(".dhx_cell_cont_tabbar").attr("id", newID);
            lay.tabs(id).id = newID;
            createView(lay.tabs(id), cell);
        }
        layout.layout_Data = data;
        layout.layout_Type = "tabbar";
        layout.layout_This = lay;
        _self.tabs.push(lay);
        return lay;
    }

    function createAccordion(layout, data) {
        var items = [];
        for (var i = 0; i < data.Child.length; i++) {
            var item = data.Child[i];
            items.push({
                id: "a" + i.toString(),
                text: typeof (item.Text) != "undefined" ? item.Text : "a" + i.toString(),
                height: typeof (item.Height) != "undefined" ? item.Height : null,
                icon: typeof (item.Icon) != "undefined" ? item.Icon : null,
                open: typeof (item.Open) != "undefined" ? item.Open : (i == 0)
            });
        }
        var lay = layout.attachAccordion({
            items: items
        });


        attachEvent(lay, data);
        for (var i = 0; i < data.Child.length; i++) {
            var cell = data.Child[i];
            var id = "a" + i.toString();
            if (cell.HasStatus) {
                lay.cells(id).SBar = lay.cells(id).attachStatusBar({
                    text: typeof (cell.StatusText) != "undefined" ? cell.StatusText : "",
                    height: typeof (cell.StatusHeight) != "undefined" ? cell.StatusHeight : 10
                });
                _self.sbars.push(lay.cells(id).SBar)
            }
            if (cell.HasToolbar) {
                lay.cells(id).TBar = lay.cells(id).attachToolbar({
                    icons_path: "/DHX/imgs/dhxtoolbar_terrace/"
                });
                lay.cells(id).TBar.id = id;
                lay.cells(id).TBar.addItems(cell.ToolbarItems);
                addToolBarClick(lay.cells(id).TBar);
                _self.tbars.push(lay.cells(id).TBar);
            }
            
            
            
            
           
            
            
              
            var newID = $.newGuid();
            $(lay.cells(id).cell).find(".dhx_cell_cont_acc").attr("id", newID);
            lay.cells(id).id = newID;
            createView(lay.cells(id), cell);
        }
        layout.layout_Data = data;
        layout.layout_Type = "accordion";
        layout.layout_This = lay;
        _self.accs.push(lay);
        return lay;
    }

    function attachEvent(layout, data) {
        if (!data.Events) data.Events = [];
        for (var i = 0; i < data.Events.length; i++) {
            var ev = data.Events[i];
            eval("var fn=" + ev.Value);
            layout.attachEvent(ev.Text, fn);
        }
    }

    _self.events = { data: {} };
    _self.addEvent = function (e, h) {
        e = String(e).toLowerCase();
        if (!this.events.data[e]) {
            this.events.data[e] = {}
        }
        var g = $.newGuid();
        this.events.data[e][g] = h;
        return g
    };
    _self.callEvent = function (g, l) {
        g = String(g).toLowerCase();
        if (this.events.data[g] == null) {
            return true
        }
        var h = true;
        for (var e in this.events.data[g]) {
            h = this.events.data[g][e].apply(this, l) && h;
        }
        return h
    };
    _self.detachEvent = function (l) {
        for (var g in this.events.data) {
            var h = 0;
            for (var e in this.events.data[g]) {
                if (e == l) {
                    this.events.data[g][e] = null;
                    delete this.events.data[g][e]
                }
                else {
                    h++
                }
            }
            if (h == 0) {
                this.events.data[g] = null;
                delete this.events.data[g]
            }
        }
    };
    _self.delEvent = function (l) {
        for (var g in this.events.data) {
            if (String(g).toLowerCase() == l.toLowerCase()) {
                this.events.data[g] = null;
                delete this.events.data[g];
            }
        }
    }



    _self.gridBroweClick = function (r, c, v, column, grid, e) {
        if (!column || !column.Options) return;
        var opts = column.Options;
        var opt = dhtmlx.find(opts, "Text", "url");
        var url = opt ? opt.Value : null;
        if (!url) {
            dhtmlx.error("为定义子页面路径！[url]");
            return;
        }
        opt = dhtmlx.find(opts, "Text", "width");
        var width = opt ? opt.Value : null;
        opt = dhtmlx.find(opts, "Text", "height");
        var height = opt ? opt.Value : null;
        function setDate(data) {
            for (key in data) {
                var cindex = grid.getColIndexById(key);
                if (cindex >= 0) {
                    var col = dhtmlx.find(grid.formatOpts.columns, "Name", key);
                    if (col.DataType == "date") {
                        grid.cells(r, cindex).setValue(parseDate(data[key]))
                    }
                    else {
                        grid.cells(r, cindex).setValue(data[key]);
                    }
                }
            }
        }
        var w1 = dhtmlx.showDialog({
            url: url,
            postData: { name: c, value: v },
            caption: "请选择",
            saveText: "确认",
            width: width,
            height: height,
            save: function () {
                if (w1.iframe) {
                    if (w1.iframe.contentWindow.dialogResult) {
                        var data = w1.iframe.contentWindow.dialogResult();
                        _self.callEvent("gridBrowing", [c, data]);
                        setDate(data);
                        w1.close();
                    }
                    else {
                        dhtmlx.error("请定义子页面的[dialogResult]函数！")
                    }
                }
            }
        });
    };
    _self.broweClick = function (name, form, item) {
        var targetName = name;
        var targetValue = form.getItemValue(targetName);
        var result = dhtmlx.find(item.UserData, "Text", "width");
        var width = result ? result.Value : null;
        var result = dhtmlx.find(item.UserData, "Text", "height");
        var height = result ? result.Value : null;

        if (item.ClassName.toLowerCase() == "u8cus") {
            if (!item.DataUrl) item.DataUrl = "/U8UI/GO/BroweCustomer";
            if (width == null) width = 800;
            if (height == null) height = 600;
        }
        if (item.ClassName.toLowerCase() == "u8dep") {
            if (!item.DataUrl) item.DataUrl = "/U8UI/GO/BroweDepartment";
            if (width == null) width = 400;
            if (height == null) height = 400;
        }
        if (item.ClassName.toLowerCase() == "u8psn") {
            if (!item.DataUrl) item.DataUrl = "/U8UI/GO/BrowePerson";
            if (width == null) width = 800;
            if (height == null) height = 600;
        }
        if (item.ClassName.toLowerCase() == "u8ven") {
            if (!item.DataUrl) item.DataUrl = "/U8UI/GO/BroweVendor";
            if (width == null) width = 800;
            if (height == null) height = 600;
        }
        if (item.ClassName.toLowerCase() == "u8item") {
            if (!item.DataUrl) item.DataUrl = "/U8UI/GO/BroweItem";
            if (width == null) width = 800;
            if (height == null) height = 600;
        }

        if (item.ClassName.toLowerCase() == "u8inv") {
            if (!item.DataUrl) item.DataUrl = "/U8UI/GO/BroweInventory";
            if (width == null) width = 800;
            if (height == null) height = 600;
        }
        if (item && item.DataUrl) {

            var w1 = dhtmlx.showDialog({
                url: item.DataUrl,
                postData: { name: targetName, value: targetValue },
                caption: "请选择",
                saveText: "确认",
                width: width,
                height: height,
                save: function () {
                    if (w1.iframe) {
                        if (w1.iframe.contentWindow.dialogResult) {
                            var data = w1.iframe.contentWindow.dialogResult();
                            if (_self.callEvent("browing", [targetName, data])) {
                                if (data[name])
                                    _self.setItem(name, data[name]);
                                else {
                                    for (key in data) {
                                        var v = data[key];
                                        _self.setItem(name, v);
                                        break;
                                    }
                                }
                                _self.setData(data);
                            }
                            w1.close();
                        }
                        else {
                            dhtmlx.error("请定义子页面的[dialogResult]函数！")
                        }
                    }
                }
            });
        }

    };
    _self.toolbarClick = function (id, toolbar) {
        switch (id) {
            case "print":
            	
                break;
            case "preview":
                var $printGrid = $(".dhx_cell_cont_layout").clone();
                $printGrid.children().css({
                    "overflow": "visible",
                    "overflow-x": "visible",
                    "overflow-y": "visible"
                });
                $printGrid.children().children().css({
                    "height": "auto",
                    "width": "auto",
                    "position": "relative",
                    "overflow": "visible",
                    "overflow-x": "visible",
                    "overflow-y": "visible"
                });
                $printGrid.printArea({
                    mode: "popup",
                    popTitle: document.title,
                    popClose: false,
                    print: false,
                    max: true
                });
                break;
            case "export":
                if (_self.grids[0]) {
                    var g = _self[_self.grids[0]];
                    g.toExcelExt();
                }
                break;
            case "add":
                _self.add();
                break;
            case "edit":
                _self.edit();
                break;
            case "del":
                _self.remove();
                break;
            case "save":
                _self.save();
                break;
            case "frist":
                _self.goFrist();
                break;
            case "last":
                _self.goLast();
                break;
            case "forward":
                _self.goForward();
                break;
            case "next":
                _self.goNext();
                break;
            case "help":
                break;
            case "refresh":
                location.reload();
                break;
            case "exit":
                if (top.closeActiveTab) top.closeActiveTab();
                break;
        
        }
    };

    _self.setAuth = function (name, auths) {
        if (!top.authorizeButtonData) return;
        if (!name) name = _self.name;
        if (!auths) auths = top.authorizeButtonData;

        for (var i = 0; i < auths.length; i++) {
            var auth = auths[i];
            if (auth.MenuName == name && auth.HasAuth == false) {
                _self.hideToolbarItem(auth.ActID);
            }
        }

    }
    return _self;
}


dhtmlx.configureDhxGrid = function (data, callback) {

    var w1 = dhtmlx.showDialog({
        caption: '表格设置',
        width: 950,
        height: 550,
        modal: true,
        save: function () {
            if (callback) {
                var nData = [];
                var data = dhxGrid.getData();
                for (var i = 0; i < data.length ; i++) {
                    var item = data[i];
                    if (item.Name) {
                        delete item["up"];
                        delete item["down"]
                        nData.push(item);
                    }
                }
                w1.close();
                callback(nData);
            }
        }
    });
    var lay = w1.layout.cells("a");
    var dhxGrid = lay.attachGrid().format({
        autowidth: false,
        columns: [
            { Name: "Name", Label: "字段", Width: 100, InputType: "ed", Align: "left" },
            { Name: "Label", Label: "名称", Width: 100, InputType: "ed", Align: "left", Frozen: true },
            {
                Name: "DataType", Label: "数据类型", Width: 80, InputType: "coro", Align: "left", Options: [
                      { Text: '文本', Value: 'str' },
                      { Text: '数字', Value: 'int' },
                      { Text: '日期', Value: 'date' },
                      { Text: '真假', Value: 'bool' }
                ]
            },
            { Name: "MaxLength", Label: "长度", Width: '40', InputType: "ed", Align: "right" },
            { Name: "Precision", Label: "精度", Width: '40', InputType: "ed", Align: "right" },
            { Name: "DefaultValue", Label: "默认值", Width: '60', InputType: "ed", Align: "right" },
            { Name: "Required", Label: "必输", Width: '50', InputType: "ch", Align: "right" },
            {
                Name: "InputType", Label: "显示类型", Width: 70, InputType: "coro", Align: "left", Options: [
                      { Text: '输入', Value: 'ed' },
                      { Text: '只读', Value: 'ro' },
                      { Text: '数字', Value: 'edncl' },
                      { Text: '选择', Value: 'ch' },
                      { Text: '多选', Value: 'clist' },
                      { Text: '下拉', Value: 'co' },
                      { Text: '日期', Value: 'dhxCalendar' },
                      { Text: '参考框', Value: 'browe' },
                      { Text: '颜色', Value: 'cp' },
                      { Text: '文本', Value: 'edtxt' },
                      { Text: '链接', Value: 'link' },
                      { Text: '图片', Value: 'img' },
                      { Text: '价格', Value: 'price' },
                      { Text: '树形', Value: 'stree' },
                      { Text: '表格', Value: 'grid' },
                      { Text: '多行文本', Value: 'txttxt' },
                      { Text: '只读文本', Value: 'rotext' },
                      { Text: '只读数字', Value: 'ednro' },
                      { Text: '只读下拉', Value: 'coro' },
                      { Text: '单选', Value: 'ra' },
                      { Text: '可输日期框', Value: 'dhxCalendarA' },
                      { Text: '计算器', Value: 'calck' },
                      { Text: '序号', Value: 'cntr' },

                ]
            },
            { Name: "Options", Label: "参考值", Width: '80', InputType: "ed", Align: "center" },
            {
                Name: "Align", Label: "对齐方式", Width: '60', InputType: "coro", Align: "left",
                Options: [
                    { Text: '靠左', Value: 'left' },
                    { Text: '居中', Value: 'center' },
                    { Text: '靠右', Value: 'right' }
                ]
            },
            { Name: "Width", Label: "列宽", Width: '60', InputType: "ed", Align: "right" },
            { Name: "Hidden", Label: "隐藏", Width: '60', InputType: "ch", Align: "center" },
            {
                Name: "Order", Label: "排序", Width: '80', InputType: "coro", Align: "center",
                Options: [
                    { Text: '否', Value: 'none' },
                    { Text: '升序', Value: 'asc' },
                    { Text: '降序', Value: 'desc' }
                ]
            }
        ]
    });


    dhxGrid.attachEvent("onLastRow", function () { addRow(); });
    dhxGrid.attachEvent("onBeforeSorting", function (ind, type, direction) { return false; });
    dhxGrid.attachEvent("onRowDblClicked", function (rid, cind) {
        var rowIndex = this.getRowIndex(rid);
        var cId = this.getColumnId(cind);

        if (cId == "Options") {
            var opts = this.getUserData(rid, cId);
            dhtmlx.nameValues(opts, function (o) {
                if (data.length > 0) {
                    dhxGrid.cells(rid, cind).setValue("已定义");
                }
                else {
                    dhxGrid.cells(rid, cind).setValue("");
                }
                dhxGrid.setUserData(rid, cId, o);
            });
        }
        return true;
    });



    var newRow = function () {
        return [
            "",
            "",
            "str",
            20,
            0,
            "",
            false,
            "ed",
            "",
            "left",
            100,
            false,
            "none"
        ];
    }

    var addRow = function () { dhxGrid.addRow($.newGuid(), newRow()); }
    //默认值设置 因为远程数据 如果是默认值不传递到客户机
    for (var i = 0; i < data.length; i++) {
        var d = data[i];
        if (!d.MaxLength) d.MaxLength = 20;
        if (!d.Precision) d.Precision = 0;
        if (!d.Required) d.Required = false;
        if (!d.Order) d.Order = "none";
        if (!d.Width) d.Width = 100;
        if (!d.Hidden) d.Hidden = false;
        if (!d.Align) d.Align = "left";
    }
    if (data) {
        dhxGrid.parse(data, "js");
        for (var i = 0; i < data.length; i++) {
            var rId = dhxGrid.getRowId(i);
            var cInd = dhxGrid.getColIndexById("Options");
            dhxGrid.cells(rId, cInd).setValue(data[i].Options ? "已定义" : "");
            dhxGrid.setUserData(rId, "Options", data[i].Options);
        }
    }
    addRow();

    w1.toolbar.addItem({ ID: "up", Pos: 1, Type: "button", Text: "上移" });
    w1.toolbar.addItem({ ID: "down", Pos: 2, Type: "button", Text: "下移" });
    w1.toolbar.addItem({ ID: "del", Pos: 3, Type: "button", Text: "删除" });
    w1.toolbar.attachEvent("onclick", function (id) {
        if (id == "up") {
            var rid = dhxGrid.getSelectedRowId();
            dhxGrid.moveRowUp(rid);
        }
        if (id == "down") {
            var rid = dhxGrid.getSelectedRowId();
            dhxGrid.moveRowDown(rid);
        }
        if (id == "del") {
            var rid = dhxGrid.getSelectedRowId();
            dhxGrid.deleteRow(rid);
        }
    });
    w1.dhxGrid = dhxGrid;
    return w1;
}

dhtmlx.nameValues = function (data, callback) {
    var w1 = dhtmlx.showDialog({
        caption: '键值对设置',
        width: 500,
        height: 350,
        modal: true,
        save: function () {
            if (callback) {
                var nData = [];
                var data = dhxGrid.getData();
                for (var i = 0; i < data.length ; i++) {
                    var item = data[i];
                    if (item.Text && item.Value) {
                        nData.push(item);
                    }
                }
                w1.close();
                callback(nData);
            }
        }
    });
    var lay = w1.layout.cells("a");
    var dhxGrid = lay.attachGrid().format({
        autowidth: false,
        columns: [
            { Name: "Text", Label: "名称", Width: 100, InputType: "ed", Align: "left" },
            { Name: "Value", Label: "值", Width: 100, InputType: "ed", Align: "left" }
        ]
    });
    dhxGrid.attachEvent("onLastRow", function () { addRow(); });
    dhxGrid.attachEvent("onBeforeSorting", function (ind, type, direction) { return false; });
    var addRow = function () { dhxGrid.addRow($.newGuid(), ["", ""]); }
    if (data) dhxGrid.parse(data, "js");
    addRow();
}


dhtmlx.find = function (datas, key, value) {
    if (!datas) return null;
    for (var i = 0; i < datas.length; i++) {
        var data = datas[i];
        if (data == value || data[key] == value) {
            return data;
        }
    }
}
dhtmlx.remove = function (datas, key, value) {
    for (var i = 0; i < datas.length; i++) {
        var data = datas[i];
        if (data[key] == value || data == value) {
            datas.splice(i, 1);
        }
    }
}
$.cleanJson = function (json) {
    for (key in json) {
        var v = json[key];
        if (v == null || v.length == 0) {
            delete json[key];
        }
        else {
            if (typeof (v) == "object")
                $.cleanJson(v);
        }
    }
    return json;
}

$.layout = function (name, init) {
    $.ajax({
        type: "get",
        url: "/Designer/Get/" + name,
        success: function (response) {
            if (response.Success) {
                if (init) {
                    var lay = dhtmlx.layout(response.Result, document.body, name);
                    init(lay);
                }
            }
            else {
                dhtmlx.error(response.Message);
            }
        }
    });
}

$.ajaxPost = function (url, data, callback) {
    $.ajax({
        dataType: "json",
        contentType: "application/json",
        type: "POST",
        url: url,
        data: JSON.stringify(data),
        success: function (response) {
            if (response.Success) {
                if (response.Message) dhtmlx.alert(response.Message);
                if (callback) callback(response.Result, response);
            }
            else {
                if (response.Message) dhtmlx.error(response.Message);
            }
        }
    });
}
$.ajaxGet = function (url, data, callback) {
    $.ajax({
        dataType: "json",
        type: "Get",
        url: url,
        data: data,
        success: function (response) {
            if (response.Success) {
                if (callback) callback(response.Result, response);
            }
            else {
                dhtmlx.error(response.Message);
            }
        }
    });
}

$.confirm = function (text, yes, no) {
    dhtmlx.confirm({
        text: text,
        callback: function (result) {
            if (result) {
                if (yes) yes();
            }
            else {
                if (no) no();
            }
        }
    });
}

$.upload = function (options, callback) {


    var dhxWins = new dhtmlXWindows();
    var w1 = dhxWins.createWindow({
        id: "A" + new Date(),
        left: ($(window).width() - 600) / 2,
        top: ($(window).height() - 400) / 2,
        width: 600,
        height: 400,
        center: true,
        move: true,
        park: true,
        resize: true,
        modal: true,
        caption: "上传文件",
        header: false
    });


    var lay = w1.attachLayout({
        pattern: "1C",
        cells: [{ id: "a", header: false, text: "" }]
    });
    var toolbar = lay.cells("a").attachToolbar({
        icons_path: "/DHX/imgs/dhxtoolbar_terrace/"
    });
    toolbar.addText("title", 0, "上传文件");
    toolbar.addSpacer("title");

    toolbar.addButton("open", 1, "选择文件");
    toolbar.addSeparator("step1", 2);
    toolbar.addButton("submit", 3, "确定");
    toolbar.addButton("exit", 4, "关闭");

    w1.submit = function () {
        if (callback) {
            var a = $(w1.iframe.contentDocument).find(".jFiler-item .jFiler-item-title");
            var files = [];
            for (var i = 0; i < a.length; i++) {
                files.push(a[i].innerHTML);
            }
            callback(files);
        }
        w1.close();
    }
    w1.open = function () {
        w1.iframe.contentWindow.Upload.click();
    }

    toolbar.target = w1;
    toolbar.attachEvent("onClick", function (id) {
        if (id == "exit") { this.target.close(); }
        if (id == "open") { this.target.open(); }
        if (id == "submit") { this.target.submit(); }
    });

    lay.attachEvent("onContentLoaded", function (id) {
        var ifr = lay.cells(id).getFrame();
        ifr.contentWindow.FrameDialog = w1;
        w1.iframe = ifr;
        w1.iframe.contentWindow.Filer(options);

    });
    lay.cells("a").attachURL("/upload/index");


    w1.layout = lay;
    w1.toolbar = toolbar;


    return w1;





}

$.browe = function (url, data, callback, w, h, text) {
    var w1 = dhtmlx.showDialog({
        url: url,
        postData: data,
        caption: text ? text : "请选择",
        saveText: "确认",
        width: w ? w : 400,
        height: h ? h : 400,
        header: false,
        save: function () {
            if (w1.iframe.contentWindow.dialogResult) {
                var d = w1.iframe.contentWindow.dialogResult();
                w1.setData(d);
            }
            else {
                dhtmlx.error("请定义子页面的[dialogResult]函数！")
            }
        }
    });
    w1.setData = function (d) {
        if (callback) callback(d);
        w1.close();
    };
    return w1;

}

dhtmlXGridObject.prototype.setRowDate = function (date) {
    var data = [];
    if (this.formatOpts && this.formatOpts.columns) {
        for (var i = 0; i < this.formatOpts.columns.length; i++) {
            var column = this.formatOpts.columns[i];
            if (column.DefaultValue) {
                data.push(column.DefaultValue);
            }
            else {
                if (date.hasOwnProperty(this.getColumnId(i)))
                    data.push(date[this.getColumnId(i)]);
                else
                    data.push("");
            }
        }
    }
    else {
        dhtmlx.alert("好像不行！");
    }
    this.addRow($.newGuid(), data);
}
dhtmlXGridObject.prototype.updateRowDate = function (r, grid, data) {
    for (key in data) {
        var cindex = grid.getColIndexById(key);
        if (cindex >= 0) {
            var col = dhtmlx.find(grid.formatOpts.columns, "Name", key);
            if (col.DataType == "date") {
                grid.cells(r, cindex).setValue(parseDate(data[key]))
            }
            else {
                grid.cells(r, cindex).setValue(data[key]);
            }
        }
    }
}
dhtmlXGridObject.prototype.insertRow = function (guid, n) {
    var data = [];
    if (this.formatOpts && this.formatOpts.columns) {
        for (var i = 0; i < this.formatOpts.columns.length; i++) {
            var column = this.formatOpts.columns[i];
            if (column.DefaultValue) {
                data.push(column.DefaultValue);
            }
            else {
                if (column.DataType == "bool") {
                    data.push(false);
                }
                else {
                    data.push('');
                }
            }
        }
    }
    else {
        dhtmlx.alert("好像不行！");
    }
    this.addRow(guid, data, n);
}
$.MyWin = function (dhxWins) {
    dhxWins.Open = function (url, postData, w, h, text) {
        if (dhxWins.window("myWin") == null) {
            dhxWins.attachViewportTo(document.body);
            if (w == -1) w = document.body.clientWidth;
            if (h == -1) h = document.body.clientHeight;
            var myWin = dhxWins.createWindow("myWin", 0, 0, w, h);
            myWin.setText(text);
            myWin.attachURL(url, null, postData);
            myWin.centerOnScreen(); //居中显示
            myWin.setModal(true); //不可编辑
            //myWin.denyMove(); //拖拽
            //myWin.denyResize(); //最大化
            //myWin.denyPark(); //最小化
            myWin.button("close").hide();
            myWin.button("park").hide();
            myWin.button("minmax").hide();
        }
        else {
            dhxWins.window("myWin").show();
        }

    }
    dhxWins.Close = function () {
        dhxWins.window("myWin").close();
    }
    return dhxWins;
}