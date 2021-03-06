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

@interface MapViewController : GCViewController <LocationManagerDelegate, WaypointManagerDelegate>

enum {
    SHOW_ONEWAYPOINT = 1,
    SHOW_ALLWAYPOINTS,

    SHOW_NEITHER = 0,
    SHOW_SEETARGET,
    SHOW_FOLLOWME,
    SHOW_FOLLOWMEZOOM,
    SHOW_SHOWBOTH,

    MAPTYPE_NORMAL = 0,
    MAPTYPE_SATELLITE,
    MAPTYPE_HYBRID,
    MAPTYPE_TERRAIN,

    MAPBRAND_GOOGLEMAPS = 0,
    MAPBRAND_APPLEMAPS,
    MAPBRAND_OPENSTREETMAPS,
};

@property (nonatomic, retain) NSArray *waypointsArray;

- (instancetype)init:(NSInteger)maptype;
- (void)userInteraction;
- (void)refreshWaypointsData;
- (void)addNewWaypoint:(CLLocationCoordinate2D)coords;

@end