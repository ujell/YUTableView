//
//  YUTableViewItem.m
//  YUTableView
//
//  Created by Yücel Uzun on 30/01/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "YUTableViewItem.h"

@interface YUTableViewItem ()

@property (nonatomic, weak) YUTableViewItem * parent;

@end

@implementation YUTableViewItem

#pragma mark init methods

- (id) initWithData: (id) data
{
    self = [super init];
    if (self)
    {
        _itemData = data;
    }
    return self;
}

- (id) initWithSubitems:(NSArray *)items data:(id)data identifier:(NSString *)identifier
{
    self = [super init];
    if (self)
    {
        _subItems       = items;
        _itemData       = data;
        _cellIdentifier = identifier;
    }
    return self;
}

#pragma mark -

- (void) setAsParentOfSubitems
{
    for (YUTableViewItem * item in self.subItems)
    {
        item.parent = self;
        [item setAsParentOfSubitems];
    }
}

+ (NSArray *) initItemsFromArray: (NSArray *) items
{
    YUTableViewItem * rootItem  = [[YUTableViewItem alloc] init];
    rootItem.parent             = nil;
    rootItem.subItems           = items;
    [rootItem setAsParentOfSubitems];
    return @[rootItem];
}

+ (void) setRootItem: (YUTableViewItem *) rootItem menuItems:(NSArray *)items
{
    YUTableViewItem * currentRootItem = (YUTableViewItem *) items[0];
    currentRootItem.cellIdentifier    = rootItem.cellIdentifier;
    currentRootItem.itemData          = rootItem.itemData;
}

+ (void) setStatusesOfItemsToNormal: (NSArray *) items
{
    for (YUTableViewItem * item in items)
        item.status = YUTableViewItemStatusNormal;
}

+ (void) setAllSubitemSatutesToNormal: (YUTableViewItem *) item
{
    item.status = YUTableViewItemStatusNormal;
    for (YUTableViewItem * i in item.subItems)
    {
        [YUTableViewItem setAllSubitemSatutesToNormal: i];
    }
}

@end
