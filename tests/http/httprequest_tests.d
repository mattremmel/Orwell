//
// httprequest_tests.d 
// Orwell
//
// Created by Matthew Remmel on 8/3/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.http.httprequest_tests;

import unit_threaded;
import orwell.http.httprequest;

/*
 * URL object attributes:
 * scheme
 * host
 * path
 * port
 * user
 * pass
 * queryParams (list)
 * fragment
 */


/**
  * HttpRequest Constructor / Parser
  */

@("this - GET")
unittest {
    // Setup
    string s =
        "GET http://www.google.com/index.html HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: www.google.com\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n\n";

    HttpRequest r = HttpRequest(s);

    // Assertions
    r.method.shouldEqual(HttpMethod.GET);
    r.url.scheme.shouldEqual(HttpScheme.HTTP);
    r.url.host.shouldEqual("www.google.com");
    r.url.path.shouldEqual("/index.html");
    r.url.port.shouldEqual(80);
    r.httpVersion.shouldEqual(HttpVersion.v1_1);
    r.headers.shouldEqual([HttpHeader("User-Agent", "Wget/1.19.1 (darwin16.6.0)"),
                           HttpHeader("Accept", "*/*"),
                           HttpHeader("Accept-Encoding", "identity"),
                           HttpHeader("Host", "www.google.com"),
                           HttpHeader("Connection", "Keep-Alive"),
                           HttpHeader("Proxy-Connection", "Keep-Alive")]);
    r.content.shouldEqual("");
}

@("this - POST")
unittest {
    // Setup
    string s =
        "POST https://forums.dlang.org/learn HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: forums.dlang.org\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n" ~
        "This is my post body";

    HttpRequest r = HttpRequest(s);

    // Assertions
    r.method.shouldEqual(HttpMethod.POST);
    r.url.scheme.shouldEqual(HttpScheme.HTTPS);
    r.url.host.shouldEqual("forums.dlang.org");
    r.url.path.shouldEqual("/learn");
    r.url.port.shouldEqual(443);
    r.httpVersion.shouldEqual(HttpVersion.v1_1);
    r.headers.shouldEqual([HttpHeader("User-Agent", "Wget/1.19.1 (darwin16.6.0)"),
                           HttpHeader("Accept", "*/*"),
                           HttpHeader("Accept-Encoding", "identity"),
                           HttpHeader("Host", "forums.dlang.org"),
                           HttpHeader("Connection", "Keep-Alive"),
                           HttpHeader("Proxy-Connection", "Keep-Alive")]);
    r.content.shouldEqual("This is my post body");
}

@("this - multiline")
unittest {
    // Setup
    string s =
        "POST https://forums.dlang.org/learn HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: forums.dlang.org\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n" ~
        "This is my multiline body\n" ~
        "This is the second line";

    HttpRequest r = HttpRequest(s);

    // Assertions
    r.method.shouldEqual(HttpMethod.POST);
    r.url.scheme.shouldEqual(HttpScheme.HTTPS);
    r.url.host.shouldEqual("forums.dlang.org");
    r.url.path.shouldEqual("/learn");
    r.url.port.shouldEqual(443);
    r.httpVersion.shouldEqual(HttpVersion.v1_1);
    r.headers.shouldEqual([HttpHeader("User-Agent", "Wget/1.19.1 (darwin16.6.0)"),
                           HttpHeader("Accept", "*/*"),
                           HttpHeader("Accept-Encoding", "identity"),
                           HttpHeader("Host", "forums.dlang.org"),
                           HttpHeader("Connection", "Keep-Alive"),
                           HttpHeader("Proxy-Connection", "Keep-Alive")]);
    r.content.shouldEqual("This is my multiline body\nThis is the second line");
}


/**
  * HttpRequest toString
  */

@("toString - GET")
unittest {
    // Setup
    string s =
        "GET http://www.google.com/index.html HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: www.google.com\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n\n";

    HttpRequest r = HttpRequest(s);

    // Assertions
    r.toString().shouldEqual(s);
}

@("toString - POST")
unittest {
    // Setup
    string s =
        "POST https://forums.dlang.org/learn HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: forums.dlang.org\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n" ~
        "This is my post body";

    HttpRequest r = HttpRequest(s);

    // Assertions
    r.toString().shouldEqual(s);
}

@("toString - multiline")
unittest {
    // Setup
    string s =
        "POST https://forums.dlang.org/learn HTTP/1.1\n" ~
        "User-Agent: Wget/1.19.1 (darwin16.6.0)\n" ~
        "Accept: */*\n" ~
        "Accept-Encoding: identity\n" ~
        "Host: forums.dlang.org\n" ~
        "Connection: Keep-Alive\n" ~
        "Proxy-Connection: Keep-Alive\n" ~
        "\n" ~
        "This is my multiline body\n" ~
        "This is the second line";

    HttpRequest r = HttpRequest(s);

    // Assertions
    r.toString().shouldEqual(s);
}
