class scpr.Presentation
    DefaultOptions:
        el:         ".presentation"
        cardsEl:    ".cards"
        card:       ".card"
        active:     ".active"
        lastActive: ".last-active"
        choosersEl: ".pager-nav"
        chooser:    ".chooser"
        nextprev:   true
        cardId:     "data-card"        
        interval:   "10000"
        fadeSpeed:  "1000"
        wait:       true # Fade Out, then Fade in vs. Fade in on top
        
    #------------
        
    constructor: (options) ->
        @options  = _(_({}).extend(@DefaultOptions)).extend options || {}
        
        @activeClass     = @extractName @options.active
        @lastActiveClass = @extractName @options.lastActive
        
        @interval  = @options.interval
        @fadeSpeed = @options.fadeSpeed
        @cardId    = @options.cardId
        
        $ =>
            @el         = $ @options.el
            @cardsEl    = @el.find(@options.cardsEl)
            @cards      = @cardsEl.find(@options.card)

            # Set the last card to active, so we can "switch to" the first one
            @cards.first().addClass(@activeClass)

            # No need to do anything else if there is only one card
            if @cards.length > 1
                @active = @cardsEl.find(@options.active)

                # Setup choosers
                @choosersEl = @el.find(@options.choosersEl).first()

                # If a choosers wrapper wasn't manually created, make one
                if !@choosersEl[0]
                    @choosersEl = $("<div/>", class: @extractName(@options.choosersEl))
                    @el.append @choosersEl

                # For each card in the presentation, create a chooser for it
                _(@cards).each (card, idx) =>
                    chooser = $("<span/>", class: @extractName(@options.chooser)).html(idx + 1)
                    chooser.attr @cardId, $(card).attr("id")
                    @choosersEl.append chooser

                @prevChooser = $("<a/>", class: @extractName(@options.chooser) + " prev")
                @nextChooser = $("<a/>", class: @extractName(@options.chooser) + " next")
                @prevChooser.attr(@cardId, "")
                @nextChooser.attr(@cardId, "")
                @choosersEl.prepend @prevChooser
                @choosersEl.append  @nextChooser
                @chooser = @choosersEl.find(@options.chooser)
                
                @switchTo @active

                # Register click event for choosers
                @chooser.on
                    click: (event) =>
                        event.preventDefault()
                        if !$(event.target).hasClass("disabled")
                            cardId = $(event.target).attr(@cardId)
                            @switchTo($ "##{cardId}")
    
    extractName: (str) ->
        if str.substring(0,1) in ['.', '#']
            str.substring 1
        else
            str

    #------------

    queue: ->
        @timer = setTimeout => 
            @switchTo @findNext()
        , @interval

    #------------
    
    findNext: ->
        if @active.next().length then @active.next() else @cards.first()
        
    #------------

    setActiveChooser: (el) ->
        chooser = @choosersEl.find(@options.chooser, @options.active)
        chooser.removeClass(@activeClass)
        $("#{@options.chooser}[#{@cardId}='#{el.attr("id")}']").addClass(@activeClass)

        @prevChooser.attr(@cardId, el.prev().attr("id") or "")
        @nextChooser.attr(@cardId, el.next().attr("id") or "")

        _([@nextChooser, @prevChooser]).each (nav) =>
            if nav.attr(@cardId) is ""
                nav.addClass("disabled")
            else
                nav.removeClass("disabled")
        
    #------------

    pushBack: (active) ->
        active.show()
        .addClass(@lastActiveClass)
        .removeClass(@activeClass)
    
    
    _fadeIn: (next) ->
        next.hide()
        .addClass(@activeClass)
        .fadeIn @fadeSpeed, =>
            @active.hide().removeClass(@lastActiveClass)
            @active = next
    
    #------------

    switchTo: (cardEl) ->
        @next?.stop true, true
        @next = cardEl
        clearTimeout @timer
        @setActiveChooser @next
        
        if @next[0] isnt @active[0]
            @pushBack @active
            
            if @options.wait
                @active.fadeOut @fadeSpeed, => @_fadeIn(@next)
            else
                @_fadeIn @next

        @queue()
