# Bootstrap things

# Scrollspy has to be initiated here, 
# instead of via data- attributes, 
# otherwise it's buggy. I don't know why.
offset = 160
nav    = "#form-nav"

$ ->
    $("select").select2()

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
