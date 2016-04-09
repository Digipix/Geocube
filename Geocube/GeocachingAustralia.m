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

@interface GeocachingAustralia ()
{
    RemoteAPI *remoteAPI;
    id delegate;
    NSHTTPCookie *authCookie;
    NSString *callback;

    NSMutableDictionary *logtypes;
}

@end

@implementation GeocachingAustralia

@synthesize delegate, callback;

- (instancetype)init:(RemoteAPI *)_remoteAPI
{
    self = [super init];

    remoteAPI = _remoteAPI;
    callback = remoteAPI.account.gca_callback_url;
    if (remoteAPI.account.gca_cookie_value != nil) {
        authCookie = [NSHTTPCookie cookieWithProperties:
                      [NSDictionary
                           dictionaryWithObjects:@[
                               @"/",
                               remoteAPI.account.gca_cookie_name,
                               [MyTools urlEncode:remoteAPI.account.gca_cookie_value],
                               @".geocaching.com.au" //remoteAPI.account.url_site
                           ] forKeys:@[
                               NSHTTPCookiePath,
                               NSHTTPCookieName,
                               NSHTTPCookieValue,
                               NSHTTPCookieDomain
                           ]
                   ]
                  ];
        // Set-Cookie: phpbb3mysql_data=a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A34%3A%22%24H%249bhZ2qUoKtqdqSSeZZvlBdDXIAiGbi.%22%3Bs%3A6%3A%22userid%22%3Bs%3A6%3A%22119649%22%3B%7D; expires=Mon, 28-Sep-2015 13:36:09 GMT; path=/; domain=.geocaching.com.au.
        NSHTTPCookieStorage *cookiemgr = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookiemgr setCookie:authCookie];
    }

    logtypes = [NSMutableDictionary dictionaryWithCapacity:20];
    [logtypes setObject:@"F" forKey:@"Found it"];
    [logtypes setObject:@"D" forKey:@"Did not find it"];
    [logtypes setObject:@"N" forKey:@"Noted"];
    [logtypes setObject:@"E" forKey:@"Needs archiving"];
    [logtypes setObject:@"M" forKey:@"Needs maintenance"];
    [logtypes setObject:@"C" forKey:@"Maintained"];
    [logtypes setObject:@"B" forKey:@"Published"];
    [logtypes setObject:@"I" forKey:@"Disabled"];
    [logtypes setObject:@"L" forKey:@"Enabled"];
    [logtypes setObject:@"V" forKey:@"Archived"];
    [logtypes setObject:@"U" forKey:@"Unarchived"];

    return self;
}

- (BOOL)commentSupportsFavouritePoint
{
    return NO;
}
- (BOOL)commentSupportsPhotos
{
    return YES;
}
- (BOOL)commentSupportsRating
{
    return YES;
}
- (BOOL)commentSupportsTrackables
{
    return NO;
}
- (BOOL)waypointSupportsPersonalNotes
{
    return NO;
}

- (NSArray *)logtypes:(NSString *)waypointType
{
    return [logtypes allKeys];
}

- (void)storeCookie:(NSHTTPCookie *)cookie
{
    if (delegate != nil)
        [delegate GCAAuthSuccessful:cookie];
}

- (NSArray *)loadPage:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    GCURLRequest *req = [GCURLRequest requestWithURL:url];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [MyTools sendSynchronousRequest:req returningResponse:&response error:&error];

    if (response.statusCode == 403) {   // Forbidden
        remoteAPI.account.gca_cookie_value = @"";
        [remoteAPI.account dbUpdateCookieValue];
        return nil;
    }

    if (data == nil || response.statusCode != 200)
        return nil;

    NSArray *lines = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    return lines;
}

- (NSArray *)postPageForm:(NSString *)baseUrl params:(NSDictionary *)params
{
    NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];

    NSMutableString *ps = [NSMutableString stringWithString:@""];
    [[params allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([ps isEqualToString:@""] == NO)
            [ps appendString:@"&"];
        [ps appendFormat:@"%@=%@", [MyTools urlEncode:key], [MyTools urlEncode:[params valueForKey:key]]];
    }];

    NSURL *url = [NSURL URLWithString:urlString];
    GCMutableURLRequest *req = [GCMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    req.HTTPBody = [ps dataUsingEncoding:NSUTF8StringEncoding];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [MyTools sendSynchronousRequest:req returningResponse:&response error:&error];

    if (data == nil || response.statusCode != 200)
        return nil;

    NSArray *lines = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    return lines;
}

