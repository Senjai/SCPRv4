#= require scprbase

##
# Preview
#
# Preview functionality for the CMS
#
class scpr.Preview
    constructor: ->
        _t = @
        
        $("form #preview-submit button.js-preview-btn").on
            click: (event) ->
                event.preventDefault()
                target = $(@)
                
                form = target.closest("form")
                data = form.serialize()
                
                $.ajax
                    type: 'PUT'
                    dataType: "html"
                    url: "preview"
                    data:
                        data
                    
                    beforeSend: (jqXHR, settings) =>
                        _t.openWindow(target.data("windowOptions"))
                        _t.window.document.write(JST['admin/templates/loading']())
                        _t.window.document.close()
                    statusCode:
                        200: (data, textStatus, jqXHR) ->
                            _t.window.document.write(data)
                            _t.window.document.close()
                        404: (jqXHR, textStatus, errorThrown) ->
                            console.log "404"
                        500: (jqXHR, textStatus, errorThrown) ->
                            console.log "500"
    
    openWindow: (options="")->
        if !@window or (@window and @window.closed)
            @window = window.open("/", "preview", "scrollbars=yes,menubar=no,location=no,directories=no,toolbar=no,#{options}")
        else
            @window.focus()
    
    writeWindow: ->
        #
    