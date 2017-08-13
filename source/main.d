//
// main.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

import orwell.proxy.httplistener;
import orwell.http.httpcallbackmanager;
import orwell.db.database;
import orwell.db.httprequestdb;
import orwell.db.httpresponsedb;
import std.stdio;
import std.string;


void main() {
    // Callback Manager
    HttpCallbackManager cbManager = new HttpCallbackManager();

    // Setup database
    Database db = Database(":memory:");
    db.initializeDatabase();

    cbManager.registerHandler(new HttpMessageHandler(
        (HttpRequest request) {
            db.saveRequest(request);
            writefln("Saved request for: %s", request.url.host);
            return request;
        },
        (HttpResponse response) {
            db.saveResponse(response);
            writeln("Saved response");
            return response;
        }
    ));

    // Start http listener
    HttpListener server = new HttpListener("localhost", 8888, cbManager);
    server.start();
    server.join();
}
