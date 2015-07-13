//
//  dbWaypoint.m
//  Geocube
//
//  Created by Edwin Groothuis on 28/06/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

#import "Geocube-Prefix.pch"

@implementation dbCache

@synthesize _id, name, description, url, lat, lon, lat_int, lon_int, lat_float, lon_float, date_placed, date_placed_epoch, gc_rating_difficulty, gc_rating_terrain, gc_favourites, cache_type_int, cache_type_str, cache_type, gc_country, gc_state, gc_short_desc_html, gc_short_desc, gc_long_desc_html, gc_long_desc, gc_hint, gc_personal_note, calculatedDistance, coordinates, gc_containerSize, gc_containerSize_str, gc_containerSize_int, gc_archived, gc_available;

- (id)init:(NSInteger)__id
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

    coordinates = MKCoordinates([lat floatValue], [lon floatValue]);
    
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
    
    [super finish];
}

- (NSInteger)hasLogs {
    return [db Logs_count_byCache_id:_id];
}

- (NSInteger)hasAttributes {
    return [db Attributes_count_byCache_id:_id];
}

- (BOOL)hasFieldNotes { return NO; }
- (BOOL)hasWaypoints { return NO; }
- (BOOL)hasInventory { return NO; }
- (BOOL)hasImages { return NO; }

@end
