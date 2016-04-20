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
{
    NSMutableArray *tabBars;
}

@property (strong, nonatomic) UIWindow *window;

@end

@implementation AppDelegate

@synthesize tabBars, currentTabBar;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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

    // Initialize imagesDownloader
    imagesDownloadManager = [[ImagesDownloadManager alloc] init];

    // Initialize and cache the database - after file manager
    db = [[database alloc] init];
    [db checkVersion];
    dbc = [[DatabaseCache alloc] init];

    // Initialize the configuration manager - after db
    myConfig = [[MyConfig alloc] init];

    // Initialize Google Maps -- after db, myConfig
    [GMSServices provideAPIKey:myConfig.keyGMS];

    // Clean the map cache - after myconfig
    [MapAppleCache cleanupCache];

    // Auto rotate the kept tracks
    [KeepTrackTracks trackAutoRotate];

    // Audio
    audioFeedback = [[AudioFeedback alloc] init];
    [audioFeedback togglePlay:myConfig.soundDirection];

    // Initialize the theme - after myconfig
    themeManager = [[ThemeManager alloc] init];
    [themeManager setTheme:myConfig.themeType];

    // Waypoint Manager - after myConfig, LM, db
    waypointManager = [[WaypointManager alloc] init];
    [dbc loadWaypointData];

    // Initialize the image library
    imageLibrary = [[ImageLibrary alloc] init];

    // Initialize the tabbar controllers

    NSMutableArray *controllers;
    UINavigationController *nav;
    UIViewController *vc;

    tabBars = [[NSMutableArray alloc] initWithCapacity:RC_MAX];

#define TABBARCONTROLLER(__controllers__) \
    tabBarController = [[UITabBarController alloc] init]; \
    tabBarController.tabBar.translucent = NO; \
    tabBarController.viewControllers = __controllers__; \
    tabBarController.customizableViewControllers = __controllers__; \
    tabBarController.delegate = self; \
    [tabBars addObject:tabBarController];
#undef TABBARCONTROLLER
#define TABBARCONTROLLER(index, __controllers__) { \
        BHTabsViewController *tbc = \
            [[BHTabsViewController alloc] \
            initWithViewControllers:index \
            viewControllers:__controllers__ \
            style:[BHTabStyle defaultStyle]]; \
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

                vc = [[TrackablesViewController alloc] init];
                vc.title = @"Trackables";
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

            case RC_USERPROFILE:
                controllers = [NSMutableArray array];

                vc = [[UserProfileViewController alloc] init];
                vc.title = @"User Profile";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                TABBARCONTROLLER(RC_USERPROFILE, controllers)
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

                vc = [[SettingsMainViewController alloc] init];
                vc.title = @"Settings";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[SettingsAccountsViewController alloc] init];
                vc.title = @"Accounts";
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

                vc = [[HighlightListViewController alloc] init];
                vc.title = @"Highlight";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[FoundListViewController alloc] init];
                vc.title = @"Found";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[DNFListViewController alloc] init];
                vc.title = @"DNF";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[InProgressListViewController alloc] init];
                vc.title = @"In Progress";
                nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                [controllers addObject:nav];

                vc = [[IgnoredListViewController alloc] init];
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

            default:
                NSAssert1(FALSE, @"Tabbar missing item %ld", (long)i);

        }
    }

    // UIResponder.window = UIWIndow
    // UIWindow.rootViewController = UITabBarController
    // UITabBarController.viewControllers = [UIViewController ...]

    [self switchController:myConfig.currentPage];
    BHTabsViewController *currentTab = [tabBars objectAtIndex:myConfig.currentPage];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = currentTab;
    NSInteger cpt = myConfig.currentPageTab;

    [self.window makeKeyAndVisible];
    [currentTab makeTabViewCurrent:cpt];

    btc = [_AppDelegate.tabBars objectAtIndex:RC_BROWSER];
    UINavigationController *nvc = [btc.viewControllers objectAtIndex:VC_BROWSER_BROWSER];
    bbvc = [nvc.viewControllers objectAtIndex:0];

    /* No site information yet? */
    dbConfig *db = [dbConfig dbGetByKey:@"sites_revision"];
    if (db == nil) {
        [self switchController:RC_NOTICES];
        currentTab = [tabBars objectAtIndex:RC_NOTICES];
        cpt = VC_NOTICES_NOTICES;
        [currentTab makeTabViewCurrent:cpt];
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
    [tabBars enumerateObjectsUsingBlock:^(BHTabsViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
