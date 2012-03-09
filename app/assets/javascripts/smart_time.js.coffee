#= require scprbase
#= require moment
#= require moment-strftime

class scpr.SmartTime
    DefaultOptions:
        finder:             ".smarttime"
        datetime_format:    "%B %d, %I:%M %p"
        date_format:        "%B %d"
        prefix:             "| "
        relative:           "8h"
        timecut:            "36h"
        window:             null
            
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
        
        # build some defaults
        for opt in ['relative','timecut','window']
            if @options[opt]
                @options[opt] = ( @options[opt].match /(\d+)\s?(\w+)/)?[1..2].reverse()

        # now find our elements
        @elements = _.compact( new SmartTime.Instance(el,@options) for el in $ @options.finder )

    #----------
    
    class SmartTime.Instance
        constructor: (el,options) ->
            @$el = $(el)
            @options = options
            
            @time       = null
            @window     = @options.window
            @relative   = @options.relative
            @timecut    = @options.timecut
            
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
            
            for opt in ['relative','timecut','window']
                if @$el.attr("data-#{opt}")
                    @[opt] = (@$el.attr("data-#{opt}").match /(\d+)\s?(\w+)/)?[1..2].reverse()            
            
            # -- now figure out our display -- #
                
            @update()
            
        #----------
        
        update: ->
            now = moment()
            
            # if we have a window, are we inside of it?
            if @window and now.subtract(@window...) > @time
                # outside the window...  
                @$el.text ''
                return true
                
            # are we doing relative or absolute timing?
            if @relative and now.subtract(@relative...) < @time
                # relative formatting
                @$el.text "" + @options.prefix + @time.fromNow()
                
            else
                # absolute formatting
                if @timecut and now.subtract(@timecut...) > @time
                    # use date-only format
                    @$el.text "" + @options.prefix + @time.strftime @options.date_format
                else
                    # use date, time format
                    @$el.text "" + @options.prefix + @time.strftime @options.datetime_format                
                
                    