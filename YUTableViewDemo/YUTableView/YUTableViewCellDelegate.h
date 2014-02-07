//
//  YUTableViewCellDelegate.h
//  YUTableView
//
//  Created by Yücel Uzun on 30/01/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YUTableViewCellDelegate <NSObject>

/**
 This method should set cell view interface with given data.
 @param item Representing item of selected row.
 */
- (void) setCellContentsFromItem: (YUTableViewItem *) item;

@end
