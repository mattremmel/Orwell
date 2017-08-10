//
// httpmessagehandler_tests.d 
// Orwell
//
// Created by Matthew Remmel on 8/9/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.http.httpmessagehandler_tests;

import unit_threaded;
import orwell.http.httpmessagehandler;

@("this - default")
unittest {
    // Setup
    string req =
        "GET http://www.google.com/index.html HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: www.google.com\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n\n";
    HttpRequest request = HttpRequest(req);

    string res = 
        "HTTP/1.1 200 OK\n" ~
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
        "This is get content";
    HttpResponse response = HttpResponse(res);

    HttpMessageHandler handler = new HttpMessageHandler();

    // Assertions
    handler.handleRequest(request).shouldEqual(request);
    handler.handleResponse(response).shouldEqual(response);
}

@("this - custom")
unittest {
    // Setup
    string req =
        "GET http://www.google.com/index.html HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: www.google.com\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n\n";
    HttpRequest orequest = HttpRequest(req);

    string res = 
        "HTTP/1.1 200 OK\n" ~
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
        "This is get content";
    HttpResponse oresponse = HttpResponse(res);

    HttpMessageHandler handler = new HttpMessageHandler(
        (HttpRequest request) {
            request.method = HttpMethod.POST;
            return request;
        },
        (HttpResponse response) {
            response.content = "This is new content";
            return response;
        }
    );

    HttpRequest nrequest = handler.handleRequest(orequest);
    HttpResponse nresponse = handler.handleResponse(oresponse);

    // Assertions
    nrequest.method.shouldEqual(HttpMethod.POST);
    nrequest.url.shouldEqual(orequest.url);
    nrequest.httpVersion.shouldEqual(orequest.httpVersion);
    nrequest.headers.shouldEqual(orequest.headers);
    nrequest.content.shouldEqual(orequest.content);

    nresponse.httpVersion.shouldEqual(oresponse.httpVersion);
    nresponse.status.shouldEqual(oresponse.status);
    nresponse.statusText.shouldEqual(oresponse.statusText);
    nresponse.headers.shouldEqual(oresponse.headers);
    nresponse.content.shouldEqual("This is new content");
}