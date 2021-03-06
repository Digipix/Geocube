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

@import GoogleMaps;

#import "Geocube-Prefix.pch"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize tabBars, currentTabBar;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _AppDelegate = self;

    // File manager
    fm = [[NSFileManager alloc] init];

    // Initialize the location mamager
    LM = [[LocationManager alloc] init];
    [LM startDelegation:nil isNavigating:NO];

    /* Create files directory */
    [fm createDirectoryAtPath:[MyTools FilesDir] withIntermediateDirectories:NO attributes:nil error:nil];

    // Initialize the global menu
    menuGlobal = [[GlobalMenu alloc] init];

    // Initialize the IOS File Transfer Manager - After file manager
    IOSFTM = [[IOSFileTransfers alloc] init];

    // Initialize and cache the database - after file manager
    db = [[database alloc] init];
    [db checkVersion];
    dbc = [[DatabaseCache alloc] init];
    [dbc loadCachableData]; // Explicit because it requires itself to be there.

    // Initialize the configuration manager - after db
    myConfig = [[MyConfig alloc] init];

    // Initialize Google Maps -- after db, myConfig
    [GMSServices provideAPIKey:myConfig.keyGMS];

    // Clean the map cache - after myconfig
    [MapAppleCache cleanupCache];

    // Auto rotate the kept tracks
    [KeepTrackTracks trackAutoRotate];
    [KeepTrackTracks trackAutoPurge];

    // Audio
    audioFeedback = [[AudioFeedback alloc] init];
    [audioFeedback togglePlay:myConfig.soundDirection];

    // Initialize the theme - after myconfig
    themeManager = [[ThemeManager alloc] init];
    [themeManager setTheme:myConfig.themeType];

    // Initialize the image library
    imageLibrary = [[ImageLibrary alloc] init];

    // Waypoint Manager - after myConfig, LM, db, imageLibrary
    waypointManager = [[WaypointManager alloc] init];

    // Initialize the tabbar controllers

    NSMutableArray *controllers;
    UINavigationController *nav;
    UIViewController *vc;

    tabBars = [[NSMutableArray alloc] initWithCapacity:RC_MAX];

