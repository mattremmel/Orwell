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
import tests.data.httpresponsedata;


/**
  * HttpResponse Constructor / Parser
  */
@("this")
@Values(mixin(HttpResponseDataValues))
unittest {
    // Setup
    HttpResponseData data = getValue!HttpResponseData;
    HttpResponse r = HttpResponse(data.data);

    // Assertions
    r.httpVersion.shouldEqual(data.httpVersion);
    r.status.shouldEqual(data.status);
    r.statusText.shouldEqual(data.statusText);
    r.headers.shouldEqual(data.headers);
    r.content.shouldEqual(data.content);
}

/**
  * HttpResponse toString
  */
@("toString")
@Values(mixin(HttpResponseDataValues))
unittest {
    // Setup
    string data = getValue!HttpResponseData.data;
    HttpResponse r = HttpResponse(data);

    // Assertions
    r.toString().shouldEqual(data);
}