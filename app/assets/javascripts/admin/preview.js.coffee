#= require scprbase

##
# Preview
#
# Preview functionality for the CMS
#
class scpr.Preview
    constructor: ->
        $("form button#preview").on
            click: (event) ->
                event.preventDefault()
                
                form = $(@).closest("form")
                data = form.serialize()
                
                modalEl   = $('#preview-modal')
                modalBody = $('.modal-body', modalEl)
                
                modalEl.modal('toggle')
                modalBody.spin()
                
                $.ajax
                    type: 'POST'
                    dataType: "json"
                    url: "/r/admin/preview/"
                    data:
                        data
                    
                    statusCode:
                        200: (data, textStatus, jqXHR) ->
                            modalBody.spin(false)
                            modalBody.html data.preview
                            console.log "200"
                        404: (jqXHR, textStatus, errorThrown) ->
                            console.log "404"
                        500: (jqXHR, textStatus, errorThrown) ->
                            console.log "500"
