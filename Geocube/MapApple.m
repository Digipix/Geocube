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

@interface MapApple ()
{
    GCPointAnnotation *me;
    NSMutableArray *markers;
    NSMutableArray *circles;

    MKPolyline *lineMeToWaypoint;
    MKPolylineRenderer *viewLineMeToWaypoint;
    MKPolyline *lineHistory;
    MKPolylineRenderer *viewLineHistory;

    BOOL circlesShown;
}

@end

@implementation MapApple

- (BOOL)mapHasViewMap
{
    return YES;
}

- (BOOL)mapHasViewSatellite
{
    return YES;
}

- (BOOL)mapHasViewHybrid
{
    return YES;
}

- (BOOL)mapHasViewTerrain;
{
    return NO;
}


- (void)mapViewWillAppear
{
    if (self.mapvc.isMovingToParentViewController)
        [myConfig addDelegate:self];
}

- (void)mapViewWillDisappear
{
    if (self.mapvc.isMovingFromParentViewController)
        [myConfig deleteDelegate:self];
}

- (void)startActivityViewer:(NSString *)text
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [DejalBezelActivityView activityViewForView:mapView withLabel:@"Refresh waypoint"];
    }];
}

- (void)stopActivityViewer
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [DejalBezelActivityView removeViewAnimated:NO];
    }];
}

- (void)initMap
{
    mapView = [[MKMapView alloc] initWithFrame:self.mapvc.view.frame];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;

    mapvc.view = mapView;

    /* Add the scale ruler */
    mapScaleView = [LXMapScaleView mapScaleForAMSMapView:mapView];
    mapScaleView.position = kLXMapScalePositionBottomLeft;
    mapScaleView.style = kLXMapScaleStyleBar;

    // Add a new waypoint
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [mapView addGestureRecognizer:lpgr];

    [self initWaypointInfo];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];

    [mapvc addNewWaypoint:touchMapCoordinate];
}

- (void)removeMap
{
    mapView = nil;
    mapScaleView = nil;
}

- (void)initCamera:(CLLocationCoordinate2D)coords
{
    /* Place camera on a view of 1500 x 1500 meters */
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coords, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:NO];
}

- (void)removeCamera
{
}

- (void)placeMarkers
{
    NSLog(@"%@/placeMarkers", [self class]);
    // Creates a marker in the center of the map.
    markers = [NSMutableArray arrayWithCapacity:20];
    [mapvc.waypointsArray enumerateObjectsUsingBlock:^(dbWaypoint *wp, NSUInteger idx, BOOL *stop) {
        // Place a single pin
        GCPointAnnotation *annotation = [[GCPointAnnotation alloc] init];
        CLLocationCoordinate2D coord = wp.coordinates;
        [annotation setCoordinate:coord];

        annotation._id = wp._id;
        annotation.name = wp.wpt_name;

        annotation.title = wp.wpt_name;
        annotation.subtitle = wp.wpt_urlname;

        [markers addObject:annotation];
    }];
    [mapView addAnnotations:markers];
}

- (void)removeMarkers
{
    NSLog(@"%@/removeMarkers", [self class]);
    [markers enumerateObjectsUsingBlock:^(MKPointAnnotation *m, NSUInteger idx, BOOL *stop) {
        [mapView removeAnnotation:m];
        m = nil;
    }];
    [mapView removeAnnotations:markers];
    markers = nil;
}

- (void)showCircles
{
    circlesShown = YES;
    circles = [NSMutableArray arrayWithCapacity:20];
    [mapvc.waypointsArray enumerateObjectsUsingBlock:^(dbWaypoint *wp, NSUInteger idx, BOOL *stop) {
        if (circlesShown == YES && wp.account.distance_minimum != 0 && wp.wpt_type.hasBoundary == YES) {
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:wp.coordinates radius:wp.account.distance_minimum];
            [mapView addOverlay:circle];
            [circles addObject:circle];
        }
    }];
}

- (void)hideCircles
{
    circlesShown = NO;
    [circles enumerateObjectsUsingBlock:^(MKCircle *c, NSUInteger idx, BOOL *stop) {
        [mapView removeOverlay:c];
        c = nil;
    }];
    circles = nil;
}

