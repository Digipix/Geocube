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

@implementation ImageLibrary

- (instancetype)init
{
    self = [super init];
    NSLog(@"ImageLibrary: %d elements", ImageLibraryImagesMax);

    [self add:@"cache - benchmark - 30x30" index:ImageTypes_Benchmark];
    [self add:@"cache - cito - 30x30" index:ImageTypes_CITO];
    [self add:@"cache - earth - 30x30" index:ImageTypes_EarthCache];
    [self add:@"cache - event - 30x30" index:ImageTypes_Event];
    [self add:@"cache - giga - 30x30" index:ImageTypes_Giga];
    [self add:@"cache - groundspeak hq - 30x30" index:ImageTypes_GroundspeakHQ];
    [self add:@"cache - letterbox - 30x30" index:ImageTypes_Letterbox];
    [self add:@"cache - maze - 30x30" index:ImageTypes_Maze];
    [self add:@"cache - mega - 30x30" index:ImageTypes_Mega];
    [self add:@"cache - multi - 30x30" index:ImageTypes_MultiCache];
    [self add:@"cache - mystery - 30x30" index:ImageTypes_Mystery];
    [self add:@"cache - unknown - 30x30" index:ImageTypes_Other];
    [self add:@"cache - traditional - 30x30" index:ImageTypes_TraditionalCache];
    [self add:@"cache - unknown - 30x30" index:ImageTypes_UnknownCache];
    [self add:@"cache - virtual - 30x30" index:ImageTypes_VirtualCache];
    [self add:@"cache - waymark - 30x30" index:ImageTypes_Waymark];
    [self add:@"cache - webcam - 30x30" index:ImageTypes_WebcamCache];
    [self add:@"cache - whereigo - 30x30" index:ImageTypes_WhereigoCache];

    [self add:@"waypoint - finish - 30x30" index:ImageWaypoints_FinalLocation];
    [self add:@"waypoint - flag - 30x30" index:ImageWaypoints_Flag];
    [self add:@"waypoint - multi - 30x30" index:ImageWaypoints_MultiStage];
    [self add:@"waypoint - parking - 30x30" index:ImageWaypoints_ParkingArea];
    [self add:@"waypoint - flag - 30x30" index:ImageWaypoints_PhysicalStage];
    [self add:@"waypoint - flag - 30x30" index:ImageWaypoints_ReferenceStage];
    //[self add:@"waypoint - question - 30x30" index:ImageWaypoints_QuestionStage];
    [self add:@"waypoint - trailhead - 30x30" index:ImageWaypoints_Trailhead];
    [self add:@"waypoint - trailhead - 30x30" index:ImageWaypoints_VirtualStage];

    [self add:@"cache - unknown - 30x30" index:ImageTypes_NFI];
    [self add:@"waypoint - unknown - 30x30" index:Imagewaypoints_NFI];
    [self add:@"cache - unknown - 30x30" index:ImageNFI];

    [self add:@"log - didnotfind - 30x30" index:ImageLog_DidNotFind];
    [self add:@"log - enabled - 30x30" index:ImageLog_Enabled];
    [self add:@"log - found - 30x30" index:ImageLog_Found];
    [self add:@"log - needsarchiving - 30x30" index:ImageLog_NeedsArchiving];
    [self add:@"log - needsmaintenance - 30x30" index:ImageLog_NeedsMaintenance];
    [self add:@"log - ownermaintenance - 30x30" index:ImageLog_OwnerMaintenance];
    [self add:@"log - reviewernote - 30x30" index:ImageLog_ReviewerNote];
    [self add:@"log - published - 30x30" index:ImageLog_Published];
    [self add:@"log - archived - 30x30" index:ImageLog_Archived];
    [self add:@"log - disabled - 18x18" index:ImageLog_Disabled];
    [self add:@"log - unarchived - 30x30" index:ImageLog_Unarchived];
    [self add:@"log - coordinates - 30x30" index:ImageLog_Coordinates];
    [self add:@"log - unknown - 30x30" index:ImageLog_WebcamPhoto];
    [self add:@"log - note - 30x30" index:ImageLog_Note];
    [self add:@"log - attended - 30x30" index:ImageLog_Attended];
    [self add:@"log - willattend - 30x30" index:ImageLog_WillAttend];
    [self add:@"log - unknown - 30x30" index:ImageLog_Unknown];

    [self add:@"container - large - 70x20" index:ImageSize_Large];
    [self add:@"container - micro - 70x20" index:ImageSize_Micro];
    [self add:@"container - notchosen - 70x20" index:ImageSize_NotChosen];
    [self add:@"container - other - 70x20" index:ImageSize_Other];
    [self add:@"container - regular - 70x20" index:ImageSize_Regular];
    [self add:@"container - small - 70x20" index:ImageSize_Small];
    [self add:@"container - unknown - 70x20" index:ImageSize_Virtual];

    [self add:@"ratings - star base 95x18" index:ImageCacheView_ratingBase];
    [self add:@"ratings - star on 19x18" index:ImageCacheView_ratingOn];
    [self add:@"ratings - star off 18x18" index:ImageCacheView_ratingOff];
    [self add:@"ratings - star half 18x18" index:ImageCacheView_ratingHalf];
    [self add:@"ratings - favourites 20x30" index:ImageCacheView_favourites];

    [self add:@"map - pin stick - 35x42" index:ImageMap_pin];
    [self add:@"map - dnf stick - 35x42" index:ImageMap_dnf];
    [self add:@"map - found stick - 35x42" index:ImageMap_found];

    [self add:@"map - cross dnf - 9x9" index:ImageMap_pinCrossDNF];
    [self add:@"map - tick found - 9x9" index:ImageMap_pinTickFound];
    [self add:@"map - disabled - 15x15" index:ImageMap_pinOutlineDisabled];
    [self add:@"map - archived - 15x15" index:ImageMap_pinOutlineArchived];
    [self add:@"map - highlight - 21x21" index:ImageMap_pinOutlineHighlight];
    [self add:@"map - background - 35x42" index:ImageMap_background];
    [self add:@"type - cross dnf - 19x19" index:ImageMap_typeCrossDNF];
    [self add:@"type - tick found - 24x21" index:ImageMap_typeTickFound];
    [self add:@"type - disabled - 24x24" index:ImageMap_typeOutlineDisabled];
    [self add:@"type - archived - 24x24" index:ImageMap_typeOutlineArchived];

    [self add:@"icons - smiley - 30x30" index:ImageIcon_Smiley];
    [self add:@"icons - sad - 30x30" index:ImageIcon_Sad];
    [self add:@"icons - target - 20x20" index:ImageIcon_Target];

    [self add:@"menu icon - global" index:ImageIcon_GlobalMenu];
    [self add:@"menu icon - local" index:ImageIcon_LocalMenu];
    [self add:@"menu icon - close" index:ImageIcon_CloseButton];

    [self add:@"compass - red on blue compass - compass" index:ImageCompass_RedArrowOnBlueCompass];
    [self add:@"compass - red on blue compass - arrow" index:ImageCompass_RedArrowOnBlueArrow];
    [self add:@"compass - white arrow on black" index:ImageCompass_WhiteArrowOnBlack];
    [self add:@"compass - red arrow on black" index:ImageCompass_RedArrowOnBlack];
    [self add:@"compass - airplane - airplane" index:ImageCompass_AirplaneAirplane];
    [self add:@"compass - airplane - compass" index:ImageCompass_AirplaneCompass];

    [self add:@"attributes - unknown" index:ImageAttribute_Unknown];
    [self add:@"attributes - 01" index:ImageAttribute_DogsAllowed];
    [self add:@"attributes - 02" index:ImageAttribute_AccessOrParkingFee];
    [self add:@"attributes - 03" index:ImageAttribute_RockClimbing];
    [self add:@"attributes - 04" index:ImageAttribute_Boat];
    [self add:@"attributes - 05" index:ImageAttribute_ScubaGear];
    [self add:@"attributes - 06" index:ImageAttribute_RecommendedForKids];
    [self add:@"attributes - 07" index:ImageAttribute_TakesLessThanAnHour];
    [self add:@"attributes - 08" index:ImageAttribute_ScenicVIew];
    [self add:@"attributes - 09" index:ImageAttribute_SignificantHike];
    [self add:@"attributes - 10" index:ImageAttribute_DifficultClimbing];
    [self add:@"attributes - 11" index:ImageAttribute_MayRequireWading];
    [self add:@"attributes - 12" index:ImageAttribute_MayRequireSwimming];
    [self add:@"attributes - 13" index:ImageAttribute_AvailableAtAllTimes];
    [self add:@"attributes - 14" index:ImageAttribute_RecommendedAtNight];
    [self add:@"attributes - 15" index:ImageAttribute_AvailableDuringWinter];
    [self add:@"attributes - 17" index:ImageAttribute_PoisonPlants];
    [self add:@"attributes - 18" index:ImageAttribute_DangerousAnimals];
    [self add:@"attributes - 19" index:ImageAttribute_Ticks];
    [self add:@"attributes - 20" index:ImageAttribute_AbandonedMines];
    [self add:@"attributes - 21" index:ImageAttribute_CliffFallingRocks];
    [self add:@"attributes - 22" index:ImageAttribute_Hunting];
    [self add:@"attributes - 23" index:ImageAttribute_DangerousArea];
    [self add:@"attributes - 24" index:ImageAttribute_WheelchairAccessible];
    [self add:@"attributes - 25" index:ImageAttribute_ParkingAvailable];
    [self add:@"attributes - 26" index:ImageAttribute_PublicTransportation];
    [self add:@"attributes - 27" index:ImageAttribute_DrinkingWaterNearby];
    [self add:@"attributes - 28" index:ImageAttribute_ToiletNearby];
    [self add:@"attributes - 29" index:ImageAttribute_TelephoneNearby];
    [self add:@"attributes - 30" index:ImageAttribute_PicnicTablesNearby];
    [self add:@"attributes - 31" index:ImageAttribute_CampingArea];
    [self add:@"attributes - 32" index:ImageAttribute_Bicycles];
    [self add:@"attributes - 33" index:ImageAttribute_Motorcycles];
    [self add:@"attributes - 34" index:ImageAttribute_Quads];
    [self add:@"attributes - 35" index:ImageAttribute_OffRoadVehicles];
    [self add:@"attributes - 36" index:ImageAttribute_Snowmobiles];
    [self add:@"attributes - 37" index:ImageAttribute_Horses];
    [self add:@"attributes - 38" index:ImageAttribute_Campfires];
    [self add:@"attributes - 39" index:ImageAttribute_Thorns];
    [self add:@"attributes - 40" index:ImageAttribute_StealthRequired];
    [self add:@"attributes - 41" index:ImageAttribute_StrollerAccessible];
    [self add:@"attributes - 42" index:ImageAttribute_NeedsMaintenance];
    [self add:@"attributes - 43" index:ImageAttribute_WatchForLivestock];
    [self add:@"attributes - 44" index:ImageAttribute_FlashlightRequired];
    [self add:@"attributes - 45" index:ImageAttribute_LostAndFoundTour];
    [self add:@"attributes - 46" index:ImageAttribute_TruckDriversRV];
    [self add:@"attributes - 47" index:ImageAttribute_FieldPuzzle];
    [self add:@"attributes - 48" index:ImageAttribute_UVTorchRequired];
    [self add:@"attributes - 49" index:ImageAttribute_Snowshoes];
    [self add:@"attributes - 50" index:ImageAttribute_CrossCountrySkies];
    [self add:@"attributes - 51" index:ImageAttribute_LongHike];
    [self add:@"attributes - 52" index:ImageAttribute_SpecialToolRequired];
    [self add:@"attributes - 53" index:ImageAttribute_NightCache];
    [self add:@"attributes - 54" index:ImageAttribute_ParkAndGrab];
    [self add:@"attributes - 55" index:ImageAttribute_AbandonedStructure];
    [self add:@"attributes - 56" index:ImageAttribute_ShortHike];
    [self add:@"attributes - 57" index:ImageAttribute_MediumHike];
    [self add:@"attributes - 58" index:ImageAttribute_FuelNearby];
    [self add:@"attributes - 59" index:ImageAttribute_FoodNearby];
    [self add:@"attributes - 60" index:ImageAttribute_WirelessBeacon];
    [self add:@"attributes - 61" index:ImageAttribute_PartnershipCache];
    [self add:@"attributes - 62" index:ImageAttribute_SeasonalAccess];
    [self add:@"attributes - 63" index:ImageAttribute_TouristFriendly];
    [self add:@"attributes - 64" index:ImageAttribute_TreeClimbing];
    [self add:@"attributes - 65" index:ImageAttribute_FrontYard];
    [self add:@"attributes - 66" index:ImageAttribute_TeamworkRequired];
    [self add:@"attributes - 67" index:ImageAttribute_PartOfGeoTour];

    /* Create pinheads and pins */
    [[dbc Types] enumerateObjectsUsingBlock:^(dbType *type, NSUInteger idx, BOOL * _Nonnull stop) {
        float r, g, b;
        [ImageLibrary RGBtoFloat:type.pin_rgb r:&r g:&g b:&b];
        UIColor *pinColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [self recreatePin:type.pin color:pinColor];
    }];

    /* Make ratings images */
    [self mergeRating:0 full:0 half:0];
    [self mergeRating:1 full:0 half:1];
    [self mergeRating:2 full:1 half:0];
    [self mergeRating:3 full:1 half:1];
    [self mergeRating:4 full:2 half:0];
    [self mergeRating:5 full:2 half:1];
    [self mergeRating:6 full:3 half:0];
    [self mergeRating:7 full:3 half:1];
    [self mergeRating:8 full:4 half:0];
    [self mergeRating:9 full:4 half:1];
    [self mergeRating:10 full:5 half:0];

    /* Pin and type images */
    pinImages = [NSMutableDictionary dictionaryWithCapacity:25];
    typeImages = [NSMutableDictionary dictionaryWithCapacity:25];

    return self;
}

