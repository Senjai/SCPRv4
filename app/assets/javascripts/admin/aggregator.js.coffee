#= require scprbase
#= require admin/content_api
#= require jquery-ui-1.9.2.custom.min.js

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
            template: JST['admin/templates/aggregator/drop_zone']
            container: "#aggregator-dropzone"
            tagName: 'ul'
            attributes:
                class: "drop-zone well"
            
            #---------------------
                
            initialize: ->
                @container = $(@container)
                
                @container.html @template
                @container.append @$el
                @render()
                
                # DropZone callbacks!!
                sortIn   = true
                dropping = false
                
                @$el.sortable
                    cursor: "move"
                    # When dragging (sorting) starts
                    start: (event, ui) ->
                        sortIn   = true
                        dropping = false
                        ui.item.addClass("dragging")
                    
                    # Called whenever an item is moved and is over the
                    # DropZone.
                    over: (event, ui) ->
                        sortIn = true
                        ui.item.addClass("adding")
                        ui.item.removeClass("removing")
                    
                    # This one gets called both when the item moves out of
                    # the dropzone, AND when the item is dropped inside of
                    # the dropzone. I don't know why jquery-ui decided to
                    # make it this way, but we have to hack around it.
                    out: (event, ui) ->
                        # If this isn't a "drop" event, we can assume that
                        # the item was just moved out of the DropZone. 
                        if !dropping
                            sortIn = false
                            ui.item.addClass("removing")
                        
                        ui.item.removeClass("adding")
                    
                    # When dragging (sorting) stops, only if the item
                    # being dragged belongs to the original list
                    beforeStop: (event, ui) ->
                        dropping = true
                        ui.item.remove() if !sortIn
                    
                    # When an item from another list is dropped into this
                    # DropZone
                    receive: (event, ui) ->
                        dropping = true
                    
                    # When dragging (sorting) stops
                    stop: (event, ui) =>
                        @collection.add
                        
            #---------------------
            
            render: ->
                scpr.R.render
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
                
                # Make her sortable!
                @$el.sortable
                    connectWith: "#aggregator-dropzone .drop-zone"
                    cursor: "move"
                
                
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
                scpr.R.render
                    collection: @collection
                    modelView: "ContentMinimal"
                    el: @$el
                    
                @
        

        #----------------------------------
        # SEARCH?!?!
        # This view is the entire Search section. It it made up of smaller
        # "ContentMinimal" views
        #
        # Note that because of the Input field, the list of content is
        # actually stored in @resultsEl, not @el
        #
        # @render() is for rendering the full section.
        # Use @_renderCollection for rendering just the search results.
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
                        @renderCollection()
                        
                        
                # Have to prevent the form from being actually submitted
                # when the "Enter" key is pressed!
                # Note that the "form" in this case is the actual
                # form for the content (eg. Homepage or Missed It Bucket)
                false
                
            #---------------------
            
            render: ->
                @$el.html @template
                @resultsEl = $("#aggregator-search-results", @$el)
                
                # Make the Results div Sortable
                @resultsEl.sortable
                    connectWith: "#aggregator-dropzone .drop-zone"
                    cursor: "move"
                
                @transitionOpts =
                    spinEl: @$el
                    dimEl: @resultsEl
                @
                
            #---------------------
                
            renderCollection: ->
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
            attributes:
                class: "content-full"
            template: JST['admin/templates/aggregator/content_full']
        
            #---------------------
        
            initialize: ->
                @
                
            render: ->
                @$el.html @template(content: @model.toJSON())
                
        
        #----------------------------------
        # A single piece of recent content!
        # Just the basic info
        @ContentMinimal: Backbone.View.extend
            tagName: 'li'
            attributes:
                class: "content-minimal"
            template: JST['admin/templates/aggregator/content_small']
            
            #---------------------

            initialize: ->
                @
                
            #---------------------
            
            render: ->
                @$el.html @template(content: @model.toJSON())
        
        #---------------------

# Shortcuts!!!!!!!!
# Before: scpr.Aggregator.Views.CollectionRenderer.render()
# After:  scpr.R.render()
scpr.R = scpr.Aggregator.Views.CollectionRenderer
