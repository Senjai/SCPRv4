##
# Newsroom
#
# Client for the Newsroom.js Node server
#
class scpr.Newsroom
    @templates:
        badge: JST["outpost/templates/badge"]
    
    #-----------------
    # Alerts/Errors
    class @Alert
        #-----------------
        # When the requested room(s) are empty
        class @Empty extends outpost.Notification
            constructor: (el) ->
                super el, "info", "There is nobody else here."
    
        #-----------------
        # When there is an error reaching the Node server
        class @Offline extends outpost.Notification
            constructor: (el) ->
                super el, "error", "Newsroom Alerts are currently offline."


    #-----------------
    #-----------------
    # Job listener just listens for a message to a socket and redirects
    class @JobListener
        constructor: ->
            $("#spinner").spin()
            
            @alerts  = 
                offline: new Newsroom.Alert.Offline($("#work_status"))

            $ =>
                # If io (sockets) isn't available, render error
                # Otheriwse connect to Socket.io
                if !io?
                    $("#spinner").spin(false)
                    $("#work_status").html()
                    @alerts['offline'].render() 
                else
                    @socket  = io.connect scpr.NODE, 'connect timeout': 5000
                    @socket.on 'finished-task', (data) ->
                        $("#work_status").html("Finished!")
                        $("#spinner").spin(false)
                        window.location = data.location

    
    #-----------------
    
    constructor: (@roomId, @userJson, options={}) ->
        @el = $ options.el
        @el.spin()

        @record  = options.record
        
        @alerts  = 
            offline: new Newsroom.Alert.Offline($("*[id*='newsroom']"))
            empty:   new Newsroom.Alert.Empty(@el)

        $ =>
            # If io (sockets) isn't available, render error
            # Otheriwse connect to Socket.io
            if !io?
                @el.spin(false)
                @alerts['offline'].render()
            else
                @socket  = io.connect scpr.NODE, 'connect timeout': 5000
                
                # Outgoing messages
                @socket.emit 'entered', @roomId, @userJson, recordJson: @record

                # Incoming messages
                @socket.on 'loadList', (users) =>
                    @el.spin(false)
                    @loadList(users)

    #-----------------
    # Load the list of users into the bucket
    # If the list is empty, notify the user
    loadList: (users) ->
        return @alerts['empty'].render() if _.isEmpty users

        ul = $("<ul/>")

        for id, user of users
            badge = $ scpr.Newsroom.templates.badge(user: user)
            ul.append badge
                
        @el.html ul

