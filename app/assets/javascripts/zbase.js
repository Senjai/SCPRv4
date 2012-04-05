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
	
	var $toggler = $(".nav-toggler");
	var $compactNav = $(".nav-compact");
	
	$toggler.toggle(function() {
		animateMenu("0%");
	}, function() {
		animateMenu("-50%");
	});
	
	$toggler.touchwipe({
	     wipeLeft: function() { animateMenu("-50%"); },
	     wipeRight: function() { animateMenu("0%"); },
	     min_move_x: 20,
	     min_move_y: 20,
	     preventDefaultEvents: true
	});
	
	$("body").on("click", function(event) {
    	if($compactNav.is(":visible") && !$(event.target).is($toggler) && !$(event.target).is($compactNav) && !$(event.target).closest($compactNav).length) {
        	// FIXME Doesn't technically "Toggle" the menu, so you have to click it twice to open it again. 
			animateMenu("-50%");
		}
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