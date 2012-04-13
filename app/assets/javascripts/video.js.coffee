#= require scprbase
#= require spin.js

# OPTIMIZE this file a little more
# FIXME: Modal doesn't go away on body click unless you hover over it first.
# FIXME: Right nav button doesn't load until after the videos are fetched if the modal is opened quickly after page load 
# TODO: Button animation needs some tweaking (border color starts on white when fading out)

class scpr.VideoPage
    DefaultOptions:
        browseAll: '.browse-all-videos'
        overlay: '.videos-list'
        navButton: 'button.arrow'
        
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend options||{}    

        $(@options.browseAll).on
            click: (event) =>
                @getVideos() if !$(@options.overlay + " .video-thumb").length
                
        # Nav button hover functionality
        for button in $(@options.navButton)
            $(button).on
                click: (event) =>
                    page = $(event.target).attr("data-page")
                    @getVideos(page) unless page is ""
                mouseenter: (event) =>
                    unless $(event.target).attr("data-page") is "" 
                      @fadeButton($(event.target), "in")
                mouseleave: (event) =>
                    @fadeButton($(event.target), "out")

    getVideos: (page=1) ->
        $.ajax {
            type: "GET"
            url: "/video/list"
            data: 
                page: page
            dataType: "script"
            beforeSend: (xhr) =>
                if $(@options.overlay).css("display") is "none" # Wait for 200ms to spin, otherwise the spinner is off-center
                  setTimeout ( => 
                    $(@options.overlay + " .list").spin()
                  ), 200
                else
                    $(@options.overlay + " .list").spin()
                console.log "Sending Request..."
            error: (xhr, status, error) => 
                $(@options.overlay + ' .list').html "Error loading videos. Please refresh the page and try again. (#{error})"
            complete: (xhr, status) => 
                setTimeout ( => 
                  $(@options.overlay + " .list").spin(false)
                ), 200 # in case it takes less than 200ms to load the videos
                console.log "Finished request. Status: #{status}"
        }

    fadeButton: (button, dir) ->
        b = button
        cursor = if dir is "in" then "pointer" else "default"
        opacity = if dir is "in" then 1 else 0.5
        b.css("cursor", cursor)
        b.animate({opacity: opacity}, "fast")