- (void)add:(NSString *)name index:(NSInteger)idx
{
    [self add2:idx name:name];
}
- (void)add2:(NSInteger)index name:(NSString *)name
{
    NSString *s = [NSString stringWithFormat:@"%@/%@", [MyTools DataDistributionDirectory], name];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:s];
    if (img == nil) {
        NSLog(@"ImageLibrary: Image %@ not found", s);
        return;
    }
    imgs[index] = img;
    names[index] = name;
}

- (void)addpinhead:(NSInteger)index image:(UIImage *)img
{
    imgs[index] = img;
    names[index] = [NSString stringWithFormat:@"pinhead: %ld", (long)index];
}

- (UIImage *)mergePinhead2:(UIImage *)bottom top:(NSInteger)top
{
    UIImage *out = [self addImageToImage:bottom withImage2:[self get:top] andRect:CGRectMake(3, 3, 15, 15)];
    return out;
}
- (UIImage *)mergePinhead:(UIImage *)bottom top:(NSInteger)top
{
    return [self mergePinhead2:bottom top:top];
}
- (void)mergePinhead:(NSInteger)bottom top:(NSInteger)top index:(NSInteger)index
{
    UIImage *out = [self mergePinhead2:[self get:bottom] top:top];
    imgs[index] = out;
    names[index] = [NSString stringWithFormat:@"Merge of %ld and %ld", (long)bottom, (long)top];
}

