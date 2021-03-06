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

@interface ImportGeocube : ImportTemplate

#define KEY_REVISION_ATTRIBUTES     @"attributes_revision"
#define KEY_REVISION_BOOKMARKS      @"bookmarks_revision"
#define KEY_REVISION_CONFIG         @"config_revision"
#define KEY_REVISION_CONTAINERS     @"containers_revision"
#define KEY_REVISION_COUNTRIES      @"countries_revision"
#define KEY_REVISION_EXTERNALMAPS   @"externalmaps_revision"
#define KEY_REVISION_KEYS           @"keys_revision"
#define KEY_REVISION_LOGSTRINGS     @"logstrings_revision"
#define KEY_REVISION_NOTICES        @"notices_revision"
#define KEY_REVISION_PINS           @"pins_revision"
#define KEY_REVISION_SITES          @"sites_revision"
#define KEY_REVISION_STATES         @"states_revision"
#define KEY_REVISION_TYPES          @"types_revision"

+ (BOOL)parse:(NSData *)data;

@end
