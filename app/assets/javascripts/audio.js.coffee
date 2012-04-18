#= require scprbase

class scpr.Audio
    DefaultOptions:
        playEl:         "#jquery_jplayer_1"
        titleEl:        "#jplayer1_title"
        widgetClass:    ".story-audio"
        playBtn:        ".audio-toggler"
        audioBar:       ".audio-bar"
    
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend( options || {} )

        # instantiate jPlayer on playEl
        @player = $(@options.playEl).jPlayer
            swfPath: "/assets-flash"
            supplied: "mp3"
            
        @audiobar = $(@options.audioBar)
        
        @widgets = []
        @playing = false
        @active = null
        
        # find our audio widgets
        $(@options.widgetClass).each (idx,el) =>
            # find a play button
            btn = $(@options.playBtn,el)
            
            if btn
                # get the audio file path from the href
                mp3 = $(btn).attr("href")
                title = $(btn).attr("title")
                duration = Number($(btn).attr("data-duration"))
                
                console.log "#{@widgets.length}: #{mp3}", btn
                
                # take the URL out of the href
                $(btn).attr "href", "javascript:void(0);"
                
                widget = new Audio.PlayWidget
                    player:     @
                    widget:     el
                    playBtn:    btn
                    mp3:        mp3
                    title:      title
                    duration:   duration
                    
                @widgets.push widget
        
        console.log "found #{@widgets.length} widgets."
        
        # register listener to close audio bar
        $(".bar-close", @audiobar).click =>
            @audiobar.animate {bottom:@audiobar.height() * -1}, 300, =>
                @audiobar.removeClass('active')
    
            @player.jPlayer "stop"
            
            @playing = false
            @active = null
            
            return false
    
    #----------
        
    play: (widget) ->
        if @playing && @active == widget
            console.log("pause/play")
                        
            if @playing == 1
                @player.jPlayer "pause"
                @playing = 2
            else
                @player.jPlayer "play"
                @playing = 1

            return true
        
        if @playing
            console.log "stopping existing play."
            # tell the player to stop
            @player.jPlayer "stop"
            
            # and tell the widget that it stopped
            @active?.stop()
        
        # set our new mp3
        console.log "setting mp3 to ", widget.options.mp3
        @player.jPlayer "setMedia", mp3:widget.options.mp3
        $(@options.titleEl).text widget.options.title

        # should we enable hours?
        $.jPlayer.timeFormat.showHour = 
            if widget.options.duration && widget.options.duration > 60*60
                true
            else
                false
        
        # animate the bar
        @audiobar.addClass("active")
        @audiobar.animate {bottom:0}, 1000
        
        # and hit play
        @player.jPlayer "play"
        
        @playing = 1
        
        widget.play()
        @active = widget
    
    #----------
        
    stop: () ->
        if @playing
            @player.jPlayer "stop"
            @active?.stop()
            @playing = false
               
    #----------
     
    class @PlayWidget
        constructor: (options) ->
            @options = options
            @player = @options.player
            
            # register click handler on play button
            @options.playBtn.on "click", (e) =>
                @player.play @
                return false
        
        play: () ->
            # ...
                
        stop: () ->
            # ...        