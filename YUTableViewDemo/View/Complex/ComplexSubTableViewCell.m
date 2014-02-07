//
//  ComplexSubTableViewCell.m
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 04/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "ComplexSubTableViewCell.h"

@implementation ComplexSubTableViewCell

- (void) setCellContentsFromItem: (YUTableViewItem *) item
{
    self.label.text = item.itemData;
}

@end