- (NSArray *)postPageMultiForm:(NSString *)baseUrl dataField:(NSString *)dataField params:(NSDictionary *)params
{
    NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];

    NSURL *url = [NSURL URLWithString:urlString];
    GCMutableURLRequest *req = [GCMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    NSString *boundary = @"YOUR_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [req addValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];

    [[params allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([key isEqualToString:dataField] == YES) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"photo.jpg\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:[params objectForKey:key]]];

            return;
        }

        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, [params objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [req setHTTPBody:body];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [MyTools sendSynchronousRequest:req returningResponse:&response error:&error];

    if (data == nil || response.statusCode != 200)
        return nil;

    NSArray *lines = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    return lines;
}

- (NSString *)FindValueInLine:(NSArray *)lines key:(NSString *)key
{
    __block BOOL found = NO;
    __block NSString *value = nil;

    [lines enumerateObjectsUsingBlock:^(NSString *l, NSUInteger idx, BOOL *stop) {
        if (found == YES) {
            // <div class='floater60'><b>49</b> </div>
            value = [MyTools stripHTML:l];
            *stop = YES;
            return;
        }

        // <div class='floater40'>Geocaching Australia Finds</div>
        NSRange r = [l rangeOfString:key];
        if (r.location == NSNotFound)
            return;
        found = YES;
    }];

    return value;
}

// ------------------------------------------------

- (GCDictionaryGCA *)my_query_list__json
{
    NSLog(@"my_query_list__json");

    NSString *urlString = @"http://geocaching.com.au/my/query/list.json";
    NSArray *lines = [self loadPage:urlString];
    NSString *S = [lines componentsJoinedByString:@""];
    NSData *data = [S dataUsingEncoding:NSUTF8StringEncoding];

    if (data == nil) {
        NSLog(@"%@ - No data returned", [self class]);
        return nil;
    }

    NSError *error = nil;
    GCDictionaryGCA *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    return json;
}

- (NSArray *)my_query
{
    NSLog(@"my_query");
    // Obsolete, do not use aymore

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/my/query"];
    NSArray *lines = [self loadPage:urlString];

    NSError *e;
    NSRegularExpression *r1 = [NSRegularExpression regularExpressionWithPattern:@"<td.*queryid='(\\d+)'>(.*?)</td>" options:0 error:&e];
    NSRegularExpression *r2 = [NSRegularExpression regularExpressionWithPattern:@"Number of matching caches: (\\d+)"options:0 error:&e];

    NSMutableArray *as = [NSMutableArray arrayWithCapacity:20];

    [lines enumerateObjectsUsingBlock:^(NSString *l, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *matches = [r1 matchesInString:l options:0 range:NSMakeRange(0, [l length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange rangeId = [match rangeAtIndex:1];
            NSRange rangeName = [match rangeAtIndex:2];

            NSString *_id = [l substringWithRange:rangeId];
            NSString *name = [l substringWithRange:rangeName];

            __block NSString *count = nil;

            NSLog(@"%@ - %@", _id, name);

            NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/my/query/count/%@", _id];
            NSArray *lines = [self loadPage:urlString];
            [lines enumerateObjectsUsingBlock:^(NSString *l, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *matches = [r2 matchesInString:l options:0 range:NSMakeRange(0, [l length])];
                for (NSTextCheckingResult *match in matches) {
                    NSRange countRange = [match rangeAtIndex:1];
                    count = [l substringWithRange:countRange];
                }
            }];

            NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:2];
            [d setObject:_id forKey:@"Id"];
            [d setObject:name forKey:@"Name"];
            if (count != nil)
                [d setObject:count forKey:@"Count"];
            [as addObject:d];
        }
    }];

    return as;
}

- (GCDictionaryGCA *)cacher_statistic__finds:(NSString *)name
{
    NSLog(@"cacher_statistics__finds");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/cacher/statistics/%@/finds/", [MyTools urlEncode:name]];
    NSArray *lines = [self loadPage:urlString];
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:1];

    NSString *value = [self FindValueInLine:lines key:@"Geocaching Australia Finds"];
    if (value != nil)
        [ret setValue:value forKey:@"waypoints_found"];

    return [[GCDictionaryGCA alloc] initWithDictionary:ret];
}

- (GCDictionaryGCA *)cacher_statistic__hides:(NSString *)name
{
    NSLog(@"cacher_statistics__hides");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/cacher/statistics/%@/hides/", [MyTools urlEncode:name]];
    NSArray *lines = [self loadPage:urlString];
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:1];

    NSString *value = [self FindValueInLine:lines key:@"Total Geocaching Australia Hides"];
    if (value != nil)
        [ret setValue:value forKey:@"waypoints_hidden"];

    value = [self FindValueInLine:lines key:@"Recommendations on Caches Hidden"];
    if (value != nil)
        [ret setValue:value forKey:@"recommendations_received"];

    value = [self FindValueInLine:lines key:@"Recommendations Caches Hidden"];
    if (value != nil)
        [ret setValue:value forKey:@"recommendations_given"];

    return [[GCDictionaryGCA alloc] initWithDictionary:ret];
}

- (GCStringGPX *)cache__gpx:(NSString *)wpname
{
    NSLog(@"cache__gpx");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/cache/%@.gpx", [MyTools urlEncode:wpname]];
    NSArray *lines = [self loadPage:urlString];
    return [GCStringGPX stringWithString:[lines componentsJoinedByString:@""]];
}

- (GCDictionaryGCA *)cache__json:(NSString *)wpname
{
    NSLog(@"cache__json");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/cache/%@.json", [MyTools urlEncode:wpname]];
    NSArray *lines = [self loadPage:urlString];
    NSString *S = [lines componentsJoinedByString:@""];
    NSData *data = [S dataUsingEncoding:NSUTF8StringEncoding];

    if (data == nil) {
        NSLog(@"%@ - No data returned", [self class]);
        return nil;
    }

    NSError *error = nil;
    GCDictionaryGCA *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    return [[GCDictionaryGCA alloc] initWithDictionary:json];
}

- (NSInteger)my_log_new:(NSString *)logtype waypointName:(NSString *)wpname dateLogged:(NSString *)dateLogged note:(NSString *)note favourite:(BOOL)favourite
{
    NSLog(@"my_log_new");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/my/log/new/%@", [MyTools urlEncode:wpname]];

    NSMutableDictionary *ps = [NSMutableDictionary dictionaryWithCapacity:5];
    [logtypes enumerateKeysAndObjectsUsingBlock:^(NSString *lt, NSString *value, BOOL *stop) {
        if ([lt isEqualToString:logtype] == YES) {
            [ps setValue:value forKey:@"action"];
            *stop = YES;
        }
    }];
    [ps setValue:note forKey:@"text"];

    if (favourite == YES)
        [ps setValue:@"5" forKey:@"Overall Experience"];
    else
        [ps setValue:@"2" forKey:@"Overall Experience"];

    [ps setValue:[dateLogged substringWithRange:NSMakeRange(0, 4)] forKey:@"gca_date_selector_year"];
    [ps setValue:[dateLogged substringWithRange:NSMakeRange(5, 2)] forKey:@"gca_date_selector_month"];
    [ps setValue:[dateLogged substringWithRange:NSMakeRange(8, 2)] forKey:@"gca_date_selector_day"];

    [ps setValue:@"" forKey:@"coords"];
    [ps setValue:@"" forKey:@"hints"];
    [ps setValue:@"" forKey:@"public_tags"];
    [ps setValue:@"" forKey:@"private_tags"];
    [ps setValue:@"" forKey:@"cacher"];
    [ps setValue:@"Log" forKey:@"button"];

    NSArray *lines = [self postPageForm:urlString params:ps];

    __block BOOL found = NO;
    [lines enumerateObjectsUsingBlock:^(NSString *l, NSUInteger idx, BOOL *stop) {
        NSRange r = [l rangeOfString:@"Log added"];
        if (r.location == NSNotFound)
            return;
        found = YES;
    }];
    if (found == NO)
        return 0;
    return -1;
}

- (NSInteger)my_gallery_cache_add:(NSString *)wpname data:(NSData *)data caption:(NSString *)caption description:(NSString *)description
{
    NSLog(@"my_gallery_cache_add");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/my/gallery/cache/add/%@", [MyTools urlEncode:wpname]];

    NSMutableDictionary *ps = [NSMutableDictionary dictionaryWithCapacity:5];
    [ps setValue:data forKey:@"uploaded"];
    [ps setValue:wpname forKey:@"cache"];
    [ps setValue:caption forKey:@"caption"];
    [ps setValue:@"" forKey:@"cacher"];
    [ps setValue:description forKey:@"description"];
    [ps setValue:@"" forKey:@"log_number"];
    [ps setValue:@"" forKey:@"swaggie"];
    [ps setValue:@"Save Image" forKey:@"button"];

    [self postPageMultiForm:urlString dataField:@"uploaded" params:ps];
    return -1;
}

- (GCDictionaryGCA *)caches_gca:(CLLocationCoordinate2D)center
{
    NSLog(@"caches_gca");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/caches/gca.json?center=%f,%f&cacher=no&limit=%ld", center.latitude, center.longitude, (long)myConfig.mapSearchMaximumNumberGCA];

    NSArray *lines = [self loadPage:urlString];
    NSString *S = [lines componentsJoinedByString:@""];
    NSData *data = [S dataUsingEncoding:NSUTF8StringEncoding];

    if (data == nil) {
        NSLog(@"%@ - No data returned", [self class]);
        return nil;
    }

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    GCDictionaryGCA *gcajson = [[GCDictionaryGCA alloc] initWithDictionary:json];

    return gcajson;
}

- (GCDictionaryGCA *)logs_cache:(NSString *)wpname
{
    NSLog(@"logs_cache");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/logs/cache/%@.json", wpname];

    NSArray *lines = [self loadPage:urlString];
    NSString *S = [lines componentsJoinedByString:@""];
    NSData *data = [S dataUsingEncoding:NSUTF8StringEncoding];

    if (data == nil) {
        NSLog(@"%@ - No data returned", [self class]);
        return nil;
    }

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return [[GCDictionaryGCA alloc] initWithDictionary:json];
}

- (GCDictionaryGCA *)my_query_json:(NSString *)queryname
{
    NSLog(@"my_query_json");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/my/query/json/%@", queryname];

    NSArray *lines = [self loadPage:urlString];
    NSString *S = [lines componentsJoinedByString:@""];
    NSData *data = [S dataUsingEncoding:NSUTF8StringEncoding];

    if (data == nil) {
        NSLog(@"%@ - No data returned", [self class]);
        return nil;
    }

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    return [[GCDictionaryGCA alloc] initWithDictionary:json];
}

- (GCStringGPX *)my_query_gpx:(NSString *)queryname
{
    NSLog(@"my_query_gpx");

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/my/query/gpx/%@", queryname];

    NSArray *lines = [self loadPage:urlString];
    return [GCStringGPX stringWithString:[lines componentsJoinedByString:@""]];
}

- (NSInteger)my_query_count:(NSString *)queryname
{
    NSLog(@"my_query_count:%@", queryname);

    __block NSInteger ret = -1;

    NSString *urlString = [NSString stringWithFormat:@"http://geocaching.com.au/my/query/count/%@", queryname];

    NSArray *lines = [self loadPage:urlString];

    NSError *e = nil;
    NSRegularExpression *r = [NSRegularExpression regularExpressionWithPattern:@"Number of matching caches: (\\d+)"options:0 error:&e];

    [lines enumerateObjectsUsingBlock:^(NSString *l, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *matches = [r matchesInString:l options:0 range:NSMakeRange(0, [l length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange countRange = [match rangeAtIndex:1];
            ret = [[l substringWithRange:countRange] integerValue];
            *stop = YES;
        }
    }];

    return ret;
}

@end
