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

extern ThemeTemplate *currentTheme;
extern ThemeManager *themeManager;

enum GCThemeType {
    THEME_NORMAL = 0,
    THEME_NIGHT,
    THEME_GEOSPHERE
};

@interface ThemeManager : NSObject

@property (nonatomic, retain, readonly) NSArray *themeNames;

- (NSInteger)currentTheme;
- (void)setTheme:(NSInteger)nr;
- (void)changeThemeView:(UIView *)v;
- (void)changeThemeViewController:(UIViewController *)v;
- (void)changeThemeArray:(NSArray *)vs;

@end
