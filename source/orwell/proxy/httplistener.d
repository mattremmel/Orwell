//
// httplistener.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.proxy.httplistener;

public import orwell.http.httprequest;
public import orwell.http.httpresponse;
public import orwell.http.httpmessagehandler;
import std.socket;
import core.thread;
import std.concurrency;
import std.experimental.logger;

/**
  * Listener that accepts connections and sends them to the HttpClientHandler
  */
class HttpListener : Thread {

    // Listener Address
    string ip;
    ushort port;

    // Listener Socket
    TcpSocket listener;

    // HttpMessageHandler
    iHttpMessageHandler messageHandler;

    // Listener Status
    bool isRunning = false;

    this(string ip, ushort port, iHttpMessageHandler messageHandler) {
        super(&run);
        this.ip = ip;
        this.port = port;
        this.messageHandler = messageHandler;
    }

    /**
      * Http Listener Entry Point
      */
    private void run() {
        this.isRunning = true;

        trace("Initilizing http listener");

        // Create socket object
        this.listener = new TcpSocket();

        // Bind to address
        try {
            tracef("Binding to %s:%s", this.ip, this.port);
            this.listener.bind(new InternetAddress(ip, port));
        }
        catch (Exception e) {
           errorf("Http listener failed to bind to %s:%s", this.ip, this.port);
           return;
        }

        // Set socket to listen
        trace("Setting socket to listen");
        this.listener.listen(10);

        // Listen for connection
        infof("Listening on %s:%s", this.ip, this.port);
        while (this.isRunning) {
            trace("Waiting for client connection");
            Socket client = this.listener.accept();

            tracef("Accepted connection from %s:%s", client.remoteAddress().toAddrString(), client.remoteAddress().toPortString());

            // Start client handler
            auto handler = new HttpClientHandler(client, this.messageHandler).start();
        }
    }
}

/**
  * Handler that proxies requests and responses through a message handler
  */
class HttpClientHandler : Thread {

    // Client Socket
    Socket client;

    // HttpMessageHandler
    iHttpMessageHandler messageHandler;

    // HttpClientHandler Constructor
    this(Socket client, iHttpMessageHandler messageHandler) {
        super(&run);
        this.client = client;
        this.messageHandler = messageHandler;
    }

    /**
      * Client Handler Entry Point
      */
    private void run() {
        scope(exit) this.client.close();
        tracef("Starting client handler for %s:%s", this.client.remoteAddress().toAddrString(), this.client.remoteAddress().toPortString());

        // Receive request
        HttpRequest request = receiveRequest();

        // Send request to intercept handler
        request = this.messageHandler.handleRequest(request);

        // Send request to server
        HttpResponse response = this.sendRequest(request);
        response.id = request.id; // Link the request and response

        // Send response to intercept handler
        response = this.messageHandler.handleResponse(response);

        // Send response to client
        this.sendResponse(response);
    }

    /**
      * Receive request from client
      */
    private HttpRequest receiveRequest() {
        // Receive data
        char[] data = receiveData(this.client);

        // Parse request
        HttpRequest request;
        try {
            request = HttpRequest(data.idup);
            tracef("Successfully parsed request from %s:%s", this.client.remoteAddress().toAddrString(), this.client.remoteAddress().toPortString());
        }
        catch (Exception e) {
            errorf("Exception parsing request: %s\nRequest:\n%s", e, data);
            // TODO: handle error
        }
        
        return request;
    }

    /**
      * Forward request to host and wait for response
      */
    private HttpResponse sendRequest(HttpRequest request) {
        // Create socket object
        auto host = new TcpSocket;
        scope(exit) host.close();

        // Connect to host
        tracef("Connecting to %s:%s", request.url.host, request.url.port);
        host.connect(new InternetAddress(request.url.host, request.url.port));

        // Send data
        tracef("Sending data to %s:%s", request.url.host, request.url.port);
        host.send(request.toString());
        
        // Receive data
        char[] data = receiveData(host);

        HttpResponse response;
        try {
            response = HttpResponse(data.idup);
            tracef("Successfully parsed response from %s:%s", request.url.host, request.url.port);
        }
        catch (Exception e) {
            errorf("Exception parsing response: %s\nResponse:\n%s", e, data);
            // TODO: handle error
        }

        return response;
    }

    /**
      * Send request response back to client
      */
    private void sendResponse(HttpResponse response) {
        tracef("Sending response to %s:%s", this.client.remoteAddress().toAddrString(), this.client.remoteAddress().toPortString());
        this.client.send(response.toString());
    }

    /**
      * Block and receive all data from socket
      */
    static private char[] receiveData(Socket s) {
        char[] data;
        char[1024] buf;
        tracef("Receiving data from %s:%s", s.remoteAddress().toAddrString(), s.remoteAddress().toPortString());
        while (true) {
            auto recv = s.receive(buf);
            tracef("Received %s bytes from %s:%s", recv, s.remoteAddress().toAddrString(), s.remoteAddress().toPortString());
            data ~= buf[0..recv];

            // If received less than buffer size, no more data
            if (recv < buf.length) break;
        }

        return data;
    }
}
