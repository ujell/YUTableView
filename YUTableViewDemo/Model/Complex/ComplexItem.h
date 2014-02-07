//
//  ComplexItem.h
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 04/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplexItem : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * explenation;
@property (nonatomic, strong) UIImage  * image;
@property (nonatomic, strong) NSArray  * randomSubitems;

- (id) initWithType: (NSString *) type;

@end
