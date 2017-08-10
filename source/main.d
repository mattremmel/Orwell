//
// main.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

import orwell.proxy.httplistener;
import orwell.http.httpcallbackmanager;
import std.stdio;
import std.string;


void main() {
    HttpCallbackManager cbManager = new HttpCallbackManager();
    cbManager.registerHandler(new HttpMessageHandler(
        (HttpRequest request) {
            writeln("[Callback] Request intercepted");
            return request;
        },
        (HttpResponse response) {
            writeln("[Callback] Response intercepted");
            return response;
        })
    );

    HttpListener server = new HttpListener("localhost", 8888, cbManager);

    server.start();
    server.join();
}
