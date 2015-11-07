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

#define THISCELL_HEADER @"cachetablecell_header"
#define THISCELL_DATA @"cachetablecell_data"
#define THISCELL_ACTIONS @"cachetablecell_actions"

@implementation CacheViewController

- (instancetype)initWithStyle:(UITableViewStyle)style canBeClosed:(BOOL)canBeClosed
{
    self = [super initWithStyle:style];

    menuItems = [NSMutableArray arrayWithArray:@[@"Add waypoint", @"Highlight", @"Refresh waypoint", @"Ignore", @"Add to group"]];
    hasCloseButton = canBeClosed;

    return self;
}

- (void)showWaypoint:(dbWaypoint *)_wp
{
    waypoint = _wp;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.tableView registerClass:[CacheHeaderTableViewCell class] forCellReuseIdentifier:THISCELL_HEADER];
    [self.tableView registerClass:[GCTableViewCell class] forCellReuseIdentifier:THISCELL_DATA];
    [self.tableView registerClass:[GCTableViewCellRightImage class] forCellReuseIdentifier:THISCELL_ACTIONS];

    waypointItems = @[@"Description", @"Hint", @"Personal Note", @"Field Notes", @"Logs", @"Attributes", @"Additional Waypoints", @"Inventory", @"Images", @"Group Members"];
    actionItems = @[@"Set as target", @"Mark as found", @"Open in browser"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     [self.tableView reloadData];
                                 }
     ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (waypoint == nil)
        return 0;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (waypoint == nil)
        return 0;
    if (section == 0)
        return 1;
    if (section == 1)
        return [waypointItems count];
    if (section == 2)
        return [actionItems count];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return @"Waypoint data";
    if (section == 2)
        return @"Waypoint actions";
    return nil;
}

