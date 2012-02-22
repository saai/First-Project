//
//  AutoRefreshHeaderView.m
//  ASAP
//
//  Created by Sha Yan on 11-8-30.
//  Copyright 2011 ShaYan. All rights reserved.
//

#import "AutoRefreshHeaderView.h"


@implementation AutoRefreshHeaderView
@synthesize titleLabel,loadingIndicator,directionImageView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(c, [[UIColor lightGrayColor] CGColor]);
    CGContextSetLineWidth(c, 1.5);
    
    CGFloat minx = CGRectGetMinX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(c,minx , maxy);
    CGContextAddLineToPoint(c, maxx, maxy);
    CGContextClosePath(c);
    // Fill & stroke the path
    CGContextDrawPath(c, kCGPathFillStroke); 
    
}


- (void)dealloc {
	[loadingIndicator release];
	[titleLabel release];
	[directionImageView release];
    [super dealloc];
}


@end
