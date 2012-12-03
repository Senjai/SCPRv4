#= require scprbase
#= require admin/content_api
#= require jquery-ui-1.8.23.custom.min.js

class scpr.ContentAggregator
    defaults:
        el: "#content_aggregator"
        template: JST['admin/templates/content_panel']
        
    constructor: (options={}) ->
        @options = _.defaults options, @defaults
        @el = $ @options.el

        @el.html @options.template
        
        # Fetch recent content
        @recent = new scpr.Content.Recent($("#js-content-recent", @el))
        @recentContent = @recent.fetch()
        