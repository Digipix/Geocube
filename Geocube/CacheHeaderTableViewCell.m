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

@implementation CacheHeaderTableViewCell

@synthesize icon, lat, lon, size, favourites;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    NSInteger width = applicationFrame.size.width;
    NSInteger height = [self cellHeight];

    imgRatingOff = [imageLibrary get:ImageCacheView_ratingOff];
    imgRatingOn = [imageLibrary get:ImageCacheView_ratingOn];
    imgRatingHalf = [imageLibrary get:ImageCacheView_ratingHalf];
    imgFavourites = [imageLibrary get:ImageCacheView_favourites];

    CGRect r;
    UILabel *l;

    /*
     +---+--------------+-----+---+
     | I |              | S XX| F |  Icon
     +---+--------------+-----+---+  Size
     | Lat              | D XXXXX |  Difficulty
     | Lon              | T XXXXX |  Terrain
     +------------------+---------+  Favourites
     */
#define BORDER 1
#define ICON_WIDTH 30
#define ICON_HEIGHT 30
#define FAVOURITES_WIDTH 20
#define FAVOURITES_HEIGHT 30
#define STAR_WIDTH 19
#define STAR_HEIGHT 18
#define LAT_HEIGHT 10
#define LON_HEIGHT 10

#define N 5
    CGRect rectIcon = CGRectMake(BORDER + N, BORDER, ICON_WIDTH - N, ICON_HEIGHT);
    CGRect rectFavourites = CGRectMake(width - 2 * BORDER - FAVOURITES_WIDTH - N, BORDER, FAVOURITES_WIDTH, FAVOURITES_HEIGHT);
    CGRect rectSize = CGRectMake(width - 2 * BORDER - 5 * STAR_WIDTH, BORDER + FAVOURITES_HEIGHT - STAR_HEIGHT - N, 5 * STAR_WIDTH - FAVOURITES_WIDTH - BORDER, STAR_HEIGHT);
    CGRect rectRatingsD = CGRectMake(width - 2 * BORDER - 5 * STAR_WIDTH, BORDER + FAVOURITES_HEIGHT - N, 5 * STAR_WIDTH, STAR_HEIGHT);
    CGRect rectRatingsT = CGRectMake(width - 2 * BORDER - 5 * STAR_WIDTH, BORDER + FAVOURITES_HEIGHT + STAR_HEIGHT - N, 5 * STAR_WIDTH, STAR_HEIGHT);
    CGRect rectLat = CGRectMake(BORDER + N, height - BORDER - LON_HEIGHT - LAT_HEIGHT + N, width - 2 * BORDER - 5 * STAR_WIDTH - N, LAT_HEIGHT);
    CGRect rectLon = CGRectMake(BORDER + N, height - BORDER - LON_HEIGHT + N, width - 2 * BORDER - 5 * STAR_WIDTH - N, LON_HEIGHT);

    // Icon
    icon = [[UIImageView alloc] initWithFrame:rectIcon];
    icon.image = [imageLibrary get:ImageTypes_TraditionalCache];
    //icon.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:icon];

    // Favourites
    imgFavouritesIV = [[UIImageView alloc] initWithFrame:rectFavourites];
    imgFavouritesIV.image = imgFavourites;
    [self.contentView addSubview:imgFavouritesIV];
    imgFavouritesIV.hidden = TRUE;
    r = rectFavourites;
    r.size.height /= 2;
    favourites = [[UILabel alloc] initWithFrame:r];
    favourites.font = [UIFont boldSystemFontOfSize:10];
    favourites.textColor = [UIColor whiteColor];
    favourites.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:favourites];

    // ContainerSize
    /*
    r = rectSize;
    r.origin.x -= 10;
    l = [[UILabel alloc] initWithFrame:r];
    l.font = [UIFont systemFontOfSize:10.0];
    l.text = @"S";
    [self.contentView addSubview:l];
     */

    size = [[UIImageView alloc] initWithFrame:rectSize];
    size.image = [imageLibrary get:ImageSize_NotChosen];
    [self.contentView addSubview:size];

    // Difficulty rating
    r = rectRatingsD;
    r.origin.x -= 10;
    l = [[UILabel alloc] initWithFrame:r];
    l.font = [UIFont systemFontOfSize:10.0];
    l.text = @"D";
    [self.contentView addSubview:l];

    r = rectRatingsD;
    r.size.width = STAR_WIDTH;
    for (NSInteger i = 0; i < 5; i++) {
        ratingD[i] = [[UIImageView alloc] initWithFrame:r];
        ratingD[i].image = imgRatingOff;
        [self.contentView addSubview:ratingD[i]];
        r.origin.x += STAR_WIDTH;
    }

    // Terrain rating
    r = rectRatingsT;
    r.origin.x -= 10;
    l = [[UILabel alloc] initWithFrame:r];
    l.font = [UIFont systemFontOfSize:10.0];
    l.text = @"T";
    [self.contentView addSubview:l];

    r = rectRatingsT;
    r.size.width = STAR_WIDTH;
    for (NSInteger i = 0; i < 5; i++) {
        ratingT[i] = [[UIImageView alloc] initWithFrame:r];
        ratingT[i].image = imgRatingOff;
        [self.contentView addSubview:ratingT[i]];
        r.origin.x += STAR_WIDTH;
    }

    // Lon
    lon = [[UILabel alloc] initWithFrame:rectLon];
    lon.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:lon];

    // Lat
    lat = [[UILabel alloc] initWithFrame:rectLat];
    lat.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:lat];

    return self;
}

- (void)setRatings:(NSInteger)favs terrain:(float)t difficulty:(float)d
{
    for (NSInteger i = 0; i < t; i++)
        ratingT[i].image = imgRatingOn;
    for (NSInteger i = t; i < 5; i++)
        ratingT[i].image = imgRatingOff;
    if (t - (int)t != 0)
        ratingT[(int)t].image = imgRatingHalf;

    for (NSInteger i = 0; i < d; i++)
        ratingD[i].image = imgRatingOn;
    for (NSInteger i = d; i < 5; i++)
        ratingD[i].image = imgRatingOff;
    if (d - (int)d != 0)
        ratingD[(int)d].image = imgRatingHalf;

    if (favs != 0) {
        favourites.text = [NSString stringWithFormat:@"%ld", (long)favs];
        imgFavouritesIV.hidden = FALSE;
    }
}

+ (NSInteger)cellHeight
{
    return BORDER * 2 + ICON_HEIGHT + LAT_HEIGHT + LON_HEIGHT;
}

- (NSInteger)cellHeight
{
    return BORDER * 2 + ICON_HEIGHT + LAT_HEIGHT + LON_HEIGHT;
}

@end
