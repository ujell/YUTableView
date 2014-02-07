//
//  YUTableViewItem.h
//  YUTableView
//
//  Created by Yücel Uzun on 30/01/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Defines state of the cell. */
typedef enum
{
    /** The item is not selected. */
    YUTableViewItemStatusNormal,
    /** The item is selected and doesn't have any subitem. */
    YUTableViewItemStatusSelected,
    /** Item is selected, has subitems and these subitems are currently on table. */
    YUTableViewItemStatusSubmenuOpened,
    /** Subitem of subitem of this item is selected. Only used if "showAllItems" is NO */
    YUTableViewItemStatusParent
} YUTableViewItemStatus;

/** YUTableViewItem encapsulates information about cell.  */
@interface YUTableViewItem : NSObject

/** The current status of the item. */
@property (nonatomic) YUTableViewItemStatus status;
/** Subitems of item. All objects in "subItems" must be kind of "YUTableViewItem". */
@property (nonatomic, strong) NSArray * subItems;
/** Custom data of item, which will be passed to cell view. */
@property (nonatomic, strong) id itemData;
/** The cell identifier of the cell which represents this item. If "cellIdentifier" is nil, "defaultCellIdentifier" in "YUTableView" will be used. */
@property (nonatomic, strong) NSString * cellIdentifier;

/**
 Initializes an "YUTableViewItem" with custom data.
 @code
 YUTableViewItem * item = [[YUTableViewItem alloc] initWithData: @"Label"];
 @endcode
 @param data Custom data of the item, which will be passed to the cell view.
 @return The newly-initialized "YUTableViewItem"
 */
- (id) initWithData: (id) data;
/**
 Initializes an "YUTableViewItem" with given parameters. All parameters are optional.
 @code
 YUTableViewItem * item, item2;
 YUTableViewItem * item3 = [[YUTableViewItem alloc] initWithSubitems: @[item, item2] data: @{@"key":@"value"} identifier: @"Cell"];
 @endcode
 @param items Subitems of item. All objects in "items" must be kind of "YUTableViewItem". 
 @param data Custom data of item, which will be passed to cell view. If "data" is nil or wrong, can cause problems while displaying the cell.
 @param identifier Cell identifier of the cell which represents this item. If "cellIdentifier" is nil, "defaultCellIdentifier" in "YUTableView" will be used.
 */
- (id) initWithSubitems: (NSArray *) items data: (id) data identifier: (NSString *) identifier;

/**
 Returns parent of the item.
 @return Parent of the item.
 */
- (YUTableViewItem *) parent;

/** Creates a root item and sets parents of all items in array. "YUTableView" uses this method when creating cells. Using this method is NOT RECOMMENDED. */
+ (NSArray *) initItemsFromArray: (NSArray *) items;

/** Changes active root item with given item. "YUTableView" calls this method. Using this method is NOT RECOMMENDED. */
+ (void) setRootItem: (YUTableViewItem *) rootItem menuItems: (NSArray *) items;

/** Sets statuses of all items in the array to normal. "YUTableView" calls this method. */
+ (void) setStatusesOfItemsToNormal: (NSArray *) items;

/** Sets statuses of item and all of its subitems to normal. "YUTableView" calls this method. */
+ (void) setAllSubitemSatutesToNormal: (YUTableViewItem *) item;


@end
