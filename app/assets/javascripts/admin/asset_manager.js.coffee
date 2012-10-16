#= require scprbase

##
# scpr.AssetThumbnail
#
# One Asset thumbnail in the CMS
#
class scpr.AssetThumbnail
    options:
        assetTemplate: JST['admin/templates/asset']
        fieldsPrefix:  "#asset-fields-"
        destroyEl:     ".destroy-bool"
        destroyField:  "input[type=checkbox][name*='[_destroy]']"
        infoEl:       ".asset-info"
        thumbnailEl:  ".thumbnail"
    
    constructor: (attributes) ->
        # Setup attributes
        _(_.keys(attributes)).each (key) =>
            @[key] = attributes[key]
        
        # Setup elements
        @el           = $ @options.assetTemplate(asset: @)
        @thumbnailEl  = $ @options.thumbnailEl, @el
        @infoEl       = $ @options.infoEl, @el
        
        @fieldsEl     = $ "#{@options.fieldsPrefix}#{@content_asset_id}"
        @destroyEl    = $ @options.destroyEl, @fieldsEl
        @destroyField = $ @options.destroyField, @fieldsEl

        # Move the hidden fields into the thumbnail,
        # Just to keep everything together.
        @thumbnailEl.append @fieldsEl.detach()
        
        # Register listener for Destroy button click
        @destroyField.on
            click: (event) =>
                if $(event.target).is(':checked')
                    @dim @infoEl
                else
                    @brighten @infoEl
        
    render: (el) ->
        el.append @el
        
    dim: (el) ->
        el.addClass("transparent")
    
    brighten: (el) ->
        el.removeClass("transparent")
        
#-----------------

##
# scpr.AssetManager
# 
# The block that contains the Asset Management tools
#
class scpr.AssetManager
    DefaultOptions:
        el:         "#asset_bucket .thumbnails"
        deleteBtn:  ".delete"
        
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
        
        @_loadAssets assets
        @_renderAssets()

    #---------------
    # Render the assets into the asset bucket
    _renderAssets: ->
        for asset in _.pairs(@assets)
            asset[1].render(@el)
            
    #---------------
    # Load the asset thumbnails into @assets
    _loadAssets: (assets) ->
        for asset in assets
            @assets[asset.content_asset_id] = new scpr.AssetThumbnail(asset)