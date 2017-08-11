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
import tests.data.httprequestdata;
import tests.data.httpresponsedata;

@("default")
@Values(mixin(HttpRequestDataValues))
@Values(mixin(HttpResponseDataValues))
unittest {
    // Setup
    HttpRequestData reqData = getValue!(HttpRequestData, 0);
    HttpResponseData resData = getValue!(HttpResponseData, 1);
    HttpRequest request = HttpRequest(reqData.data);
    HttpResponse response = HttpResponse(resData.data);
    HttpMessageHandler handler = new HttpMessageHandler();

    // Assertions
    handler.handleRequest(request).shouldEqual(request);
    handler.handleResponse(response).shouldEqual(response);
}

@("custom")
@Values(mixin(HttpRequestDataValues))
@Values(mixin(HttpResponseDataValues))
unittest {
    // Setup
    HttpRequestData reqData = getValue!(HttpRequestData, 0);
    HttpResponseData resData = getValue!(HttpResponseData, 1);
    HttpRequest request = HttpRequest(reqData.data);
    HttpResponse response = HttpResponse(resData.data);
    
    HttpMessageHandler handler = new HttpMessageHandler(
        (HttpRequest req) {
            req.method = HttpMethod.DELETE;
            return req;
        },
        (HttpResponse res) {
            res.content = "This is new content";
            return res;
        }
    );

    request = handler.handleRequest(request);
    response = handler.handleResponse(response);

    // Assertions
    request.method.shouldEqual(HttpMethod.DELETE);
    request.url.shouldEqual(reqData.url);
    request.httpVersion.shouldEqual(reqData.httpVersion);
    request.headers.shouldEqual(reqData.headers);
    request.content.shouldEqual(reqData.content);

    response.httpVersion.shouldEqual(resData.httpVersion);
    response.status.shouldEqual(resData.status);
    response.statusText.shouldEqual(resData.statusText);
    response.headers.shouldEqual(resData.headers);
    response.content.shouldEqual("This is new content");    
}