//
//  UINavigationController+Rotation_IOS6.m
//  CloudSEE_II
//  解决当rootViewController为tabbar时，图片的旋转问题
//  Created by Yanghu on 9/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "UINavigationController+Rotation_IOS6.h"

@implementation UINavigationController (Rotation_IOS6)

-(BOOL)shouldAutorotate {
    
        return [[self.viewControllers lastObject] shouldAutorotate];
}


-(NSUInteger)supportedInterfaceOrientations {
    
        return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
     
        return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
