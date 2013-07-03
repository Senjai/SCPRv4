class outpost.RecurringRuleUI
    @TemplatePath = "outpost/templates/recurring_rule_ui/"


    constructor: (inputId, options={}) ->
        @options = _.defaults options, @defaults

        @input = $(inputId)
        @input.hide()

        @wrapper = $(@_template("wrapper"))

        @_buildFields()
        @_buildView()
        @_registerEvents()

        @input.after @wrapper


    parseFields: ->
        timeParts   = @_parsedTimeParts()
        interval    = @intervalInput.val()

        @_jsonToInput @_weeklyRule(
            if !_.isEmpty(interval) then parseInt(interval) else 0,
            @_parsedDays(), # Always an array.
            @_numberArray(timeParts.hour),
            @_numberArray(timeParts.minute)
        )

        console.log @input.val()



# private ######################################


    _buildFields: ->
        @intervalInputWrapper = $(@_template("interval_input"))
        @intervalInput = $("input#recurring-interval", @intervalInputWrapper)

        @dayInputsWrapper = $(@_template("day_select"))
        @dayInputs = $("input[type='checkbox']", @dayInputsWrapper)

        @timeInputWrapper = $(@_template("time_input"))
        @timeStartInput = $("input#recurring-time-start", @timeInputWrapper)
        @timeEndInput   = $("input#recurring-time-end", @timeInputWrapper)


    _registerEvents: ->
        $("select, input", @wrapper).on "change", (event) =>
            @parseFields()


    _buildView: ->
        @wrapper.append @intervalInputWrapper
        @wrapper.append @dayInputsWrapper
        @wrapper.append @timeInputWrapper


    # Accepts a JSON object and populates the actual
    # (hidden) input with the stringified object.
    _jsonToInput: (json) ->
        @input.val JSON.stringify(json)


    # Parse the time input into HOUR and MINUTE.
    # If the time input hasn't been filled in,
    # then we'll bypass any splitting and just
    # return an empty object, so that both
    # HOUR and MINUTE will return "undefined".
    _parsedTimeParts: ->
        namedParts = {}
        time = @timeInput.val()

        if !_.isEmpty(time)
            parts = time.split(":")
            namedParts["hour"]   = parts[0]
            namedParts["minute"] = parts[1]

        namedParts


    # Grab the selected Day checkboxes and return 
    # an array of integers for those days.
    # Since we control the value for these checkboxes,
    # we know that they will be valid for parseInt(), 
    # and therefore don't need to check for the value's 
    # presence.
    # We also sort because Sunday is "day 0" on the 
    # server, but we want to put it at the end of the list. 
    # We probably don't *need* to sort, but it just feels 
    # right, you know? Yeah, you know.
    _parsedDays: ->
        selected = $("input[name='recurring-days']:checked", @wrapper)
        days = []

        for input in selected
            days.push parseInt($(input).val())

        days.sort()


    # The WeeklyRule object, as defined by IceCube::WeeklyRule#to_hash
    _weeklyRule: (interval, days, hour, minute) ->
        "validations":
            "day": days
            "hour_of_day": hour
            "minute_of_hour": minute
            "second_of_minute": [0]
        "rule_type": "IceCube::WeeklyRule"
        "interval": interval
        "week_start": 0 # Hard-code Sunday


    # Since the hour and minute might be undefined, 
    # and IceCube wants an array for these 
    # (but we only care about one hour/minute),
    # we want to either return an array with the 
    # number, or an empty array.
    _numberArray: (number) ->
        if number? then [parseInt(number)] else []


    _template: (template_name, options={}) ->
        JST[RecurringRuleUI.TemplatePath + template_name](options)