- (UIImage *)mergeXXX:(UIImage *)bottom top:(NSInteger)top
{
    return [self addImageToImage:bottom withImage2:[self get:top] andRect:CGRectMake(6, 6, 13, 13)];
}
- (UIImage *)mergeDNF:(UIImage *)bottom top:(NSInteger)top
{
    return [self mergeXXX:bottom top:top];
}
- (UIImage *)mergeFound:(UIImage *)bottom top:(NSInteger)top
{
    return [self mergeXXX:bottom top:top];
}

- (UIImage *)mergeHighlight:(UIImage *)bottom top:(NSInteger)top
{
    return [self addImageToImage:bottom withImage2:[self get:top] andRect:CGRectMake(0, 0, 21, 21)];
}

- (UIImage *)mergePin:(UIImage *)bottom top:(NSInteger)top
{
    return [self addImageToImage:bottom withImage2:[self get:top] andRect:CGRectMake(0, 0, 35, 42)];
}

- (UIImage *)mergeYYY:(UIImage *)bottom top:(NSInteger)top
{
    return [self addImageToImage:bottom withImage2:[self get:top] andRect:CGRectMake(3, 3, 15, 15)];
}
- (UIImage *)mergeDisabled:(UIImage *)bottom top:(NSInteger)top
{
    return [self mergeYYY:bottom top:top];
}
- (UIImage *)mergeArchived:(UIImage *)bottom top:(NSInteger)top
{
    return [self mergeYYY:bottom top:top];
}

