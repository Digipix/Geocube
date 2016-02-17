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

@interface WaypointViewController ()
{
    dbWaypoint *waypoint;
}

@end

enum {
    WAYPOINT_HEADER,
    WAYPOINT_DATA,
    WAYPOINT_ACTIONS,
    WAYPOINT_MAX,

    WAYPOINT_HEADER_WAYPOINT = 0,
    WAYPOINT_HEADER_MAX,

    WAYPOINT_DATA_DESCRIPTION = 0,
    WAYPOINT_DATA_HINT,
    WAYPOINT_DATA_PERSONALNOTE,
    WAYPOINT_DATA_FIELDNOTES,
    WAYPOINT_DATA_LOGS,
    WAYPOINT_DATA_ATTRIBUTES,
    WAYPOINT_DATA_ADDITIONALWAYPOINTS,
    WAYPOINT_DATA_INVENTORY,
    WAYPOINT_DATA_IMAGES,
    WAYPOINT_DATA_GROUPMEMBERS,
    WAYPOINT_DATA_MAX,

    WAYPOINT_ACTIONS_SETASTARGET = 0,
    WAYPOINT_ACTIONS_LOGTHISWAYPOINT,
    WAYPOINT_ACTIONS_OPENINBROWSER,
    WAYPOINT_ACTIONS_MAX,
};

#define THISCELL_HEADER @"Waypointtablecell_header"
#define THISCELL_DATA @"Waypointtablecell_data"
#define THISCELL_ACTIONS @"Waypointtablecell_actions"

@implementation WaypointViewController

enum {
    menuAddWaypoint = 0,
    menuHighlight,
    menuRefreshWaypoint,
    menuIgnore,
    menuMarkFound,
    menuInProgress,
    menuAddToGroup,
    menuViewRaw,
    menuMax
};

- (instancetype)initWithStyle:(UITableViewStyle)style canBeClosed:(BOOL)canBeClosed
{
    self = [super initWithStyle:style];

    lmi = [[LocalMenuItems alloc] init:menuMax];
    [lmi addItem:menuAddWaypoint label:@"Add waypoint"];
    [lmi addItem:menuHighlight label:@"Highlight"];
    [lmi addItem:menuMarkFound label:@"Mark Found"];
    [lmi addItem:menuInProgress label:@"In Progress"];
    [lmi addItem:menuRefreshWaypoint label:@"Refresh waypoint"];
    [lmi addItem:menuAddToGroup label:@"Add to group"];
    [lmi addItem:menuIgnore label:@"Ignore"];
    [lmi addItem:menuViewRaw label:@"Raw data"];

    hasCloseButton = canBeClosed;

    return self;
}

