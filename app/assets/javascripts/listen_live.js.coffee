#= require scprbase

#= require_directory ./t_listen/
#= require swfobject

class scpr.ListenLive
    DefaultOptions:
        playerEl:   "#llplayer"
        playBtn:    "#llplay"
        playerId:   "#llplayDiv"
        rewind:     "http://scprdev.org:8000/rewind.mp3"
        offset:     2
        socketJS:   "http://scprdev.org:8000/socket.io/socket.io.js"
        host:       "http://scprdev.org:8000/"
        
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend options || {}
        
        if window.LLINIT == true
            console.log "tried to init a second ListenLive"
            return false
        else
            console.log "setting LLINIT to true"
            window.LLINIT = true
            
        
        @playing = false
        @started = 0
        @offset = 0
        @serverBuffer = 0
        
        @bufferUI = $ "<div/>", 
            id: "llBufferUI"
            html: JST["t_listen/buffer"]
                        
        $(@options.playerEl).html @bufferUI
                
        $.getScript @options.socketJS, =>
            # set up the socket
            @io = io.connect @options.host
            
            @io.on "ready", (data) =>
                console.log "got ready with ", data
                                
                @_displayBuffer data
                @_setUpPlayer()
                
                @bufferUI.on "click", (e) =>
                    offset = Math.round (1 - e.offsetX / @bufferUI.width() ) * @serverBuffer
                    @offsetTo offset
                    @_displayBuffer()
                
            @io.on "timecheck", (data) =>
                @_displayBuffer data
                
    #----------
    
    _displayBuffer: (data) ->
        if data
            @serverBuffer = data.buffered
            @serverTime = new Date(data.time)

            # set times
            $("#llServerTime").text String(@serverTime)
        
        # set buffer bar
        if @offset == 0
            $("#llBuffBar").width("100%")
        else        
            perc = 100 - (@offset / @serverBuffer * 100)
            $("#llBuffBar").width("#{ perc }%")
            
        $("#llPlayTime").text String(new Date(Number(@serverTime) - @offset*1000))
    
    #----------
                            
    _setUpPlayer: ->  
        $(@options.playerEl).append $ "<div/>", id:@options.playerId, text:"Flash player failed to load."
               
        swfobject.embedSWF "/assets-flash/streammachine.swf",
            @options.playerId,
            8,
            8,
            "9",
            "/swf/expressInstall.swf",
            { stream:"#{@options.rewind}?socket=#{@io.socket.sessionid}" },
            { wmode: "transparent" }, {}, (e) => @audio = e.ref
                            
        @playBtn = $(@options.playBtn)
                
        # register a click handler on the play button
        @playBtn.on "click", (evt) =>
            if @playing
                #@audio.pause()
                console.log "stopping..."
                @playing = false
            else              
                @audio.play()
                console.log "playing..."
                @playing = true
                
        $("#llnow").on "click", (evt) =>
            @offsetTo 1

        $("#lltop").on "click", (evt) =>
            now = new Date
            topoff = (now.getMinutes() * 60) + now.getSeconds()
        
            console.log "top of hour was at offset ", topoff
            @offsetTo topoff
                    
        $("#llbottom").on "click", (evt) =>
            now = new Date
        
            offsecs = null
        
            if now.getMinutes() >= 30
                # bottom of this hour
                offsecs = ( now.getMinutes() - 30 ) * 60 + now.getSeconds()
            else
                # bottom of the last hour
                offsecs = ( now.getMinutes() + 30 ) * 60 + now.getSeconds()
            
            console.log "bottom of the hour offset: ", offsecs
            @offsetTo offsecs
   
    #----------
                            
    offsetTo: (i) ->
        i = Number(i)
        
        # make sure we have a valid offset
        if i < 1
            i = 1
            
        # don't switch if this is already our offset
        if i == @offset
            return true
                        
        @io.emit("offset",i)
        
        # we need to seek to the end of the file
        @audio.seekToEnd()
        @audio.play()
                
        # note our status
        @started = Number(new Date) / 1000
        @offset = i
        @playing = true
