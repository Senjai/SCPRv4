#= require scprbase
#= require spin.js

# OPTIMIZE this file a little more
# FIXME: Modal doesn't go away on body click unless you hover over it first.
# FIXME: Right nav button doesn't load until after the videos are fetched if the modal is opened quickly after page load 
# TODO: Button animation needs some tweaking (border color starts on white when fading out)

class scpr.VideoPage
    DefaultOptions:
        button: 'button.browse-all-videos'
        overlay: '.videos-overlay'
        nav: 
            button: 'button.arrow'
            left: 'button.arrow.left'
            right: 'button.arrow.right' 
        inactive:
            "background-color": "#070707"
            opacity: 1
            color: "#777777"
            "border-color": "#505050"
        active:
            "background-color": "#2e2e2e"
            opacity: 1
            color: "#bfbfbf"
            "border-color": "#808080"
        
    constructor: (options) ->
        @opts = _(_({}).extend(@DefaultOptions)).extend options||{}
        @clickShouldHide = false
    
        # When you hover on and off the button, do some fancy things with opacity.
        $(@opts.button).hover(
          => @fadeButton($(@opts.button), "in")
          => @fadeButton($(@opts.button), "out")
        )
    
        # This is the easiest way to tell if the cursor is in the overlay or not
        $(@opts.overlay).hover(
          => @clickShouldHide = false
          => @clickShouldHide = true
        )

        # Nav button hover functionality
        for button in $(@opts.nav.button)
            $(button).on
                click: (event) =>
                    page = $(event.target).attr("data-page")
                    @getVideos(page) unless page is ""
                mouseenter: (event) =>
                    unless $(event.target).attr("data-page") is "" 
                      @fadeButton $(event.target), "in"
                mouseleave: (event) =>
                    @fadeButton $(event.target), "out"

        # When you click the button, show the modal
        $(@opts.button).click => @showModal()

        # Hide the overlay if the Esc key is pressed
        $(document).keyup (e) => (@hideModal() if e.keyCode is 27 and $(@opts.overlay).css("display") isnt "none")
   
        # And finally, if we click outside of the overlay, hide it.
        $('body').click => @hideModal() if @clickShouldHide and $(@opts.overlay).css("display") isnt "none"


    getVideos: (page=1) ->
        $.ajax {
            type: "GET"
            url: "/video/list"
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
                setTimeout ( => 
                  $(@opts.overlay).spin(false)
                ), 200 # in case it takes less than 200ms to load the videos
                console.log "Finished request. Status: #{status}"
        }

    fadeButton: (button, dir) ->
            b = button
            cursor = if dir is "in" then "pointer" else "default"
            opacity = if dir is "in" then 1 else 0.5
            b.css("cursor", cursor)
            b.animate({opacity: opacity}, "fast") if ($(@opts.overlay).css('display') is 'none' and b.hasClass("browse-all-videos")) or b.hasClass('arrow')
        
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