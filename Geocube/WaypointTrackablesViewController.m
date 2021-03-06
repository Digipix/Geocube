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

@interface WaypointTrackablesViewController ()
{
    NSMutableArray *tbs;
    dbWaypoint *waypoint;
}

@end

@implementation WaypointTrackablesViewController

#define THISCELL @"WaypointTrackablesViewController"

- (instancetype)init:(dbWaypoint *)_wp
{
    self = [super init];
    waypoint = _wp;

    tbs = [NSMutableArray arrayWithCapacity:5];

    [[dbTrackable dbAllByWaypoint:waypoint._id] enumerateObjectsUsingBlock:^(dbTrackable *tb, NSUInteger idx, BOOL *stop) {
        [tbs addObject:tb];
    }];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView registerClass:[GCTableViewCellWithSubtitle class] forCellReuseIdentifier:THISCELL];

    lmi = nil;

    return self;
}

- (void)viewDidLoad
{
    hasCloseButton = YES;
    [super viewDidLoad];
}

#pragma mark - TableViewController related functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [tbs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Trackables";
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:THISCELL];
    cell.accessoryType = UITableViewCellAccessoryNone;

    dbTrackable *tb = [tbs objectAtIndex:indexPath.row];

    cell.textLabel.text = tb.name;
    cell.detailTextLabel.text = tb.ref;
    cell.userInteractionEnabled = NO;
    cell.imageView.image = nil;

    return cell;
}

@end
