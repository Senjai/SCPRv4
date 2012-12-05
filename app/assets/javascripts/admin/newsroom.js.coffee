#= require scprbase

# Communicate with the Newsroom.js Node server
class scpr.Newsroom
    #-----------------
    # Alerts/Errors
    class @Alert
        #-----------------
        # When the requested room(s) are empty
        class @Empty extends scpr.Notification
            constructor: (el) ->
                super el, "info", "There is nobody else here."
    
        #-----------------
        # When there is an error reaching the Node server
        class @Offline extends scpr.Notification
            constructor: ->
                super $("*[id*='newsroom']"), "error", "Newsroom Alerts are currently offline."


    #-----------------
    #-----------------
    
    DefaultOptions:
        badgeTemplate: JST["admin/templates/newsroom_badge"]
    
    #-----------------

    constructor: (@server, @roomInfo, @user, @object, options) ->
        @options = _.defaults options||{}, @DefaultOptions
        @el      = $ options.el
        @room    = JSON.parse(@roomInfo) # So we can use it here
        
        @alerts  = 
            offline: new Newsroom.Alert.Offline()
            empty:   new Newsroom.Alert.Empty(@el)

        # If io (sockets) isn't available, error and return
        # Otheriwse connect to Socket.io
        return @alerts['offline'].render() if !io?
        @socket  = io.connect @server

        # Outgoing messages
        @socket.emit 'entered', @roomInfo, @user, @object
        
        $("input, textarea, select").on
            focus: (event) =>
                @socket.emit('fieldFocus', $(event.target).attr('id'))
            blur: (event) =>
                @socket.emit('fieldBlur', $(event.target).attr('id'))
                
        
        # Incoming messages
        @socket.on 'loadList',   (users)         => @loadList(users)
        @socket.on 'newUser',    (user)          => @newUser(user)
        @socket.on 'removeUser', (user)          => @removeUser(user)
        @socket.on 'fieldFocus', (fieldId, user) => @fieldFocus(fieldId, user)
        @socket.on 'fieldBlur',  (fieldId, user) => @fieldBlur(fieldId, user)
            

    #-----------------
    # Load the list of users into the bucket
    # If the list is empty, notify the user
    loadList: (users) ->
        @_addUser user for user in users
        @alerts['empty'].render() if @_empty()
        
    #-----------------
    # Add a user to the list
    # Show/hide `Empty` notification as necessary
    newUser: (user) ->
        @_addUser user
        @alerts['empty'].detach() if @alerts['empty'].isVisible()

    #-----------------
    # Remove a user from the list
    removeUser: (user) ->
        _t = @
        userId = @_mungeUserId(user.id)
        $("#user-#{userId}", @el).fadeOut 'fast', ->
            $(@).remove()
            _t.alerts['empty'].render() if _t._empty()


    #-----------------
    # Field highlighting
    fieldFocus: (fieldId, user) ->  
        userId = @_mungeUserId(user.id)
        @_mark ?= $("<div/>", class: "circle badge-mark", style: "background-color: #{user.color}")
        $("label[for='#{fieldId}']").prepend @_mark
        $("#user-#{userId}").addClass("highlighted")
        
    #-----------------
    # Field de-highlighting
    fieldBlur: (fieldId, user) ->
        userId = @_mungeUserId(user.id)
        @_mark.detach()
        $("#user-#{userId}").removeClass("highlighted")
    

    #-----------------
    # Munge the user badge ID to be compatible with jQuery. This is a temporary solution.
    _mungeUserId: (userId) ->
        userId.replace(/:/g, "-").replace(/\//g, "-") 
    
    #-----------------
    # Add a user to the bucket by rendering the template
    _addUser: (user) ->
        badge = $ @options.badgeTemplate
            user: user
            userId: @_mungeUserId(user.id)
            record: user.record
            room: @room
            
        badge.hide()
        @el.append badge
        badge.fadeIn('fast')

    #-----------------
    # Check if @el is empty
    _empty: ->
        !@el.html().trim()
