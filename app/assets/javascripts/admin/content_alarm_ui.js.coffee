#= require scprbase

class scpr.ContentAlarmUI
    DefaultOptions:
        form:             "form.simple_form"
        timestampEl:      ".published_at"
        statusSelect:     "select[id*=status]"
        statusPending:    "3"
        
    constructor: (options) ->
        @options         = _.defaults options||{}, @DefaultOptions
        
        @form            = @options.form
        @statusSelect    = $(@options.statusSelect, @form)
        @timestampEl     = $(@options.timestampEl,  @form)

        @statusPending   = @options.statusPending
        
        @checkStatus @statusSelect
        
        # Setup listeners for status change
        @statusSelect.on
            change: (event) => @checkStatus(event.target)
            
    checkStatus: (selectEl) ->
        status = $("option:selected", selectEl).val()
        if status is @statusPending
            @showTimestampFields()
        else
            @hideTimestampFields()

    showTimestampFields: ->
        @timestampEl.show()

    hideTimestampFields: ->
        @timestampEl.hide()
