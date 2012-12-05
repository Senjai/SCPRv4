#= require scprbase

# Raise notifications from anywhere in the JS code
# Pass the el to place the message into
class scpr.Notification
    constructor: (@wrapper, @type, @message) ->
        @el = $("<div />", class: "alert alert-#{type}").html("#{message}")

    render: ->
        @wrapper.append @el
    
    # Replaces the wrapper's content with the alert
    replace: ->
        @wrapper.html @el
        
    # Delegation for jQuery: @el.is(":visible")
    isVisible: ->
        @el.is(":visible")
        
    # Delegation for jQuery: @el.show()
    show: ->
        @el.show()
        
    # Delegation for jQuery: @el.hide()
    hide: -> 
        @el.hide()
    
    # Delegation for jQuery: @el.detach()
    detach: ->
        @el.detach()
        
    # Delegation for jQuery: @el.remove()
    remove: ->
        @el.remove()
