#= require scprbase

class scpr.Track
	DefaultOptions:
		content_path: "/track/page"
		
	constructor: (options) ->
		@options = _(_({}).extend(@DefaultOptions)).extend options || {}
	
	#----------
	 
	content: (tag) ->
		$.post @options.content_path, tag:tag
		
#----------

class scpr.SocialTools
    DefaultOptions:
        fbfinder:   ".social_fb"
        twitfinder: ".social_twit"
        disqfinder: ".social_disq"
        count:      ".count"
        
        gaq:         "_gaq"
        
        fburl:      "http://graph.facebook.com/"
        twiturl:    "http://urls.api.twitter.com/1/urls/count.json"
        disqurl:    "http://kpcc.disqus.com/count.js?q=1&"
        
        no_comments: "Add your comments"
        comments:    "Comments (<%= count %>)"
        
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
                    
        # look for facebook elements so that we can fetch counts and add functionality
        @fbelements = ($ el for el in $ @options.fbfinder)
        @fbTimeout = null

        # look for twitter elements
        @twit_elements = ($ el for el in $ @options.twitfinder)
        @twitTimeout = null
        
        # look for disqus elements
        @disq_elements = ($ el for el in $ @options.disqfinder)
        @disqPending = false
        @disqTimeout = null
        
        # -- look for google analytics -- #
        @gaq = null
        if window[@options.gaq]
            @gaq = window[@options.gaq]
            
        if @fbelements.length > 0 
            @_getFbCounts()
            
        if @twit_elements.length > 0
            @_getTwitCounts()
            
        if @disq_elements.length > 0
            # load in our custom override for disqus' widgets lib
            window.DISQUSWIDGETS = {
                displayCount: (res) => @_displayDisqusCounts(res)
            }
            
            @disqCache = []
            
            @_getDisqusCounts()
        
        # add share functionality on facebook
        $(@options.fbfinder).on "click", (evt) =>
            if url = $(evt.target).attr("data-url")
                fburl = "http://www.facebook.com/sharer.php?u=#{url}"
                window.open fburl, 'pop_up','height=350,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no'                
        
        # add share functionality for twitter
        $(@options.twitfinder).on "click", (evt) =>
            if url = $(evt.target).attr("data-url")
                twurl = "https://twitter.com/intent/tweet?url=#{url}&text=Via+%40kpcc"
                window.open twurl, 'pop_up','height=350,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no'
            
    #----------
    
    _getDisqusCounts: ->
        # fire off a request to disqus 
        keys = []
        
        # clear out the disqCache
        if @disqPending
            console.log "cancelled disqus counts because of pending request"
            return false
            
        @disqCache = []
        
        _(@disq_elements).each (el,idx) =>
            objkey = el.attr('data-objkey')
            @disqCache.push el:el, objkey:objkey
            keys.push "#{idx}=1,#{encodeURIComponent(objkey)}"
                    
        $.ajax "#{@options.disqurl}#{keys.join('&')}", dataType: "script"
        
        # set a timeout for signalling bad load
        @disqTimeout = setTimeout (=> @_signalDisqusLoadFailure()), 5000
        @disqPending = Number(new Date)
        
        true
        
    _displayDisqusCounts: (res) ->
        # mark this disqus session as loaded
        clearTimeout @disqTimeout
        @disqTimeout = null
        
        # how long did the load take?
        loadtime = Number(new Date) - @disqPending
        console.log "disqus counts load took #{loadtime/1000} seconds"
        @gaq?.push ['_trackEvent','SocialTools','Disqus Load','',loadtime,true]
        
        # handle comment counts on the page
        if res.counts?
            _(res.counts).each (v) =>
                if (obj = @disqCache[ v.uid ])
                    c = $(@options.count,obj.el)
                    
                    if c.length
                        $(@options.count,obj.el).text v.comments
                    else if v.comments
                        obj.el.text _.template @options.comments, count:v.comments
                    
            # note our pending request as finished
            @disqPending = false
            
            true
            
    _signalDisqusLoadFailure: ->
        console.log "failed to load disqus counts in 5 seconds."
        @gaq?.push ['_trackEvent','SocialTools','Disqus Failure',String(new Date),0,true]
        
    #----------
        
    _getFbCounts: ->
        # collect the element urls
        @ids = (el.attr("data-url") for el in @fbelements)
        
        # set a timeout for signalling bad load
        @fbTimeout = setTimeout (=> @_signalFbLoadFailure()), 5000
        @fbPending = Number(new Date)
        
        # fire an async request 
        $.getJSON @options.fburl, { ids: @ids.join(',') }, (res) =>
            # note load success
            clearTimeout @fbTimeout
            @fbTimeout = null
            loadtime = Number(new Date) - @fbPending
            console.log "fb counts load took #{loadtime/1000} seconds"
            @gaq?.push ['_trackEvent','SocialTools','Facebook Load','',loadtime,true]
            
            # fill in our numbers
            for el in @fbelements
                if fbobj = res[ el.attr("data-url") ]
                    count = Number(fbobj.shares||0) + Number(fbobj.likes||0)
                    $(@options.count,el).text count
            
    _signalFbLoadFailure: ->
        console.log "failed to load facebook counts in 5 seconds."
        @gaq?.push ['_trackEvent','SocialTools','Facebook Failure',String(new Date),0,true]
    
    #----------    
            
    _getTwitCounts: ->
        if @twit_elements?.length
            # set our failure timeout
            @twitTimeout = setTimeout (=> @_signalTwitLoadFailure()), 5000
            @twitPending = Number(new Date)
            
            @twitCancel = _.once =>
                clearTimeout @twitTimeout
                @twitTimeout = null
                @twitCancel = null
                loadtime = Number(new Date) - @twitPending
                console.log "twit counts load took #{loadtime/1000} seconds"
                @gaq?.push ['_trackEvent','SocialTools','Twitter Load','',loadtime,true]
                
        # twitter url requests have to go off one-by-one
        _(@twit_elements).each (el,idx) =>
            # register a global callback for the twitter counter
            window[ "__scprTwit#{idx}" ] = (res) => 
                # we mark twitter as successful when the first function returns
                @twitCancel?()
            
                if res?.count?
                    $(@options.count,el).text res.count

            # fire off as a script request, using the callback to set values
            $.ajax @options.twiturl, dataType: "script", data:{ url: el.attr("data-url"), callback:"__scprTwit#{idx}" }
            
    _signalTwitLoadFailure: ->
        console.log "failed to load twitter counts in 5 seconds."
        @gaq?.push ['_trackEvent','SocialTools','Twitter Failure',String(new Date),0,true]
            
