//
// httprequest.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.http.httpmessage;

public import etc.enums;

/**
  * HTTP Schemes
  */
enum HttpScheme {
    HTTP = "http",
    HTTPS = "https",
    FTP = "ftp"
}

/**
  * HTTP/1.1 Methods
  */
enum HttpMethod {
    GET =         "GET",  /// Requests a representation of the specified resource.
    HEAD =       "HEAD",  /// Requests a response identicial to that of GET, but without the response body.
    POST =       "POST",  /// Used to submit an entity to the specified resource.
    PUT =         "PUT",  /// Replaces all current representations of the target resource with the request payload.
    DELETE =   "DELETE",  /// Requests a delete of the specified resource.
    CONNECT = "CONNECT",  /// Used to establish a tunnel to the server identified by the target resource.
    OPTIONS = "OPTIONS",  /// Used to request the communications options for the target resource.
    TRACE =     "TRACE",  /// Performs a message loop-back test along the path to the target resource.
    PATCH =     "PATCH"   /// Used to apply partial modifications to a resource.
}

/**
  * HTTP Versions
  */
enum HttpVersion {
    v1 = "HTTP/1",
    v1_1 = "HTTP/1.1",
    v2 = "HTTP/2"
}

/**
  * HTTP Status Code
  */
alias HttpStatusCode = int;

/**
  * HTTP Status Text
  */
alias HttpStatusText = string;

/**
  * HTTP Header
  */
struct HttpHeader {
    string key;     /// The header key
    string value;   /// The header value

    this(string key, string value) {
        this.key = key;
        this.value = value;
    }
}
