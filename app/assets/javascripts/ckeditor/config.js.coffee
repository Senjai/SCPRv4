CKEDITOR.editorConfig = (config) ->
    config.toolbar = [
        ['Bold', 'Italic', 'Strike']
        ['NumberedList', 'BulletedList', 'Blockquote']
        ['Link', 'Unlink', 'Image']
        ['Source']
    ]
    config.height = "400px"
    config.width  = "635px"
    config.contentsCss = "/assets/application.css"
    true
