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
                form   = target.closest("form")
                
                # Update any hidden textareas that are using CKEditor
                # Then serialize the form.
                for id,instance of CKEDITOR.instances
                    instance.updateElement()

                data = form.serialize()
                
                $.ajax
                    type: 'PUT'
                    dataType: "html"
                    url: "preview"
                    data:
                        data
                    
                    beforeSend: (jqXHR, settings) ->
                        _t.openWindow(target.data("windowOptions"))
                        _t.writeToWindow(JST['admin/templates/loading']())

                    statusCode:
                        200: (data, textStatus, jqXHR) ->
                            _t.writeToWindow(data)
                        404: (jqXHR, textStatus, errorThrown) ->
                            _t.writeToWindow("Error: #{errorThrown}")
                        500: (jqXHR, textStatus, errorThrown) ->
                            _t.writeToWindow("Error: #{errorThrown}")

    #--------------------
    # Open the preview window.
    # If it doesn't exist yet, create it.
    # If it already exists, just focus on it.
    openWindow: (options="")->
        if !@window or (@window and @window.closed)
            @window = window.open("/", "preview", "scrollbars=yes,menubar=no,location=no,directories=no,toolbar=no,#{options}")
        else
            @window.focus()

    #--------------------
    # Write some data to the preview window.
    # This shouldn't get called before @window is set.
    writeToWindow: (data) ->
        @window.document.write(data)
        @window.document.close()
