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

@implementation dbCache

@synthesize name, description, url, lat, lon, lat_int, lon_int, lat_float, lon_float, date_placed, date_placed_epoch, gc_rating_difficulty, gc_rating_terrain, gc_favourites, cache_type_int, cache_type_str, cache_type, gc_country, gc_state, gc_short_desc_html, gc_short_desc, gc_long_desc_html, gc_long_desc, gc_hint, gc_personal_note, calculatedDistance, coordinates, gc_containerSize, gc_containerSize_str, gc_containerSize_int, gc_archived, gc_available, cache_symbol, cache_symbol_int, cache_symbol_str, gc_owner, gc_placed_by;

- (id)init:(NSId)__id
{
    self = [super init];
    _id = __id;

    self.gc_archived = NO;
    self.gc_available = YES;
    self.gc_country = nil;
    self.gc_state = nil;
    self.gc_short_desc = nil;
    self.gc_short_desc_html = NO;
    self.gc_long_desc = nil;
    self.gc_long_desc_html = NO;
    self.gc_hint = nil;
    self.gc_personal_note = nil;
    self.gc_containerSize = nil;
    self.gc_favourites = 0;
    self.gc_rating_difficulty = 0;
    self.gc_rating_terrain = 0;

    return self;
}

- (void)finish
{
    // Conversions from the data retrieved
    lat_float = [lat floatValue];
    lon_float = [lon floatValue];
    lat_int = lat_float * 1000000;
    lon_int = lon_float * 1000000;
    cache_type = [dbc CacheType_get:cache_type_int];

    date_placed_epoch = [MyTools secondsSinceEpoch:date_placed];

    coordinates = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);

    // Adjust container size
    if (gc_containerSize == nil) {
        if (gc_containerSize_int != 0) {
            gc_containerSize = [dbc ContainerSize_get:gc_containerSize_int];
            gc_containerSize_str = gc_containerSize.size;
        }
        if (gc_containerSize_str != nil) {
            gc_containerSize = [dbc ContainerSize_get_bysize:gc_containerSize_str];
            gc_containerSize_int = gc_containerSize._id;
        }
    }

    // Adjust cache types
    if (cache_type == nil) {
        if (cache_type_int != 0) {
            cache_type = [dbc CacheType_get:cache_type_int];
            cache_type_str = cache_type.type;
        }
        if (cache_type_str != nil) {
            cache_type = [dbc CacheType_get_byname:cache_type_str];
            cache_type_int = cache_type._id;
        }
    }
    if (cache_type == nil) {
        cache_type = [dbc CacheType_get_byname:cache_symbol_str];
        cache_type_int = cache_type._id;
        cache_type_str = cache_symbol_str;
    }

    // Adjust cache symbol
    if (cache_symbol == nil) {
        if (cache_symbol_int != 0) {
            cache_symbol = [dbc CacheSymbol_get:cache_symbol_int];
            cache_symbol_str = cache_symbol.symbol;
        }
        if (cache_symbol_str != nil) {
            cache_symbol = [dbc CacheSymbol_get_bysymbol:cache_symbol_str];
            cache_symbol_int = cache_symbol._id;
        }
    }

    [super finish];
}

- (NSInteger)hasLogs {
    return [dbLog dbCountByCache:_id];
}

- (NSInteger)hasAttributes {
    return [dbAttribute dbCountByCache:_id];
}

- (NSInteger)hasFieldNotes { return 0; }
- (NSInteger)hasWaypoints { return 0; }
- (NSInteger)hasImages { return 0; }

- (NSInteger)hasInventory {
    return [dbTravelbug dbCountByCache:_id];
}

