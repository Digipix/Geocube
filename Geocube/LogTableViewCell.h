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

@interface LogTableViewCell : GCTableViewCell {
    UIImageView *logtypeImage;
    GCSmallLabel *datetimeLabel;
    GCSmallLabel *loggerLabel;
    GCTextblock *logLabel;

    CGRect rectLogtype;
    CGRect rectDatetime;
    CGRect rectLogger;
    CGRect rectLog;

    dbLog *log;
}

@property (nonatomic, retain) UIImageView *logtypeImage;
@property (nonatomic, retain) GCSmallLabel *datetimeLabel;
@property (nonatomic, retain) GCSmallLabel *loggerLabel;
@property (nonatomic, retain) GCTextblock *logLabel;
@property (nonatomic, retain) dbLog *log;

- (void)setLogString:(NSString *)logString;

@end
