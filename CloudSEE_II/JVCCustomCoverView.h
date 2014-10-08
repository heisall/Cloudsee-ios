//
//  JVCCustomCoverView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/7/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCoverViewDelegate <NSObject>

/**
 *  点击4、9、16分屏的回调
 *
 *  @param screanNum 分屏num
 */
- (void)customCoverViewButtonCkickCallBack:(int)screanNum;

@end

enum SCREANMUM
{
    SCREAN_ONE      = -1,   //一分屏
    SCREAN_FOUR     = 0 ,   //4分屏
    SCREAN_NIME     = 2,    //九分屏
    SCREAN_SISTEN   = 3,  //十六分屏
};

@interface JVCCustomCoverView : UIView
{
    id<CustomCoverViewDelegate>CustomCoverDelegate;
}

@property(nonatomic,assign)    id<CustomCoverViewDelegate>CustomCoverDelegate;

/**
 *  单例
 *
 *  @return 返回 单例
 */
+ (JVCCustomCoverView *)shareInstance;

/**
 *  跟新覆盖试图消息
 *
 *  @param titleArray 分屏消息
 *  @param skinType   皮肤
 */
- (void)updateConverViewWithTitleArray:(NSArray *)titleArray  skinType:(int )skinType;

/**
 *  移除converview
 */
- (void)removeConverView;

@end
