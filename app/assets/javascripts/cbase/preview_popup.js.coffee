#= require bootstrap-modal

#= require t_cbase/preview_headers


class scpr.ContentBaseAPI.PreviewPopup
    DefaultOptions:
        el: "#cbPreviewButton"
        map: []
        css: "http://www.scpr.org/assets/application.css"
        
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend options || {}
        
        @cbapi = @options.cbapi || new ContentBaseAPI()
                    
        @_init = false
        
        # -- create hidden element for dimensioning -- #
        @hidden = $ "<div/>", style:"position:absolute; top:-10000px; width:0px; height:0px;"
        $('body').append @hidden
        
        @shell = null
        @frame = null
        @content = null
        
        @map = {}
        
        _(@options.map).each (v,k) =>
            el = $(v)
            if el.length
                # set up mapping for live updates
                @map[k] = el

        # attach click listener
        $(@options.el).on "click", (evt) =>
            args = {}
            
            for k,v of @map
                args[k] = v.val()
            
            console.log "args is ", args
            
            $.ajax 
                url: "#{scpr.API_ROOT}/content/#{@options.obj_key}/preview"
                type: "POST"
                data: args
                xhrFields: { withCredentials:true }
                dataType: "json"
                success: (r) =>
                    console.log "got success of ", r
                    
                    # if there isn't already a popup window, create one
                    if !@_init
                        @_createFrame()

                    @content.html r.preview
                        
                    @shell.modal("show")
                error: (r) =>
                    console.log "got error of ", r
                    #cb? null
                
            # cancel click bubbling
            false
            
    #----------
                    
    _createFrame: ->
        # inject our css
        @style = $ "<style/>", text:JST['t_cbase/style']()
        $("head").append @style
        
        # create our iframe
        height = $(window).height() - 100
        width = 770
        
        @shell = $ "<iframe/>", class:"modal fade", style:"width:#{width}px;height:#{height}px;margin: -#{height/2}px 0 0 -#{width/2}px;padding: 20px"
        $("body").append @shell
        
        # dig in to get the new document
        @frame = @shell[0].contentWindow.document
        @frame.open()
        @frame.close()
        
        @content = $ "<div/>"
        $("head", $ @frame).html JST['t_cbase/preview_headers']()
            
        #$("body", $ @frame).css margin:"20px"
        $("body", $ @frame).append @content
        
        @_init = true