/*
 * SmartWizard 2.0 plugin
 * jQuery Wizard control Plugin
 * by Dipu 
 * 
 * http://www.techlaboratory.net 
 * http://tech-laboratory.blogspot.com
 */
 
(function($){
    $.fn.smartWizard = function(action) {
        var options = $.extend({}, $.fn.smartWizard.defaults, action);
        var args = arguments;
        
        return this.each(function(){
                var obj = $(this);
                var curStepIdx = options.selected;
                var steps = $("ul > li > a", obj); // Get all anchors in this array
                var contentWidth = 0;
                var loader,msgBox,elmActionBar,elmStepContainer,btNext,btPrevious,btFinish,btReturn;
                
                elmActionBar = $('.actionBar',obj);
                if(elmActionBar.length == 0){
                  elmActionBar = $('<div></div>').addClass("actionBar");                
                }

                msgBox = $('.msgBox',obj);
                if(msgBox.length == 0){
                  msgBox = $('<div class="msgBox"><div class="content"></div><a href="#" class="close">X</a></div>');
                  elmActionBar.append(msgBox);                
                }
                
                $('.close',msgBox).click(function() {
                    msgBox.fadeOut("normal");
                    return false;
                });

                // Method calling logic
                if (!action || action === 'init' || typeof action === 'object') {
                  init();
                }else if (action === 'showMessage') {
                  //showMessage(Array.prototype.slice.call( args, 1 ));
                  var ar =  Array.prototype.slice.call( args, 1 );
                  showMessage(ar[0]);
                  return true;
                }else if (action === 'setError') {
                  var ar =  Array.prototype.slice.call( args, 1 );
                  setError(ar[0].stepnum,ar[0].iserror);
                  return true;
                }else if (action === 'skipTo') {
                	/*
                	 * create by zhushukai
                	 * ??????????????????,???????????????????????????????????????
                	 * $('#yourId').smartWizard('skipTo',2);??????????????????
                	 */
                   var ar =  Array.prototype.slice.call( args, 1 );
                   steps.eq(ar[0]-1).click();
                   return true;
                } else {
                  $.error( 'Method ' +  action + ' does not exist' );
                }
                
                function init(){
                  var allDivs =obj.children('div'); //$("div", obj);                
                  obj.children('ul').addClass("anchor");
                  allDivs.addClass("content");
                  // Create Elements
                  loader = $('<div>Loading</div>').addClass("loader");
                  elmActionBar = $('<div></div>').addClass("actionBar");
                  elmStepContainer = $('<div></div>').addClass("stepContainer");
                  btNext = $('<a>'+options.labelNext+'</a>').attr("href","#").addClass("buttonNext");
                  btPrevious = $('<a>'+options.labelPrevious+'</a>').attr("href","#").addClass("buttonPrevious");
                  btFinish = $('<a>'+options.labelFinish+'</a>').attr("href","#").addClass("buttonFinish");
                  if(options.labelReturn!=null){
                 	 btReturn=$("<a>"+options.labelReturn+'</a>').attr("href","#").addClass("buttonReturn");
                  }
                  // highlight steps with errors
                  
                  if(options.errorSteps && options.errorSteps.length>0){
                    $.each(options.errorSteps, function(i, n){
                      setError(n,true);
                    });
                  }
                  
                  elmStepContainer.append(allDivs);
                  elmActionBar.append(loader);
                  obj.append(elmStepContainer);
                  obj.append(elmActionBar); 
                  elmActionBar.append(btFinish).append(btNext).append(btPrevious).append(btReturn); 
                  contentWidth = elmStepContainer.width();

                  $(btNext).click(function() {
                      doForwardProgress();
                      return false;
                  }); 
                  $(btPrevious).click(function() {
                	  if($.isFunction(options.onPreviousStep)){
                		  if(options.onPreviousStep.call(this,$(steps.eq(curStepIdx), obj))){
                			  doBackwardProgress();
                		  }
                	  }
                      return false;
                  }); 
                  if(btReturn!=null){
	                  $(btReturn).click(function(){
	                  	if($.isFunction(options.onReturnStep)) {
	                        options.onReturnStep.call(this);
	                        doFirstProgress();
	                      }
	                  	return false;
	                  });
                  }
                  $(btFinish).click(function() {
                      if(!$(this).hasClass('buttonDisabled')){
                         if($.isFunction(options.onFinish)) {
                            if(!options.onFinish.call(this,$(steps))){
                              return false;
                            }
                         }else{
                           var frm = obj.parents('form');
                           if(frm && frm.length){
                             frm.submit();
                           }                         
                         }                      
                      }

                      return false;
                  }); 
                  
                  $(steps).bind("click", function(e){
                      if(steps.index(this) == curStepIdx){
                        return false;                    
                      }
                      var nextStepIdx = steps.index(this);
                      var isDone = steps.eq(nextStepIdx).attr("isDone") - 0;
                      if(isDone == 1){
                      	 //?????????????????? ??????onNextStep?????????
	                 	  if($.isFunction(options.onNextStep)&&nextStepIdx>curStepIdx) {
	                      	  if(!options.onNextStep.call(this,$(steps.eq(curStepIdx), obj))){
		                        return false;
		                      }else{
		                      	LoadContent(nextStepIdx);
		                      }
		                      
	                 	  }else{
	                      		LoadContent(nextStepIdx);
	                      }
                                           
                      }
                      return false;
                  }); 
                  
                  // Enable keyboard navigation                 
                  if(options.keyNavigation){
                      $(document).keyup(function(e){
                          if(e.which==39){ // Right Arrow
                            doForwardProgress();
                          }else if(e.which==37){ // Left Arrow
                            doBackwardProgress();
                          }
                      });
                  }
                  //  Prepare the steps
                  prepareSteps();
                  // Show the first slected step
                  LoadContent(curStepIdx);                  
                }

                function prepareSteps(){
                  if(!options.enableAllSteps){
                    $(steps, obj).removeClass("selected").removeClass("done").addClass("disabled"); 
                    $(steps, obj).attr("isDone",0);                 
                  }else{
                    $(steps, obj).removeClass("selected").removeClass("disabled").addClass("done"); 
                    $(steps, obj).attr("isDone",1); 
                  }

            	    $(steps, obj).each(function(i){
                        $($(this).attr("href"), obj).hide();
                        $(this).attr("rel",i+1);
                  });
                }
                
                function LoadContent(stepIdx){
                    var selStep = steps.eq(stepIdx);
                    var ajaxurl = options.contentURL;
                    var hasContent =  selStep.data('hasContent');
                    stepNum = stepIdx+1;
                    if(ajaxurl && ajaxurl.length>0){
                       if(options.contentCache && hasContent){
                           showStep(stepIdx);                          
                       }else{
                           $.ajax({
                            url: ajaxurl,
                            type: "POST",
                            data: ({step_number : stepNum}),
                            dataType: "text",
                            beforeSend: function(){ loader.show(); },
                            error: function(){loader.hide();},
                            success: function(res){ 
                              loader.hide();       
                              if(res && res.length>0){  
                                 selStep.data('hasContent',true);            
                                 $($(selStep, obj).attr("href"), obj).html(res);
                                 showStep(stepIdx);
                              }
                            }
                          }); 
                      }
                    }else{
                      showStep(stepIdx);
                    }
                }
                
                function showStep(stepIdx){
                    var selStep = steps.eq(stepIdx); 
                    var curStep = steps.eq(curStepIdx);
                    if(stepIdx != curStepIdx){
                      if($.isFunction(options.onLeaveStep)) {
                        if(!options.onLeaveStep.call(this,$(curStep))){
                          return false;
                        }
                      }
                    }     
                   // elmStepContainer.height($($(selStep, obj).attr("href"), obj).outerHeight());               
                    if(options.transitionEffect == 'slide'){
                      $($(curStep, obj).attr("href"), obj).slideUp("fast",function(e){
                            $($(selStep, obj).attr("href"), obj).slideDown("fast");
                            curStepIdx =  stepIdx;                        
                            SetupStep(curStep,selStep);
                          });
                    } else if(options.transitionEffect == 'fade'){                      
                      $($(curStep, obj).attr("href").match(/#\w{1,}/)+"", obj).fadeOut("fast",function(e){
                            $($(selStep, obj).attr("href").match(/#\w{1,}/)+"", obj).fadeIn("fast");
                            curStepIdx =  stepIdx;                        
                            SetupStep(curStep,selStep);                           
                          });                    
                    } else if(options.transitionEffect == 'slideleft'){
                        var nextElmLeft = 0;
                        var curElementLeft = 0;
                        if(stepIdx > curStepIdx){
                            nextElmLeft1 = contentWidth + 10;
                            nextElmLeft2 = 0;
                            curElementLeft = 0 - $($(curStep, obj).attr("href"), obj).outerWidth();
                        } else {
                            nextElmLeft1 = 0 - $($(selStep, obj).attr("href"), obj).outerWidth() + 20;
                            nextElmLeft2 = 0;
                            curElementLeft = 10 + $($(curStep, obj).attr("href"), obj).outerWidth();
                        }
                        if(stepIdx == curStepIdx){
                            nextElmLeft1 = $($(selStep, obj).attr("href"), obj).outerWidth() + 20;
                            nextElmLeft2 = 0;
                            curElementLeft = 0 - $($(curStep, obj).attr("href"), obj).outerWidth();                           
                        }else{
                            $($(curStep, obj).attr("href"), obj).animate({left:curElementLeft},"fast",function(e){
                              $($(curStep, obj).attr("href"), obj).hide();
                            });                       
                        }

                        $($(selStep, obj).attr("href"), obj).css("left",nextElmLeft1);
                        $($(selStep, obj).attr("href"), obj).show();
                        $($(selStep, obj).attr("href"), obj).animate({left:nextElmLeft2},"fast",function(e){
                          curStepIdx =  stepIdx;                        
                          SetupStep(curStep,selStep);                      
                        });
                    } else{

                    	$($(curStep, obj).attr("href").match(/#\w{1,}/)+"", obj).css("display","none");
                    	$($(selStep, obj).attr("href").match(/#\w{1,}/)+"", obj).css("display","block");
                    	//ie7?????????
//                        $($(curStep, obj).attr("href"), obj).hide(); 
//                        $($(selStep, obj).attr("href"), obj).show();
                        curStepIdx =  stepIdx;                        
                        SetupStep(curStep,selStep);
                    }
                    return true;
                }
                
                function SetupStep(curStep,selStep){
                   $(curStep, obj).removeClass("selected");
                   $(curStep, obj).addClass("done");
                   
                   $(selStep, obj).removeClass("disabled");
                   $(selStep, obj).removeClass("done");
                   $(selStep, obj).addClass("selected");
                   $(selStep, obj).attr("isDone",1);
                   adjustButton();
                   if($.isFunction(options.onShowStep)) {
                      if(!options.onShowStep.call(this,$(selStep))){
                        return false;
                      }
                   } 
                }                
               //??????????????????
              function doFirstProgress() {

				var stepIdx = 0;
				var selStep = steps.eq(stepIdx);
				stepNum = stepIdx + 1;
				var selStep = steps.eq(stepIdx);
				var curStep = steps.eq(curStepIdx);
				//??????????????????????????????
//				elmStepContainer.height($($(selStep, obj).attr("href"), obj)
//						.outerHeight());
				$($(curStep, obj).attr("href"), obj).hide();
				$($(selStep, obj).attr("href"), obj).show();
				curStepIdx = stepIdx;
				for(var i=0;i<steps.length;i++){
					if(i!=stepIdx){
					$(steps.eq(i), obj).removeClass("selected");
					$(steps.eq(i), obj).removeClass("done");
					$(steps.eq(i), obj).attr("isDone", 0);
					$(steps.eq(i), obj).addClass("disabled");
					}
				}
				$(selStep, obj).removeClass("disabled");
				$(selStep, obj).removeClass("done");
				$(selStep, obj).addClass("selected");
				$(selStep, obj).attr("isDone", 1);
				
				adjustButton();

			}
                function doForwardProgress(){
                  var nextStepIdx = curStepIdx + 1;
                  if(steps.length <= nextStepIdx){
                    if(!options.cycleSteps){
                      return false;
                    }                  
                    nextStepIdx = 0;
                  }
                  //?????????????????? ??????onNextStep?????????
                  if($.isFunction(options.onNextStep)) {
                      if(!options.onNextStep.call(this,$(steps.eq(curStepIdx), obj))){
                        return false;
                      }else{
                      	LoadContent(nextStepIdx);
                      }
                   }else{//??????onNextStep???????????? ????????????????????????
                   		LoadContent(nextStepIdx);
                   }
                  
                  
                  
                }
                
                function doBackwardProgress(){
                  var nextStepIdx = curStepIdx-1;
                  if(0 > nextStepIdx){
                    if(!options.cycleSteps){
                      return false;
                    }
                    nextStepIdx = steps.length - 1;
                  }
                  LoadContent(nextStepIdx);
                }  
                
                function adjustButton(){
                  if(!options.cycleSteps){                
                    if(0 >= curStepIdx){
                      $(btPrevious).addClass("buttonDisabled");
                    }else{
                      $(btPrevious).removeClass("buttonDisabled");
                    }
                    if((steps.length-1) <= curStepIdx){
                      $(btNext).addClass("buttonDisabled");
                    }else{
                      $(btNext).removeClass("buttonDisabled");
                    }
                  }
                  // Finish Button 
                  if(!steps.hasClass('disabled') || options.enableFinishButton){
                    $(btFinish).removeClass("buttonDisabled");
                  }else{
                    $(btFinish).addClass("buttonDisabled");
                  }
                  
                  if(options.enableFinishButtonOnlyLastStep){
                  	if((steps.length-1) <= curStepIdx){
                      $(btFinish).removeClass("buttonDisabled");
                    }else{
                      $(btFinish).addClass("buttonDisabled");
                    }
                  }
                }
                
                function showMessage(msg){
                  $('.content',msgBox).html(msg);
              		msgBox.show();
                }
                
                function setError(stepnum,iserror){
                  if(iserror){                    
                    $(steps.eq(stepnum-1), obj).addClass('error')
                  }else{
                    $(steps.eq(stepnum-1), obj).removeClass("error");
                  }                                   
                }                        
        });  
    };  
 
    // Default Properties and Events
    $.fn.smartWizard.defaults = {
          selected: 0,  // Selected Step, 0 = first step   
          keyNavigation: true, // Enable/Disable key navigation(left and right keys are used if enabled)
          enableAllSteps: false,
          transitionEffect: 'fade', // Effect on navigation, none/fade/slide/slideleft
          contentURL:null, // content url, Enables Ajax content loading
          contentCache:true, // cache step contents, if false content is fetched always from ajax url
          cycleSteps: false, // cycle step navigation
          enableFinishButton: false, // make finish button enabled always
          enableFinishButtonOnlyLastStep: false, // make finish button enabled only last step
          errorSteps:[],    // Array Steps with errors
          labelNext:'?????????', 
		  labelPrevious:'?????????',
		  labelFinish:'??????',
          labelReturn:null,
          onPreviousStep : null,
          onLeaveStep: null, // triggers when leaving a step
          onShowStep: null,  // triggers when showing a step
          onFinish: null,  // triggers when Finish button is clicked
          onReturnStep:null,//labelReturn ???????????????????????????
          onNextStep:null//?????????????????? ??????????????????
    };    
    
})(jQuery);