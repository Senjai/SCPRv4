#= require scprbase
#= require admin/content_api
#= require jquery-ui-1.8.23.custom.min.js

##
# scpr.Aggregator (like Alligator but more G's)
#
# Hooks into ContentAPI to help YOU, our loyal
# customer, aggregate SCPR content for various
# purposes (eg. homepage, missed it buckets)
# 
# Made up of basically two parts:
# * The "DropZone", where content will be dropped
#   and sorted and generally managed.
#
# * The "Content Finder" area, where the user can easily
#   find content by either searching or selecting
#   from the recent content. More ways to find 
#   content will be added.
#
class scpr.Aggregator
    
    #---------------------
    
    constructor: (el, @contentJson) ->
        @el = $(el)
        @baseView = new scpr.Aggregator.Views.Base
            el: @el
            collection: new scpr.ContentAPI.ContentCollection(@contentJson)
            
        @baseView.render()
        
        
    #----------------------------------
    # Views!
    class @Views
        
        #----------------------------------
        # Some helper modules for you and me!
        # Use this one to render a basic collection into
        # any el
        @CollectionRenderer: 
            render: (args={}) ->
                el         = args.el
                collection = args.collection
                modelView  = args.modelView
                
                el.empty()
                
                collection.each (model) =>
                    view = new scpr.Aggregator.Views[modelView]
                        model: model
                    el.append view.render()
                
                el

            #---------------------
            # Use this when the aggregator is thinking!
            transitionStart: (args={}) ->
                spinEl = args.spinEl
                dimEl  = args.dimEl
                
                dimEl.css opacity: 0.3
                spinEl.spin(top: 100)
            
            #---------------------
            # Use this when the aggregator is done thinking!
            transitionEnd: (args={}) ->
                spinEl = args.spinEl
                dimEl  = args.dimEl
                
                dimEl.css opacity: 1
                spinEl.spin(false)
                
                
        #----------------------------------
        # The skeleton for the the different pieces!
        @Base: Backbone.View.extend
            template: JST['admin/templates/aggregator/base']
            
            #---------------------
            
            initialize: ->
                @
            
            #---------------------
            
            render: ->
                # Build the skeleton. We'll fill everything in next.
                @$el.html @template
                
                # Setup the Drop Zone section
                @dropZone = new scpr.Aggregator.Views.DropZone
                    collection: @collection # The bootstrapped content
                
                # Setup the search/find section
                @recentContent = new scpr.Aggregator.Views.RecentContent()
                @search        = new scpr.Aggregator.Views.Search()
                
                @
                
                
        #----------------------------------
        # The drop-zone!
        # Gets filled with ContentFull views
        @DropZone: Backbone.View.extend
            container: "#aggregator-dropzone"
            tagName: 'ul'
            attributes:
                class: "drop-zone"
                
            #---------------------
                
            initialize: ->
                $(@container).html @$el
                @render()
                
            #---------------------
            
            render: ->
                scpr.Aggregator.Views.CollectionRenderer.render
                    collection: @collection
                    modelView: "ContentFull"
                    el: @$el
                
                @


        #----------------------------------
        # The RecentContent list!
        # Gets filled with ContentMinimal views
        @RecentContent: Backbone.View.extend
            container: "#aggregator-recent-content"
            tagName: 'ul'
            attributes:
                class: "content-list"

            #---------------------

            initialize: ->
                # Grab Recent Content using ContentAPI
                # Render the list
                @collection = new scpr.ContentAPI.ContentCollection()
                @container  = $(@container)
                @container.html @$el
                
                @transitionOpts =
                    spinEl: @container
                    dimEl: @$el
                    
                @populate()
                
            #---------------------
        
            populate: ->
                scpr.R.transitionStart @transitionOpts
                
                @collection.fetch
                    data:
                        limit: 10
                    success: (collection, response, options) =>
                        scpr.R.transitionEnd @transitionOpts
                        @render()
        
            #---------------------
        
            render: ->
                scpr.Aggregator.Views.CollectionRenderer.render
                    collection: @collection
                    modelView: "ContentMinimal"
                    el: @$el
                    
                @
        

        #----------------------------------
        # SEARCH?!?!
        @Search: Backbone.View.extend
            container: "#aggregator-search"
            template: JST["admin/templates/aggregator/search"]
            attributes:
                class: "form-search"
            events: 
                "click button": "search"
                
            initialize: ->
                @collection = new scpr.ContentAPI.ContentCollection()
                @container  = $(@container)
                @container.html @$el
                @render()
                
            #---------------------
            # Search!
            search: (event) ->
                scpr.R.transitionStart @transitionOpts
                query = $("#aggregator-search-input", @$el).val()
                
                @collection.fetch
                    data: 
                        query: query
                    success: (collection, response, options) =>
                        scpr.R.transitionEnd @transitionOpts
                        @_renderCollection()
                        
                        
                # Have to prevent the form from being actually submitted
                # when the "Enter" key is pressed!
                # Note that the "form" in this case is the actual
                # form for the content (eg. Homepage or Missed It Bucket)
                false
                
            #---------------------
            
            render: ->
                @$el.html @template
                @resultsEl = $("#aggregator-search-results", @$el)
                @transitionOpts =
                    spinEl: @$el
                    dimEl: @resultsEl
                @
                
            #---------------------
                
            _renderCollection: ->
                scpr.R.render
                    collection: @collection
                    modelView: "ContentMinimal"
                    el: @resultsEl
                
                @
            
        #----------------------------------
        # A single piece of content in the drop zone!
        # Full with lots of information
        @ContentFull: Backbone.View.extend
            tagName: 'li'
            template: JST['admin/templates/aggregator/content_full']
        
            #---------------------
        
            render: ->
                @$el.html @template(content: @model.toJSON())
                
        
        #----------------------------------
        # A single piece of recent content!
        # Just the basic info
        @ContentMinimal: Backbone.View.extend
            tagName: 'li'
            template: JST['admin/templates/aggregator/content_small']
            
            #---------------------
            
            render: ->
                @$el.html @template(content: @model.toJSON())
        
        #---------------------

# Shortcuts!!!!!!!!
# Before: scpr.Aggregator.Views.CollectionRenderer.render()
# After:  scpr.R.render()
scpr.R = scpr.Aggregator.Views.CollectionRenderer
