//
// httpresponse_tests.d 
// Orwell
//
// Created by Matthew Remmel on 8/3/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.http.httpresponse_tests;

import unit_threaded;
import orwell.http.httpresponse;


/**
  * HttpResponse Constructor / Parser
  */

@("this - simple")
unittest {
    // Setup
    string s =
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

    HttpResponse r = HttpResponse(s);
    writelnUt("Response object: ", r);

    // Assertions
    r.httpVersion.shouldEqual(HttpVersion.v1_1);
    r.status.shouldEqual(200);
    r.statusText.shouldEqual("OK");
    r.headers.shouldEqual([HttpHeader("Access-Control-Allow-Origin", "*"),
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
                           HttpHeader("X-Frame-Options", "DENY")]);
    r.content.shouldEqual("This is get content");
}

@("this - multiline")
unittest {
    // Setup
    string s =
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
        "This is multiline content\n" ~
        "This is the second line";

    HttpResponse r = HttpResponse(s);

    // Assertions
    r.httpVersion.shouldEqual(HttpVersion.v1_1);
    r.status.shouldEqual(200);
    r.statusText.shouldEqual("OK");
    r.headers.shouldEqual([HttpHeader("Access-Control-Allow-Origin", "*"),
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
                           HttpHeader("X-Frame-Options", "DENY")]);
    r.content.shouldEqual("This is multiline content\nThis is the second line");
}


/**
  * HttpResponse toString
  */

@("toString - simple")
unittest {
    // Setup
    string s =
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

    HttpResponse r = HttpResponse(s);

    // Assertions
    r.toString().shouldEqual(s);
}

@("toString - multiline")
unittest {
    // Setup
    string s =
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
        "This is multiline content\n" ~
        "This is the second line";

    HttpResponse r = HttpResponse(s);

    // Assertions
    r.toString().shouldEqual(s);
}
