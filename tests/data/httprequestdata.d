//
// httprequestdata.d 
// Orwell
//
// Created by Matthew Remmel on 8/11/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.data.httprequestdata;

import orwell.http.httprequest;

/**
  * The string used for mixing in the request data objects.
  * Should be used with a unit test like: @Values(mixin(HttpRequestDataValues));
  */
// TODO: try to upgrade to generate string at compile time
enum string HttpRequestDataValues = "[requestdata_1, requestdata_2]";

/**
  * The struct used to hold request data and the expected parsed values
  */
struct HttpRequestData {
    string testName = "";
    string data;
    HttpMethod method;
    string url;
    HttpVersion httpVersion;
    HttpHeader[] headers;
    string content;

    @safe
    pure string toString() const {
        return this.testName;
    }
}

// Request data 1
enum HttpRequestData requestdata_1 = {
    testName: "request_1", // TODO: Try to upgrade to be generated automatically at compile time
    data: "GET http://www.google.com/index.html HTTP/1.1\n" ~
          "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
          "Accept: */*\n" ~
          "Accept-Encoding: identity\n" ~
          "Host: www.google.com\n" ~
          "Connection: Keep-Alive\n" ~
          "Proxy-Connection: Keep-Alive\n" ~
          "\n\n",
    method: HttpMethod.GET,
    url: "http://www.google.com/index.html",
    httpVersion: HttpVersion.v1_1,
    headers: [HttpHeader("User-Agent", "Wget/1.19.1 (darwin16.6.0)"),
              HttpHeader("Accept", "*/*"),
              HttpHeader("Accept-Encoding", "identity"),
              HttpHeader("Host", "www.google.com"),
              HttpHeader("Connection", "Keep-Alive"),
              HttpHeader("Proxy-Connection", "Keep-Alive")],
    content: ""
};

//Request data 2
enum HttpRequestData requestdata_2 = {
    testName: "request_2",
    data: "POST https://forums.dlang.org/learn HTTP/1.1\n" ~
          "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
          "Accept: */*\n" ~
          "Accept-Encoding: identity\n" ~
          "Host: forums.dlang.org\n" ~
          "Connection: Keep-Alive\n" ~
          "Proxy-Connection: Keep-Alive\n" ~
          "\n" ~
          "This is my multiline body\n" ~
          "This is the second line",
    method: HttpMethod.POST,
    url: "https://forums.dlang.org/learn",
    httpVersion: HttpVersion.v1_1,
    headers: [HttpHeader("User-Agent", "Wget/1.19.1 (darwin16.6.0)"),
              HttpHeader("Accept", "*/*"),
              HttpHeader("Accept-Encoding", "identity"),
              HttpHeader("Host", "forums.dlang.org"),
              HttpHeader("Connection", "Keep-Alive"),
              HttpHeader("Proxy-Connection", "Keep-Alive")],
    content: "This is my multiline body\nThis is the second line"
};