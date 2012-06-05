express = require 'express'
app = express.createServer()
io = require('socket.io').listen(app)

app.use express.bodyParser()
app.listen 13002

connections = {}
users = {}
# express.js
app.get '/', (req, res) ->
  res.send 404

app.post '/watcher/:action/:to', (req, res) ->
  target = connections[req.params.to]
  if target
    connections[req.params.to].emit(req.params.action, req.body)
    res.send 200
  else
    res.send 404

# socket.io
io.sockets.on 'connection', (socket) ->
    console.log "connected: ", socket.id
    
    socket.on 'entered', (user_str, object_str) ->
        object = JSON.parse(object_str)
        user = JSON.parse(user_str)
        socket.username = user.username
        connections[user.username] = socket
        users[user.username] = user
        
        socket.join(object.id)
        socket.emit("load_viewers", users)
        socket.broadcast.emit("add_viewer", user)

    socket.on 'disconnect', ->
        user = users[socket.username]
        io.sockets.emit('remove_viewer', user)
        delete users[socket.username]
        delete connections[socket.username]
        socket.leave socket.room
