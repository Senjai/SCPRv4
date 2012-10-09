#= require scprbase

$ ->
    for wrapper in $("form.simple_form div.datetime")
        new scpr.DateTimeInput(wrapper: wrapper)
    
    for wrapper in $("form.simple_form div.date")
        new scpr.DateTimeInput(wrapper: wrapper, time: false, field: "input.date")

class scpr.DateTimeInput
    DefaultOptions:
        time:          true
        dateTemplate:  JST["admin/templates/date_field"]
        timeTemplate:  JST["admin/templates/time_field"]
        timestampEls:  ".timestamp-el"
        populateIcons: "span.populate"
        controls:      "div.controls"
        field:         "input.datetime"
        dateFormat:    "YYYY-MM-DD"
        timeFormat:    "hh:mma"
        dbFormat:      "YYYY-MM-DD hh:mm:ss"

    constructor: (options) ->    
        @options = _.defaults options||{}, @DefaultOptions
        @time    = @options.time

        # Elements
        @wrapper       = $ @options.wrapper
        @controls      = $ @options.controls, @wrapper
        @field         = $ @options.field, @wrapper

        # Attributes
        @id     = @field.attr("id")
        @dateId = "#{@id}_date"
        @timeId = "#{@id}_time"

        # Hide the field since we don't want anybody editing it directly
        @field.hide()
        
        # Render the templates
        # Prepend time first so it's second
        @controls.prepend(@options.timeTemplate(time_id: @timeId, time_format: @options.timeFormat)) if @time
        @controls.prepend(@options.dateTemplate(date_id: @dateId, date_format: @options.dateFormat))
    
        # Register the newly-created elements
        @timestampEls   = $ @options.timestampEls, @wrapper
        @dateEl         = $ "##{@dateId}"
        @timeEl         = $ "##{@timeId}"
        @populateIcons  = $ @options.populateIcons, @wrapper

        # Fill in the new fields with the correct date/time
        # Only if the field has a value (i.e. we're editing the object)
        if @field.val()
            @dateEl.val @getDate(@options.dateFormat)
            @timeEl.val @getDate(@options.timeFormat) if @time

        # Make the dateEl a datepicker
        @dateEl.datepicker(autoclose: true, format: @options.dateFormat.toLowerCase())

        # Fill in hidden text field when visible field is changed
        @timestampEls.on
            change: (event) => (@field.trigger "update")

        @field.on
            update: => (@setDate(@dateEl.val(), @timeEl.val() if @time))
                
        # Fill in visible fields with right now time,
        # and trigger the "update" event on field hidden field
        @populateIcons.on
            click: (event) =>
                @populateDate(@dateEl, @options.dateFormat)
                @populateDate(@timeEl, @options.timeFormat) if @time
                @field.trigger "update"
       
    # Populate a visible field with a date human-readable date string
    populateDate: (el, format) ->
        date = moment().format(format)
        el.val(date)

    # Get timestamp from hidden field
    getDate: (format) ->
        date = Date.parse(@field.val())
        moment(date).format(format) if date
    
    # Set value of hidden field to a real date
    setDate: (date, time="") ->
        date = moment(Date.parse("#{date} #{time}"))
        console.log "date set to", date
        if date
            formatted = date.format(@options.dbFormat) 
            @field.val(formatted)
        else
            @field.val("")
