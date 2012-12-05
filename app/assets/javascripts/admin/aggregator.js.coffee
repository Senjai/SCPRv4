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
                el         = args.el             # Where to place the collection
                collection = args.collection     # The collection of models
                modelView  = args.modelView      # The view to render a model in
                views      = args.viewCollection # The collection of views to add to
                
                # Empty the el, since we're just replacing the collection
                el.empty()
                
                # For each model, create a new model view and append it
                # to the el
                # If we were given a views object, place the model into
                # that as well
                collection.each (model) =>
                    view = new scpr.Aggregator.Views[modelView]
                        model: model
                    el.append view.render()
                    views?[model.id] = view
                
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
        #----------------------------------
        # The skeleton for the the different pieces!
        class @Base extends Backbone.View
            template: JST['admin/templates/aggregator/base']
        
            #---------------------
        
            initialize: ->
                # childViews is how we're going to meaningfully share 
                # views between all of the different areas. 
                @childViews = {}
        
            #---------------------
        
            render: ->
                # Build the skeleton. We'll fill everything in next.
                @$el.html @template
                            
                # Setup the search/find section
                @recentContent = new scpr.Aggregator.Views.RecentContent(base: @)
                @search        = new scpr.Aggregator.Views.Search(base: @)
            
                # Setup the Drop Zone section
                @dropZone = new scpr.Aggregator.Views.DropZone
                    collection: @collection # The bootstrapped content
                    base: @
                @
                
                
        #----------------------------------
        # The drop-zone!
        # Gets filled with ContentFull views
        class @DropZone extends Backbone.View
            template: JST['admin/templates/aggregator/drop_zone']
            container: "#aggregator-dropzone"
            tagName: 'ul'
            attributes:
                class: "drop-zone well"
            
            #---------------------
                
            initialize: ->
                @base = @options.base
                
                @container = $(@container)
                @container.html @template
                @container.append @$el
                
                @render()
                
                # DropZone callbacks!!
                sortIn   = true
                dropped = false
                
                @$el.sortable
                    cursor: "move"
                    # When dragging (sorting) starts
                    start: (event, ui) ->
                        sortIn   = true
                        dropped = false
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
                    out: (event, ui) =>
                        # If this isn't a "drop" event, we can assume that
                        # the item was just moved out of the DropZone.
                        #
                        # If that's the case, and the item was originally
                        # in the dropzone, then add the "removing" class
                        #
                        # If "drop event" is the case but the element came 
                        # from somewhere else, then don't add the "removing"
                        # class. 
                        if !dropped && ui.sender[0] == @$el[0]
                            sortIn = false
                            ui.item.addClass("removing")
                        
                        ui.item.removeClass("adding")
                    
                    # When dragging (sorting) stops, only if the item
                    # being dragged belongs to the original list
                    beforeStop: (event, ui) ->
                        dropped = true
                        ui.item.remove() if !sortIn
                    
                    # When an item from another list is dropped into this
                    # DropZone
                    receive: (event, ui) =>
                        dropped = true
                        @add(ui.item)
                        
                        # Remove the dropped element because we're rendering
                        # the bigger, better one.
                        ui.item.remove()
                        
                    # When dragging (sorting) stops
                    stop: (event, ui) ->
                        @
                        
            #---------------------
            # Adds a model to the collection, and adds a new
            # ContentFull view to the DropZone
            add: (el) ->
                id = el.attr("data-id")
                
                # Get the view for this DOM element
                # and add its model to the DropZone
                # collection
                model = @base.childViews[id].model
                @collection.add model
                
                # Render a ContentFull view using this model
                view = new scpr.Aggregator.Views.ContentFull
                    model: model
                el.replaceWith view.render()
                
            #---------------------
            
            render: ->
                scpr.R.render
                    collection: @collection
                    modelView: "ContentFull"
                    el: @$el
                    viewCollection: @base.childViews
                
                @


        #----------------------------------
        #----------------------------------
        # An abstract class from which the different
        # collection views should inherit
        class @ContentList extends Backbone.View
            paginationTemplate: JST["admin/templates/aggregator/_pagination"]
            errorTemplate: JST["admin/templates/aggregator/error"]
            events: 
                "click .pagination a": "changePage"
                
            #---------------------

            initialize: ->
                @base = @options.base
                @page = 1

                # Grab Recent Content using ContentAPI
                # Render the list
                @collection = new scpr.ContentAPI.ContentCollection()

                @container  = $(@container)
                @container.html @$el

                @render()
                
            #---------------------
            # Get the page from the DOM
            # Proxy to #request to setup params
            changePage: (event) ->
                page = parseInt $(event.target).attr("data-page")
                @request(page: page) if page > 0
                false

            #---------------------
            # Fire the actual request to the server
            # Also handles transitions
            fetch: (params) ->
                scpr.R.transitionStart @transitionOpts
                
                @collection.fetch
                    data: params
                    success: (collection, response, options) =>
                        scpr.R.transitionEnd @transitionOpts

                        # We successfully retrieved the content,
                        # So we can set @page to the requested page
                        # and render the collection (including
                        # the pagination)
                        @page = params.page
                        @renderCollection()
                    error: (collection, xhr, options) =>
                        scpr.R.transitionEnd @transitionOpts
                        
                        alert = new scpr.Notification(@resultsEl,
                            "error", @errorTemplate(xhr: xhr))
                        alert.render()
                        
            #---------------------
            # Fill in the @resultsEl with the model views
            renderCollection: ->
                scpr.R.render
                    collection: @collection
                    modelView: "ContentMinimal"
                    el: @resultsEl
                    viewCollection: @base.childViews

                # Add in the pagination
                $(".aggregator-pagination", @$el).html @paginationTemplate
                    current: @page
                    prev: @page - 1
                    next: @page + 1

                @
                
            #---------------------

            render: ->
                @$el.html @template
                @resultsEl = $(@resultsId, @$el)

                # Make the Results div Sortable
                @resultsEl.sortable
                    connectWith: "#aggregator-dropzone .drop-zone"
                    cursor: "move"

                @transitionOpts =
                    spinEl: @$el
                    dimEl: @resultsEl

                @

        #----------------------------------
        # The RecentContent list!
        # Gets filled with ContentMinimal views
        #
        # Note that because of Pagination, the list of content is
        # stored in @resultsEl, not @el
        class @RecentContent extends @ContentList
            container: "#aggregator-recent-content"
            resultsId: "#aggregator-recent-content-results"
            template: JST['admin/templates/aggregator/recent_content']
            
            #---------------------
            # Need to populate right away for Recent Content
            initialize: ->
                super
                @request()
                
            #---------------------
            # Sets up default parameters, and then proxies to #fetch
            request: (params={}) ->
                _.defaults params,
                    limit: 10
                    page: 1
                    query: ""
                
                @fetch(params)

                
        #----------------------------------
        # SEARCH?!?!
        # This view is the entire Search section. It it made up of 
        # smaller "ContentMinimal" views
        #
        # Note that because of the Input field and pagination, 
        # the list of content is actually stored in @resultsEl, not @el
        #
        # @render() is for rendering the full section.
        # Use @_renderCollection for rendering just the search results.
        class @Search extends @ContentList
            container: "#aggregator-search"
            resultsId: "#aggregator-search-results"
            template: JST["admin/templates/aggregator/search"]
            attributes:
                class: "form-search"
            events:
                "click .pagination a": "changePage"
                "click button"       : "search"
            
            #---------------------
            # Just a simple proxy to #request to fill in the args properly
            search: (event) ->
                @request()
                
            #---------------------
            # Sets up default parameters, and then proxies to #fetch
            request: (params={}) ->
                _.defaults params,
                    limit: 10
                    page: 1
                    query: $("#aggregator-search-input", @$el).val()
                
                @fetch(params)
                false # to keep the Rails form from submitting
                

        #----------------------------------
        #----------------------------------
        # An abstract class from which the different
        # representations of a model should inherit
        class @ContentView extends Backbone.View
            tagName: 'li'
            
            #---------------------
        
            initialize: ->
                # Add the model ID to the DOM
                # We have to do this so that we can share content
                # between the lists.
                @$el.attr("data-id", @model.id)
            
            #---------------------

            render: ->
                @$el.html @template(content: @model.toJSON())
                
        #----------------------------------
        # A single piece of content in the drop zone!
        # Full with lots of information
        class @ContentFull extends @ContentView
            attributes:
                class: "content-full"
            template: JST['admin/templates/aggregator/content_full']
                
        
        #----------------------------------
        # A single piece of recent content!
        # Just the basic info
        class @ContentMinimal extends @ContentView
            attributes:
                class: "content-minimal"
            template: JST['admin/templates/aggregator/content_small']

        #---------------------

# Shortcuts!!!!!!!!
# Before: scpr.Aggregator.Views.CollectionRenderer.render()
# After:  scpr.R.render()
scpr.R = scpr.Aggregator.Views.CollectionRenderer
