##
# Newsroom
#
# Client for the Newsroom.js Node server
#
class scpr.Newsroom
    @queue = []

    @templates:
        badge: JST["outpost/templates/badge"]
    
    @fail: ->
        window.newsroomFailed = true
        queued.fail() for queued in Newsroom.queue

    @load: ->
        window.newsroomReady = true
        queued.load() for queued in Newsroom.queue

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

            if window.newsroomReady then @load() else @enqueue()

        #-----------------

        enqueue: ->
            Newsroom.queue.push @

        #-----------------

        load: ->
            $ =>
                # If io (sockets) isn't available, render error
                # Otheriwse connect to Socket.io
                if !io?
                    @fail()
                    return

                @socket  = io.connect scpr.NODE, 'connect timeout': 5000
                @socket.on 'finished-task', (data) ->
                    $("#work_status").html("Finished!")
                    $("#spinner").spin(false)
                    window.location = data.location

        fail: ->
            $("#spinner").spin(false)
            $("#work_status").html()
            @alerts['offline'].render()
    
    #-----------------
    
    constructor: (@roomId, @userJson, options={}) ->
        @el = $ options.el
        @el.spin()

        @record  = options.record
        
        @alerts  = 
            offline: new Newsroom.Alert.Offline($("*[id*='newsroom']"))
            empty:   new Newsroom.Alert.Empty(@el)


        if window.newsroomReady then @load() else @enqueue()

    #-----------------
    # Enqueue the loading until we're told to load (to allow for asynx JS loading)
    enqueue: ->
        Newsroom.queue.push @

    #-----------------
    # Load the ticker
    load: ->
        $ =>
            # If io (sockets) isn't available, render error
            # Otheriwse connect to Socket.io
            if !io?
                @fail()
                return

            @socket  = io.connect scpr.NODE, 'connect timeout': 5000
            
            # Outgoing messages
            @socket.emit 'entered', @roomId, @userJson, recordJson: @record

            # Incoming messages
            @socket.on 'loadList', (users) =>
                @el.spin(false)
                @loadList(users)

    fail: ->
        @el.spin(false)
        @alerts['offline'].render()

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

