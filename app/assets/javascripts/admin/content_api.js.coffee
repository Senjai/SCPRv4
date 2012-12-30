#= require scprbase

class scpr.ContentAPI

    #-----------------------------

    @Content: Backbone.Model.extend
        #----------
        # simpleJSON is an object of just the attributes
        # we care about for SCPRv4. Everything else will
        # filled out server-side.
        simpleJSON: ->
            {
                id:       @get 'id'
                position: @get 'position'
            }
    
    #-----------------------------
    
    @ContentCollection: Backbone.Collection.extend
        url: "/api/content/"
        model: @Content

        #----------
        # Sort by position attribute
        comparator: (model) ->
            model.get 'position'
            
        #----------
        # An array of content turned into simpleJSON. See
        # Content#simpleJSON for more.
        simpleJSON: ->
            contents = []
            @each (content) -> contents.push(content.simpleJSON())
            contents
