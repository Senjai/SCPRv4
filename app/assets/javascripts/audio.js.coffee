#= require scprbase

class scpr.Audio
    DefaultOptions:
        playEl: "#jquery_jplayer_1"
        titleEl: "#jplayer1_title"
    
    constructor: (options) ->
        @options = _(_({}).extend(this.DefaultOptions)).extend( options || {} )

        # instantiate jPlayer on playEl
        @player = $(@options.playEl).jPlayer
            swfPath: "/flash"
            supplied: "mp3"

        # register play button click handler
        $("a.play-btn").click (e) =>
            # get the audio file path from the href
            mp3 = $(e.target).attr("href")
            title = $(e.target).attr("title")
            
            # add the audio into jplayer
            @player.jPlayer "setMedia", mp3:mp3
            
            # set the title
            $(@options.titleEl).text title
            
            # animate the bar
            $(".audio-bar").animate {bottom:0}, 1000
            
            # and hit play
            @player.jPlayer "play"
            
            return false            
            
        # register listener to close audio bar
        $(".bar-close").click =>
            $(".audio-bar").animate {bottom:-70}, 300
            $("#jquery_jplayer_1").jPlayer "stop"
            return false;             

        #$(".jp-ff").jPlayer("playHead", 10);
        #// Toggle volume slider
        