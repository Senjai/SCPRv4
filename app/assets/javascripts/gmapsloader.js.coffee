#= require scprbase

# Watches for elements with class ".map-loader" and loads google maps into specified container
# If `data-map-id` is not specified on the map loader, then it will find the first element with id="map-canvas"
# data-address is required

class scpr.GMapsLoader
    DefaultOptions:
        mapLink: ".map-link"
        address: "data-address"
        mapId: "data-map-id"
        defaultMapId: "#map-canvas"
        errorsDiv: "#map-errors"
        errorMsg: "There was a problem loading the map. Please go to http://maps.google.com and search from there."
        zoom: 12
        # The defaults below point (approximately) to the Crawford Family Forum, just so the map has something relevantto point to while it's geocoding the event address
        defaultLat: 34.1372402
        defaultLong: -118.1487027

    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend( options || {} )

        $(@options.mapLink).on
            # Specify a map ID to load. If no map ID is specified on the link, then it will load the first element on the page with id="map-canvas"
            click: (event) =>
                if $(event.target).attr(@options.mapId)
                    mapElement = $("#"+$(event.target).attr(@options.mapId))
                    return false if $.trim(mapElement.html()) # don't do anything if the element already has a map in it
                else
                    mapElement = $(@options.defaultMapId)
                    return false if $.trim(mapElement.html()) # don't do anything if the element already has a map in it
                
                @mapInit mapElement, $(event.target).attr(@options.address)


    mapInit: (mapElement, address) ->
        if typeof(mapElement) == undefined # Make sure there is something to load the map into
            console.log "There is nowhere to load the map into."
            return false
    
        if !address # Make sure Google Maps has something to do when it's loaded
            @notifyError()
            return false

        mapOpts = 
           zoom: @options.zoom
           center: new google.maps.LatLng(@options.defaultLat, @options.defaultLong)
           mapTypeId: google.maps.MapTypeId.ROADMAP
    
        map = new google.maps.Map(mapElement[0], mapOpts)
        @getLatLong(address, map)


    getLatLong: (address, map) ->
        geocoder = new google.maps.Geocoder()
        geocoder.geocode { 'address': address }, (results, status) =>
             if status == google.maps.GeocoderStatus.OK
                map.setCenter(results[0].geometry.location)
                marker = new google.maps.Marker
                    map: map
                    position: results[0].geometry.location
         
              else
                @notifyError("Sorry, we couldn't find the location of this event.")
    

    notifyError: (msg=@options.errorMsg) ->
        $(@options.errorsDiv).append msg

