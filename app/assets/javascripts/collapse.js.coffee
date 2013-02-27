# Just a simplified version of bootstrap-collapse
$ ->
    $(".collapse-toggle").on
        click: -> 
            $($(@).data('target')).toggle()
