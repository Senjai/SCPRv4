#= require scprbase

class scpr.ContentAlarmUI
    DefaultOptions:
        form:             "form.simple_form"
        timestampEl:      ".fire_at"
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
        @statusSelect    = $ @options.statusSelect,   @form
        @timestampEl     = $ @options.timestampEl,    @form # Wrapper
        @datetimeField   = $ @options.datetimeField,  @form # Input
        @destroyEl       = $ @options.destroyEl,      @form # Wrapper
        @destroyField    = $ @options.destroyField,   @form # Checkbox
        @notificationEl  = $ @options.notificationEl, @form

        @statusPending   = @options.statusPending # 3
        
        @pending   = false
        @scheduled = false
        
        @pubNotification  = new scpr.Notification(@notificationEl, "success", "This content is scheduled to be published.")
        @warnNotification = new scpr.Notification(@notificationEl, "warning", "This content is not scheduled to be published.")
        
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
            @pubNotification.show()
            @warnNotification.hide()
        if !pending and scheduled
            @pubNotification.hide()
            @warnNotification.show()
        if pending and !scheduled
            @pubNotification.hide()
            @warnNotification.show()
        
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
