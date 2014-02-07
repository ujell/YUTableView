//
//  ComplexMainTableViewCell.m
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 04/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "ComplexMainTableViewCell.h"
#import "ComplexItem.h"
@implementation ComplexMainTableViewCell

- (void) setCellContentsFromItem: (YUTableViewItem *) item
{
    ComplexItem * data  = (ComplexItem *) item.itemData;
    self.title.text     = data.name;
    self.label.text     = data.explenation;
    [self.image setImage: data.image];
    
    if (item.status == YUTableViewItemStatusSubmenuOpened)
        self.contentView.backgroundColor = [UIColor grayColor];
    else
        self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
