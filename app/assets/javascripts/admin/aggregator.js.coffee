#= require scprbase
#= require admin/content_api
#= require jquery-ui-1.8.23.custom.min.js

##
# scpr.Aggregator
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
    constructor: (@el, contentJson) ->
        @baseView = new scpr.Aggregator.Views.Base(collection: contentJson)
        $(@el).html @baseView.render()
        
    #----------------------------------
    
    class scpr.Aggregator.Views
        # The skeleton for the the different pieces!
        @Base: Backbone.View.extend
            template: JST['admin/templates/aggregator/base']
            
            initialize: ->
                @render()
                @dropZone      = new scpr.Aggregator.Views.DropZone(collection: @collection, el: $("#aggregator-dropzone"))
                @recentContent = new scpr.Aggregator.Views.RecentContentList(el: $("#aggregator-search"))
                
            render: ->
                #
        
        
        #----------------------------------
        # The drop-zone!
        # Gets filled with ContentFull views
        @DropZone: Backbone.View.extend
            initialize: ->
                # Do lots of things
                
            render: ->
                # Do lots more things


        #----------------------------------
        # A single piece of content in the drop zone!
        # Full with lots of information
        @ContentFull: Backbone.View.extend
            tag: 'li'
            template: JST['admin/templates/aggregator/content_full']
        
            initialize: ->
                # Do we need this function?
                
            render: ->
                @$el.html @template(content: @model)
        
    
        #----------------------------------
        # The RecentContent list!
        # Gets filled with ContentMinimal views
        @RecentContent: Backbone.View.extend
            tag: 'ul'

            initialize: ->
                # Grab Recent Content using ContentAPI
                # Render the list
                
            render: ->
                #
        
        
        #----------------------------------
        # A single piece of recent content!
        # Just the basic info
        @ContentMinimal: Backbone.View.extend
            tag: 'li'
            template: JST['admin/templates/aggregator/content_small']
            
            initialize: ->
                # Do we need this function?
                
            render: ->
                @$el.html @template(content: @model)
    