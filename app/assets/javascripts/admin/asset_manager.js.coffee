#= require scprbase
#= require assethost/assethost

class scpr.AssetManager
    DefaultOptions:
        jsonInput: "#asset_json"

    #----------

    constructor: (assets, el, options={}) ->
        _.extend @, Backbone.Events
        @options = _.defaults options, @DefaultOptions

        @assets     = new scpr.AssetHost.Assets(assets)
        @assetsView = new scpr.AssetManager.Assets(collection: @assets)
        
        $(el).html @assetsView.el
        
        # Register listener for AssetHost message
        window.addEventListener "message", (event) =>
            # If the data is an object (or not "LOADED"), do things
            if _.isObject(event.data)
                @assets.reset(event.data)
                @assets.sort()
                @assetsView.render()
                $(@options.jsonInput).val(JSON.stringify(@assets.simpleJSON()))
        , false
        
    
    #----------
    
    @Asset: Backbone.View.extend
        tagName: "li"
        template: JST['admin/templates/asset']
        
        #----------
        
        initialize: ->
            @render()
            @model.bind "change", => @render()

        #----------

        render: ->
            if @model.get('tags')
                @$el.html @template(asset: @model.toJSON())
                
            @
    
    #----------

    @Assets: Backbone.View.extend
        tagName: "ul"
        events: "click button": "_popup"
        
        initialize: ->
            @_views = {}
            
            @collection.bind "reset", => 
                @$el.detach() for view in @_views
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
            @$el.html( _(views).map (v) -> v.el )
            
            button = $('<button/>', style: "margin: 0 20px;", text: "Pop Up Asset Chooser")
            title  = $('<h4/>', text: "Assets").append button
            @$el.prepend title
            @
            