#= require scprbase

class scpr.ContentCarousel
    DefaultOptions:
        carouselWrapperClass: "content-carousel"
        carouselClass: "carousel"
        nextBtn: "a.next"
        prevBtn: "a.prev"
        animationSpeed: 300

    #----------
    
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
        @carousel = $(".#{@options.carouselWrapperClass} .#{@options.carouselClass}")
        
        @fetchContent()
        
        $(".#{@options.carouselWrapperClass} #{@options.nextBtn}").on
            click: (event) =>
                event.preventDefault()
                if $(event.target).hasClass("disabled")
                    return false

                @fetchContent(parseInt(@carousel.attr("data-current-page"), 10) + 1)
                
        $(".#{@options.carouselWrapperClass} #{@options.prevBtn}").on
            click: (event) =>
                event.preventDefault()
                if $(event.target).hasClass("disabled")
                    return false

                @fetchContent(parseInt(@carousel.attr("data-current-page"), 10) - 1)

    fetchContent: (page=1) ->
        $.ajax
            type: "GET"
            url: @options.dataUrl
            data: 
                page: page
            dataType: "script"
            beforeSend: (xhr) =>
                $(@carousel).spin("large")
                console.log "Sending Request..."
            error: (xhr, status, error) => 
                $(@carousel).html "Error loading content. Please refresh the page and try again. (#{error})"
            complete: (xhr, status) => 
                $(@carousel).spin(false)
                console.log "Finished request. Status: #{status}"
