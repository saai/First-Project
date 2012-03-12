//
//  MyLocalizedLabel.m
//  ASAP
//
//  Created by Sha Yan on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyLocalizedLabel.h"

@implementation MyLocalizedLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.text = NSLocalizedString(self.text, @"localized string for label");
}
@end
