#= require scprbase

$ ->
    for wrapper in $("form.simple_form div.datetime")
        new scpr.DateTimeInput(wrapper: wrapper)
        
class scpr.DateTimeInput
    DefaultOptions:
        dateTemplate: JST["admin/templates/timestamp_fields"]
        timestampEls: ".timestamp-el"
        dateFormat:   "MM/DD/YYYY"
        timeFormat:   "hh:mma"
        
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
        
        # Elements
        @wrapper      = $ @options.wrapper
        @controls     = @wrapper.find("div.controls")
        @field        = @wrapper.find("input.datetime")

        # Hide the field since we don't want anybody editing it directly
        @field.hide()

        # Attributes
        @id     = @field.attr("id")
        @dateId = "#{@id}_date"
        @timeId = "#{@id}_time"

        # Render the template
        @controls.prepend(@options.dateTemplate(date_id: @dateId, time_id: @timeId))
        
        # Register the newly-created elements
        @timestampEls   = $ @options.timestampEls
        @dateEl         = $ "##{@dateId}"
        @timeEl         = $ "##{@timeId}"

        # Fill in the new fields with the correct date/time
        # Only if the field has a value (i.e. we're editing the object)
        if @field.val()
            @dateEl.val @getDate(@options.dateFormat)
            @timeEl.val @getDate(@options.timeFormat)

        # Make the dateEl a datepicker
        @dateEl.datepicker()

        # Setup event listeners to fill in hidden text field on change
        @timestampEls.on
            change: (event) =>
                @setDate @dateEl.val(), @timeEl.val()

    getDate: (format) ->
        date = moment(@field.val())
        date.format format
    
    setDate: (date, time) ->
        datetime = Date.parse("#{date} #{time}")
        console.log "date set to", datetime
        @field.val(datetime)
