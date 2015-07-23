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

@implementation dbSymbol

@synthesize symbol;

- (id)init:(NSId)__id symbol:(NSString *)_symbol
{
    self = [super init];
    _id = __id;
    symbol = _symbol;
    [self finish];
    return self;
}

+ (NSArray *)dbAll
{
    NSMutableArray *ss = [[NSMutableArray alloc] initWithCapacity:20];
    dbSymbol *s;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id, symbol from symbols");

        DB_WHILE_STEP {
            INT_FETCH_AND_ASSIGN(0, _id);
            TEXT_FETCH_AND_ASSIGN(1, _symbol);
            s = [[dbSymbol alloc] init:_id symbol:_symbol];
            [ss addObject:s];
        }
        DB_FINISH;
    }
    return ss;
}

+ (dbObject *)dbGet:(NSId)_id;
{
    dbSymbol *s;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id, symbol from symbols where id = ?");

        SET_VAR_INT(1, _id);

        DB_IF_STEP {
            INT_FETCH_AND_ASSIGN( 0, _id);
            TEXT_FETCH_AND_ASSIGN(1, _symbol);
            s = [[dbSymbol alloc] init:_id symbol:_symbol];
            return s;
        }
        DB_FINISH;
    }
    return nil;
}

- (NSId)dbCreate
{
    return [dbSymbol dbCreate:symbol];
}

+ (NSId)dbCreate:(NSString *)symbol
{
    NSId __id;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"insert into symbols(symbol) values(?)");

        SET_VAR_TEXT(1, symbol);

        DB_CHECK_OKAY;
        DB_GET_LAST_ID(__id);
        DB_FINISH;
    }
    return __id;
}

@end
