$(document).ready ->
    raw = "content-raw"
    formatted = "content-formatted"
    toggled = "toggled"

    # Formatted by default
    $("[data-role='#{raw}']").hide()
    $("#toggle_formatted").addClass(toggled)
    
    $("#toggle_raw").on
        click: (event) =>
            $(".#{toggled}").removeClass(toggled)
            $(event.target).addClass(toggled)
            $("[data-role='#{raw}']").show()
            $("[data-role='#{formatted}']").hide()
    
    $("#toggle_formatted").on
        click: (event) =>
            $(".#{toggled}").removeClass(toggled)
            $(event.target).addClass(toggled)
            $("[data-role='#{formatted}']").show()
            $("[data-role='#{raw}']").hide()
