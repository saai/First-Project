//
//  MyAttributedLabel.h
//  ASAP
//
//  Created by Sha Yan on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAttributedLabelDelegate.h"
#import <CoreText/CoreText.h>
#define MyAttributedLabel_WarnAboutKnownIssues 1
// We use this arbitrary URL scheme to handle custom actions.
// So URLs begin with "customURL://xxx" will be handled here instead of opening in Safari.
// Note: in the above example, "xxx" is the 'host' part of the URL.
// Note: the "customURL" is the schema value.

#define kCustomURLSchema @"customURL://"
#define kCustomURLSchemaValue @"customURL"

@interface MyAttributedLabel : UILabel
{
    NSMutableAttributedString *_attributedText;
    CGPoint touchStartPoint;
    NSMutableArray *customLinks;
    CTFrameRef textFrame;
    CGRect drawingRect;
    NSTextCheckingResult *activeLink;
    
}

@property(nonatomic, copy) NSAttributedString *attributedText;
//Defaults to NSTextCheckingTypeLink, + NSTextCheckingTypePhoneNumber if "tel:" scheme supported
@property(nonatomic, assign) NSTextCheckingTypes automaticallyAddLinksForType;

//Defaults linkColor.
@property(nonatomic, retain) UIColor *linkColor;
//[UIColor colorWithWhite:0.2 alpha:0.5]
@property(nonatomic, retain) UIColor *highlightedLinkColor;

//Defaults to YES.
@property(nonatomic,assign) BOOL underlineLinksForTypes;
@property(nonatomic, assign) int32_t underlineStyle;
//If YES, pointInside will only return YES if the touch is on a link. 
//If NO, pointInside will always return YES (Defaults to NO)
@property(nonatomic, assign) BOOL onlyCatchTouchesOnLinks; 
@property(nonatomic, assign) BOOL centerVertically;
@property(nonatomic, assign) BOOL extendBottomToFit; //!< Allows to draw text past the bottom of the view if need. May help in rare cases (like using Emoji)
@property(nonatomic, assign) IBOutlet id<MyAttributedLabelDelegate> delegate;

-(void)setAttributedText:(NSAttributedString *)attributedText withLabelStyles:(BOOL)useLabelSytles;
-(void)resetAttributedText;
-(void)addCustomLink: (NSURL *)linkUrl inRange: (NSRange)range;
-(void)removeAllCustomLinks;
@end


