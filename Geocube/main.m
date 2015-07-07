//
//  main.m
//  Geocube
//
//  Created by Edwin Groothuis on 28/06/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "database.h"
#import "dbObjects.h"
#import "GlobalMenu.h"
#import "ImageLibrary.h"

GlobalMenu *menuGlobal;

// Database handle
database *db = nil;

// In memory objects from the database
NSArray *WaypointTypes = nil;
NSArray *WaypointGroups = nil;
NSArray *Waypoints = nil;

// System groups
dbObjectWaypointGroup *WaypointGroup_AllWaypoints = nil;
dbObjectWaypointGroup *WaypointGroup_AllWaypoints_Found = nil;
dbObjectWaypointGroup *WaypointGroup_AllWaypoints_NotFound = nil;
dbObjectWaypointGroup *WaypointGroup_LastImport = nil;
dbObjectWaypointGroup *WaypointGroup_LastImportAdded = nil;

// Waypoint types
dbObjectWaypointType *WaypointType_Unknown = nil;

// Image Library
ImageLibrary *imageLibrary = nil;

//
AppDelegate *_AppDelegate;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
