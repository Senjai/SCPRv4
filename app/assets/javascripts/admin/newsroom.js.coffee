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
            constructor: (el) ->
                super el, "error", "Newsroom Alerts are currently offline."


    #-----------------
    #-----------------
    # Job listener just listens for a message to a socket and redirects
    class @JobListener
        constructor: (@user) ->
            $("#spinner").spin()
            
            @alerts  = 
                offline: new Newsroom.Alert.Offline($("#work_status"))

            # If io (sockets) isn't available, error and return
            # Otheriwse connect to Socket.io
            return @alerts['offline'].render() if !io?
            @socket  = io.connect scpr.NODE
            @socket.emit 'task-waiting', @user
            
            @socket.on 'finished-task', (data) ->
                $("#work_status").html("Finished!")
                $("#spinner").spin(false)
                window.location = data.location

    #-----------------

    DefaultOptions:
        badgeTemplate: JST["admin/templates/newsroom_badge"]
    
    #-----------------

    constructor: (@roomId, @userJson, options={}) ->
        @options = _.defaults options, @DefaultOptions
        @el      = $ options.el
        @record  = options.record
        
        @alerts  = 
            offline: new Newsroom.Alert.Offline($("*[id*='newsroom']"))
            empty:   new Newsroom.Alert.Empty(@el)

        # If io (sockets) isn't available, error and return
        # Otheriwse connect to Socket.io
        return @alerts['offline'].render() if !io?
        @socket  = io.connect scpr.NODE

        # Outgoing messages
        @socket.emit 'entered', @roomId, @userJson, recordJson: @record

        # Incoming messages
        @socket.on 'loadList',   (users) => @loadList(users)
        @socket.on 'newUser',    (user)  => @newUser(user)
        @socket.on 'removeUser', (user)  => @removeUser(user)

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
        $("#user-#{user.id}", @el).fadeOut 'fast', ->
            $(@).remove()
            _t.alerts['empty'].render() if _t._empty()
    
    #-----------------
    # Add a user to the bucket by rendering the template
    _addUser: (user) ->
        badge = $@options.badgeTemplate(user: user, room: @room)
        badge.hide()
        @el.append badge
        badge.fadeIn('fast')

    #-----------------
    # Check if @el is empty
    _empty: ->
        !@el.html().trim()
