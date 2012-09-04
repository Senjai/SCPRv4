$(document).ready ->
    $("input.datepicker").datepicker()

    # Multi-American stuff
    rawRole = "content-raw"
    formattedRole = "content-formatted"

    raw = "[data-role='#{rawRole}']"
    formatted = "[data-role='#{formattedRole}']"
    
    toggled = "toggled"
    wrapper = ".resource_attribute"
    
    # Formatted by default
    $(raw).hide()
    $(".toggle_formatted").addClass(toggled)
    
    # events
    $(".toggle_raw").on
        click: (event) =>
            $(event.target).siblings(".#{toggled}").removeClass(toggled)
            $(event.target).addClass(toggled)
            $(event.target).closest(wrapper).find(raw).show()
            $(event.target).closest(wrapper).find(formatted).hide()
    
    $(".toggle_formatted").on
        click: (event) =>
            $(event.target).siblings(".#{toggled}").removeClass(toggled)
            $(event.target).addClass(toggled)
            $(event.target).closest(wrapper).find(formatted).show()
            $(event.target).closest(wrapper).find(raw).hide()
