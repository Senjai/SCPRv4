class scpr.ContentBaseAPI.MultiSelector
    DefaultOptions:
        finder: ""
    
    constructor: (options) ->
        @options = _.defaults options, @DefaultOptions
        
        @elements = []
        @active = null
        
        @idx = 0
    
        # current search
        @string = null
        @matches = null
                
        # register click listeners on our finder elements
        _($(@options.finder)).each (el) =>
            elobj = id:@idx++, el:el, opts:null
            
            $("li",el).on "click", (evt) =>
                # capture the click so it doesn't get through to the container el
                evt.stopPropagation()
            
            # attach a click handler
            $(el).on "click", (evt) =>
                evt.stopPropagation()
                @activate(elobj)
                
                
        # attach key handler
        $(window).bind "keydown", (evt) => @_keyhandler(evt)
                
        # and finally, one click listener for outside to handle deactivation
        $(window).on "click", (evt) =>
            console.log "deactivating ", @active
            @deactivate(@active) if @active
    
    #----------
                
    activate: (el) ->
        return true if el == @active
        
        @deactivate(@active) if @active
        
        console.log "activating ", el
        # have we already built an options hash for this element?        
        if !el.opts
            console.log "building opts"
            el.opts = @_buildElementOptions el.el
            
        # note the selection...
        $(el.el).addClass "active"
        
        @active = el
        
    #----------
    
    deactivate: (el) ->
        $(el.el).removeClass "active"
        $(".match", el.el).removeClass "match"
        
        @string = null
        @matches = null
        @active = null
        
    #----------
    
    _keyhandler: (evt) ->
        # short-circuit if we aren't active
        return true if !@active
                
        if 65 <= evt.which <= 90
            console.log "keypress is ", evt
            char = String.fromCharCode evt.which
            @string = (@string||"") + char
            
            # deselect all matches
            _(@matches).each (el,text) -> $(el).parent().removeClass("match")
            
            test = ///^\s*#{@string}///i
            # now select anything that matches our new string
            m = {}
            _(@matches || @active.opts).each (el,text) ->
                # does the text match our string?
                if test.test(text)
                    # put this into matches
                    m[ text ] = el 
                    
                    # and highlight it
                    # el is the input itself, so highlight on the parent label
                    $(el).parent().addClass("match")
                
            # matches?
            @matches = m unless _(m).isEmpty()
            console.log "matches is ", @matches, m, _(m).isEmpty(), @string
            
        else if evt.which == 13
            # select our matches
            $(_(@matches).values()).prop("checked",true) if @matches
            @matches = null
            @string = null
            
        else if evt.which == 27
            # escape... clear our selection string and matches
            console.log "in escape handler"
            _(@matches).each (el,text) -> $(el).parent().removeClass "match"
            @matches = null
            @string = null
            
        return true
    
    #----------
        
    _buildElementOptions: (el) ->
        opts = {}
        
        # find all labels under this el
        for label in $("label",el)
            # and there should be an input in here as well
            input = _($("input",label)).first()
            opts[ $(label).text() ] = input
            
        return opts
        
