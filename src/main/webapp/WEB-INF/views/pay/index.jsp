<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>页面</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1">

    <link rel="stylesheet" type="text/css" href="/Chat/css/index.css">
    <link rel="stylesheet" type="text/css" href="/Chat/css/modalBox.css">

    <script type="text/javascript" src="${pageContext.request.contextPath}/layuiadmin/layui/layui.js"></script>

</head>
<div id="window-img" style="display: none;z-index: 100;width: 100%;max-height: 100%;"></div>
<body>
<iframe id="firefllow"  src="${pageContext.request.contextPath }/pay/fireworks.action" scrolling="no" width="100%" height="99%" frameborder="0">
</iframe>

<!-- 模态框 -->
<div id="myModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2></h2>
            <span id="closeBtn" class="close">×</span>
        </div>
        <div class="modal-body">
            <ul class="chatMessages"></ul>
        </div>

    </div>
</div>

<%--检索联系人--%>
<div id="peopleModal" class="modal">
    <div class="modal-content1">
        <div class="modal-header">
            <h2></h2>
            <span id="closeBtn1" class="close">X</span>
        </div>
        <div class="modal-body">
            <ul class="result-containe"></ul>
        </div>

    </div>
</div>

<div class="qqBox">
    <!-- xx -->
    <div class="BoxHead">
        <!-- 搜索 -->
        <form style="height: 130px;" onsubmit="submitFn(this, event);">
            <div class="search-wrapper">
                <div class="input-holder">
                    <input type="text" class="search-input" placeholder="请输入关键词" />
                    <button class="search-icon" onClick="searchToggle(this, event)"><span></span></button>
                </div>
                <span class="close" onClick="searchToggle(this, event);"></span>

            </div>
        </form>
        <div class="internetName"><input type="hidden" id="headId" value=""></div>
        <div class="tubiao">
            <span><img style="width: 40px; margin: 5px 5px;cursor: pointer;" onclick="closeFireFlower()" src="/Chat/images/firefllow.png" title="特效开/关"></span>

