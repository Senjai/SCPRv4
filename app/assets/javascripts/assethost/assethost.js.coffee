#= require scprbase
#= require assethost/assethostbase
#= require backbone

class scpr.AssetHost
    @Asset: Backbone.Model.extend
        urlRoot: "#{assethost.SERVER}/api/assets/"
        
        url: ->
            url = if @isNew() then @urlRoot else @urlRoot + encodeURIComponent(@id)
            
            if assethost.TOKEN
                url = url + "?" + $.param(auth_token:assethost.TOKEN)
                
            url
            
        #----------
        
        chopCaption: (count=100) ->
            chopped = @get('caption')

            if chopped and chopped.length > count
                regstr = "^(.{#{count}}\\w*)\\W"
                chopped = chopped.match(new RegExp(regstr))

                if chopped
                    chopped = "#{chopped[1]}..."
                else
                    chopped = @get('caption')

            chopped


    #----------

    @Assets: Backbone.Collection.extend
        model: @Asset
        
        # If we have an ORDER attribute, sort by that.  Otherwise, sort by just 
        # the asset ID.  
        comparator: (asset) ->
            asset.get("ORDER") || -Number(asset.get("id"))
        
        #----------
