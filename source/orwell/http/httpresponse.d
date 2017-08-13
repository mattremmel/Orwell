//
// httpresponse.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.http.httpresponse;

public import orwell.http.httpmessage;
public import std.datetime;
import std.experimental.logger;
import std.string;
import std.format;
import std.conv;


struct HttpResponse {

    /**
      * The ID of the request this response is for
      */
    size_t id;

    /**
      * The HTTP version of the response
      */
    HttpVersion httpVersion;

    /**
      * The HTTP status code of the response
      */
    HttpStatusCode status;

    /**
      * The HTTP status text of the response
      */
    HttpStatusText statusText;

    /**
      * The list of HTTP response headers
      */
    HttpHeader[] headers;

    /**
      * The HTTP response body content
      */
    string content;

    /**
      * Response meta data
      */
    SysTime timestamp; /// The timestamp when the response was received
    size_t size;       /// The size of the entire response

    /**
      * Parse response string to HttpResponse object
      */ 
    this(string data) {
        // Split request into lines
        int i = 0;
        string[] lines = data.splitLines();

        // Find start line (RFC2616)
        while (lines[i] == "") { ++i; }

        // Handle status line
        string[] statusline = lines[i++].split(" ");
        this.httpVersion = fromValue!HttpVersion(statusline[0]);
        this.status = to!HttpStatusCode(statusline[1]);
        this.statusText = statusline[2..$].join(" ");

        // Handle headers
        // Empty line must be present between headers and body
        for (;lines[i] != ""; ++i) {
            string line = lines [i];

            // Parse and add header
            size_t loc = line.indexOf(":");
            this.headers ~= HttpHeader(line[0..loc].stripLeft(), line[loc+1..$].stripLeft());
        }

        // Set content
        // Skip CRLF token
        this.content = lines[++i..$].join("\n");
    }

    /**
      * Compile response object back into response string
      */
    string toString() {
        string response = "";

        // Add status line
        response ~= format("%s %s %s\n", cast(string)this.httpVersion, this.status, this.statusText);

        // Add headers
        foreach (h; this.headers) {
            response ~= format("%s: %s\n", h.key, h.value);
        }

        // Add CRLF between headers and content
        response ~= "\n";

        // Add content
        if (this.content.length > 0) {
            response ~= this.content;
        }
        else {
            response ~= "\n";
        }

        return response;
    }
}