+ (NSMutableArray *)dbAll
{
    NSMutableArray *caches = [[NSMutableArray alloc] initWithCapacity:20];
    dbCache *cache;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id, name, description, lat, lon, lat_int, lon_int, date_placed, date_placed_epoch, url, cache_type, gc_country, gc_state, gc_rating_difficulty, gc_rating_terrain, gc_favourites, gc_long_desc_html, gc_long_desc, gc_short_desc_html, gc_short_desc, gc_hint, gc_container_size_id, gc_archived, gc_available, cache_symbol, gc_owner, gc_placed_by from caches");

        DB_WHILE_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, __id);
            TEXT_FETCH_AND_ASSIGN(req, 1, _name);
            TEXT_FETCH_AND_ASSIGN(req, 2, _desc);
            TEXT_FETCH_AND_ASSIGN(req, 3, _lat);
            TEXT_FETCH_AND_ASSIGN(req, 4, _lon);
            INT_FETCH_AND_ASSIGN(req, 5, _lat_int);
            INT_FETCH_AND_ASSIGN(req, 6, _lon_int);
            TEXT_FETCH_AND_ASSIGN(req, 7, _date_placed);
            INT_FETCH_AND_ASSIGN(req, 8, _date_placed_epoch);
            TEXT_FETCH_AND_ASSIGN(req, 9, _url);
            INT_FETCH_AND_ASSIGN(req, 10, _cache_type);
            TEXT_FETCH_AND_ASSIGN(req, 11, _country);
            TEXT_FETCH_AND_ASSIGN(req, 12, _state);
            DOUBLE_FETCH_AND_ASSIGN(req, 13, _ratingD);
            DOUBLE_FETCH_AND_ASSIGN(req, 14, _ratingT);
            INT_FETCH_AND_ASSIGN(req, 15, _favourites);
            BOOL_FETCH_AND_ASSIGN(req, 16, _gc_long_desc_html);
            TEXT_FETCH_AND_ASSIGN(req, 17, _gc_long_desc);
            BOOL_FETCH_AND_ASSIGN(req, 18, _gc_short_desc_html);
            TEXT_FETCH_AND_ASSIGN(req, 19, _gc_short_desc);
            TEXT_FETCH_AND_ASSIGN(req, 20, _gc_hint);
            INT_FETCH_AND_ASSIGN(req, 21, _gc_container_size);
            BOOL_FETCH_AND_ASSIGN(req, 22, _gc_archived);
            BOOL_FETCH_AND_ASSIGN(req, 23, _gc_available);
            BOOL_FETCH_AND_ASSIGN(req, 24, _cache_symbol);
            TEXT_FETCH_AND_ASSIGN(req, 25, _gc_owner);
            TEXT_FETCH_AND_ASSIGN(req, 26, _gc_placed_by);

            cache = [[dbCache alloc] init:__id];
            [cache setName:_name];
            [cache setDescription:_desc];
            [cache setLat:_lat];
            [cache setLon:_lon];

            [cache setLat_int:_lat_int];
            [cache setLon_int:_lon_int];
            [cache setDate_placed:_date_placed];
            [cache setDate_placed_epoch:_date_placed_epoch];
            [cache setUrl:_url];
            [cache setCache_type_int:_cache_type];
            [cache setGc_country:_country];
            [cache setGc_state:_state];
            [cache setGc_rating_difficulty:_ratingD];
            [cache setGc_rating_terrain:_ratingT];
            [cache setGc_favourites:_favourites];
            [cache setGc_long_desc_html:_gc_long_desc_html];
            [cache setGc_long_desc:_gc_long_desc];
            [cache setGc_short_desc_html:_gc_short_desc_html];
            [cache setGc_short_desc:_gc_short_desc];
            [cache setGc_hint:_gc_hint];
            [cache setGc_containerSize_int:_gc_container_size];
            [cache setGc_archived:_gc_archived];
            [cache setGc_available:_gc_available];
            [cache setCache_symbol_int:_cache_symbol];
            [cache setGc_owner:_gc_owner];
            [cache setGc_placed_by:_gc_placed_by];
            [cache finish];
            [caches addObject:cache];
        }
        DB_FINISH;
    }
    return caches;
}

+ (NSId)dbGetByName:(NSString *)name
{
    NSId _id = 0;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id from caches where name = ?");

        SET_VAR_TEXT(req, 1, name);

        DB_IF_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, __id);
            _id = __id;
        }
        DB_FINISH;
    }
    return _id;
}

