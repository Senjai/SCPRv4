# KPCC Public API Documentation

## v2 ##
**Current Version**: 2.1.0  
**Endpoint**: /api/v2/  
**Response**: JSON only


### Content ###
**Endpoint**: /api/v2/content/

#### Supported Classes ###

Note that NewsStory and ContentShell are lumped together.

<table>
  <tr>
    <th>Class name</th>
    <th>API type</th>
    <th>ID prefix</th>
  </tr>
  <tr>
    <td>NewsStory + ContentShell</td>
    <td>news</td>
    <td>news/story</td>
  </tr>
  <tr>
    <td>BlogEntry</td>
    <td>blogs</td>
    <td>blogs/entry</td>
  </tr>
  <tr>
    <td>ShowSegment</td>
    <td>segments</td>
    <td>shows/segment</td>
  </tr>
  <tr>
    <td>ShowEpisode</td>
    <td>episodes</td>
    <td>shows/episode</td>
  </tr>
  <tr>
    <td>VideoShell</td>
    <td>video</td>
    <td>contentbase/videoshell</td>
  </tr>
</table>


#### Response ####
This is how every article is represented by the API in its response.

**bold** denotes that a node will *always* be present, even if it's empty.
Otherwise, the node will only be present if it isn't empty.

<table>
  <tr><td><strong>id</strong></td><td>The object key. (blogs/entry:999)</td></tr>
  <tr><td><strong>title</strong></td><td>The full title.</td></tr>
  <tr><td><strong>short_title</strong></td><td>The short title.</td></tr>
  <tr><td><strong>byline</strong></td><td>The byline.</td></tr>
  <tr><td><strong>published_at</strong></td><td>The original publish date of the content. (ISO 8601)</td></tr>
  <tr><td><strong>teaser</strong></td><td>The teaser.</td></tr>
  <tr><td><strong>body</strong></td><td>The full body copy.</td></tr>
  <tr><td><strong>permalink</strong></td><td>The full, canonical URL.</td></tr>
  <tr><td><strong>thumbnail</strong></td><td>An IMG tag for the thumbnail (188x188)</td></tr>
  <tr><td>category</td><td>The article's category.
    <ul>
      <li>id</li>
      <li>title</li>
      <li>url</li>
    </ul>
  </td></tr>
  <tr><td><strong>assets</strong></td><td>An array of this article's assets.  
    <ul>
      <li>title</li>
      <li>caption</li>
      <li>owner</li>
    </ul>
    Four sizes (thumbnail, small, large, full) are available. See below for more.</td></tr>
  <tr><td>attributions</td><td>All of this article's attributions.
    <ul>
      <li>name</li>
      <li>role_text</li>
      <li>role</li>
    </ul>
  </td></tr>
</table>


#### Assets ####

There are four sizes of assets. These are their names and geometry (see [ImageMagick geometry](http://www.imagemagick.org/script/command-line-processing.php#geometry) for explanation). Note that `#` means "cropped".

* lsquare (188x188#)
* small (450x450>)
* large (730x486>)
* full (1024x1024>)

<table>
  <tr><td><strong>title</strong></td><td>Asset title</td></tr>
  <tr><td><strong>caption</strong></td><td>Asset caption</td></tr>
  <tr><td><strong>owner</strong></td><td>Asset owner</td></tr>
  <tr><td><strong>thumbnail, small,<br />large, full</strong></td><td>Asset sizes:
    <ul>
      <li>URL</li>
      <li>Width</li>
      <li>Height</li>
    </ul>
  </td></tr>
</table>


#### Article by URL ####
Find an article by its URL.

**Endpoint**: /api/v2/content/by_url?url={url} (GET)  
**Params**:
* `url` - The full URL of the content.

**Example**
GET /api/v2/content/by_url?url=http://www.scpr.org/blogs/politics/2013/04/16/13317/dearmayor-live-from-westchester-what-should-la-s-n/  
**Returns**
A single JSON object representation of the requested content.


#### Article by ID (obj_key) ####
Find an article by its obj_key (blogs/entry:999)

**Endpoint**: /api/v2/content/{obj_key} (GET)  
**Params**: 
* `obj_key` - The object key (API id) for the article.

**Example**
GET /api/v2/content/blogs/entry:999  
**Returns**
A single JSON object representation of the requested content.


#### Content Collection ####
Find a collection of articles based on several parameters.

**Endpoint**: /api/v2/content?{optional params} (GET)  
**Params**: (All parameters are optional)
* `query` - (string) A search query.  
Example: ?query=Obama+Healthcare
* `types` - (comma-separated list) The types of articles to return.  
Example: ?types=news,blogs,segments  
See the "Supported Classes" table for the options. (default: all types)
* `limit` - (integer) The number of articles to return.  
Maximum is 40. (default: 10)
* `page` - The page of results to return. (default: 1)

**Example**
GET /api/v2/content?query=Obama&types=news,blogs,segments&limit=25&page=4  
**Returns**
A JSON array of article objects, ordered by **descending published_at date**.


#### Most Viewed
Grab the most viewed content.

**Endpoint**: /api/v2/content/most_viewed (GET)  
**Params**: None  
**Example**
GET /api/v2/content/most_viewed  
**Returns**
A JSON array of article objects.


#### Most Commented
Grab the most commented content.

**Endpoint**: /api/v2/content/most_commented (GET)  
**Params**: None  
**Example**
GET /api/v2/content/most_commented  
**Returns**
A JSON array of article objects.


### Errors ###

These are some errors you might come across when interacting with the API.

<table>
  <tr>
    <th>Error Name</th>
    <th>Status</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>Unauthorized</td>
    <td>401</td>
    <td>The API key is incorrect or missing (Private API only)</td>
  </tr>
  <tr>
    <td>Bad Request</td>
    <td>400</td>
    <td>Some parameter is malformed, such as an invalid URI in #by_url</td>
  </tr>
  <tr>
    <td>Not Found</td>
    <td>404</td>
    <td>The requested article can't be found.</td>
  </tr>
  <tr>
    <td>Server Error</td>
    <td>500</td>
    <td>An unexpected error occurred.</td>
  </tr>
</table>


## v1 ##
Please do not use API v1. It will be removed after 2013-05-01.
