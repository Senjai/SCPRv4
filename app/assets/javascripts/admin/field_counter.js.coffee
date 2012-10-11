#= require scprbase

$ ->
    for field in $("form.simple_form .field-counter")
        el        = $(field)
        target    = el.attr("data-target")
        fuzziness = el.attr("data-fuzziness")
        new scpr.FieldCounter(el, target: target fuzziness: fuzziness)
        
class scpr.FieldCounter
    DefaultOptions:
        target:          145 # This should pretty much always be overwritten
        fuzziness:       20
        inRangeClass:    "alert alert-success"
        outOfRangeClass: "alert alert-warning"
        
    constructor: (@el, options={}) ->
        @options = _.defaults options, @DefaultOptions

        # Setup elements
        @field   = $("input, textarea", @el)
        @counterEl = $("<div />", class: "counter-notify", style: "padding: 0;")
        $(".controls", @el).prepend @counterEl
        
        # Setup attributes
        @count     = 0
        @target    = @options.target
        @fuzziness = @options.fuzziness
        @rangeLow  = @target - @fuzziness
        @rangeHigh = @target + @fuzziness

        # Set the count on initialize
        @updateCount(@field.val().length)
        
        # Register listeners
        @field.on
            keyup: (event) =>
                @updateCount($(event.target).val().length)
        
        @el.on
            updateCount: (count) =>
                @updateText(count)
                @updateColor(count)
                
    #--------------

    inRange: ->
        @rangeLow <= @count and @count <= @rangeHigh
                    
    #--------------
    
    updateCount: (length) ->
        @count = length
        @el.trigger "updateCount", @count
    
    #--------------
    
    updateText: (count) ->
        @counterEl.html("Optimal Length: #{count} of #{@target} (+/- #{@fuzziness})")

    #--------------
    
    updateColor: (count) ->
        if @inRange()
            @counterEl.removeClass(@outOfRangeClass)
            @counterEl.addClass(@inRangeClass)
        else
            @counterEl.removeClass(@inRangeClass)
            @counterEl.addClass(@outOfRangeClass)
        
        