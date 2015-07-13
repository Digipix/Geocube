//
//  CacheGroupsViewController.h
//  Geocube
//
//  Created by Edwin Groothuis on 11/07/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

@interface CacheGroupsViewController : GCTableViewController {
    NSMutableArray *ugs, *sgs;
    dbWaypoint *wp;
}

- (id)init:(dbWaypoint *)wp;

@end