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
#   find content by searching, selecting
#   from the recent content, or dropping in a URL.
#
class scpr.Aggregator

    #---------------------
    
    defaults:
        apiType: "public"
        params: {}
        viewOptions: {}
        
    constructor: (el, json, options={}) ->
        @options = _.defaults options, @defaults
        
        @el = $(el)
        
        # Set the type of API we're dealing with
        apiClass = if @options.apiType is "public" then "ContentCollection" else "PrivateContentCollection"
        
        @baseView = new scpr.Aggregator.Views.Base _.extend options.view || {},
            el: @el
            collection: new scpr.ContentAPI[apiClass](json)
            apiClass: apiClass
            params: @options.params
            viewOptions: @options.viewOptions
            
        @baseView.render()
        
        
    #----------------------------------
    # Views!
    class @Views
        #----------------------------------
        # The skeleton for the the different pieces!
        class @Base extends Backbone.View
            template: JST['admin/templates/aggregator/base']
            defaults:
                active: "recent"
                    
            #---------------------
        
            initialize: ->
                @options = _.defaults @options, @defaults
                
                # @foundCollection is the collection for all the content
                # in the RIGHT panel.
                @foundCollection = new scpr.ContentAPI[@options.apiClass]()
        
            #---------------------
            # Import a URL and turn it into content
            # Let the caller handle what happens after the request
            # via callbacks
            importUrl: (url, callbacks={}) ->
                $.getJSON("#{scpr.PUBLIC_API_ROOT}/content/by_url", { url: url })
                   .success((data, textStatus, jqXHR)      -> callbacks.success?(data))
                   .error((jqXHR, textStatus, errorThrown) -> callbacks.error?(jqXHR))
                   .complete((jqXHR, status)               -> callbacks.complete?(jqXHR))

                true
                
            #---------------------
            
            render: ->
                # Build the skeleton. We'll fill everything in next.
                @$el.html @template(active: @options.active)
                            
                # Build each of the tabs
                @recentContent = new scpr.Aggregator.Views.RecentContent(base: @)
                @search        = new scpr.Aggregator.Views.Search(base: @)
                @url           = new scpr.Aggregator.Views.URL(base: @)
                
                # Build the Drop Zone section
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
                
                # Setup the container, render the template,
                # and then add in the el (the list)
                @container = $(@container)
                @container.html @template
                @container.append @$el
                @helper = $("<h1 />").html("Drop Content Here")
                
                @updateInput()
                @render()
                
                # Register listeners for URL droppage
                @dragOver = false
                @$el.on "dragenter", (event)  => @_dragEnter(event)
                @$el.on "dragleave", (event)  => @_dragLeave(event)
                @$el.on "dragover", (event)   => @_dragOver(event)
                @$el.on "drop", (event)       => @importUrl(event)
                
                
                # Listeners for @collection events triggered
                # by Backbone
                @collection.bind "add remove reorder", =>
                    @checkDropZone()
                    @setPositions()
                    @updateInput()
                    
                # DropZone callbacks!!
                sortIn  = true
                dropped = false
                
                @$el.sortable
                    cursor: "move"
                    # When dragging (sorting) starts
                    start: (event, ui) ->
                        sortIn  = true
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
                    # Before placeholder disappears
                    beforeStop: (event, ui) =>
                        dropped = true
                        
                    # When an item from another list is dropped into this
                    # DropZone
                    # Move it from there to DropZone.
                    receive: (event, ui) =>
                        dropped = true
                        # If we're able to move it in, Remove the dropped 
                        # element because we're rendering the bigger, better one.
                        # Otherwise, revert the el back to the original element.
                        if @move(ui.item)
                            ui.item.remove()
                        else
                            $(ui.item).effect 'highlight', color: "#f2dede", 1500
                            $(ui.sender).sortable "cancel"
                            
                    # When dragging (sorting) stops, only for items
                    # in the original list.
                    # Update the position attribute for each
                    # model
                    #
                    # If !sortIn (i.e. if we're dragging something out
                    # of the DropZone), then remove that item. A trigger
                    # on @collection.remove() will re-sort the models.
                    #
                    # If we stopped but sortIn is true, then it means
                    # we have just re-ordered the elements in the UI,
                    # so we manually trigger a "reorder" event.
                    stop: (event, ui) =>
                        if !sortIn
                            ui.item.remove()
                            @remove(ui.item)
                        else
                            @collection.trigger "reorder"

            #---------------------

            _stopEvent: (event) ->
                event.preventDefault()
                event.stopPropagation()
                
            #---------------------
            # When an element enters the zone
            _dragEnter: (event) ->
                @_stopEvent event
                @$el.addClass('dim')
                
            #---------------------
            # dragleave has child element problems
            # When you hover over a child element,
            # a dragleave event is fired.
            # So we need to set a small delay to allow
            # dragover to show dragleave what's up.
            _dragLeave: (event) ->
                @dragOver = false
                setTimeout =>
                    @$el.removeClass('dim') if !@dragOver
                , 50

                @_stopEvent event
                
            #---------------------
            # When an element is in the zone and not yet released
            # Get continuously and rapidly fired when hovering with
            # a droppable item.
            # Set dragOver to true to stop dragleave from messing it up
            _dragOver: (event) ->
                @dragOver = true
                @_stopEvent event
                
            #---------------------
            # Proxy to @base.importUrl
            # Grabs the dropped-in URL, passes it on
            # Also does some animations and stuff
            importUrl: (event) ->
                @_stopEvent event

                @container.spin()
                url = event.originalEvent.dataTransfer.getData('text/uri-list')
                alert = {}
                
                @base.importUrl url, 
                    success: (data) =>
                        if data
                            @buildFromData(data)
                            alert = new scpr.Notification(@$el, "success", 
                                "<strong>Success!</strong> Imported #{data.id}")
                        else
                            alert = new scpr.Notification(@$el, "error", 
                                "<strong>Failure.</strong> Invalid URL (#{url})")
                        
                    error: (jqXHR) =>
                        alert = new scpr.Notification(@$el, "error", 
                            "<strong>Error.</strong> Try the Search tab.")
                    
                    # Run this no matter what.
                    # It just turns off the bells and whistles
                    complete: (jqXHR) =>
                        @importNotice(alert)
                        @container.spin(false)
                        @$el.removeClass('dim')
                
                return false # prevent default behavior

            #---------------------
            # Give a JSON object, build a model, and its corresponding
            # ContentFull view for the DropZone,
            # then append it to @el and @collection
            buildFromData: (data) ->
                model = new scpr.ContentAPI.Content(data)

                view = new scpr.Aggregator.Views.ContentFull _.extend @base.options.viewOptions,
                    model: model

                @$el.append view.render()

                # Add the new model to @collection
                @collection.add model
                    
            #---------------------
            # Alert the user that the URL drag-and-drop failed or succeeded
            # Receives a Notification object
            importNotice: (notification) ->
                notification.prepend()
                
                setTimeout ->
                    notification.fadeOut()
                , 5000
                
            #---------------------
            # Moves a model from the "found" section into the drop zone.
            # Converts its view into a ContentFull view.
            move: (el) ->
                id = el.attr("data-id")
                
                # Get the model for this DOM element
                # and add it to the DropZone
                # collection
                model = @base.foundCollection.get id
                # If the model is already in @collection, then
                # let the user know and do not import it
                # Otherwise, set the position and add it to the collection
                if not @collection.get id
                    @collection.add model
                    view = new scpr.Aggregator.Views.ContentFull _.extend @base.options.viewOptions,
                        model: model
                        
                    el.replaceWith view.render()
                else
                    alert = new scpr.Notification(@$el, "warning", 
                        "That content is already in the drop zone.")
                    @importNotice(alert)
                    false
                
            #---------------------
            # Remove this el's model from @collection
            # This is the only case where we want to 
            # actually remove a view from @base.childViews
            remove: (el) ->
                id    = el.attr("data-id")
                model = @collection.get id
                @collection.remove model
            
            #---------------------
            # Go through the li's and find the corresponding model.
            # This is how we're able to save the order based on
            # the positions in the DropZone.
            # Returns a new Backbone Collection.
            setPositions: ->
                for el in $("li", @$el)
                    el    = $ el
                    id    = el.attr("data-id")
                    model = @collection.get id
                    model.set "position", el.index()
                
            #---------------------
            
            checkDropZone: ->
                if @collection.isEmpty()
                    @_enableDropZoneHelper()
                else
                    @_disableDropZoneHelper()
                    
            _enableDropZoneHelper: ->
                @$el.addClass('empty')
                @$el.append @helper
            
            _disableDropZoneHelper: ->
                @$el.removeClass('empty')
                @helper.detach()
                
            #---------------------
            # Update the JSON input with current collection
            updateInput: ->
                $("#content_json").val(JSON.stringify(@collection.simpleJSON()))

            #---------------------
                
            render: ->
                @$el.empty()
                @checkDropZone()

                # For each model, create a new model view and append it
                # to the el
                @collection.each (model) =>
                    view = new scpr.Aggregator.Views.ContentFull _.extend @base.options.viewOptions,
                        model: model
                        
                    @$el.append view.render()

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
                @base     = @options.base
                @page     = 1
                @per_page = @base.options.params.limit || 10
                
                # Grab Recent Content using ContentAPI
                # Render the list
                @collection = new scpr.ContentAPI[@base.options.apiClass]()
                
                # Add just the added model to @base.foundCollection
                @collection.bind "add", (model, collection, options) =>
                    @base.foundCollection.add model
                
                # Add the reset collection to @base.foundCollection
                @collection.bind "reset", (collection, options) =>
                    @base.foundCollection.add collection.models
                
                @container  = $(@container)
                @container.html @$el
                @render()
                
            #---------------------
            # Get the page from the DOM
            # Proxy to #request to setup params
            changePage: (event) ->
                page = parseInt $(event.target).attr("data-page")
                @request(page: page) if page > 0
                false # To prevent the link from being followed

            #---------------------
            # Fire the actual request to the server
            # Also handles transitions
            fetch: (params) ->
                @transitionStart()
                
                @collection.fetch
                    data: _.defaults params, @base.options.params
                    success: (collection, response, options) =>
                        # If the collection length is > 0, then 
                        # call @renderCollection().
                        # Otherwise render a notice that no results
                        # were found.
                        if collection.length > 0
                            @renderCollection()
                        else
                            @alertNoResults()
                        
                        # Set the page and re-render the pagination
                        @renderPagination(params, collection)
                        
                    error: (collection, xhr, options) =>
                        @alertError(xhr: xhr)
                .always => @transitionEnd()
                
                # Return the collection
                @collection

            #---------------------
            # Use this when the aggregator is thinking!
            # Adds spin and dimming effects
            transitionStart: ->
                @resultsEl.addClass('dim')
                @$el.spin(top: 100)

            #---------------------
            # Use this when the aggregator is done thinking!
            # Removes spin and dimming effects
            transitionEnd: ->
                @resultsEl.removeClass('dim')
                @$el.spin(false)
                
            #---------------------
            # Render a notice if the server returned an error
            alertError: (options={}) ->
                xhr = options.xhr
                
                _.defaults options,
                    el: @resultsEl
                    type: "error"
                    message: @errorTemplate(xhr: xhr)
                    method: "replace"
                    
                alert = new scpr.Notification(options.el, 
                    options.type, options.message)
                    
                alert[options.method]()

            #---------------------
            # Render a notice if no results were returned
            alertNoResults: (options={}) ->
                _.defaults options,
                    el: @resultsEl
                    type: "notice"
                    message: "No results"
                    method: "replace"
                    
                alert = new scpr.Notification(options.el, 
                    options.type, options.message)
                    
                alert[options.method]()
            
            #---------------------
            # Fill in the @resultsEl with the model views
            renderCollection: ->
                @resultsEl.empty()
                
                @collection.each (model) =>
                    view = new scpr.Aggregator.Views.ContentMinimal
                        model: model
                        
                    @resultsEl.append view.render()
                
                @$el

            #---------------------
            # Re-render the pagination with new page values,
            # and set @page.
            #
            # If the passed-in length is less than the requested 
            # limit, then assume that we reached the end of the 
            # results and disable the "Next" link
            renderPagination: (params, collection) ->
                @page = params.page
                
                # Add in the pagination
                # Prefer blank classes over "0" for consistency
                # parseInt(null) and parseInt("") both return null
                # null compared to any number is always false
                $(".aggregator-pagination", @$el).html @paginationTemplate
                    current: @page
                    prev: @page - 1 unless @page < 1
                    next: @page + 1 unless collection.length < params.limit

                @$el
                
            #---------------------
            # Render the whole section.
            # This should only be called once per page load.
            # Rendering of indivial collections is done with
            # @renderCollection().
            render: ->
                @$el.html @template
                @resultsEl = $(@resultsId, @$el)

                # Make the Results div Sortable
                @resultsEl.sortable
                    connectWith: "#aggregator-dropzone .drop-zone"
                    cursor: "move"

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
                    limit: @per_page
                    page: 1
                    query: ""
                
                @fetch(params)
                false # To keep consistent with Search#request

                
        #----------------------------------
        # SEARCH?!?!
        # This view is the entire Search section. It it made up of 
        # smaller "ContentMinimal" views
        #
        # Note that because of the Input field and pagination, 
        # the list of content is actually stored in @resultsEl, not @el
        #
        # @render() is for rendering the full section.
        # Use @renderCollection for rendering just the search results.
        class @Search extends @ContentList
            container: "#aggregator-search"
            resultsId: "#aggregator-search-results"
            template: JST["admin/templates/aggregator/search"]
            events:
                "click .pagination a": "changePage"
                "click button"       : "search"
            
            #---------------------
            # Just a simple proxy to #request to fill in the args properly
            # Can't make the event delegate straigh to #request because
            # Backbone automatically passes the event object as the
            # argument, but #request doesn't handle that.
            search: (event) ->
                @request()
                
            #---------------------
            # Sets up default parameters, and then proxies to #fetch
            request: (params={}) ->
                _.defaults params,
                    limit: @per_page
                    page: 1
                    query: $("#aggregator-search-input", @$el).val()
                
                @fetch(params)
                false # to keep the Rails form from submitting
                

        #----------------------------------
        # The URL Import view
        # Inherits from @ContentList but doesn't actually
        # need all of its goodies. That's okay.
        class @URL extends @ContentList
            container: "#aggregator-url"
            resultsId: "#aggregator-url-results"
            template: JST["admin/templates/aggregator/url"]
            events:
                "click button" : "fetch"

            #---------------------

            append: (model) ->
                view = new scpr.Aggregator.Views.ContentMinimal
                    model: model

                @resultsEl.append view.render()

                @$el
            
            #---------------------
            # Proxies to @base.importUrl
            # Also handles transitions
            fetch: (params) ->
                @transitionStart()
                
                input = $("#aggregator-url-input", @$el)
                url   = input.val()
                
                @base.importUrl url, 
                    success: (data) =>
                        # Returns null if no record is found
                        # If no data, alert the person
                        # Otherwise, turn it into a ContentMinimal view
                        # for easy dragging, and clear the input
                        if data
                            @collection.add data
                            @append @collection.get(data.id)
                            input.val("") # Empty the URL input
                        else 
                            @alertNoResults
                                method: "render"
                                message: "Invalid URL"
                    
                    error: (jqXHR)    => @alertError(xhr: jqXHR)
                    complete: (jqHXR) => @transitionEnd()
                        
                false # Prevent the Rails form from submitting

                
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
                @options = _.defaults @options, { template: @template }
                
            #---------------------

            render: ->
                @$el.html JST["admin/templates/aggregator/#{@options.template}"](content: @model.toJSON(), opts: @viewOptions)
                
        #----------------------------------
        # A single piece of content in the drop zone!
        # Full with lots of information
        class @ContentFull extends @ContentView
            attributes:
                class: "content-full"
            template: 'content_full'
            
        #----------------------------------
        # A single piece of recent content!
        # Just the basic info
        class @ContentMinimal extends @ContentView
            attributes:
                class: "content-minimal"
            template: 'content_small'

        #---------------------
