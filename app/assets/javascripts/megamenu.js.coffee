#= require scprbase

class scpr.MegaMenu
    DefaultOptions:
        finder: "#megamenu .mega a"
        attr:   "data-section"
        
    #----------
        
    constructor: (items,options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend( options || {} )
        
        @sections = {}
        
        # master control for animations
        @expanded = 0
                
        $(@options.finder).each (idx,el) =>
            # for each section link, attach mouseover / mouseout listeners
            el = $(el)
            if el.attr(@options.attr)
                sec = 
                    item: el
                    drop: $("##{el.attr(@options.attr)}")
                    score: 0
                    selected: false
                    func: _.debounce (=> @_score(sec)), 50
                    
                # stash a copy
                @sections[ el.attr(@options.attr) ] = sec
                
                el.mouseover =>                     
                    sec.score += 1
                    sec.func()

                el.mouseout =>                 
                    sec.score -= 1
                    sec.func()
                
                sec.drop.mouseover => 
                    sec.score += 1
                    sec.func()

                sec.drop.mouseout =>
                    sec.score -= 1
                    sec.func()
                    
    _score: (sec) ->
        console.log "_score for #{sec.drop.attr('id')}: #{sec.score} (master: #{@expanded})"
        if sec.score > 0 && !sec.selected
            # show section
            sec.selected = true
            sec.item.addClass("hover")
            
            if @expanded
                sec.drop.show()
            else
                sec.drop.fadeIn(100)
                
        else if sec.score == 0 && sec.selected
            # hide section
            sec.selected = false
            sec.item.removeClass("hover")
            
            if @expanded == 1
                @expanded -= 1
                sec.drop.fadeOut("fast")
            else
                sec.drop.hide()