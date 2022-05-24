(function() {
	/*建立模态框对象*/
	var modalBox = {};
	/*获取模态框*/
	modalBox.modal = document.getElementById("myModal");
    /*获得trigger按钮*/
	modalBox.triggerBtn = document.getElementById("triggerBtn");
    /*获得关闭按钮*/
	modalBox.closeBtn = document.getElementById("closeBtn");
	/*模态框显示*/
	modalBox.show = function() {
		// console.log(this.modal);
		this.modal.style.display = "block";
	}
	/*模态框关闭*/
	modalBox.close = function() {
		this.modal.style.display = "none";
	}
	/*当用户点击模态框内容之外的区域，模态框也会关闭*/
	modalBox.outsideClick = function() {
		var modal = this.modal;
		window.onclick = function(event) {
            if(event.target == modal) {
            	modal.style.display = "none";
            }
		}
	}
    /*模态框初始化*/
	modalBox.init = function() {
		var that = this;
		this.triggerBtn.onclick = function() {
			$("#myModal").find('h2').html("聊天记录"+"——"+$('.bg').find('.name').text());
			$.ajax({
				url:'/pay/selectChatContent.action',
				type:"post",
				async:false,
				data:{
					userID:$('.bg').find('.interid').val(),
					receiverID:window.top.getID()
				},
				success:function (res){
					var html='';
					$.each(res,function (i,n){
						if (n.userID==window.top.getID()) {
							html += '<li>' +
								'<div class="answerHead1"><img src="/Chat/img/6.jpg"/></div>' + window.top.getUser().name + '<span class="date">' + n.theSpecificTime + '</span>' + '<br/>' +
								'<p class="answers1">' + n.news + '</p>' +

								'</li>';
						}else {
							html += '<li>' +
								'<div class="answerHead1"><img src="/Chat/img/tou.jpg"/></div>' + $('.bg').find('.name').text() + '<span class="date">' + n.theSpecificTime + '</span>' + '<br/>' +
								'<p class="answers1">' + n.news + '</p>' +

								'</li>';
						}
					});
					$('.chatMessages').html(html)
				}
			});
			that.show();
		}
		this.closeBtn.onclick = function() {
			that.close();
		}
		this.outsideClick();
	}
	modalBox.init();
 
})();