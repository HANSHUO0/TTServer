function createTab(a,b,c,d){
	var dt = window.parent.document.getElementById(a);
 	
 	var dd = document.createElement('dd'); 
	dd.innerHTML= '<a id='+b+' lay-href='+c+'>'+d+'</a>';
	dt.append(dd);
	
	window.parent.document.getElementById(b).click();
}