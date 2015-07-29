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

@implementation FilterDirectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier filterObject:(FilterObject *)_fo
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    fo = _fo;

    directions = @[@"North", @"North East", @"East", @"South East", @"South", @"South West", @"West", @"North West"];

    [self header];
    [self configInit];

    CGRect rect;
    NSInteger y = 0;
    UILabel *l;

    rect = CGRectMake(20, 2, width - 40, cellHeight);
    l = [[UILabel alloc] initWithFrame:rect];
    l.font = f1;
    l.text = fo.name;
    l.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:l];
    y += cellHeight;

    if (fo.expanded == NO) {
        [self.contentView sizeToFit];
        fo.cellHeight = height = y;
        return self;
    }

    rect = CGRectMake(20, y, 100, 15);
    l = [[UILabel alloc] initWithFrame:rect];
    l.text = @"Direction is:";
    l.font = f2;
    l.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:l];

    rect = CGRectMake(120, y, width - 140, 15);
    directionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    directionButton.frame = rect;
    [directionButton addTarget:self action:@selector(clickDirection:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:directionButton];
    [self clickDirection:nil];
    y += 35;

    [self.contentView sizeToFit];
    fo.cellHeight = height = y;

    return self;
}

- (void)configInit
{
    configPrefix = @"direction";

    directionString = [self configGet:@"direction"];
    NSEnumerator *e = [directions objectEnumerator];
    NSString *s;
    direction = 0;
    while ((s = [e nextObject]) != nil) {
        if ([s compare:directionString] == NSOrderedSame)
            return;
        direction++;
    }
}

- (void)configUpdate
{
    [self configSet:@"direction" value:directionString];
    [self configSet:@"enabled" value:[NSString stringWithFormat:@"%d", fo.expanded]];
}

- (void)clickDirection:(UIButton *)s
{
    if (s == nil) {
        [directionButton setTitle:[directions objectAtIndex:direction] forState:UIControlStateNormal];
        [directionButton setTitle:[directions objectAtIndex:direction] forState:UIControlStateSelected];
        return;
    }

    [ActionSheetStringPicker
        showPickerWithTitle:@"Select a Direction"
        rows:directions
        initialSelection:direction
        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            direction = selectedIndex;
            directionString = [directions objectAtIndex:direction];
            [self clickDirection:nil];
            [self configUpdate];
        }
        cancelBlock:^(ActionSheetStringPicker *picker) {
        }
        origin:self
    ];
}

@end
