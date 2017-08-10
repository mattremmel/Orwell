//
// httpcallbackmanager.d 
// Orwell
//
// Created by Matthew Remmel on 8/9/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.http.httpcallbackmanager;

public import orwell.http.httpmessagehandler;


/**
  * A class to handling the registering and calling of message handlers
  */
class HttpCallbackManager : iHttpMessageHandler {

    // The series of message handlers
    private iHttpMessageHandler[] messageHandlers;

    /**
      * Call the registered request handlers
      */
    HttpRequest handleRequest(HttpRequest request) {
        if (this.messageHandlers.length == 0) return request;

        foreach (mh ; this.messageHandlers) {
            request = mh.handleRequest(request);
        }

        return request;
    }

    /**
      * Call the registered response handlers
      */
    HttpResponse handleResponse(HttpResponse response) {
        if (this.messageHandlers.length == 0) return response;
        
        foreach (mh ; this.messageHandlers) {
            response = mh.handleResponse(response);
        }

        return response;
    }

    /**
      * Register a new message handler
      */ 
    void registerHandler(iHttpMessageHandler handler) {
        this.messageHandlers ~= handler;
    }

    /**
      * Unregisters a message handler
      */
    void unregisterHandler(iHttpMessageHandler handler) {
        // TODO:
    }
}