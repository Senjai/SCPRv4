# KPCC Public API Documentation

## v2 ##
**Current Version**: 2.0.0  
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
This is how every article is represented by the API in its response:

<table>
  <tr><td>id</td><td>The object key. (blogs/entry:999)</td></tr>
  <tr><td>title</td><td>The full title.</td></tr>
  <tr><td>short_title</td><td>The short title.</td></tr>
  <tr><td>published_at</td><td>The original publish date of the content. (ISO 8601)</td></tr>
  <tr><td>teaser</td><td>The teaser.</td></tr>
  <tr><td>body</td><td>The full body copy.</td></tr>
  <tr><td>permalink</td><td>The full, canonical URL.</td></tr>
  <tr><td>thumbnail</td><td>An IMG tag for the thumbnail (188x188)</td></tr>
  <tr><td>byline</td><td>The byline.</td></tr>
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
</table>


## v1 ##
Please do not use API v1. It will be removed after 2013-05-01.
