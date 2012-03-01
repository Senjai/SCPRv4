#= require scprbase

class scpr.ProgramPage
    DefaultOptions:
        programs_path: "/programs/"
    
    constructor: (options={}) ->
        @opts = _.defaults options, @DefaultOptions
		console.log "Loaded Program Page"