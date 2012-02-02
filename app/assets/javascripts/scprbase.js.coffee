###
SCPRv4: Southern California Public Radio
###

scpr ?= {}
scpr.API_ROOT = "http://scprv4.dev/dashboard/api"

# stub console.log() for IE
if !window.console
    class window.console
        @log: ->


