# Popup the edit page in Outpost based on the current path
window.openCMS = (newWin) ->
    domain = window.location.protocol + '//' + window.location.host
    path   = window.location.pathname
    redirectUrl = null

    res = [
            {
                re: new RegExp "^/blogs/.+/.+/.+/.+/(.+)/.+/?$", "gi"
                cmsPath: "blog_entries"
            },
            {
                re: new RegExp "^/programs/.+/.+/.+/.+/(.+)/.+/?$", "gi"
                cmsPath: "show_segments"
            },
            {
                re: new RegExp "^/news/.+/.+/.+/(.+)/.+/?$", "gi"
                cmsPath: "news_stories"
            },
            {
                re: new RegExp "^/events/.+/.+/.+/(.+)/.+/?$", "gi"
                cmsPath: "events"
            }
        ]

    for matcher in res
        if match = matcher.re.exec(path)
            id = match[1]
            redirectUrl = "#{domain}/outpost/#{matcher.cmsPath}/#{id}/edit"
            break

    if redirectUrl
        newWin.location = redirectUrl
        newWin.focus()
    else
        newWin.close()
        alert "Only News Stories, Blog Entries, Show Segments, and Events are supported."

# Bookmark JS
# Paste here to turn it into bookmark-safe code: http://ted.mielczarek.org/code/mozilla/bookmarklet.html
# var newWin; try { newWin = window.open("", "cms-" + (new Date().getTime() / 1000)); openCMS(newWin) } catch(e) { newWin.close(); alert("This function is not available on this page."); }
