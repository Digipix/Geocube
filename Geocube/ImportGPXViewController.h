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

@interface ImportGPXViewController : GCViewController {
    NSString *filename;
    dbCacheGroup *group;

    UILabel *newCachesLabel;
    UILabel *totalCachesLabel;
    UILabel *newLogsLabel;
    UILabel *totalLogsLabel;
    UILabel *progressLabel;

    NSInteger newCachesCount;
    NSInteger totalCachesCount;
    NSInteger newLogsCount;
    NSInteger totalLogsCount;

    NSUInteger percentageRead;

    Import_GPX *imp;
    BOOL importDone;
}

- (id)init:(NSString *)filename group:(dbCacheGroup *)group;

@end
