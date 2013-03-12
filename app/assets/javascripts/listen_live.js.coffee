class scpr.ListenLive
    DefaultOptions:
        playerEl:   "#llplayer"
        playBtn:    "#llplay"
        playerId:   "llplayDiv"
        scheduleId: "#llschedule"
        rewind:     "http://scprdev.org:8000/kpcclive.mp3"
        socketJS:   "http://scprdev.org:8000/socket.io/socket.io.js"
        host:       "http://scprdev.org:8000/kpcclive"
        #rewind:     "http://localhost:8000/kpcclive.mp3"
        #socketJS:   "http://localhost:8000/socket.io/socket.io.js"
        #host:       "http://localhost:8000/kpcclive"
        
        
    constructor: (options) ->
        if window.LLINIT == true
            @options = _(_({}).extend(@DefaultOptions)).extend options || {}
            window.LLINIT = true

            @playing = false
            @started = 0
            @offset = 0
            @serverBuffer = 0
            
            @currentShow = null
            @playerUI = null
            @audio = null
            
            @playUIdiv = $("<div/>")
            $(@options.playerEl).append(@playUIdiv)
                    
            # -- build program schedule -- #

            if @options.schedule
                @schedule = new ListenLive.Schedule @options.schedule
                @guide = new ListenLive.ProgramGuide collection:@schedule
                
                $(@options.scheduleId).html @guide.render().el
                
                @schedule.bind "playMe", (m) =>
                    # seek to start time of this show
                    offset = moment().diff m.start, "seconds"
                    console.log "guide click wants to play at ", offset
                    @offsetTo offset

            # -- connect to the rewind server -- #
                    
            $.getScript @options.socketJS, =>
                # set up the socket
                @io = io.connect @options.host
                
                @io.on "ready", (data) =>
                    console.log "got ready with ", data
                                    
                    # set up our audio player at @audio
                    @_setUpPlayer()
                    
                    # update our display
                    @_updateDisplay data
                    
                    # attach our extra buttons
                    @_attachExtraUI()
                    
                # each time we get a timecheck from the server, update our play view
                @io.on "timecheck", (data) => @_updateDisplay data
                
    #----------
        
    _updateDisplay: (data) ->
        if data
            # -- stash our times -- #
        
            @serverBuffer = Number(data.buffered)
            @serverTime   = new Date(data.time)
            @playTime     = new Date( Number(@serverTime) - @offset*1000 )
        
        # -- do we have a current show? -- #
        if @currentShow && @currentShow.isWhatsPlayingAt @playTime
            # we're good
            
        else
            # if we had a current show, tell it that it is no longer playing
            @currentShow?.isPlaying(false)
            
            # need to figure out what's on and rerender our player
            @currentShow = @schedule.on_at @playTime
            @currentShow.isPlaying(true)

            @playerUI = $ "<div/>", 
                id: "llPlayerUI"
                html: JST["t_listen/player"]( show:@currentShow.toJSON() )

            @playUIdiv.html @playerUI
            
            # enable clicks on the buffer bar
            llBP = $("#llBuffProgress",@playUIdiv)
            llBP.on "click", (evt) =>
                s = @currentShow.start
                e = @currentShow.end
                d = e.diff(s)
                
                dest    = moment(s).add("ms", d * (evt.offsetX / llBP.width()) )
                offset  = ( @serverTime - dest.toDate() ) / 1000
                
                if offset < 0
                    offset = 0
                    
                @offsetTo offset
            
        @_updateTimes()
        
        # -- update our guide -- #
        
        @guide.render()

    #----------
        
    _updateTimes: ->
        # update the server and play time
        $("#llServerTime").text String(@serverTime)
        $("#llPlayTime").text String(@playTime)
        
        if @currentShow
            # set the buffer bar to reflect the current show
            s = @currentShow.start
            e = @currentShow.end
            d = e.diff(s) / 1000
            c = moment(@playTime).diff(s) / 1000

            perc = Math.round( c / d * 100 ) 
                        
            $("#llBuffBar").width("#{perc}%")
        else
            # set buffer bar globally
            if @offset == 0
                $("#llBuffBar").width("100%")
            else        
                perc = 100 - (@offset / @serverBuffer * 100)
                $("#llBuffBar").width("#{ perc }%")
        
        # show time buffered in the player         
        if @audio && @audio.getBufferedTime?
            $("#llBuffLen").text @audio.getBufferedTime()
            
    #----------
                            
    _setUpPlayer: ->  
        $(@options.playerEl).append $ "<div/>", id:@options.playerId, text:"Flash player failed to load."
               
        # we end up with our flash player available at @audio               
        swfobject.embedSWF "/assets-flash/streammachine.swf",
            @options.playerId,
            8,
            8,
            "9",
            "/swf/expressInstall.swf",
            { stream:"#{@options.rewind}?socket=#{@io.socket.sessionid}" },
            { wmode: "transparent" }, {}, (e) => @audio = e.ref
    
    #----------
     
    _attachExtraUI: ->     
        @playBtn = $(@options.playBtn)
                
        # register a click handler on the play button
        @playBtn.on "click", (evt) =>
            if @playing
                @audio.stop()
                @playing = false
            else              
                @audio.play()
                @playing = true
                
        $("#llnow").on "click", (evt) =>
            @offsetTo 1

        $("#lltop").on "click", (evt) =>
            now = new Date
            topoff = (now.getMinutes() * 60) + now.getSeconds()
        
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
                        
        @io.emit "offset", i, (i) =>
            if @offset != i
                @offset = Math.round(i)
                        
        # we need to seek to the end of the file
        if @playing
            @audio.seekToEnd()
            
        @audio.play()
                
        # note our status
        @started = Number(new Date) / 1000
        @offset = i
        @_updateDisplay()
        @playing = true

    #----------
    
    class @CurrentGen
        DefaultOptions:
            url:                "http://live.scpr.org/kpcclive?ua=SCPRWEB"
            player:             "#jquery_jplayer_1"
            swf_path:           "/assets-flash"
            pause_timeout:      300
            schedule_finder:    "#llschedule"
            schedule_template:  JST["t_listen/currentgen_schedule"]
            solution:           "flash, html"
            
        constructor: (opts) ->
            @options = _.defaults opts, @DefaultOptions
            
            @player = $(@options.player)
            @_pause_timeout = null
            
            @_on_now = null
            
            # -- set up our player -- #
                
            @player.jPlayer
                swfPath: @options.swf_path
                supplied: "mp3"
                ready: => 
                    @player.jPlayer("setMedia",mp3:@options.url).jPlayer("play")
                    
            # -- register play / pause handlers -- #
            @player.on $.jPlayer.event.play, (evt) =>
                if @_pause_timeout
                    clearTimeout @_pause_timeout
                    @_pause_timeout = null
                
            @player.on $.jPlayer.event.pause, (evt) => 
                
                # set a timer to convert this pause to a stop in one minute
                @_pause_timeout = setTimeout => 
                    @player.jPlayer("clearMedia")
                    @player.jPlayer("setMedia",mp3:@options.url)
                    console.log "stopped after inactivity"
                , @options.pause_timeout * 1000

            $.jPlayer.timeFormat.showHour = true;

            # -- build our schedule -- #
            
            if @options.schedule
                @schedule = new ListenLive.Schedule @options.schedule
                @_buildSchedule()
                
                setTimeout =>
                    @_buildSchedule() unless @_on_now == @schedule.on_now()
                , 60*1000
                
        #----------
        
        _buildSchedule: ->
            on_now = @schedule.on_now()
            on_next = @schedule.on_at( on_now.end.toDate() )
                            
            $(@options.schedule_finder).html @options.schedule_template? on_now:on_now.toJSON(), on_next:on_next.toJSON()
                
            @_on_now = on_now
            
    
    #----------

    @ScheduleShow: Backbone.Model.extend
        urlRoot: '/api/programs'
        initialize: ->
            # parse start and end times
            @start  = moment 1000 * Number(@attributes['start'])
            @end    = moment 1000 * Number(@attributes['end'])

            # Check if the show starts or ends between hours and choose format
            if @start.format("mm") is "00" and @end.format("mm") is "00"
                time_format = "ha"
            else
                time_format = "h:mma"

            @set 
                start:      @start
                end:        @end
                start_time: @start.format(time_format)
                end_time:   @end.format(time_format)
                
        isWhatsPlayingAt: (time) ->
            @start.toDate() <= time < @end.toDate()
            
        isPlaying: (state) ->
            @set isPlaying:state

    @Schedule: Backbone.Collection.extend
        model: ListenLive.ScheduleShow
        
        on_at: (time) ->
            # iterate through models until we get a true result from isWhatsPlayingAt
            @find (m) -> 
                m.isWhatsPlayingAt time
            
        #----------
        
        on_now: -> @on_at (new Date)

    #----------
    
    @ProgramGuideProgram: Backbone.View.extend
        tagName: "li"
        template: 
            """
            <b><%= title %></b>
            <br/><i><%= start_time %> - <%= relative %></i>
            """
        
        initialize: ->
            @render()
            @model.bind "change", => @render()
            
            @$el.on "click", (evt) => @model.trigger "playMe", @model
            
        #----------
            
        setClass: (cls) ->
            for c in ['playing','buffered','future']
                @$el.removeClass c
                
            if cls
                @$el.addClass cls
                
        #----------
        
        render: ->
            # figure out buffer / playing state
            if @model.get("isPlaying")
                @setClass "playing"
            else if @model.start > moment()
                @setClass "future"
            else
                @setClass()
            
            reltime = 
                if @model.start <= moment() <= @model.end
                    "On Now"
                else if @model.start < moment()
                    "Finished #{@model.end.fromNow()}"
                else
                    "Starts #{@model.start.fromNow()}"
            
            @$el.html _.template @template, _(@model.toJSON()).extend relative:reltime
            
            @
            
    #----------
    
    @ProgramGuide: Backbone.View.extend
        tagName: "ul"
        
        initialize: ->
            @_views = {}
            @collection.bind "reset", => 
                _(@_views).each (a) => $(a.el).detach()
                @_views = {}
                @render()
        
        render: ->
            # set up views for each collection member
            @collection.each (a) => 
                # create a view unless one exists
                @_views[a.cid] ?= new ListenLive.ProgramGuideProgram model:a
                @_views[a.cid].bind "click", (a) => @trigger "click", a
                
            # make sure all of our view elements are added
            @$el.append( _(@_views).map (v) -> v.render().el )
            
            @