- (void)mergeRating:(NSInteger)index full:(NSInteger)full half:(NSInteger)half
{
    UIImage *out = [UIImage imageWithCGImage:[self get:ImageCacheView_ratingBase].CGImage];
    NSInteger w = 19;
    NSInteger h = 19;
    for (NSInteger i = 0; i < full; i++) {
        UIImage *_out = [self addImageToImage:out withImage2:[self get:ImageCacheView_ratingOn] andRect:CGRectMake(i * w, 0, w, h)];
        out = [UIImage imageWithCGImage:_out.CGImage];
    }

    if (half == 1) {
        UIImage *_out = [self addImageToImage:out withImage2:[self get:ImageCacheView_ratingHalf] andRect:CGRectMake(full * w, 0, w, h)];
        out = [UIImage imageWithCGImage:_out.CGImage];
    }

    ratingImages[index] = [UIImage imageWithCGImage:out.CGImage];
}

- (UIImage *)addImageToImage:(UIImage *)img1 withImage2:(UIImage *)img2 andRect:(CGRect)cropRect
{
    CGSize size = img1.size;
    UIGraphicsBeginImageContext(size);

    CGPoint pointImg1 = CGPointMake(0, 0);
    [img1 drawAtPoint:pointImg1];

    CGPoint pointImg2 = cropRect.origin;
    [img2 drawAtPoint:pointImg2];

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)get:(NSInteger)imgnum
{
    UIImage *img = imgs[imgnum];
    if (img == nil)
        NSLog(@"ImageLibrary: imgnum %ld not found", (long)imgnum);
    return img;
}

