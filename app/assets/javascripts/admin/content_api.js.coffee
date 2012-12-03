#= require scprbase

class scpr.ContentAPI
    @Content: Backbone.Model.extend
        
    @ContentCollection: Backbone.Model.extend
        url: "/api/content/"
    
    
    class @Query
        template: JST['admin/templates/content']
        
        constructor: (@el, options={}) ->
            @query = options.query || ""
            @limit = options.limit || ""
            @types = options.types || ""
        
        fetch: ->
            $.ajax
                type: "GET"
                data_type: "json"
                url: "/api/content"
                data:
                    query: @query
                    limit: @limit
                    types: @types
                success: (data, status, xhr) =>
                    @el.html @template(content: data)
                
    # A wrapper around Query to fetch recent content
    class @Recent
        constructor: (@el, options={}) ->
            @query = ""
            @limit = 20
            @types = "" # rely on server-side default for now
        
        # Proxy to Query#fetch
        fetch: ->
            query = new scpr.Content.Query @el,
                query: @query
                limit: @limit
                types: @types
            
            query.fetch()
        