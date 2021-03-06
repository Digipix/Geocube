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

@interface GCViewController ()
{
    NSInteger numberOfItemsInRow;
    GCCloseButton *closeButton;
}

@end

@implementation GCViewController

@synthesize numberOfItemsInRow;

- (instancetype)init
{
    self = [super init];

    lmi = nil;
    self.numberOfItemsInRow = 3;

    hasCloseButton = NO;
    closeButton = nil;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self changeTheme];
}

- (void)prepareCloseButton:(UIView *)view
{
    if (hasCloseButton == YES) {
        UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closePage:)];
        swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
        [view addGestureRecognizer:swipeToRight];
    }
}

- (void)changeTheme
{
    self.view.backgroundColor = currentTheme.tableViewBackgroundColor;

    [themeManager changeThemeView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showCloseButton];
}

- (void)showCloseButton
{
    if (hasCloseButton == YES)
        [self.view bringSubviewToFront:closeButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@/viewWillAppear: %0.0f px", [self class], self.view.frame.size.height);

    [menuGlobal defineLocalMenu:lmi forVC:self];

    // Add a close button to the view
    if (hasCloseButton == YES && closeButton == nil) {
        GCCloseButton *b = [GCCloseButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:b];
        [b addTarget:self action:@selector(closePage:) forControlEvents:UIControlEventTouchDown];
        closeButton = b;
    }

    self.view.backgroundColor = currentTheme.viewBackgroundColor;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                                [self calculateRects];
                                                [self viewWilltransitionToSize];
                                            }
                                 completion:nil
     ];
}

- (void)calculateRects
{
    // Dummy for this class
}

- (void)viewWilltransitionToSize
{
    // Dummy for this class
}

- (void)willClosePage
{
    // Nothing for now
}

- (void)closePage:(UIButton *)b
{
    [self willClosePage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (closeButton == nil)
        return;

    CGRect frame = closeButton.frame;
    frame.origin.x = scrollView.contentOffset.x;
    frame.origin.y = scrollView.contentOffset.y;
    closeButton.frame = frame;

    [self.view bringSubviewToFront:closeButton];
}

#pragma -- Local menu related functions

- (void)performLocalMenuAction:(NSInteger)index
{
    [MyTools messageBox:self header:@"You selected..." text:[NSString stringWithFormat:@"number %@", @(index + 1)]];
}

@end
