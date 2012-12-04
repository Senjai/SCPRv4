#= require scprbase
#= require assethost/assethostbase

##
# AssetHost
# Models for AssetHost API interaction
#
class scpr.AssetHost
    @Asset: Backbone.Model.extend
        urlRoot: "#{assethost.SERVER}/api/assets/"

        #----------
        # simpleJSON is an object of just the attributes
        # we care about for SCPRv4. Everything else is
        # pulled from the AssetHost API.
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
        # An array of assets turned into simpleJSON. See
        # Asset#simpleJSON for more.
        simpleJSON: ->
            assets = []
            @each (asset) -> assets.push(asset.simpleJSON())
            assets
                
        #----------
