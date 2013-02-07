var openCMS;

openCMS = function() {
  var domain, id, match, matcher, path, redirectUrl, res, _i, _len;
  domain = window.location.origin;
  path = window.location.pathname;
  redirectUrl = null;
  res = [
    {
      re: new RegExp("^/blogs/(.+)/(.+)/(.+)/(.+)/(.+)/(.+)/?$", "gi"),
      cmsPath: "/r/admin/blog_entries",
      idSlot: 5
    }, {
      re: new RegExp("^/programs/(.+)/(.+)/(.+)/(.+)/(.+)/(.+)/?$", "gi"),
      cmsPath: "/r/admin/show_segments",
      idSlot: 5
    }, {
      re: new RegExp("^/news/(.+)/(.+)/(.+)/(.+)/(.+)/?$", "gi"),
      cmsPath: "/r/admin/news_stories",
      idSlot: 4
    }, {
      re: new RegExp("^/video/(.+)/(.+)/?$", "gi"),
      cmsPath: "/r/admin/video_shells",
      idSlot: 1
    }
  ];
  for (_i = 0, _len = res.length; _i < _len; _i++) {
    matcher = res[_i];
    if (match = matcher.re.exec(path)) {
      id = match[matcher.idSlot];
      redirectUrl = "" + domain + matcher.cmsPath + "/" + id + "/edit";
      break;
    }
  }
  if (redirectUrl) {
    return window.open(redirectUrl, '_blank', 'width=1200,height=800');
  } else {
    return alert("Can't find this in the CMS. Only News Stories, Blog Entries, Show Segments, and Video Shells are supported.");
  }
};

openCMS();
