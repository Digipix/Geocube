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

@interface UserProfileViewController ()
{
    UIScrollView *contentView;
    NSMutableArray *accountViews;

    NSInteger width;

    NSInteger totalFound, totalDNF, totalHidden, totalRecommendationsGiven, totalRecommendationsReceived;
}

@end

@implementation UserProfileViewController

enum {
    menuReload,
    menuMax
};

- (instancetype)init
{
    self = [super init];

    lmi = [[LocalMenuItems alloc] init:menuMax];
    [lmi addItem:menuReload label:@"Reload"];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    contentView = [[GCScrollView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = contentView;

    [self loadStatistics];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     [self loadStatistics];
                                 }
     ];
}

- (void)loadStatistics
{
    for (UIView *subview in contentView.subviews) {
        if ([subview isKindOfClass:[GCCloseButton class]] == YES)
            continue;
        [subview removeFromSuperview];
    }

    CGRect bounds = [[UIScreen mainScreen] bounds];
    width = bounds.size.width;
    NSInteger labelHeight = myConfig.GCLabelFont.lineHeight;
    __block NSInteger y = 10;

    totalFound = 0;
    totalDNF = 0;
    totalHidden = 0;
    totalRecommendationsGiven = 0;
    totalRecommendationsReceived = 0;

    accountViews = [NSMutableArray arrayWithCapacity:[dbc.Accounts count] + 1];
    __block NSInteger count = 0;

    [dbc.Accounts enumerateObjectsUsingBlock:^(dbAccount *a, NSUInteger idx, BOOL *stop) {

        // If there is nothing, do not show.
        if (a.accountname_string == nil || [a.accountname_string length] == 0)
            return;

        count++;

        GCLabel *l;

        /* Site name */
        l = [[GCLabel alloc] initWithFrame:CGRectMake(10, y, width - 20, labelHeight)];
        [l setText:a.site];
        [contentView addSubview:l];
        y += 15;

        if (a.enabled == NO) {
            l = [[GCLabel alloc] initWithFrame:CGRectMake(10 + width / 8, y, 7 * width / 8, 0)];
            [l setText:@"Remote API is not enabled for this account."];
            l.numberOfLines = 0;
            [l sizeToFit];
            [contentView addSubview:l];
            y += l.frame.size.height;
            return;
        }

        if (a.canDoRemoteStuff == NO) {
            l = [[GCLabel alloc] initWithFrame:CGRectMake(10 + width / 8, y, 7 * width / 8, 0)];
            [l setText:@"Remote API is not available for this account, please check the settings."];
            l.numberOfLines = 0;
            [l sizeToFit];
            [contentView addSubview:l];
            y += l.frame.size.height;
            return;
        }

        GCView *v = [[GCView alloc] initWithFrame:CGRectMake(10, y, width - 20, 0)];
        [contentView addSubview:v];
        [accountViews addObject:v];
        y += 1;

        a.idx = idx;
        [self performSelectorInBackground:@selector(runStatistics:) withObject:a];
    }];

    if (count == 0) {
        GCLabel *l = [[GCLabel alloc] initWithFrame:CGRectMake(10, y, width - 20, 0)];
        l.text = @"No accounts are configured yet. As such no information is available is here yet.";
        l.numberOfLines = 0;
        [l sizeToFit];
        [contentView addSubview:l];
        y += l.frame.size.height;
        return;
    }

    /* Total */
    // Spacer
    GCView *v = [[GCView alloc] initWithFrame:CGRectMake(10, y, width - 20, 20)];
    [contentView addSubview:v];
    y += v.frame.size.height;

    // Header
    GCLabel *l = [[GCLabel alloc] initWithFrame:CGRectMake(10, y, width - 20, labelHeight)];
    [l setText:@"Total"];
    [contentView addSubview:l];
    y += l.frame.size.height;

    v = [[GCView alloc] initWithFrame:CGRectMake(10, y, width - 20, 0)];
    [accountViews addObject:v];
    [contentView addSubview:v];
    y += 1;

    [contentView setContentSize:CGSizeMake(width, y)];
}

- (void)runStatistics:(dbAccount *)a
{
    NSDictionary *d = [a.remoteAPI UserStatistics];
    @synchronized(self) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self showStatistics:a.idx dict:d];
        }];
    }
}

- (void)updateTotal:(NSInteger *)i with:(NSObject *)o
{
    NSNumber *number = (NSNumber *)o;
    @synchronized(self) {
        *i += [number integerValue];
    }
}

