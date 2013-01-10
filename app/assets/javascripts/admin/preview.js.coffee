#= require scprbase

##
# Preview
#
# Preview functionality for the CMS
#
class scpr.Preview
    constructor: ->        
        $("form button#preview").on
            click: (event) ->
                event.preventDefault()
                
                form = $(@).closest("form")[0]
                originalTarget = form.target
                originalAction = form.action
                
                form.target = "_blank"
                form.action = "/r/admin/preview"
                form.submit()
                
                form.target = originalTarget
                form.action = originalAction
