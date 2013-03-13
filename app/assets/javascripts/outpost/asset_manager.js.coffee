##
# AssetManager
#
# For Managing Assets
class scpr.AssetManager
    DefaultOptions:
        jsonInput: "#asset_json"

    #----------

    constructor: (assets, el, options={}) ->
        _.extend @, Backbone.Events
        @options = _.defaults options, @DefaultOptions
        @el = $(el)

        @assets     = new scpr.AssetHost.Assets(assets)
        @assetsView = new scpr.AssetManager.Assets(collection: @assets)
        
        @el.html @assetsView.el
        
        # Register listener for AssetHost message
        window.addEventListener "message", (event) =>
            # If the data is an object (i.e. not "LOADED"), do things
            if _.isObject(event.data)
                @assets.reset(event.data)
                @assets.sort()
                @assetsView.render()
                @updateInput()
        , false

    #----------
        
    updateInput: ->
        $(@options.jsonInput).val(JSON.stringify(@assets.simpleJSON()))
        
    #----------
    
    @Asset: Backbone.View.extend
        tagName: "li"
        template: JST['outpost/templates/asset']
        
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
        events: "click a.popup": "_popup"
        
        initialize: ->
            @_views = {}
            
            @collection.bind "reset", => 
                view.detach() for view in @_views
                @_views = {}
                
            @collection.bind 'add', (f) => 
                @_views[f.cid] = new scpr.AssetManager.Asset
                    model: f
                
                @renderCollection()

            @collection.bind 'remove', (f) => 
                $(@_views[f.cid].el).detach()
                delete @_views[f.cid]
                @renderCollection()
            
            # attach a listener to wait for the LOADED message
            window.addEventListener "message", (evt) => 
                if evt.data == "LOADED" and @chooserIsAvailable()
                    console.log @collection.toJSON()
                    # dispatch our event with the asset data
                    window.assethostChooser.postMessage @collection.toJSON(), assethost.SERVER
            , false

            @render()
        
        #----------

        chooserIsAvailable: ->
            window.assethostChooser and !window.assethostChooser.closed

        #----------
        
        _popup: (event) ->
            event.originalEvent.stopPropagation()
            event.originalEvent.preventDefault()
            
            popup =
                url:     "#{assethost.SERVER}/a/chooser"
                name:    "chooser"
                options: "height=620,width=1000,scrollbars=1"
            
            if @chooserIsAvailable()
                window.assethostChooser.focus()
            else
                window.assethostChooser = window.open(popup.url, popup.name, popup.options)
            
            false
            
        #----------
        # Render the full view. This should only be called once.
        render: ->
            @$el.html JST['outpost/templates/asset_manager']
            @collectionEl = $(".collection", @$el)
            @emptyNotification = new scpr.Notification(
                @collectionEl, 
                "info", 
                "There are no assets. Click the button to open AssetHost."
            )
            
            @renderCollection()
            @
            
        #----------
        # Render the collection. This gets called every time AssetHost send a message.
        renderCollection: ->
            if @collection.isEmpty()
                return @emptyNotification.render()
                
            @collection.each (asset, index) =>
                asset.set(ORDER: index)

                @_views[asset.cid] ?= new scpr.AssetManager.Asset
                    model: asset
            
            views = _(@_views).sortBy (a) => a.model.get("ORDER")
            @collectionEl.html( _(views).map (v) -> v.el )
            @
