##
# PublishingHelper
#
# Some shared code for rendering alerts, and toggling fields
#
class outpost.PublishingHelper
    statusPending:    "3"
    statusPublished:  "5"
    
    constructor: (@options={}) ->
        # Elements
        @form          = $ @options.form
        @container     = $ @options.container,     @form # Wrapper for the fields
        @statusField   = $ @options.statusField,   @form # Status select
        @notifications = $ @options.notifications, @form # Notification bucket

        # Event for when the status field is changed
        @statusField.on
            change: (event) =>
                @setStatus()
                @notify()
        
    #----------
    # Get the current status from the dropdown
    setStatus: ->
        @status = $("option:selected", @statusField).val()
    
    #----------
    # Helpers for finding current and original status
    isPending: ->
        @status is @statusPending
        
    isPublished: ->
        @status is @statusPublished
        
    wasPending: ->
        @originalStatus is @statusPending
        
    wasPublished: ->
        @originalStatus is @statusPublished
        
    #----------
    # Handles scenarios
    notify: ->
        # Override me

    #----------
    # Render the notification
    alert: (key) ->
        @alerts[key].render()
        
    #----------
    # Mass-Detach all of the alerts
    clearAlerts: ->
        alert.detach() for name,alert of @alerts

    #----------
    
    showFields: ->
        @container.show()

    #----------

    hideFields: ->
        @container.hide()
