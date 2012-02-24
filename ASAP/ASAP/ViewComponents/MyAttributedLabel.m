//
//  MyAttributedLabel.m
//  ASAP
//
//  Created by Sha Yan on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyAttributedLabel.h"
#import "NSAttributedString+MyAttributedStringAdditions.h"

#define UITextAlignmentJustify ((UITextAlignment)kCTJustifiedTextAlignment)
#pragma -
#pragma mark Get CTRefs from UIRefs

CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment);
CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode);

CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment) 
{
	switch (alignment) 
    {
		case UITextAlignmentLeft: return kCTLeftTextAlignment;
		case UITextAlignmentCenter: return kCTCenterTextAlignment;
		case UITextAlignmentRight: return kCTRightTextAlignment;
		case UITextAlignmentJustify: return kCTJustifiedTextAlignment; /* special OOB value if we decide to use it even if it's not really standard... */
		default: return kCTNaturalTextAlignment;
	}
}

CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode) 
{
	switch (lineBreakMode) 
    {
		case UILineBreakModeWordWrap: return kCTLineBreakByWordWrapping;
		case UILineBreakModeCharacterWrap: return kCTLineBreakByCharWrapping;
		case UILineBreakModeClip: return kCTLineBreakByClipping;
		case UILineBreakModeHeadTruncation: return kCTLineBreakByTruncatingHead;
		case UILineBreakModeTailTruncation: return kCTLineBreakByTruncatingTail;
		case UILineBreakModeMiddleTruncation: return kCTLineBreakByTruncatingMiddle;
		default: return 0;
	}
}

#pragma -
#pragma mark Custom Utilities

CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin);
BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range);
NSRange NSRangeFromCFRange(CFRange range);
BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range);
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin);
CGRect CGRectFlipped(CGRect rect, CGRect bounds) ;

CGRect CGRectFlipped(CGRect rect, CGRect bounds) 
{
	return CGRectMake(CGRectGetMinX(rect),
					  CGRectGetMaxY(bounds)-CGRectGetMaxY(rect),
					  CGRectGetWidth(rect),
					  CGRectGetHeight(rect));
}

NSRange NSRangeFromCFRange(CFRange range) 
{
	return NSMakeRange(range.location, range.length);
}

CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin) 
{
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
	CGFloat height = ascent + descent /* + leading */;
	
	CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
	
	return CGRectMake(lineOrigin.x + xOffset,
					  lineOrigin.y - descent,
					  width,
					  height);
}

BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range) 
{
	NSRange lineRange = NSRangeFromCFRange(CTLineGetStringRange(line));
	NSRange intersectedRange = NSIntersectionRange(lineRange, range);
	return (intersectedRange.length > 0);
}

BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range) 
{
	NSRange runRange = NSRangeFromCFRange(CTRunGetStringRange(run));
	NSRange intersectedRange = NSIntersectionRange(runRange, range);
	return (intersectedRange.length > 0);
}

// Font Metrics: http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/FontHandling/Tasks/GettingFontMetrics.html
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin) 
{
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGFloat height = ascent + descent /* + leading */;
	
	return CGRectMake(lineOrigin.x,
					  lineOrigin.y - descent,
					  width,
					  height);
}

#pragma -
#pragma mark Private interface
@interface MyAttributedLabel()

-(NSMutableAttributedString *)attributedTextWithLinks;
-(void)drawActiveLinkHighlightForRect:(CGRect)rect;
-(void)resetTextFrame;

#pragma -
#pragma mark Check Touch 
-(NSTextCheckingResult *) linkAtPoint:(CGPoint) point;
-(NSTextCheckingResult *)linkAtCharacterIndex: (CFIndex) index;

#if MyAttributedLabel_WarnAboutKnownIssues
-(void)warnAboutKnownIssues_CheckLineBreakMode;
-(void)warnAboutKnownIssues_CheckAdjustsFontSizeToFitWidth;
#endif

@end

#pragma -
#pragma mark implementation of MyAttributedLabel

@implementation MyAttributedLabel
@synthesize delegate;

