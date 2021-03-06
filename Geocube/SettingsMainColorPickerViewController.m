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

@interface SettingsMainColorPickerViewController ()
{
    NSInteger type;
    UIButton *chooseButton, *resetButton;
    dbPin *dummyPin;
    UIColor *currentColour;
    UIImageView *previewColour;
    UILabel *hexLabel;
    NKOColorPickerView *colorPickerView;
}

@end

@implementation SettingsMainColorPickerViewController

- (instancetype)init:(NSInteger)_type
{
    self = [super init];

    type = _type;
    lmi = nil;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = [[UIScreen mainScreen] bounds];
    NSInteger y = 10;

    GCScrollView *contentView = [[GCScrollView alloc] initWithFrame:frame];
    self.view = contentView;

    GCLabel *l = [[GCLabel alloc] initWithFrame:CGRectMake(10, y, frame.size.width, 20)];
    switch (type) {
        case SettingsMainColorPickerTrack:
            l.text = @"Track";
            currentColour = myConfig.mapTrackColour;
            break;
        case SettingsMainColorPickerDestination:
            l.text = @"Destination";
            currentColour = myConfig.mapDestinationColour;
            break;
        default:
            l.text = @"Wot?";
            break;
    }
    [self.view addSubview:l];
    y += 20;

    /* Create pin data */

    dummyPin = [[dbPin alloc] init];
    dummyPin.rgb_default = [ImageLibrary ColorToRGB:currentColour];
    [dummyPin finish];
    dummyPin.img = [ImageLibrary newPinHead:dummyPin.colour];

    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *colour){
        dummyPin.img = [ImageLibrary newPinHead:colour];
        dummyPin.rgb = [ImageLibrary ColorToRGB:colour];
        hexLabel.text = dummyPin.rgb;
        currentColour = colour;
        previewColour.image = dummyPin.img;
    };
    colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 340) color:currentColour andDidChangeColorBlock:colorDidChangeBlock];
    [colorPickerView setColor:currentColour];
    [self.view addSubview:colorPickerView];
    y += 340;

    UIImage *img = dummyPin.img;
    previewColour = [[UIImageView alloc] initWithFrame:CGRectMake((15 + frame.size.width / 5 - img.size.width * 1.5) / 2, y, img.size.width * 1.5, img.size.height * 1.5)];
    previewColour.image = img;
    [self.view addSubview:previewColour];

    chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseButton.frame = CGRectMake(frame.size.width / 5, y, 3 * frame.size.width / 5, 20);
    [chooseButton setTitle:@"Choose this colour" forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(chooseColour) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:chooseButton];
    y += 30;

    hexLabel = [[GCLabel alloc] initWithFrame:CGRectMake(5, y, 10 + frame.size.width / 5, 20)];
    hexLabel.text = dummyPin.rgb;
    hexLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hexLabel];

    resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    resetButton.frame = CGRectMake(frame.size.width / 5, y, 3 * frame.size.width / 5, 20);
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetColour) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:resetButton];
    y += 30;

    contentView.contentSize = CGSizeMake(frame.size.width, y);
}

- (void)chooseColour
{
    NSString *hexString = [ImageLibrary ColorToRGB:currentColour];

    /* Write to database */
    switch (type) {
        case SettingsMainColorPickerTrack:
            [myConfig mapTrackColourUpdate:hexString];
            break;
        case SettingsMainColorPickerDestination:
            [myConfig mapDestinationColourUpdate:hexString];
            break;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetColour
{
    /* Reset the colour */
    switch (type) {
        case SettingsMainColorPickerTrack:
            [colorPickerView setColor:myConfig.mapTrackColour];
            break;
        case SettingsMainColorPickerDestination:
            [colorPickerView setColor:myConfig.mapDestinationColour];
            break;
    }
}

@end