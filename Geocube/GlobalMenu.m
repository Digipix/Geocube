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

#define MENU_STRING @"GC"

@implementation GlobalMenu

@synthesize parent_vc, previous_vc, localMenuDelegate, localMenuButton;

- (id)init
{
    self = [super init];
    items = [NSArray arrayWithObjects:@"Navigate", @"XCaches Online", @"Caches Offline", @"XNotes and Logs", @"XTrackables", @"Groups", @"XBookmarks", @"Files", @"XUser Profile", @"XNotices", @"Settings", @"Help", nil];

    //    NSString *imgfile = [NSString stringWithFormat:@"%@/global menu icon.png", [MyTools DataDistributionDirectory]];
    //    UIImage *img = [UIImage imageNamed:imgfile];

    button = [[UIBarButtonItem alloc] initWithTitle:MENU_STRING style:UIBarButtonItemStylePlain target:nil action:@selector(openGlobalMenu:)];
    button.tintColor = [UIColor whiteColor];

    numberOfItemsInRow = 3;

    return self;
}

- (void)setLocalMenuTarget:(UIViewController<DOPNavbarMenuDelegate> *)_vc
{
    // NSLog(@"GlobalMenu/setTarget: from %p to %p", parent_vc, _vc);
    previous_vc = parent_vc;
    parent_vc = _vc;
    button.target = _vc;
    localMenuDelegate = _vc;
}

- (DOPNavbarMenu *)global_menu
{
    if (_global_menu == nil) {
        NSMutableArray *menuoptions = [[NSMutableArray alloc] initWithCapacity:20];

        NSEnumerator *e = [items objectEnumerator];
        NSString *menuitem;
        while ((menuitem = [e nextObject]) != nil) {
            BOOL enabled = YES;
            if ([[menuitem substringWithRange:NSMakeRange(0, 1)] compare:@"X"] == NSOrderedSame) {
                enabled = NO;
                menuitem = [menuitem substringFromIndex:1];
            }
            DOPNavbarMenuItem *item = [DOPNavbarMenuItem ItemWithTitle:menuitem icon:[UIImage imageNamed:@"Image"] enabled:enabled];
            [menuoptions addObject:item];
        }

        _global_menu = [[DOPNavbarMenu alloc] initWithItems:menuoptions width:parent_vc.view.dop_width maximumNumberInRow:numberOfItemsInRow];
        _global_menu.backgroundColor = [UIColor blackColor];
        _global_menu.separatarColor = [UIColor whiteColor];
        _global_menu.menuName = MENU_STRING;
        _global_menu.delegate = self;
    }
    return _global_menu;
}

- (void)openLocalMenu:(id)sender
{
    if (localMenuDelegate != nil)
        [localMenuDelegate openLocalMenu:sender];
}

- (void)openGlobalMenu:(id)sender
{
    // NSLog(@"GlobalMenu/openMenu: self.vc:%p", self.parent_vc);

    button.enabled = NO;
    if (self.global_menu.isOpen) {
        [self.global_menu dismissWithAnimation:YES];
    } else {
        [self.global_menu showInNavigationController:parent_vc.navigationController];
    }
}

- (void)didShowMenu:(DOPNavbarMenu *)menu
{
    // NSLog(@"GlobalMenu/didShowMenu: self.vc:%p", self.parent_vc);

    [button setTitle:MENU_STRING];
    button.enabled = NO;
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu
{
    // NSLog(@"GlobalMenu/didDismissMenu: self.vc:%p", self.parent_vc);

    [button setTitle:MENU_STRING];
    button.enabled = YES;
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index
{
    // NSLog(@"GlobalMenu/didSelectedMenu: self.vc:%p", self.parent_vc);

    NSLog(@"Switching to %ld", (long)index);
    [_AppDelegate switchController:index];
}

@end
