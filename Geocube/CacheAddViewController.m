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

@interface CacheAddViewController ()
{
    NSString *code;
    NSString *name;
    CLLocationCoordinate2D coords;
}

@end

@implementation CacheAddViewController

#define THISCELL @"CacheAddTableViewCell"

enum {
    cellCode = 0,
    cellName,
    cellCoords,
    cellSubmit,
    cellMax
};

- (instancetype)init
{
    self = [super init];

    lmi = nil;

    code = @"MYxxxxx";
    name = @"A new name";
    coords = [LM coords];

    hasCloseButton = YES;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.tableView registerClass:[GCTableViewCellWithSubtitle class] forCellReuseIdentifier:THISCELL];
}

#pragma mark - TableViewController related functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return cellMax;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"New waypoint data";
}

// Return a cell for the index path
- (GCTableViewCellWithSubtitle *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCTableViewCellWithSubtitle *cell = [aTableView dequeueReusableCellWithIdentifier:THISCELL];
    if (cell == nil) {
        cell = [[GCTableViewCellWithSubtitle alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:THISCELL];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.row) {
        case cellCode:
            cell.textLabel.text = @"Waypoint code";
            cell.detailTextLabel.text = code;
            break;
        case cellName:
            cell.textLabel.text = @"Short Name";
            cell.detailTextLabel.text = name;
            break;
        case cellCoords:
            cell.textLabel.text = @"Coords";
            cell.detailTextLabel.text = [Coordinates NiceCoordinates:coords];
            break;
        case cellSubmit:
            cell.textLabel.text = @"Create this waypoint";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case cellCode:
            [self updateCode];
            break;
        case cellName:
            [self updateName];
            break;
        case cellCoords:
            [self updateCoords];
            break;
        case cellSubmit:
            [self updateSubmit];
            break;
    }
}

- (void)updateCode
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Update waypoint"
                               message:@"Update waypoint code"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action) {
                             //Do Some action
                             UITextField *tf = [alert.textFields objectAtIndex:0];
                             code = tf.text;

                             [self.tableView reloadData];
                         }];

    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];

    [alert addAction:ok];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = code;
        textField.placeholder = @"Waypoint code";
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateName
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Update waypoint"
                               message:@"Update waypoint name"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action) {
                             //Do Some action
                             UITextField *tf = [alert.textFields objectAtIndex:0];
                             name = tf.text;

                             [self.tableView reloadData];
                         }];

    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];

    [alert addAction:ok];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = name;
        textField.placeholder = @"Waypoint name";
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateCoords
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Update waypoint"
                               message:@"Latitude is north and south\nLongitude is east and west\nUse 3679 for the direction"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action) {
                             //Do Some action
                             UITextField *tf = [alert.textFields objectAtIndex:0];
                             NSString *lat = tf.text;
                             NSLog(@"Latitude '%@'", lat);

                             tf = [alert.textFields objectAtIndex:1];
                             NSString *lon = tf.text;
                             NSLog(@"Longitude '%@'", lon);

                             Coordinates *c;
                             c = [[Coordinates alloc] initString:lat lon:lon];
                             coords.latitude = c.lat;
                             coords.longitude = c.lon;

                             [self.tableView reloadData];
                         }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];

    [alert addAction:ok];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = [Coordinates NiceLatitude:coords.latitude];
        textField.placeholder = @"Latitude (like S 12 34.567)";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = [Coordinates NiceLongitude:coords.longitude];
        textField.placeholder = @"Longitude (like E 23 45.678)";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)editingChanged:(UITextField *)tf
{
    tf.text = [MyTools checkCoordinate:tf.text];
}

- (void)updateSubmit
{
    dbWaypoint *wp = [[dbWaypoint alloc] init:0];
    Coordinates *c = [[Coordinates alloc] init:coords];

    wp.lat = [c lat_decimalDegreesSigned];
    wp.lon = [c lon_decimalDegreesSigned];
    wp.lat_int = [c lat] * 1000000;
    wp.lon_int = [c lon] * 1000000;
    wp.name = code;
    wp.description = name;
    wp.date_placed_epoch = time(NULL);
    wp.date_placed = [MyTools dateString:wp.date_placed_epoch];
    wp.url = nil;
    wp.urlname = wp.name;
    wp.symbol_id = 1;
    wp.type_id = [dbc Type_Unknown]._id;
    [dbWaypoint dbCreate:wp];

    [dbc.Group_AllWaypoints_ManuallyAdded dbAddWaypoint:wp._id];
    [dbc.Group_AllWaypoints dbAddWaypoint:wp._id];

    [waypointManager needsRefresh];

    [self.navigationController popViewControllerAnimated:YES];
}

@end