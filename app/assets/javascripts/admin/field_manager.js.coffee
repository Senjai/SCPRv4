#= require scprbase

##
# FieldManager
#
# A simple class that listens for certain events
# and does things to forms
#
class scpr.FieldManager
    constructor: ->
        
        $("fieldset.form-block legend").on
            click: (event) ->
                target = $(@)
                target.siblings(".fields").toggle()
                target.siblings(".notification").toggle()

        # Add fields
        $(".js-add-fields").on
            click: (event) ->
                target = $(@)
                time   = new Date().getTime()
                regexp = new RegExp(target.data('id'), 'g')
                fields = target.data('fields').replace(regexp, time)
                
                if buildTarget = target.data('build-target')
                    $(buildTarget).append fields
                else
                    target.before(fields)
                    
                event.preventDefault()
