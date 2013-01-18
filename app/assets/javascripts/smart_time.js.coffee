class scpr.SmartTime
    DefaultOptions:
        finder:             ".smarttime"
        time_format:        "%I:%M %p"
        date_format:        "%B %d"
        prefix:             ""
        relative:           "8h"
        timecut:            "36h"
        window:             null
        class:              "sttime"
            
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
        
        # build some defaults
        for opt in ['relative','timecut','window']
            if @options[opt]
                @options[opt] = ( @options[opt].match /(\d+)\s?(\w+)/)?[1..2].reverse()
                @options[opt][1] = parseInt(@options[opt][1])

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
                    @[opt][1] = parseInt(@[opt][1])
            # -- now figure out our display -- #
                
            @update()
            
        #----------
        
        update: ->
            now = moment()
            # Dup the Moment object
            # All limits are Lower limits
            # "Outside" = Before
            # "Inside"  = After
            windowLimit   = moment(now).subtract(@window...)   if @window
            relativeLimit = moment(now).subtract(@relative...) if @relative
            timecutLimit  = moment(now).subtract(@timecut...)  if @timecut
            
            # if we have a window, are we inside of it?
            if @time < windowLimit
                # @time is outside of the windowLimit
                # eg:
                #   now     = 8:00pm
                #   @time   = 6:00am
                #   @window = "10h"
                #
                #   windowLimit = (now - @window) = 10:00am
                #
                #   @time is outside (before) the windowLimit, so don't show anything
                #
                @$el.text ''
                @$el.removeClass @options.class if @options.class
                return true

            # are we doing relative or absolute timing?
            if @time > relativeLimit
                # @time is inside of the relativeLimit
                # Show a relative time
                # eg: 
                #   now       = 1:00pm
                #   @time     = 12:00pm
                #   @relative = "2h"
                #
                #   relativeLimit = (now - @relative) = 11:00am
                #
                #   @time is inside (after) relativeLimit, so show Relative time
                #
                # If (now - @time) is negative (i.e., @time is AFTER now),
                # then display "Just Now". This can happen just because of slight
                # discrepancies between server and client times.
                if now.diff(@time, "seconds") < 0
                    @$el.text 'Just Now'
                else
                    # relative formatting
                    @$el.text "" + @options.prefix + @time.fromNow()
                
            else
                # @time is outside of the relativeLimit
                # But inside the windowLimit (otherwise it would have returned already)
                # eg:
                #   now       = 5:00pm
                #   @time     = 12:00pm
                #   @window   = "8h"
                #   @relative = "2h"
                #
                #   windowLimit   = (now - @window)   = 9:00am
                #   relativeLimit = (now - @relative) = 3:00pm
                #
                #   @time is inside (after) windowLimit,
                #   but outside (before) relativeLimit, so we
                #   should display absolute formatting.
                #
                # If @time is outside (before) the timecutLimit (when to stop showing)
                # time), then just show the date.
                if @time < timecutLimit
                    # use date-only format
                    @$el.text "" + @options.prefix + @time.strftime @options.date_format
                else
                    # If @time is inside (after) the timecutLimit, then always show time,
                    # and decide whether or not to show date:
                    #
                    # If @window was specified and the hours are less than or equal to 12,
                    # then only show the time, since the date can be inferred.
                    # Otherwise, if no @window was specified, or the hours is higher than 12,
                    # show the date.
                    if @window and @window[1] <= 12
                        # use time format only
                        @$el.text "" + @options.prefix + @time.strftime "#{@options.time_format}"
                    else
                        # use date, time format
                        @$el.text "" + @options.prefix + @time.strftime "#{@options.date_format}, #{@options.time_format}"
                
            @$el.addClass @options.class if @options.class
