//
//  BasicTableViewCell.h
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 03/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUTableView.h"

@interface BasicTableViewCell : UITableViewCell <YUTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UILabel            * label;
@property (weak, nonatomic) IBOutlet UIImageView        * arrowImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * leftConstraint;

@end
