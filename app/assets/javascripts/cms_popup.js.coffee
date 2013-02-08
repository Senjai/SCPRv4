# Popup the edit page in Outlet based on the current path
window.openCMS = ->
    domain = window.location.origin
    path   = window.location.pathname
    redirectUrl = null
    
    res = [
            { 
                re: new RegExp "^/blogs/(.+)/(.+)/(.+)/(.+)/(.+)/(.+)/?$", "gi"
                cmsPath: "/r/admin/blog_entries" 
                idSlot: 5
            },
            { 
                re: new RegExp "^/programs/(.+)/(.+)/(.+)/(.+)/(.+)/(.+)/?$", "gi"
                cmsPath: "/r/admin/show_segments" 
                idSlot: 5
            },
            { 
                re: new RegExp "^/news/(.+)/(.+)/(.+)/(.+)/(.+)/?$", "gi"
                cmsPath: "/r/admin/news_stories"
                idSlot: 4
            },
            { 
                re: new RegExp "^/video/(.+)/(.+)/?$", "gi"
                cmsPath: "/r/admin/video_shells"
                idSlot: 1
            }
        ]

    for matcher in res
        if match = matcher.re.exec(path)
            id = match[matcher.idSlot]
            redirectUrl = "#{domain}#{matcher.cmsPath}/#{id}/edit"
            break

    if redirectUrl
        window.open redirectUrl, '_blank', 'width=1200,height=800'
    else
        alert "Only News Stories, Blog Entries, Show Segments, and Video Shells are supported."
