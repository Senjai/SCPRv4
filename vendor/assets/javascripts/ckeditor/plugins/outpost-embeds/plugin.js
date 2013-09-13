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

        CKEDITOR.on('dialogDefinition', function(ev) {
          var dialogName = ev.data.name;
          var dialogDefinition = ev.data.definition;

          if (dialogName == 'OutpostEmbedsDialog') {
            var main = dialogDefinition.getContents('main');
            var embeds = [];

            $('#embeds-fields tr').each(function() {
              var title = $(this).find('input[type=text]').val(),
                  url   = $(this).find('input[type=url]').val();

              if(url != "") {
                embeds.push({
                  title : title,
                  url   : url
                })
              }
            });

            var items = [];
            for(i=0; i < embeds.length; i++) {
              var embed = embeds[i],
                  title = embed.title,
                  url   = embed.url

              items.push([
                title + " (" + url + ")",
                "<a href='"+url+"' class='embed-placeholder'>"+title+"</a>"
              ])
            }

            main.add({
              id    : 'embed-selection',
              type  : 'radio',
              label : "Select Embed",
              items : items
            });
          }
        });

        CKEDITOR.dialog.add('OutpostEmbedsDialog', function (instance) {
          this.embeds = [];

          return {
            title : 'Embeds',
            minWidth : 550,
            minHeight : 200,

            contents: [{
              id: "main",
              elements: []
            }],

            onOk: function() {
              var p = instance.document.createElement('p');
              console.log(this.getValueOf('main', 'embed-selection'));
              p.setHtml(this.getValueOf('main', 'embed-selection'));
              instance.insertElement(p);
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
