$ ->
    # Permissive Configuration, for Flatpages
    $('.cke-editor-permissive').ckeditor({
        allowedContent: true
    })

    # Restrictive configuration
    # For articles
    $('.cke-editor-restrictive').ckeditor({
        # P and BR are added by CKEditor
        extraAllowedContent: [
            "a[*](*){*}",
            "img[*](*){*}",
            "strong", "em", "small",
            "u", "s", "i", "b",
            "blockquote",
            "div[data-href]", # data-href is for facebook embeds
            "ul", "ol", "li",
            "hr",
            "h1", "h2", "h3", "h4", "h5", "h6",
            "script[src,charset,async]",
            "iframe[*]", "embed[*]", "object[*]",
            "cite", "mark", "time",
            "dd", "dl", "dt",
            "table", "th", "tr", "td", "tbody", "thead", "tfoot"
        ].join(";")
    })
