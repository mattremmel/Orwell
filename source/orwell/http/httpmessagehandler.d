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


/// Aliases for request intercept handler 
alias HttpRequestHandler = HttpRequest delegate(HttpRequest request); 

/// Aliases for response intercept handler 
alias HttpResponseHandler = HttpResponse delegate(HttpResponse response); 

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

    // Request / Response Handlers
    private HttpRequestHandler requestHandler;
    private HttpResponseHandler responseHandler;

    /**
      * Sets the default message handlers to simply return
      */
    this() {
        this.requestHandler = (HttpRequest request) {
            return request;
        };

        this.responseHandler = (HttpResponse response) {
            return response;
        };
    }

    /**
      * Sets the message handlers to the specified delegates
      */
    this(HttpRequestHandler requestHandler, HttpResponseHandler responseHandler) {
        this.requestHandler = requestHandler;
        this.responseHandler = responseHandler;
    }

    /**
      * Handle the intercepted request
      */
    HttpRequest handleRequest(HttpRequest request) {
        return this.requestHandler(request);
    }

    /**
      * Handle the intercepted response
      */ 
    HttpResponse handleResponse(HttpResponse response) {
        return this.responseHandler(response);
    }
}