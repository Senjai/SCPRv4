#= require scprbase

class scpr.ActiveContent
    DefaultOptions:
        tabs: [],
        dvalue: 1,
        cookie: null
    
    constructor: (options) ->
        @options = _(_({}).extend(this.DefaultOptions)).extend( options || {} )
    
        _(@options.tabs).each (id,idx) => 
            $("##{id}_c").bind "click", => @clickedTab(id,idx)
            
        # set one visible
        init = @options.dvalue
        
        if @options.cookie
            init = scpr.Cookie.get(@options.cookie) || @options.dvalue
            
        @clickedTab(@options.tabs[init-1],init-1)
        
    clickedTab: (tab,idx) -> 
        # turn everyone off
        for id in @options.tabs
            $("##{id}").hide()
            $("##{id}_c").removeClass("active")
            
        # turn ours on
        $("##{tab}").show()
        $("##{tab}_c").addClass('active')
        
        # set a cookie
        if @options.cookie
            scpr.Cookie.set(@options.cookie,idx+1,86400)
        
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
                    scpr.Cookie.set(@options.cookie,true)
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