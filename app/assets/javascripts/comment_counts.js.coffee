class scpr.CommentCounts
	DefaultOptions:
        finder: ".commentcountjs"
        attr:   "data-objkey"
        url:    "/api/comments"
        counts: null
        
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
            
        @elements = ($ el for el in $ @options.finder)

        # collect the element keys
        @keys = (el.attr(@options.attr) for el in @elements)

        if @options.counts
            @_populate @options.counts
            
    #----------
                
    update: ->
        # fire an async request 
        $.getJSON @options.url, { ids: @keys.join(',') }, (res) => @_populate(res)
        true
            
    #----------
                
    _populate: (res) ->
        for el in @elements
            if obj = res[ el.attr(@options.attr) ]
                count = Number(obj.comments||0)
                if count
                    console.log "setting count on #{obj.obj_key} to #{count}"
                    el.text "Comments (#{count})"