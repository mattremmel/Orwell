//
// httpresponsedb.d 
// Orwell
//
// Created by Matthew Remmel on 8/12/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.db.httpresponsedb_tests;

import unit_threaded;
import orwell.db.httpresponsedb;
import tests.data.httpresponsedata;
import std.conv;


// Prepared statements
enum string _idStatement = "SELECT id FROM responses WHERE id == :id";
enum string _versionStatement = "SELECT version FROM responses WHERE id == :id";
enum string _statusStatement = "SELECT status FROM responses WHERE id == :id";
enum string _statusTextStatement = "SELECT statusText FROM responses WHERE id == :id";
enum string _headersStatement = "SELECT headers FROM responses WHERE id == :id";
enum string _contentStatement = "SELECT content FROM responses WHERE id == :id";
enum string _timestampStatement = "SELECT timestamp FROM responses WHERE id == :id";
enum string _sizeStatement = "SELECT timestamp FROM responses WHERE id == :id";


@("saveResponse")
@Values(mixin(HttpResponseDataValues))
unittest {
    // Setup
    Database db = Database(":memory:");
    db.createResponsesTable();

    HttpResponse r = HttpResponse(getValue!HttpResponseData.data);
    db.saveResponse(r);

    Statement idStatement = db.prepare(_idStatement); idStatement.bind(":id", r.id);
    Statement versionStatement = db.prepare(_versionStatement); versionStatement.bind(":id", r.id);
    Statement statusStatement = db.prepare(_statusStatement); statusStatement.bind(":id", r.id);
    Statement statusTextStatement = db.prepare(_statusTextStatement); statusTextStatement.bind(":id", r.id);
    Statement headersStatement = db.prepare(_headersStatement); headersStatement.bind(":id", r.id);
    Statement contentStatement = db.prepare(_contentStatement); contentStatement.bind(":id", r.id);
    Statement timestampStatement = db.prepare(_timestampStatement); timestampStatement.bind(":id", r.id);
    Statement sizeStatement = db.prepare(_sizeStatement); sizeStatement.bind(":id", r.id);

    // Assertions
    db.totalChanges.shouldEqual(1);
    db.execute("SELECT count(*) FROM responses").oneValue!long.shouldEqual(1);
    idStatement.execute().oneValue!size_t.shouldEqual(r.id);
    versionStatement.execute().oneValue!string.to!HttpVersion.shouldEqual(r.httpVersion);
    statusStatement.execute().oneValue!int.shouldEqual(r.status);
    statusTextStatement.execute().oneValue!string.shouldEqual(r.statusText);

    // Check headers value
    /* NOTE: because the header values are manually encoded, they would
             be hard to test without duplicating the work. For this reason
             the easier option would be to rely on the getRequest unit tests
             to ensure that the headers are being encoded and decoded correctly. */
    
    contentStatement.execute().oneValue!string.shouldEqual(r.content);
    timestampStatement.execute().oneValue!long.to!SysTime.shouldEqual(r.timestamp);
    sizeStatement.execute().oneValue!size_t.shouldEqual(r.size);
}

@("getResponseWithID")
@Values(mixin(HttpResponseDataValues))
unittest {
    // Setup
    Database db = Database(":memory:");
    db.createResponsesTable();

    HttpResponse r = HttpResponse(getValue!HttpResponseData.data);
    db.saveResponse(r);

    HttpResponse response = db.getResponseWithID(r.id);

    // Assertions
    response.id.shouldEqual(r.id);
    response.httpVersion.shouldEqual(r.httpVersion);
    response.status.shouldEqual(r.status);
    response.statusText.shouldEqual(r.statusText);
    response.headers.shouldEqual(r.headers);
    response.content.shouldEqual(r.content);
    response.timestamp.shouldEqual(r.timestamp);
    response.size.shouldEqual(r.size);
}