#define TABBARCONTROLLER(index, __controllers__) { \
    MHTabBarController *tbc = [[MHTabBarController alloc] init]; \
    tbc.delegate = self; \
    tbc.viewControllers = __controllers__; \
    [tabBars addObject:tbc]; \
    }

    for (NSInteger i = 0; i < RC_MAX; i++) {
        switch (i) {
            case RC_NAVIGATE:
                controllers = [NSMutableArray array];

                vc = [[CompassViewController alloc] init];
                vc.title = @"Compass";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[WaypointViewController alloc] initWithStyle:UITableViewStyleGrouped canBeClosed:NO];
                vc.title = @"Target";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[MapViewController alloc] init:SHOW_ONEWAYPOINT];
                vc.title = @"Map";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_NAVIGATE, controllers)
                break;

            case RC_WAYPOINTS:
                controllers = [NSMutableArray array];

                vc = [[FiltersViewController alloc] init];
                vc.title = @"Filters";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[WaypointsOfflineListViewController alloc] init];
                vc.title = @"List";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[MapViewController alloc] init:SHOW_ALLWAYPOINTS];
                vc.title = @"Map";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_WAYPOINTS, controllers)
                break;

            case RC_KEEPTRACK:
                controllers = [NSMutableArray array];

                vc = [[KeepTrackCar alloc] init];
                vc.title = @"Car";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[KeepTrackTracks alloc] init];
                vc.title = @"Tracks";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_KEEPTRACK, controllers)
                break;

            case RC_NOTESANDLOGS:
                controllers = [NSMutableArray array];

                vc = [[NotesPersonalNotesViewController alloc] init];
                vc.title = @"Personal";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[NotesFieldnotesViewController alloc] init];
                vc.title = @"Field";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[NotesImagesViewController alloc] init];
                vc.title = @"Images";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_NOTESANDLOGS, controllers)
                break;

            case RC_TRACKABLES:
                controllers = [NSMutableArray array];

                vc = [[TrackablesInventoryViewController alloc] init];
                vc.title = @"Inventory";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[TrackablesMineViewController alloc] init];
                vc.title = @"Mine";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[TrackablesListViewController alloc] init];
                vc.title = @"List";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_TRACKABLES, controllers)
                break;

            case RC_GROUPS:
                controllers = [NSMutableArray array];

                vc = [[GroupsViewController alloc] init:YES];
                vc.title = @"User Groups";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[GroupsViewController alloc] init:NO];
                vc.title = @"System Groups";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_GROUPS, controllers)
                break;

            case RC_BROWSER:
                controllers = [NSMutableArray array];

                vc = [[BrowserUserViewController alloc] init];
                vc.title = @"User";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[BrowserAccountsViewController alloc] init];
                vc.title = @"Queries";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[BrowserBrowserViewController alloc] init];
                vc.title = @"Browser";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_BROWSER, controllers)
                break;

            case RC_FILES:
                controllers = [NSMutableArray array];

                vc = [[FilesViewController alloc] init];
                vc.title = @"Local Files";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_FILES, controllers)
                break;

            case RC_STATISTICS:
                controllers = [NSMutableArray array];

                vc = [[StatisticsViewController alloc] init];
                vc.title = @"Statistics";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_STATISTICS, controllers)
                break;

            case RC_NOTICES:
                controllers = [NSMutableArray array];

                vc = [[NoticesViewController alloc] init];
                vc.title = @"Notices";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_NOTICES, controllers)
                break;

            case RC_SETTINGS:
                controllers = [NSMutableArray array];

                vc = [[SettingsAccountsViewController alloc] init];
                vc.title = @"Accounts";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[SettingsMainViewController alloc] init];
                vc.title = @"Settings";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[SettingsColoursViewController alloc] init];
                vc.title = @"Colours";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_SETTINGS, controllers)
                break;

            case RC_HELP:
                controllers = [NSMutableArray array];

                vc = [[HelpAboutViewController alloc] init];
                vc.title = @"About";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[HelpHelpViewController alloc] init];
                vc.title = @"Help";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[HelpImagesViewController alloc] init];
                vc.title = @"Images";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[HelpDatabaseViewController alloc] init];
                vc.title = @"DB";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_HELP, controllers)
                break;

            case RC_LISTS:
                controllers = [NSMutableArray array];

                vc = [[ListHighlightViewController alloc] init];
                vc.title = @"Highlight";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[ListFoundViewController alloc] init];
                vc.title = @"Found";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[ListDNFViewController alloc] init];
                vc.title = @"DNF";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[ListInProgressViewController alloc] init];
                vc.title = @"In Progress";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[ListIgnoredViewController alloc] init];
                vc.title = @"Ignored";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_LISTS, controllers)
                break;

            case RC_QUERIES:
                controllers = [NSMutableArray array];

                vc = [[QueriesGroundspeakViewController alloc] init];
                vc.title = @"Groundspeak";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[QueriesGCAViewController alloc] init];
                vc.title = @"GCA";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_QUERIES, controllers)
                break;

            case RC_DOWNLOADS:
                controllers = [NSMutableArray array];

                vc = [[DownloadsImportsViewController alloc] init];
                vc.title = @"Downloads";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_DOWNLOADS, controllers)
                break;

            default:
                NSAssert1(FALSE, @"Tabbar missing item %ld", (long)i);

        }
    }

    // Switch back to the last page the user was on.
    [self switchController:myConfig.currentPage];
    MHTabBarController *currentTab = [tabBars objectAtIndex:myConfig.currentPage];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = currentTab;
    NSInteger cpt = myConfig.currentPageTab;

    [self.window makeKeyAndVisible];
    [currentTab setSelectedIndex:cpt animated:YES];

    // Browser View Controller
    browserTabController = [_AppDelegate.tabBars objectAtIndex:RC_BROWSER];
    UINavigationController *nvc = [browserTabController.viewControllers objectAtIndex:VC_BROWSER_BROWSER];
    browserViewController = [nvc.viewControllers objectAtIndex:0];

    // Download View Controller and Manager
    downloadTabController = [_AppDelegate.tabBars objectAtIndex:RC_DOWNLOADS];
    nvc = [downloadTabController.viewControllers objectAtIndex:VC_DOWNLOADS_DOWNLOADS];
    downloadsImportsViewController = [nvc.viewControllers objectAtIndex:0];
    downloadManager = [[DownloadManager alloc] init];
    downloadManager.downloadsImportsDelegate = downloadsImportsViewController;
    importManager = [[ImportManager alloc] init];
    importManager.downloadsImportsDelegate = downloadsImportsViewController;
    imagesDownloadManager = [[ImagesDownloadManager alloc] init];
    imagesDownloadManager.delegate = downloadsImportsViewController;

    /* No site information yet? */
    dbConfig *db = [dbConfig dbGetByKey:@"sites_revision"];
    if (db == nil) {
        [self switchController:RC_NOTICES];
        currentTab = [tabBars objectAtIndex:RC_NOTICES];
        cpt = VC_NOTICES_NOTICES;
        [currentTab setSelectedIndex:cpt animated:YES];
        [NoticesViewController AccountsNeedToBeInitialized];
    }

    // Cleanup imported information from iTunes -- after the viewcontroller has been generated
    [IOSFTM cleanupITunes];

    return YES;
}

- (void)switchController:(NSInteger)idx
{
    NSLog(@"AppDelegate: Switching to TB %ld", (long)idx);
    currentTabBar = idx;
    self.window.rootViewController = [tabBars objectAtIndex:idx];
    [self.window makeKeyAndVisible];
}

- (void)resizeControllers:(CGSize)size coordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [tabBars enumerateObjectsUsingBlock:^(MHTabBarController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [vc resizeController:size coordinator:coordinator];
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"import");
    [IOSFTM importAirdropAttachment:url];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"%@ - %@ - memory warning", [application class], [self class]);
}

- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %lu", tabBarController, viewController, (unsigned long)index);

    // Uncomment this to prevent "Tab 3" from being selected.
    //return (index != 2);

    return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %lu", tabBarController, viewController, (unsigned long)index);
}
@end
