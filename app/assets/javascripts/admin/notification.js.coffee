#= require scprbase

# Raise notifications from anywhere in the JS code
# Pass the el to place the message into
class scpr.Notification
    constructor: (el, type, message) ->
        @type      = type
        @message   = message
        @container = el
        @el        = $("<div />", class: "alert alert-#{type}").html("#{message}").hide()
        el.append @el
    
    # Delegation to @el.show()
    show: ->
        @el.show()
        
    # Delegation to @el.hide()
    hide: -> 
        @el.hide()
