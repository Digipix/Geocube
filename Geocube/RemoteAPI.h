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

enum {
    REMOTEAPI_OK = 0,
    REMOTEAPI_APIREFUSED,               // Couldn't connect to the API
    REMOTEAPI_APIFAILED,                // Invalid values returned
    REMOTEAPI_APIDISABLED,              // No authentication details

    REMOTEAPI_NOTPROCESSED,             // Not supported in this protocol

    REMOTEAPI_CREATELOG_LOGFAILED,      // Unable to create the log
    REMOTEAPI_CREATELOG_IMAGEFAILED,    // Unable to upload the image
    REMOTEAPI_LOADWAYPOINT_LOADFAILED,  // Unable to load the waypoint
    REMOTEAPI_LOADWAYPOINTS_LOADFAILED, // Unable to load the waypoints
    REMOTEAPI_LISTQUERIES_LOADFAILED,   // Unable to load the list of queries
};

@protocol RemoteAPIAuthenticationDelegate

- (void)remoteAPI:(RemoteAPI *)api failure:(NSString *)failure error:(NSError *)error;
- (void)remoteAPI:(RemoteAPI *)api success:(NSString *)success;

@end

@interface RemoteAPI : NSObject <GCOAuthBlackboxDelegate, RemoteAPI_GCADelegate>

@property (nonatomic, retain) dbAccount *account;
@property (nonatomic, retain) GCOAuthBlackbox *oabb;
@property (nonatomic) NSInteger stats_found, stats_notfound;
@property (nonatomic) id<RemoteAPIAuthenticationDelegate> authenticationDelegate;

@property (nonatomic, retain) NSString *errorMsg;
@property (nonatomic, retain) NSError *error;
@property (nonatomic) NSInteger errorCode;

- (instancetype)init:(dbAccount *)account;
- (BOOL)Authenticate;
- (BOOL)waypointSupportsPersonalNotes;
- (BOOL)commentSupportsPhotos;
- (BOOL)commentSupportsTrackables;
- (BOOL)commentSupportsFavouritePoint;
- (BOOL)commentSupportsRating;
- (NSRange)commentSupportsRatingRange;

- (NSInteger)UserStatistics:(NSDictionary **)retDict;

- (NSInteger)CreateLogNote:(dbLogString *)logstring waypoint:(dbWaypoint *)waypoint dateLogged:(NSString *)dateLogged note:(NSString *)note favourite:(BOOL)favourite image:(dbImage *)image imageCaption:(NSString *)imageCaption imageDescription:(NSString *)imageDescription rating:(NSInteger)rating trackables:(NSArray *)trackables;

- (NSInteger)loadWaypoint:(dbWaypoint *)waypoint;
- (NSInteger)loadWaypoints:(CLLocationCoordinate2D)center retObj:(NSObject **)retObj;

- (NSInteger)updatePersonalNote:(dbPersonalNote *)note;

- (NSInteger)listQueries:(NSArray **)qs;
- (NSInteger)retrieveQuery:(NSString *)_id group:(dbGroup *)group retObj:(NSObject **)retObj;
- (NSInteger)retrieveQuery_forcegpx:(NSString *)_id group:(dbGroup *)group retObj:(NSObject **)retObj;

- (void)trackablesMine;
- (void)trackablesInventory;
- (dbTrackable *)trackableFind:(NSString *)code;

@end
