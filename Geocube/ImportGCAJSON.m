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

@interface ImportGCAJSON ()
{
    dbAccount *account;
    dbGroup *group;

    NSMutableArray *namesImported;
}

@end

@implementation ImportGCAJSON

@synthesize namesImported, delegate;

- (instancetype)init:(dbGroup *)_group account:(dbAccount *)_account
{
    self = [super init];

    group = _group;
    account = _account;

    NSLog(@"%@: Importing into %@", [self class], group.name);

    return self;
}

- (void)parseBefore_cache
{
    NSLog(@"%@/parseBefore_cache: Parsing initializing", [self class]);
    namesImported = [NSMutableArray arrayWithCapacity:50];
}

- (void)parseData_cache:(NSDictionary *)dict
{
    NSLog(@"%@/parseData_cache: Parsing data", [self class]);

    /*
     {
         "datetime" : "2015-12-10T08:37:41Z",
         "msg" : "Caches",
         "actionstatus" : "1",
         "geocaches" : [
         ]`
     }
     */

    [self parseGeocaches:[dict objectForKey:@"geocaches"]];
    [waypointManager needsRefresh];
}

- (void)parseAfter_cache
{
    NSLog(@"%@/parseAfter_cache: Parsing done", [self class]);
}

- (void)parseGeocaches:(NSArray *)as
{
    [as enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL *stop) {
        [self parseGeocache:d];
        if (delegate != nil)
            [delegate updateGCAJSONImportDataWaypoints];
    }];
}

- (void)parseGeocache:(NSDictionary *)dict
{
    dbWaypoint *wp = [[dbWaypoint alloc] init:0];
    /*
    {
        "terrain" : "1.5",
        "coords" : {
            "lon" : 151.12445,
            "lat" : -34.048867
        },
        "type" : "B",
        "state" : "NSW",
        "placedby" : "Richary",
        "short_description" : "A gnome for the latest race",
        "name" : "Golden [Genome]",
        "direction" : null,
        "country" : "AU",
        "archived" : "f",
        "available" : "t",
        "log1" : "Moved",
        "log3" : "Found it",
        "difficulty" : "1.5",
        "waypoint" : "GA7854",
        "type_text" : "Moveable",
        "hidden" : "2015-12-01",
        "log2" : "Found it",
        "recommended" : "0",
        "long_description" : "&lt;p&gt;Golden gnome is a ....",
        "locale" : "Caringbah South",
        "distance" : 1.11,
        "log4" : "Moved",
        "owner" : "richary",
        "container" : "R",
        "container_text" : "Regular",
        "found": "y",
        "datefound": "2015-12-02",
        "hints" : "",
        "icon" : "cacheicon_moveable.png",
        "rating" : 4
    }
     */

    NSDictionary *coords = [dict objectForKey:@"coords"];
    NSString *dummy;

    NSString *wpname;
    DICT_NSSTRING_KEY(dict, wpname, @"waypoint");
    NSId old = [dbWaypoint dbGetByName:wpname];
    if (old != 0)
        wp = [dbWaypoint dbGet:old];

    DICT_FLOAT_KEY(dict, wp.gs_rating_terrain, @"terrain");
    DICT_NSSTRING_KEY(coords, wp.wpt_lat, @"lat");
    DICT_NSSTRING_KEY(coords, wp.wpt_lon, @"lon");
    DICT_NSSTRING_KEY(dict, wp.wpt_type_str, @"type");
    wp.wpt_type = nil;
    DICT_NSSTRING_KEY(dict, wp.gs_state_str, @"state");
    wp.gs_state = nil;
    DICT_NSSTRING_KEY(dict, wp.gs_placed_by, @"placedby");
    DICT_NSSTRING_KEY(dict, wp.gs_short_desc, @"short_description");
    wp.gs_short_desc_html = YES;
    DICT_NSSTRING_KEY(dict, wp.wpt_urlname, @"name");
    DICT_NSSTRING_KEY(dict, wp.gs_country_str, @"country");
    wp.gs_country = nil;
    DICT_NSSTRING_KEY(dict, dummy, @"archived");
    wp.gs_archived = [dummy isEqualToString:@"t"];
    DICT_NSSTRING_KEY(dict, dummy, @"available");
    wp.gs_available = [dummy isEqualToString:@"t"];
    DICT_FLOAT_KEY(dict, wp.gs_rating_difficulty, @"difficulty");
    DICT_NSSTRING_KEY(dict, wp.wpt_name, @"waypoint");
    DICT_NSSTRING_KEY(dict, wp.wpt_type_str, @"type_text");
    wp.wpt_type = nil;
    DICT_NSSTRING_KEY(dict, wp.wpt_date_placed, @"hidden");
    DICT_NSSTRING_KEY(dict, wp.gs_long_desc, @"long_description");
    wp.gs_long_desc_html = YES;
    DICT_NSSTRING_KEY(dict, wp.gs_owner_str, @"owner");
    wp.gs_owner = nil;
    DICT_NSSTRING_KEY(dict, wp.gs_container_str, @"container_text");
    wp.gs_container = nil;
    DICT_NSSTRING_KEY(dict, wp.gs_hint, @"hints");
    DICT_INTEGER_KEY(dict, wp.gs_date_found, @"datefound");

    wp.account = account;
    wp.account_id = account._id;

    if (wp.wpt_symbol_str == nil)
        wp.wpt_symbol_str = @"Geocache";

    [wp finish];

    if (old == 0) {
        NSLog(@"%@: Creating %@", [self class], wpname);
        [dbWaypoint dbCreate:wp];
        [group dbAddWaypoint:wp._id];
    } else {
        NSLog(@"%@: Updating %@", [self class], wpname);
        [wp dbUpdate];
        if ([group dbContainsWaypoint:wp._id] == NO)
            [group dbAddWaypoint:wp._id];
    }

    [namesImported addObject:wpname];
}

