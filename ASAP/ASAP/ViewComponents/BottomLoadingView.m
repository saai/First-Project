//
//  BottomLoadingView.m
//  ASAP
//
//  Created by Sha Yan on 11-9-5.
//  Copyright 2011 ShaYan. All rights reserved.
//

#import "BottomLoadingView.h"


@implementation BottomLoadingView
@synthesize loadingIndicator,directionImageView,titleLabel;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [loadingIndicator release];
	[directionImageView release];
	[titleLabel release];
    [super dealloc];
}


@end
