// Open Listen Live Window
function open_popup(url) { 
        window.open(url, 'pop_up','height=800,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no');
        return false; 
}

// temporary dev tool
function tryWidth(width) {
	window.open(window.location.pathname, "dev", "height=1000,width="+width)
}

// temporary
$(document).ready(function() {
	$(".nav-compact.in .nav-toggler").on("click", function(event) {
		$(".nav-compact").animate({left: '-10px'}, 300, function() { 
			$(".nav-compact").removeClass('in').addClass('out');
		});
	});
	
	$(".nav-compact.out .nav-toggler").on("click", function(event) {
		console.log("okay");
		$(".nav-compact").animate({left: '-160px'}, 300, function() {
			$(".nav-compact").removeClass('out').addClass('in');
			console.log("went in");
		});
	});
});