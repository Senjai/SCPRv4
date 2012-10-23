#= require scprbase

##
# scpr.AssetThumbnail
#
# An Asset thumbnail in the CMS
#
class scpr.AssetThumbnail
    options:
        assetTemplate: JST['admin/templates/asset']
        fieldsPrefix:  "#asset-fields-"
        destroyEl:     ".destroy-bool"
        destroyField:  "input[type=checkbox][name*='[_destroy]']"
        infoEl:       ".asset-info"
        thumbnailEl:  ".thumbnail"
    
    constructor: (@attributes) ->
        # Setup attributes
        _(_.keys(attributes)).each (key) =>
            @[key] = @attributes[key]
        
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
    
    toJSON: ->
        @attributes
        
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
            token:       "droQQ2LcESKeGPzldQr7"
            server:      "http://ahhost-scpr.dev"
            chooserPath: "/a/chooser"
            
    constructor: (assets, options) ->
        @options   = _.defaults options||{}, @DefaultOptions
        @assethost = @options.assethost
        
        @el         = $ @options.el
        @collection = {}
        
        @button = $("<button />", id: "asset-chooser").html("Popup Asset Chooser")
        @el.prepend @button
        
        @button.on
            click: (event) =>
                @_popup(event)
                
        @_loadAssets assets
        @_renderAssets()

    #---------------
    # Return an array of objects turned into JSON
    toJSON: ->
        collection = []
        for asset in @collection
            collection.push asset.toJSON
        collection
        
    #---------------
    # Render the assets into the asset bucket
    _renderAssets: ->
        for asset in _.pairs(@collection)
            asset[1].render(@el)
            
    #---------------
    # Load the asset thumbnails into @assets
    _loadAssets: (assets) ->
        for asset in assets
            @collection[asset.content_asset_id] = new scpr.AssetThumbnail(asset)

    _popup: (event) ->
        event.originalEvent.stopPropagation()
        event.originalEvent.preventDefault()
        newwindow = window.open("#{@assethost.server}#{@assethost.chooserPath}", 'chooser', 'height=620,width=1000,scrollbars=1')
        
        # attach a listener to wait for the LOADED message
        window.addEventListener "message", (event) => 
            if event.data == "LOADED"
                # dispatch our event with the asset data
                newwindow.postMessage @toJSON(), @assethost.server
        , false
                            
        return false
        