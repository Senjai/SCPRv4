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
        grid: '.videos-overlay .grid'
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

        # When you hover on and off, do some fancy things with opacity.
        $(@opts.button).hover(
            => 
               $(@opts.button).css("cursor", "pointer")
               $(@opts.button).animate({opacity: 1}, "fast") if $(@opts.overlay).css('display') is 'none'
            => 
               $(@opts.button).css("cursor", "default")
               $(@opts.button).animate({opacity: 0.5}, "fast") if $(@opts.overlay).css('display') is 'none'
        )
        
        # When you click the button, show the overlay.
        $(@opts.button).bind "click", =>
              $(@opts.overlay).show("fast")
              clickShouldHide = true # In case they click outside of the overlay before they've hovered over it
              $(@opts.button).animate(@opts.active, "fast") unless $(@opts.button).hasClass('clicked')
              $(@opts.button).removeClass('clicked').addClass('clicked')
              $.ajax {
                  type: "GET"
                  url: "/videos"
                  dataType: "script"
                  beforeSend: (xhr) -> 
                    $('.videos-overlay .grid').spin()
                    console.log "Sending Request..."
                  error: (xhr, status, error) -> 
                    $('.videos-overlay .grid').spin(false)
                    $('.videos-overlay .grid ul').html "Error loading videos. Please refresh the page and try again."
                  dataFilter: (data, type) -> 
                    $('.videos-overlay .grid ul').html(data)
                  success: (result, status, xhr) -> 
                    $('.videos-overlay .grid').spin(false)
                  complete: (xhr, status) -> 
                    console.log "Finished request. Status: #{status}"
              }

        # This is the easiest way to tell if the cursor is in the overlay or not
        $(@opts.overlay).hover(
            => 
               clickShouldHide = false
            => 
               clickShouldHide = true
        )
        
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
        $('body').bind "mouseup", =>
            if clickShouldHide and $(@opts.overlay).css('display') isnt 'none'
              $(@opts.overlay).hide("fast")
              clickShouldHide = false
              $(@opts.button).animate(@opts.inactive, "fast")
              $(@opts.button).removeClass('clicked')