//
//  dbObjectWaypoint.m
//  Geocube
//
//  Created by Edwin Groothuis on 28/06/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

#import "dbObjectWaypoint.h"

@implementation dbObjectWaypoint

@synthesize _id, name, description, url, lat, lon, lat_int, lon_int, date_placed, date_placed_epoch, wp_type_int, wp_type;

- (id)init:(NSInteger)__id
{
    _id = __id;
    return self;
}

@end
