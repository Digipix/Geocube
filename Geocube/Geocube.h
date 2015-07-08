//
//  Geocube.h
//  Geocube
//
//  Created by Edwin Groothuis on 28/06/2015.
//  Copyright (c) 2015 Edwin Groothuis. All rights reserved.
//

#ifndef Geocube_Geocube_h
#define Geocube_Geocube_h

#import "database.h"
#import "database-cache.h"
#import "dbObjects.h"
#import "GlobalMenu.h"
#import "AppDelegate.h"
#import "ImageLibrary.h"

// Global menu
extern GlobalMenu *menuGlobal;

// Database handle
extern database *db;
extern DatabaseCache *dbc;

// Images
extern ImageLibrary *imageLibrary;

//
extern AppDelegate *_AppDelegate;

#endif
