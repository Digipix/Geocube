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

@interface CacheTableViewCell : GCTableViewCell {
    GCLabel *description;
    GCLabel *name;
    UIImageView *size;
    GCLabel *labelRatingD, *labelRatingT;
    UIImageView *imgRatingD, *imgRatingT;
    GCLabel *favourites;
    UIImage *imgRatingOff, *imgRatingOn, *imgRatingHalf, *imgRatingBase, *imgFavourites, *imgSize;
    UIImageView *icon, *imgFavouritesIV;
    GCLabel *stateCountry;
    GCLabel *bearing;
    GCLabel *compass;
    GCLabel *distance;
}

@property (nonatomic, retain) GCLabel *description;
@property (nonatomic, retain) GCLabel *name;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) GCLabel *country;
@property (nonatomic, retain) GCLabel *stateCountry;
@property (nonatomic, retain) GCLabel *bearing;
@property (nonatomic, retain) GCLabel *compass;
@property (nonatomic, retain) GCLabel *distance;

- (NSInteger)cellHeight;
+ (NSInteger)cellHeight;
- (void)setRatings:(NSInteger)favourites terrain:(float)t difficulty:(float)v size:(NSInteger)sz;
- (void)showGroundspeak:(BOOL)yesno;

@end


