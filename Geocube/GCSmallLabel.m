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

@interface GCSmallLabel ()

@end

@implementation GCSmallLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.font = myConfig.GCSmallFont;
    [self changeTheme];

    return self;
}

- (void)changeTheme
{
    self.textColor = currentTheme.labelTextColor;
    self.backgroundColor = currentTheme.labelBackgroundColor;

    // [themeManager changeTheme:self.subviews];
}

- (void)bold:(BOOL)onoff
{
    if (onoff == YES)
        self.font = [UIFont boldSystemFontOfSize:myConfig.GCSmallFont.pointSize];
    else
        self.font = [UIFont systemFontOfSize:myConfig.GCSmallFont.pointSize];
}

@end
