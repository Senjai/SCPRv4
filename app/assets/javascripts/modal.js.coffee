# Generic Modal-Toggler behavior adpated from z-base
class scpr.Modal
    DefaultOptions:
        toggler: ".modal-toggler"
        modalId: 'data-modal-id'
        modal: ".modal-popup"

    constructor: (options={}) ->
        @options = _.defaults options, @DefaultOptions
        
        if $(@options.toggler).length and $(@options.modal).length
            $(@options.toggler).on
                # Specify a modal ID to pop-up. If no modalID is specified on the link, then it will try to find the closest modal.
                click: (event) =>
                    if $(event.target).attr(@options.modalId)
                        $(".modal-popup#"+$(event.target).attr(@options.modalId)).toggle()
                    else
                        if $(event.target).next(@options.modal).length then $(event.target).next(@options.modal).toggle() else $(event.target).closest(@options.modal).toggle()
                    
                    $("body").toggleClass("with-audio-bar")

                    if event.preventDefault then event.preventDefault() else event.returnValue = false
                    return false

            $("body, #opaque-cover").on
                # Decide when to close the modal, adapted from zbase.js
                click: (event) =>
                    if $(@options.modal).is(":visible") and !$(event.target).is(@options.toggler) and !$(event.target).is(@options.modal) and !$(event.target).closest(@options.modal).length
                        $(@options.modal).hide()
                        $("body").removeClass("with-audio-bar")

            # Hide the modal if the Esc key is pressed
            $(document).keyup (event) =>
                if event.keyCode is 27 and $(@options.modal).is(":visible")
                    $(@options.modal).hide()
                    $("body").removeClass("with-audio-bar")
           
