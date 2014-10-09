//
//  JVCOperationControllerIphone5.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/8/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationControllerIphone5.h"
#import "OpenALBufferViewcontroller.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCManagePalyVideoComtroller.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCOperationMiddleView.h"
//#import "managePalyVideoComtroller.h"

@interface JVCOperationControllerIphone5 ()
{
    /**
     *  音频监听、云台、远程回调的中间view
     */
    
    JVCOperationMiddleViewIphone5 *operationBigView;
}


@end

@implementation JVCOperationControllerIphone5

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化音频监听、云台、远程回放模块
 */
- (void)initOperationControllerMiddleViewwithFrame:(CGRect )newFrame
{
    operationBigView=[JVCOperationMiddleViewIphone5 shareInstance];
    
    CGFloat off_height=0;
    if (IOS_VERSION>=7.0) {
        off_height = 44;
    }
    operationBigView.frame=CGRectMake(newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height+self.navigationController.navigationBar.frame.size.height-off_height);
    [operationBigView updateViewWithTitleArray:[NSArray arrayWithObjects:NSLocalizedString(@"Audio", nil), NSLocalizedString(@"PTZ Control", nil),NSLocalizedString(@"Playback", nil),nil] detailArray:[NSArray arrayWithObjects:NSLocalizedString(@"Learn audio info at any time", nil), NSLocalizedString(@"Adjust PTZ at any time", nil),NSLocalizedString(@"Check Playback info at any time", nil),nil] skinType:skinSelect];
    operationBigView.delegateIphone5BtnCallBack=self;
    [self.view addSubview:operationBigView];
    [self.view setBackgroundColor:SETLABLERGBCOLOUR(239.0, 239.0, 239.0)];
    
    JVCCustomYTOView *ytoView = [JVCCustomYTOView shareInstance];
    ytoView.frame = CGRectMake(operationBigView.frame.origin.x,operationBigView.frame.origin.y,operationBigView.frame.size.width,operationBigView.frame.size.height-self.navigationController.navigationBar.frame.size.height+off_height);
    ytoView.tag=661;
    ytoView.delegateYTOperation=self;
    [self.view addSubview:ytoView];
    [ytoView setHidden:YES];
    
}

/**
 *  iphone5、5s中间的那块音频监听 云台 远程回放
 *
 *  @param clickBtnType 选则那个按钮
 */
-  (void)operationMiddleIphone5BtnCallBack:(int)clickBtnType
{
    DDLogInfo(@"%s====%d",__FUNCTION__,clickBtnType);
    
    [self MiddleBtnClickWithIndex:clickBtnType];
    
}

/**
 *  音频监听功能（关闭）
 *
 *  @param bState YES:(对讲模式下)  NO：音频监听模式下
 */
-(void)audioButtonClick:(BOOL)bState{
    
    OpenALBufferViewcontroller *openAlObj     = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    JVCCloudSEENetworkHelper           *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    /**
     *  如果是选中状态，置为非选中状态，如果是非选中状态，置为非选中状态
     */
    if ([[JVCOperationMiddleViewIphone5 shareInstance] getAudioBtnState]) {
        
        [ystNetworkObj  RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_AudioListening remoteOperationCommand:-1];
        
        [openAlObj stopSound];
        [openAlObj cleanUpOpenALMath];
        
        [[JVCOperationMiddleViewIphone5 shareInstance] setAudioBtnUNSelect];
        
    }else{
        
        [openAlObj initOpenAL];
        [ystNetworkObj  RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_AudioListening remoteOperationCommand:-1];
        
        [[JVCOperationMiddleViewIphone5 shareInstance] setAudioBtnSelectWithSkin];
    }
}

/**
 *  停止音频监听
 */
- (void)stopAudioMonitor
{
    if ([[JVCOperationMiddleViewIphone5 shareInstance] getAudioBtnState]) {
        
        [self MiddleBtnClickWithIndex:TYPEBUTTONCLI_SOUND];
        
        [[JVCOperationMiddleViewIphone5 shareInstance] setAudioBtnUNSelect];
        
    }
    
}

@end
