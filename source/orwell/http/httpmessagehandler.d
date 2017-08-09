//
// httpmessagehandler.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.http.httpmessagehandler;

public import orwell.http.httprequest;
public import orwell.http.httpresponse;


/**
  * The interface for handling intercepted messages
  */
interface iHttpMessageHandler {
    HttpRequest handleRequest(HttpRequest request);
    HttpResponse handleResponse(HttpResponse response);
}

/**
  * A default implementation of a message handler
  */
class HttpMessageHandler : iHttpMessageHandler {

    // Default HttpRequest handler
    HttpRequest handleRequest(HttpRequest request) {
        return request;
    }

    // Default HttpResponse handler
    HttpResponse handleResponse(HttpResponse response) {
        return response;
    }
}