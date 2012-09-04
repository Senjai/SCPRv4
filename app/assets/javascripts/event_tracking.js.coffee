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
                _gaq.push ["_trackEvent", @options.category, @options.action, @options.label, @options.nonInteraction]
        
