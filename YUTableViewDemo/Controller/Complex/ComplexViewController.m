//
//  ComplexViewController.m
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 04/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "ComplexViewController.h"
#import "YUTableView.h"
#import "ComplexItem.h"
#include <stdlib.h>

@interface ComplexViewController () <YUTableViewDelegate>

@property (weak, nonatomic) IBOutlet YUTableView * tableView;

@end

@implementation ComplexViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    [self setTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table Init

- (void) setTable
{
    _tableView.showAllItems                             = [_tableProperties [@"showAll"] boolValue];
    _tableView.scrollToTopWhenAnimationFinished         = [_tableProperties [@"scrollToTop"] boolValue];
    _tableView.insertRowAnimation                       = [_tableProperties [@"insertAnimation"] integerValue];
    _tableView.deleteRowAnimation                       = [_tableProperties [@"deleteAnimation"] integerValue];
    _tableView.userInteractionEnabledDuringAnimation    = [_tableProperties [@"userInt"] boolValue];
    _tableView.parentView                               = self;
    
    if (_tableProperties [@"animationDuration"])
        _tableView.animationDuration = [_tableProperties [@"animationDuration"] floatValue];
    
    [_tableView setCellsFromArray: [self createCellItems] cellIdentifier: @"BasicTableViewCell"];
    [_tableView setRootItem: [[YUTableViewItem alloc] initWithData: @"Back"]];
    _tableView.competitionBlock                 = ^(void)
    {
        NSLog( @"Animation completed!");
    };
}

- (NSArray *) createCellItems
{
    NSMutableArray * array = [NSMutableArray array];
    NSArray * types        = @[@"Dog", @"Cat", @"Unicorn", @"Phoenix"];
    for (int i = 0; i < 5; i++)
    {
        YUTableViewItem * mainItem      = [[YUTableViewItem alloc] initWithData: [NSString stringWithFormat:@"Item %i", i]];
        NSMutableArray  * subItemList   = [NSMutableArray arrayWithCapacity: 4];
        
        for (NSString * t in types)
        {
            ComplexItem     * complexItem   = [[ComplexItem alloc] initWithType: t];
            YUTableViewItem * subItem       = [[YUTableViewItem alloc] initWithData: complexItem];
            subItem.cellIdentifier          = @"ComplexMainTableViewCell";
            NSMutableArray  * loremItemList = [NSMutableArray arrayWithCapacity: complexItem.randomSubitems.count];
            for (NSString * s in complexItem.randomSubitems)
            {
                YUTableViewItem * lorem     = [[YUTableViewItem alloc] initWithData: s];
                lorem.cellIdentifier        = @"ComplexSubTableViewCell";
                [loremItemList addObject: lorem];
            }
            subItem.subItems = loremItemList;
            [subItemList addObject: subItem];
        }
        
        mainItem.subItems = subItemList;
        [array addObject: mainItem];
    }
    return array;
}

#pragma mark - YUTableViewDelegate

- (CGFloat)heightForItem:(YUTableViewItem *)item
{
    if ([item.cellIdentifier isEqualToString:@"ComplexMainTableViewCell"])
        return 100;
    if ([item.cellIdentifier isEqualToString: @"ComplexSubTableViewCell"])
        return 20;
    return _tableView.rowHeight;
}

- (void)didSelectedRow:(YUTableViewItem *)item
{
    NSString * msg;
    
    if ([item.cellIdentifier isEqualToString:@"ComplexMainTableViewCell"])
        msg = ((ComplexItem *)item.itemData).name;
    else
        msg = item.itemData;
    
    if (item.subItems.count == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Info"
                                                         message: msg
                                                        delegate: nil
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSLog(@"%@ selected", msg);
    }
}

#pragma mark - Actions

- (IBAction)selectButtonTouched:(id)sender
{
    unsigned int randomCell;
    YUTableViewItem * root = _tableView.tableViewItems [0];
    YUTableViewItem * temp = root;
    if (arc4random_uniform(2) == 0)
    {
        do
        {
            randomCell = arc4random_uniform( (u_int32_t)  temp.subItems.count);
            temp = temp.subItems [randomCell];
        }
        while (temp.subItems.count > 0);
    }
    else
    {
        randomCell = arc4random_uniform( (u_int32_t) temp.subItems.count);
        temp = temp.subItems [randomCell];
    }
    [_tableView selectItem: temp animate: YES];
}

@end
