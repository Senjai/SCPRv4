#= require scprbase
#= require asset_host_core/models

class scpr.AssetManager
    DefaultOptions:
        el: ""
        preview: true

    #----------

    constructor: (assets, options={}) ->
        _.extend @, Backbone.Events
        @options = _.defaults options, @DefaultOptions

        @assets = new scpr.AssetManager.Assets(assetdata)
        
        @assetsView = new scpr.AssetManager.Assets(collection: @assets)
        $(@options.el).html @assetsView.el
        
        window.addEventListener "message", (evt) => 
            if evt.data != "LOADED"
                found = {}
                
                # reconcile our asset list to the returned list
                _(evt.data).each (a,i) =>
                    # do we have this asset?
                    if asset = @assets.get(a.id)
                        asset.set
                            caption: a.caption
                            ORDER: i
                    else
                        # no, needs to be added
                        asset = new scpr.AssetManager.Asset(a)
                        asset.fetch(success: (aobj)=>aobj.set({caption:a.caption,ORDER:i});@assets.add(aobj))
                    
                    found[ a.id ] = true
                
                # now check for removed assets
                remove = []
                @assets.each (a,i) => 
                    if found[a.get('id')]
                        # we're cool
                        console.log "found asset: ", a.get('id')
                    else
                        # not in our return list... delete
                        console.log "removing asset: ", a.get('id')
                        remove.push(a)
                        
                for a in remove
                    @assets.remove(a)
                    
                @assets.sort()
                @assetsView.render()
                    
                @trigger("assets",evt.data)
        , false
    
    #----------
    
    @Asset: Backbone.View.extend
        tagName: "li"
        attributes:
            class: "span2 asset"
        template: JST['admin/templates/asset']
        
        #----------
        
        initialize: ->
            @render()
            $el.attr("data-asset-url", @model.get 'api_url')
            @model.bind "change", => @render()

        #----------

        render: ->
            if @model.get('tags')                                                                                
                $el.html @template(asset:@model.toJSON())
                
            @
    
    #----------
    
    @Assets: Backbone.View.extend
        tagName: "ul"
        events: "click button": "_popup"
        
        initialize: ->
            @_views = {}
            
            @collection.bind "reset", => 
                $(view.el).detach() for view in @_views
                @_views = {}
                
            @collection.bind 'add', (f) => 
                @_views[f.cid] = new scpr.AssetManager.Asset
                    model: f
                    args:  @options.args
                    rows:  @options.rows
                
                @render()

            @collection.bind 'remove', (f) => 
                $(@_views[f.cid].el).detach()
                delete @_views[f.cid]
                @render()
            
            @render()
            
            #----------
            
            _popup: (event) ->
                event.originalEvent.stopPropagation()
                event.originalEvent.preventDefault()
                
                popup =
                    url:     "#{assethost.SERVER}/a/chooser"
                    name:    "chooser"
                    options: "height=620,width=1000,scrollbars=1"
                    
                newwindow = window.open popup.url, popup.name, popup.options
                
                # attach a listener to wait for the LOADED message
                window.addEventListener "message", (evt) => 
                    if evt.data == "LOADED"
                        # dispatch our event with the asset data
                        newwindow.postMessage @collection.toJSON(), assethost.SERVER
                , false
                
                return false
                
            #----------
            
            render: ->
                @collection.each (asset) => 
                    @_views[asset.cid] ?= new scpr.AssetManager.Asset
                        model: asset
                        args:  @options.args
                        rows:  @options.rows
                
                views = _(@_views).sortBy (a) => a.model.get("ORDER")
                $(@el).html( _(views).map (v) -> v.el )
                
                $(@el).append( $("<li/>").html( $('<button/>',{text:"Pop Up Asset Chooser"})))
                                                
                @