- (NSString *)getName:(NSInteger)imgnum
{
    NSString *name = names[imgnum];
    if (name == nil)
        NSLog(@"ImageLibrary: imgnum %ld not found", (long)imgnum);
    return name;
}

- (UIImage *)getRating:(float)rating
{
    return ratingImages[(int)(2 * rating)];
}

- (NSString *)getPinTypeCode:(NSInteger)imgnum found:(NSInteger)found disabled:(BOOL)disabled archived:(BOOL)archived highlight:(BOOL)highlight
{
    NSMutableString *s = [NSMutableString stringWithString:@""];

    if (highlight == YES)
        [s appendString:@"H"];
    else
        [s appendString:@"h"];

    [s appendFormat:@"%ld", (long)imgnum];

    if (disabled == YES)
        [s appendString:@"D"];
    else
        [s appendString:@"d"];

    if (archived == YES)
        [s appendString:@"A"];
    else
        [s appendString:@"a"];

    switch (found) {
        case LOGSTATUS_NOTLOGGED:
            [s appendString:@"-"];
            break;
        case LOGSTATUS_NOTFOUND:
            [s appendString:@"l"];
            break;
        case LOGSTATUS_FOUND:
            [s appendString:@"L"];
            break;
    }

    return s;
}

- (UIImage *)getPin:(NSInteger)imgnum found:(NSInteger)found disabled:(BOOL)disabled archived:(BOOL)archived highlight:(BOOL)highlight
{
    NSString *s = [self getPinTypeCode:imgnum found:found disabled:disabled archived:archived highlight:highlight];
    UIImage *img = [pinImages valueForKey:s];
    if (img == nil) {
        NSLog(@"Creating pin %@s", s);
        img = [self getPinImage:imgnum found:found disabled:disabled archived:archived highlight:highlight];
        [pinImages setObject:img forKey:s];
    }

    return img;
}

- (UIImage *)getPinImage:(NSInteger)imgnum found:(NSInteger)found disabled:(BOOL)disabled archived:(BOOL)archived highlight:(BOOL)highlight
{
    UIImage *img = [imageLibrary get:ImageMap_background];

    if (highlight == YES)
        img = [self mergeHighlight:img top:ImageMap_pinOutlineHighlight];

    img = [self mergePin:img top:imgnum + ImageMap_pinheadEnd - ImageMap_pinheadStart];

    if (disabled == YES)
        img = [self mergeDisabled:img top:ImageMap_pinOutlineDisabled];

    if (archived == YES)
        img = [self mergeArchived:img top:ImageMap_pinOutlineArchived];

    switch (found) {
        case LOGSTATUS_NOTLOGGED:
            // Do not overlay anything
            break;
        case LOGSTATUS_NOTFOUND:
            img = [self mergeFound:img top:ImageMap_pinCrossDNF];
            // Overlay the blue cross
            break;
        case LOGSTATUS_FOUND:
            img = [self mergeFound:img top:ImageMap_pinTickFound];
            // Overlay the yellow tick
            break;
    }

    return img;
}

