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
        # The skeleton for the the different pieces!
        @Base: Backbone.View.extend
            template: JST['admin/templates/aggregator/base']
            
            #---------------------
            
            initialize: ->
                $ ->
                    $("#js-content-search-input")
                
                @
            
            #---------------------
            
            render: ->
                # Build the skeleton. We'll fill everything in next.
                @$el.html @template
                
                # Setup the Drop Zone section
                # then render it
                @dropZone = new scpr.Aggregator.Views.DropZone
                    collection: @collection # The stuff that was already associated with the object when the page loaded
                $("#aggregator-dropzone", @$el).html @dropZone.el
                @dropZone.render()
                
                # Setup the search/find section
                @recentContent = new scpr.Aggregator.Views.RecentContent()
                $("#aggregator-recent-content", @$el).html @recentContent.el
                
                @
                
                
        #----------------------------------
        # The drop-zone!
        # Gets filled with ContentFull views
        @DropZone: Backbone.View.extend
            tagName: 'ul'
            attributes:
                class: "drop-zone"
                
            #---------------------
                
            initialize: ->
                @
                
            #---------------------
            
            render: ->
                @$el.empty()
                
                @collection.each (model) =>
                    view = new scpr.Aggregator.Views.ContentFull
                        model: model
                    @$el.append view.render()
                
                @


        #----------------------------------
        # The RecentContent list!
        # Gets filled with ContentMinimal views
        @RecentContent: Backbone.View.extend
            tagName: 'ul'
            attributes:
                class: "content-list"

            #---------------------

            initialize: ->
                # Grab Recent Content using ContentAPI
                # Render the list
                @collection = new scpr.ContentAPI.ContentCollection()
                @populate()

            #---------------------
        
            populate: ->
                @collection.fetch
                    data:
                        limit: 10
                    success: (collection, response, options) =>
                        @render()
        
            #---------------------
        
            render: ->
                @$el.empty()

                @collection.each (model) =>
                    view = new scpr.Aggregator.Views.ContentMinimal
                        model: model
                    @$el.append view.render()
                
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
        
