##
# PublishingUI
#
# Show/hide Publishing fields based on status.
# Also renders messages based on status
#
class outpost.PublishingUI extends outpost.PublishingHelper
    constructor: (@options={}) ->
        super
        
        # Alerts
        @alerts =
            willPublish:    new outpost.Notification(@notifications, "warning", "This content <strong>will be published</strong> immediately.")
            isPublished:    new outpost.Notification(@notifications, "success", "This content is <strong>published</strong>")
            willUnpublish:  new outpost.Notification(@notifications, "danger", "<strong>Warning!</strong> This content <strong>will be unpublished</strong> immediately.")
            
        # Notify the scheduled status
        @originalStatus = @setStatus() # also sets @status
        @hideFields() # Hidden by default.
        @notify()

    #----------

    notify: ->
        @clearAlerts()
        
        # No need to run these methods more than once
        isPublished = @isPublished()
        wasPublished = @wasPublished()
        
        # Show the fields if it's published.
        @showFields() if isPublished
        
        # All the different scenarios
        # Already published
        if isPublished and wasPublished
            @showFields()
            return @alert 'isPublished'
            
        # Publishing
        if isPublished and !wasPublished
            @hideFields()
            return @alert 'willPublish'
        
        # Unpublishing
        if !isPublished and wasPublished
            @hideFields()
            return @alert 'willUnpublish'