- (void)showWaypoint:(dbWaypoint *)_wp
{
    waypoint = _wp;

    if (waypoint.flag_highlight == YES) {
        [lmi changeItem:menuHighlight label:@"Unhighlight"];
    } else {
        [lmi changeItem:menuHighlight label:@"Highlight"];
    }
    [self refreshMenu];

    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // Restore
    if (hasCloseButton == NO)
        [self showWaypoint:waypointManager.currentWaypoint];

    [self.tableView registerClass:[WaypointHeaderTableViewCell class] forCellReuseIdentifier:THISCELL_HEADER];
    [self.tableView registerClass:[GCTableViewCell class] forCellReuseIdentifier:THISCELL_DATA];
    [self.tableView registerClass:[GCTableViewCellRightImage class] forCellReuseIdentifier:THISCELL_ACTIONS];
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
    return WAYPOINT_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (waypoint == nil)
        return 0;
    switch (section) {
        case WAYPOINT_HEADER:
            return WAYPOINT_HEADER_MAX;
        case WAYPOINT_DATA:
            return WAYPOINT_DATA_MAX;
        case WAYPOINT_ACTIONS:
            return WAYPOINT_ACTIONS_MAX;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case WAYPOINT_DATA:
            return @"Waypoint data";
        case WAYPOINT_ACTIONS:
            return @"Waypoint actions";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != WAYPOINT_HEADER)
        return [super tableView:tableView viewForHeaderInSection:section];

    NSInteger width = tableView.bounds.size.width;

    GCView *headerView = [[GCView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
    GCLabel *l;

    UIColor *backgroundColor = [UIColor clearColor];
    if (waypoint.flag_highlight == YES)
       backgroundColor = [UIColor yellowColor];

    l = [[GCLabel alloc] initWithFrame:CGRectMake (0, 0, width, 15)];
    l.text = waypoint.wpt_urlname;
    l.font = [UIFont boldSystemFontOfSize:14];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = backgroundColor;
    [headerView addSubview:l];

    l = [[GCLabel alloc] initWithFrame:CGRectMake (0, 15, width, 10)];
    NSMutableString *s = [NSMutableString stringWithString:@""];
    if (waypoint.gs_placed_by != nil && [waypoint.gs_placed_by isEqualToString:@""] == NO)
        [s appendFormat:@"by %@", waypoint.gs_placed_by];
    if ([waypoint.wpt_date_placed isEqualToString:@""] == NO)
        [s appendFormat:@" on %@", [MyTools datetimePartDate:waypoint.wpt_date_placed]];
    l.text = s;
    l.font = [UIFont systemFontOfSize:10];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = backgroundColor;
    [headerView addSubview:l];

    l = [[GCLabel alloc] initWithFrame:CGRectMake (0, 25, width, 12)];
    l.text = [NSString stringWithFormat:@"%@ (%@)", waypoint.wpt_name, waypoint.account.site];
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = backgroundColor;
    [headerView addSubview:l];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == WAYPOINT_HEADER)
        return 37;
    return [super tableView:tableView heightForHeaderInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.section) {
        case WAYPOINT_HEADER: {
            WaypointHeaderTableViewCell *cell = [[WaypointHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_HEADER];
            cell.accessoryType = UITableViewCellAccessoryNone;
            Coordinates *c = [[Coordinates alloc] init:waypoint.wpt_lat_float lon:waypoint.wpt_lon_float];
            cell.lat.text = [c lat_degreesDecimalMinutes];
            cell.lon.text = [c lon_degreesDecimalMinutes];
            [cell setRatings:waypoint.gs_favourites terrain:waypoint.gs_rating_terrain difficulty:waypoint.gs_rating_difficulty];

            cell.userInteractionEnabled = NO;
            cell.size.image = [imageLibrary get:waypoint.gs_container.icon];
            cell.icon.image = [imageLibrary getType:waypoint];

            return cell;
        }

        case WAYPOINT_DATA: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THISCELL_DATA forIndexPath:indexPath];
            if (cell == nil)
                cell = [[GCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_DATA];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;

            UIColor *tc = currentTheme.textColor;
            switch (indexPath.row) {

               case WAYPOINT_DATA_DESCRIPTION:
                    cell.textLabel.text = @"Description";
                    if ([waypoint.gs_short_desc isEqualToString:@""] == YES && [waypoint.gs_long_desc isEqualToString:@""] == YES && [waypoint.description isEqualToString:@""] == YES) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = NO;
                    }
                    break;

                case WAYPOINT_DATA_HINT:
                    cell.textLabel.text = @"Hint";
                    if (waypoint.gs_hint == nil || [waypoint.gs_hint isEqualToString:@""] == YES || [waypoint.gs_hint isEqualToString:@" "] == YES) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = NO;
                    }
                    break;

                case WAYPOINT_DATA_PERSONALNOTE:
                    cell.textLabel.text = @"Personal Note";
                    if ([dbPersonalNote dbGetByWaypointID:waypoint._id] == nil) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = YES;     // Be able to create one
                    }
                    break;

                case WAYPOINT_DATA_FIELDNOTES: {
                    cell.textLabel.text = @"Field Notes";
                    NSInteger c = [waypoint hasFieldNotes];
                    if (c == 0) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = NO;
                    } else
                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", cell.textLabel.text, (long)c];
                    break;
                }

                case WAYPOINT_DATA_LOGS: {
                    cell.textLabel.text = @"Logs";
                    NSInteger c = [waypoint hasLogs];
                    if (c == 0) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = NO;
                    } else {
                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", cell.textLabel.text, (long)c];
                    }
                    break;
                }

                case WAYPOINT_DATA_ATTRIBUTES: {
                    cell.textLabel.text = @"Attributes";
                    NSInteger c = [waypoint hasAttributes];
                    if (c == 0) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = NO;
                    } else
                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", cell.textLabel.text, (long)c];
                    break;
                }

                case WAYPOINT_DATA_ADDITIONALWAYPOINTS: {
                    cell.textLabel.text = @"Additional Waypoints";
                    NSArray *wps = [waypoint hasWaypoints];
                    if ([wps count] <= 1) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = YES;     // Be able to create one
                    } else
                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", cell.textLabel.text, (long)([wps count] - 1)];
                    break;
                }

                case WAYPOINT_DATA_INVENTORY: {
                    cell.textLabel.text = @"Inventory";
                    NSInteger c = [waypoint hasInventory];
                    if (c == 0) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = NO;
                    } else
                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", cell.textLabel.text, (long)c];
                    break;
                }

                case WAYPOINT_DATA_IMAGES: {
                    cell.textLabel.text = @"Images";
                    NSInteger c = [waypoint hasImages];
                    if (c == 0) {
                        tc = currentTheme.labelTextColorDisabled;
                        cell.userInteractionEnabled = YES;  // Be able to create one
                    } else
                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",cell.textLabel.text, (long)c];
                    break;
                }

                case WAYPOINT_DATA_GROUPMEMBERS:
                    cell.textLabel.text = @"Group Members";
                    break;
            }
            cell.textLabel.textColor = tc;
            cell.imageView.image = nil;
            return cell;

        }

        case WAYPOINT_ACTIONS:
            switch (indexPath.row) {
                case WAYPOINT_ACTIONS_SETASTARGET: {
                    GCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THISCELL_ACTIONS forIndexPath:indexPath];
                    if (cell == nil)
                        cell = [[GCTableViewCellRightImage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_ACTIONS];
                    cell.userInteractionEnabled = YES;
                    cell.imageView.image = [imageLibrary get:ImageIcon_Target];
                    cell.textLabel.text = @"Set as target";
                    return cell;
                }

                case WAYPOINT_ACTIONS_LOGTHISWAYPOINT: {
                    GCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THISCELL_ACTIONS forIndexPath:indexPath];
                    if (cell == nil)
                        cell = [[GCTableViewCellRightImage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_ACTIONS];
                    cell.userInteractionEnabled = YES;
                    cell.imageView.image = [imageLibrary get:ImageIcon_Smiley];
                    cell.textLabel.text = @"Log this waypoint";
                    return cell;
                }

                case WAYPOINT_ACTIONS_OPENINBROWSER: {
                    GCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THISCELL_DATA forIndexPath:indexPath];
                    if (cell == nil)
                        cell = [[GCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THISCELL_ACTIONS];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.userInteractionEnabled = YES;

                    if (waypoint.wpt_url == nil)
                        cell.userInteractionEnabled = NO;

                    cell.textLabel.text = @"Open in browser";
                    return cell;
                }

            }
    }

    return nil;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case WAYPOINT_HEADER:
            return;

        case WAYPOINT_DATA:
            switch (indexPath.row) {
                case WAYPOINT_DATA_DESCRIPTION: {
                    UIViewController *newController = [[WaypointDescriptionViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_HINT: {
                    UIViewController *newController = [[WaypointHintViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_PERSONALNOTE: {
                    UIViewController *newController = [[WaypointPersonalNoteViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_FIELDNOTES: {
                    UITableViewController *newController = [[WaypointLogsViewController alloc] initMine:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_LOGS: {
                    UITableViewController *newController = [[WaypointLogsViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_ATTRIBUTES: {
                    UITableViewController *newController = [[WaypointAttributesViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_ADDITIONALWAYPOINTS: {
                    NSArray *wps = [waypoint hasWaypoints];
                    if ([wps count] <= 1) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                        [self newWaypoint];
                    } else {
                        UITableViewController *newController = [[WaypointWaypointsViewController alloc] init:waypoint];
                        newController.edgesForExtendedLayout = UIRectEdgeNone;
                        [self.navigationController pushViewController:newController animated:YES];
                    }
                    return;
                }

                case WAYPOINT_DATA_INVENTORY: {
                    UITableViewController *newController = [[WaypointTrackablesViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_IMAGES: {
                    UITableViewController *newController = [[WaypointImagesViewController alloc] init:waypoint table:self.tableView];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_DATA_GROUPMEMBERS: {
                    UITableViewController *newController = [[WaypointGroupsViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }
            }
            return;

        case WAYPOINT_ACTIONS:
            switch (indexPath.row) {
                case WAYPOINT_ACTIONS_SETASTARGET: {
                    if ([waypointManager currentWaypoint] != nil &&
                        [[waypointManager currentWaypoint].wpt_name isEqualToString:waypoint.wpt_name] == YES) {
                        [waypointManager setCurrentWaypoint:nil];
                        [self showWaypoint:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                        return;
                    }

                    [waypointManager setCurrentWaypoint:waypoint];
                    [self.tableView reloadData];

                    BHTabsViewController *tb = [_AppDelegate.tabBars objectAtIndex:RC_NAVIGATE];
                    UINavigationController *nvc = [tb.viewControllers objectAtIndex:VC_NAVIGATE_TARGET];
                    WaypointViewController *cvc = [nvc.viewControllers objectAtIndex:0];
                    [cvc showWaypoint:waypointManager.currentWaypoint];

                    nvc = [tb.viewControllers objectAtIndex:VC_NAVIGATE_MAP];
                    MapViewController *mvc = [nvc.viewControllers objectAtIndex:0];
                    [mvc refreshWaypointsData];

                    [_AppDelegate switchController:RC_NAVIGATE];
                    [tb makeTabViewCurrent:VC_NAVIGATE_COMPASS];
                    return;
                }

                case WAYPOINT_ACTIONS_LOGTHISWAYPOINT: {
                    UIViewController *newController = [[WaypointLogViewController alloc] init:waypoint];
                    newController.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:newController animated:YES];
                    return;
                }

                case WAYPOINT_ACTIONS_OPENINBROWSER: {
                    [_AppDelegate switchController:RC_BROWSER];
                    BHTabsViewController *btc = [_AppDelegate.tabBars objectAtIndex:RC_BROWSER];
                    UINavigationController *nvc = [btc.viewControllers objectAtIndex:VC_BROWSER_BROWSER];
                    BrowserBrowserViewController *bbvc = [nvc.viewControllers objectAtIndex:0];

                    [btc makeTabViewCurrent:VC_BROWSER_BROWSER];
                    [bbvc loadURL:waypoint.wpt_url];
                    return;
                }
            }

            return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == WAYPOINT_HEADER)
        return [WaypointTableViewCell cellHeight];
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Local menu related functions

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index
{
    switch (index) {
        case menuAddWaypoint: // Add a waypoint
            [self newWaypoint];
            return;
        case menuHighlight: // Highlight waypoint
            waypoint.flag_highlight = !waypoint.flag_highlight;
            [waypoint dbUpdateHighlight];
            [self.tableView reloadData];
            return;
        case menuRefreshWaypoint: // Refresh waypoint from server
            [self refreshWaypoint];
            return;
        case menuIgnore: // Ignore this waypoint
            waypoint.flag_ignore = !waypoint.flag_ignore;
            [waypoint dbUpdateIgnore];
            if (waypoint.flag_ignore == YES) {
                [[dbc Group_AllWaypoints_Ignored] dbAddWaypoint:waypoint._id];
            } else {
                [[dbc Group_AllWaypoints_Ignored] dbRemoveWaypoint:waypoint._id];
            }
            [self.tableView reloadData];
            return;
        case menuAddToGroup: // Add waypoint to a group
            [self addToGroup];
            return;
        case menuViewRaw:
            [self menuViewRaw];
            return;
        case menuInProgress:
            waypoint.flag_inprogress = !waypoint.flag_inprogress;
            [waypoint dbUpdateInProgress];
            [self.tableView reloadData];
            return;
        case menuMarkFound:
            waypoint.flag_markedfound = !waypoint.flag_markedfound;
            [waypoint dbUpdateMarkedFound];
            [self.tableView reloadData];
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
        initialSelection:myConfig.lastAddedGroup
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
                               message:@"Enter the coordinates"
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

                             dbWaypoint *wp = [[dbWaypoint alloc] init:0];
                             wp.wpt_lat = [c lat_decimalDegreesSigned];
                             wp.wpt_lon = [c lon_decimalDegreesSigned];
                             wp.wpt_lat_int = [c lat] * 1000000;
                             wp.wpt_lon_int = [c lon] * 1000000;
                             wp.wpt_name = [dbWaypoint makeName:[waypoint.wpt_name substringFromIndex:2]];
                             wp.wpt_description = wp.wpt_name;
                             wp.wpt_date_placed_epoch = time(NULL);
                             wp.wpt_date_placed = [MyTools dateString:wp.wpt_date_placed_epoch];
                             wp.wpt_url = nil;
                             wp.wpt_urlname = wp.wpt_name;
                             wp.wpt_symbol_id = 1;
                             wp.wpt_type_id = [dbc Type_Unknown]._id;
                             [dbWaypoint dbCreate:wp];

                             [dbc.Group_AllWaypoints_ManuallyAdded dbAddWaypoint:wp._id];
                             [dbc.Group_AllWaypoints dbAddWaypoint:wp._id];

                             [waypointManager needsRefresh];
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
        textField.placeholder = @"Latitude (like S 12 34.567)";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.inputView = [[KeyboardCoordinateView alloc] initWithIsLatitude:YES];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Longitude (like E 23 45.678)";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.inputView = [[KeyboardCoordinateView alloc] initWithIsLatitude:NO];
    }];

    [ALERT_VC_RVC(self) presentViewController:alert animated:YES completion:nil];
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
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [DejalBezelActivityView removeViewAnimated:NO];
     }];
    waypoint = [dbWaypoint dbGet:waypoint._id];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [MyTools playSound:playSoundImportComplete];
}

- (void)menuViewRaw
{
    UIViewController *newController = [[WaypointRawViewController alloc] init:waypoint];
    newController.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController pushViewController:newController animated:YES];
}

@end