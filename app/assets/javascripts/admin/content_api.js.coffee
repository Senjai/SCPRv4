#= require scprbase

class scpr.ContentAPI
    @Content: Backbone.Model.extend {}
    
    @ContentCollection: Backbone.Collection.extend
        url: "/api/content/"
        model: @Content
