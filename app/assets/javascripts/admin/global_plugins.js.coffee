# Bootstrap things

# Scrollspy has to be initiated here, 
# instead of via data- attributes, 
# otherwise it's buggy. I don't know why.
offset = 160
nav    = "#form-nav"

$ ->
    # Set a blank placeholder for all selects.
    # Also allow clearing for any option.
    # If you don't want this on a certain select element,
    # add the `include_blank: false` option to the rails
    # helper.
    #
    # Note: This also gets called in field_manager.
    # TODO: Make it so we don't have to call it twice.
    $("select").select2
        placeholder: " "
        allowClear: true
    
    $spy = $("body").scrollspy
        target: nav
        offset: offset

    $('[rel="tooltip"]').tooltip()

    # Since we have some fixed elements at the
    # top of the screen, we have to offset the
    # anchors when they're clicked in the form
    # nav.
    $("#{nav} li a").on
        click: (event) ->
            event.preventDefault()
            href = $(@).attr('href')
            window.location.hash = href
            $(href)[0].scrollIntoView()
            window.scrollBy(0, -offset + 80)
            false

    true
