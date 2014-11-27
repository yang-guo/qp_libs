## Description

Runs async GET and POST requests on websites, with the optionality for custom headers or payloads.  This library has a dependency on libcurl

## Documentation

All functions are under the namespace .http

There are three main functions
* _postAsync[callback,url,payload,header]_ sends POST request to url
* _getAsync[callback,url]_ sends GET request to url with default headers
* _getAsynch[callback,url,header]_ sends GET request to url with option for additional headers

The parameters are
* callback(_fn[x;y;z]_) takes in 3 parameters of (result,statuscode,curlcode)
* url(_s_) request target, e.g. "http://www.google.com"
* payload(_s_) payload on POST requests
* header(_S_) headers that will be added to the request

## Examples

```q
.http.getAsync[{xx::(x;y;z)};"http://www.google.com"] //returns html of google to callback
```