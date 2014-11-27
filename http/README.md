## Description

Runs async GET and POST requests on websites, with the optionality for custom headers or payloads.  This library has a dependency on libcurl

## Documentation

There are three main functions
* postAsync[callback,url,payload,header]
* getAsync[callback,url]
* getAsynch[callback,url,header]

The parameters are
* callback - (function[x;y;z]) takes in 3 parameters of (result,statuscode,curlcode)
* url - (string) request target, e.g. "http://www.google.com"
* payload - (string) payload on POST requests
* header - (list of strings) headers that will be added to the request