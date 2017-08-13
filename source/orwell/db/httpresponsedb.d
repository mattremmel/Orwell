//
// httpresponsedb.d 
// Orwell
//
// Created by Matthew Remmel on 8/12/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.db.httpresponsedb;

public import d2sqlite3;
public import orwell.http.httpresponse;
import std.array;
import std.string;


// This module contains database operations for working with HttpResponse objects

/**
  * The function used to create the responses table
  */
void createResponsesTable(Database db) {
    db.run("
        DROP TABLE IF EXISTS responses;
        CREATE TABLE responses (
            id         INTEGER PRIMARY KEY,
            version    TEXT NOT NULL,
            status     INTEGER,
            statusText TEXT NOT NULL,
            headers    TEXT,
            content    TEXT,
            timestamp  INTEGER,
            size       INTEGER
        );
    ");
}

/**
  * Save the http response to the database
  */
void saveResponse(Database db, HttpResponse response) {
    // Statement that inserts the http response into the database
    static immutable string statement = "
    INSERT INTO responses (id, version, status, statusText, headers, content, timestamp, size)
    VALUES (:id, :version, :status, :statusText, :headers, :content, :timestamp, :size)
    ";

    // Create prepared statement
    Statement ps = db.prepare(statement);

    ps.bind(":id", response.id);
    ps.bind(":version", response.httpVersion);
    ps.bind(":status", response.status);
    ps.bind(":statusText", response.statusText);

    // Convert headers string
    string hstr = "";
    foreach (h; response.headers) {
        hstr ~= format("%s:%s\n", h.key, h.value);
    }
    ps.bind(":headers", hstr);

    ps.bind(":content", response.content);
    ps.bind(":timestamp", response.timestamp.stdTime());
    ps.bind(":size", response.size);

    // Execute and reset query
    ps.execute();
    ps.reset();
}

/**
  * Get http response object from database
  */
HttpResponse getResponseWithID(Database db, size_t id) {
    // Statement to retreive http response with id from database
    static immutable string statement = "
    SELECT * FROM responses WHERE id == :id;
    ";

    // Create prepared statement
    Statement ps = db.prepare(statement);
    ps.bind(":id", id);

    // Execute query
    ResultRange rr = ps.execute();
    assert(!rr.empty, "Expected one row in result");
    Row result = rr.front;
    assert(result.length == 8, "Expected 8 columns in response row");

    // Parse response into HttpResponse
    HttpResponse response = HttpResponse();
    response.id = id;
    response.httpVersion = result["version"].as!HttpVersion;
    response.status = result["status"].as!int;
    response.statusText = result["statusText"].as!string;
    
    // Convert headers string
    foreach (h; result["headers"].as!string.splitLines()) {
        size_t loc = h.indexOf(":");
        assert(loc != -1);
        response.headers ~= HttpHeader(h[0..loc], h[loc+1..$]);
    }

    response.content = result["content"].as!string;
    response.timestamp = SysTime(result["timestamp"].as!long);
    response.size = result["size"].as!size_t;

    // Reset query and return
    ps.reset();
    return response;
}