@synthesize automaticallyAddLinksForType,linkColor,highlightedLinkColor,underlineStyle,underlineLinksForTypes,onlyCatchTouchesOnLinks;
@synthesize centerVertically,extendBottomToFit;

- (void)commonInit
{
	customLinks = [[NSMutableArray alloc] init];
	self.linkColor = [UIColor blueColor];
    self.highlightedLinkColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    self.underlineStyle = kCTUnderlineStyleNone ;
    self.underlineLinksForTypes = YES;
	self.automaticallyAddLinksForType = NSTextCheckingTypeLink;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:0"]]) {
		self.automaticallyAddLinksForType |= NSTextCheckingTypePhoneNumber;
	}
	self.onlyCatchTouchesOnLinks = YES;
	self.userInteractionEnabled = YES;
	self.contentMode = UIViewContentModeRedraw;
	[self resetAttributedText];
}

- (id) init
{
    if (self = [super init]) 
    {
        [self commonInit];
    }
    return self;
}
- (id) initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self != nil) 
    {
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	if (self != nil) 
    {
		[self commonInit];
	}
	return self;
}


-(void)dealloc
{
	[_attributedText release];
	[customLinks release];
	self.linkColor = nil;
    self.highlightedLinkColor = nil;
	[self resetTextFrame];
    [activeLink release];
	[super dealloc];
}

-(void)drawTextInRect:(CGRect)rect
{
    if (!_attributedText) 
    {
        [super drawTextInRect:rect];
        return;
    }
    else
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		// flipping the context to draw core text
		// no need to flip our typographical bounds from now on
		CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
		
		if (self.shadowColor) 
        {
			CGContextSetShadowWithColor(ctx, self.shadowOffset, 0.0, self.shadowColor.CGColor);
		}
        NSMutableAttributedString* attrStrWithLinks = [self attributedTextWithLinks];
        if (textFrame == NULL) 
        {
			CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStrWithLinks);
			drawingRect = self.bounds;
            
            if (self.centerVertically || self.extendBottomToFit)
            {
				CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,CGSizeMake(drawingRect.size.width,CGFLOAT_MAX),NULL);
				if (self.extendBottomToFit) 
                {
					CGFloat delta = MAX(0.f , ceilf(sz.height - drawingRect.size.height)) + 10 /* Security margin */;
					drawingRect.origin.y -= delta;
					drawingRect.size.height += delta;
				}
				if (self.centerVertically) 
                {
					drawingRect.origin.y -= (drawingRect.size.height - sz.height)/2;
				}
            }
            
			CGMutablePathRef path = CGPathCreateMutable();
			CGPathAddRect(path, NULL, drawingRect);
			textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
			CGPathRelease(path);
			CFRelease(framesetter);
		}
        
        if (activeLink) 
        {
            [self drawActiveLinkHighlightForRect:drawingRect];
        }
		
		CTFrameDraw(textFrame, ctx);
        
		CGContextRestoreGState(ctx);
        
        
        
    }
}

#pragma -
#pragma mark Private Methods

-(void)drawActiveLinkHighlightForRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, CGAffineTransformMakeTranslation(rect.origin.x, rect.origin.y));
    [self.highlightedLinkColor setFill];
    
    NSRange activeLinkRange = activeLink.range;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    CFIndex lineCount =CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < lineCount; lineIndex++) 
    {
		CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
		
		if (!CTLineContainsCharactersFromStringRange(line, activeLinkRange)) 
        {
			continue; // with next line
		}
		
		// we use this rect to union the bounds of successive runs that belong to the same active link
		CGRect unionRect = CGRectZero;
		
		CFArrayRef runs = CTLineGetGlyphRuns(line);
		CFIndex runCount = CFArrayGetCount(runs);
		for (CFIndex runIndex = 0; runIndex < runCount; runIndex++) 
        {
			CTRunRef run = CFArrayGetValueAtIndex(runs, runIndex);
			
			if (!CTRunContainsCharactersFromStringRange(run, activeLinkRange)) 
            {
				if (!CGRectIsEmpty(unionRect)) 
                {
					CGContextFillRect(ctx, unionRect);
					unionRect = CGRectZero;
				}
				continue; // with next run
			}
			
			CGRect linkRunRect = CTRunGetTypographicBoundsAsRect(run, line, lineOrigins[lineIndex]);
			linkRunRect = CGRectIntegral(linkRunRect);		// putting the rect on pixel edges
			linkRunRect = CGRectInset(linkRunRect, -1, -1);	// increase the rect a little
			if (CGRectIsEmpty(unionRect)) 
            {
				unionRect = linkRunRect;
			} 
            else 
            {
				unionRect = CGRectUnion(unionRect, linkRunRect);
			}
		}
		if (!CGRectIsEmpty(unionRect)) 
        {
			CGContextFillRect(ctx, unionRect);
			//unionRect = CGRectZero;
		}
	}
	CGContextRestoreGState(ctx);
    
}


