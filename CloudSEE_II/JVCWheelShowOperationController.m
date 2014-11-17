//
//  JVCWheelShowOperationController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-16.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCWheelShowOperationController.h"
#import "JVCWheelShowManagePalyVideoComtroller.h"

@interface JVCWheelShowOperationController ()

@end

@implementation JVCWheelShowOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)initLayoutWithShowVideoView {
    
    /**
     *  播放窗体
     */
    _managerVideo                            = [[JVCWheelShowManagePalyVideoComtroller alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width*0.75)];
    _managerVideo.tag                        = 100;
    _managerVideo.strSelectedDeviceYstNumber = self.strSelectedDeviceYstNumber;
    _managerVideo._operationController       = self;
    _managerVideo.delegate                   = self;
    _managerVideo.isPlayBackVideo            = self.isPlayBackVideo;
    _managerVideo.nSelectedChannelIndex      = self._iSelectedChannelIndex;
    _managerVideo.imageViewNums              = kDefaultShowWidnowCount;
    _managerVideo.isConnectAll               = self.isConnectAll;
    [_managerVideo setUserInteractionEnabled:YES];
    [self.view addSubview:_managerVideo];
    [_managerVideo initWithLayout];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
