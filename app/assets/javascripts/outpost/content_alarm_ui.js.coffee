##
# ContentAlarmUI
#
# Show/hide ContentAlarm fields based on status.
# Also renders messages based on status & timestamp
#
class scpr.ContentAlarmUI extends scpr.PublishingHelper
    constructor: (@options={}) ->
        super
        
        @datetimeField = @container.find("input.datetime") # The actual datetime input 
        
        # Alerts
        @alerts =
            isScheduled:    new scpr.Notification(@notifications, "success", "This content is <strong>scheduled</strong> to be published.")
            isNotScheduled: new scpr.Notification(@notifications, "info", "This content is <strong>not scheduled</strong> to be published.")

        # Notify the scheduled status
        @originalStatus = @setStatus() # also sets @status
        @hideFields() # Hidden by default.
        @setTimestamp()
        @notify()
        
        # Event for when the timestamp field is changed
        @datetimeField.on
            update: (event) => 
                @setTimestamp()
                @notify()

    #----------
    # Set @timestamp to the current value of the timestamp field
    setTimestamp: ->
        @timestamp = @datetimeField.val()

    #----------

    notify: ->
        @clearAlerts()
        
        timestampFilled = !_.isEmpty(@timestamp)
        isPending       = @isPending()
        isPublished     = @isPublished()
        
        # Show the fields if it's pending.
        if isPending then @showFields() else @hideFields()
        
        # When it IS scheduled
        if isPending and timestampFilled
            return @alert 'isScheduled'
        
        # When it ISN'T scheduled
        if isPending and !timestampFilled
            return @alert 'isNotScheduled'
        
        # This one assumes that the PublishingUI script
        # will let the user know about Publishing Immediately.
        if !isPending and !isPublished and timestampFilled
            @hideFields()
            return @alert 'isNotScheduled'
