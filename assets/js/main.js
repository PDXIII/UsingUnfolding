function init(){
	$('.collapse').collapse();
	$('.dropdown-toggle').dropdown();
}

onload=function (){
	init();
}

onresize=function (){
	init();
}