#= require scprbase
#= require moment
#= require moment-strftime

class scpr.SmartTime
    DefaultOptions:
        finder:  ".smarttime"
        abs_format: "%B %d, %I:%M %p"
            
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions        

        # now find our elements
        @elements = _.compact( new SmartTime.Instance(el,@options) for el in $ @options.finder )
        

    #----------
    
    class SmartTime.Instance
        constructor: (el,options) ->
            @time       = null
            @window     = null
            @relative   = null
            
            @$el = $(el)
            @options = options
            
            # -- find our time -- #
            
            if @$el.attr("data-unixtime")
                # if there's a data-unixtime attribute, that's our preferred choice 
                # for grabbing a time
                @time = moment Number(@$el.attr("data-unixtime")) * 1000
                
            else if $(el).attr("datetime")
                # a datetime value is our next fallback. for now, we'll just let 
                # moment try to figure it out
                @time = moment @$el.attr("datetime")
            
            else
                # failure.
                return false
                
            # -- look for display limits -- #
            
            if @$el.attr("data-timewindow")
                # timewindow provides a window in which we handle display. If we're 
                # outside the window, we display nothing
                @window = (@$el.attr("data-timewindow").match /(\d+)\s?(\w+)/)?[1..2].reverse()
            
            if @$el.attr("data-relativefor")
                # set a window for relative times / dates
                @relative = (@$el.attr("data-relativefor").match /(\d+)\s?(\w+)/)?[1..2].reverse()
            
            # -- now figure out our display -- #
                
            @update()
            
        #----------
        
        update: ->
            # if we have a window, are we inside of it?
            if @window and moment().subtract(@window...) > @time
                # outside the window...  
                @$el.text ''
                return true
                
            # are we doing relative or absolute timing?
            if @relative and moment().subtract(@relative...) < @time
                # relative formatting
                @$el.text @time.fromNow()
                
            else
                # absolute formatting
                @$el.text @time.strftime @options.abs_format
                
                
                    