- (UIImage *)getPin:(dbWaypoint *)wp
{
    return [self getPin:wp.type.pin found:wp.logStatus disabled:(wp.groundspeak == nil ? NO : (wp.groundspeak.available == NO)) archived:(wp.groundspeak == nil ? NO : wp.groundspeak.archived) highlight:wp.highlight];
}

- (UIImage *)getType:(NSInteger)imgnum found:(NSInteger)found disabled:(BOOL)disabled archived:(BOOL)archived highlight:(BOOL)highlight
{
    NSString *s = [self getPinTypeCode:imgnum found:found disabled:disabled archived:archived highlight:highlight];
    UIImage *img = [typeImages valueForKey:s];
    if (img == nil) {
        img = [self getTypeImage:imgnum found:found disabled:disabled archived:archived highlight:highlight];
        [typeImages setObject:img forKey:s];
    }

    return img;
}

- (UIImage *)getTypeImage:(NSInteger)imgnum found:(NSInteger)found disabled:(BOOL)disabled archived:(BOOL)archived highlight:(BOOL)highlight
{
    UIImage *img = [imageLibrary get:imgnum];

    if (disabled == YES)
        img = [self mergeDisabled:img top:ImageMap_typeOutlineDisabled];

    if (archived == YES)
        img = [self mergeArchived:img top:ImageMap_typeOutlineArchived];

    switch (found) {
        case LOGSTATUS_NOTLOGGED:
            // Do not overlay anything
            break;
        case LOGSTATUS_NOTFOUND:
            img = [self mergeFound:img top:ImageMap_typeCrossDNF];
            // Overlay the blue cross
            break;
        case LOGSTATUS_FOUND:
            img = [self mergeFound:img top:ImageMap_typeTickFound];
            // Overlay the yellow tick
            break;
    }

    return img;
}

- (UIImage *)getType:(dbWaypoint *)wp
{
    return [self getType:wp.type.icon found:wp.logStatus disabled:(wp.groundspeak == nil ? NO : (wp.groundspeak.available == NO)) archived:(wp.groundspeak == nil ? NO : wp.groundspeak.archived) highlight:wp.highlight];
}

- (void)recreatePin:(NSInteger)pin color:(UIColor *)pinColor
{
    [self addpinhead:pin image:[self newPinHead:pinColor]];
    [self mergePinhead:ImageMap_pin top:pin index:pin + ImageMap_pinheadEnd - ImageMap_pinheadStart];
}

+ (void)RGBtoFloat:(NSString *)rgb r:(float *)r g:(float *)g b:(float *)b
{
    unsigned int i;
    NSScanner *s = [NSScanner scannerWithString:[rgb substringWithRange:NSMakeRange(0, 2)]];
    [s scanHexInt:&i];
    *r = i / 255.0;
    s = [NSScanner scannerWithString:[rgb substringWithRange:NSMakeRange(2, 2)]];
    [s scanHexInt:&i];
    *g = i / 255.0;
    s = [NSScanner scannerWithString:[rgb substringWithRange:NSMakeRange(4, 2)]];
    [s scanHexInt:&i];
    *b = i / 255.0;
}

- (UIImage *)newPinHead:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(15, 15));
    CGContextRef context = UIGraphicsGetCurrentContext();

    /*
     * .....xxxxx.....
     * ...xxXXXXXxx...
     * ..xXXXXXXXXXx..
     * .xXX,::,XXXXXx.
     * .xXX::::XXXXXx.
     * xXXX::::XXXXXXx
     * xXXX'::'XXXXXXx
     * xXXXXXXXXXXXXXx
     * xXXXXXXXXXXXXXx
     * xXXXXXXXXXXXXXx
     * .xXXXXXXXXXXXx.
     * .xXXXXXXXXXXXx.
     * ..xXXXXXXXXXx..
     * ...xxXXXXXxx...
     * .....xxxxx.....
     */

#define VLINE(x, y1, y2) \
    CGContextSetLineWidth(context, 1); \
    CGContextMoveToPoint(context, x + 0.5, y1); \
    CGContextAddLineToPoint(context, x + 0.5, y2 + 1); \
    CGContextStrokePath(context);
#define HLINE(y, x1, x2) \
    CGContextSetLineWidth(context, 1); \
    CGContextMoveToPoint(context, x1, y + 0.5); \
    CGContextAddLineToPoint(context, x2 + 1, y + 0.5); \
    CGContextStrokePath(context);
