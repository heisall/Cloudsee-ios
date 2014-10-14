//
//  JVCLickTypeViewController.h
//  CloudSEE_II
//  
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
#import "JVCLabelFieldSView.h"

@class JVCDeviceModel;
@interface JVCLickTypeViewController : JVCBaseSliderViewController<UITextFieldDelegate,JVCLabelFieldSViewDelegate>
{
    JVCDeviceModel *deviceModel;
    
    
    JVCLabelFieldSView *YStLinkView;
    
    JVCLabelFieldSView *IPLinkView;
}
@property(nonatomic,retain)JVCDeviceModel *deviceModel;
@property(nonatomic,retain) JVCLabelFieldSView *YStLinkView;
@property(nonatomic,retain)JVCLabelFieldSView *IPLinkView;

/**
 *  处理按钮按下保存事件的返回值
 *
 *  @param linkType 返回值
 */
- (void)modiyDeviceLinkModelToServer:(int)linkType;
@end
