//
// mockhttpserver.d 
// Orwell
//
// Created by Matthew Remmel on 8/14/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.mocks.mockhttpserver;

import orwell.http.httprequest;
import std.socket;
import core.thread;
import std.conv;


/**
  * MockHttpServer reads an HttpRequest from the socket, and send the
  * request content back to the client
  */
class MockHttpServer : Thread {

    // Server socket
    TcpSocket server;

    // Server response
    string response;

    this(ref ushort assignedPort, string response) {
        super(&run);
        
        // Set response
        this.response = response;
        
        // Create server socket
        this.server = new TcpSocket();

        // Bind server to random port
        server.bind(new InternetAddress("localhost", 0));

        // Send port number back to caller
        assignedPort = this.server.localAddress.toPortString().to!ushort;
    }

    // Server entry point
    private void run() {

        // Listen for and accept client
        this.server.listen(1);
        Socket client = this.server.accept();

        // Receive data
        char[] data;
        char[1024] buf;
        while(true) {
            auto recv = client.receive(buf);
            data ~= buf[0..recv];

            // If received less than buffer, no more data
            if (recv < buf.length) break;
        }

        // Send response back to client
        client.send(this.response);

        // Cleanup
        server.close();
        client.close();

        return;
    }
}

// Unit Tests
import unit_threaded;
import tests.data.httprequestdata;
import tests.data.httpresponsedata;

@("basic_usage")
@Values(mixin(HttpRequestDataValues))
@Values(mixin(HttpResponseDataValues))
unittest {
    // Setup
    ushort port = 0;
    string resData = getValue!(HttpResponseData, 1).data;
    MockHttpServer mockServer = new MockHttpServer(port, resData);
    assert(port != 0, "MockHttpServer port should not equal 0");
    mockServer.start();

    string reqData = getValue!(HttpRequestData, 0).data;

    TcpSocket server = new TcpSocket(new InternetAddress("localhost", port));
    server.send(reqData);

    char[] data;
    char[1024] buf;
    while (true) {
        auto recv = server.receive(buf);
        data ~= buf[0..recv];

        if (recv < buf.length) break;
    }

    // Assertions
    data.shouldEqual(resData);
}
