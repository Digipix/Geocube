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

@interface dbPin ()
{
    NSString *rgb;
    NSString *rgb_default;
    NSString *description;

    // Not from the database
    UIColor *colour;
    UIImage *img;
}

@end

@implementation dbPin

@synthesize rgb, rgb_default, description, colour, img;

- (void)finish
{
    if ([rgb isEqualToString:@""] == YES)
        rgb = rgb_default;
    colour = [ImageLibrary RGBtoColor:rgb];
    img = [ImageLibrary newPinHead:colour];

    [super finish];
}

- (void)dbUpdateRGB
{
    @synchronized(db.dbaccess) {
        DB_PREPARE(@"update pins set rgb = ? where id = ?");

        SET_VAR_TEXT(1, self.rgb);
        SET_VAR_INT( 2, self._id);
        DB_CHECK_OKAY;
        DB_FINISH;
    }

    colour = [ImageLibrary RGBtoColor:self.rgb];
    img = [ImageLibrary newPinHead:colour];
}

+ (NSArray *)dbAll
{
    NSMutableArray *ps = [[NSMutableArray alloc] initWithCapacity:20];

    @synchronized(db.dbaccess) {
        DB_PREPARE(@"select id, description, rgb, rgb_default from pins");

        DB_WHILE_STEP {
            dbPin *p = [[dbPin alloc] init];;
            INT_FETCH( 0, p._id);
            TEXT_FETCH(1, p.description);
            TEXT_FETCH(2, p.rgb);
            TEXT_FETCH(3, p.rgb_default);
            [p finish];
            [ps addObject:p];
        }
        DB_FINISH;
    }
    return ps;
}

+ (NSInteger)dbCount
{
    return [dbPin dbCount:@"pins"];
}

@end