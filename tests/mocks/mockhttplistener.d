//
// mockhttplistener.d 
// Orwell
//
// Created by Matthew Remmel on 8/14/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.mocks.mockhttplistener;

import orwell.proxy.httplistener;
import std.socket;
import core.thread;
import std.conv;


/**
  * MockHttpListener accepts a client connection and sends it to the
  * clientHandler and then exits. It does not loop and is only used for
  * testing
  */
class MockHttpListener : Thread {

    // The listener
    TcpSocket listener;

    // HttpMessageHandler
    iHttpMessageHandler messageHandler;

    this(ref ushort assignedPort, iHttpMessageHandler messageHandler) {
        super(&run);
        this.messageHandler = messageHandler;

        // Create listener socket
        this.listener = new TcpSocket();

        // Bind listener to random port
        this.listener.bind(new InternetAddress("localhost", 0));

        // Send port number back to caller
        assignedPort = this.listener.localAddress.toPortString().to!ushort;
    }

    private void run() {
        // Listen for and accept client
        this.listener.listen(1);
        Socket client = this.listener.accept();

        auto handler = new HttpClientHandler(client, this.messageHandler).start();
    }
}