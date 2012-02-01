#= require scprbase

#= require underscore
#= require backbone

class scpr.ContentBaseAPI
    DefaultOptions:
		api_path: "/dashboard/api"
		
	constructor: (options) ->
		@options = _(_({}).extend(@DefaultOptions)).extend options || {}
	