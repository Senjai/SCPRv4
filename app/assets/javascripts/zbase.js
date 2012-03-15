jQuery(document).ready(function() {	
	// Taggle Episode Modal Visibility
	$(".broadcastbar .true, .modal-close").click(function() {
		$(".episode-guide").toggleClass("hidden");
		$("body").bind(
	       'click',
	       function(e){
	        if(
	         !jQuery(".episode-guide").hasClass("hidden")
			 && !jQuery(e.target).is(".episode-guide")
			 && !jQuery(e.target).closest(".episode-guide").length
	        ){
	         jQuery(".episode-guide").addClass("hidden");
			 return false;
	        }
	       }
	      );
		return false;
	});
	
});

// Open Listen Live Window
function open_popup(url) { 
        window.open(url, 'pop_up','height=800,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no');
        return false; 
}
