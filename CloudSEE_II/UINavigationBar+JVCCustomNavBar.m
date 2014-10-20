//
//  UINavigationBar+JVCCustomNavBar.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "UINavigationBar+JVCCustomNavBar.h"
#import <objc/runtime.h>
@implementation UINavigationBar (JVCCustomNavBar)
//- (UIImage *)barBackground
//{
//    // 你要设定的背景
//    if (IOS_VERSION>=IOS7) {
//        
//        return nil;
//        
//    }
//    return [UIImage imageNamed:@"top_bg.png"];
//}
//
//- (void)didMoveToSuperview
//{
//    //iOS5 only
//    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
//    }
//}
//
////this doesn't work on iOS5 but is needed for iOS4 and earlier
//- (void)drawRect:(CGRect)rect
//{
//    //draw image
//    [[self barBackground] drawInRect:rect];
//}


static void setter(UINavigationBar *self, SEL _cmd, UIColor *tintColor)
{
    self.tintColor = tintColor;
}

static UIColor *getter(UINavigationBar *self, SEL _cmd)
{
	return self.tintColor;
}


+ (void)initialize
{
	if (![self instancesRespondToSelector:@selector(setBarTintColor:)]) {
		class_addMethod([self class], @selector(setBarTintColor:), (IMP)setter, "v@:@");
		class_addMethod([self class], @selector(barTintColor), (IMP)getter, "@@:");
	}
}

@end
