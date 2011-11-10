jQuery(document).ready(function() {
	
	// Temporary workaround to remove hardcoded image widths and heights from assethost images
	$(".contentasset img").removeAttr("height").removeAttr("width");
	$(".contentasset").removeAttr("style");
	
	// Stubbed out simple hover behavior for megamenus in primary nav
	$(".mega a").hover(
		function(){
			var sectionContext = '#' + $(this).attr("data-section");
			$(sectionContext).show();
		},
		function(){
			var sectionContext = '#' + $(this).attr("data-section");
			$(sectionContext).hide();
		}
	);
	
	// Instantiate carousel for article rotator
	$(".carousel").carouFredSel({
			circular	: false,
			infinite	: false,
			auto 		: false,
			items : 4,
			prev : {
				button		: "#carousel_prev",
				key			: "left",
				items		: 4,
				duration	: 600
			},
			next : {
				button		: "#carousel_next",
				key			: "right",
				items		: 4,
				duration	: 600
			},
			pagination : {
				container	: "#carousel_pag",
				keys		: true,
				duration	: 600
			}				
	});
	
	// Stubbed out Fancybox code for video lightboxes
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