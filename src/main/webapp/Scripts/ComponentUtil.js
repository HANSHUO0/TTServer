$(function () {
    // 设置Ajax操作的默认设置
    $.ajaxSetup({
        cache: false,
        timeout: 60000,
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            if (typeof (errorThrown) != "undefined")
                $.messager.alert("错误", "调用服务器失败。<br />" + errorThrown, 'error');
            else {
                var error = "<b style='color: #f00'>" + XMLHttpRequest.status + "  " + XMLHttpRequest.statusText + "</b>";
                var start = XMLHttpRequest.responseText.indexOf("<title>");
                var end = XMLHttpRequest.responseText.indexOf("</title>");
                if (start > 0 && end > start)
                    error += "<br /><br />" + XMLHttpRequest.responseText.substring(start + 7, end);

                $.messager.alert("错误", "调用服务器失败。<br />" + error, 'error');
            }
        }
    });

});
$.extend({
    showDialog: function (options) {
        options.modal = options.modal ? options.modal : false;
        options.resizable = options.resizable ? options.resizable : false;
        options.closable = options.closable ? options.closable : true;
        options.minimizable = options.minimizable ? options.minimizable : false;
        options.maximizable = options.maximizable ? options.maximizable : false;
        options.collapsible = options.collapsible ? options.collapsible : false;
        options.iconCls = options.iconCls ? options.iconCls : "icon-panel";
        options.cache = options.cache ? options.cache : false;
        options.inline = options.inline ? options.inline : false;
        options.draggable = options.draggable ? options.draggable : true;
        if (options.width || options.height) {
            options.fit = false;
        }
        options.width = options.width ? options.width : "auto";
        options.height = options.height ? options.height : "auto";
        options.noheader = options.noheader ? options.noheader : false;
        options.method = options.method ? options.method : "get";
        options.href = options.url ? options.url : options.href;
        options.doSize = options.doSize ? options.doSize : true;
        options.cache = options.cache ? options.cache : false;
        options.inline = options.inline ? options.inline : true;
        options.success = options.success ? options.success : null;

        var _html = '<div></div>';
        var _dialog = $(_html);
        _dialog.refresh = true;
        if (options.refresh) {
            _dialog.refresh = options.refresh;
        }
        if (options.callback) {
            _dialog.callback = options.callback;
        }
        if (!options.buttons) {
            options.buttons = [
                  {
                      text: '保存', iconCls: 'icon-save', handler: function () {
                          var frm = _dialog.find("form");
                          frm.form('submit', {
                              novalidate: true,
                              success: function (data) {
                                  data = eval('(' + data + ')');
                                  alertMessage(data, options.success);
                              },
                          });
                      }
                  },
                  {
                      text: '取消', iconCls: 'icon-cancel', handler: function () {
                          _dialog.dialog("close");
                          if (_dialog.callback) {
                              _dialog.callback()
                          }
                      }
                  }
            ];
        }
        _dialog.bind("keydown", function (event) {
            if ((event.altKey && event.keyCode == 83) || (event.keyCode == 113)) {
                _dialog.find("form").submit();
                return false;
            };
        });
        _dialog.bind("keyup", function (event) {
            if (event.keyCode == 13 || event.keyCode == 9) {
                var tabIndex = parseInt($(":focus").attr("tabindex"));
                tabIndex++;
                if ($("[tabindex=" + tabIndex + "]").length == 0) tabIndex = 0;
                $("[tabindex=" + tabIndex + "]").focus();
            }
        });
        var loadfn = options.onLoad;
        options.onLoad = function () {
            if (loadfn) loadfn();
            _dialog.find(".validatebox-text:visible").each(function (index, element) {
                $(element).attr("tabindex", index);
            });
            $("[tabindex=0]").focus();
        };
        _dialog.appendTo('body').dialog(options);
    }
});

function changeEasyUITheme(themeName) {
    var href = "/themes/" + themeName + "/easyui.css";
    $("link").each(function (index, element) {
        if (element.href.indexOf("/easyui.css") > 0) {
            $(element).attr('href', href);
        }
    });
    var $iframe = $('iframe');
    if ($iframe.length > 0) {
        for (var i = 0; i < $iframe.length; i++) {
            var ifr = $iframe[i];
            $(ifr).contents().find('link').each(function (index, element) {
                if (element.href.indexOf("/easyui.css") > 0) {
                    $(element).attr('href', href);
                }
            });
        }
    }
    $.cookie('themeName', themeName, {
        path: '/',
        expires: 7
    });
}


function alertMessage(data, fn) {
    var msg = data.Message;
    var title = data.Success ? "提示" : "错误";
    var ico = data.Success ? "info" : "error";
    if (fn) {
        $.messager.alert(title, msg, ico, fn);
    }
    else {
        $.messager.alert(title, msg, ico, function () { $("[tabindex=0]").focus(); });
    }
}




