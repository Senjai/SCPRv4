// Open Listen Live Window
function open_popup(url) { 
        window.open(url, 'pop_up','height=800,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no');
        return false; 
}

// temporary dev tool
function openWindow(width, height) {
	if(height == null) height = "1000";
	window.open(window.location, "dev", "height="+height+",width="+width)
}

function animateMenu(percentage) {
	$(".nav-compact").animate({left: percentage}, 300);
}

// Check for mobile
// var mobile = false;
// $(document).ready(function() {
//  if( navigator.userAgent.match(/Android/i)
//  || navigator.userAgent.match(/webOS/i)
//  || navigator.userAgent.match(/iPhone/i)
//  || navigator.userAgent.match(/iPad/i)
//  || navigator.userAgent.match(/iPod/i)
//  || navigator.userAgent.match(/BlackBerry/i)
//  ){
//   mobile= true;
//  }
// }
// function(){
//   if(mobile==true){
//   	return false;
//   }
// }