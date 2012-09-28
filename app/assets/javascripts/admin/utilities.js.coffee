$ ->
    $("fieldset.form-block legend").on
        click: (event) -> 
            target = $(event.target)
            target.siblings(".fields").toggle()
            target.siblings(".notification").toggle()
