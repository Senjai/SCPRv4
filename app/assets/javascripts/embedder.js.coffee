class scpr.Embedder
    defaults:
        placeholderFinder: ".embed-placeholder"

    constructor: (options={}) ->
        @options = _.defaults options, @defaults
        @embeds = $(@options.placeholderFinder)
        @swapEmbeds()

    swapEmbeds: ->
        for placeholder in @embeds
            $(placeholder).oembed()
