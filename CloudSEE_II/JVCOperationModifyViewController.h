//
//  JVCOperationModifyViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/31/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
@class JVCDeviceModel;

static const int kOperationMofifyTypeSUCCESS      = 0;//成功

@protocol JVCOperationModifyViewControllerDelegate <NSObject>

/**
 *  修改完之后的返回事件
 */
- (void)modifyDeviceInfoCallBack;
@end


@interface JVCOperationModifyViewController : JVCBaseSliderViewController<UITextFieldDelegate>
{
    JVCDeviceModel *modifyModel;
    
    id<JVCOperationModifyViewControllerDelegate>modifyDelegate;
}
@property(nonatomic,retain) JVCDeviceModel *modifyModel;
@property(nonatomic,assign)id<JVCOperationModifyViewControllerDelegate>modifyDelegate;

@end
