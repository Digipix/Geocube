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

#import "Geocube-Prefix.pch"

#define THISCELL @"CacheLogsViewControllerCell"

@implementation CacheLogsViewController

- (id)init:(dbCache *)_wp
{
    self = [super init];
    wp = _wp;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView registerClass:[LogTableViewCell class] forCellReuseIdentifier:THISCELL];

    logs = [db Logs_all_bycacheid:_wp._id];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

#pragma mark - TableViewController related functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [logs count];
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:THISCELL];
    if (cell == nil) {
        cell = [[LogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    dbLog *l = [logs objectAtIndex:indexPath.row];
    cell.datetime.text = l.datetime;
    cell.logger.text = l.logger;
    cell.log.text = l.log;
    cell.log.lineBreakMode = NSLineBreakByWordWrapping;
    dbLogType *lt = [dbc LogType_get:l.logtype_id];
    cell.logtype.image = [imageLibrary get:lt.icon];

    [cell.log sizeToFit];
    [cell.contentView sizeToFit];
    [cell setUserInteractionEnabled:NO];

    /* Save the height for later */
    l.cellHeight = cell.logger.frame.size.height + cell.log.frame.size.height + 10;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dbLog *l = [logs objectAtIndex:indexPath.row];
    return l.cellHeight;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
