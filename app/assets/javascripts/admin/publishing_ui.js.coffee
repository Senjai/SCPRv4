##
# Publishing UI
#
# Simple UI for showing/hiding the Published timestamp
# based on selected status
#
class scpr.PublishingUI
    Defaults:
        form:             "form.simple_form"
        containerEl:      ".publishing-fields"
        notificationEl:   ".notification#scheduled_status"
        statusSelect:     "select[id*=status]"
        datetimeField:    "input.datetime[name*='[published_at]']"
        statusPending:    "3"
        statusPublished:  "5"
    
    constructor: (options={}) ->
        @options = _.defaults options, @Defaults
        
        # Elements
        @form           = $ @options.form
        @container      = $ @options.containerEl,  @form
        @statusSelect   = $ @options.statusSelect, @form
        @notificationEl = $ @options.notificationEl, @form
        @datetimeField  = $ @options.datetimeField, @form
                
        @statusPending   = @options.statusPending
        @statusPublished = @options.statusPublished
                
        # Alerts
        @alerts =
            isScheduled:    new scpr.Notification(@notificationEl, "success", "This content is <strong>scheduled</strong> to be published.")
            isNotScheduled: new scpr.Notification(@notificationEl, "info", "This content is <strong>not scheduled</strong> to be published.")
            willPublish:    new scpr.Notification(@notificationEl, "warning", "This content <strong>will be published</strong> immediately.")
            isPublished:    new scpr.Notification(@notificationEl, "info", "This content is <strong>published</strong>")
            willUnpublish:  new scpr.Notification(@notificationEl, "danger", "<strong>Warning!</strong> This content <strong>will be unpublished</strong>.")
            
        # Notify the scheduled status
        @originalStatus = @setStatus() # also sets @status
        @hide() # Hidden by default.
        @setTimestamp()
        @notify()
        
        # Event for when the timestamp field is changed
        @datetimeField.on
            update: (event) => 
                @setTimestamp()
                @notify()
                
        # Event for when the status field is changed
        @statusSelect.on
            change: (event) =>
                @setStatus()
                @notify()
        
    #----------
    # Get the current status from the dropdown
    setStatus: ->
        @status = $("option:selected", @statusSelect).val()

    #----------
    # Set @timestamp to the current value of the timestamp field
    setTimestamp: ->
        @timestamp = @datetimeField.val()

    #----------
    # Convenience methods for finding original status
    wasPending: ->
        @originalStatus is @statusPending
    
    wasPublished: ->
        @originalStatus is @statusPublished
        
    #----------
    # Render the appropriate notification
    # Also handles hiding/showing of datetime fields
    notify: ->
        isPending   = @status is @statusPending
        isPublished = @status is @statusPublished
        wasPending   = @wasPending()
        wasPublished = @wasPublished()
        
        timestampFilled = !_.isEmpty(@timestamp)
        
        # Mass-Detach all of the alerts
        alert.detach() for name,alert of @alerts

        # Show the fields if it's pending.
        @show() if isPending
            
        # All the different scenarios
        # Already published
        if isPublished and wasPublished
            @show()
            return @alerts['isPublished'].render()
            
        # Publishing
        if isPublished and !wasPublished
            @hide()
            return @alerts['willPublish'].render()
        
        # Unpublishing
        if !isPublished and wasPublished
            return @alerts['willUnpublish'].render()
        
        # When it IS scheduled
        if isPending and timestampFilled
            return @alerts['isScheduled'].render()
        
        # When it ISN'T scheduled
        if isPending and !timestampFilled
            return @alerts['isNotScheduled'].render()
        
        if !isPending and timestampFilled
            @hide()
            return @alerts['isNotScheduled'].render()
            
    #----------
    
    show: ->
        @container.show()

    #----------

    hide: ->
        @container.hide()