+ (dbCache *)dbGet:(NSId)__id
{
    NSMutableArray *caches = [[NSMutableArray alloc] initWithCapacity:20];
    dbCache *cache;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id, name, description, lat, lon, lat_int, lon_int, date_placed, date_placed_epoch, url, cache_type, gc_country, gc_state, gc_rating_difficulty, gc_rating_terrain, gc_favourites, gc_long_desc_html, gc_long_desc, gc_short_desc_html, gc_short_desc, gc_hint, gc_container_size_id, gc_archived, gc_available, cache_symbol, gc_owner, gc_placed_by from caches where id = ?");

        SET_VAR_INT(req, 1, __id);

        DB_IF_STEP {
            INT_FETCH_AND_ASSIGN(req, 0, __id);
            TEXT_FETCH_AND_ASSIGN(req, 1, _name);
            TEXT_FETCH_AND_ASSIGN(req, 2, _desc);
            TEXT_FETCH_AND_ASSIGN(req, 3, _lat);
            TEXT_FETCH_AND_ASSIGN(req, 4, _lon);
            INT_FETCH_AND_ASSIGN(req, 5, _lat_int);
            INT_FETCH_AND_ASSIGN(req, 6, _lon_int);
            TEXT_FETCH_AND_ASSIGN(req, 7, _date_placed);
            INT_FETCH_AND_ASSIGN(req, 8, _date_placed_epoch);
            TEXT_FETCH_AND_ASSIGN(req, 9, _url);
            INT_FETCH_AND_ASSIGN(req, 10, _cache_type);
            TEXT_FETCH_AND_ASSIGN(req, 11, _country);
            TEXT_FETCH_AND_ASSIGN(req, 12, _state);
            DOUBLE_FETCH_AND_ASSIGN(req, 13, _ratingD);
            DOUBLE_FETCH_AND_ASSIGN(req, 14, _ratingT);
            INT_FETCH_AND_ASSIGN(req, 15, _favourites);
            BOOL_FETCH_AND_ASSIGN(req, 16, _gc_long_desc_html);
            TEXT_FETCH_AND_ASSIGN(req, 17, _gc_long_desc);
            BOOL_FETCH_AND_ASSIGN(req, 18, _gc_short_desc_html);
            TEXT_FETCH_AND_ASSIGN(req, 19, _gc_short_desc);
            TEXT_FETCH_AND_ASSIGN(req, 20, _gc_hint);
            INT_FETCH_AND_ASSIGN(req, 21, _gc_container_size);
            BOOL_FETCH_AND_ASSIGN(req, 22, _gc_archived);
            BOOL_FETCH_AND_ASSIGN(req, 23, _gc_available);
            BOOL_FETCH_AND_ASSIGN(req, 24, _cache_symbol);
            TEXT_FETCH_AND_ASSIGN(req, 25, _gc_owner);
            TEXT_FETCH_AND_ASSIGN(req, 26, _gc_placed_by);

            cache = [[dbCache alloc] init:__id];
            [cache setName:_name];
            [cache setDescription:_desc];
            [cache setLat:_lat];
            [cache setLon:_lon];

            [cache setLat_int:_lat_int];
            [cache setLon_int:_lon_int];
            [cache setDate_placed:_date_placed];
            [cache setDate_placed_epoch:_date_placed_epoch];
            [cache setUrl:_url];
            [cache setCache_type_int:_cache_type];
            [cache setGc_country:_country];
            [cache setGc_state:_state];
            [cache setGc_rating_difficulty:_ratingD];
            [cache setGc_rating_terrain:_ratingT];
            [cache setGc_favourites:_favourites];
            [cache setGc_long_desc_html:_gc_long_desc_html];
            [cache setGc_long_desc:_gc_long_desc];
            [cache setGc_short_desc_html:_gc_short_desc_html];
            [cache setGc_short_desc:_gc_short_desc];
            [cache setGc_hint:_gc_hint];
            [cache setGc_containerSize_int:_gc_container_size];
            [cache setGc_archived:_gc_archived];
            [cache setGc_available:_gc_available];
            [cache setCache_symbol_int:_cache_symbol];
            [cache setGc_owner:_gc_owner];
            [cache setGc_placed_by:_gc_placed_by];

            [cache finish];
            [caches addObject:cache];
        }
        DB_FINISH;
    }

    return cache;
}

