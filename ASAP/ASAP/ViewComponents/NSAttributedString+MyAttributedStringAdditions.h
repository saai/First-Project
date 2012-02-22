//
//  NSAttributedString+MyAttributedStringAdditions.h
//  ASAP
//
//  Created by Sha Yan on 12-2-21.
//  Copyright (c) 2012年 ShaYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@interface NSAttributedString (MyAttributedStringConstructors)
+(id)attributedStringWithString:(NSString*)string;
+(id)attributedStringWithAttributedString:(NSAttributedString*)attrStr;

-(CGSize)sizeConstrainedToSize:(CGSize)maxSize;
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange;
@end

@interface NSMutableAttributedString (MyAttributedStringStyleModifiers)

//set font
-(void) setFont:(UIFont *)font;
-(void) setFont:(UIFont *)font range:(NSRange)range;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range;
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range;

//set text color
-(void) setTextColor:(UIColor *)color;
-(void) setTextColor:(UIColor *)color range:(NSRange)range;

//set underline
-(void)setTextIsUnderlined:(BOOL)underlined;
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range;
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range; //!< style is a combination of CTUnderlineStyle & CTUnderlineStyleModifiers

//set bold
-(void)setTextBold:(BOOL)isBold range:(NSRange)range;

//set Italic
-(void)setItalic:(BOOL)isItalic range: (NSRange)range;

//set alignment
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode;
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range;

@end
