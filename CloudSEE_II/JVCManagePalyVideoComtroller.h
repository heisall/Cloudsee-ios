//
//  JVCManagePalyVideoComtroller.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCOperationController.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCMonitorConnectionSingleImageView.h"

enum CONNECTALLDEVICE{
    
    CONNECTALLDEVICE_Run = 1, //正在全连接
    CONNECTALLDEVICE_End = 0, //全连接结束
    
    
};

@interface JVCManagePalyVideoComtroller : UIView<ystNetWorkHelpDelegate,UIScrollViewDelegate,YstNetWorkHelpOperationDelegate>
{
    JVCOperationController  *_operationController;
    int                     imageViewNums;            //ScorllView每页视图显示的窗体个数
    int                     _iCurrentPage;
    int                     _iBigNumbers;
    int                     nSelectedChannelIndex;
    NSString               *strSelectedDeviceYstNumber;
}

@property (nonatomic,retain) NSMutableArray         *amChannelListData;
@property (nonatomic,assign) JVCOperationController *_operationController;
@property (nonatomic,assign) int                     imageViewNums,_iCurrentPage,_iBigNumbers;
@property (nonatomic,assign) int                     nSelectedChannelIndex;
@property (nonatomic,assign) NSString               *strSelectedDeviceYstNumber;

/**
 *  初始化视频播放的窗口布局
 */
-(void)initWithLayout;

-(void)_playVideoCilck:(int)windowsIndex selectedChannel:(int)selectedChannel;
/**
 *  切割窗口的处理函数
 *
 *  @param singeShowViewNumber 一个视图窗口同时显示监控窗口的数量
 */
-(void)splitViewWindow:(int)singeShowViewNumber;

-(void)changeContenView;
-(BOOL)returnPlayBackViewState;
-(void)setScrollviewByIndex:(NSInteger)Index;


/**
 *  取消全连事件 (子线程调用)
 */
-(void)CancelConnectAllVideoByLocalChannelID;

@end
