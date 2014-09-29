//
//  UITabBarController+Rotation_IOS6.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Rotation_IOS6)

- (BOOL)shouldAutorotate;

- (NSUInteger)supportedInterfaceOrientations;

@end
