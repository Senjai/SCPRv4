#= require scprbase
#= require assethost/assethostbase
#= require backbone

##
# AssetHost
# Models for AssetHost API interaction
#
class scpr.AssetHost
    @Asset: Backbone.Model.extend
        urlRoot: "#{assethost.SERVER}/api/assets/"
        
        simpleJSON: ->
            {
                id:          @get 'id'
                caption:     @get 'caption'
                asset_order: @get 'ORDER'
            }
        
        #--------------
        
        url: ->
            url = if @isNew() then @urlRoot else @urlRoot + encodeURIComponent(@id)
            
            if assethost.TOKEN
                token = $.param(auth_token:assethost.TOKEN)
                url += "?#{token}"
                
            url
            
    #----------

    @Assets: Backbone.Collection.extend
        model: @Asset
        
        # If we have an ORDER attribute, sort by that.
        # Otherwise, sort by just the asset ID.
        comparator: (asset) ->
            asset.get("ORDER") || -Number(asset.get("id"))
        
        #----------
        # This is for passing on to the server
        # We only need to pass a few attributes,
        # not the entire asset JSON.
        simpleJSON: ->
            assets = []
            @each (asset) -> assets.push(asset.simpleJSON())
            assets
                
        #----------
