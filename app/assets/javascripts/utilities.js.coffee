class scpr.CompactNav
    constructor: ->
        @nav = $("#footer-nav")
        @viewPort = $(".viewport")

        $("#condensed-nav-link").on
            click: => @slideRight()

        $("#compact-nav-head .in-btn").on
            click: => @slideLeft()

    slideRight: ->
        $("html").addClass "compactNav"
        @nav.addClass("active")
        @viewPort.css(height: @nav.height())

        $("body").addClass("navIn").css
            height: @nav.height()

        @viewPort.animate(left: @nav.width(), "fast")

    slideLeft: ->
        @viewPort.animate(left: 0, "fast", =>
            @viewPort.css(height: "auto")
            $("body").removeClass("navIn").css
                height: "auto"
            @nav.removeClass("active")
        )

#----------
# Hack to get DFP ads in iframes to be responsive
class scpr.adSizer
    constructor: ->
        $(document).ready =>
            # 7 times. If the ad hasn't loaded after that, then we're giving up.
            for i in [1..7]
                @sizedCheck(i)
            

    resize: (element) ->
        $(element).css
            "max-width": "100%",
            "height": "auto"
        @removeFixedDimensions(element)

    sizedCheck: (i) ->
        setTimeout () =>
            if $(".dfp:not(.adSized)").length
                @resizeIframes()
        , 500*i

    resizeIframes: ->
        $.each $(".dfp:not(.adSized) iframe"), (i, iframe) =>
            $(iframe.contentWindow.document).ready () =>
                ad = $(iframe.contentWindow.document).find("img, object, embed")[0]
                if $(ad).length
                    @resize(ad)
                    $(iframe).closest(".ad .dfp").addClass("adSized")

    removeFixedDimensions: (element) ->
        $(element).removeAttr("width").removeAttr("height")

#----------

class scpr.TweetRotator
    defaults:
        el:          "#election-tweets"
        fadeSpeed:   '400' # milliseconds
        rotateSpeed: 15 # seconds
        activeClass: 'active'
        
    constructor: (options={}) ->
        @options = _.defaults options, @defaults
        
        @el     = $(@options.el)
        
        @_firstChild = $(@el.children()[0])
        @active      = @_firstChild
        
        setInterval =>
            @rotate()
        , @options.rotateSpeed * 1000
        
    rotate: ->
        next = @getNext()
        @active.fadeOut @options.fadeSpeed, =>
            @deactivate @active
            @activate next
    
    activate: (el) ->
        el.fadeIn @options.fadeSpeed, =>
            el.addClass(@options.activeClass)
            @active = el
    
    deactivate: (el) ->
        el.removeClass(@options.activeClass)
        
    getNext: ->
        next = @active.next()
        if next.length then next else @_firstChild
        
        
#----------
class scpr.PromoteFacebook
    constructor: ->
        $(document).ready =>
            # Show callout to Like KPCC on Facebook if user came to scpr.org from Facebook.
            $(".fb-callout").addClass "show"  unless document.referrer.search("facebook") is -1

class scpr.SocialTools
    DefaultOptions:
        fbfinder:   ".social_fb"
        twitfinder: ".social_twit"
        gplusfinder: ".social_gplus"
        emailfinder: ".email"
        disqfinder: ".social_disq"
        count:      ".count"
        
        gaq:         "_gaq"
        
        fburl:      "http://graph.facebook.com/fql"
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

        # add share functionality on google plus
        $(@options.gplusfinder).on "click", (evt) =>
            if url = $(evt.target).attr("data-url")
                gpurl = "https://plus.google.com/share?url=#{url}"
                window.open gpurl, 'pop_up','height=400,width=500,resizable,left=10,top=10,scrollbars=no,toolbar=no'
        
        # add share functionality for twitter
        $(@options.twitfinder).on "click", (evt) =>
            if url = $(evt.target).attr("data-url")
                headline = $(evt.target).attr("data-text")
                twurl = "https://twitter.com/intent/tweet?url=#{url}&text=#{headline}&via=kpcc"
                window.open twurl, 'pop_up','height=350,width=556,resizable,left=10,top=10,scrollbars=no,toolbar=no'
        
        # add share functionality for email
        $(@options.emailfinder).on "click", (evt) =>
            if key = $(evt.target).attr("data-key")
                emurl = "/content/share?obj_key=#{key}"
                window.open emurl, 'pop_up','height=650,width=500,resizable,left=10,top=10,scrollbars=no,toolbar=no'
                
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
        # set a timeout for signalling bad load
        @fbTimeout = setTimeout (=> @_signalFbLoadFailure("Failed to load FB Counts in 5 seconds")), 5000
        @fbPending = Number(new Date)
        
        # Setup the FQL query by mapping all of the URLS from @fbelements and joining with "OR"
        query = "SELECT url, total_count FROM link_stat WHERE " + _.map(@fbelements, (el) ->("url='#{el.attr("data-url")}'")).join(" OR ") + ""
        
        # fire an async request
        $.ajax
            type: "GET"
            url: @options.fburl
            dataType: 'json'
            cache: false
            data: 
                q: query

            success: (res) =>
                # note load success
                clearTimeout @fbTimeout
                @fbTimeout = null
                loadtime = Number(new Date) - @fbPending
                @gaq?.push ['_trackEvent','SocialTools','Facebook Load','',loadtime,true]
                
                # fill in our numbers
                for el in @fbelements
                    if fbobj = _.find(res.data, (obj) -> obj.url == el.attr("data-url"))
                        count = fbobj.total_count
                        $(@options.count,el).text count

            error: (xhr, status, err) =>
                @_signalFbLoadFailure("Could not retrieve data from #{@options.fburl}. Error: #{err}")
            
    _signalFbLoadFailure: (message) ->
        console.log message
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
