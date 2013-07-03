class outpost.RecurringRuleUI
    @TemplatePath = "outpost/templates/recurring_rule_ui/"

    @Types:
        "daily": "IceCube::DailyRule"
        "weekly": "IceCube::WeeklyRule"

    defaults:
        defaultPeriod: "daily"


    constructor: (inputId, options={}) ->
        @options = _.defaults options, @defaults

        @input = $(inputId)
        @input.hide()

        @wrapper = $(@_template("wrapper"))

        @_buildFields()
        @_registerEvents()
        @_buildView()

        @switchToPeriod(@options.defaultPeriod)

        @input.after @wrapper


    switchToPeriod: (value) ->
        @periodSelect.trigger("change", value)


    parseFields: ->
        timeParts = @_parsedTimeParts()

        switch @period
            when "daily"
                @_jsonToInput @_dailyRule(
                    @_numberArray(timeParts.hour),
                    @_numberArray(timeParts.minute)
                )

            when "weekly"
                interval = @intervalInput.val()

                @_jsonToInput @_weeklyRule(
                    if !_.isEmpty(interval) then parseInt(interval) else 0,
                    @_parsedDays(), # Always an array.
                    @_numberArray(timeParts.hour),
                    @_numberArray(timeParts.minute)
                )

        console.log @input.val()



# private ######################################


    _buildFields: ->
        @periodSelectWrapper    = $(@_template("period_select"))
        @periodSelect           = $("select", @periodSelectWrapper)

        @intervalInputWrapper   = $(@_template("interval_input"))
        @intervalInput          = $("input", @intervalInputWrapper)

        @dayInputsWrapper   = $(@_template("day_select"))
        @dayInputs          = $("input", @dayInputsWrapper)

        @timeInputWrapper   = $(@_template("time_input"))
        @timeInput          = $("input", @timeInputWrapper)


    _registerEvents: ->
        @periodSelect.on "change", (event, period) =>
            period ?= event.val
            @_periodSelectChangeHandler(period)

        @intervalInput.on "change", (event) => @parseFields()
        @timeInput.on "change", (event) => @parseFields()

        for input in @dayInputs
            $(input).on "change", (event) => @parseFields()


    _periodSelectChangeHandler: (period) ->
        selectValue = @periodSelect.val()
        @periodSelect.val(period) if selectValue isnt period

        switch period
            when "daily" then @_switchToDaily()
            when "weekly" then @_switchToWeekly()

        @parseFields()


    _buildView: ->
        @wrapper.append @periodSelectWrapper
        @wrapper.append @intervalInputWrapper
        @wrapper.append @dayInputsWrapper
        @wrapper.append @timeInputWrapper


    _switchToDaily: ->
        @period = "daily"
        @dayInputsWrapper.hide()
        @intervalInputWrapper.hide()


    _switchToWeekly: ->
        @period = "weekly"
        @dayInputsWrapper.show()
        @intervalInputWrapper.show()


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


    # The DailyRule object, as defined by IceCube::DailyRule#to_hash
    _dailyRule: (hour, minute) ->
        "validations":
            "hour_of_day": hour
            "minute_of_hour": minute
            "second_of_minute": [0] # We don't need to expose the second.
        "rule_type": RecurringRuleUI.Types["daily"]
        "interval": 1 # For now, we don't need this exposed for Daily rule.


    # The WeeklyRule object, as defined by IceCube::WeeklyRule#to_hash
    _weeklyRule: (interval, days, hour, minute) ->
        "validations":
            "day": days
            "hour_of_day": hour
            "minute_of_hour": minute
            "second_of_minute": [0]
        "rule_type": RecurringRuleUI.Types["weekly"]
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
