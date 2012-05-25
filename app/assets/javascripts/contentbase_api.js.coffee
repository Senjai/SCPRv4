#= require scprbase

#= require jquery
#= require underscore
#= require backbone
#= require jquery-ui-1.8.17.sortable_w_effects
#= require strftime

#= require t_cbase/style
#= require t_cbase/content

#= require_self

#= require_directory ./cbase/

class scpr.ContentBaseAPI
    DefaultOptions:
        api_path: "http://scprv4.dev/dashboard/api"
        
    @DjangoToContentType:
        15:     'news/story'
        25:     'shows/episode'
        24:     'shows/segment'
        44:     'blogs/entry'
        115:    'content/shell'
        125:    'content/video'
        
    @ContentTypeToDjango:
        'news/story':       15
        'shows/segment':    24
        'shows/episode':    25
        'blogs/entry':      44
        'content/shell':    115
        'content/video':    125
            
    constructor: (options) ->
        @options = _(_({}).extend(@DefaultOptions)).extend options || {}
        api_root = @options.api_path
        
    #----------
    
    content_by_url: (url,cb) ->
        $.ajax 
            url: "#{scpr.API_ROOT}/content/by_url?id=#{encodeURIComponent(url)}"
            params: { id:url }
            xhrFields: { withCredentials:true }
            dataType: "json"
            success: (r) =>
                console.log "got success of ", r
                cb? new ContentBaseAPI.Content r
            error: (r) =>
                console.log "got error of ", r
                cb? null
                
    #----------
    
    buildContentDropZone: (args) ->
        new ContentBaseAPI.ContentDropZone args
        
    enablePreview: (args = {}) ->
        new ContentBaseAPI.PreviewPopup _(args).extend cbapi:@
    
    #----------
    
    @smart_date: (date) ->
        to = new Date()
        from = new Date(date)

        if [to.getYear,to.getMonth,to.getDate].join("-") == [from.getYear,from.getMonth,from.getDate].join("-")
            # today.  just h:mm
            return strftime "%l:%M%p", from
        else if ( Number(to) - Number(from) ) < (86400 * 7)
            return strftime "%a, %l:%M%p", from 
        else
            return strftime "%b %e, %l:%M%p", from
    
    #----------
    
    @time_ago_in_words: (date) ->
        to = Number(new Date())
        from = Number(new Date(date))
                
        seconds_ago = Math.floor (to  - from) / 1000
        minutes_ago = Math.floor seconds_ago / 60

        if minutes_ago == 0
            return "about #{seconds_ago} seconds"
        else if minutes_ago == 1
            return "about a minute"
        else if minutes_ago < 55
            return "about #{minutes_ago} minutes"
        else if minutes_ago < 90
            return "about an hour"
        else
            hours_ago = Math.round minutes_ago / 60
            
            if minutes_ago < (60 * 18)
                return "about #{hours_ago} hours"
            else if minutes_ago < (60 * 36)
                return "about a day"
            else
                days_ago = Math.round minutes_ago / 1440
                
                if minutes_ago < (60 * 24 * 24)
                    return "about #{days_ago} days"
                else if minutes_ago < (60 * 24 * 48)
                    return "about a month"
                else
                    return from.getISODate()        
    
    #----------
    
    class ContentBaseAPI.ContentDropZone
        DefaultOptions:
            key: "contents"
            fields: ['content_type','object_id','position']
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
                    
                console.log "form html was ", @el.clone()

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
                    @contents.fetch 
                        data: 
                            ids: (o.obj_key || @djangoToObjKey(o.content_type,o.object_id) for o in @objects)
                        silent: true
                        success: =>
                            console.log "collection fetch success"
                            # if we're doing ordering, add the ORDER attribute
                            if @options.order_key
                                _(@objects).each (o) => 
                                    id = o.obj_key || @djangoToObjKey(o.content_type,o.object_id)
                                    @contents.get(id)?.set { ORDER:parseInt o[@options.order_key] }, silent:true
                                    console.log "set ORDER:#{o[@options.order_key]} for #{id}"
                                
                                console.log "done setting order"
                                @contents.sort()
                            else
                                @contents.trigger("reset")
                    
                # wipe out the element contents and render our content
                @view = new ContentBaseAPI.ContentsView collection:@contents

                @style = $ "<style/>", text:JST['t_cbase/style']()
                @form = $ "<div/>"
                @drop = $ "<div/>"
                

                @el.html @style
                @el.append @drop
                @drop.html @view.render().el
                @el.append @form
                @_buildInputForm()
                
                @contents.on "all", => 
                    @objects = @contents.map (m) =>
                        [type,id] = @objKeyToDjango m.get('obj_key')

                        console.log "converted #{m.get('obj_key')} into ", type, id

                        obj = content_type:type, object_id:id

                        if @options.order_key
                            obj[@options.order_key] = String m.get("ORDER")

                        return obj

                    console.log "building form from ", @objects

                    @form.html @parser.constructForm(@objects)
                    
                console.log "calling constructForm with ", @objects
                @form.html @parser.constructForm(@objects)

                @el.on "dragenter", (evt) => @_dropDragEnter evt
                @el.on "dragover", (evt) => @_dropDragOver evt
                @el.on "drop", (evt) => @_dropDrop evt

                @el.show()

        #----------
        
        _buildInputForm: ->
            template = 
                """
                <div class="cbaseURLInput">
                    <b style="margin: 16px">Content URL:</b>
                    <input id="cbaseURLInputIn" style="width: 60%;"/>
                    <button class="importURL">Get Content</button>
                    <br style="clear:both;"/>
                </div>
                """
            
            @inputForm = _.template template
            @el.append @inputForm
            
            input = $("#cbaseURLInputIn",@inputForm)
            
            console.log "button is ", $("button",@inputForm), input
            
            $("button",@inputForm).on "click", (evt) =>
                #console.log "val is ", input.val(), @_tryToImport
                @_tryToImport input.val()
                input.val("")
                false
        
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
            
            @_tryToImport(uri)
        
        #----------
    
        _tryToImport: (uri) ->
            if !uri
                @el.effect "shake", "fast"
                return false
        
            # check if this is a content URL
            @cbapi.content_by_url uri, (c) =>
                if c
                    c.set ORDER:@contents.length
                    @contents.add(c)
                    @el.effect "highlight"
                else
                    @el.effect "shake", "fast"
    
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
        template: JST["t_cbase/content"]
            
        events:
            'click button.delete': '_delete'
            
        initialize: ->
            @model.on "change", @render()
            
            @del_confirm = false
            @del_timeout = null
            
        _delete: (evt) ->
                console.log "delete evt is ", evt
                
                if @del_confirm
                    # delete
                    console.log "confirm is set. should delete", @model
                    clearTimeout @del_timeout
                    
                    # remove our model...
                    _.defer => @model.collection.remove @model
                else
                    target = $(evt.target)
                    target.text "Really Delete?"
                    @del_confirm = true
                    
                    # set a reset timeout
                    @del_timeout = setTimeout =>
                        target.text "Delete"
                        @del_confirm = false
                        @del_timeout = null
                        console.log "reset confirm on delete button", target
                    , 2000
                
                false
                        
        render: ->
            console.log "rendering #{@model.id}"
            @$el.html @template _.extend @model.toJSON(), published_at:ContentBaseAPI.smart_date(@model.get("published_at"))
            
            @$el.attr "data-objkey", @model.id 
            @
            
    #----------
    
    @ContentsView: Backbone.View.extend            
        tagName: "ul"
        className: "cbaseView"
        
        initialize: ->
            @_views = {}

            @collection.bind 'all', => 
                console.log "rebuilding views on event"
                _(@_views).each (av) => $(av.el).detach()
                @$el.html ""
                @_views = {}
                @render()
            
        render: ->
            # set up views for each collection member
            @collection.each (f) => 
                console.log "calling render for ", f
                # create a view unless one exists
                @_views[f.cid] ?= new ContentBaseAPI.ContentView model:f

            # make sure all of our view elements are added
            @$el.append( _(@_views).map (v) -> v.el )

            @$el.sortable
                update: (evt,ui) => 
                    console.log "evt is ", evt, ui
                    _(@el.children).each (li,idx) => 
                        console.log("set idx for #{$(li).attr("data-objkey")} to #{idx}")
                        @collection.get( $(li).attr("data-objkey") ).attributes.ORDER = idx
                    @collection.sort()

            @
            
    #----------
    
    class ContentBaseAPI.ContentList
        DefaultOptions:
            el: null
            function: "recent"
        
        constructor: (options) ->
            @options = _(_({}).extend(@DefaultOptions)).extend options || {}
            
            @el = $(@options.el)
    
            if !_(@el).first()
                console.log "Element invalid."
                return false
            
            # create our collection via the given API function
            @contents = new ContentBaseAPI.ContentCollection()
            @contents.fetch url:"#{@contents.url}/#{@options.function}",success: =>
                # set up our view 
                @view = new ContentBaseAPI.ListViewList collection:@contents
                @el.html @view.render().el
    
    #----------
    
    @ListViewContent: Backbone.View.extend
        tagName: "li"
        
        template:
            """
            <a href="<%= link_path %>" target="_new">
                <%= asset %>
                <%= headline %>
            </a>
            <br/><%= byline %>
            <br/><%= obj_key %> &mdash; <%= published_at %>
            &mdash; <a href="<%= admin_path %>" target="_new">Admin</a>
            """
        
        initialize: ->
            @model.on "change", @render()
            
        render: ->
            @$el.html _.template @template, _.extend @model.toJSON(), 
                published_at:ContentBaseAPI.smart_date(@model.get("published_at"))
                
            @$el.attr "data-objkey", @model.id 
            @
            
    
    #----------

    @ListViewList: Backbone.View.extend
        tagName: "ul"
        className: "cbaseList"
            
        initialize: ->
            @_views = {}

            @collection.bind 'add', (f) => 
                console.log "add event from ", f
                @collection.sort()

            @collection.bind 'remove', (f) => 
                console.log "remove event from ", f
                @collection.sort()

            @collection.bind 'reset', => 
                console.log "reset event"
                _(@_views).each (av) => $(av.el).detach()
                @_views = {}
                @render()

        render: ->
            # set up views for each collection member
            @collection.each (f) => 
                # create a view unless one exists
                @_views[f.cid] ?= new ContentBaseAPI.ListViewContent model:f

            # make sure all of our view elements are added
            @$el.append( _(@_views).map (v) -> v.el )

            return @
            
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
                        
                        i++
                        
            console.log "objects is ", @objects
                    
        #----------
                
        constructForm: (newobj = @objects) ->
            div = $ "<div/>"
            
            # write the form meta info
            div.append $ "<input/>", 
                type:   "hidden", 
                name:   "#{@options.key}-TOTAL_FORMS", 
                id:     "id_#{@options.key}-TOTAL_FORMS",
                value:  if newobj.length > @ids.length then newobj.length else @ids.length

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
                        
                if @options.del_key
                    div.append $ "<input/>",
                        type:   "hidden", 
                        name:   "#{@options.key}-#{i}-#{@options.del_key}", 
                        id:     "id_#{@options.key}-#{i}-#{@options.del_key}",
                        value:  "on"
            
            # and return the div
            return div
                    