<%--            <span><img style="width: 20px; margin: 15px 5px;" src="/Chat/iocn/iocnqx.png" alt=""></span>--%>
        </div>
    </div>

    <!-- 好友聊天类容 -->
    <div class="context">

        <div class="conLeft">
            <div class="shouBox">
                <!-- 菜单分组 -->
                <div class="aui-flexView">

                    <div class="aui-scrollView">
                        <div class="aui-tab-box" data-ydui-tab>
                            <div class="tab-nav">
                                <div class="tab-nav-item tab-active">
                                    <a id="mesMenu" href="javascript:;">消息</a>
                                </div>
                                <C:if test="${empty CustomerPeopleList}">
                                    <div class="tab-nav-item">
                                        <a href="javascript:;">技术</a>
                                    </div>
                                    <div class="tab-nav-item">
                                        <a href="javascript:;">同事</a>
                                    </div>
                                </C:if>
                                <C:if test="${!empty CustomerPeopleList}">
                                    <div class="tab-nav-item">
                                        <a href="javascript:;">同事</a>
                                    </div>
                                    <div class="tab-nav-item">
                                        <a href="javascript:;">客户</a>
                                    </div>
                                </C:if>
                            </div>

                            <div class="tab-panel">

                                <!--消息-->
                                <div class="tab-panel-item tab-active">
                                    <div class="tab-item">

                                        <a href="javascript:;" class="aui-list-item">
                                            <ul id="message">
                                                <C:forEach items="${message}" var="n">
                                                    <li onclick='lookMessage(this)'>
                                                        <div class="liLeft"><img
                                                            src="/Chat/index_files/20170926103645_21.jpg">
                                                            <span class="boxFont"></span>
                                                        </div>
                                                        <div class="liRight">
                                                            <span class="intername"><i class="name">${n.userName}<C:if test="${!empty n.cusName}">(${n.cusName})</C:if></i><p>${n.lastTime}</p></span>
                                                            <input type="hidden" class="interid" value="${n.userID}">
                                                            <input type="hidden" class="haveLable" value="${n.isHas}">
                                                            <input type="hidden" class="job" value="" >
                                                            <span class="infor">${n.content.replace("<br/>","")}</span>
                                                        </div>


                                                    </li>
                                                </C:forEach>
                                            </ul>

                                        </a>

                                    </div>
                                </div>

                                <!--同事列表-->
                                <div class="tab-panel-item">
                                    <div class="tab-item">
                                <%-- <hr style="color: #CF1900">--%>
                                        <a href="javascript:;" class="aui-list-item">
                                            <ul id="Colleague">
                                                <C:if test="${!empty FriendsList}">
                                                    <C:forEach items="${FriendsList}" var="FL">
                                                    <li onclick="clickToMessage(this)">
                                                        <div class="liLeft">
                                                            <img src="/Chat/index_files/20170926103645_04.jpg">

                                                        </div>
                                                        <div class="liRight">

                                                            <span class="intername"><i class="name">${FL.psnName}</i></span>
                                                            <input type="hidden" class="interid" value="${FL.ID}">
                                                            <input type="hidden" class="haveLable" value="">
                                                            <input type="hidden" class="job" value="${FL.depID}" >
                                                            <span class="infor"> </span>
                                                        </div>

                                                    </li>
                                                </C:forEach>
                                                </C:if>

                                            </ul>
                                        </a>

                                    </div>
                                </div>

                                <!--客户-->
                                <div class="tab-panel-item"`>
                                    <div class="tab-item" id="customer">
                                        <a href="javascript:;" class="aui-list-item">
                                            <ul>
                                                <C:if test="${!empty CustomerPeopleList}">
                                                <C:forEach items="${CustomerPeopleList}" var="Cus">
                                                    <li onclick="clickToMessage(this)">
                                                        <div class="liLeft"><img
                                                                src="/Chat/index_files/20170926103645_04.jpg"></div>
                                                        <div class="liRight">
                                                            <span class="intername"><i class="name">${Cus.userName}(${Cus.cName})</i></span>
                                                            <input type="hidden" class="interid" value="${Cus.uID}">
                                                            <input type="hidden" class="haveLable" value="">
                                                            <input type="hidden" class="job" value="" >
                                                            <span class="infor"> </span>
                                                        </div>
                                                    </li>
                                                </C:forEach>
                                                </C:if>

                                                <C:if test="${!empty DepartmentPeople}">
                                                    <C:forEach items="${DepartmentPeople}" var="dep">
                                                        <li onclick="clickToMessage(this)">
                                                            <div class="liLeft"><img
                                                                    src="/Chat/index_files/20170926103645_04.jpg"></div>
                                                            <div class="liRight">
                                                                <span class="intername"><i class="name">${dep.psnName}(${dep.cName})</i></span>
                                                                <input type="hidden" class="interid" value="${dep.userID}">
                                                                <input type="hidden" class="haveLable" value="">
                                                                <input type="hidden" class="job" value="" >
                                                                <span class="infor"> </span>
                                                            </div>
                                                        </li>
                                                    </C:forEach>
                                                </C:if>
                                            </ul>
                                        </a>

                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>


            </div>

        </div>


        <div class="conRight" >

            <div class="Righthead">
                <%-- <div class="headName">赵鹏</div>
            <div class="headConfig">
                <ul>
                    <li><img src="./index_files/20170926103645_06.jpg"></li>
                    <li><img src="./index_files/20170926103645_08.jpg"></li>
                    <li><img src="./index_files/20170926103645_10.jpg"></li>
                    <li><img src="./index_files/20170926103645_12.jpg"></li>
                </ul>
            </div>--%>
            </div>
            <!-- 显示聊天内容 -->
            <div class="RightCont">
                <ul class="newsList">
                   <%-- <li>
                        <div class="nesHead"><img src="/Chat/index_files/6.jpg"></div>
                        <div class="news"><img class="jiao" src="/Chat/img/you.jpg"><img class="Expr"
                                                                                     src="/Chat/index_files/em_40.jpg"></div>
                    </li>--%>
                </ul>
            </div>

            <div class="RightFoot" hidden>
                <div class="emjon" style="display: none;">
                    <ul id="emjonslist">
<%--                        <li><img src="/Chat/expression/arclist/"></li>--%>
                    </ul>
                </div>
                <div class="footTop">
                    <%--<a><input type="file" name="file"></a>--%>
                    <a id="intro" href="javaScript:0" onclick="clickIntro()" ><img style="float: right;padding-right: 10px" src="/Chat/img/intro.png" height="24" title="简介"></a>

                    <a id="triggerBtn" href="javaScript:0"><img style="float: right;padding-right: 10px" src="/Chat/images/chatMessages.png" height="24" title="聊天记录"></a>

                    <ul>
                        <!-- <li><img src="./index_files/20170926103645_31.jpg"></li> -->
                        <li class="ExP"><img src="/Chat/index_files/20170926103645_33.jpg" style="cursor: pointer;"></li>
                        <li style="background: url('/Chat/index_files/20170926103645_43.jpg') no-repeat" title="上传图片">
                            <input style="opacity: 0;" accept="image/jpg,image/gif,image/jpeg,image/png,image/svg" type="file" id="picture">
                        </li>
                       <%--  <li><img src="./index_files/20170926103645_35.jpg"></li>
                    <li><img src="./index_files/20170926103645_37.jpg"></li>
                     语言   <li><img src="/Chat/index_files/20170926103645_39.jpg"></li>
                         <li><img src="./index_files/20170926103645_41.jpg" alt=""></li>
                     文件   <li><img src="/Chat/index_files/20170926103645_43.jpg"></li>
                         <li><img src="./index_files/20170926103645_45.jpg"></li>--%>
                        <li></li>
                    </ul>
                </div>
                <div class="inputBox">
                        <textarea id="dope" placeholder="请输入消息..." style="width: 99%;height: 125px; border: none;outline: none; resize:none;text-indent: 2em;"
                                  name="" rows="" cols=""></textarea>
                    <button class="sendBtn" onclick="send()">发送(S)</button>
                </div>
            </div>
        </div>


        <div class="right" hidden>
           <%-- <div class="up card">
                &nbsp;&nbsp;客户名：<p>张三</p><br></p>
                &nbsp;&nbsp;客户信息：<p>滨江江南大道568号HK阿斯的骄傲开了阿大声道</p><br></p>
                &nbsp;&nbsp;客户需求：<p>服务器无法访问,二位若翁二娃任务 温热无热无绕弯儿翁绕弯儿翁热无绕弯儿</p><br><br>
            </div>
            <hr color="#ECECEC">
            <div class="down card">
                &nbsp;&nbsp;同事名：<p>小王</p><br></p>
                &nbsp;&nbsp;所属部门：<p>OA部</p><br></p>
            </div>--%>
            <div class="up card" hidden>
                <h1>名片</h1>
                <img src="/Chat/images/people.jpeg"><br><br>
                &nbsp;&nbsp;姓 &nbsp;&nbsp;名：<p id="ColleagueName"></p><br><br>
                &nbsp;&nbsp;部 &nbsp;&nbsp;门：<p id="ColleagueDept"></p><br><br>
                &nbsp;&nbsp;职 &nbsp;&nbsp;位：<p id="ColleaguePosition"></p><br><br>
                &nbsp;&nbsp;电 &nbsp;&nbsp;话：<p id="ColleaguePhone"></p><br><br>
                &nbsp;&nbsp;手 &nbsp;&nbsp;机：<p id="ColleagueMobilePhone"></p><br><br>
                &nbsp;&nbsp;E-mail：<p id="ColleagueEmail"></p><br><br>
                &nbsp;&nbsp;地 &nbsp;&nbsp;址：<p id="ColleagueAddress"></p><br><br>
            </div>
            <div class="mine" hidden>
                <i id="mineName" style="float:right;margin:10% 30% 0 0;text-align: center;font-size: 25px;font-family: 黑体;"></i>
                <img src="/Chat/img/6.jpg" width="80" height="80" style="border-radius: 50%;"><br><br><br>
                公 &nbsp;&nbsp;司：<p id="company"></p><br><br>
                部 &nbsp;&nbsp;门：<p id="dept"></p><br><br>
                电 &nbsp;&nbsp;话：<p id="phone"></p><br><br>
                手 &nbsp;&nbsp;机：<p id="mobilePhone"></p><br><br>
                E-mail：<p id="email"></p><br>
            </div>
           <div class="customer" hidden>
               <i style="font-size: 25px;font-family: 黑体;">客户信息：</i>   <input style="float: right;margin-right: 10%;color: #009f95;border:none;background: none;font-size: 20px;cursor: pointer;" type="button" value="编辑" id="editCustomer" onclick="editCustomerMessage()"><br><br>
               公司名称：<p id="cusCompany"></p><br><br>
               地&nbsp;&nbsp;址：<p id="cusAddress"></p><br><br>
               使用产品：<p id="cusUseOfTheProduct"></p><br><br>
               服务到期：<p id="cusServiceDue" style="display: block"></p><br>
               客户名：<p id="cusID"></p><br><br>
               电&nbsp;&nbsp;话：<input style="margin-left: 48px;border:none;color: #e64949;font-family: 楷体;font-size: 20px;" type="text" id="cusPhone" value="" readonly><br>
           </div>
        </div>
    </div>

</div>
<script type="text/javascript" src="/Chat/js/modalBoxPeople.js"></script>
<script type="text/javascript" src="/Chat/js/modalBox.js"></script>
<script type="text/javascript" src="/Chat/js/jquery-1.12.4.js"></script>
<script type="text/javascript" src="/Chat/js/jquery.min.js"></script>
<script type="text/javascript" src="/Chat/js/index.js"></script>
<script type="text/javascript" src="/Chat/js/kcommon.js"></script>
<script type="text/javascript" src="/layuiadmin/layui/layui.all.js"></script>
<script type="text/javascript" src="/layuiadmin/layui/layui.js"></script>
<script type="text/javascript">

    //获取当前时间
    let yy = new Date().getFullYear();
    let mm = new Date().getMonth()+1;
    let dd = new Date().getDate();
    let hh = new Date().getHours();
    let mf = new Date().getMinutes()<10 ? '0'+new Date().getMinutes() : new Date().getMinutes();
    let ss = new Date().getSeconds()<10 ? '0'+new Date().getSeconds() : new Date().getSeconds();

    var websocket = null;
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
        //2,123  2登录用户标识,  123会话id
        //usr获取session的用户标识
        // $('body').append(1111)
        var url = "ws://" + window.location.host + "/webSocketOneToOne/" + window.top.getID() + ",123";
        websocket = new WebSocket(url);
    } else {
        alert('当前浏览器 Not support websocket')
    }

    $(function (){
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/department/seldepartment.action',
            data:{groupID:window.top.getGroupID()},
            async:false,
            success: function(res){
                if(res.data[0].listData){
                    $.each($.parseJSON(res.data[0].showData).item,function (i,n){
                        $.each(n.item,function (i,n){
                            // console.log($("#Colleague :input[value="+n.id+"]").parent('.liRight').parent('li').html());
                            if (n.open == 1){
                                $.each(n.item,function (i,n){
                                    $("#Colleague :input[value="+n.id+"]").parent('.liRight').parent('li').find('.job').val(n.text.substring(n.text.lastIndexOf("]")+1));
                                    // console.log(n.id+" "+n.text.substring(n.text.lastIndexOf("]")+1))
                                })
                            }
                          // console.log(n.id+" "+n.text.substring(n.text.lastIndexOf("]")+1))
                            $("#Colleague :input[value="+n.id+"]").parent('.liRight').parent('li').find('.job').val(n.text.substring(n.text.lastIndexOf("]")+1));

                        })
                    })
                }
            }
        });

        {
            $("#dept").text($("#Colleague :input[value="+window.top.getID()+"]").parent('.liRight').parent('li').find('.job').val());
            $("#mineName").text($("#Colleague :input[value="+window.top.getID()+"]").parent('.liRight').parent('li').find('.job').val());
            $("#company").text(window.top.getName);
            var user = window.top.getUser();
            $("#phone").text(user.phone)
            $("#mobilePhone").text(user.sosPhone)
            $("#email").text(user.email)
        }


        var messages='';
      <C:if test="${!empty message}">
            <%--console.log(${message})--%>
            $.each(${message},function (i,n){
                // console.log(n)
                var id1 = n.userID;
                $("#message :input[value="+id1+"]").parent('.liRight').parent('li').find('.job').val($("#Colleague :input[value="+id1+"]").parent('.liRight').parent('li').find('.job').val())
                if(n.count!=0){
                    $("#message :input[value="+id1+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').html(n.count)
                }
               /* if (n.INewType == 1 && n.receiverID == window.top.getID()){
                  $("#message :input[value="+id1+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').html(n.count)
                } else if (id1 == window.top.getID()){
                    if($("#message :input[value="+n.receiverID+"]").length >= 1){
                        // $("#message :input[value="+n.receiverID+"]").parent(".liRight").parent('li').find('.infor').text(n.news)
                    }else {
                        $.ajax({
                            url: '/user/seluser.action',
                            async: false,
                            type: "POST",
                            data: {ID: n.receiverID},
                            success: function (res) {
                                // console.log(res.data);
                                // $("#message :input[value="+n.receiverID+"]").parent(".liRight").parent('li').find(".name").text(res.data[0].psnName);
                                $("#message").append(
                                    '<li onclick="lookMessage(this)">' +
                                    '<div class="liLeft"><img src="/Chat/index_files/20170926103645_21.jpg"></div><span class="boxFont"></span>' +
                                    '<div class="liRight">' +
                                    '<span class="intername"><i class="name">' + res.data[0].psnName + '</i>' + res.data[0].createDate + '</span>' +
                                    '<input type="hidden" class="interid" value="' + n.receiverID + '">' +
                                    '<span class="infor">' + n.news + '</span>' +
                                    '</div>' +
                                    '</li>'
                                );
                            }
                        });
                    }
                }*/
        });
        </C:if>

        //回车
        $("#dope").keydown( function(event){
            //var msgInput=$(this).val()
            //兼容Chrome和Firefox
            event=(event)?event:((window.event)?window.event:"");
            var keyCode=event.keyCode?event.keyCode:(event.which?event.which:event.charCode);
            var altKey = event.ctrlKey || event.metaKey;
            if(keyCode == 13 && altKey){ //ctrl+enter换行
                var newDope=$(this).val()+"\n";// 获取textarea数据进行 换行
                $(this).val(newDope);
                // console.log("换行")
            }else if(keyCode==13){ //enter发送
                $(".sendBtn").click();
                event.preventDefault();//禁止回车的默认换行
            }

        });


        //表情
        $('.ExP').on('mouseenter',function(){
            $('.emjon').show();
        })
        $('.emjon').on('mouseleave',function(){
            $('.emjon').hide();
        })
        $('.emjon li').on('click',function(){
            var imgSrc=$(this).children('img').attr('src');
            var str="";
            str+='<li>'+
                '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">'+hh+":"+mf+'</span></div>'+
                '<div class="nesHead"><img src="/Chat/img/6.jpg"/></div>'+
                '<div class="news"><img class="jiao" src="/Chat/img/you.jpg"><img class="Expr" src="'+imgSrc+'"></div>'+
                '</li>';
            $('.newsList').append(str);
            str='<img class="Expr" src="'+imgSrc+'">';
            var usr = $(".bg").children('.liRight').children('.interid').val();
            var isHas = $(".bg .haveLable").val();
            websocket.send(JSON.stringify({'isHas': isHas, 'message': str, 'role': usr, 'socketId': 123}));
            if (isHas != '1') {
                $(".bg .haveLable").val('1');
            }
            $("#message :input[value="+usr+"]").parent(".liRight").parent('li').find('.intername').html("<i class=\"name\">"+$(".internetName").text()+"</i>"+hh+":"+mf);
            $("#message :input[value="+usr+"]").parent(".liRight").parent('li').find('.infor').html('<img class="Expr" src="'+imgSrc+'">');
            $('.emjon').hide();
            $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );
        });

        //去除自己
        $(":input[value="+window.top.getID()+"]").parent(".liRight").parent('li').remove();

        //图片
        $('#picture').bind("change", function () {
            var file = this.files && this.files[0];
            if (file) {
                console.log(file)
                //判断文件格式
                var index= file.name.lastIndexOf(".");//获取最后一个.的位置
                var ext = file.name.substr(index+1);//获取后缀
                var pattern = /^(jpg|jpeg|png|gif|svg)$/;
                if(!pattern.test(ext))
                {
                    layui.use(['table','form'], function() {
                        layer.msg('文件格式不支持(非图片)！！',{icon:2,time: 1500},function (){$('#picture').val("")});
                    });
                    return false;
                }else {
                    chooseImg(file)
                }

            }
        });


    });


    //连接发生错误的回调方法
    websocket.onerror = function() {
        setMessageInnerHTML("WebSocket连接发生错误");
    };
    //连接成功建立的回调方法
    websocket.onopen = function() {
        setMessageInnerHTML("WebSocket连接成功");
    }
    //接收到消息的回调方法
    websocket.onmessage = function(event) {
        var replace = event.data.indexOf("说");
        var id = event.data.substring(0,replace);
        var news = event.data.substring(replace+1);
       /* if ( news.indexOf('<img') != -1 ){
            news = '图片';
        }*/
        // console.log("id是"+id+" \n消息是"+news);


        if (id === $(".bg").children(".liRight").children(".interid").val()) {
            var answer = '';

            answer += '<li>' +
                '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">'+hh+":"+mf+'</span></div>'+
                '<div class="answerHead"><img src="/Chat/img/tou.jpg"/></div>' +
                '<div class="answers"><img class="jiao" src="/Chat/img/zuo.jpg">' + news + '</div>' +
                '</li>';
            $('.newsList').append(answer);
            $("#message :input[value="+id+"]").parent(".liRight").parent('li').find('.intername').html("<i class=\"name\">"+$(".bg").children('.liRight').find('.name').text()+"</i><p>"+hh+":"+mf+"</p>");
            if (news.indexOf("data:image") != -1){
                news='<img onclick="clickPic(this)" style="height: 60px" src="'+news+'">';
                $("#message :input[value="+id+"]").parent(".liRight").parent('li').find('.infor').html(news)
            }else {
                $("#message :input[value="+id+"]").parent(".liRight").parent('li').find('.infor').html(news.replace("<br/>",""))
            }
            $("#message :input[value="+id+"]").parent(".liRight").parent('li').find('.haveLable').val('1');
            $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight);
            window.top.setNews(1);
            //刷新已读
            $.ajax({
                url:'/pay/updateHaveRead.action',
                type:"POST",
                data:{
                    userID:id,
                    receiverID:window.top.getID()
                }
            })
        }else {
            // console.log($("#message :input[value="+id+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').text());
            if ($("#message :input[value="+id+"]").length == 1){
                if ($("#message :input[value="+id+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').text() === 99){
                    $("#message :input[value="+id+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').text("99+");
                }
                $("#message :input[value="+id+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').text(
                    Number($("#message :input[value="+id+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').text()) + 1
                );
                if (news.indexOf("data:image") != -1){
                    news='<img onclick="clickPic(this);" style="height: 60px" src="'+news+'">';
                    $("#message :input[value="+id+"]").parent(".liRight").parent('li').find('.infor').html(news)
                }else {
                    $("#message :input[value=" + id + "]").parent(".liRight").parent('li').find('.infor').html(news.replace("<br/>",""));
                }
                $("#message :input[value="+id+"]").parent(".liRight").parent('li').find('.haveLable').val('1');
            }else {
                $.ajax({
                    url:'/user/seluser.action',
                    type:"POST",
                    data: {ID: id},
                    success:function (res){
                        // console.log(res.data)
                        if (news.indexOf("data:image") != -1){
                            news='<img onclick="clickPic(this)" style="height: 60px" src="'+news+'">';
                            $("#message").append(
                                '<li onclick="lookMessage(this)">'+
                                '<div class="liLeft"><img src="/Chat/index_files/20170926103645_21.jpg"></div><span class="boxFont"></span>'+
                                '<div class="liRight">'+
                                '<span class="intername"><i class="name">'+res.data[0].psnName+'</i><p>'+hh+':'+mf+'</p></span>'+
                                '<input type="hidden" class="interid" value="'+id+'">'+
                                '<input type="hidden" class="haveLable" value="1">' +
                                '<input type="hidden" class="job" value="'+res.data[0].depID+'">' +
                                '<span class="infor">'+news+'</span>'+
                                '</div>'+
                                '</li>'
                            );
                        }else {
                            $("#message").append(
                                '<li onclick="lookMessage(this)">'+
                                '<div class="liLeft"><img src="/Chat/index_files/20170926103645_21.jpg"></div><span class="boxFont"></span>'+
                                '<div class="liRight">'+
                                '<span class="intername"><i class="name">'+res.data[0].psnName+'</i><p>'+hh+':'+mf+'</p></span>'+
                                '<input type="hidden" class="interid" value="'+id+'">'+
                                '<input type="hidden" class="haveLable" value="1">' +
                                '<input type="hidden" class="job" value="'+res.data[0].depID+'">' +
                                '<span class="infor">'+news.replace("<br/>","")+'</span>'+
                                '</div>'+
                                '</li>'
                            );
                        }

                    }

                })
                $("#message :input[value="+id+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').text(1)

                // $("#message :input[value="+id+"]").parent(".liRight").parent('li').children('.liLeft').children('.boxFont').text('1');

            }

            window.top.setNews(1)
        }
        // console.log("回调信息",event.data)
        setMessageInnerHTML(event.data);
    }
    //连接关闭的回调方法
    websocket.onclose = function() {
        setMessageInnerHTML("WebSocket连接关闭");
    }
    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function() {
        closeWebSocket();
    }

    //将消息显示在网页上
    function setMessageInnerHTML(innerHTML) {
       console.log(innerHTML);
    }
    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    };
    //发送消息
    function send() {
        //聊天用户ID
        var usr = $(".bg").children('.liRight').children('.interid').val();
        var isHas = $(".bg .haveLable").val();
        var newss = $('#dope').val().trim();
        var news=$('#dope').val().trim().replace(/\n/g,"<br/>");

        if(news == "" || news==null){
            layui.use(['table','form'], function() {
                layer.msg('输入为空,请重新输入！！',{icon:2,time: 1500},function (){$('#dope').val("")});
            })
        }else{

            $('#dope').val('');
            var str='';
            str+='<li>'+
                '<div style="text-align: center;margin-bottom: 5px"><span class="talkTime">'+hh+':'+mf+'</span></div>'+
                '<div class="nesHead"><img src="/Chat/img/6.jpg"/></div>'+
                '<div class="news"><img class="jiao" src="/Chat/img/you.jpg">'+news+'</div>'+
                '</li>';
            if ($(".bg .haveLable").val() != '1') {
                $(".bg .haveLable").val('1');
            }
            $("#message :input[value="+usr+"]").parent(".liRight").parent('li').find('.intername').html("<i class=\"name\">"+$(".internetName").text()+"</i><p>"+hh+":"+mf+"</p>");
            $('.newsList').append(str);
            $('.conLeft').find('li .bg').children('.liRight').children('.infor').text(newss);
            $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );
            window.top.showUnRead();
            if (usr != null && usr != '') {
                websocket.send(JSON.stringify({'isHas': isHas, 'message': news, 'role': usr, 'socketId': 123}));
            }
        }
    };

    //发送图片
    function chooseImg(file){
        //聊天用户ID
        var usr = $(".bg").children('.liRight').children('.interid').val();
        var isHas = $(".bg .haveLable").val();
        var fileReader = new FileReader();
        fileReader.readAsDataURL(file)
        fileReader.onload = function (e) {
            var str="";
            str+='<li>'+
                '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">'+hh+":"+mf+'</span></div>'+
                '<div class="nesHead"><img src="/Chat/img/6.jpg"/></div>'+
                '<div class="news"><img class="jiao" src="/Chat/img/you.jpg"><img onclick="clickPic(this)" style="height: 60px;" src="'+e.target.result+'"></div>'+
                '</li>';
            $('.newsList').append(str);
            $("#message :input[value="+usr+"]").parent(".liRight").parent('li').find('.intername').html("<i class=\"name\">"+$(".internetName").text()+"</i>"+hh+":"+mf);
            $('.conLeft').find('li .bg').children('.liRight').children('.infor').text("图片");
            $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );

            if ($(".bg .haveLable").val() != '1') {
                $(".bg .haveLable").val('1');
            }

            var s = JSON.stringify({
                'type': 1,
                'message': e.target.result,
                'isHas': isHas,
                'role': usr,
                'socketId': 123
            });
            websocket.send(s);
        }


    };

    function clickPic(obj){
        // kvfKit.previewImg('window-img', $(obj).attr("src"),$(obj).width,$(obj).height);
       /* var windowHeight = window.screen.height;//屏幕分辨率高度
        var widthWeight = window.screen.width;
        var imgBigH = windowHeight-400;
        var imgBigW= widthWeight-300;

        var img = new Image();
        img.src = $(obj).attr("src");
        var height = img.height; // 原图片大小
        var width = img.width; //原图片大小
        var scaleWH = width / height;

        var bigH = height;
        var bigW = width;
        console.log("imgBigH"+imgBigH+"imgBigW"+imgBigW+"bigH"+bigH+"bigW"+bigW)
        if (bigH > imgBigH) {
            bigH = imgBigH;
            bigW = scaleWH * bigH;
            if (bigW > imgBigW) {
                bigW = imgBigW;
                bigH = bigW / scaleWH;
            }
        }else {
            if (bigW > imgBigW) {
                bigW = imgBigW;
                bigH = bigW / scaleWH;
            }
        }

        var imgHtml = "<img src='"+$(obj).attr("src")+"' style='width: "+bigW+"px;height: "+bigH+"px' />"
        //弹出层
        layer.open({
            type: 1,
            shade: 0.8,
            offset: 'auto',
            area: [bigW + 'px',bigH+'px'], //原图显示 // area: [500 + 'px', 550 + 'px']
            shadeClose: true,
            scrollbar: false,
            title: false, //不显示标题
            content: $("#window-img").html(imgHtml), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
            cancel: function () {
                //layer.msg('捕获就是从页面已经存在的元素上，包裹layer的结构', { time: 5000, icon: 6 });
                $("#window-img").css('display', 'none')
            },
            end: function() {
                $("#window-img").css('display', 'none');
            }
        });*/
        var defult = {};
        var img = new Image();
        img.src = $(obj).attr("src");
        img.onload = function () {
            var max_height = window.screen.height;;
            var max_width = window.screen.width;
            var rate1 = max_height/img.height;
            var rate2 = max_width/img.width;
            var rate3 = 1;
            var rate = Math.min(rate1,rate2,rate3);
            defult.height=img.height * rate;
            defult.width = img.width * rate;
            console.log("max_height:"+max_height+"  max_width:"+max_width+"  defult.height:"+defult.height+" defult.width:"+defult.width)
            var imghtml="<img src='"+$(obj).attr("src")+"' width='"+defult.width+"px' height='"+defult.height+"px'>"
            layer.open({
                type:1,
                shade: 0.8,
                offset: 'auto',
                area: [defult.width + 'px',defult.height + 50 +'px'],
                shadeClose:true,
                scrollbar: false,
                title: false, //不显示标题
                content: $("#window-img").html(imghtml), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
                cancel: function () {
                    //layer.msg('捕获就是从页面已经存在的元素上，包裹layer的结构', { time: 5000, icon: 6 });
                    $("#window-img").css('display', 'none')
                },
                end: function() {
                    $("#window-img").css('display', 'none');
                }
             });
        }

    }


    //搜索联系人
    function submitFn(obj,evt){
        console.log("个人ID为"+window.top.getID())
        var userId=window.top.getID();
        var value = $(obj).find('.search-input').val().trim();
        // $(obj).find('.result-container ul').html('');
        var _html='';
        if(!value.length){
            _html = "<li style='padding-top: 10px'>关键词不能为空。</li>";
        } else{
            console.log("个人ID为"+window.top.getID())
            $.ajax({
                url:"/pay/contacts.action",
                type:"GET",
                async:false,
                data:{
                    ID:window.top.getID(),
                    psnName:value
                },
                success:function (Data) {
                    if (Data.msg === "查询失败"){
                        _html = "<li style='padding-top: 10px'>没有该联系人。</li>";
                    }else {
                        console.log(Data)
                        if (null != Data.userList) {
                            $.each(Data.userList, function (i, n) {
                                if (n.ID === userId){}else {
                                    _html += "<li onclick='clickPeople(this)'>";
                                    _html += "<div class=\"liLeft\"><img src=\"/Chat/index_files/20170926103645_21.jpg\"></div><span class=\"boxFont\"></span>";
                                    _html += "<div class=\"liRight\">";
                                    _html += "<span class=\"intername\"><i class=\"name\">" + n.psnName + "</i><p>" + hh + ":" + mf + "</p></span>";
                                    _html += "<input type=\"hidden\" class=\"interid\" value=\"" + n.ID + "\">";
                                    _html += "<input type=\"hidden\" class=\"haveLable\" value=\"\">";
                                    _html += "<input type=\"hidden\" class=\"job\" value=\"" + n.job + "\">";
                                    _html += "<span class=\"infor\"></span>";
                                    _html += "</div>";
                                    _html += "</li>";
                                }
                            });
                        }

                        if (null != Data.customerPeopleList) {
                            $.each(Data.customerPeopleList, function (i, n) {
                                _html += "<li onclick='clickPeople(this)'>";
                                _html += "<div class=\"liLeft\"><img src=\"/Chat/index_files/20170926103645_21.jpg\"></div><span class=\"boxFont\"></span>";
                                _html += "<div class=\"liRight\">";
                                _html += "<span class=\"intername\"><i class=\"name\">" + n.cName + "</i><p>" + hh + ":" + mf + "</p></span>";
                                _html += "<input type=\"hidden\" class=\"interid\" value=\"" + n.uID + "\">";
                                _html += "<input type=\"hidden\" class=\"haveLable\" value=\"\">";
                                _html += "<input type=\"hidden\" class=\"job\" value=\"\">";
                                _html += "<span class=\"infor\"></span>";
                                _html += "</div>";
                                _html += "</li>";
                            });
                        }

                        if (null != Data.DepartmentPeople) {
                            $.each(Data.DepartmentPeople, function (i, n) {
                                _html += "<li onclick='clickPeople(this)'>";
                                _html += "<div class=\"liLeft\"><img src=\"/Chat/index_files/20170926103645_21.jpg\"></div><span class=\"boxFont\"></span>";
                                _html += "<div class=\"liRight\">";
                                _html += "<span class=\"intername\"><i class=\"name\">" + n.cName + "</i><p>" + hh + ":" + mf + "</p></span>";
                                _html += "<input type=\"hidden\" class=\"interid\" value=\"" + n.userID + "\">";
                                _html += "<input type=\"hidden\" class=\"haveLable\" value=\"\">";
                                _html += "<input type=\"hidden\" class=\"job\" value=\"\">";
                                _html += "<span class=\"infor\"></span>";
                                _html += "</div>";
                                _html += "</li>";
                            });
                        }

                    }
                }
            })
        }

        // $('.result-container').html(_html)
        $('#peopleModal ul').html(_html );
        // console.log($(".result-container ul").html())

        $('#peopleModal').fadeIn(100);
        evt.preventDefault();
    };

    //点击搜索到的联系人
    function clickPeople(ob) {
        var clickId = $(ob).find('.interid').val();
        if( $("#message :input[value="+clickId+"]").length === 1 ){
            $("#message :input[value="+clickId+"]").parent('.liRight').parent('li').click();
            $("#mesMenu").click();
        }else {
            var intername = $(ob).html();
            var html = "<li class='bg' onclick='lookMessage(this)'>" + intername + "</li>";
            $("#message").children('li').removeClass('bg');
            $("#message").append(html);
            $('.internetName').text($(ob).children('.liRight').children('.intername').text());
        }
        // $(ob).html('')
        $("#mesMenu").click();
        $('.close').click();
        $(".bg").click();
    };


    //点击消息列表联系人聊天
    function lookMessage(obj) {
        $(".up").hide();
        $(".customer").hide();
        $(".mine").hide();
        $(".newsList").show();
        // $(".chatMessages").hide();
        $(".right").show();
        $(obj).addClass('bg').siblings().removeClass('bg');
        var intername=$(obj).children('.liRight').children('.intername').children('.name').text();
        $('.internetName').text(intername);
        $('.newsList').html('');
        $(".RightFoot").show();

        if ($("#Colleague input[value=" + $(obj).find('.interid').val() + "]").length == 1) {
            $("#ColleagueName").html('<br>')
            $("#ColleagueDept").html(' <br>')
            $("#ColleaguePosition").html(' <br>')
            $("#ColleaguePhone").html('<br> ')
            $("#ColleagueMobilePhone").html(' <br>')
            $("#ColleagueEmail").html(' <br>')
            $("#ColleagueAddress").html(' <br>')
            if ($("#Colleague :input[value=" + $(obj).find('.interid').val() + "]")) {
                $("#ColleagueDept").text($(obj).find(".job").val())
                if ($(obj).find('.job').val() === '总经理') {
                    $("#ColleaguePosition").text("盟主")
                } else {
                    $("#ColleaguePosition").text("成员")
                }
                    <c:if test="${!empty FriendsList}">
                    $.each(${FriendsList}, function (i, n) {
                        if (n.ID == $(obj).find('.interid').val()) {
                            $("#ColleagueName").text(n.psnName)
                            $("#ColleaguePhone").text(n.sosPhone)
                            $("#ColleagueMobilePhone").text(n.mobilePhone)
                            $("#ColleagueEmail").text(n.email)
                            $("#ColleagueAddress").text(n.address)
                        }
                    })
                    </c:if>
            }
        $(".up").show();
        }else {
            $("#cusCompany").html('<br>')
            $("#cusAddress").html('<br>')
            $("#cusUseOfTheProduct").html('<br>')
            $("#cusServiceDue").html('<br>')
            $("#cusID").html('<br>')
            $("#cusPhone").val('')
            <c:if test="${!empty CustomerPeopleList}">
                $.each(${CustomerPeopleList},function (i,n){
                    if (n.uID==$(obj).find('.interid').val()){
                        $.ajax({
                            url:'/pay/selectPeopleDetails.action',
                            type:'post',
                            data:{ID:n.uID},
                            success:function (res){
                                if (res.length!=0) {
                                    var html=''
                                    $.each(res,function (i,n){
                                        html+=n.cProductName+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+n.cEndDate+'<br>';
                                    });
                                    $("#cusServiceDue").html(html);
                                }
                            }
                        });
                        $("#cusCompany").text(n.cCusName)
                        $("#cusAddress").text(n.cCusAddress)
                        $("#cusUseOfTheProduct").text(n.cCCCode)
                        $("#cusID").text(n.cName)
                        $("#cusPhone").val(n.cMoblePhone)
                    }
                });
            </c:if>


            $(".customer").show();
            $(".mine").show();
        }


        var num = $(obj).find('.boxFont').text();
        $(obj).find('.boxFont').text('')
        window.top.setNews("-"+num)
        // $(obj).parent('li').parent('ul').find('img').remove();
        if ($(obj).find('img').length == 1){
            $(obj).append('<img src="/Chat/img/delete.png" class="deleteimg" hidden onclick="deleteFocus(this)" style="position:relative;margin-right:0px;z-index: 10;" width="45" title="删除记录">');
            $(obj).children('img').show();
        }

        var html='';
        var chatID = $(obj).find('.interid').val();
        $.ajax({
            url:'/pay/selectChatContent.action',
            type: "POST",
            data: {
                userID:chatID,
                receiverID:window.top.getID()
            },
            success:function (res){

                $.each(res,function (i,n){
                    // console.log(n)
                    if (n.userID == chatID){
                        if (new Date(new Date().toLocaleDateString())-new Date(n.theSpecificTime.substring(0,n.theSpecificTime.indexOf(" ")))==0) {
                            // if ((new Date().-new Date(n.theSpecificTime))/ 3600/ 1000 > 48) {console.log("大于两天")}
                            if (n.news.indexOf("data:image") != -1) {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.createDate + '</span></div>' +
                                    '<div class="answerHead"><img src="/Chat/img/tou.jpg"/></div>' +
                                    '<div class="answers"><img class="jiao" src="/Chat/img/zuo.jpg"><img style="height: 60px" onclick="clickPic(this)" src="'+n.news+'"></div>' +
                                    '</li>';
                            }else {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.createDate + '</span></div>' +
                                    '<div class="answerHead"><img src="/Chat/img/tou.jpg"/></div>' +
                                    '<div class="answers"><img class="jiao" src="/Chat/img/zuo.jpg">' + n.news + '</div>' +
                                    '</li>';
                            }
                        }else {
                            if (n.news.indexOf("data:image") != -1) {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.theSpecificTime + '</span></div>' +
                                    '<div class="answerHead"><img src="/Chat/img/tou.jpg"/></div>' +
                                    '<div class="answers"><img class="jiao" src="/Chat/img/zuo.jpg"><img style="height: 60px;" onclick="clickPic(this)" src="'+n.news+'"></div>' +
                                    '</li>';
                            }else {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.theSpecificTime + '</span></div>' +
                                    '<div class="answerHead"><img src="/Chat/img/tou.jpg"/></div>' +
                                    '<div class="answers"><img class="jiao" src="/Chat/img/zuo.jpg">' + n.news + '</div>' +
                                    '</li>';
                            }
                        }
                    }else {
                        if (new Date(new Date().toLocaleDateString())-new Date(n.theSpecificTime.substring(0,n.theSpecificTime.indexOf(" ")))==0) {
                            if (n.news.indexOf("data:image") != -1) {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.createDate + '</span></div>' +
                                    '<div class="nesHead"><img src="/Chat/img/6.jpg"/></div>' +
                                    '<div class="news"><img class="jiao" src="/Chat/img/you.jpg"><img style="height: 60px;" onclick="clickPic(this)" src="'+n.news+'"></div>' +
                                    '</li>';
                            }else {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.createDate + '</span></div>' +
                                    '<div class="nesHead"><img src="/Chat/img/6.jpg"/></div>' +
                                    '<div class="news"><img class="jiao" src="/Chat/img/you.jpg">' + n.news + '</div>' +
                                    '</li>';
                            }
                        }else {
                            if (n.news.indexOf("data:image") != -1) {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.theSpecificTime + '</span></div>' +
                                    '<div class="nesHead"><img src="/Chat/img/6.jpg"/></div>' +
                                    '<div class="news"><img class="jiao" src="/Chat/img/you.jpg"><img style="height: 60px" onclick="clickPic(this)" src="'+n.news+'"></div>' +
                                    '</li>';
                            }else {
                                html += '<li>' +
                                    '<div style="text-align: center;margin-top: 6px;"><span class="talkTime">' + n.theSpecificTime + '</span></div>' +
                                    '<div class="nesHead"><img src="/Chat/img/6.jpg"/></div>' +
                                    '<div class="news"><img class="jiao" src="/Chat/img/you.jpg">' + n.news + '</div>' +
                                    '</li>';
                            }
                        }

                    }
                })
                $('.newsList').html(html);
                $('.RightCont').scrollTop($('.RightCont')[0].scrollHeight );


            }
        });

        /*//名片信息
        if($("#Colleague :input[value="+chatID+"]").length===1){
            //是同事
            $.ajax({
                url:'/pay/',
                type:"POST",
                data:{
                    ID:chatID
                },
                success:function (res){

                }
            });
        }else {

        }*/

    }

    //点击客户同事进行聊天
    function clickToMessage(obj) {
        var clickId = $(obj).find('.interid').val();
        if( $("#message :input[value="+clickId+"]").length === 1 ){
            $("#message :input[value="+clickId+"]").parent('.liRight').parent('li').click();
            $("#mesMenu").click();
        }else {
            var intername = $(obj).html();
            var html = "<li class='bg' onclick='lookMessage(this)'>" + intername + "</li>";
            $("#message").children('li').removeClass('bg');
            // $('.internetName').text($(obj).children('.liRight').children('.intername').text());
            $("#message").append(html);
            $("#mesMenu").click();
            $("#message .bg").click();
        }
    }



    //获取焦点删除
    function deleteFocus(obj){
        layui.use(['table','form'], function() {
            layer.confirm('确定删除聊天记录吗', function (index) {
               $.ajax({
                   url:'/pay/deleteChatMessage.action',
                   type:"POST",
                   data:{
                       userID:window.top.getID(),
                       receiverID:$(obj).parent('li').find('.interid').val()
                   },
                   success:function (res){
                        if (res.code == '1'){
                            layer.msg(res.msg,{icon: 1,time: 1500},function (){location.reload()});
                        }else {
                            layer.msg(res.msg,{icon: 2,time: 1500},function (){location.reload()});
                        }
                   }
               });
            });
        })
    }

    //展示简介
    function clickIntro() {
        if ($(".right").is(":hidden")) {
            $(".right").show();
        } else{
            $(".right").hide();
        }

    }

    //关闭烟
    function closeFireFlower(){
        if ($("#firefllow").is(":hidden")) {
            $("#firefllow").show();
        }else {
            $("#firefllow").hide();
        }
    }

    //客户编辑
    function editCustomerMessage(){
        layui.use(['table','form'], function() {
        if ($("#editCustomer").val()=='编辑') {
            $("#editCustomer").val("保存");
            // $("#cusAddress").css("border-color","red");//边框颜色
            $("#cusAddress").css("background-color","#00FFFF");//背景颜色
            $("#cusAddress").attr("contenteditable","true");
            $("#cusPhone").css("background-color","#00FFFF");//背景颜色
            $("#cusPhone").removeAttr("readonly");
        }else{
            $("#cusAddress").removeAttr("contenteditable");
            $("#cusPhone").attr("readonly","readonly");
            $("#cusAddress").css("background-color","white");//背景颜色
            $("#cusPhone").css("background-color","white");//背景颜色
                $.ajax({
                url:'/pay/editCustomerMessage',
                type:'post',
                data:{
                    ID:$(".bg").find('.interid').val(),
                    mobilePhone:$("#cusPhone").val().trim(),
                    address:$("#cusAddress").text().trim()
                },
                success:function (res){
                    if (res.msg==='添加成功'){
                        layer.msg('修改成功！', {icon: 1, time: 1500}, function () { });
                    }else {
                        layer.msg('修改失败！', {icon: 2, time: 1500}, function () { });
                    }
                }
            });
            $("#editCustomer").val("编辑");
        }
        });

    }



</script>

</body>
</html>