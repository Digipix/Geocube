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

@interface LiveAPI ()
{
    RemoteAPI *remoteAPI;
    NSString *liveAPIPrefix;

    NSMutableArray *GSLogTypesEvents;
    NSMutableArray *GSLogTypesOthers;
    NSMutableDictionary *GSLogTypes;

    id delegate;
}

@end

@implementation LiveAPI

@synthesize delegate;

- (instancetype)init:(RemoteAPI *)_remoteAPI
{
    self = [super init];

    remoteAPI = _remoteAPI;
    liveAPIPrefix = @"https://api.groundspeak.com/LiveV6/geocaching.svc/";

    GSLogTypesEvents = nil;
    GSLogTypesOthers = nil;

    return self;
}

- (NSArray *)logtypes:(NSString *)waypointType
{

    if (GSLogTypesEvents == nil)
        [self GetGeocacheDataTypes];

    if ([waypointType isEqualToString:@"event"] == YES) {
        NSMutableArray *rs = [NSMutableArray arrayWithCapacity:20];
        [GSLogTypesEvents enumerateObjectsUsingBlock:^(NSNumber *num1, NSUInteger idx, BOOL *stop) {
            [[GSLogTypes allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                if ([[GSLogTypes objectForKey:key] integerValue] == [num1 integerValue]) {
                    [rs addObject:key];
                    *stop = YES;
                }
            }];
        }];
        return rs;
    }

    NSMutableArray *rs = [NSMutableArray arrayWithCapacity:20];
    [GSLogTypesOthers enumerateObjectsUsingBlock:^(NSNumber *num1, NSUInteger idx, BOOL *stop) {
        [[GSLogTypes allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            if ([[GSLogTypes objectForKey:key] integerValue] == [num1 integerValue]) {
                [rs addObject:key];
                *stop = YES;
            }
        }];
    }];
    return rs;
}

- (GCMutableURLRequest *)prepareURLRequest:(NSString *)url parameters:(NSString *)parameters
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", liveAPIPrefix, url];
    if (parameters != nil) {
        [urlString appendFormat:@"?format=json&%@", parameters];
    } else {
        [urlString appendString:@"?format=json"];
    }

    NSURL *urlURL = [NSURL URLWithString:urlString];
    GCMutableURLRequest *urlRequest = [GCMutableURLRequest requestWithURL:urlURL];

    [urlRequest setValue:@"none" forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    return urlRequest;
}

- (GCMutableURLRequest *)prepareURLRequest:(NSString *)url
{
    return [self prepareURLRequest:url parameters:nil];
}

- (GCMutableURLRequest *)prepareURLRequest:(NSString *)url method:(NSString *)method
{
    GCMutableURLRequest *req = [self prepareURLRequest:url parameters:nil];
    [req setHTTPMethod:method];
    return req;
}

- (NSDictionary *)GetYourUserProfile
{
    NSLog(@"GetYourUserProfile");

    GCMutableURLRequest *urlRequest = [self prepareURLRequest:@"GetYourUserProfile" method:@"POST"];

    /*
     * {
     *    "AccessToken": "D7dYifnoQrG6QrbpHlTFOuW/BI0=",
     *    "DeviceInfo": {
     *        "ApplicationSoftwareVersion": "4.98.2",
     *        "DeviceOperatingSystem": "10.10.5",
     *        "DeviceUniqueId": "8141B980-CF1B-491B-9247-18AB78A3A8B1"
     *    },
     *    "ProfileOptions": {
     *        "FavoritePointsData": "true",
     *        "PublicProfileData": "true"
     *    }
     * }
     */
    NSString *_body = [NSString stringWithFormat:@"{\"AccessToken\":\"%@\",\"ProfileOptions\":{\"PublicProfileData\":\"true\",\"EmailData\":\"true\"},\"DeviceInfo\":{ \"ApplicationSoftwareVersion\":\"1.2.3.4\",\"DeviceOperatingSystem\":\"2.3.4.5\",\"DeviceUniqueId\":\"42\"}}", remoteAPI.oabb.token];
    urlRequest.HTTPBody = [_body dataUsingEncoding:NSUTF8StringEncoding];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *retbody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"error: %@", [error description]);
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"retbody: %@", retbody);

    if (error != nil || response.statusCode != 200)
        return nil;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}

- (NSDictionary *)GetCacheIdsFavoritedByUser
{
    NSLog(@"GetCacheIdsFavoritedByUser");

    GCMutableURLRequest *urlRequest = [self prepareURLRequest:@"GetCacheIdsFavoritedByUser" parameters:[NSString stringWithFormat:@"accessToken=%@", [MyTools urlEncode:remoteAPI.oabb.token]]];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *retbody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"error: %@", [error description]);
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"retbody: %@", retbody);

    if (error != nil || response.statusCode != 200)
        return nil;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}

