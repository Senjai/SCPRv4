class scpr.Slideshow
    @TemplatePath = "slideshow/templates/"

    DefaultOptions:
        el:         "#photo"
        deeplink:   false
        title: "Slideshow"
        
    constructor: (options={}) ->
        @options = _.defaults options, @DefaultOptions
        
        # add in events
        _.extend(this, Backbone.Events)

        $ => 
            # -- get our parent element -- #
            @el = $ @options.el
    
            # -- create asset collection -- #
            @assets = new Slideshow.Assets @options.assets
            @total  = @assets.length

            # Set the starting slide.
            # We only want to work with the slide's index internally to avoid confusion.
            # If the requested slide is in between 0 and the total slides, use it
            # Otherwise just go to slide 0
            @start      = 0 # default starting position
            @deeplink   = @options.deeplink

            if @deeplink
                startingSlide = Number(@options.start)
                if startingSlide > 0 and startingSlide <= @total
                    @start = startingSlide - 1


            #----------
            # Create the elements we need for the complete slideshow
            @overlayNav = new Slideshow.OverlayNav
                start:  @start
                total:  @total

            @slides = new Slideshow.Slides
                collection:     @assets
                start:          @start
                wrapper:        @el

            @slides.overlayNav = @overlayNav
            @overlayNav.slides = @slides

            @thumbtray = new Slideshow.Thumbtray
                collection: @assets
                start:      @start
            

            # Setup Header elements
            @header = $ JST[Slideshow.TemplatePath + 'header']
                title: @options.title

            @nav = new Slideshow.NavigationLinks 
                start:  @start
                total:  @total

            @traytoggler = new Slideshow.ThumbtrayToggler
                thumbtray:  @thumbtray

            @fullscreenButton = JST[Slideshow.TemplatePath + 'fullscreen_button']
                target: $(@el).attr('id')


            #----------
            # Fill in the main element with all the pieces
            @el.append @header
            @header.append @nav.el
            @header.append @traytoggler.el
            
            @el.append      @thumbtray.el
            @el.append      @slides.el
            
            #----------
            # Render the elements
            @traytoggler.render()
            @nav.render()
            @slides.render()

            #----------
            # bind slides and nav together
            # Click on a nav button, send switchTo() to Slides
            @nav.bind           "switch", (idx) =>
                @slides.switchTo idx
                
            @overlayNav.bind    "switch", (idx) =>
                @slides.switchTo idx

            @thumbtray.bind     "switch", (idx) =>
                @slides.switchTo idx
            
            # switchTo() emits "switch" on slides, which sends setCurrent()
            # to those who need it. Also emits "switch" on Slideshow for
            # Google Analytics
            @slides.bind        "switch", (idx) =>
                @nav.setCurrent        idx
                @overlayNav.setCurrent idx
                @slides.setCurrent     idx
                @thumbtray.setCurrent  idx
                @trigger "switch",     idx

                # Chrome won't let you change the history while in fullscreen mode,
                # so we'll just have to disable it in that case.

                if @deeplink and window.history.replaceState and !@fullscreenActive()
                    slideNum = idx + 1
                    window.history.replaceState { slide: slideNum }, document.title + ": Slide #{slideNum}", window.location.pathname + "?slide=#{slideNum}"

            #----------
            # Keyboard Navigation
            @hasmouse = false
            $(window).on 
                keydown: (e) =>
                    if @hasmouse
                        # is this a keypress we care about?
                        switch e.keyCode
                            when 37 then @slides.switchTo(@slides.current - 1)
                            when 39 then @slides.switchTo(@slides.current + 1)

            #----------
            # Show/Hide targets on mouseover/mouseout
            @el.on
                mouseenter: (e) =>
                    if @hasmouse is false
                        @hasmouse = true

                mouseleave: (e) =>
                    if @hasmouse is true
                        @hasmouse = false

            # Handle the fullscreen clickage
            $("button.slideshow-fullscreen").on
                click: (event) =>
                    el = $($(event.target).data('target'))[0]
                    
                    el.requestFullScreen?() or 
                    el.mozRequestFullScreen?() or 
                    el.webkitRequestFullScreen?()


                    # Trigger all the goodies.
                    # Wait a second to let fullscreen finish fullscreening.
                    setTimeout =>
                        @slides.currentSlide().trigger "activated"
                    , 500

    canGoFullScreen: ->
        document.fullscreenEnabled or
        document.mozFullScreenEnabled or
        document.webkitFullscreenEnabled

    #----------

    fullscreenActive: ->
        document.fullscreenElement? or 
        document.mozFullScreenElement? or
        document.webkitFullscreenElement?

    #----------

    class @Asset extends Backbone.Model
        #

    class @Assets extends Backbone.Collection
        url: "/" # This is unneeded since we're never actually fetching anything
        model: Slideshow.Asset
        
    #----------
        

    class @Slides extends Backbone.View
        className: "slides asset-block"

        #----------

        initialize: ->
            @slides     = []
            @current    = @options.start
            @overlayNav = @options.overlayNav

       #----------

        switchTo: (idx) ->
            if idx >= 0 and idx <= @slides.length - 1
                @currentEl  = @currentSlide()
                @nextEl     = $ @slides[idx]

                @currentEl.stop(true, true).fadeOut 'fast', =>
                    @currentEl.removeClass 'active'
                    @trigger "switch", idx
                    @nextEl.addClass('active').fadeIn('fast')
                    @nextEl.trigger "activated"

        #----------

        currentSlide: ->
            $ @slides[@current]

        #----------

        setVerticalOffset: (slide) ->
            wrapper   = $(".media-wrapper", slide)
            img       = $("img", slide)

            imgWidth        = img.width()
            imgHeight       = img.height()
            wrapperWidth    = wrapper.width()
            wrapperHeight   = wrapper.height()

            # We can't use CSS to vertically center the images.
            # If this image is taller than its container,
            # then set a top of half of the height difference.
            if imgHeight < wrapperHeight
                heightDiff = wrapperHeight - imgHeight
                img.css top: heightDiff/2
            

        #----------

        setCurrent: (idx) ->
            @current = idx

        #----------

        render: ->
            $(".static-slides .slide", @options.wrapper).each (i, el) =>
                $(@el).append el

                if i == @options.start
                    $(el).addClass("active")

                @slides[i] = $(el)
            
            # And the overlay nav
            $(@el).append @overlayNav.el
            
            # Give the images time to start loading
            setTimeout () =>
                @overlayNav.showTargets()
            , 2000

    #----------
    
    class @Navigation extends Backbone.View
        initialize: ->
            @total      = @options.total
            @current    = @options.start
            @hasmouse   = false

        #----------

        setCurrent: (idx) ->
           @current = idx
           @render()

        #----------

        render: ->
            $(@el).html(@template
                count:      @current + 1
                total:      @total
                prev_class: @_activeIf @current > 0
                next_class: @_activeIf @current < @total - 1
            )

            @

        #----------

        _activeIf: (condition) ->
            if condition then "active" else "disabled"

        #----------

        _buttonClick: (event) ->
            target = $(event.target)

            if target.hasClass 'next'
                idx = @current + 1
            else if target.hasClass 'prev'
                idx = @current - 1
            
            if idx?
                @trigger "switch", idx


    #----------

    class @OverlayNav extends @Navigation
        className: "overlay-nav"

        events:
            'click .active':    "_buttonClick"
            "mouseenter":       "showTargets"
            "mouseleave":       "hideTargets"

        template: JST[Slideshow.TemplatePath + "overlay_nav"]

        #----------
        # Handle the hiding and showing of the buttons
        
        showTargets: ->
            if @hasmouse is false
                @hasmouse = true
                $(@el).stop(false, true).css(height: @_getTargetHeight())
                @render()
                $(@el).css opacity: 1
            
        hideTargets: ->
            if @hasmouse is true
                @hasmouse = false
                $(@el).stop(true, true).animate(opacity: 0, 'fast')

        #----------

        _getTargetHeight: ->
            $(@slides.el).find(".slide.active img").height()


    #----------
                
    class @NavigationLinks extends @Navigation
        className: "pager-nav"

        events:
            'click .active': '_buttonClick'

        template: JST[Slideshow.TemplatePath + "nav_links"]

    #----------

    class @ThumbtrayToggler extends Backbone.View
        className: 'thumbtray-toggler'
        
        events:
            'click':    '_toggleThumbTray'

        _toggleThumbTray: ->
            @options.thumbtray.toggle()
            $(@el).toggleClass 'active'

    #----------

    class @Thumbtray extends Backbone.View
        className: "thumbtray"

        events:
            "click .nav.active": "_buttonClick"

        options:
            per_page: 5

        template:
            prev: JST[Slideshow.TemplatePath + "thumb_nav_prev"]
            next: JST[Slideshow.TemplatePath + "thumb_nav_next"]

        #----------

        initialize: ->
            @per_page   = @options.per_page
            @current    = @options.start
            @visible    = false

            @thumbnailView = new Slideshow.ThumbnailsView
                collection: @collection
                per_page:   @options.per_page
                thumbtray:  @

            @thumbs    = @thumbnailView.thumbs

            @current_page   = @_pageForIdx @current
            @total_pages    = @_pageForIdx @thumbs.length - 1
            
            $(@el).html     @thumbnailView.el
            $(@el).prepend  @_prevTemplate()
            $(@el).append   @_nextTemplate()
            
        #----------
        
        setCurrent: (idx) ->
            @current = idx
            @thumbnailView.setCurrent idx

            page = @_pageForIdx idx
            if page isnt @current_page
                @switchTo page
            
        switchTo: (page) ->
            if page >= 1 and page <= @total_pages and page isnt @current_page
                @current_page = page
                $(@thumbnailView.el).stop(true, true).animate opacity: 0, 'fast', =>
                    @render()

        #----------

        toggle: ->
            if @visible then @hide() else @show()
            
        show: ->
            @current_page = @_pageForIdx @current
            @render()
            @thumbnailView.setCurrent @current
            $(@el).fadeIn()
            @visible = true

        hide: ->
            $(@el).fadeOut 75
            @visible = false

        #----------

        render: ->
            @thumbnailView.sliceThumbs @current_page
            @thumbnailView.render()

            @.$(".nav.prev").replaceWith @_prevTemplate()
            @.$(".nav.next").replaceWith @_nextTemplate()
            @
        
        #----------

        _prevTemplate: ->
            @template.prev
                prev_class: @_activeIf @current_page > 1

        _nextTemplate: ->
            @template.next
                next_class: @_activeIf @current_page < @total_pages

        _activeIf: (condition) ->
            if condition then "active" else "disabled"
            
        #----------

        _pageForIdx: (idx) ->
            Math.ceil (idx + 1) / @per_page

        #----------

        _buttonClick: (event) ->
            target = $(event.target)

            if target.hasClass 'next'
                page = @current_page + 1
            else if target.hasClass 'prev'
                page = @current_page - 1

            if page?
                @switchTo page
       
 
    #----------

    class @ThumbnailsView extends Backbone.View
        className: "thumbnails"
            
        initialize: ->
            @thumbs     = []
            @thumbidx   = 0
            @per_page   = @options.per_page

            @collection.each (asset,idx) => 
                thumb = new Slideshow.Thumbnail
                    model:      asset
                    index:      idx
                    thumbtray:  @options.thumbtray

                @thumbs[idx] = thumb
            
            _(@thumbs).each (thumb) =>
                $(@el).append thumb.render().el

        #----------

        setCurrent: (idx) ->
            @.$('.active').removeClass 'active'
            active = _(@thumbs).find (thumb) -> thumb.index is idx
            $(active.el).addClass 'active'
            
        #----------

        sliceThumbs: (page) ->
            start = (page - 1) * @per_page
            end   = start + @per_page
            @thumbSlice = @thumbs.slice start, end

        #----------

        render: ->
            @.$(".thumbnail").removeClass 'current-set'
            
            _(@thumbSlice).each (thumb) ->
                $(thumb.el).addClass 'current-set'
        
            $(@el).animate opacity: 1, 'fast'
            @


    #----------

    class @Thumbnail extends Backbone.View
        className: "thumbnail"

        events:
            'click': '_thumbClick'

        template: JST[Slideshow.TemplatePath + "thumbnail"]

        #----------

        initialize: ->
            @thumbtray  = @options.thumbtray
            @index      = @options.index
            
        #----------

        render: ->
            $(@el).html(@template
                url: @model.get("urls")['lsquare']
            )

            @

        #----------

        _thumbClick: (evt) ->
            @thumbtray.trigger "switch", @index
            
#----------
