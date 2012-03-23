#= require scprbase

# Generic Modal-Toggler behavior adpated from z-base
class scpr.Modal
    DefaultOptions:
        toggler: ".modal-toggler"
        modalId: 'data-modal-id'
        modal: ".modal-popup"

        
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend( options || {} )
        
        if $(@options.toggler).length and $(@options.modal).length
            console.log "Toggler count: #{$(@options.toggler).length}; Modal count: #{$(@options.modal).length}"
            
            $(@options.toggler).on
                click: (event) =>
                    if $(event.target).attr(@options.modalId)
                        $("#"+$(event.target).attr(@options.modalId)).toggle()
                    else
                        if $(event.target).next(@options.modal).length then $(event.target).next(@options.modal).toggle() else $(event.target).closest(@options.modal).toggle()

            $("body").on
                click: (event) =>
                    if $(@options.modal).is(":visible") and !$(event.target).is(@options.toggler) and !$(event.target).is(@options.modal) and !$(event.target).closest(@options.modal).length
                        $(@options.modal).hide()
