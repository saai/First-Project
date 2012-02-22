//
//  MyAttributedLabelDelegate.h
//  ASAP
//
//  Created by Sha Yan on 12-2-21.
//  Copyright (c) 2012年 ShaYan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyAttributedLabel;
@protocol MyAttributedLabelDelegate <NSObject>
@optional
-(BOOL)attributedLabel:(MyAttributedLabel *)attributedLabel shouldFollowLink :(NSTextCheckingResult*) linkInfo;
-(UIColor *)colorForLink:(NSTextCheckingResult*)linkInfo;
-(int32_t)underlineStyle:(NSTextCheckingResult *)linkInfo;
@end
