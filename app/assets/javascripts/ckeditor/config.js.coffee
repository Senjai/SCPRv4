CKEDITOR.editorConfig = (config) ->
    config.extraPlugins = 'mediaembed,codemirror'
    
    # Note: All other theme CSS files have been removed from this repo.
    # See https://github.com/w8tcha/CKEditor-CodeMirror-Plugin to download more.
    config.codemirror_theme = "monokai"
    
    config.toolbar = [
        ['Bold', 'Italic', 'Underline', "RemoveFormat"]
        ['NumberedList', 'BulletedList', 'Blockquote']
        ['Link', 'Unlink', 'Image', 'MediaEmbed']
        ['Find', 'Paste', 'PasteText', 'PasteFromWord']
        ['Source', 'Maximize']
    ]
    
    config.language = 'en'
    config.height = "400px"
    config.width  = "635px"
    config.bodyClass = 'ckeditor-body'
    config.contentsCss = "/assets/application.css?bust=true"
    
    config.forcePasteAsPlainText = true
    
    true
