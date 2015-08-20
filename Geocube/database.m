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

@implementation database

@synthesize dbaccess, db;

- (id)init
{
    dbaccess = self;
    db = nil;
    return self;
}

- (void)checkVersion
{
    NSString *dbname = [[NSString alloc] initWithFormat:@"%@/%@", [MyTools DocumentRoot], DB_NAME];
    NSLog(@"Using %@ as the database.", dbname);
    NSString *dbempty = [[NSString alloc] initWithFormat:@"%@/%@", [MyTools DataDistributionDirectory], DB_EMPTY];

    // Keep a symlink to /Users/edwin/db to the database for easy access
    NSError *e;
    [fm removeItemAtPath:@"/Users/edwin/db" error:nil];
    [fm createSymbolicLinkAtPath:@"/Users/edwin/db" withDestinationPath:dbname error:&e];

    // If the database doesn't exist, create it
    [self checkAndCreateDatabase:dbname empty:dbempty];

    // Determine version of the distribution database
    sqlite3_open([dbempty UTF8String], &db);
    dbConfig *c_empty = [dbConfig dbGetByKey:@"version"];
    sqlite3_close(db);

    // Determine version of the active database
    sqlite3_open([dbname UTF8String], &db);
    dbConfig *c_real = [dbConfig dbGetByKey:@"version"];
    sqlite3_close(db);

    // If the active version is different from the distribution version, then reinitialize.
    NSLog(@"Database version %@, distribution is %@.", c_real.value, c_empty.value);
    if ([c_real.value isEqualToString:c_empty.value] == NO) {
        NSLog(@"Empty is newer, overwriting old one");
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"option_cleardatabase"];
        [self checkAndCreateDatabase:dbname empty:dbempty];
    }

    sqlite3_open([dbname UTF8String], &db);
}

- (void)checkAndCreateDatabase:(NSString *)dbname empty:(NSString *)dbempty
{
    BOOL success;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"option_cleardatabase"] == TRUE) {
        NSLog(@"Erasing database on user request.");
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"option_cleardatabase"];
        [fm removeItemAtPath:dbname error:NULL];
    }

    success = [fm fileExistsAtPath:dbname];
    if (success == NO) {
        [fm copyItemAtPath:dbempty toPath:dbname error:nil];
        NSLog(@"Initializing database from %@ to %@.", dbempty, dbname);
    }
}

- (void)dealloc
{
    sqlite3_close(db);
}

@end
