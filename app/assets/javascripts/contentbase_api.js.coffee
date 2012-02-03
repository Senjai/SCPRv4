#= require scprbase

#= require underscore
#= require backbone
#= require jquery-ui-1.8.17.sortable_w_effects

class scpr.ContentBaseAPI
    DefaultOptions:
        api_path: "http://scprv4.dev/dashboard/api"
        
    @DjangoToContentType:
        15:     'news/story'
        24:     'shows/segment'
        44:     'blogs/entry'
        115:    'content/shell'
        
    @ContentTypeToDjango:
        'news/story':       15
        'shows/segment':    24
        'blogs/entry':      44
        'content/shell':    115
            
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend options || {}
        api_root = @options.api_path
        
    #----------
    
    content_by_url: (url,cb) ->
        $.ajax 
            url: "#{scpr.API_ROOT}/content/by_url?id=#{encodeURIComponent(url)}"
            params: { id:url }
            xhrFields: { withCredentials:true }
            success: (r) =>
                console.log "got success of ", r
                cb? new ContentBaseAPI.Content r
            error: (r) =>
                console.log "got error of ", r
                cb? null
                
    #----------
    
    buildContentDropZone: (args) ->
        new ContentBaseAPI.ContentDropZone args
    
    #----------

    class ContentBaseAPI.ContentDropZone
        DefaultOptions:
            key: "contents"
            fields: ['content_type','object_id']
            order_key: 'position'
            autofill: null
            del_key: 'DELETE'
            el: null

        constructor: (options) ->
            @options = _(_({}).extend(@DefaultOptions)).extend options || {}

            @cbapi = new ContentBaseAPI()

            $ =>
                @el = $(@options.el)

                if !_(@el).first()
                    console.log "Element invalid."
                    return false

                # read in existing django-admin forms
                @parser = new ContentBaseAPI.DjangoAdminParser 
                    key:        @options.key
                    fields:     @options.fields
                    autofill:   @options.autofill
                    del_key:    @options.del_key

                @objects = @parser.objects

                # create our content collection

                @contents = new ContentBaseAPI.ContentCollection()

                if @objects.length > 0
                    @contents.fetch data:{ids:(o.obj_key || @djangoToObjKey(o.content_type,o.object_id) for o in @objects)}

                # wipe out the element contents and render our content
                @view = new ContentBaseAPI.ContentsView collection:@contents

                @form = $ "<div/>"
                @drop = $ "<div/>"

                @el.html @drop
                @drop.html @view.render().el
                @el.append @form

                @contents.on "all", => 
                    i = 0

                    @objects = @contents.map (m) =>
                        [type,id] = @objKeyToDjango m.get('obj_key')

                        console.log "converted #{m.get('obj_key')} into ", type, id

                        obj = 
                            content_type: type
                            object_id: id
                            position: i

                        i++

                        return obj

                    console.log "building form from ", @objects

                    @form.html @parser.constructForm(@objects)

                @el.on "dragenter", (evt) => @_dropDragEnter evt
                @el.on "dragover", (evt) => @_dropDragOver evt
                @el.on "drop", (evt) => @_dropDrop evt

                @el.show()

        #----------

        djangoToObjKey: (type,id) ->
            "#{ ContentBaseAPI.DjangoToContentType[type] }:#{id}"

        objKeyToDjango: (obj_key) ->
            [ctype,id] = obj_key.split(":")

            return [ContentBaseAPI.ContentTypeToDjango[ctype],id]

        #----------

        _dropDragEnter: (evt) ->
            evt = evt.originalEvent
            evt.stopPropagation()
            evt.preventDefault()
            false

        _dropDragOver: (evt) ->        
            evt = evt.originalEvent
            evt.stopPropagation()
            evt.preventDefault()
            false

        #----------

        _dropDrop: (evt) ->
            evt = evt.originalEvent

            evt.stopPropagation()
            evt.preventDefault()

            uri = evt.dataTransfer.getData 'text/uri-list'
            console.log "uri-list is ", uri

            # check if this is a content URL
            @cbapi.content_by_url uri, (c) =>
                if c
                    @contents.add(c)
                else
                    $(@options.el)?.animate {"background-color":"#fcc"},
                        duration: "fast",
                        complete: $(@options.el).animate({"background-color":"#fff"},duration:"fast")
        
    #----------
    
    
            
    @Content: Backbone.Model.extend
        urlRoot: "#{scpr.API_ROOT}/content/"
        
        sync: (method,model,options) ->
            Backbone.sync(method,model,_.extend({xhrFields:{withCredentials:true}},options))
    
        initialize: ->
            
    #----------        
            
    @ContentCollection: Backbone.Collection.extend
        url: "#{scpr.API_ROOT}/content/"
        
        sync: (method,model,options) ->
            Backbone.sync(method,model,_.extend({xhrFields:{withCredentials:true}},options))
            
        # If we have an ORDER attribute, sort by that.  Otherwise, sort by published_at 
        comparator: (asset) ->
            asset.get("ORDER") || -Number(new Date(asset.get("published_at")))
                    
    #----------
    
    @ContentView: Backbone.View.extend
        tagName: "li"
        
        template:
            """
            <i>(<%= obj_key %>)</i>
            <h3><%= headline %></h3>
            <p><%= teaser %></p>
            """
            
        initialize: ->
            @model.on "change", @render()
            
        render: ->
            @$el.html _.template @template, @model.toJSON()
            
    #----------
    
    @ContentsView: Backbone.View.extend            
        tagName: "ul"
        className: "contentsView"
        
        initialize: ->
            @_views = {}

            @collection.bind 'add', (f) => 
                console.log "add event from ", f
                @collection.sort()

            @collection.bind 'remove', (f) => 
                console.log "remove event from ", f
                @collection.sort()

            @collection.bind 'reset', (f) => 
                console.log "reset event from ", f                    
                _(@_views).each (av) => $(av.el).detach()
                @_views = {}
                @render()
            
        render: ->
            # set up views for each collection member
            @collection.each (f) => 
                # create a view unless one exists
                @_views[f.cid] ?= new ContentBaseAPI.ContentView model:f

            # make sure all of our view elements are added
            $(@el).append( _(@_views).map (v) -> v.el )

            $( @el ).sortable
                update: (evt,ui) => 
                    _(@el.children).each (li,idx) => 
                        @collection.get(id).attributes.ORDER = idx
                        console.log("set idx for #{id} to #{idx}")
                    @collection.sort()

            @
            
    #----------
    
    class ContentBaseAPI.DjangoAdminParser
        DefaultOptions:
            key: "contents"
            fields: ['content_type','object_id','position']
            autofill: null
            del_key: 'DELETE'

        constructor: (options) ->
            @options = _(_({}).extend(@DefaultOptions)).extend options || {}
                    
            # look for count
            @count = 0
            if c = _($ "#id_#{@options.key}-TOTAL_FORMS").first()
                @count = c.value
                
            console.log "count is ", @count
            
            @objects = []
            @ids = []
            
            if @count > 0
                # need to grab values from the form
                
                i = 0
                _(@count).times =>
                    if id = $ "#id_#{@options.key}-#{i}-id"
                        # form exists...
                        @ids.push id[0].value
                        obj = id: id[0].value

                        # get the fields
                        obj[f] = $("#id_#{@options.key}-#{i}-#{f}")?[0].value for f in @options.fields
                        
                        @objects.push obj
                        
            console.log "objects is ", @objects
                    
        #----------
                
        constructForm: (newobj = @objects) ->
            div = $ "<div/>"
            
            # write the form meta info
            div.append $ "<input/>", 
                type:   "hidden", 
                name:   "#{@options.key}-TOTAL_FORMS", 
                id:     "id_#{@options.key}-TOTAL_FORMS",
                value:  newobj.length

            div.append $ "<input/>", 
                type:   "hidden", 
                name:   "#{@options.key}-INITIAL_FORMS", 
                id:     "id_#{@options.key}-INITIAL_FORMS",
                value:  @ids.length
                
                        
            for obj,i in newobj
                # set our id
                div.append $ "<input/>",
                    type:   "hidden", 
                    name:   "#{@options.key}-#{i}-id", 
                    id:     "id_#{@options.key}-#{i}-id",
                    value:  @ids[i] || null
                    
                for f in @options.fields
                    div.append $ "<input/>",
                        type:   "hidden", 
                        name:   "#{@options.key}-#{i}-#{f}", 
                        id:     "id_#{@options.key}-#{i}-#{f}",
                        value:  obj[f] || ""
                
                _(@options.autofill).each (v,f) =>
                    div.append $ "<input/>",
                        type:   "hidden", 
                        name:   "#{@options.key}-#{i}-#{f}", 
                        id:     "id_#{@options.key}-#{i}-#{f}",
                        value:  v
                        
            # need to present empties for any removed rows
            _(_(@ids).rest(newobj.length)).each (id,i) =>
                i = i + newobj.length
                
                div.append $ "<input/>",
                    type:   "hidden", 
                    name:   "#{@options.key}-#{i}-id", 
                    id:     "id_#{@options.key}-#{i}-id",
                    value:  id

                for f in @options.fields
                    div.append $ "<input/>",
                        type:   "hidden", 
                        name:   "#{@options.key}-#{i}-#{f}", 
                        id:     "id_#{@options.key}-#{i}-#{f}",
                        value:  ""

                _(@options.autofill).each (v,f) =>
                    div.append $ "<input/>",
                        type:   "hidden", 
                        name:   "#{@options.key}-#{i}-#{f}", 
                        id:     "id_#{@options.key}-#{i}-#{f}",
                        value:  ""
                        
                if @options.del_key
                    div.append $ "<input/>",
                        type:   "hidden", 
                        name:   "#{@options.key}-#{i}-#{@options.del_key}", 
                        id:     "id_#{@options.key}-#{i}-#{@options.del_key}",
                        value:  "on"
            
            # and return the div
            return div
                    