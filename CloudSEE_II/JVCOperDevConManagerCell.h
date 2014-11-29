//
//  JVCOperDevConManagerCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JVCOperDevConManagerDelegate <NSObject>

- (void)JVCOperDevConManagerClickCallBack:(int)index switchState:(BOOL)state;
@end

typedef NS_ENUM(int, JVCOperaDevConManagerCellType)
{
    JVCOperaDevConManagerCellTypeSafe            =   0,//安全防护
    JVCOperaDevConManagerCellTypeTimerDuration   =   2,//防护时间段
    JVCOperaDevConManagerCellTypeMoventAttention =   1,//移动检测

};

@interface JVCOperDevConManagerCell : UITableViewCell
{
    id<JVCOperDevConManagerDelegate> deviceDelegate;
}
@property(nonatomic,assign)id<JVCOperDevConManagerDelegate> deviceDelegate;

- (void)updateCellContentWithIndex:(JVCOperaDevConManagerCellType)index  safeTimer:(NSString *)stringSafe andSwitchState:(BOOL)state;
@end