-(void)resetTextFrame 
{
	if (textFrame) {
		CFRelease(textFrame);
		textFrame = NULL;
	}
}


-(NSMutableAttributedString *)attributedTextWithLinks
{
    NSMutableAttributedString *str = [self.attributedText mutableCopy];
    if (!str) return nil;
    // Detect the phone number url or links, set it to blue color. 
    // Set the underline style single or none according to the underlineLinksForTypes.
    NSString* plainText = [str string];
    if (plainText && (self.automaticallyAddLinksForType >0)) 
    {
        NSError * error = nil;
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:self.automaticallyAddLinksForType error:&error];
        [linkDetector enumerateMatchesInString:plainText options:0 range:NSMakeRange(0, [plainText length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            int32_t uStyle = self.underlineLinksForTypes ? kCTUnderlineStyleSingle : kCTUnderlineStyleNone;
            UIColor *thisLinkColor = self.linkColor;
            
            if (thisLinkColor) 
            {
                [str setTextColor:thisLinkColor range:[result range]];
            }
            if (uStyle>0) 
            {
                [str setTextUnderlineStyle:uStyle range:[result range]];
            }
        }];
    }
    
    // the custom link styles.
    [customLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
	 {
		 NSTextCheckingResult* result = (NSTextCheckingResult*)obj;
         UIColor *thisLinkColor = (self.delegate && [self.delegate respondsToSelector:@selector(colorForLink:)]) ? [self.delegate colorForLink:result] : self.linkColor;
         
         int32_t uStyle = (self.delegate && [self.delegate respondsToSelector:@selector(underlineStyle:)]) ? [self.delegate underlineStyle:result] : underlineStyle;
         
		 @try {
			 if (thisLinkColor)
				 [str setTextColor:thisLinkColor range:[result range]];
             if (uStyle >0)
                 [str setTextUnderlineStyle:uStyle range:[result range]];
		 }
		 @catch (NSException * e) {
			 // Protection against NSRangeException
			 if ([[e name] isEqualToString:NSRangeException]) {
				 NSLog(@"AttributedLabel exception: %@",e);
			 } else {
				 @throw;
			 }
		 }
	 }];
	return [str autorelease];
    
}

