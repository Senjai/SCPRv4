#= require scprbase

class scpr.EventTracking
    DefaultOptions:
        category: "data-ga-category"
        action: "data-ga-action"
        label: "data-ga-label"
        chooser: ".track-event"
        nonInteraction: true

    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend( options || {} )

        $(@options.chooser).on
            click: (event) =>
                eventCategory = $(event.target).attr(@options.category)
                eventAction = $(event.target).attr(@options.action)
                eventLabel = $(event.target).attr(@options.label)
                _gaq.push ["_trackEvent", eventCategory, eventAction, eventLabel, @options.nonInteraction]
        
