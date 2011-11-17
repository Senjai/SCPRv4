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
	
	// *** Stubbed out code for in-page audio player ***
	// Clicking on a story audio link invokes the player
	$(".play-btn").click(
		function(){
			$(".audio-bar").animate({bottom:0}, 1000);
			$("#jquery_jplayer_1").jPlayer("play");
			return false;
		}
	);
	// Close audio bar
	$(".bar-close").click(
		function(){
			$(".audio-bar").animate({bottom:-70}, 300);
			$("#jquery_jplayer_1").jPlayer("stop");
			return false;
		}
	);
	// Instance of jPlayer 
	$("#jquery_jplayer_1").jPlayer({
	        ready: function () {
	          $(this).jPlayer("setMedia", {
	            m4a: "http://media.scpr.org/audio/features/20111011_features1490.mp3"
	          });
	        },
	        swfPath: "/flash",
	        supplied: "m4a"
	      });
	
	$(".jp-ff").jPlayer("playHead", 10);
	// Toggle volume slider
	
});