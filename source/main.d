//
// main.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

import orwell.proxy.httplistener;


import std.stdio;
import std.string;


void main() {
    HttpListener server = new HttpListener("localhost", 8888, (HttpRequest request) {
        writeln("[Callback] Request intercepted:\n", request);
        return request;
    }, (HttpResponse response) {
        writeln("[Callback] Response intercepted:\n", response);
        return response;
    });

    server.start();
    server.join();
}
