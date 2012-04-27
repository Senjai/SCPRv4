#= require scprbase

class scpr.ContentCarousel
    DefaultOptions:
        carouselWrapperClass: "content-carousel-wrapper"
        carouselClass: "carousel"
        currentClass: "carousel-current"
        prevClass: "carousel-prev"
        nextClass: "carousel-next"
        nextBtn: "a.next"
        prevBtn: "a.prev"
        animationSpeed: 300

    #----------
    
    constructor: (items,options) ->
        console.log "Found carousel"

        @options = _.defaults options||{}, @DefaultOptions
        @carousel = $(".#{@options.carouselClass}")
        @current = $(".#{@options.carouselClass} .#{@options.currentClass}")
        @next = $(".#{@options.carouselClass} .#{@options.nextClass}")
        @prev = $(".#{@options.carouselClass} .#{@options.prevClass}")
        
        $(".#{@options.carouselWrapperClass} #{@options.nextBtn}").on
            click: (event) =>
                event.preventDefault()
                @slideNext()
                
        $(".#{@options.carouselWrapperClass} #{@options.prevBtn}").on
            click: (event) =>
                event.preventDefault()
                @slidePrev()
        
    slideNext: ->
        @carousel.animate
            left: @carousel.width() * -1
        , @options.animationSpeed
            

    slidePrev: ->
        @carousel.animate
            left: @carousel.width()
        , @options.animationSpeed, ->
            @current.removeClass(@options.currentClass).addClass(@options.prevClass)
            @prev.removeClass(@options.prevClass)
            @next.removeClass(@options.nextClass).addClass(@options.currentClass)