- (void)showStatistics:(NSInteger)idx dict:(NSDictionary *)d
{
    NSObject *o;
    GCLabel *l;
    NSInteger labelHeight = myConfig.GCLabelFont.lineHeight;

    GCView *view = [accountViews objectAtIndex:idx];
    for (GCView *subview in view.subviews) {
        if ([subview isKindOfClass:[GCCloseButton class]] == YES)
            continue;
        [subview removeFromSuperview];
    }

    NSInteger y = 0;
    NSInteger idxTotal = [accountViews count] - 1;

    if (d == nil) {
        l = [[GCLabel alloc] initWithFrame:CGRectMake(width / 8, y, 7 * width / 8, labelHeight)];
        [l setText:@"No data"];
        [view addSubview:l];
        y += l.frame.size.height;

    } else {
        o = [d valueForKey:@"waypoints_found"];
        if ([o isKindOfClass:[NSNumber class]] == YES) {
            if (idx != idxTotal)
                [self updateTotal:&totalFound with:o];
            l = [[GCLabel alloc] initWithFrame:CGRectMake(width / 8, y, 7 * width / 8, labelHeight)];
            [l setText:[NSString stringWithFormat:@"Found: %@", o]];
            [view addSubview:l];
            y += l.frame.size.height;
        }

        o = [d valueForKey:@"waypoints_notfound"];
        if ([o isKindOfClass:[NSNumber class]] == YES) {
            if (idx != idxTotal)
                [self updateTotal:&totalDNF with:o];
            l = [[GCLabel alloc] initWithFrame:CGRectMake(width / 8, y, 7 * width / 8, labelHeight)];
            [l setText:[NSString stringWithFormat:@"Not found: %@", o]];
            [view addSubview:l];
            y += l.frame.size.height;
        }

        o = [d valueForKey:@"waypoints_hidden"];
        if ([o isKindOfClass:[NSNumber class]] == YES) {
            if (idx != idxTotal)
                [self updateTotal:&totalHidden with:o];
            l = [[GCLabel alloc] initWithFrame:CGRectMake(width / 8, y, 7 * width / 8, labelHeight)];
            [l setText:[NSString stringWithFormat:@"Hidden: %@", o]];
            [view addSubview:l];
            y += l.frame.size.height;
        }

        o = [d valueForKey:@"recommendations_given"];
        if ([o isKindOfClass:[NSNumber class]] == YES) {
            if (idx != idxTotal)
                [self updateTotal:&totalRecommendationsGiven with:o];
            l = [[GCLabel alloc] initWithFrame:CGRectMake(width / 8, y, 7 * width / 8, labelHeight)];
            [l setText:[NSString stringWithFormat:@"Recommendations given: %@", o]];
            [view addSubview:l];
            y += l.frame.size.height;
        }

        o = [d valueForKey:@"recommendations_received"];
        if ([o isKindOfClass:[NSNumber class]] == YES) {
            if (idx != idxTotal)
                [self updateTotal:&totalRecommendationsReceived with:o];
            l = [[GCLabel alloc] initWithFrame:CGRectMake(width / 8, y, 7 * width / 8, labelHeight)];
            [l setText:[NSString stringWithFormat:@"Recommendations received: %@", o]];
            [view addSubview:l];
            y += l.frame.size.height;
        }

        if (idx != idxTotal && [[accountViews objectAtIndex:idxTotal] isKindOfClass:[GCView class]] == YES) {
            NSDictionary *totals = [NSDictionary dictionaryWithObjects:@[
             [NSNumber numberWithInteger:totalFound],
             [NSNumber numberWithInteger:totalDNF],
             [NSNumber numberWithInteger:totalHidden],
             [NSNumber numberWithInteger:totalRecommendationsGiven],
             [NSNumber numberWithInteger:totalRecommendationsReceived]
            ] forKeys:@[
              @"waypoints_found",
              @"waypoints_notfound",
              @"waypoints_hidden",
              @"recommendations_given",
              @"recommendations_received"
            ]
            ];
            [self showStatistics:[accountViews count] - 1 dict:totals];
        }
    }

    view.frame = CGRectMake(10, 0, width - 20, y);
    [self resizeContainer];
}

- (void)resizeContainer
{
    NSInteger y = 0;
    for (GCView *subview in contentView.subviews) {
        subview.frame = CGRectMake(subview.frame.origin.x, y, subview.frame.size.width, subview.frame.size.height);
        y += subview.frame.size.height;
    }
    [contentView setContentSize:CGSizeMake(width, y)];
}


#pragma mark - Local menu related functions

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index
{
    switch (index) {
        case menuReload:
            [self loadStatistics];
            return;
    }

    [super didSelectedMenu:menu atIndex:index];
}

@end
