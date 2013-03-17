##
# ContentAPI
#
# Interaction with the SCPR API
#
class scpr.ContentAPI

    #-----------------------------

    class @Content extends Backbone.Model
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
    
    class @ContentCollection extends Backbone.Collection
        url: "/api/content/"
        model: ContentAPI.Content
            
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

    #-----------------------------
    
    class @PrivateContentCollection extends @ContentCollection
        url: "/api/private/content"
        
    #-----------------------------
