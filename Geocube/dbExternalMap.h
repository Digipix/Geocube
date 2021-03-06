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

@interface dbExternalMap : dbObject

@property (nonatomic) NSInteger geocube_id;
@property (nonatomic) BOOL enabled;
@property (nonatomic, retain) NSString *name;

+ (dbExternalMap *)dbGetByGeocubeID:(NSId)geocube_id;

@end

@interface dbExternalMapURL : dbObject

@property (nonatomic) NSId externalMap_id;
@property (nonatomic, retain) dbExternalMap *externalMap;
@property (nonatomic, retain) NSString *model;
@property (nonatomic) NSInteger type;
@property (nonatomic, retain) NSString *url;

+ (NSArray *)dbAllByExternalMap:(NSId)map_id;
+ (void)dbDeleteByExternalMap:(NSId)map_id;

@end
