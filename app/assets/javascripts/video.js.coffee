#= require scprbase
#= require spin.js

# OPTIMIZE This file. Needs to be more DRY and consistent. For starters, turn the overlay.hide() & setting clickShouldHide into a function
# FIXME Button behavior needs a little work

$.ajaxSetup({
  beforeSend: (xhr) ->
    xhr.setRequestHeader("Accept", "text/javascript")
})

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
        clickShouldHide = false
        console.log "We are on a video page."
        
        # Load the most recent videos when this class is initiated, so that the modal has videos ready to go
        @getVideos()

        # When you hover on and off the button, do some fancy things with opacity.
        $(@opts.button).hover(
            => 
               $(@opts.button).css("cursor", "pointer")
               $(@opts.button).animate({opacity: 1}, "fast") if $(@opts.overlay).css('display') is 'none'
            => 
               $(@opts.button).css("cursor", "default")
               $(@opts.button).animate({opacity: 0.5}, "fast") if $(@opts.overlay).css('display') is 'none'
        )
        
        # When you click the button, show the overlay.
        $(@opts.button).click =>
              $(@opts.overlay).show("fast")
              clickShouldHide = true # In case they click outside of the overlay before they've hovered over it
              $(@opts.button).animate(@opts.active, "fast") unless $(@opts.button).hasClass('clicked')
              $(@opts.button).removeClass('clicked').addClass('clicked')

        # This is the easiest way to tell if the cursor is in the overlay or not
        $(@opts.overlay).hover(
            -> 
              clickShouldHide = false
            -> 
              clickShouldHide = true
        )
        
        # Nav button functionality
        # $(@opts.nav.button).hover @fadeArrow("in"), @fadeArrow()
        $(@opts.nav.right).click -> @getVideos(2)
        $(@opts.nav.left).click -> @getVideos(1)    
        
            
        # Hide the overlay if the Esc key is pressed
        $(document).keyup( 
          (e) =>
            if e.keyCode == 27 # Esc
                $(@opts.overlay).hide("fast")
                clickShouldHide = false
                $(@opts.button).animate(@opts.inactive, "fast")
                $(@opts.button).removeClass('clicked')
        )

        # And finally, if we click outside of the overlay, hide it.
        $('body').mouseup =>
            if clickShouldHide and $(@opts.overlay).css('display') isnt 'none'
                $(@opts.overlay).hide("fast")
                clickShouldHide = false
                $(@opts.button).animate(@opts.inactive, "fast")
                $(@opts.button).removeClass('clicked')
    
    getVideos: (page=1) ->
        $.ajax {
            type: "GET"
            url: "/videos/list"
            data: 
                page: page
            dataType: "script"
            beforeSend: (xhr) -> 
                $('.videos-overlay').spin() # FIXME This spins out of the modal if it's called before the modal is popped up. Need to stop and start it if the modal pops up
                console.log "Sending Request..."
            error: (xhr, status, error) -> 
                $('.videos-overlay ul').html "Error loading videos. Please refresh the page and try again. (#{error})"
            complete: (xhr, status) -> 
                $('.videos-overlay ul').spin(false)
                console.log "Finished request. Status: #{status}"
        }

    fadeArrow: (direction="out") =>
        if direction is "in"
            $(this).css("cursor", "pointer")
            $(this).animate({opacity: 1}, "fast")
        else
            $(this).css("cursor", "default")
            $(this).animate({opacity: .5}, "slow")
