/*
 * Geocube
 * By Edwin Groothuis <geocube@mavetju.org>
 * Copyright 2015 Edwin Groothuis
 *
 * This file is part of Geocube.
 *
 * Geocube is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Geocube is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Geocube.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "Geocube-Prefix.pch"

@implementation dbCacheSymbol

@synthesize _id, symbol;

- (id)init:(NSInteger)__id symbol:(NSString *)_symbol
{
    self = [super init];
    _id = __id;
    symbol = _symbol;
    [self finish];
    return self;
}

+ (NSArray *)dbAll
{
    NSString *sql = @"select id, symbol from cache_symbols";
    sqlite3_stmt *req;
    NSMutableArray *ss = [[NSMutableArray alloc] initWithCapacity:20];
    dbCacheSymbol *s;

    @synchronized(dbO.dbaccess) {
        if (sqlite3_prepare_v2(dbO.db, [sql cStringUsingEncoding:NSUTF8StringEncoding], -1, &req, NULL) != SQLITE_OK)
            DB_ASSERT_PREPARE;

        while (sqlite3_step(req) == SQLITE_ROW) {
            INT_FETCH_AND_ASSIGN(req, 0, _id);
            TEXT_FETCH_AND_ASSIGN(req, 1, _symbol);
            s = [[dbCacheSymbol alloc] init:_id symbol:_symbol];
            [ss addObject:s];
        }
        sqlite3_finalize(req);
    }
    return ss;
}

+ (dbObject *)dbGet:(NSInteger)_id;
{
    NSString *sql = @"select id, symbol from cache_symbols where id = ?";
    sqlite3_stmt *req;
    dbCacheSymbol *s;

    @synchronized(dbO.dbaccess) {
        if (sqlite3_prepare_v2(dbO.db, [sql cStringUsingEncoding:NSUTF8StringEncoding], -1, &req, NULL) != SQLITE_OK)
            DB_ASSERT_PREPARE;

        SET_VAR_INT(req, 1, _id);

        if (sqlite3_step(req) == SQLITE_ROW) {
            INT_FETCH_AND_ASSIGN(req, 0, _id);
            TEXT_FETCH_AND_ASSIGN(req, 1, _symbol);
            s = [[dbCacheSymbol alloc] init:_id symbol:_symbol];
            return s;
        }
        sqlite3_finalize(req);
    }
    return nil;
}

- (NSInteger)dbCreate
{
    return [dbCacheSymbol dbCreate:symbol];
}

+ (NSInteger)dbCreate:(NSString *)symbol
{
    NSString *sql = @"insert into cache_symbols(symbol) values(?)";
    sqlite3_stmt *req;
    NSInteger __id;

    @synchronized(dbO.dbaccess) {
        if (sqlite3_prepare_v2(dbO.db, [sql cStringUsingEncoding:NSUTF8StringEncoding], -1, &req, NULL) != SQLITE_OK)
            DB_ASSERT_PREPARE;

        SET_VAR_TEXT(req, 1, symbol);

        if (sqlite3_step(req) != SQLITE_DONE)
            DB_ASSERT_STEP;
        __id = sqlite3_last_insert_rowid(dbO.db);
        sqlite3_finalize(req);
    }
    return __id;
}

@end