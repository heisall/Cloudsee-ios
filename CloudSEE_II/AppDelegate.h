//
//  AppDelegate.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
        NSMutableArray *_amOpenGLViewListData; //存放GlView显示类的集合
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) NSMutableArray *_amOpenGLViewListData;

/**
 *  初始化TabarViewControllers
 */
-(void)initWithTabarViewControllers;

/**
 *  重新登录后，初始化TabarViewControllers
 */
-(void)UpdateTabarViewControllers;
@end
