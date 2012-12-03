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
class scpr.Aggregator
    # The drop-zone
    @Aggregator: Backbone.View.extend
    
    # A single piece of content in the drop zone
    @ContentView: Backbone.View.extend
    
    # List of Recent content
    @RecentContentPanel: Backbone.View.extend
    
    # Recent content
    @RecentContentView: Backbone.View.extend
    
    # The Search panel!
    @SearchPanel: Backbone.View.extend