#----------

class scpr.SectionCarousel
	DefaultOptions:
		el: "#sec_carousel"
		items: 4
		prev: "#sec_carousel_prev"
		next: "#sec_carousel_next"
		pages: "#sec_carousel_pag"
		param: "page"
		
	#----------
	
	_template:
		"""
		<a href="<%= link_path %>">
			<%= asset %>
			<p><%= headline %></p>
		</a>
		"""

	#----------
	
	constructor: (items,options) ->
		@options = _(_({}).extend(this.DefaultOptions)).extend( options || {} )

		# -- create our initial elements -- #
		@el = $(@options.el)
		
		for i in items
			tag = $ "<li/>"
			tag.html _.template @_template, i
			@el.append tag
		
		# -- instantiate our carousel -- #

		$(@options.el).carouFredSel
			circular:	false
			infinite:	false
			auto:		false
			items:		@options.items
			prev:		@options.prev
			next:		@options.next
			pagination: @options.pages
			scroll:
				onAfter: (oldI,newI) => @_loadItems(oldI,newI)

	_loadItems: (oldI,newI) ->
		console.log "oldI is ", oldI
		console.log "newI is ", newI

#----------	   

class scpr.BetaToggle
	DefaultOptions:
		cookie: "scprbeta"
		el: "#beta-button"
		homeEl: "#beta-home"
		onText: "Opt me in to the beta!"
		offText: "Get me out of the beta!"
	
	constructor: (options) ->
		@options = _(_({}).extend(this.DefaultOptions)).extend( options || {} )
		
		@current = if scpr.Cookie.get(@options.cookie) == "true" then true else false

		$ => 
			# attach click handler for cookie toggling
			$(@options.el).click (e) =>
				if @current
					# opt out
					console.log "opt out!"
					scpr.Cookie.unset(@options.cookie)
					@current = false
				else
					# opt in
					console.log "opt in!"
					scpr.Cookie.set(@options.cookie,true,86400*30)
					@current = true
				
				@setText()
				
				# show the home page link
				$(@options.homeEl).show()
			
				return false
				
			@setText()

	setText: ->
		if @current
			$(@options.el).text @options.offText
		else
			$(@options.el).text @options.onText

		
	
#----------		   

###
 cookie code originally from prototype-tidbits
 http://livepipe.net/projects/prototype_tidbits/
###

class scpr.Cookie
	@set: (name,value,seconds) ->
		if seconds
			d = new Date()
			d.setTime d.getTime() + (seconds * 1000)
			expiry = '; expires=' + d.toGMTString()
		else
			expiry = ''

		document.cookie = name + "=" + value + expiry + "; path=/"

	@get: (name) ->
		nameEQ = name + "=";
		ca = document.cookie.split(';');
		for c in ca
			while c.charAt(0) == ' '
				c = c.substring(1,c.length)

			if c.indexOf(nameEQ) == 0
				return c.substring(nameEQ.length,c.length)

		return null

	@unset: (name) ->
		scpr.Cookie.set name, '', -1