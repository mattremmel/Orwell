//
// main.d 
// Orwell
//
// Created by Matthew Remmel on 8/2/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

import vibe.vibe;
import std.stdio;

void main() {
    auto settings = new HTTPServerSettings;
    settings.port = 8080;

    listenHTTP(settings, &proxyHandler);

    runApplication();
}

void proxyHandler(scope HTTPServerRequest sreq, scope HTTPServerResponse sres) {
    // Setup non forwarded headers map
    static immutable string[] non_forward_headers = ["Content-Length", "Transfer-Encoding", "Content-Encoding", "Connection"];
    static InetHeaderMap non_forward_headers_map;
	if (non_forward_headers_map.length == 0){
		foreach (n; non_forward_headers) {
			non_forward_headers_map[n] = "";
        }
    }

    // Handle setting up the proxied request
    void setupRequest(scope HTTPClientRequest creq) {
        creq.method = sreq.method;
        creq.requestURL = sreq.path; // Only set the resource path, not full URL
        creq.httpVersion = sreq.httpVersion;
        creq.headers = sreq.headers.dup;
        creq.headers["Host"] = sreq.fullURL.host;
        sreq.bodyReader.pipe(creq.bodyWriter);
    }

    // Handle the proxied response
    void handleResponse(scope HTTPClientResponse cres) {
        import vibe.utils.string;

        // Set status line
        sres.statusCode = cres.statusCode;
        sres.statusPhrase = cres.statusPhrase;
        sres.httpVersion = cres.httpVersion;

        // Special case for empty response bodies
        if ("Content-Length" !in cres.headers && "Transfer-Encoding" !in cres.headers || sreq.method == HTTPMethod.HEAD) {
            foreach (key, ref value; cres.headers) {
                if (icmp2(key, "Connection") != 0) {
                    sres.headers[key] = value;
                }
            }

            sres.writeVoidBody();
            return;
        }

        // Enforce compatibility with HTTP/1.0 clients that do not support chunked encoding
        if (sres.httpVersion == HTTPVersion.HTTP_1_0 && ("Transfer-Encoding" in cres.headers || "Content-Length" !in cres.headers)) {
            // Copy all headers that may pass from upstream to client
            foreach (key, ref value; cres.headers) {
                if (key !in non_forward_headers_map){
                    sres.headers[key] = value;
                }
            }

            if ("Transfer-Encoding" in sres.headers) {
                sres.headers.remove("Transfer-Encoding");
            }

            auto content = cres.bodyReader.readAll(1024*1024);
            sres.headers["Content-Length"] = to!string(content.length);
            
            if (sres.isHeadResponse) {
                sres.writeVoidBody();
            }
            else {
                sres.bodyWriter.write(content);
            }

            return;
        }

        // Perform a verbatim copy of the client response
        if ("Content-Length" in cres.headers) {
            
            if ("Content-Encoding" in sres.headers) {
                sres.headers.remove("Content-Encoding");
            }

            foreach (key, ref value; cres.headers) {
                if (icmp2(key, "Connection") != 0) {
                    sres.headers[key] = value;
                } 
            }

            auto size = cres.headers["Content-Length"].to!size_t();
            
            if (sres.isHeadResponse) {
                sres.writeVoidBody();
            }
            else {
                cres.readRawBody((scope InterfaceProxy!InputStream reader)
                {
                    sres.writeRawBody(reader, size);
                });
            }

            assert(sres.headerWritten);
            return;
        }

        // Fall back to a generic re-encoding of the response
        // copy all headers that may pass from upstream to client
        foreach (key, ref value; cres.headers)
            if (key !in non_forward_headers_map)
                sres.headers[key] = value;
        if (sres.isHeadResponse) sres.writeVoidBody();
        else cres.bodyReader.pipe(sres.bodyWriter);
    }

    writeln("Sending request to: ", sreq.requestURL);
    try requestHTTP(sreq.requestURL, &setupRequest, &handleResponse);
    catch (Exception e) {
        throw new HTTPStatusException(HTTPStatus.badGateway, "Connection to upstream server failed: ", e.msg);
    }
}

