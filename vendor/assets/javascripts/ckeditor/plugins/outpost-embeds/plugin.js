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
    CKEDITOR.plugins.add('outpost-embeds', {
      hidpi: true,
      icons: "outpostembeds",

      findEmbeds: function() {
        var embeds =[];

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

        return embeds;
      },

      init: function(editor) {
        var plugin = this;

        CKEDITOR.dialog.add('OutpostEmbedsDialog', function (instance) {
          return {
            title : 'Embeds',
            minWidth : 550,
            minHeight : 200,

            contents: [{
              id: "main",
              elements: [
                {
                  id    : 'embed-notification',
                  type  : 'html',
                  html  : "<strong>There are no embeds yet! Add them below.</strong>"
                },
                {
                  id    : 'embed-selection',
                  type  : 'radio',
                  label : "Select Embed",
                  items: [""]
                } // element
              ] // elements
            }], // contents

            onShow: function() {
              var notification = this.getContentElement('main', 'embed-notification'),
                  embeds       = plugin.findEmbeds();

              if(embeds.length) {
                notification.hide()
              } else {
                notification.show()
              }

              return;

              for(var i=0; i < embeds.length; i++) {
                var embed = embeds[i],
                    title = embed.title,
                    url   = embed.url

                el.append(url)

                // items.push([
                //   title + " (" + url + ")",
                //   "<a href='"+url+"' class='embed-placeholder'>"+title+"</a>"
                // ]);
              }

              var elements = this.definition.getContents('main').elements;
              for(var i = 0; i < elements.length; i++) {
                var el   = elements[i],
                    func = el.onShow;

                if(func) func.apply(el);
              }
            },

            onOk: function() {
              if($("#embed-selection").length) {
                var p = instance.document.createElement('p');
                p.setHtml(this.getValueOf('main', 'embed-selection'));
                instance.insertElement(p);
              }
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
