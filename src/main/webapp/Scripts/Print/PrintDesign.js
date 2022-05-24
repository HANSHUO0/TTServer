//声明为全局变量 打印控件对象
var LODOP;

// 保存从服务器上去取得的打印代码
var MyCodes = {
    "01": "",
    "02": "",
    "03": "",
    "04": "",
    "05": "",
    "06": "",
    "07": "",
    "08": "",
    "09": "",
    "10": ""
};


// 实际打印时候，从后台取数据， 设计演示的时候 js定义一个演示数据
var PrintData = {
    "companyname": "普尔玛物流",
    "code": "S0027621605110003",
    "year": "2016",
    "month": "05",
    "day": "31",
    "origin": "杭州市",
    "destation": "武汉市",
    "businessphone": "0571-87774073",
    "queryphone": "0571-87774072",
    "sendcompany": "杭州市XXXX公司",
    "sendLinkman": "发货人",
    "sendLinkmanphone": "13500000000",
    "sendaddress": "浙江省萧山市市心南路68号",
    "receiptcompany": "武汉XXXX公司",
    "receiptLinkman": "收货人",
    "receiptLinkmanphone": "13800000000",
    "receiptaddress": "武汉市青山区现代花园1号楼",
    "goodsname": "配件1",
    "goodspack": "木箱",
    "goodspiece": "1",
    "goodsweight": "20.00",
    "goodsvolume": "30",
    "goodsname1": "配件2",
    "goodspack1": "纸箱",
    "goodspiece1": "2",
    "goodsweight1": "22.00",
    "goodsvolume1": "35",
    "goodsname2": "配件3",
    "goodspack2": "托盘",
    "goodspiece2": "3",
    "goodsweight2": "24.00",
    "goodsvolume2": "36",
    "remark": "货物备注",
    "notice": "听通知送货",
    "report": "要求回单：1份",
    "receptyear": "2016",
    "receptmonth": "06",
    "receptday": "05",
    "deliverystylesend": "√",
    "deliverystyleself": "√",
    "businesstypezero": "√",
    "businesstypecar": "√",
    "businesstypefast": "√",
    "businesstypetransit": "√",
    "businesstypestract": "√",
    "basefreight": "100.00",
    "sendfreight": "200.00",
    "takefreight": "300.00",
    "insufreight": "400.00",
    "packfreight": "500.00",
    "otherfreight": "600.00",
    "bigsumfreight": "壹仟伍佰陆拾柒元肆圆",
    "smallsumfreight": "21000.00",
    "settleprepay": "√",
    "settletopay": "√",
    "settlebackpay": "√",
    "settlemonthly": "√",
    "goodsvalues": "100000.00",
    "insure": "√",
    "uninsure": "√",
    "insurecase": "20000.00",
    "securefee": "10.00"
};

/*
 * 根据单据类型ID 从服务器取得打印代码 
 * 返回的数据类型 {"id":"1","code":"......."}
 */
function getCode(vouID) {
    if (MyCodes[vouID].length > 0) {
        return MyCodes[vouID];
    }
    var code;
    $.ajaxSetup({ async: false });
    $.ajax({
        type: 'get',
        url: 'getPrintCode.html',
        dataType: "json",
        contentType: 'application/json',
        success: function (data) {
            //将打印代码缓存 避免多次去服务器上读取
            MyCodes[data.id] = data.code;
            code = data.code;
        }
    });
    return code;
}

/*
 * 根据单据类型ID 从服务器取得打印代码 
 * 返回的数据类型 {"message":"","status":"1"}
 */
function saveCode(vouID, code) {

    $.ajaxSetup({ async: false });
    $.ajax({
        type: 'post',
        url: 'print/savecode/1.html',
        dataType: "json",
        contentType: 'application/json',
        data: { "id": vouID, "code": code },
        success: function (data) {
            MyCodes[vouID] = code;
            alert("保存成功");
        }
    });

}


/*
 *  初始化打印控件对象， 根据ID取得代码， 执行代码 
 */
function initialize(vouID) {
    LODOP = getLodop();
    var code = getCode(vouID);
    eval(code);
}

/*
 *  预览
 */
function preview(vouID) {
    initialize(vouID);
    LODOP.PREVIEW();
}

/*
 *  打印设计 ，关闭设计器后提示是否保存
 */
function design(vouID) {
    LODOP = getLodop();
    initialize(vouID);
    if (LODOP.CVERSION) CLODOP.On_Return = function (TaskID, Value) {
        //这里用来保存 设计器关闭后生成的打印代码
        if (confirm("需要保存本次设计的内容？")) {
            saveCode(vouID, Value);
        }
    };
    LODOP.PRINT_DESIGN();

}

/*
 *  打印维护
 */
function setup(vouID) {

    alert("此功能是在设计后的基础上，在客户端使用，打开维护界面后，调整位置，点‘应用’ 会保存设置到客户端电脑上。 客户端打印按此设置！");
    initialize(vouID);
    LODOP.PRINT_SETUP();
}


// 恢复缺省
function setDefault(vouID) {
    if (confirm("确定要恢复到缺失设置？继续操作后当前的用户自定义设计将恢复到默认设置！")) {
        //后台更新 用默认的设置更新用户自定义
        MyCodes[vouID] = "";
    }
}


function SaveAsFile(grid) {
    var title = grid.datagrid("options").title;
    var html = createDataGridPrintHtml(grid);
    //getExcelXML有一个JSON对象的配置，配置项看了下只有title配置，为excel文档的标题
    //var datas = grid.datagrid('getExcelXml', { title: title }); //获取datagrid数据对应的excel需要的xml格式的内容
    //用ajax发动到动态页动态写入xls文件中
    //$.fileDownload('/Download/GetFile', {
    //    httpMethod: "POST",
    //    data: { title: title, data: datas }
    //});
    
    LODOP = getLodop();
    LODOP.PRINT_INIT("");
    LODOP.ADD_PRINT_TABLE(0, 0, "RightMargin:0", "BottomMargin:0", html);
    LODOP.SET_SAVE_MODE("LINESTYLE", 1); //Excel文件的页面设置：横向打印   1-纵向,2-横向;
    LODOP.SET_SAVE_MODE("QUICK_SAVE",true);//快速生成（无表格样式,数据量较大时或许用到） 
    LODOP.SAVE_TO_FILE(title + ".xlsx");
};
function Priverw(title, html) {
    LODOP = getLodop();
    LODOP.PRINT_INIT(title);
    LODOP.SET_PRINT_PAGESIZE(0, 0, 0, 'A4');
    LODOP.ADD_PRINT_HTM("2mm", "2mm", "RightMargin:2mm", "BottomMargin:2mm", html);
    LODOP.PREVIEW();
}

function PrintDataGrid(grid) {
    var title = grid.datagrid("options").title;
    var html = createDataGridPrintHtml(grid);
    Priverw(title, html);
}
