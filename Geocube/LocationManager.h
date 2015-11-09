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

@protocol LocationManagerDelegate

- (void)updateLocationManagerLocation;

@optional
- (void)updateLocationManagerHistory;

@end

@interface LocationManager : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *_LM;

    CLLocationAccuracy accuracy;
    CLLocationDistance altitude;
    CLLocationDirection direction;
    CLLocationCoordinate2D coords;

    NSMutableArray *coordsHistorical;
    NSDate *lastHistory;
    CLLocationCoordinate2D coordsHistoricalLast;
    float speed;
}

@property (nonatomic, retain) NSMutableArray *delegates;
@property (nonatomic) float speed;

@property (nonatomic) CLLocationAccuracy accuracy;
@property (nonatomic) CLLocationDistance altitude;
@property (nonatomic) CLLocationDirection direction;
@property (nonatomic) CLLocationCoordinate2D coords;
@property (nonatomic) NSMutableArray *coordsHistorical;

- (void)startDelegation:(id)delegate isNavigating:(BOOL)isNavigating;
- (void)stopDelegation:(id)delegate;
- (void)updateDataDelegate;

@end

@interface GCCoordsHistorical : NSObject {
    NSTimeInterval when;
    CLLocationCoordinate2D coord;
}

@property (nonatomic) NSTimeInterval when;
@property (nonatomic) CLLocationCoordinate2D coord;

@end
