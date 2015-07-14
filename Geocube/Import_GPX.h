//
//  Import_GPX.h
//  Geocube
//
//  Created by Edwin Groothuis on 28/06/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

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