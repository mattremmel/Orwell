//
// database.d 
// Orwell
//
// Created by Matthew Remmel on 8/9/17.
// Copyright (c) 2017 Matthew Remmel. All rights reserved.
//

module orwell.db.database;

public import d2sqlite3;
import orwell.db.httprequestdb;
import orwell.db.httpresponsedb;

// Assert that sqlite3 was compiled with thread-safe enabled
static this() {
    assert(threadSafe(), "sqlite3 was not compiled to be thread safe");
}

void initializeDatabase(Database db) {
    // Create requests table
    db.createRequestsTable();
    db.createResponsesTable();
}