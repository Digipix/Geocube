//
//  CacheAttributesViewController.m
//  Geocube
//
//  Created by Edwin Groothuis on 14/07/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

#import "Geocube-Prefix.pch"

@implementation CacheAttributesViewController

#define THISCELL @"CacheAttributesViewController"

- (id)init:(dbCache *)_cache
{
    self = [super init];
    cache = _cache;
    
    attrs = [NSMutableArray arrayWithCapacity:5];
    
    NSArray *as = [db Attributes_all_bycacheid:cache._id];
    NSEnumerator *e = [as objectEnumerator];
    dbAttribute *a;
    while ((a = [e nextObject]) != nil) {
        [attrs addObject:a];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView registerClass:[LogTableViewCell class] forCellReuseIdentifier:THISCELL];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - TableViewController related functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [attrs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Attributes";
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:THISCELL];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    dbAttribute *a = [attrs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = a.label;
    cell.imageView.image = nil;
    
    return cell;
}




@end