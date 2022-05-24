/*$('.conLeft li').on('click',function(){
    $(this).addClass('bg').siblings().removeClass('bg');
    var intername=$(this).children('.liRight').children('.intername').children('.name').text();
    $('.internetName').text(intername);
    $('.newsList').html('');
});*/

var html = ''
for (let i=1;i<=75;i++){
    html+="<li><img src=\"/Chat/expression/arclist/"+i+".gif\"></li>"
}
$("#emjonslist").append(html);


/*function answers(){
    var arr=["你好","今天天气很棒啊","你吃饭了吗？","我最美我最美","我是可爱的僵小鱼","你们忍心这样子对我吗？","spring天下无敌，实习工资850","我不管，我最帅，我是你们的小可爱","段友出征，寸草不生","一入段子深似海，从此节操是路人","馒头：嗷","突然想开个车","段子界混的最惨的两个狗：拉斯，普拉达。。。"];
    var aa=Math.floor((Math.random()*arr.length));
    var answer='';
    answer+='<li>'+
                '<div class="answerHead"><img src="/Chat/img/tou.jpg"/></div>'+
                '<div class="answers"><img class="jiao" src="/Chat/img/zuo.jpg">'+arr[aa]+'</div>'+
            '</li>';
    $('.newsList').append(answer);	
    $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );
}*/


// 搜索框
function searchToggle(obj, evt){
	var container = $(obj).closest('.search-wrapper');

	if(!container.hasClass('active')){
		  container.addClass('active');
		  evt.preventDefault();
	}
	else if(container.hasClass('active') && $(obj).closest('.input-holder').length == 0){
		  container.removeClass('active');
		  // clear input
		  container.find('.search-input').val('');
		  // clear and hide result container when we press close
		  container.find('#peopleModal a ul li').fadeOut(100, function(){$(this).empty();});
	}
}

// function submitFn(obj, evt){
// 	value = $(obj).find('.search-input').val().trim();
//
// 	_html = "";
// 	if(!value.length){
// 		_html = "关键词不能为空。";
// 	} else{
// 	    $.ajax({
//             url:"/pay/contacts.action",
//             type:"GET",
//             data:{
//                 psnName:value
//             },
//             success:function (Data) {
//                 if (Data.msg === "查询失败"){
//                     _html = "没有该联系人。";
//                 }else {
//                     _html = "<a href=\"javascript:;\" class=\"aui-list-item\">";
//                     _html += "<ul>";
//                     $.each(Data.data,function (i,n){
//                        _html += "<li>";
//                        _html += "<div class=\"liLeft\"><img\n" + "src=\"/Chat/index_files/20170926103645_04.jpg\"></div>";
//                        _html += "<div class=\"liRight\">";
//                         _html += "<span class=\"intername\">"+n.psnName+"</span>";
//                         _html += "<span class=\"infor\"></span>";
//                         _html += "</div>";
//                         _html += "</li>";
//                     });
//                     _html += "</ul>";
//                     _html += "</a>";
//                 }
//             }
//         })
// 	}
//
// 	$('.tab-item').html(_html)
// /*	$(obj).find('.result-container').html( _html );
// 	$(obj).find('.result-container').fadeIn(100);*/
//
// 	evt.preventDefault();
// }

// 菜单选项卡
!function(window) {
    "use strict";

    var doc = window.document
      , ydui = {};

    $(window).on('load', function() {});

    var util = ydui.util = {

        parseOptions: function(string) {},

        pageScroll: function() {}(),

        localStorage: function() {}(),

        sessionStorage: function() {}(),

        serialize: function(value) {},

        deserialize: function(value) {}
    };

    function storage(ls) {}

    $.fn.emulateTransitionEnd = function(duration) {}
    ;

    if (typeof define === 'function') {
        define(ydui);
    } else {
        window.YDUI = ydui;
    }

}(window);

!function(window) {
    "use strict";

    function Tab(element, options) {
        this.$element = $(element);
        this.options = $.extend({}, Tab.DEFAULTS, options || {});
        this.init();
        this.bindEvent();
        this.transitioning = false;
    }

    Tab.TRANSITION_DURATION = 150;

    Tab.DEFAULTS = {
        nav: '.tab-nav-item',
        panel: '.tab-panel-item',
        activeClass: 'tab-active'
    };

    Tab.prototype.init = function() {
        var _this = this
          , $element = _this.$element;

        _this.$nav = $element.find(_this.options.nav);
        _this.$panel = $element.find(_this.options.panel);
    }
    ;

    Tab.prototype.bindEvent = function() {
        var _this = this;
        _this.$nav.each(function(e) {
            $(this).on('click.ydui.tab', function() {
                _this.open(e);
            });
        });
    }
    ;

    Tab.prototype.open = function(index) {
        var _this = this;

        index = typeof index == 'number' ? index : _this.$nav.filter(index).index();

        var $curNav = _this.$nav.eq(index);

        _this.active($curNav, _this.$nav);

        _this.active(_this.$panel.eq(index), _this.$panel, function() {
            $curNav.trigger({
                type: 'opened.ydui.tab',
                index: index
            });
            _this.transitioning = false;
        });
    }
    ;

    Tab.prototype.active = function($element, $container, callback) {
        var _this = this
          , activeClass = _this.options.activeClass;

        var $avtive = $container.filter('.' + activeClass);

        function next() {
            typeof callback == 'function' && callback();
        }

        $element.one('webkitTransitionEnd', next).emulateTransitionEnd(Tab.TRANSITION_DURATION);

        $avtive.removeClass(activeClass);
        $element.addClass(activeClass);
    }
    ;

    function Plugin(option) {
        var args = Array.prototype.slice.call(arguments, 1);

        return this.each(function() {
            var target = this
              , $this = $(target)
              , tab = $this.data('ydui.tab');

            if (!tab) {
                $this.data('ydui.tab', (tab = new Tab(target,option)));
            }

            if (typeof option == 'string') {
                tab[option] && tab[option].apply(tab, args);
            }
        });
    }

    $(window).on('load.ydui.tab', function() {
        $('[data-ydui-tab]').each(function() {
            var $this = $(this);
            $this.tab(window.YDUI.util.parseOptions($this.data('ydui-tab')));
        });
    });

    $.fn.tab = Plugin;

}(window);