- (NSDictionary *)GetGeocacheDataTypes
{
    NSLog(@"GetGeocacheDataTypes");

    GCMutableURLRequest *urlRequest = [self prepareURLRequest:@"GetGeocacheDataTypes" parameters:[NSString stringWithFormat:@"accessToken=%@&logTypes=true", [MyTools urlEncode:remoteAPI.oabb.token]]];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *retbody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"error: %@", [error description]);
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"retbody: %@", retbody);

    if (error != nil || response.statusCode != 200)
        return nil;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    /* Get the following:
     * For events: Write note, Will Attend, Attended, Announcement
     * For waypoints: Found it, Didn't find it, Write note, Needs Archived, Temporary Disable Listing, Enable Listing,
     *                Needs Maintenance, Owner Maintenance, Update Coordinates
     * For trackable: Write note, Dropped Off, Retrieved It from a Cache, Discovered It
     */

    GSLogTypesEvents = [NSMutableArray arrayWithCapacity:20];
    GSLogTypesOthers = [NSMutableArray arrayWithCapacity:20];
    GSLogTypes = [NSMutableDictionary dictionaryWithCapacity:20];

    [[json valueForKey:@"EventLogTypeIds"] enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        [GSLogTypesEvents addObject:num];
    }];
    [[json valueForKey:@"GeocacheLogTypeIds"] enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        [GSLogTypesOthers addObject:num];
    }];

    NSArray *d = [json objectForKey:@"WptLogTypes"];
    if (d == nil)
        return nil;

    [d enumerateObjectsUsingBlock:^(NSDictionary *gslt, NSUInteger idx, BOOL *stop) {
        if ([[gslt objectForKey:@"AdminActionable"] boolValue] == YES && [[gslt objectForKey:@"OwnerActionable"] boolValue] == NO)
            return;
        [GSLogTypes setValue:[NSNumber numberWithInteger:[[gslt objectForKey:@"WptLogTypeId"] integerValue]] forKey:[gslt objectForKey:@"WptLogTypeName"]];
    }];

    return json;
}

- (NSInteger)CreateFieldNoteAndPublish:(NSString *)logtype waypointName:(NSString *)waypointName dateLogged:(NSString *)dateLogged note:(NSString *)note favourite:(BOOL)favourite
{
    NSLog(@"CreateFieldNoteAndPublish");

    GCMutableURLRequest *urlRequest = [self prepareURLRequest:@"CreateFieldNoteAndPublish" method:@"POST"];

    /*
     * {
     *      "AccessToken":"String content",
     *      "CacheCode":"String content",
     *      "WptLogTypeId":9223372036854775807,
     *      "UTCDateLogged":"\/Date(928174800000-0700)\/",
     *      "Note":"String content",
     *      "PromoteToLog":true,
     *      "ImageData":{
     *              "FileCaption":"String content",
     *              "FileDescription":"String content",
     *              "FileName":"String content",
     *              "base64ImageData":"String content"
     *      },
     *      "FavoriteThisCache":true,
     *      "EncryptLogText":true,
     *      "UpdatedLatitude":1.26743233E+15,
     *      "UpdatedLongitude":1.26743233E+15
     * }
     */
    NSInteger gslogtype;
    NSTimeInterval date;

    if (GSLogTypesEvents == nil)
        [self GetGeocacheDataTypes];

    gslogtype = [[GSLogTypes objectForKey:logtype] integerValue];

    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"YYYY-MM-dd"];
    NSDate *todayDate = [dateF dateFromString:dateLogged];
    date = [todayDate timeIntervalSince1970];

    NSString *_body = [NSString stringWithFormat:@"{\"AccessToken\":\"%@\",\"CacheCode\":\"%@\",\"WptLogTypeId\":%ld,\"UTCDateLogged\":\"/Date(%ld000)/\",\"Note\":\"%@\",\"PromoteToLog\":true,\"FavoriteThisCache\":%@,\"EncryptLogText\":false}", remoteAPI.oabb.token, waypointName, (long)gslogtype, (long)date, [MyTools JSONEscape:note], (favourite == YES) ? @"true" : @"false"];
    urlRequest.HTTPBody = [_body dataUsingEncoding:NSUTF8StringEncoding];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *retbody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"error: %@", [error description]);
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"retbody: %@", retbody);

    if (error != nil || response.statusCode != 200)
        return 0;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    NSDictionary *log = [json objectForKey:@"Log"];
    NSNumber *log_id = [log objectForKey:@"ID"];
    return [log_id integerValue];
}

- (NSDictionary *)SearchForGeocaches:(NSString *)wpname
{
    NSLog(@"SearchForGeocaches");

    GCMutableURLRequest *urlRequest = [self prepareURLRequest:@"SearchForGeocaches" method:@"POST"];

    /*
     * {
     *  "AccessToken": "SUJK5WNyq865waiqrZrfjSfO0XU=",
     *  "CacheCode": {
     *      "CacheCodes": [
     *          "GC3NZDM"
     *      ]
     *      },
     *      "GeocacheLogCount": 20,
     *      "IsLite": false,
     *      "MaxPerPage": 20,
     *      "TrackableLogCount": 1
     *  }
     */
    NSString *_body = [NSString stringWithFormat:@"{\"AccessToken\":\"%@\",\"CacheCode\":{\"CacheCodes\":[\"%@\"]},\"GeocacheLogCount\":20,\"IsLite\":false,\"MaxPerPage\":20,\"TrackableLogCount\":1}", remoteAPI.oabb.token, wpname];
    urlRequest.HTTPBody = [_body dataUsingEncoding:NSUTF8StringEncoding];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *retbody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"error: %@", [error description]);
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"retbody: %@", retbody);

    if (error != nil || response.statusCode != 200)
        return nil;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}

@end
