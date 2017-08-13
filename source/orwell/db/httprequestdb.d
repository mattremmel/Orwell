//
// httprequestdb.d 
// Orwell
//
// Created by Matthew Remmel on 8/10/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.db.httprequestdb;

public import d2sqlite3;
public import orwell.http.httprequest;
import std.array;
import std.string;


// This module contains database operations for working with HttpRequest objects

/**
  * The function used to create the requests table
  */
void createRequestsTable(Database db) {
    db.run("
        DROP TABLE IF EXISTS requests;
        CREATE TABLE requests (
            id        INTEGER PRIMARY KEY,
            method    TEXT NOT NULL,
            scheme    TEXT NOT NULL,
            host      TEXT NOT NULL,
            path      TEXT NOT NULL,
            port      INTEGER,
            user      TEXT,
            pass      TEXT,
            query     TEXT,
            fragment  TEXT,
            version   TEXT NOT NULL,
            headers   TEXT,
            content   TEXT,
            timestamp INTEGER,
            size      INTEGER
        );
    ");
}

/**
  * Save the http request to the database
  */
void saveRequest(Database db, HttpRequest request) {
    // Statement that inserts the http request into the database
    static immutable string statement = "
    INSERT INTO requests (id, method, scheme, host, path, port, user, pass, query, fragment, version, headers, content, timestamp, size)
    VALUES (:id, :method, :scheme, :host, :path, :port, :user, :pass, :query, :fragment, :version, :headers, :content, :timestamp, :size);
    ";
    
    // Create prepared statement
    Statement ps = db.prepare(statement);

    ps.bind(":id", request.id);
    ps.bind(":method", request.method);
    ps.bind(":scheme", request.url.scheme);
    ps.bind(":host", request.url.host);
    ps.bind(":path", request.url.path);
    ps.bind(":port", request.url.port);
    ps.bind(":user", request.url.user);
    ps.bind(":pass", request.url.pass);

    // Convert query string
    string qstr = "";
    foreach (param; request.url.queryParams) {
        qstr ~= format("%s=%s\n", param.key.percentEncode, param.value.percentEncode);
    }
    ps.bind(":query", qstr);
    
    ps.bind(":fragment", request.url.fragment);
    ps.bind(":version", request.httpVersion);

    // Convert headers string
    string hstr = "";
    foreach (h; request.headers) {
        hstr ~= format("%s:%s\n", h.key, h.value);
    }
    ps.bind(":headers", hstr);

    ps.bind(":content", request.content);
    ps.bind(":timestamp", request.timestamp.stdTime());
    ps.bind(":size", request.size);

    // Execute and reset query
    ps.execute();
    ps.reset();
}

/**
  * Get http request object from database
  */
HttpRequest getRequestWithID(Database db, size_t id) {
    // Statement to retreive http request with id from database
    static immutable string statement = "
    SELECT * FROM requests WHERE id == :id;
    ";

    // Create prepared statement
    Statement ps = db.prepare(statement);
    ps.bind(":id", id);

    // Execute query
    ResultRange rr = ps.execute();
    assert(!rr.empty, "Expected one row in result");
    Row result = rr.front;
    assert(result.length == 15, "Expected 15 columns in requests row");

    // Parse result into HttpRequest
    HttpRequest request = HttpRequest();
    request.id = id;
    request.method = result["method"].as!HttpMethod;
    request.url.scheme = result["scheme"].as!string;
    assert(request.url.scheme != "", "Scheme value should not be empty");
    request.url.host = result["host"].as!string;
    assert(request.url.host != "", "Host value should not be empty");
    request.url.path = result["path"].as!string;
    assert(request.url.path != "", "Path value should not be empty");
    request.url.port = result["port"].as!ushort;
    request.url.user = result["user"].as!string;
    request.url.pass = result["pass"].as!string;

    // Convert query string
    foreach (param; result["query"].as!string.splitLines()) {
        string[] pair = param.split("=");
        assert(pair.length == 2);
        request.url.queryParams.add(pair[0], pair[1]);
    }

    request.url.fragment = result["fragment"].as!string;
    request.httpVersion = result["version"].as!HttpVersion;

    // Convert headers string
    foreach (h; result["headers"].as!string.splitLines()) {
        size_t loc = h.indexOf(":");
        assert(loc != -1);
        request.headers ~= HttpHeader(h[0..loc], h[loc+1..$]);
    }

    request.content = result["content"].as!string;
    request.timestamp = SysTime(result["timestamp"].as!long);
    request.size = result["size"].as!size_t;

    // Reset query and return
    ps.reset();
    return request;
}