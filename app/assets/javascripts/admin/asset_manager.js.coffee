#= require scprbase

class scpr.Asset
    assetTemplate: JST['admin/templates/asset']
        
    constructor: (attributes) ->
        _(_.keys(attributes)).each (key) =>
            @[key] = attributes[key]
            
    render: (el, i) ->
        el.append @assetTemplate(asset: @, i: i)
        
#-----------------

class scpr.AssetManager
    DefaultOptions:
        el:            "#asset_bucket .thumbnails"
        
        assetAttr:
          id:      "asset_id"
          caption: "caption"
          order:   "asset_order"
        
        assethost:
            token:  "droQQ2LcESKeGPzldQr7"
            server: "http://ahhost.dev"
            prefix: "/api"
    
    constructor: (assets, options) ->
        @options   = _.defaults options||{}, @DefaultOptions
        @assethost = @options.assethost
        
        @el     = $ @options.el
        @assets = {}
        
        # Load the assets into the collection
        for asset in assets
            @assets[asset.id] = new scpr.Asset(asset)

        # Render the assets
        i=0
        for asset in _.pairs(@assets)
            asset[1].render(@el, i)
            i++
            
        # Listeners
    