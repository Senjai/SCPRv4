#= require scprbase

class scpr.ListenLive
    DefaultOptions:
        playerEl:   "#llplayer"
        playBtn:    "#llplay"
        rewind:     "http://scprdev.org:8000/rewind.mp3"
        offset:     1
        
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend options || {}
        
        @playing = false
        @offset = null
        
        @player = $(@options.playerEl).jPlayer
            swfPath: "/flash"
            supplied: "mp3"
            solution: "html,flash"
            errorAlerts: true
            ready: (evt) =>
                console.log "in jPlayer ready"
                @offsetTo @options.offset
                
        @playBtn = $(@options.playBtn)
            
        @player.on $.jPlayer.event.waiting, (evt) => 
            console.log "got waiting"
            @playBtn.text "Loading"
            
        @player.on $.jPlayer.event.playing, (evt) =>
            console.log "got playing"
            @playBtn.text "Playing at -#{@offset}"
            
        @player.on "stop", (evt) =>
            @playBtn.text "Play"
            
        # register a click handler on the play button
        @playBtn.on "click", (evt) =>
            if @playing
                @player.jPlayer "stop"
                console.log "stopping..."
                @playing = false
            else              
                @player.jPlayer "play"
                console.log "playing..."
                @playing = true
                    
        $("#lltop").on "click", (evt) =>
            now = new Date
            topoff = (now.getMinutes() * 60) + now.getSeconds()
            
            console.log "top of hour was at offset ", topoff
            @offsetTo topoff
            
            if !@playing
                @player.jPlayer "play"
                @playing = true
                    
    offsetTo: (i) ->
        i = Number(i)
        
        # make sure we have a valid offset
        if i < 1
            i = 1
            
        # don't switch if this is already our offset
        if i == @offset
            return true
            
        # if we're playing already, stop
        if @playing
            @player.jPlayer "stop"
            
        # set our audio URL
        console.log "setting media to #{@options.rewind}?off=#{i}"
        @player.jPlayer "setMedia", mp3:"#{@options.rewind}?off=#{i}"
        @offset = i
        
        if @playing
            @player.jPlayer "play"