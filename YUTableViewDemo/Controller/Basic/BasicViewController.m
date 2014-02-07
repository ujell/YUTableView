//
//  BasicViewController.m
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 03/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "BasicViewController.h"
#import "YUTableView.h"

@interface BasicViewController () <YUTableViewDelegate>

@property (weak, nonatomic) IBOutlet YUTableView * tableView;

@end

@implementation BasicViewController

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
    
    [_tableView setCellsFromArray: [self createCellItems: 5 root: nil] cellIdentifier: @"BasicTableViewCell"];
    [_tableView setRootItem: [[YUTableViewItem alloc] initWithData: @"Back"]];

}

- (NSArray *) createCellItems: (int) numberOfItems root :(NSString *) root
{
    if (numberOfItems == 0) return nil;
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0; i < numberOfItems; i++)
    {
        NSString * label;
        if (root == nil)
            label = [NSString stringWithFormat: @"%i", i];
        else
            label = [NSString stringWithFormat: @"%@.%i", root, i];
        YUTableViewItem * item = [[YUTableViewItem alloc] initWithData: label];
        
        item.subItems          = [self createCellItems: i root: label];
        [array addObject: item];
    }
    
    return array;
}

#pragma mark - YUTableViewDelegate Methods

- (void)didSelectedRow:(YUTableViewItem *)item
{
    if (item.subItems.count == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Info"
                                                         message: [NSString stringWithFormat:
                                                                    @"Item %@ selected", item.itemData]
                                                        delegate: nil
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSLog(@"%@ selected", item.itemData);
    }
}

@end
