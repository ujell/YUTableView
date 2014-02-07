//
//  YUTableView.h
//  YUTableView
//
//  Created by Yücel Uzun on 30/01/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUTableViewItem.h"
#import "YUTableViewCellDelegate.h"

@protocol YUTableViewDelegate;

/** "YUTableView" is subclass of "UITableView" and adds expandable submenu support to it. */
@interface YUTableView : UITableView

/** Superview of the table view. */
@property (nonatomic, weak)   id <YUTableViewDelegate> parentView;

/** A cell identifier that will be used only if "cellIdentifier" property of "YUTableViewItem" is nil. */
@property (nonatomic ,strong) NSString * defaultCellIdentifier;

/** If set YES adds subitems under the selected cell. Else leaves only parents and subitems of selected item*/
@property (nonatomic) BOOL showAllItems;

/** Duration of animations. If duration and "competitionBlock" are not set, default duration will be used. If "competitionBlock" is set, default value is 0.2f */
@property (nonatomic) CGFloat animationDuration;

/** This block will be executed after animations had finished. */
@property (nonatomic, strong) void (^competitionBlock) (void);

/** The animation which will be shown while inserting a cell to the table. Default value is "UITableViewRowAnimationLeft" */
@property (nonatomic) UITableViewRowAnimation insertRowAnimation;

/** The animation which will be shown while deleting a cell from the table. Default value is "UITableViewRowAnimationRight" */
@property (nonatomic) UITableViewRowAnimation deleteRowAnimation;

/** If YES table view scrolls to top when animations finished. Default is NO. */
@property (nonatomic) BOOL scrollToTopWhenAnimationFinished;

/** The last selected item which has subitems and these items are currently on table. */
@property (nonatomic, weak, readonly)   YUTableViewItem   * activeHeader;

/** The last selected item. */
@property (nonatomic, weak, readonly)   YUTableViewItem   * activeSubitem;

/** All items in the data source. */
@property (nonatomic, strong, readonly)  NSArray * tableViewItems;

/** If NO disables user interaction with table during animation. Default is YES. */
@property (nonatomic) BOOL userInteractionEnabledDuringAnimation;

/**
 Sets initial values with given array and reloads table.
 @code
 YUTableViewItem * subitem  = [[YUTableViewItem alloc]  initWithData: @{@"label" : @"subitem"}];
 YUTableViewItem * item     = [[YUTableViewItem alloc]  initWithData: @{@"label" : @"item"}];
 item.subItems              = @[subitem];
 [_tableView setCellsFromArray: @[item] cellIdentifier: @"Cell"];
 @endcode
 @param cellItems Array of cell items. Items must be kind of YUTableViewItem class.
 @param cellIdentifier Default identifier for cells. Can be nil, but each YUTableViewItem must have a cell identifier.
 */
- (void) setCellsFromArray: (NSArray *) cellItems cellIdentifier: (NSString *) cellIdentifier;

/**
 Sets the item which resets the table. It will only be shown if "showAllItems" is NO. If not set, will not be shown.
 @code
 YUTableViewItem * item  = [[YUTableViewItem alloc] initWithData: @{@"label" : @"Back"}];
 [self.tableView setRootItem: item];
 @endcode
 @param rootItem "subitems" of this item is not used so if you want to change all of the cells, you should use "setCellsFromArray" method.
*/
- (void) setRootItem: (YUTableViewItem *) rootItem;

/**
 Selects specified item in the table and calls "didSelectedRow" method of "parentView".
 @code
 [_tableView selectItem: itemList [0] animate: NO];
 @endcode
 @param item The item which will be selected.
 @param animate If YES animates while selecting item.
 */
- (void) selectItem : (YUTableViewItem *) item animate: (BOOL) animate;

@end

@protocol YUTableViewDelegate <NSObject>

@optional

/**
 Equivalent of "- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath". Argument is contents of selected cell instead index path.
 @code
 - (void) didSelectedRow: (YUTableViewItem *) cellItem
 {
     NSDictionary * data = (NSDictionary *) cellItem.itemData;
     if (data [@"msg"])
     NSLog (@"%@", data [@"msg"]);
 }
 @endcode
 @param item Content of selected cell.
*/
- (void) didSelectedRow: (YUTableViewItem *) item;

/**
 Equivalent of "- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath". If not implemented default value is used.
 @code
 - (CGFloat) heightForItem: (YUTableViewItem *) item
 {
    NSString * cellType = item.itemData;
    if ([cellType isEqualToString: @"myCell"])
        return 80;
    return 120;
 }
 @endcode
 @param item Content of cell.
 @return Height of cell.
 */
- (CGFloat) heightForItem: (YUTableViewItem *) item;

@end