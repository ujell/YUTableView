//
//  ComplexItem.m
//  YUTableViewDemo
//
//  Created by Yücel Uzun on 04/02/14.
//  Copyright (c) 2014 Yücel Uzun. All rights reserved.
//

#import "ComplexItem.h"

@implementation ComplexItem

- (id) initWithType: (NSString *) type
{
    self = [super init];
    if (self)
    {
        if ([type isEqualToString:@"Dog"])
        {
            _name           = @"Dog";
            _explenation    = @"Canis lupus familiaris";
            _image          = [UIImage imageNamed:@"dog"];
            _randomSubitems = @[@"Lorem", @"Ipsum", @"Dolor", @"Sit", @"Amet"];
        }
        else if ([type isEqualToString:@"Cat"])
        {
            _name           = @"Cat";
            _explenation    = @"Felis silvestris catus";
            _image          = [UIImage imageNamed:@"cat"];
            _randomSubitems = @[@"Consectetur", @"Adipiscing", @"Elit"];
        }
        else if ([type isEqualToString:@"Unicorn"])
        {
            _name           = @"Unicorn";
            _explenation    = @"Unicornis";
            _image          = [UIImage imageNamed:@"unicorn"];
            _randomSubitems = @[@"Etiam", @"Id", @"Nibh", @"Eros"];
        }
        else if ([type isEqualToString:@"Phoenix"])
        {
            _name           = @"Phoenix";
            _explenation    = @"Phoenix";
            _image          = [UIImage imageNamed:@"phoenix"];
            _randomSubitems = @[@"Cras", @"Hendrerit", @"Convallis", @"Adipiscing"];
        }
    }
    return self;
}

@end
