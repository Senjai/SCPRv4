/*
* Embed dialogue for Outpost.
*
* Plugin name:      outpost-embeds
* Menu button name: OutpostEmbeds
*
* @author Bryan Ricker / SCPR
* @version 0.1
*/
(function() {
    CKEDITOR.plugins.add( 'outpost-embeds', {
      icons: 'mediaembed',
      init: function(editor) {
        var self = this;
        CKEDITOR.dialog.add('OutpostEmbedsDialog', function (instance) {
          return {
            title : 'Embeds',
            minWidth : 550,
            minHeight : 200,
            contents : [
              {
                id : 'outpost-embeds',
                expand : true,
                elements : [
                  {
                    id            : 'embedArea',
                    type          : 'textarea',
                    label         : 'URL',
                    autofocus     : 'autofocus',
                  }
                ]
              }
            ],

            onLoad: function() {
              this.embeds = [];
              self = this;

              $('#embeds-fields tr').each(function() {
                var title = $(this).find('input[type=text]').val()
                    url   = $(this).find('input[type=url]').val();

                if(url != "") {
                  self.embeds.push({
                    title : title,
                    url   : url
                  });
                }
              });
            },

            onOk: function() {
              for (var i = 0; i < window.frames.length; i++) {
                if (window.frames[i].name == 'iframeMediaEmbed') {
                  var content = window.frames[i].document.getElementById("embed").value;
                }
              }
              div = instance.document.createElement('div');
              div.setHtml(this.getContentElement('iframe', 'embedArea').getValue());
              instance.insertElement(div);
            }
          }; // return
        });

        editor.addCommand('OutpostEmbeds',
          new CKEDITOR.dialogCommand('OutpostEmbedsDialog', {
            allowedContent: 'a[*](*)'
          })
        );

        editor.ui.addButton('OutpostEmbeds', {
          label     : 'Outpost Embeds',
          command   : 'OutpostEmbeds',
          toolbar   : 'outpost-embeds'
        });
      } // init
    }); // add
})(); // closure
