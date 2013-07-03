class outpost.RecurringRuleUI
    @TemplatePath = "outpost/templates/recurring_rule_ui/"

    constructor: (inputId) ->
        @input = $(inputId)
        @input.hide()

        @el = $(JST[RecurringRuleUI.TemplatePath + "wrapper"]())

        @buildFields()
        @registerEvents()
        @appendFields()

        @input.after @el
        
    buildFields: ->
        @intervalSelect = 
            $(JST[RecurringRuleUI.TemplatePath + "interval_select"]())


    registerEvents: ->
        @intervalSelect.on "change", (value) =>
            @exposeFieldsForInterval(value)


    appendFields: ->
        @el.append @intervalSelect

    exposeFieldsForInterval: (value) ->
        true
