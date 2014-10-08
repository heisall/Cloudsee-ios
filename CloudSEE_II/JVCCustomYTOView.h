//
//  JVCCustomYTOView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/7/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YTOperationDelegate <NSObject>

/**
 *  云台操作的回调
 *
 *  @param YTJVNtype 云台控制的命令
 */
- (void)YTOperationDelegateCallBackWithJVNYTCType:(int )YTJVNtype ;

@end

/**
 *  云台操作的枚举类型，与宏定义的相同
 */
enum JVN_YTCTR_TYPE
{
    JVN_YTCTR_TYPE_U    = 1,//   1//上
    JVN_YTCTR_TYPE_D    = 2,//下
    JVN_YTCTR_TYPE_L    = 3,//左
    JVN_YTCTR_TYPE_R    = 4,//右
    JVN_YTCTR_TYPE_A    =  5,//自动
    JVN_YTCTR_TYPE_GQD  =  6,//光圈大
    JVN_YTCTR_TYPE_GQX  =  7,//光圈小
    JVN_YTCTR_TYPE_BJD  = 8,//变焦大
    JVN_YTCTR_TYPE_BJX  = 9,//变焦小
    JVN_YTCTR_TYPE_BBD  = 10,//变倍大
    JVN_YTCTR_TYPE_BBX  = 11,//变倍小
    JVN_YTCTR_TYPE_AT   =  25//自动停止
    
    
};

static const double  FULLWIDTH  = 480.0;
static const double  FULLHEIGHT = 320.0;

@interface JVCCustomYTOView : UIView
{
    id<YTOperationDelegate>delegateYTOperation;
    
}
@property(nonatomic,assign)id<YTOperationDelegate> delegateYTOperation;

/**
 *  单例
 *
 *  @return 返回DevicePredicateObject 单例
 */
+ (JVCCustomYTOView *)shareInstance;

/**
 *  显示云台
 */
-(void)showYTOperationView;

/**
 *  隐藏云台
 */
-(void)HidenYTOperationView;

@end
