//
//  JVCSignleAlarmDisplayView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/16/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCAlarmModel.h"

@protocol playVideoDelegate <NSObject>

/**
 *  播放view的回调
 */
- (void)playVideoCallBack:(JVCAlarmModel *)playModel;

@end


@interface JVCSignleAlarmDisplayView : UIView
{
    id<playVideoDelegate>palyVideoDelegate;
}

@property(nonatomic,retain)JVCAlarmModel *tAlarmModel;
@property(nonatomic,assign)id<playVideoDelegate>palyVideoDelegate;
- (void)initView;

- (void)ClickbackGroud;
- (void)showToastAlert;

@end
