#= require scprbase

class scpr.MegaMenu
    DefaultOptions:
        finder: "#megamenu .mega a"
        attr:   "data-section"
        bucket: "#megamenu"
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
                _(@hidden).each (el) -> el.hide()
            
                sec.drop.fadeIn 100
                                
        else if sec.score == 0 && sec.selected
            # hide section
            sec.selected = false
            sec.item.removeClass("hover")
            
            if @expanded
                sec.drop.hide()
            else
                sec.drop.fadeOut("fast")
                # anything that should be hidden during displays?
                _(@hidden).each (el) -> el.show()
                
            