#pragma -
#pragma mark Setters and Getters
-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [self setAttributedText:attributedText withLabelStyles:NO];
}
-(NSAttributedString *)attributedText
{
    if (!_attributedText) 
    {
        [self resetAttributedText];
    }
    // use copy instance to return, so the attributedText itself will keep immutable.
    return [[_attributedText copy] autorelease]; 
}
-(void)setText:(NSString *)text 
{
	NSString* cleanedText = [[text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"]
							 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[super setText:cleanedText]; // will call setNeedsDisplay too
	[self resetAttributedText];
}
-(void)setFont:(UIFont *)font 
{
	[_attributedText setFont:font];
	[super setFont:font]; // will call setNeedsDisplay too
}
-(void)setTextColor:(UIColor *)color 
{
	[_attributedText setTextColor:color];
	[super setTextColor:color]; // will call setNeedsDisplay too
}
-(void)setTextAlignment:(UITextAlignment)alignment 
{
	CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(alignment);
	CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
	[_attributedText setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
	[super setTextAlignment:alignment]; // will call setNeedsDisplay too
}
-(void)setLineBreakMode:(UILineBreakMode)lineBreakMode 
{
	CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
	CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(lineBreakMode);
	[_attributedText setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
	
	[super setLineBreakMode:lineBreakMode]; // will call setNeedsDisplay too
	
#if MyAttributedLabel_WarnAboutKnownIssues
	[self warnAboutKnownIssues_CheckLineBreakMode];
#endif	
}

-(void)setCenterVertically:(BOOL)val {
	centerVertically = val;
	[self setNeedsDisplay];
}

-(void)setAutomaticallyAddLinksForType:(NSTextCheckingTypes)types {
	automaticallyAddLinksForType = types;
	[self setNeedsDisplay];
}

-(void)setExtendBottomToFit:(BOOL)val {
	extendBottomToFit = val;
	[self setNeedsDisplay];
}

-(void)setNeedsDisplay 
{
	[self resetTextFrame];
	[super setNeedsDisplay];
}


#pragma mark MyAttributedLabel Methods
-(void)setAttributedText:(NSAttributedString *)attributedText withLabelStyles:(BOOL)useLabelSytles
{
    [_attributedText release];
    _attributedText = [attributedText mutableCopy];
    if (useLabelSytles) 
    {
        [_attributedText setFont:self.font];
        [_attributedText setTextAlignment:CTTextAlignmentFromUITextAlignment(self.textAlignment) lineBreakMode:CTLineBreakModeFromUILineBreakMode(self.lineBreakMode)];
        [_attributedText setTextColor:self.textColor];
    }
    [self removeAllCustomLinks];
    [self setNeedsDisplay];
}

-(void)resetAttributedText 
{
	NSMutableAttributedString* mutAttrStr = [NSMutableAttributedString attributedStringWithString:self.text];
	[mutAttrStr setFont:self.font];
	[mutAttrStr setTextColor:self.textColor];
    CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
    CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
    [mutAttrStr setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
	self.attributedText = mutAttrStr;
}

-(void)addCustomLink: (NSURL *)linkUrl inRange: (NSRange)range 
{
	NSTextCheckingResult* link = [NSTextCheckingResult linkCheckingResultWithRange:range URL:linkUrl];
	[customLinks addObject:link];
	[self setNeedsDisplay];
    
}
-(void)removeAllCustomLinks
{
    [customLinks removeAllObjects];
	[self setNeedsDisplay];
}

#pragma -
#pragma mark RecognizeTouch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [activeLink release];
    activeLink = [[self linkAtPoint:point] retain];
    touchStartPoint = point;
    
    // we need to draw highlight according to the activeLink.
    [self setNeedsDisplay];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [activeLink release];
    activeLink = nil;
    // we need to draw highlight according to the activeLink.
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // call delegate methods.
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSTextCheckingResult *linkAtTouchesEnded = [self linkAtPoint:point];
    BOOL closeToStart = (abs(touchStartPoint.x -point.x)<10 && abs(touchStartPoint.y -point.y) <10);
    if(activeLink && (NSEqualRanges(activeLink.range,linkAtTouchesEnded.range) || closeToStart))
    {
        BOOL openLink = (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:shouldFollowLink:)]) ? [self.delegate attributedLabel:self shouldFollowLink:activeLink] : YES;
        if (openLink) 
        {
            [[UIApplication sharedApplication] openURL:activeLink.URL];
        }
    }
    // reset the clicked links.
    [activeLink release];
    activeLink = nil;
    [self setNeedsDisplay];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitResult = [super hitTest:point withEvent:event];
    if(hitResult !=self)
    {
        return hitResult;
    }
    if (self.onlyCatchTouchesOnLinks) 
    {
        BOOL didHitLink = ([self linkAtPoint: point] !=nil);
        if (!didHitLink) 
        {
            return nil;
        }
    }
    return hitResult;
}

-(NSTextCheckingResult *)linkAtPoint:(CGPoint) point
{
    static const CGFloat kVMargin = 5.f;
	if (!CGRectContainsPoint(CGRectInset(drawingRect, 0, -kVMargin), point)) return nil;
	
	CFArrayRef lines = CTFrameGetLines(textFrame);
	if (!lines) return nil;
	CFIndex nbLines = CFArrayGetCount(lines);
	NSTextCheckingResult* link = nil;
	
	CGPoint origins[nbLines];
	CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
	
	for (int lineIndex=0 ; lineIndex<nbLines ; ++lineIndex) 
    {
		// this actually the origin of the line rect, so we need the whole rect to flip it
		CGPoint lineOriginFlipped = origins[lineIndex];
		
		CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
		CGRect lineRectFlipped = CTLineGetTypographicBoundsAsRect(line, lineOriginFlipped);
		CGRect lineRect = CGRectFlipped(lineRectFlipped, CGRectFlipped(drawingRect,self.bounds));
		
		lineRect = CGRectInset(lineRect, 0, -kVMargin);
		if (CGRectContainsPoint(lineRect, point)) 
        {
			CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(lineRect),
												point.y-CGRectGetMinY(lineRect));
			CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
			link = ([self linkAtCharacterIndex:idx]);
			if (link) return link;
		}
	}
	return nil;
    
}

-(NSTextCheckingResult *)linkAtCharacterIndex: (CFIndex) index
{
    __block NSTextCheckingResult* foundResult = nil;
	
	NSString* plainText = [_attributedText string];
	if (plainText && (self.automaticallyAddLinksForType > 0)) 
    {
		NSError* error = nil;
		NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:self.automaticallyAddLinksForType error:&error];
		[linkDetector enumerateMatchesInString:plainText options:0 range:NSMakeRange(0,[plainText length])
									usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
		 {
			 NSRange r = [result range];
			 if (NSLocationInRange(index, r)) 
             {
				 foundResult = [[result retain] autorelease];
				 *stop = YES;
			 }
		 }];
		if (foundResult) return foundResult;
	}
	
	[customLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger aidx, BOOL *stop)
	 {
		 NSRange r = [(NSTextCheckingResult*)obj range];
		 if (NSLocationInRange(index, r)) 
         {
			 foundResult = [[obj retain] autorelease];
			 *stop = YES;
		 }
	 }];
	return foundResult;
    
}

