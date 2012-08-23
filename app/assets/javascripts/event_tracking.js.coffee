(($) ->
 
  # Extend the jQuery object with the ga trackEvent function.
  $.extend ga:
    trackEvent: (args) ->
      defaultArgs =
        category: "Unspecified"
        action: "Unspecified"
        nonInteractive: false

      args = $.extend(defaultArgs, args)
      _gaq.push ["_trackEvent", args.category, args.action, args.label, args.value, args.nonInteractive]

  defaultOptions =   
    categoryAttribute: "data-ga-category"
    actionAttribute: "data-ga-action"
    labelAttribute: "data-ga-label"
    noninteractiveAttribute: "data-ga-noninteractive"
    #Whether to look for the label
    useLabel: false 
    #false = track as soon as the plugin loads, true = bind to an event
    useEvent: true
    #The event to bind to if useEvent is true
    event: "click"
    #A method to call to check whether or not we should call the tracking when the event is clicked
    valid: (elem, e) ->
      true
    #Tracking complete
    complete: (elem, e) ->

    #Category should always be set if using gaTrackEvent
    category: "Unspecified"
    #Action should always be set if using gaTrackEvent
    action: "Unspecified"   
    #Label can be specified if using gaTrackEvent and useLabel == true
    label: ""   
    #non-interactive - only used if using gaTrackEvent
    nonInteractive: false

  # gaTrackEvent adds unobtrusive tracking attributes itself
  # So you can add tracking to links etc.
  $.fn.gaTrackEvent = (options) ->
    options = $.extend(defaultOptions, options)
    @each ->
      element = $(this)
      element.attr options.categoryAttribute, options.category
      element.attr options.actionAttribute, options.action
      element.attr options.labelAttribute, options.label  if options.useLabel is true and options.label isnt ""
      element.attr options.noninteractiveAttribute, "true"  if options.nonInteractive is true
      element.gaTrackEventUnobtrusive options

  # Create the plugin
  # gaTrackEventUnobtrusive expects you to add the data attributes either via server side code or direct into the mark up.
  $.fn.gaTrackEventUnobtrusive = (options) ->
    #Merge options
    options = $.extend(defaultOptions, options)
    #Keep the chain going
    @each ->
      _this = $(this)
      
      #Wrap the tracking so we can reuse it.
      callTrackEvent = ->
        
        #Retreive the info
        category = _this.attr(options.categoryAttribute)
        action = _this.attr(options.actionAttribute)
        label = _this.attr(options.labelAttribute)
        nonInteractive = (_this.attr(options.noninteractiveAttribute) is "true")
        args =
          category: category
          action: action
          nonInteractive: nonInteractive

        if options.useLabel
          args.label = label
        else args.label = label  if options.useLabel
        $.ga.trackEvent args
      
      #If we want to bind to an event, do it.
      if options.useEvent is true
        
        #This is what happens when you actually click a button
        constructedFunction = (e) ->
          
          #Check the callback function
          if options.valid(_this, e) is true
            callTrackEvent()
            options.complete _this, e
        
        #E.g. if we are going to click on a link
        _this.bind options.event, constructedFunction
      else
        
        #Otherwise just track immediately (e.g. if we just came from a post-back)
        callTrackEvent()

) jQuery