#= require scprbase

$ ->
    for wrapper in $("form.simple_form div.datetime")
        new scpr.DateTimeInput(wrapper: wrapper)
            
class scpr.DateTimeInput
    DefaultOptions:
        dateTemplate:  JST["admin/templates/timestamp_fields"]
        timestampEls:  ".timestamp-el"
        populateIcons: "span.populate"
        controls:      "div.controls"
        field:         "input.datetime"
        dateFormat:    "MM/DD/YYYY"
        timeFormat:    "hh:mma"

    constructor: (options) ->    
        @options = _.defaults options||{}, @DefaultOptions
        
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
        
        # Render the template
        @controls.prepend(@options.dateTemplate(date_id: @dateId, time_id: @timeId))
    
        # Register the newly-created elements
        @timestampEls   = $ @options.timestampEls, @wrapper
        @dateEl         = $ "##{@dateId}"
        @timeEl         = $ "##{@timeId}"
        @populateIcons  = $ @options.populateIcons, @wrapper

        # Fill in the new fields with the correct date/time
        # Only if the field has a value (i.e. we're editing the object)
        if @field.val()
            @dateEl.val @getDate(@options.dateFormat)
            @timeEl.val @getDate(@options.timeFormat)

        # Make the dateEl a datepicker
        @dateEl.datepicker(autoclose: true)

        # Fill in hidden text field when visible field is changed
        @timestampEls.on
            change: (event) => (@field.trigger "update")

        @field.on
            update: => (@setDate @dateEl.val(), @timeEl.val())
                
        # Fill in visible fields with right now time,
        # and trigger the "update" event on field hidden field
        @populateIcons.on
            click: (event) =>
                @populateDate(@dateEl, @options.dateFormat)
                @populateDate(@timeEl, @options.timeFormat)
                @field.trigger "update"
       
    # Populate a visible field with a date human-readable date string
    populateDate: (el, format) ->
        date = moment().format(format)
        el.val(date)

    # Get timestamp from hidden field
    getDate: (format) ->
        date = moment(Date.parse(@field.val()))
        date.format format
    
    # Set value of hidden field to a real date
    setDate: (date, time) ->
        datetime = Date.parse("#{date} #{time}")
        console.log "date set to", datetime
        @field.val(datetime)
