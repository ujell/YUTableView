//
//  YUTableView.m
//  YUTableView
//
//  Created by Yücel Uzun on 30/01/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "YUTableView.h"

@interface YUTableView () < UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * activeTableViewItems;

@end

@implementation YUTableView

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _activeTableViewItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YUTableViewItem * item = (YUTableViewItem *) _activeTableViewItems [indexPath.row];
    UITableViewCell * cell;

    NSString * cellID;
    if ([item cellIdentifier] != nil && [item cellIdentifier].length > 0)
        cellID = [item cellIdentifier];
    else
        cellID = _defaultCellIdentifier;
    cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
    }

    [((UITableViewCell <YUTableViewCellDelegate> *)cell) setCellContentsFromItem: item];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YUTableViewItem * selectedItem = (YUTableViewItem *) _activeTableViewItems [indexPath.row];
    
    if ([_parentView respondsToSelector: @selector (didSelectedRow:)])
    {
        [_parentView didSelectedRow: selectedItem];
    }
    
    if (selectedItem == _activeHeader && !_showAllItems)
    {
        return;
    }
    
    if (selectedItem.subItems != nil && selectedItem.subItems.count > 0)
    {
        _activeHeader = selectedItem;
        [self reloadTable: selectedItem];
    }
    else
    {
        _activeSubitem.status = YUTableViewItemStatusNormal;
        _activeSubitem        = selectedItem;
        selectedItem.status   = YUTableViewItemStatusSelected;
        [self reloadData];
    }
    
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if ([_parentView respondsToSelector: @selector(heightForItem:)])
    {
        return [_parentView heightForItem: _activeTableViewItems [indexPath.row]];
    }
    
    return tableView.rowHeight;
}

#pragma mark - Init Methods of YUTableView

- (void) setCellsFromArray: (NSArray *) cellItems cellIdentifier: (NSString *) cellIdentifier
{
    _tableViewItems         = [YUTableViewItem initItemsFromArray: cellItems];
    _activeTableViewItems   = ((YUTableViewItem *)_tableViewItems [0]).subItems;
    _activeHeader           = nil;
    _activeSubitem          = nil;
    _defaultCellIdentifier  = cellIdentifier;
    [self reloadData];
}

- (void) setRootItem:(YUTableViewItem *)rootItem
{
    [YUTableViewItem setRootItem: rootItem menuItems: _tableViewItems];
}

#pragma mark - Adding and removing cells

- (void) reloadTable: (YUTableViewItem *) selectedItem
{
    NSMutableArray  * newItems      = [[NSMutableArray alloc] initWithArray: _activeTableViewItems];
    NSInteger       selectedIndex;
    if ([_activeTableViewItems containsObject: selectedItem])
        selectedIndex = [_activeTableViewItems indexOfObject: selectedItem];
    else
        selectedIndex = -1;
    NSMutableArray  * pathsToAdd    = [NSMutableArray array];
    NSMutableArray  * pathsToRemove = [NSMutableArray array];
    
    if (_showAllItems)
    {
        NSIndexSet * indexes;
        // Item is in the table.
        if (selectedIndex != -1)
        {
            if (selectedItem.status == YUTableViewItemStatusSubmenuOpened)
            {
                selectedItem.status     = YUTableViewItemStatusNormal;
                indexes                 = [NSMutableIndexSet indexSetWithIndexesInRange:
                                           NSMakeRange (selectedIndex + 1, [self getDisplayedSubitemCount: selectedItem])];
                [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * stop)
                 {
                     [pathsToRemove addObject: [NSIndexPath indexPathForRow: index inSection:0 ]];
                 }];
                [newItems removeObjectsAtIndexes: indexes];
            }
            else
            {
                selectedItem.status     = YUTableViewItemStatusSubmenuOpened;
                indexes                 = [NSMutableIndexSet indexSetWithIndexesInRange:
                                           NSMakeRange (selectedIndex + 1, selectedItem.subItems.count)];
                [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * stop)
                 {
                     [pathsToAdd addObject: [NSIndexPath indexPathForRow: index inSection:0 ]];
                 }];
                [newItems insertObjects: selectedItem.subItems atIndexes: indexes];
            }
        }
        else
        {
            YUTableViewItem * temp          = selectedItem;
            NSMutableArray * parentArray    = [NSMutableArray array];
            NSInteger count                 = 0;
            
            while (![_activeTableViewItems containsObject: temp])
            {
                YUTableViewItem * parent        = temp.parent;
                NSUInteger position             = [parent.subItems indexOfObject: temp];
                NSIndexSet * indexesBeforeItem  = [NSIndexSet indexSetWithIndexesInRange:
                                                       NSMakeRange( 0, position + 1)];
                NSIndexSet * indexesAfterItem   = [NSIndexSet indexSetWithIndexesInRange:
                                                       NSMakeRange( position + 1, parent.subItems.count - position -1)];
                
                [parentArray insertObjects: [parent.subItems objectsAtIndexes: indexesBeforeItem]
                                 atIndexes: indexesBeforeItem];
                [parentArray addObjectsFromArray: [parent.subItems objectsAtIndexes: indexesAfterItem]];

                temp        = temp.parent;
                count       += temp.subItems.count;
                temp.status = YUTableViewItemStatusSubmenuOpened;
            }
            temp.status         = YUTableViewItemStatusSubmenuOpened;
            NSInteger position  = [_activeTableViewItems indexOfObject: temp];
            indexes             = [NSMutableIndexSet indexSetWithIndexesInRange: NSMakeRange (position + 1, count)];
            [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * stop)
             {
                 [pathsToAdd addObject: [NSIndexPath indexPathForRow: index inSection:0 ]];
             }];
            [newItems insertObjects: parentArray atIndexes: indexes];
        }
    }
    else
    {
        selectedItem.status = YUTableViewItemStatusSubmenuOpened;
        newItems            = [[NSMutableArray alloc] initWithArray: selectedItem.subItems];
        
        if (selectedItem.parent != nil)
        {
            [newItems insertObject: selectedItem atIndex: 0];
            YUTableViewItem * ancestor = selectedItem.parent;
            while (ancestor != nil)
            {
                ancestor.status = YUTableViewItemStatusParent;
                if (ancestor.itemData != nil)
                    [newItems insertObject: ancestor atIndex: 0];
                ancestor        = ancestor.parent;
            }
        }
        
        for (int i = 0; i < _activeTableViewItems.count; i++)
            if (![newItems containsObject: _activeTableViewItems [i]])
                [pathsToRemove addObject: [NSIndexPath indexPathForRow: i inSection:0 ]];
        for (int i = 0; i < newItems.count; i++)
            if (![_activeTableViewItems containsObject: newItems[i]])
                [pathsToAdd addObject: [NSIndexPath indexPathForRow: i inSection:0 ]];
    }
    [YUTableViewItem setStatusesOfItemsToNormal: selectedItem.subItems];
    _activeTableViewItems = newItems;
    
    if ([newItems containsObject: _activeSubitem])
        _activeSubitem.status = YUTableViewItemStatusSelected;
    
    [self insertRows: pathsToAdd deleteRows: pathsToRemove selectedIndex: [newItems indexOfObject: selectedItem]];
}

