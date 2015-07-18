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
 * along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef Geocube_Import_GPX_h
#define Geocube_Import_GPX_h

@interface Import_GPX : NSObject <NSXMLParserDelegate> {
    NSInteger *newCachesCount;
    NSInteger *totalCachesCount;
    NSInteger *newLogsCount;
    NSInteger *totalLogsCount;
    NSUInteger *percentageRead;
    NSUInteger totalLines;

    NSArray *files;
    dbCacheGroup *group;

    NSMutableArray *attributes;
    NSMutableArray *logs;
    NSInteger index;
    NSInteger inItem, inLog;
    NSMutableString *currentText;
    NSString *currentElement;
    dbCache *currentC;
    dbLog *currentLog;
}

- (id)init:(NSString *)filename group:(dbCacheGroup *)group newCachesCount:(NSInteger *)nCC totalCachesCount:(NSInteger *)tCC newLogsCount:(NSInteger *)nLC totalLogsCount:(NSInteger *)tLC percentageRead:(NSUInteger *)pR;
- (void)parse;

@end

#endif