- (GCView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0)
        return nil;

    NSInteger width = tableView.bounds.size.width;

    GCView *headerView = [[GCView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
    GCLabel *l;

    l = [[GCLabel alloc] initWithFrame:CGRectMake (0, 0, width, 14)];
    l.text = waypoint.urlname;
    l.font = [UIFont boldSystemFontOfSize:14];
    l.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:l];

    l = [[GCLabel alloc] initWithFrame:CGRectMake (0, 15, width, 10)];
    NSMutableString *s = [NSMutableString stringWithString:@""];
    if (waypoint.gs_placed_by != nil && [waypoint.gs_placed_by isEqualToString:@""] == NO)
        [s appendFormat:@"by %@", waypoint.gs_placed_by];
    if ([waypoint.date_placed isEqualToString:@""] == NO)
        [s appendFormat:@" on %@", [MyTools datetimePartDate:waypoint.date_placed]];
    l.text = s;
    l.font = [UIFont systemFontOfSize:10];
    l.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:l];

    l = [[GCLabel alloc] initWithFrame:CGRectMake (0, 25, width, 12)];
    l.text = [NSString stringWithFormat:@"%@ (%@)", waypoint.name, waypoint.account.site];
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:l];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 37;
    return [super tableView:tableView heightForHeaderInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Cache header
    if (indexPath.section == 0) {
        CacheHeaderTableViewCell *cell = [[CacheHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_HEADER];
        cell.accessoryType = UITableViewCellAccessoryNone;
        Coordinates *c = [[Coordinates alloc] init:waypoint.lat_float lon:waypoint.lon_float];
        cell.lat.text = [c lat_degreesDecimalMinutes];
        cell.lon.text = [c lon_degreesDecimalMinutes];
        [cell setRatings:waypoint.gs_favourites terrain:waypoint.gs_rating_terrain difficulty:waypoint.gs_rating_difficulty];

        cell.userInteractionEnabled = NO;
        cell.size.image = [imageLibrary get:waypoint.gs_container.icon];
        cell.icon.image = [imageLibrary getType:waypoint];

        //[cell showGroundspeak:(groundspeak != nil)]; Not sure yet
        return cell;
    }

    // Cache data
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THISCELL_DATA forIndexPath:indexPath];
        if (cell == nil)
            cell = [[GCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_DATA];
        cell.textLabel.text = [waypointItems objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;

        UIColor *tc = currentTheme.textColor;
        switch (indexPath.row) {
            case 0: /* Description */
                if ([waypoint.gs_short_desc isEqualToString:@""] == YES && [waypoint.gs_long_desc isEqualToString:@""] == YES && [waypoint.description isEqualToString:@""] == YES) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = NO;
                }
                break;
            case 1: /* Hint */
                //                if (waypoint.groundspeak.hint ==b nil || [waypoint.groundspeak.hint isEqualToString:@""] == YES)
                if (waypoint.gs_hint == nil || [waypoint.gs_hint isEqualToString:@""] == YES || [waypoint.gs_hint isEqualToString:@" "] == YES) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = NO;
                }
                break;
            case 2: /* Personal note */
                if ([dbPersonalNote dbGetByWaypointID:waypoint._id] == nil) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = YES;     // Be able to create one
                }
                break;
            case 3: { /* Field Note */
                NSInteger c = [waypoint hasFieldNotes];
                if (c == 0) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = NO;
                } else
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [waypointItems objectAtIndex:indexPath.row], (long)c];
                break;
            }
            case 4: { /* Logs */
                NSInteger c = [waypoint hasLogs];
                if (c == 0) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = NO;
                } else {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [waypointItems objectAtIndex:indexPath.row], (long)c];
                }
                break;
            }
            case 5: { /* Attributes */
                NSInteger c = [waypoint hasAttributes];
                if (c == 0) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = NO;
                } else
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [waypointItems objectAtIndex:indexPath.row], (long)c];
                break;
            }
            case 6: { /* Related Waypoints */
                NSArray *wps = [waypoint hasWaypoints];
                if ([wps count] <= 1) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = YES;     // Be able to create one
                } else
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [waypointItems objectAtIndex:indexPath.row], (long)([wps count] - 1)];
                break;
            }
            case 7: { /* Inventory */
                NSInteger c = [waypoint hasInventory];
                if (c == 0) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = NO;
                } else
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [waypointItems objectAtIndex:indexPath.row], (long)c];
                break;
            }
            case 8: { /* Images */
                NSInteger c = [waypoint hasImages];
                if (c == 0) {
                    tc = currentTheme.labelTextColorDisabled;
                    cell.userInteractionEnabled = NO;
                } else
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [waypointItems objectAtIndex:indexPath.row], (long)c];
                break;
            }
        }
        cell.textLabel.textColor = tc;
        cell.imageView.image = nil;
        return cell;
    }

    // Cache commands
    if (indexPath.section == 2) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            GCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THISCELL_ACTIONS forIndexPath:indexPath];
            if (cell == nil)
                cell = [[GCTableViewCellRightImage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_ACTIONS];
            cell.userInteractionEnabled = YES;

            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [imageLibrary get:ImageIcon_Target];
                    break;
                case 1:
                    cell.imageView.image = [imageLibrary get:ImageIcon_Smiley];
                    break;
            }
            cell.textLabel.text = [actionItems objectAtIndex:indexPath.row];
            return cell;
        }

        if (indexPath.row == 2) {
            GCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THISCELL_DATA forIndexPath:indexPath];
            if (cell == nil)
                cell = [[GCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_ACTIONS];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.userInteractionEnabled = YES;

            if (indexPath.row == 2) {
                if (waypoint.url == nil)
                    cell.userInteractionEnabled = NO;
            }

            cell.textLabel.text = [actionItems objectAtIndex:indexPath.row];
            return cell;
        }
    }

    return nil;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {   /* Description */
            UIViewController *newController = [[CacheDescriptionViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 1) {   /* Hint */
            UIViewController *newController = [[CacheHintViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 2) {   /* Personal note */
            UIViewController *newController = [[CachePersonalNoteViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 3) {   /* Field Notes */
            UITableViewController *newController = [[CacheLogsViewController alloc] initMine:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 4) {   /* Logs */
            UITableViewController *newController = [[CacheLogsViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 5) {   /* Attributes */
            UITableViewController *newController = [[CacheAttributesViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 6) {    /* Waypoints */
            NSArray *wps = [waypoint hasWaypoints];
            if ([wps count] <= 1) {
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [self newWaypoint];
            } else {
                UITableViewController *newController = [[CacheWaypointsViewController alloc] init:waypoint];
                newController.edgesForExtendedLayout = UIRectEdgeNone;
                [self.navigationController pushViewController:newController animated:YES];
            }
            return;
        }
        if (indexPath.row == 7) {    /* Trackables */
            UITableViewController *newController = [[CacheTrackablesViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 8) {    /* Images */
            UITableViewController *newController = [[CacheImagesViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        if (indexPath.row == 9) {    /* Groups */
            UITableViewController *newController = [[CacheGroupsViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }
        return;
    }

    if (indexPath.section == 2) {
        if (indexPath.row == 0) {   /* Set as target */
            if ([waypointManager currentWaypoint] != nil &&
                [[waypointManager currentWaypoint].name isEqualToString:waypoint.name] == YES) {
                [waypointManager setCurrentWaypoint:nil];
                [self showWaypoint:nil];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }

            [waypointManager setCurrentWaypoint:waypoint];
            [self.tableView reloadData];

            BHTabsViewController *tb = [_AppDelegate.tabBars objectAtIndex:RC_NAVIGATE];
            UINavigationController *nvc = [tb.viewControllers objectAtIndex:VC_NAVIGATE_TARGET];
            CacheViewController *cvc = [nvc.viewControllers objectAtIndex:0];
            [cvc showWaypoint:waypointManager.currentWaypoint];

            nvc = [tb.viewControllers objectAtIndex:VC_NAVIGATE_MAP_GMAP];
            MapGoogleViewController *mgv = [nvc.viewControllers objectAtIndex:0];
            [mgv refreshWaypointsData];

            nvc = [tb.viewControllers objectAtIndex:VC_NAVIGATE_MAP_AMAP];
            MapAppleViewController *mav = [nvc.viewControllers objectAtIndex:0];
            [mav refreshWaypointsData];

            nvc = [tb.viewControllers objectAtIndex:VC_NAVIGATE_MAP_OSM];
            MapOSMViewController *mov = [nvc.viewControllers objectAtIndex:0];
            [mov refreshWaypointsData];

            [_AppDelegate switchController:RC_NAVIGATE];
            [tb makeTabViewCurrent:VC_NAVIGATE_COMPASS];
            return;
        }

        if (indexPath.row == 1) {   /* Mark as found */
            UIViewController *newController = [[CacheLogViewController alloc] init:waypoint];
            newController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:newController animated:YES];
            return;
        }

        if (indexPath.row == 2) {
            [_AppDelegate switchController:RC_BROWSER];
            BHTabsViewController *btc = [_AppDelegate.tabBars objectAtIndex:RC_BROWSER];
            UINavigationController *nvc = [btc.viewControllers objectAtIndex:VC_BROWSER_BROWSER];
            BrowserBrowserViewController *bbvc = [nvc.viewControllers objectAtIndex:0];

            [btc makeTabViewCurrent:VC_BROWSER_BROWSER];
            [bbvc loadURL:waypoint.url];
            return;
        }

        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return [CacheTableViewCell cellHeight];
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Local menu related functions

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index
{
    switch (index) {
        case 0: // Add a waypoint
            [self newWaypoint];
            return;
        case 1: // Highlight waypoint
            waypoint.highlight = !waypoint.highlight;
            [waypoint dbUpdateHighlight];
            return;
        case 2: // Refresh waypoint from server
            [self refreshWaypoint];
            return;
        case 3: // Ignore this waypoint
            waypoint.ignore = !waypoint.ignore;
            [waypoint dbUpdateIgnore];
            if (waypoint.ignore == YES) {
                [[dbc Group_AllWaypoints_Ignored] dbAddWaypoint:waypoint._id];
            } else {
                [[dbc Group_AllWaypoints_Ignored] dbRemoveWaypoint:waypoint._id];
            }
            return;
        case 4: // Add waypoint to a group
            [self addToGroup];
            return;
    }

    [super didSelectedMenu:menu atIndex:index];
}

- (void)addToGroup
{
    NSMutableArray *groups = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *groupNames = [NSMutableArray arrayWithCapacity:10];
    [[dbc Groups] enumerateObjectsUsingBlock:^(dbGroup *cg, NSUInteger idx, BOOL *stop) {
        if (cg.usergroup == 0)
            return;
        [groupNames addObject:cg.name];
        [groups addObject:cg];
    }];

    [ActionSheetStringPicker showPickerWithTitle:@"Select a Group"
        rows:groupNames
        initialSelection:[myConfig lastAddedGroup]
        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [myConfig lastAddedGroupUpdate:selectedIndex];
            dbGroup *group = [groups objectAtIndex:selectedIndex];
            [group dbRemoveWaypoint:waypoint._id];
            [group dbAddWaypoint:waypoint._id];
        }
        cancelBlock:^(ActionSheetStringPicker *picker) {
            NSLog(@"Block Picker Canceled");
        }
        origin:self.tableView
    ];
}

- (void)newWaypoint
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Add a related waypoint"
                               message:@"Lattitude is north and south\nLongitude is east and west\nUse 3679 for the direction"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action) {
                             //Do Some action
                             UITextField *tf = [alert.textFields objectAtIndex:0];
                             NSString *lat = tf.text;
                             NSLog(@"Lattitude '%@'", lat);

                             tf = [alert.textFields objectAtIndex:1];
                             NSString *lon = tf.text;
                             NSLog(@"Longitude '%@'", lon);

                             Coordinates *c;
                             c = [[Coordinates alloc] initString:lat lon:lon];

                             dbWaypoint *wp = [[dbWaypoint alloc] init:0];
                             wp.lat = [c lat_decimalDegreesSigned];
                             wp.lon = [c lon_decimalDegreesSigned];
                             wp.lat_int = [c lat] * 1000000;
                             wp.lon_int = [c lon] * 1000000;
                             wp.name = [dbWaypoint makeName:[waypoint.name substringFromIndex:2]];
                             wp.description = wp.name;
                             wp.date_placed_epoch = time(NULL);
                             wp.date_placed = [MyTools dateString:wp.date_placed_epoch];
                             wp.url = nil;
                             wp.urlname = wp.name;
                             wp.symbol_id = 1;
                             wp.type_id = [dbc Type_Unknown]._id;
                             [dbWaypoint dbCreate:wp];

                             [dbc.Group_AllWaypoints_ManuallyAdded dbAddWaypoint:wp._id];
                             [dbc.Group_AllWaypoints dbAddWaypoint:wp._id];

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
        textField.placeholder = @"Lattitude (like S 12 34.567)";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
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

- (void)refreshWaypoint
{
    [self performSelectorInBackground:@selector(runRefreshWaypoint) withObject:nil];
}

- (void)runRefreshWaypoint
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Refresh waypoint"];
    }];
    [waypoint.account.remoteAPI updateWaypoint:waypoint];
    [self.tableView reloadData];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [DejalBezelActivityView removeViewAnimated:NO];
     }];
}

@end
