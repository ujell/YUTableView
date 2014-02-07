//
//  ComplexSubTableViewCell.h
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 04/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUTableView.h"

@interface ComplexSubTableViewCell : UITableViewCell <YUTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UILabel * label;

@end
