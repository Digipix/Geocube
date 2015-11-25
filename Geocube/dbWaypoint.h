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

@interface dbWaypoint : dbObject

enum {
        LOGSTATUS_NOTLOGGED,
        LOGSTATUS_NOTFOUND,
        LOGSTATUS_FOUND,
};

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *urlname;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lon;
@property (nonatomic) NSInteger lat_int;
@property (nonatomic) NSInteger lon_int;
@property (nonatomic) float lat_float;
@property (nonatomic) float lon_float;
@property (nonatomic, retain) NSString *date_placed;
@property (nonatomic) NSInteger date_placed_epoch;
@property (nonatomic) NSId symbol_id;
@property (nonatomic, retain) NSString *symbol_str;
@property (nonatomic, retain) dbSymbol *symbol;
@property (nonatomic) NSId type_id;
@property (nonatomic, retain) NSString *type_str;
@property (nonatomic, retain) dbType *type;

@property (nonatomic) NSInteger logStatus;
@property (nonatomic) BOOL highlight;
@property (nonatomic) BOOL ignore;
@property (nonatomic) NSId account_id;
@property (nonatomic, retain) dbAccount *account;

@property (nonatomic) BOOL gs_hasdata;
@property (nonatomic) float gs_rating_difficulty;
@property (nonatomic) float gs_rating_terrain;
@property (nonatomic) NSInteger gs_favourites;
@property (nonatomic) NSId gs_country_id;
@property (nonatomic, retain) NSString *gs_country_str;
@property (nonatomic, retain) dbCountry *gs_country;
@property (nonatomic) NSId gs_state_id;
@property (nonatomic, retain) NSString *gs_state_str;
@property (nonatomic, retain) dbState *gs_state;
@property (nonatomic) BOOL gs_short_desc_html;
@property (nonatomic, retain) NSString *gs_short_desc;
@property (nonatomic) BOOL gs_long_desc_html;
@property (nonatomic, retain) NSString *gs_long_desc;
@property (nonatomic, retain) NSString *gs_hint;
@property (nonatomic) NSId gs_container_id;
@property (nonatomic, retain) NSString *gs_container_str;
@property (nonatomic, retain) dbContainer *gs_container;
@property (nonatomic) BOOL gs_archived;
@property (nonatomic) BOOL gs_available;
@property (nonatomic, retain) NSString *gs_placed_by;
@property (nonatomic, retain) NSString *gs_owner_str;
@property (nonatomic, retain) NSString *gs_owner_gsid;
@property (nonatomic) NSId gs_owner_id;
@property (nonatomic, retain) dbName *gs_owner;

@property (nonatomic) NSInteger calculatedDistance;
@property (nonatomic) NSInteger calculatedBearing;
@property (nonatomic) CLLocationCoordinate2D coordinates;

- (instancetype)init:(NSId)_id;
- (NSInteger)hasFieldNotes;
- (NSInteger)hasLogs;
- (NSInteger)hasAttributes;
- (NSArray *)hasWaypoints;
- (NSInteger)hasInventory;
- (NSInteger)hasImages;

+ (NSId)dbGetByName:(NSString *)name;
+ (void)dbCreate:(dbWaypoint *)wp;
- (void)dbUpdate;
+ (NSArray *)dbAll;
+ (NSArray *)dbAllFound;
+ (NSArray *)dbAllAttended;
+ (NSArray *)dbAllNotFound;
+ (NSArray *)dbAllIgnored;
+ (NSArray *)dbAllInGroups:(NSArray *)groups;
+ (dbWaypoint *)dbGet:(NSId)id;
+ (void)dbUpdateLogStatus;
- (void)dbUpdateHighlight;
- (void)dbUpdateIgnore;
+ (NSString *)makeName:(NSString *)suffix;
+ (NSArray *)waypointsWithImages;
+ (NSArray *)waypointsWithLogs;
+ (NSArray *)waypointsWithMyLogs;

@end
