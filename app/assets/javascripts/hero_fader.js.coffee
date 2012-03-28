#= require scprbase

# Hero fader
class scpr.HeroFader
    DefaultOptions:
        activeClass: 'active'
        lastActiveClass: "last-active"
        slide: '#events-header .slides-wrapper .slide'
        chooser: ".chooser"
        slideId: 'data-slide'
        fadeSpeed: 2000
        fadeInterval: 8000

    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend options||{}

        $(@options.chooser).on
            click: (event) =>
                @slideSwitch $("#"+$(event.target).attr(@options.slideId))
        
        @fadeQueue()

    slideSwitch: (next) ->
        # Immediately complete any animations that are running right now and clear the animation queue
        $(@options.slide).stop(true, true) # args: clearQueue, jumpToEnd

        # Figure out which slide is active
        $active = $(@options.slide + "." + @options.activeClass)
        $active = if $active.length then $active else $(@options.slide + ':last')
        
        # Figure out which slide is next
        $next = next or (if $active.next().length then $active.next() else $(@options.slide + ':first'))
        
        # Don't do anything if the user clicked on the chooser for the slide that they're already on
        if $next[0] isnt $active[0]
            # Clear the timeout incase we clicked a button in the middle of one
            clearTimeout(@fader)

            # Hightlight the chooser for the active slide
            $(@options.chooser + "[#{@options.slideId}='#{$next.attr("id")}']").addClass("active")
            $(@options.chooser + "[#{@options.slideId}='#{$active.attr("id")}']").removeClass("active")

            # Now fade in the next slide on top of the last-active slide
            $active.css({opacity: 1.0}).addClass(@options.lastActiveClass).animate({opacity: 0.0}, @options.fadeSpeed)
            $next.css({opacity: 0.0}).addClass(@options.activeClass).animate({opacity: 1.0}, @options.fadeSpeed, =>
                $active.removeClass @options.activeClass + " " + @options.lastActiveClass
            )

            # Set the time until the next fade
            @fadeQueue()

    fadeQueue: ->
        @fader = setTimeout (=> 
            @slideSwitch()
        ), @options.fadeInterval
