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
    
    constructor: (options={}) ->
        @options = _.defaults options, @DefaultOptions
        
        # Setup Attributes
        @slugField  = $ @options.field
        @titleAttrs = @options.titleAttributes
        
        # Loop through title attributes and find the first one that matches
        for attr in @titleAttrs
            @titleField = $ @slugField.closest("form").find("input[name*='[#{attr}]']")[0]
            break if !_.isEmpty(@titleField)
        
        # If there's no title field, then there's no 
        # point in doing anything else.
        return if !@titleField
        
        @maxLength  = @options.maxLength
        @button     = $ JST['admin/templates/slug_generate_button']()

        # If we found a matching field, 
        # render the generate button and add it after the slug field
        @slugField.after(@button)
        @button.on
            click: (event) =>
                @updateSlug(@titleField.val())
                event.preventDefault()
                
    #------------------
    
    updateSlug: (value) ->
        @slugField.val @slugify(value)
    
    #------------------
    
    slugify: (str) ->
        str.toLowerCase()
           .replace(/\s+/g, "-")     # Spaces -> `-`
           .replace(/-{2,}/g, '-')   # Fix accidental double-hyphens
           .replace(/[^\w\-]+/g, '') # Remove non-word characters/hyphen
           .replace(/^-+/, '')       # Trim hyphens from beginning
           .substring(0, @maxLength) # Just the first 50 characters
           .replace(/-+$/, '')       # Trim hyphens from end
