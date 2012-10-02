#= require scprbase

$ ->
    for widget in $(".audio-fields")
        new scpr.AudioUI($ widget)
        
class scpr.AudioUI
    DefaultOptions:
        destroyEl:    ".destroy-bool"
        destroyField: "input[type=checkbox][name*='[_destroy]']"
        detailsEl:    ".details"
        infoEl:       ".existing-audio"
        
    constructor: (@el, options) ->
        @options = _.defaults options||{}, @DefaultOptions
        
        @destroyEl    = $ @options.destroyEl, @el
        @destroyField = $ @options.destroyField, @destroyEl
        @detailsEl    = $ @options.detailsEl, @el
        @infoEl       = $ @options.infoEl, @el

        # destroy checkbox
        @destroyField.on
            change: (event) =>
                destroyed = if $(event.target).is(':checked') then true else false
                @toggleTransparency(destroyed)

    #-------------------
    
    toggleTransparency: (direction) ->
        if direction
            @infoEl.addClass "transparent"
            @detailsEl.addClass "transparent"
        else
            @infoEl.removeClass "transparent"
            @detailsEl.removeClass "transparent"
