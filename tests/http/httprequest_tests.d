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
import tests.data.httprequestdata;


/**
  * HttpRequest Constructor / Parser
  */
@("this")
@Values(mixin(HttpRequestDataValues))
unittest {
    // Setup
    HttpRequestData data = getValue!HttpRequestData;
    HttpRequest r = HttpRequest(data.data);

    // Assertions
    r.method.shouldEqual(data.method);
    r.url.shouldEqual(data.url);
    r.httpVersion.shouldEqual(data.httpVersion);
    r.headers.shouldEqual(data.headers);
    r.content.shouldEqual(data.content);
}

/**
  * HttpRequest toString
  */
@("toString")
@Values(mixin(HttpRequestDataValues))
unittest {
    // Setup
    string data = getValue!HttpRequestData.data;
    HttpRequest r = HttpRequest(data);

    // Assertions
    r.toString().shouldEqual(data);
}
