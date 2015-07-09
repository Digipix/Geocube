//
//  GroupsViewControllerViewController.m
//  Geocube
//
//  Created by Edwin Groothuis on 30/06/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

#import "Geosphere-Prefix.pch"

@implementation GCViewController

@synthesize numberOfItemsInRow, tab_menu, global_menu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberOfItemsInRow = 3;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Local" style:UIBarButtonItemStylePlain target:self action:@selector(openMenu:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [menuGlobal addButtons:self numberOfItemsInRow:self.numberOfItemsInRow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // NSLog(@"GCTableViewController/viewWillAppear: self:%p", self);

    [menuGlobal setTarget:self];
    [menuGlobal didDismissMenu:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DOPNavbarMenu *)tab_menu
{
    if (tab_menu == nil) {
        DOPNavbarMenuItem *item_empty = [DOPNavbarMenuItem ItemWithTitle:@"empty" icon:[UIImage imageNamed:@"Image"]];
        tab_menu = [[DOPNavbarMenu alloc] initWithItems:@[item_empty] width:self.view.dop_width maximumNumberInRow:numberOfItemsInRow];
        tab_menu.backgroundColor = [UIColor blackColor];
        tab_menu.separatarColor = [UIColor whiteColor];
        tab_menu.menuName = @"Local";
        tab_menu.delegate = self;
    }
    return tab_menu;
}


- (void)openMenu:(id)sender
{
    if (sender != self.navigationItem.rightBarButtonItem) {
        [menuGlobal openMenu:sender];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.tab_menu.isOpen) {
        [self.tab_menu dismissWithAnimation:YES];
    } else {
        [self.tab_menu showInNavigationController:self.navigationController];
    }
}

- (void)didShowMenu:(DOPNavbarMenu *)menu
{
    if (menu != self.tab_menu) {
        [menuGlobal didShowMenu:menu];
        return;
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:@"dismiss"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu
{
    if (menu != self.tab_menu) {
        [menuGlobal didDismissMenu:menu];
        return;
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:menu.menuName];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    if (menu != self.tab_menu) {
        [menuGlobal didSelectedMenu:menu atIndex:index];
        return;
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"you selected" message:[NSString stringWithFormat:@"number %@", @(index+1)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

@end