#define DOT(x, y) \
    HLINE(y, x, x);

    const CGFloat *vs = CGColorGetComponents([color CGColor]);
    CGFloat r = vs[0];
    CGFloat g = vs[1];
    CGFloat b = vs[2];

    // Outer circle
    for (NSInteger i = 0; i < 2; i++) {
        if (i == 0)
            CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        else
            CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:r green:g blue:b alpha:0.4] CGColor]);
        HLINE( 0,  5,   9);     // Top
        HLINE( 1,  3,   4);
        DOT  ( 2,  2);
        VLINE( 1,  3,   4);
        VLINE( 0,  5,   9);     // Lefthand side
        VLINE( 1, 10, 11);
        DOT  ( 2, 12);
        HLINE(13,  3,   4);
        HLINE(14,  5,   9);     // Bottom
        HLINE(13, 10,  11);
        DOT  (12, 12);
        VLINE(13, 10, 11);
        VLINE(14,  5,  9);      // Righthand side
        VLINE(13,  3,  4);
        DOT  (12,  2);
        HLINE( 1,  10, 11);
    }

    // Inner circle
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    HLINE( 1, 5,  9);
    HLINE( 2, 3, 11);
    HLINE( 3, 2, 12);
    HLINE( 4, 2, 12);
    HLINE( 5, 1, 13);
    HLINE( 6, 1, 13);
    HLINE( 7, 1, 13);
    HLINE( 8, 1, 13);
    HLINE( 9, 1, 13);
    HLINE(10, 2, 12);
    HLINE(11, 2, 12);
    HLINE(12, 3, 11);
    HLINE(13, 5,  9);

    // Little dot at the top left
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    HLINE( 3, 4, 5);
    HLINE( 4, 3, 6);
    HLINE( 5, 3, 6);
    HLINE( 6, 4, 5);

    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] CGColor]);
    DOT  ( 3, 3);
    DOT  ( 6, 3);
    DOT  ( 6, 6);
    DOT  ( 3, 6);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)getSquareWithNumber:(NSInteger)num
{
    NSInteger width = 0;
    if (num < 10)
        width = 1 * 14;
    else if (num < 100)
        width = 2 * 14;
    else if (num < 1000)
        width = 3 * 14;
    else
        width = 4 * 14;
    width += 4;

    UIGraphicsBeginImageContext(CGSizeMake(width, 20));
    CGContextRef context = UIGraphicsGetCurrentContext();

    /*
     *              1         2
     *    0123456789012345678901234
     *  0 .........xxxxxxx.........
     *  1 ......xxx.......xxx......
     *  2 ....xx.............xx....
     *  3 ...x.................x...
     *  4 ..x...................x..
     *  5 .x.....................x.
     *  6 .x.....................x.
     *  7 x.......................x
     *  8 x.......................x
     *  9 x.......................x
     * 10 x.......................x
     *  1 x.......................x
     *  2 x.......................x
     *  3 .x.....................x.
     *  4 .x.....................x.
     *  5 ..x...................x..
     *  6 ...x.................x...
     *  7 ....xx.............xx....
     *  8 ......xxx.......xxx......
     *  9 .........xxxxxxx.........
     */


    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9] CGColor]);
    NSInteger w = width - 1;
    VLINE(0    ,  7, 12);
    VLINE(w - 0,  7, 12);
    VLINE(1    ,  5,  6);
    VLINE(w - 1,  5,  6);
    VLINE(1    , 13, 14);
    VLINE(w - 1, 13, 14);

    HLINE( 1,     6,     8);
    HLINE( 1, w - 8, w - 6);
    HLINE( 2,     4,     5);
    HLINE( 2, w - 5, w - 4);
    HLINE(17,     4,     5);
    HLINE(17, w - 5, w - 4);
    HLINE(18,     6,     8);
    HLINE(18, w - 8, w - 6);

    DOT  (2,  4);
    DOT  (3,  3);
    DOT  (2, 15);
    DOT  (3, 16);
    DOT  (w - 2,  4);
    DOT  (w - 3,  3);
    DOT  (w - 2, 15);
    DOT  (w - 3, 16);

    HLINE( 0, 9, width - 10);
    HLINE(19, 9, width - 10);


    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    l.text = [NSString stringWithFormat:@"%ld", num];
    l.textAlignment = NSTextAlignmentCenter;
    [l.layer drawInContext:context];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end