#pragma -
#pragma mark Some Known Issues Warnings

#if MyAttributedLabel_WarnAboutKnownIssues
-(void)warnAboutKnownIssues_CheckLineBreakMode {
	BOOL truncationMode = (self.lineBreakMode == UILineBreakModeHeadTruncation)
	|| (self.lineBreakMode == UILineBreakModeMiddleTruncation)
	|| (self.lineBreakMode == UILineBreakModeTailTruncation);
	if (truncationMode) {
		NSLog(@"[MyAttributedLabel] Warning: \"UILineBreakMode...Truncation\" lineBreakModes not yet fully supported by CoreText and MyAttributedLabel");
		NSLog(@"                    (truncation will appear on each paragraph instead of the whole text)");
		NSLog(@"                    This is a known issue.");
	}
}
-(void)warnAboutKnownIssues_CheckAdjustsFontSizeToFitWidth {
	if (self.adjustsFontSizeToFitWidth) {
		NSLog(@"[MyAttributedLabel] Warning: \"adjustsFontSizeToFitWidth\" property not supported by CoreText and MyAttributedLabel! This property will be ignored.");
	}	
}
-(void)setAdjustsFontSizeToFitWidth:(BOOL)value {
	[super setAdjustsFontSizeToFitWidth:value];
	[self warnAboutKnownIssues_CheckAdjustsFontSizeToFitWidth];
}

-(void)setNumberOfLines:(NSInteger)nbLines {
	NSLog(@"[MyAttributedLabel] Warning: the numberOfLines property is not yet supported by CoreText and MyAttributedLabel. (this property is ignored right now)");
	NSLog(@"                    This is a known issue .");
	[super setNumberOfLines:nbLines];
}
#endif

@end
