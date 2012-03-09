#= require scprbase

# This file will eventually handle the ajax loading of the filters on Program pages. Currently it is not being used.

class scpr.ProgramPage
    DefaultOptions:
        programs_path: "/programs/"
    
    constructor: (options={}) ->
        @opts = _.defaults options, @DefaultOptions
		console.log "Loaded Program Page"