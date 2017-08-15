//
// httplistener_test.d 
// Orwell
//
// Created by Matthew Remmel on 8/14/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.proxy.httplistener_tests;

import unit_threaded;
import orwell.proxy.httplistener;
import tests.data.httprequestdata;
import tests.data.httpresponsedata;
import tests.mocks.mockhttpserver;
import tests.mocks.mockhttplistener;
import std.socket;


@("clientHandler")
@Values(mixin(HttpRequestDataValues))
@Values(mixin(HttpResponseDataValues))
unittest {
    /*
     * Setup
     */

    // Data
    HttpRequest request = HttpRequest(getValue!(HttpRequestData, 0).data);
    HttpResponse response = HttpResponse(getValue!(HttpResponseData, 1).data);
    
    // Intercepted messages
    HttpRequest irequest;
    HttpResponse iresponse;

    // Setup mock http server
    ushort serverPort = 0;
    MockHttpServer mockServer = new MockHttpServer(serverPort, response.toString());
    assert(serverPort != 0, "MockHttpServer port should not equal 0");
    mockServer.start();

    // Setup mock http listener
    ushort listenerPort = 0;
    MockHttpListener mockListener = new MockHttpListener(listenerPort, new HttpMessageHandler(
        (HttpRequest ireq) {
            irequest = ireq;
            return ireq;
        },
        (HttpResponse ires) {
            iresponse = ires;
            return ires;
        }
    ));
    assert(listenerPort != 0, "MockHttpListener port should not equal 0");
    mockListener.start();

    // Send request to the listener, with target set as mock http server
    TcpSocket proxy = new TcpSocket(new InternetAddress("localhost", listenerPort));
    request.url.host = "localhost";
    request.url.port = serverPort;
    proxy.send(request.toString());

    // Receive data
    char[] data;
    char[1024] buf;
    while (true) {
        auto recv = proxy.receive(buf);
        data ~= buf[0..recv];

        if (recv < buf.length) break;
    }

    /*
     * Assertions
     */
    irequest.method.shouldEqual(request.method);
    irequest.url.shouldEqual(request.url);
    irequest.httpVersion.shouldEqual(request.httpVersion);
    irequest.headers.shouldEqual(request.headers);
    irequest.content.shouldEqual(request.content);

    iresponse.httpVersion.shouldEqual(response.httpVersion);
    iresponse.status.shouldEqual(response.status);
    iresponse.statusText.shouldEqual(response.statusText);
    iresponse.headers.shouldEqual(response.headers);
    iresponse.content.shouldEqual(iresponse.content);

    data.shouldEqual(response.toString());
}
