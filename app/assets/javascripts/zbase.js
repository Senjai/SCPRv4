jQuery(document).ready(function() {
	
	// Temporary workaround to remove hardcoded image widths and heights from assethost images
	//$(".contentasset img").removeAttr("height").removeAttr("width");
	//$(".contentasset").removeAttr("style");
	
	// *** Stubbed out simple hover behavior for megamenus in primary nav ***
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
	$(".section-mega").hover(
		function(){
			$(this).show();
			var tabContext = $(this).attr("id");
			$("a[data-section='"+tabContext+"']").addClass("hover");
		},
		function(){
			$(this).hide();
			var tabContext = $(this).attr("id");
			$("a[data-section='"+tabContext+"']").removeClass("hover");
		}
	);
	
	// *** Instantiate carousel for article rotator ***
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
	$("#missed-it").carouFredSel({
			circular	: false,
			infinite	: false,
			auto 		: false,
			items : 6,
			prev : {
				button		: "#carousel_prev",
				key			: "left",
				items		: 6,
				duration	: 600
			},
			next : {
				button		: "#carousel_next",
				key			: "right",
				items		: 6,
				duration	: 600
			},
			pagination : {
				container	: "#carousel_pag",
				keys		: true,
				duration	: 600
			}				
	});
	
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