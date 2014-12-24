## Description

Runs async GET and POST requests on websites, with the optionality for custom headers or payloads.  This library has a dependency on libcurl

## Documentation

All functions are under the namespace .http

There are three main functions
* _postAsync[callback,url,payload,header]_ sends POST request to url
* _getAsync[callback,url]_ sends GET request to url with default headers
* _getAsynch[callback,url,header]_ sends GET request to url with option for additional headers
* _parsedict[dict]_ converts a q dictionary to a GET request of format KEY1=VALUE1&KEY2=VALUE2&...
* _pipe[successfn;failfn;result;statuscode;curlcode] used in conjunction with an async request - if statuscode=200 and curlcode=0, passes result to successfn, otherwise passes (statuscode;curlcode) to failfn

The parameters are
* callback(_fn[x;y;z]_) takes in 3 parameters of (result(_s_),statuscode(_j_),curlcode(_j_))
* url(_s_) request target, e.g. "http://www.google.com"
* payload(_s_) payload on POST requests
* header(_S_) headers that will be added to the request
* dict(_dict_) dictionary to convert to GET request format
* successfn(_fn[x]_) takes the result of a successful call
* failfn(_fn[x]_) takes a list of (statuscode;curlcode) of a failed call

## Examples

```q
.http.getAsync[{xx::(x;y;z)};"http://www.google.com"] //returns html of google to callback
.http.parsedict[`a`b!1 2] //returns a callback of a=1&b=2
.http.getAsync[.http.pipe[{s::x};{f::x}];"http://www.google.com"] //if query is successful, sets s as the return html, otherwise sets f as the error codes
```