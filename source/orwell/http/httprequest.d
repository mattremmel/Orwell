//
// httprequest.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.http.httprequest;

public import orwell.http.httpmessage;
import url;
import std.experimental.logger;
import std.string;
import std.format;
import std.datetime;


/**
  * The struct responsible for holding a representation of an
  * HTTP request.
  */
struct HttpRequest {

    
    /**
      * The HTTP/1.1 method of the request
      */
    HttpMethod method; 
    
    /**
      * The Uniform Resource Locator
      */
    URL url;

    /**
      * The HTTP version of the request
      */
    HttpVersion httpVersion;

    /**
      * The list of HTTP request headers
      */
    HttpHeader[] headers;

    /**
      * The body of the request
      */
    string content;

    /**
      * Request meta data
      */
    SysTime timestamp; /// The timestamp when the request was sent
    size_t size;       /// The size of the entire request

    /**
      * Parse request string into HttpRequest object
      */
    this(string data) {
        // Split request into lines
        int i = 0;
        string[] lines = data.splitLines();

        // Find start line (RFC2616)
        while (lines[i] == "") { ++i; }
       
        // Handle start line 
        string[] startline = lines[i++].split(" ");
        this.method = fromValue!HttpMethod(startline[0]);
        this.url = parseURL(startline[1]);
        this.httpVersion = fromValue!HttpVersion(startline[2]);

        // Handle headers
        // Empty line must be present between headers and body
        for (;lines[i] != ""; ++i) {
            string line = lines[i];

            // Parse and add header
            size_t loc = line.indexOf(":");
            this.headers ~= HttpHeader(line[0..loc].stripLeft(), line[loc+1..$].stripLeft());
        }

        // Set content
        // Skip CRLF token
        this.content = lines[++i..$].join("\n");
    }

    /**
      * Compile request object back into request string
      */
    string toString() {
        string request = "";

        // Add start line
        request ~= format("%s %s %s\n", this.method, this.url, cast(string)this.httpVersion);

        // Add headers
        foreach (h; this.headers) {
            request ~= format("%s: %s\n", h.key, h.value);
        }

        // Add CRLF between headers and content
        request ~= "\n";

        // Add content
        if (this.content.length > 0) {
            request ~= this.content;
        }
        else {
            request ~= "\n";
        }

        return request;
    }
}

