//
//  ComplexMainTableViewCell.h
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 04/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUTableView.h"

@interface ComplexMainTableViewCell : UITableViewCell <YUTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UILabel        * title;
@property (nonatomic, weak) IBOutlet UILabel        * label;
@property (nonatomic, weak) IBOutlet UIImageView    * image;

@end
