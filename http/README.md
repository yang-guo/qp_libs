## Description

Runs async GET and POST requests on websites, with the optionality for custom headers or payloads.  This library has a dependency on libcurl

## Documentation

There are three main functions
* postAsync[callback,url,payload,header]
* getAsync[callback,url]
* getAsynch[callback,url,header]

The parameters are
* callback(_fn[x;y;z]_) - takes in 3 parameters of (result,statuscode,curlcode)
* url(_s_) - request target, e.g. "http://www.google.com"
* payload(_s_) - payload on POST requests
* header(_S_) - headers that will be added to the request