- (void)mapCallOutPressed:(id)sender
{
    MKPointAnnotation *ann = [[mapView selectedAnnotations] objectAtIndex:0];
    NSLog(@"%@", ann.title);
    [super openWaypointView:ann.title];
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GCPointAnnotation class]] == YES) {
        GCPointAnnotation *a = annotation;
        MKPinAnnotationView *dropPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"venues"];

        dbWaypoint *wp = [waypointManager waypoint_byId:a._id];
        dropPin.image = [self waypointImage:wp];

        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [disclosureButton addTarget:self action:@selector(mapCallOutPressed:) forControlEvents:UIControlEventTouchUpInside];

        dropPin.rightCalloutAccessoryView = disclosureButton;
        dropPin.canShowCallout = NO;

        return dropPin;
    }

    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[GCPointAnnotation class]]) {
        GCPointAnnotation *pa = (GCPointAnnotation *)view.annotation;
        dbWaypoint *wp = [dbWaypoint dbGet:pa._id];
        [self updateWaypointInfo:wp];
        [self showWaypointInfo];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[GCPointAnnotation class]]) {
        [self hideWaypointInfo];
        wpInfoView.hidden = YES;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if (overlay == lineMeToWaypoint) {
        if (viewLineMeToWaypoint == nil) {
            viewLineMeToWaypoint = [[MKPolylineRenderer alloc] initWithPolyline:lineMeToWaypoint];
            viewLineMeToWaypoint.fillColor = myConfig.mapDestinationColour;
            viewLineMeToWaypoint.strokeColor = myConfig.mapDestinationColour;
            viewLineMeToWaypoint.lineWidth = 5;
        }

        return viewLineMeToWaypoint;
    }

    if (overlay == lineHistory) {
        if (viewLineHistory == nil) {
            viewLineHistory = [[MKPolylineRenderer alloc] initWithPolyline:lineHistory];
            viewLineHistory.fillColor = myConfig.mapTrackColour;
            viewLineHistory.strokeColor = myConfig.mapTrackColour;
            viewLineHistory.lineWidth = 5;
        }

        return viewLineHistory;
    }

    __block MKCircleRenderer *circleRenderer = nil;
    [circles enumerateObjectsUsingBlock:^(MKCircle *c, NSUInteger idx, BOOL *stop) {
        if (overlay == c) {
            circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
            circleRenderer.strokeColor = [UIColor blueColor];
            circleRenderer.fillColor = [UIColor colorWithRed:0 green:0 blue:0.35 alpha:0.05];
            circleRenderer.lineWidth = 1;
            *stop = YES;
        }
    }];

    return circleRenderer;
}

- (void)moveCameraTo:(CLLocationCoordinate2D)coord zoom:(BOOL)zoom
{
    CLLocationCoordinate2D t = coord;

    if (zoom == YES) {
        NSInteger span = [self calculateSpan];

        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(t, span, span);
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
        [mapView setRegion:adjustedRegion animated:NO];
    }

    [mapView setCenterCoordinate:t animated:YES];
}

- (void)moveCameraTo:(CLLocationCoordinate2D)c1 c2:(CLLocationCoordinate2D)c2
{
    CLLocationCoordinate2D d1, d2;
    [Coordinates makeNiceBoundary:c1 c2:c2 d1:&d1 d2:&d2];

    NSMutableArray *coords = [NSMutableArray arrayWithCapacity:2];
    MKPointAnnotation *annotation;

    annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:d1];
    [coords addObject:annotation];

    annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:d2];
    [coords addObject:annotation];

    [mapView showAnnotations:coords animated:YES];

    [mapView removeAnnotations:coords];
}

- (void)setMapType:(NSInteger)mapType
{
    switch (mapType) {
        case MAPTYPE_NORMAL:
            mapView.mapType = MKMapTypeStandard;
            break;
        case MAPTYPE_SATELLITE:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case MAPTYPE_HYBRID:
            mapView.mapType = MKMapTypeHybrid;
            break;
    }
}

- (void)addLineMeToWaypoint
{
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = LM.coords;
    coordinateArray[1] = waypointManager.currentWaypoint.coordinates;

    lineMeToWaypoint = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    [mapView addOverlay:lineMeToWaypoint];
}

- (void)removeLineMeToWaypoint
{
    [mapView removeOverlay:lineMeToWaypoint];
    viewLineMeToWaypoint = nil;
    lineMeToWaypoint = nil;
}

- (void)addHistory
{
    CLLocationCoordinate2D coordinateArray[[LM.coordsHistorical count]];

    NSInteger idx = 0;
    for (GCCoordsHistorical *mho in LM.coordsHistorical) {
        coordinateArray[idx++] = mho.coord;
    }

    lineHistory = [MKPolyline polylineWithCoordinates:coordinateArray count:[LM.coordsHistorical count]];
    [mapView addOverlay:lineHistory];
}

- (void)removeHistory
{
    [mapView removeOverlay:lineHistory];
    viewLineHistory= nil;
    lineHistory= nil;
}

- (CLLocationCoordinate2D)currentCenter
{
    return [mapView centerCoordinate];
}

- (void)updateMyBearing:(CLLocationDirection)bearing
{
//    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

#pragma mark -- delegation from the map

// From http://stackoverflow.com/questions/5556977/determine-if-mkmapview-was-dragged-moved moby
- (BOOL)mapViewRegionDidChangeFromUserInteraction
{
    UIView *view = self.mapvc.view.subviews.firstObject;
    //  Look through gesture recognizers to determine whether this region change is from user interaction
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateEnded) {
            return YES;
        }
    }

    return NO;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    BOOL mapChangedFromUserInteraction = [self mapViewRegionDidChangeFromUserInteraction];

    if (mapChangedFromUserInteraction)
        [mapvc userInteraction];

    // Update the ruler
    [mapScaleView update];
}

#pragma mark -- delegation from MyConfig

- (void)changeMapClusters:(BOOL)enable zoomLevel:(float)zoomLevel
{
    [self removeMarkers];
    [self placeMarkers];
}

@end
