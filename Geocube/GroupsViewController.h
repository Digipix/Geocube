//
//  GroupsVIewControllerViewController.h
//  Geocube
//
//  Created by Edwin Groothuis on 30/06/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPNavbarMenu.h"

@interface GroupsViewController : UITableViewController <UITextViewDelegate, DOPNavbarMenuDelegate> {
    NSInteger wpgCount;
    NSArray *wpgs;
}

@property (assign, nonatomic) NSInteger numberOfItemsInRow;
@property (strong, nonatomic) DOPNavbarMenu *tab_menu, *global_menu;

- (id)init:(BOOL)showUsers;

@end
