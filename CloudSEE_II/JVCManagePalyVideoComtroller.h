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
    UIScrollView            *WheelShowListView;
    NSMutableArray          *amChannelListData;
    JVCOperationController  *_operationController;
    int                     imageViewNums;            //ScorllView每页视图显示的窗体个数
    int                     _iCurrentPage;
    int                     _iBigNumbers;
    int                     nSelectedChannelIndex;
}

@property (nonatomic,retain) NSMutableArray *amChannelListData;
@property (nonatomic,assign) JVCOperationController *_operationController;
@property (nonatomic,assign) UIScrollView *WheelShowListView;
@property (nonatomic,assign) int imageViewNums,_iCurrentPage,_iBigNumbers;
@property (nonatomic,assign) int nSelectedChannelIndex;

-(void)initWithLayout;
-(void)_playVideoCilck:(int)windowsIndex selectedChannel:(int)selectedChannel;
-(void)changeContenView;
-(BOOL)returnPlayBackViewState;
-(void)setScrollviewByIndex:(NSInteger)Index;


/**
 *  取消全连事件 (子线程调用)
 */
-(void)CancelConnectAllVideoByLocalChannelID;

@end
