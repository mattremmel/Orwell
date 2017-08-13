//
// httprequestdb_tests.d 
// Orwell
//
// Created by Matthew Remmel on 8/11/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module tests.db.httprequestdb_tests;

import unit_threaded;
import orwell.db.httprequestdb;
import tests.data.httprequestdata;
import std.conv;


// Prepared statments
enum string _idStatement = "SELECT id FROM requests WHERE id == :id";
enum string _methodStatement = "SELECT method FROM requests WHERE id == :id";
enum string _schemeStatement = "SELECT scheme FROM requests WHERE id == :id";
enum string _hostStatement = "SELECT host FROM requests WHERE id == :id";
enum string _pathStatement = "SELECT path FROM requests WHERE id == :id";
enum string _portStatement = "SELECT port FROM requests WHERE id == :id";
enum string _userStatement = "SELECT user FROM requests WHERE id == :id";
enum string _passStatement = "SELECT pass FROM requests WHERE id == :id";
enum string _queryStatement = "SELECT query FROM requests WHERE id == :id";
enum string _fragmentStatement = "SELECT fragment FROM requests WHERE id == :id";
enum string _versionStatement = "SELECT version FROM requests WHERE id == :id";
enum string _headersStatement = "SELECT headers FROM requests WHERE id == :id";
enum string _contentStatement = "SELECT content FROM requests WHERE id == :id";
enum string _timestampStatement = "SELECT timestamp FROM requests WHERE id == :id";
enum string _sizeStatement = "SELECT size FROM requests WHERE id == :id";


@("saveRequest")
@Values(mixin(HttpRequestDataValues))
unittest {
    // Setup
    Database db = Database(":memory:");
    db.createRequestsTable();

    HttpRequest r = HttpRequest(getValue!HttpRequestData.data);
    db.saveRequest(r);

    Statement idStatement = db.prepare(_idStatement); idStatement.bind(":id", r.id);
    Statement methodStatement = db.prepare(_methodStatement); methodStatement.bind(":id", r.id);
    Statement schemeStatement = db.prepare(_schemeStatement); schemeStatement.bind(":id", r.id);
    Statement hostStatement = db.prepare(_hostStatement); hostStatement.bind(":id", r.id);
    Statement pathStatement = db.prepare(_pathStatement); pathStatement.bind(":id", r.id);
    Statement userStatement = db.prepare(_userStatement); userStatement.bind(":id", r.id);
    Statement passStatement = db.prepare(_passStatement); passStatement.bind(":id", r.id);
    Statement queryStatement = db.prepare(_queryStatement); queryStatement.bind(":id", r.id);
    Statement fragmentStatement = db.prepare(_fragmentStatement); fragmentStatement.bind(":id", r.id);
    Statement versionStatement = db.prepare(_versionStatement); versionStatement.bind(":id", r.id);
    Statement headersStatement = db.prepare(_headersStatement); headersStatement.bind(":id", r.id);
    Statement contentStatement = db.prepare(_contentStatement); contentStatement.bind(":id", r.id);
    Statement timestampStatement = db.prepare(_timestampStatement); timestampStatement.bind(":id", r.id);
    Statement sizeStatement = db.prepare(_sizeStatement); sizeStatement.bind(":id", r.id);

    // Assertions
    db.totalChanges.shouldEqual(1);
    db.execute("SELECT count(*) FROM requests").oneValue!long.shouldEqual(1);
    idStatement.execute().oneValue!size_t.shouldEqual(r.id);
    methodStatement.execute().oneValue!string.to!HttpMethod.shouldEqual(r.method);
    schemeStatement.execute().oneValue!string.shouldEqual(r.url.scheme);
    hostStatement.execute().oneValue!string.shouldEqual(r.url.host);
    pathStatement.execute().oneValue!string.shouldEqual(r.url.path);
    userStatement.execute().oneValue!string.shouldEqual(r.url.user);
    passStatement.execute().oneValue!string.shouldEqual(r.url.pass);

    // Check query value
    /* NOTE: because the query values are manually encoded, they would
             be hard to test without duplicating the work. For this reason
             the easier option would be to rely on the getRequest unit tests
             to ensure that the query is being encoded and decoded correctly. */

    fragmentStatement.execute().oneValue!string.shouldEqual(r.url.fragment);
    versionStatement.execute().oneValue!string.to!HttpVersion.shouldEqual(r.httpVersion);

    // Check headers value
    /* NOTE: because the header values are manually encoded, they would
             be hard to test without duplicating the work. For this reason
             the easier option would be to rely on the getRequest unit tests
             to ensure that the headers are being encoded and decoded correctly. */

    contentStatement.execute().oneValue!string.shouldEqual(r.content);
    timestampStatement.execute().oneValue!long.to!SysTime.shouldEqual(r.timestamp);
    sizeStatement.execute().oneValue!size_t.shouldEqual(r.size);
}

@("getRequestWithID")
@Values(mixin(HttpRequestDataValues))
unittest {
    // Setup
    Database db = Database(":memory:");
    db.createRequestsTable();

    HttpRequest r = HttpRequest(getValue!HttpRequestData.data);
    db.saveRequest(r);

    HttpRequest request = db.getRequestWithID(r.id);
    
    // Assertions
    request.id.shouldEqual(r.id);
    request.method.shouldEqual(r.method);
    request.url.scheme.shouldEqual(r.url.scheme);
    request.url.host.shouldEqual(r.url.host);
    request.url.path.shouldEqual(r.url.path);
    request.url.port.shouldEqual(r.url.port);
    request.url.user.shouldEqual(r.url.user);
    request.url.pass.shouldEqual(r.url.pass);
    request.url.queryParams.shouldEqual(r.url.queryParams);
    request.url.fragment.shouldEqual(r.url.fragment);
    request.httpVersion.shouldEqual(r.httpVersion);
    request.headers.shouldEqual(r.headers);
    request.content.shouldEqual(r.content); 
}