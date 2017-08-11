//
// httpresponsedata.d 
// Orwell
//
// Created by Matthew Remmel on 8/11/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.data.httpresponsedata;

import orwell.http.httpresponse;


/**
  * The string used for mixing in the response data objects.
  * Should be used with a unit test like: @Values(mixin(HttpResponseDataValues));
  */
  // TODO: try to upgrade to gernate string at compile time
  enum string HttpResponseDataValues = "[responsedata_1, responsedata_2]";

/**
  * The struct used to hold response data and the expected parsed values
  */
struct HttpResponseData {
    string testName = "";
    string data;
    HttpVersion httpVersion;
    HttpStatusCode status;
    HttpStatusText statusText;
    HttpHeader[] headers;
    string content;

    @safe
    pure string toString() const {
        return this.testName;
    }
}

// Response data 1
enum HttpResponseData responsedata_1 = {
    testName: "response_1",
    data: "HTTP/1.1 200 OK\n" ~
          "Access-Control-Allow-Origin: *\n" ~
          "Connection: Keep-Alive\n" ~
          "Content-Encoding: gzip\n" ~
          "Content-Type: text/html; charset=utf-8\n" ~
          "Date: Wed, 10 Aug 2016 13:17:18 GMT\n" ~
          "Etag: 686897696a7c876b7e\n" ~
          "Keep-Alive: timeout=5, max=999\n" ~
          "Last-Modified: Wed, 10 Aug 2016 05:38:31 GMT\n" ~
          "Server: Apache\n" ~
          "Set-Cookie: csrftoken=....\n" ~
          "Transfer-Encoding: chunked\n" ~
          "Vary: Cookie, Accept-Encoding\n" ~
          "X-Frame-Options: DENY\n" ~
          "\n" ~
          "This is content",
    httpVersion: HttpVersion.v1_1,
    status: 200,
    statusText: "OK",
    headers: [HttpHeader("Access-Control-Allow-Origin", "*"),
              HttpHeader("Connection", "Keep-Alive"),
              HttpHeader("Content-Encoding", "gzip"),
              HttpHeader("Content-Type", "text/html; charset=utf-8"),
              HttpHeader("Date", "Wed, 10 Aug 2016 13:17:18 GMT"),
              HttpHeader("Etag", "686897696a7c876b7e"),
              HttpHeader("Keep-Alive", "timeout=5, max=999"),
              HttpHeader("Last-Modified", "Wed, 10 Aug 2016 05:38:31 GMT"),
              HttpHeader("Server", "Apache"),
              HttpHeader("Set-Cookie", "csrftoken=...."),
              HttpHeader("Transfer-Encoding", "chunked"),
              HttpHeader("Vary", "Cookie, Accept-Encoding"),
              HttpHeader("X-Frame-Options", "DENY")],
    content: "This is content"
};

// Response data 2
enum HttpResponseData responsedata_2 = {
    testName: "response_2",
    data: "HTTP/1.1 200 OK\n" ~
          "Access-Control-Allow-Origin: *\n" ~
          "Connection: Keep-Alive\n" ~
          "Content-Encoding: gzip\n" ~
          "Content-Type: text/html; charset=utf-8\n" ~
          "Date: Wed, 10 Aug 2016 13:17:18 GMT\n" ~
          "Etag: 686897696a7c876b7e\n" ~
          "Keep-Alive: timeout=5, max=999\n" ~
          "Last-Modified: Wed, 10 Aug 2016 05:38:31 GMT\n" ~
          "Server: Apache\n" ~
          "Set-Cookie: csrftoken=....\n" ~
          "Transfer-Encoding: chunked\n" ~
          "Vary: Cookie, Accept-Encoding\n" ~
          "X-Frame-Options: DENY\n" ~
          "\n" ~
          "This is multiline content\n" ~
          "This is the second line",
    httpVersion: HttpVersion.v1_1,
    status: 200,
    statusText: "OK",
    headers: [HttpHeader("Access-Control-Allow-Origin", "*"),
              HttpHeader("Connection", "Keep-Alive"),
              HttpHeader("Content-Encoding", "gzip"),
              HttpHeader("Content-Type", "text/html; charset=utf-8"),
              HttpHeader("Date", "Wed, 10 Aug 2016 13:17:18 GMT"),
              HttpHeader("Etag", "686897696a7c876b7e"),
              HttpHeader("Keep-Alive", "timeout=5, max=999"),
              HttpHeader("Last-Modified", "Wed, 10 Aug 2016 05:38:31 GMT"),
              HttpHeader("Server", "Apache"),
              HttpHeader("Set-Cookie", "csrftoken=...."),
              HttpHeader("Transfer-Encoding", "chunked"),
              HttpHeader("Vary", "Cookie, Accept-Encoding"),
              HttpHeader("X-Frame-Options", "DENY")],
    content: "This is multiline content\nThis is the second line"
};