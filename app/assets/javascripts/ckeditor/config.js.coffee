# Global Configuration
CKEDITOR.editorConfig = (config) ->
    config.extraPlugins = 'mediaembed,codemirror,autosave'

    config.codemirror =
        # https://github.com/w8tcha/CKEditor-CodeMirror-Plugin 
        theme                   : 'monokai'
        lineNumbers             : true
        lineWrapping            : true
        matchBrackets           : true
        matchTags               : true
        autoCloseTags           : false
        enableSearchTools       : false
        showSearchButton        : false
        enableCodeFolding       : true
        enableCodeFormatting    : true
        autoFormatOnStart       : false
        autoFormatOnUncomment   : false
        highlightActiveLine     : true
        highlightMatches        : false
        showTabs                : false
        showFormatButton        : false
        showCommentButton       : false
        showUncommentButton     : false

    config.autosave_SaveKey = "autosave-#{window.location.pathname}"

    config.toolbar = [
        ['Bold', 'Italic', 'Underline', "RemoveFormat"]
        ['NumberedList', 'BulletedList', 'Blockquote']
        ['Link', 'Unlink', 'Image', 'MediaEmbed']
        ['Find', 'Paste']
        ['Source', 'Maximize']
    ]

    config.language     = 'en'
    config.height       = "400px"
    config.width        = "635px"
    config.bodyClass    = 'ckeditor-body'
    config.contentsCss  = "/assets/application.css"
    config.baseHref     = "http://www.scpr.org/"

    config.disableNativeSpellChecker    = false
    config.forcePasteAsPlainText        = true

    true
