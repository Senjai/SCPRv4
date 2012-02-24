#= require scprbase
#= require spin.js

# OPTIMIZE this file a little more
# TODO: Modal doesn't go away on body click unless you hover over it first.
# TODO: Button animation needs some tweaking
# TODO: Real pagination

class scpr.VideoPage
    DefaultOptions:
        button: 'button.browse-all-videos'
        overlay: '.videos-overlay'
        nav: 
            button: 'button.arrow'
            left: 'button.arrow.left'
            right: 'button.arrow.right' 
        inactive:
            "background-color": "#000"
            opacity: 0.5
            color: "#444"
            "border-color": "#444"
        active:
            "background-color": "#2e2e2e"
            opacity: 1
            color: "#bfbfbf"
            "border-color": "#808080"
        
    constructor: (options) ->
        @opts = _(_({}).extend(@DefaultOptions)).extend options||{}
        @clickShouldHide = false
        console.log "We are on a video page."
        
        # Load the most recent videos when this class is initiated, so that the modal has videos ready to go
        # @getVideos()
    
        # When you hover on and off the button, do some fancy things with opacity.
        $(@opts.button).hover(
          => @fadeButton("in")
          => @fadeButton()
        )
    
        # This is the easiest way to tell if the cursor is in the overlay or not
        $(@opts.overlay).hover(
          => @clickShouldHide = false
          => @clickShouldHide = true
        )

        # Nav button functionality
        $(@opts.nav.button).hover(
          ->
            unless $(this).attr("data-page") is ""
                $(this).css("cursor", "pointer")
                $(this).animate({opacity: 1}, "fast")
          ->
            $(this).css("cursor", "default")
            $(this).animate({opacity: .5}, "fast")
        )

        $(@opts.nav.right).live "click", => 
            @getVideos($(this).attr("data-page")) unless $(this).attr("data-page") is ""
        $(@opts.nav.left).live "click", => 
            @getVideos($(this).attr("data-page")) unless $(this).attr("data-page") is ""

        # When you click the button, show the modal
        $(@opts.button).click => @showModal()

        # Hide the overlay if the Esc key is pressed
        $(document).keyup (e) => (@hideModal() if e.keyCode is 27 and $(@opts.overlay).css("display") isnt "none")
   
        # And finally, if we click outside of the overlay, hide it.
        $('body').click => @hideModal() if @clickShouldHide and $(@opts.overlay).css("display") isnt "none"


    getVideos: (page=1) ->
        $.ajax {
            type: "GET"
            url: "/videos/list"
            data: 
                page: page
            dataType: "script"
            beforeSend: (xhr) =>
                if $(@opts.overlay).css("display") is "none" # Wait for 200ms to spin, otherwise the spinner is off-center
                  setTimeout ( => 
                    $(@opts.overlay).spin()
                  ), 200
                else
                    $(@opts.overlay).spin()
                console.log "Sending Request..."
            error: (xhr, status, error) -> 
                $('.videos-overlay ul').html "Error loading videos. Please refresh the page and try again. (#{error})"
            complete: (xhr, status) => 
                $(@opts.overlay).spin(false)
                console.log "Finished request. Status: #{status}"
        }

    fadeArrow: (direction="out") ->
        if direction is "in"
            this.css("cursor", "pointer")
            this.animate({opacity: 1}, "fast")
        else
            $(this).css("cursor", "default")
            $(this).animate({opacity: .5}, "slow")

    fadeButton: (dir="out") ->
            cursor = if dir is "in" then "pointer" else "default"
            opacity = if dir is "in" then 1 else 0.5
            $(@opts.button).css("cursor", cursor)
            $(@opts.button).animate({opacity: opacity}, "fast") if $(@opts.overlay).css('display') is 'none'
        
    showModal: =>
        @getVideos() if !$(@opts.overlay + " ul>li").length # Get videos only if the modal hasn't been opened yet
        $(@opts.overlay).show("fast")
        $(@opts.button).animate(@opts.active, "fast") unless $(@opts.button).hasClass('clicked')
        $(@opts.button).removeClass('clicked').addClass('clicked')

    hideModal: =>
        $(@opts.overlay).hide("fast")
        @clickShouldHide = false
        $(@opts.button).animate(@opts.inactive, "fast")
        $(@opts.button).removeClass('clicked')