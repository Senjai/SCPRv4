// Open Listen Live Window
function open_popup(url) { 
        window.open(url, 'pop_up','height=800,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no');
        return false; 
}

// temporary dev tool
function tryWidth(width) {
	window.open(window.location.pathname, "dev", "height=1000,width="+width)
}

function animateMenu(percentage) {
	$(".nav-compact").animate({left: percentage}, 300);
}

// temporary
$(document).ready(function() {
	
	$(".nav-toggler").toggle(function() {
		animateMenu("0%");
	}, function() {
		animateMenu("-50%");
	});
	
	$(".nav-toggler").touchwipe({
	     wipeLeft: function() { animateMenu("-50%"); },
	     wipeRight: function() { animateMenu("0%"); },
	     min_move_x: 20,
	     min_move_y: 20,
	     preventDefaultEvents: true
	});
	
});

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