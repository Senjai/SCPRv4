#= require scprbase

$ -> 
    $('.toggle-search').on
        click: ->
            $('.nav-primary').toggleClass('search-takeover')
            $('.nav-primary .search-form .search').focus()

class scpr.MegaMenu
    DefaultOptions:
        finder: "#megamenu .mega a"
        attr:   "data-section"
        bucket: "#mega-bucket"
        hidden: []
        
    #----------
        
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend( options || {} )
        
        @sections = []
        
        # master control for animations
        @expanded = 0
        
        @hidden = _(@options.hidden).map (el) -> $(el)
        
        @bucket = $ @options.bucket
                
        $(@options.finder).each (idx,el) =>
            # for each section link, attach mouseover / mouseout listeners
            el = $(el)
            if el.attr(@options.attr)
                sec = 
                    item: el
                    drop: $("##{el.attr(@options.attr)}")
                    score: 0
                    selected: false
                    positioned: false
                    func: _.debounce (=> @_score(sec)), 100
                    
                # stash a copy
                @sections.push = sec
                
                el.mouseover =>
                    sec.score += 1
                    #sec.func()
                    @_score(sec)
                    @expanded += 1

                el.mouseout =>
                    sec.score -= 1
                    #@_score(sec)
                    sec.func()
                    @expanded -= 1
                
                sec.drop.mouseover =>
                    sec.score += 1
                    #sec.func()
                    @_score(sec)
                    @expanded += 1

                sec.drop.mouseout =>
                    sec.score -= 1
                    sec.func()
                    #@_score(sec)
                    @expanded -= 1
                    
                # The following works sort-of. It still follows a link if you click it once, click somewhere else, and then click it again. It should show the menu again.
                $("body").on
                    touchstart: (event) =>
                        if sec.drop.is(":visible") and !$(event.target).is(sec.drop) and !$(event.target).closest(sec.drop).length
                            sec.score -= 1
                            sec.func()
                            @expanded -= 1
                    
                    
    _score: (sec) ->
        if sec.score > 0 && !sec.selected
            # show section
            sec.selected = true
            sec.item.addClass("hover")
            
            if !sec.positioned
                # move the section into our bucket
                @bucket.append sec.drop
            
            if @expanded
                # hide all other sections
                _(@sections).each (k,v) -> v.drop.hide()
                
                sec.drop.show()
            else
                # anything that should be hidden during displays?
                _(@hidden).each (el) -> el.css
                    visibility: "hidden"
            
                sec.drop.fadeIn 100
            
        else if sec.score == 0 && sec.selected
            # hide section
            sec.selected = false
            sec.item.delay(25).queue ->
                $(this).removeClass("hover")
                $(this).dequeue()
            
            if @expanded
                sec.drop.hide()
            else
                sec.drop.fadeOut("25")
                # show the stuff that was hidden during display
                _(@hidden).each (el) -> el.css
                    visibility: "visible"