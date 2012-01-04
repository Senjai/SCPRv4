jQuery(document).ready(function() {
	
	// Temporary workaround to remove hardcoded image widths and heights from assethost images
	//$(".contentasset img").removeAttr("height").removeAttr("width");
	//$(".contentasset").removeAttr("style");
	
		
	// *** Stubbed out Fancybox code for video lightboxes ***
	$("a.video-link").fancybox({
			'transitionIn'	:	'elastic',
			'transitionOut'	:	'elastic',
			'speedIn'		:	300, 
			'speedOut'		:	200, 
			'overlayShow'	:	true,
			'overlayOpacity' :  0.8,
			'overlayColor'	: 	'#000',
			'padding'		: 	0
	});
	
	
});

// Open Listen Live Window
function open_popup(url) { 
        window.open(url, 'pop_up','height=800,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no');
        return false; 
}
// Open Social Sharing Windows
function open_social_popup(url) { 
        window.open(url, 'pop_up','height=350,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no');
        return false; 
}