- (void) insertRows: (NSArray *) pathsToAdd deleteRows: (NSArray* ) pathsToRemove selectedIndex: (NSUInteger) index
{
    // There is a bug in iOS 7.0 which can cause some failure while displaying the cell. This part is a dirty fix for that.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [self selectRowAtIndexPath: [NSIndexPath indexPathForRow: index inSection:0 ]
                          animated: NO
                    scrollPosition: UITableViewScrollPositionNone];
        [self deselectRowAtIndexPath: [NSIndexPath indexPathForRow: index inSection:0 ] animated:NO];
    }
    
    // For some wierd reason iOS 6 can't handle animation duration when inserting/deleting rows.
    if (_animationDuration == 0 || [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        _animationDuration = 0.2;

    self.userInteractionEnabled = _userInteractionEnabledDuringAnimation;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration: _animationDuration];
    [CATransaction setCompletionBlock:^{
        if (_scrollToTopWhenAnimationFinished)
            [self scrollRectToVisible: CGRectMake(0, 0, 1, 1) animated: YES];
        if (_competitionBlock != nil)
            _competitionBlock ();
        self.userInteractionEnabled = YES;
        [self reloadData];
    }];
    
    [UIView animateWithDuration: _animationDuration animations:^{
        [self beginUpdates];
        [self deleteRowsAtIndexPaths: pathsToRemove withRowAnimation: _deleteRowAnimation];
        [self insertRowsAtIndexPaths: pathsToAdd withRowAnimation: _insertRowAnimation];
        [self endUpdates];
    }];
    
    [CATransaction commit];
}

- (void) selectItem : (YUTableViewItem *) item animate: (BOOL) animate
{
    __weak YUTableView * weakSelf = self;
    if (item.subItems.count == 0)
    {
        if (animate)
        {
            void (^originalBlock) (void)    = _competitionBlock;
            _competitionBlock = ^(void)
            {
                [weakSelf.parentView didSelectedRow: item];
                weakSelf.competitionBlock = originalBlock;
            };
        }
        else
        {
            [_parentView didSelectedRow: item];
        }
    }
    
    if (_showAllItems)
    {
        [self reloadTable: item];
    }
    else
    {
        if (item.subItems == nil || item.subItems.count == 0)
        {
            _activeSubitem = item;
            _activeHeader  = item.parent;
            [self reloadTable: item.parent];
        }
        else
            [self reloadTable: item];
    }

}

- (NSUInteger) getDisplayedSubitemCount: (YUTableViewItem * ) selectedItem
{
    NSUInteger result = selectedItem.subItems.count;
    for (YUTableViewItem * i in selectedItem.subItems)
    {
        if (i.status == YUTableViewItemStatusSubmenuOpened)
            result += [self getDisplayedSubitemCount: i];
    }
    return result;
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.delegate                           = self;
    self.dataSource                         = self;
    _showAllItems                           = NO;
    _insertRowAnimation                     = UITableViewRowAnimationLeft;
    _deleteRowAnimation                     = UITableViewRowAnimationRight;
    _scrollToTopWhenAnimationFinished       = NO;
    _userInteractionEnabledDuringAnimation  = YES;
}

#pragma mark -

@end