+ (NSId)dbCreate:(dbCache *)cache
{
    NSId __id = 0;

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"insert into caches(name, description, lat, lon, lat_int, lon_int, date_placed, date_placed_epoch, url, cache_type, gc_country, gc_state, gc_rating_difficulty, gc_rating_terrain, gc_favourites, gc_long_desc_html, gc_long_desc, gc_short_desc_html, gc_short_desc, gc_hint, gc_container_size_id, gc_archived, gc_available, cache_symbol, gc_owner, gc_placed_by) values(?, ?, ?, ?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

        SET_VAR_TEXT(req, 1, cache.name);
        SET_VAR_TEXT(req, 2, cache.description);
        SET_VAR_TEXT(req, 3, cache.lat);
        SET_VAR_TEXT(req, 4, cache.lon);
        SET_VAR_INT(req, 5, cache.lat_int);
        SET_VAR_INT(req, 6, cache.lon_int);
        SET_VAR_TEXT(req, 7, cache.date_placed);
        SET_VAR_INT(req, 8, cache.date_placed_epoch);
        SET_VAR_TEXT(req, 9, cache.url);
        SET_VAR_INT(req, 10, cache.cache_type_int);
        SET_VAR_TEXT(req, 11, cache.gc_country);
        SET_VAR_TEXT(req, 12, cache.gc_state);
        SET_VAR_DOUBLE(req, 13, cache.gc_rating_difficulty);
        SET_VAR_DOUBLE(req, 14, cache.gc_rating_terrain);
        SET_VAR_INT(req, 15, cache.gc_favourites);
        SET_VAR_BOOL(req, 16, cache.gc_long_desc_html);
        SET_VAR_TEXT(req, 17, cache.gc_long_desc);
        SET_VAR_BOOL(req, 18, cache.gc_short_desc_html);
        SET_VAR_TEXT(req, 19, cache.gc_short_desc);
        SET_VAR_TEXT(req, 20, cache.gc_hint);
        SET_VAR_INT(req, 21, cache.gc_containerSize_int);
        SET_VAR_BOOL(req, 22, cache.gc_archived);
        SET_VAR_BOOL(req, 23, cache.gc_available);
        SET_VAR_INT(req, 24, cache.cache_symbol_int);
        SET_VAR_TEXT(req, 25, cache.gc_owner);
        SET_VAR_TEXT(req, 26, cache.gc_placed_by);

        DB_CHECK_OKAY;
        DB_GET_LAST_ID(__id);
        DB_FINISH;
    }
    return __id;
}

- (void)dbUpdate
{
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"update caches set name = ?, description = ?, lat = ?, lon = ?, lat_int = ?, lon_int  = ?, date_placed = ?, date_placed_epoch = ?, url = ?, cache_type = ?, gc_country = ?, gc_state = ?, gc_rating_difficulty = ?, gc_rating_terrain = ?, gc_favourites = ?, gc_long_desc_html = ?, gc_long_desc = ?, gc_short_desc_html = ?, gc_short_desc = ?, gc_hint = ?, gc_container_size_id = ?, gc_archived = ?, gc_available = ?, cache_symbol = ?, gc_owner = ?, gc_placed_by = ? where id = ?");

        SET_VAR_TEXT(req, 1, name);
        SET_VAR_TEXT(req, 2, description);
        SET_VAR_TEXT(req, 3, lat);
        SET_VAR_TEXT(req, 4, lon);
        SET_VAR_INT(req, 5, lat_int);
        SET_VAR_INT(req, 6, lon_int);
        SET_VAR_TEXT(req, 7, date_placed);
        SET_VAR_INT(req, 8, date_placed_epoch);
        SET_VAR_TEXT(req, 9, url);
        SET_VAR_INT(req, 10, cache_type_int);
        SET_VAR_TEXT(req, 11, gc_country);
        SET_VAR_TEXT(req, 12, gc_state);
        SET_VAR_DOUBLE(req, 13, gc_rating_difficulty);
        SET_VAR_DOUBLE(req, 14, gc_rating_terrain);
        SET_VAR_INT(req, 15, gc_favourites);
        SET_VAR_BOOL(req, 16, gc_long_desc_html);
        SET_VAR_TEXT(req, 17, gc_long_desc);
        SET_VAR_BOOL(req, 18, gc_short_desc_html);
        SET_VAR_TEXT(req, 19, gc_short_desc);
        SET_VAR_TEXT(req, 20, gc_hint);
        SET_VAR_INT(req, 21, gc_containerSize_int);
        SET_VAR_BOOL(req, 22, gc_archived);
        SET_VAR_BOOL(req, 23, gc_available);
        SET_VAR_INT(req, 24, cache_symbol_int);
        SET_VAR_TEXT(req, 25, gc_owner);
        SET_VAR_TEXT(req, 26, gc_placed_by);
        SET_VAR_INT(req, 27, _id);

        DB_CHECK_OKAY;
        DB_FINISH;
    }
}

@end
