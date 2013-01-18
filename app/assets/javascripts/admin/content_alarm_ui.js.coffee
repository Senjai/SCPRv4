##
# ContentAlarmUI
#
# The UI that helps figure out Content Alarms
#
class scpr.ContentAlarmUI
    DefaultOptions:
        form:             "form.simple_form"
        timestampEl:      ".fire_at"
        containerEl:      ".content-alarm-ui"
        datetimeField:    "input.datetime[name*='[fire_at]']"
        notificationEl:   ".notification#alarm_status"
        destroyEl:        ".destroy-bool"
        destroyField:     "input[type=checkbox][name*='[_destroy]']"
        statusSelect:     "select[id*=status]"
        statusPending:    "3"
        
    constructor: (options) ->
        @options         = _.defaults options||{}, @DefaultOptions
        
        # Setup all of the attributes
        @form            = @options.form
        @container       = $ @options.containerEl,    @form
        @statusSelect    = $ @options.statusSelect,   @form
        @timestampEl     = $ @options.timestampEl,    @container # Wrapper
        @datetimeField   = $ @options.datetimeField,  @container # Input
        @destroyEl       = $ @options.destroyEl,      @container # Wrapper
        @destroyField    = $ @options.destroyField,   @container  # Checkbox
        @notificationEl  = $ @options.notificationEl, @container

        @statusPending   = @options.statusPending # 3
        
        @pending   = false
        @scheduled = false
        
        @alerts =
            publish: new scpr.Notification(@notificationEl, "success", "This content is scheduled to be published.")
            notPublish: new scpr.Notification(@notificationEl, "warning", "This content is not scheduled to be published.")
        
        # Check if the alarm fire_at is filled in
        # Check which status is selected
        @checkScheduled()
        if @checkStatus(@statusSelect) then @show() else @hide()
        @notify(@pending, @scheduled)
                
        @datetimeField.on
            update: (event) =>
                @checkScheduled()
                @notify(@pending, @scheduled)
                
        # Setup listeners for status change
        @statusSelect.on
            change: (event) => 
                if @checkStatus($ event.target) then @show() else @hide()
                @notify(@pending, @scheduled)
    
        # Setup events for the destroy checkbox
        @destroyField.on
            change: (event) =>
                destroyed = if $(event.target).is(':checked') then true else false
                @toggleTransparency(destroyed)
                @scheduled = !destroyed
                @notify(@pending, @scheduled)
                
    #----------
    
    # Do some boolean checking to figure out 
    # which message to display
    notify: (pending, scheduled) ->
        if pending and scheduled
            @alerts['publish'].render()
            @alerts['notPublish'].detach()
        if !pending and scheduled
            @alerts['publish'].detach()
            @alerts['notPublish'].render()
        if pending and !scheduled
            @alerts['publish'].detach()
            @alerts['notPublish'].render()
        
    #----------

    toggleTransparency: (direction) ->
        if direction
            @timestampEl.addClass "transparent"
        else
            @timestampEl.removeClass "transparent"
        
    #----------
    
    checkScheduled: ->
        if !_.isEmpty(@datetimeField.val())
            @scheduled = true
        else
            @scheduled = false

        @scheduled

    #----------

    checkStatus: (selectEl) ->
        status = $("option:selected", selectEl).val()
        if status is @statusPending
            @pending = true 
        else 
            @pending = false

        @pending
    
    #----------

    show: ->
        @timestampEl.show()
        @destroyEl.show()

    #----------

    hide: ->
        @timestampEl.hide()
        @destroyEl.hide()
