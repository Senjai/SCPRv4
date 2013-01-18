# Find slug fields and load them up
$ ->
    for field in $("form.simple_form input[name*='[slug]']")
        new scpr.AutoSlugField(field: field)

##
# AutoSlugField
#
# Takes a field and turns it into a slug on-the-fly
#
class scpr.AutoSlugField
    DefaultOptions:
        titleAttributes: ["headline", "name", "title"]
        maxLength:       50
    
    constructor: (options) ->
        @options = _.defaults options||{}, @DefaultOptions
        
        # Setup Attributes
        @slugField  = $ @options.field
        @titleAttrs = @options.titleAttributes
        @maxLength  = @options.maxLength
        
        # Loop through title attributes and find the first one that matches
        for attr in @titleAttrs
            @titleField = $ @slugField.closest("form").find("input[name*='[#{attr}]']")[0]
            break if !_.isEmpty(@titleField)

        # If we found a matching field, 
        # and if the slug field is empty when the page loads,
        # register a keyup event for it
        if @titleField and _.isEmpty(@slugField.val())
            @titleField.on
                keyup: (event) => @updateSlug($(event.target).val())
    
    updateSlug: (value) ->
        # Slugs should not be longer than @maxLength characters
        slug = @slugify(value)
        if slug.length < @maxLength
            @slugField.val slug
    
    slugify: (str) ->
        str.toLowerCase()
           .replace(/\s+/g, "-")     # Spaces -> `-`
           .replace(/-{2,}/g, '-')   # Fix accidental double-hyphens
           .replace(/[^\w\-]+/g, '') # Remove non-word characters/hyphen
           .replace(/^-+/, '')       # Trim hyphens from beginning
           .replace(/-+$/, '')       # Trim hyphens from end