- (void)parseBefore_logs
{
    NSLog(@"%@/parseBefore_logs: Parsing initializing", [self class]);
}

- (void)parseData_logs:(NSDictionary *)data
{
    NSLog(@"%@/parseData_logs: Parsing data", [self class]);
    /*
     actionstatus = 1;
     datetime = "2016-01-06T21:26:18Z";
     logs =     (
     );
     msg = Logs
     */

    [self parseLogs:[data objectForKey:@"logs"]];
}

- (void)parseAfter_logs
{
    NSLog(@"%@/parseAfter_logs: Parsing done", [self class]);
}

- (void)parseLogs:(NSArray *)as
{
    [as enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL *stop) {
        [self parseLog:d];
        if (delegate != nil)
            [delegate updateGCAJSONImportDataLogs];
    }];
}

- (void)parseLog:(NSDictionary *)dict
{
    /*
     {
     cache = GA4338;
     cacher = ziggiau;
     coords = "";
     date = "2015-08-05";
     icon = "icon_flat_sm_found.png";
     id = 11713450;
     text = "In an effort to get some GCA finds under my belt, I finally found my first traditional one and the first in this series, almost 3 years to the day since the FTF of this cache. Knew where I had to look but still made things more difficult than I needed to for such an easy find.";
     type = "Found it";
     }
     */
    dbLog *t = [[dbLog alloc] init:0];
    NSString *dummy;

    t.waypoint_id = [dbWaypoint dbGetByName:[dict objectForKey:@"cache"]];
    DICT_INTEGER_KEY(dict, t.gc_id, @"id");
    DICT_NSSTRING_KEY(dict, t.logtype_string, @"type");
    DICT_NSSTRING_KEY(dict, dummy, @"date");
    t.datetime = [NSString stringWithFormat:@"%@T00:00:00", dummy];
    DICT_NSSTRING_KEY(dict, t.logger_str, @"cacher");
    DICT_NSSTRING_KEY(dict, t.log, @"text");
    t.needstobelogged = NO;
    [t finish];

    NSId _id = [dbLog dbGetIdByGC:t.gc_id account:account];
    if (_id == 0) {
        [dbLog dbCreate:t];
    } else {
        t._id = _id;
        [t dbUpdate];
    }
}

@end
