//
//  BasicTableViewCell.m
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 03/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "BasicTableViewCell.h"

@implementation BasicTableViewCell

- (void) setCellContentsFromItem: (YUTableViewItem *) item
{
    self.label.text = item.itemData;
    if (item.status != YUTableViewItemStatusSubmenuOpened && item.status != YUTableViewItemStatusParent)
    {
        self.arrowImage.hidden          = YES;
        self.leftConstraint.constant    = 20;
    }
    else
    {
        self.arrowImage.hidden          = NO;
        self.leftConstraint.constant    = self.arrowImage.frame.size.width + 40;
    }
}

@end
