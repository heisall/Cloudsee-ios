//
//  NormalCircle.m
//  SuQian
//
//  Created by Suraj on 24/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import "NormalCircle.h"
#import <QuartzCore/QuartzCore.h>

#define kOuterColor			[UIColor colorWithRed:128.0/255.0 green:127.0/255.0 blue:123.0/255.0 alpha:0.9]
#define kInnerColor			[UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:0.6]
#define kHighlightColor	[UIColor colorWithRed:255.0/255.0 green:252.0/255.0 blue:255.0/255.0 alpha:0.9]
#define kLineColorInRound			[UIColor colorWithRed:45.0/255.0 green:67.0/255.0 blue:129.0/255.0 alpha:0.4]

#define KLineWidth 1.0

#define KRadiusWidth 4.0


@implementation NormalCircle
@synthesize selected,cacheContext;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

- (id)initwithRadius:(CGFloat)radius
{
	CGRect frame = CGRectMake(0, 0, 2*radius, 2*radius);
	NormalCircle *circle = [self initWithFrame:frame];
	if (circle) {
		[circle setBackgroundColor:[UIColor clearColor]];
	}
	return circle;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	self.cacheContext = context;
	CGFloat lineWidth = KLineWidth;
	CGRect rectToDraw = CGRectMake(rect.origin.x+lineWidth, rect.origin.y+lineWidth, rect.size.width-2*lineWidth, rect.size.height-2*lineWidth);
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, kOuterColor.CGColor);
	CGContextStrokeEllipseInRect(context, rectToDraw);
	
	// Fill inner part
	CGRect innerRect = CGRectInset(rectToDraw,1, 1);
    //CGContextSetFillColorWithColor(context, kInnerColor.CGColor);
	CGContextFillEllipseInRect(context, innerRect);
	
	if(self.selected == NO)
		return;
	
    //设置蓝色的背景
    CGRect smallerRectInRound = CGRectInset(rectToDraw,5.0, 5.0);
	CGContextSetFillColorWithColor(context, kLineColorInRound.CGColor);
	CGContextFillEllipseInRect(context, smallerRectInRound);

    
	// For selected View
	CGRect smallerRect = CGRectInset(rectToDraw,25.0, 25.0);
	CGContextSetFillColorWithColor(context, kHighlightColor.CGColor);
	CGContextFillEllipseInRect(context, smallerRect);
}

- (void)highlightCell
{
	self.selected = YES;
	[self setNeedsDisplay];
}

- (void)resetCell
{
	self.selected = NO;
	[self setNeedsDisplay];
}


@end
