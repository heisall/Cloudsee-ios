//
//  JVCManagePalyVideoComtroller.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCManagePalyVideoComtroller.h"
#import "JVCMonitorConnectionSingleImageView.h"
#import "JVNetConst.h"
#import "OpenALBufferViewcontroller.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCChannelScourseHelper.h"
#import "JVCAppHelper.h"
#import "JVCCloudSEENetworkMacro.h"

@interface JVCManagePalyVideoComtroller () {

    UIScrollView            *WheelShowListView;
}

enum showWindowNumberType{
    
    showWindowNumberType_One     = 1,
    showWindowNumberType_Four    = 4 ,
    showWindowNumberType_Nine    = 9 ,
    showWindowNumberType_Sixteen = 16,
};

@end

@implementation JVCManagePalyVideoComtroller

@synthesize amChannelListData,_operationController,imageViewNums;
@synthesize _iCurrentPage,_iBigNumbers,nSelectedChannelIndex;
@synthesize strSelectedDeviceYstNumber,delegate;

static const int  kPlayViewDefaultMaxValue            = showWindowNumberType_Four;
static const int  kPlayVideoWithFullFramCriticalValue = 4;

int  nAllLinkFlag;
BOOL isAllLinkRun;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self._iBigNumbers    = kPlayViewDefaultMaxValue;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

/**
 *  初始化视频显示窗口
 */
-(void)initWithLayout{
    
    JVCCloudSEENetworkHelper *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    int channelCount                              = [self channelCountAtSelectedYstNumber];
    ystNetWorkHelperObj.ystNWHDelegate   =self;
    
    WheelShowListView       = [[UIScrollView alloc] init];
    WheelShowListView.frame = CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
	WheelShowListView.directionalLockEnabled = YES;
	WheelShowListView.pagingEnabled = YES;
	WheelShowListView.showsVerticalScrollIndicator=NO;
	WheelShowListView.showsHorizontalScrollIndicator=YES;
	WheelShowListView.bounces=NO;
	WheelShowListView.delegate = self;
	WheelShowListView.backgroundColor=[UIColor clearColor];
	[self addSubview:WheelShowListView];
	[WheelShowListView release];
    
    int ncolumnCount  = sqrt(self.imageViewNums);
    
    if (ncolumnCount >= 1) {
        
        self._iBigNumbers = 1;
    }
    
    CGFloat imageViewHeight = self.frame.size.height / ncolumnCount;
    CGFloat imageViewWidth  = self.frame.size.width  / ncolumnCount;
    
	for (int i = 0;i < channelCount ; i++) {
        
		JVCMonitorConnectionSingleImageView *singleVideoShow = [[JVCMonitorConnectionSingleImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageViewWidth, imageViewHeight)];
      
        singleVideoShow.layer.borderWidth=1.0;
        [singleVideoShow unSelectUIView];
        singleVideoShow.singleViewType=1;
        singleVideoShow.wheelShowType=1;
        singleVideoShow.delegate =self;
		[singleVideoShow initWithView];
		singleVideoShow.tag=KWINDOWSFLAG+i;
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingelTabFrom_FOUR:)];
		singleRecognizer.numberOfTapsRequired = 1; // 单击
		[singleVideoShow addGestureRecognizer:singleRecognizer];
        
        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTabFrom:)];
		doubleRecognizer.numberOfTapsRequired = 2; // 双击
		[singleVideoShow addGestureRecognizer:doubleRecognizer];
		
		// 关键在这一行，如果双击确定偵測失败才會触发单击
		[singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
		[singleRecognizer release];
		[doubleRecognizer release];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedOncell:)];
        
        [singleVideoShow addGestureRecognizer:longPress];
        longPress.allowableMovement = NO;
        longPress.minimumPressDuration = 0.5;
        [longPress release];
        
        
        UISwipeGestureRecognizer *recognizer;
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [singleVideoShow addGestureRecognizer:recognizer];
        [recognizer release];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [singleVideoShow addGestureRecognizer:recognizer];
        [recognizer release];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [singleVideoShow  addGestureRecognizer:recognizer];
        [recognizer release];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [singleVideoShow  addGestureRecognizer:recognizer];
        [recognizer release];
        
        /**
         *  捏合的手势
         */
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(fingerpPinchGesture:)];
        [singleVideoShow  addGestureRecognizer:pinchGesture];
        [pinchGesture release];
        
        [WheelShowListView  addSubview:singleVideoShow];
        [singleVideoShow release];
    }
    
    [self isConnectAllStatus];
    
    [self changeContenView];
}

/**
 *  判断当前界面是否为全连状态
 */
-(void)isConnectAllStatus{
    
    int count = [self channelCountAtSelectedYstNumber];
    
    if (self.nSelectedChannelIndex == kJVCChannelScourseHelperAllConnectFlag) {
        
        if (count > showWindowNumberType_One && count <= showWindowNumberType_Four ) {
            
            self.imageViewNums = showWindowNumberType_Four;
            
        }else if (count > showWindowNumberType_Four && count <= showWindowNumberType_Nine ){
        
            self.imageViewNums = showWindowNumberType_Nine;
            
        }else if (count > showWindowNumberType_Nine && count <= showWindowNumberType_Sixteen) {
        
            self.imageViewNums = showWindowNumberType_Sixteen;
            
        }else if ( count > 0 && count <= showWindowNumberType_One) {
            
            self.imageViewNums = showWindowNumberType_One;
            
        }else if (count > showWindowNumberType_Sixteen ){
        
            self.imageViewNums = showWindowNumberType_Sixteen ;
            
        }else {
        
            self.imageViewNums = showWindowNumberType_One;
        }
        
        self.nSelectedChannelIndex = 0 ;
    }
}

- (void)setScrollviewByIndex:(NSInteger)Index
{
    CGPoint point = CGPointMake(Index*320, 0);
    
    [WheelShowListView setContentOffset:point animated:NO];
}

#pragma mark  手势的动作
- (void)fingerpPinchGesture:(UIPinchGestureRecognizer*)pinchGesture
{
    
    //横屏，进行云台控制，竖屏左右滑动scrollview
    
    int bDevieOrigin = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSLog(@"handleSwipeFrom ==%d",bDevieOrigin);
    
    if (bDevieOrigin == UIInterfaceOrientationPortrait ||bDevieOrigin ==  UIInterfaceOrientationPortraitUpsideDown) {
        
        return;
    }
    
    NSLog(@"pinchGesture=%lf",pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        
    }else if(pinchGesture.scale<1) {//捏合缩小
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBX];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBXT];

    }else if(pinchGesture.scale>1)//捏合放大
    {
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBD];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_BBDT];

        
    }
    
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
  
    //横屏，进行云台控制，竖屏左右滑动scrollview
    
    int bDevieOrigin = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSLog(@"handleSwipeFrom ==%d",bDevieOrigin);
    
    if (bDevieOrigin == UIInterfaceOrientationPortrait ||bDevieOrigin ==  UIInterfaceOrientationPortraitUpsideDown) {
        
        return;
    }
    
    // NSLog(@"Swipe received.");
    
    if (recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
    
        [self sendYTOperationWithOperationType:JVN_YTCTRL_D];
        usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_DT];

        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_U];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_UT];

        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_L];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_LT];

        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        [self sendYTOperationWithOperationType:JVN_YTCTRL_R];
         usleep(200*1000);
        [self sendYTOperationWithOperationType:JVN_YTCTRL_RT];

        
    }
    
    
}

-(void)longPressedOncell:(id)sender{
    
//    if (self.frame.size.height>=300.0||[_operationController returnIsplayBackVideo]) {
//        return;
//    }
//    
//    if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
//        JVCMonitorConnectionSingleImageView *singleView=(JVCMonitorConnectionSingleImageView*)((UILongPressGestureRecognizer *)sender).view;
//        if (![singleView getActivity]) {
//            
//            for (int i=0; i<[amChannelListData count]; i++) {
//                JVCMonitorConnectionSingleImageView *imgView=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
//                // NSLog(@"value=%d",self.tag);
//                //NSLog(@"imgView=%@",imgView );
//                if (singleView.tag!=imgView.tag) {
//                    [imgView unSelectUIView];
//                }else {
//                    if (self.imageViewNums==1) {
//                        [imgView unSelectUIView];
//                    }else{
//                        
//                        [imgView selectUIView];
//                    }
//                    _operationController._iSelectedChannelIndex=i;
//                }
//            }
//            //[_operationController gotoDeviceShowChannels];
//        }
//    }
}

#pragma mark  向设备发送手势
/**
 *  云台操作的回调
 *
 *  @param YTJVNtype 云台控制的命令
 */
- (void)sendYTOperationWithOperationType:(int )YTJVNtype
{
    DDLogInfo(@"==%s===%d",__FUNCTION__,YTJVNtype);
    
    [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] RemoteOperationSendDataToDevice:self.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_YTO remoteOperationCommand:YTJVNtype];
}

/**
 *  设置scrollview滚动状态
 *
 *  @param scrollState 状态
 */
- (void)setManagePlayViewScrollState:(BOOL)scrollState
{
    WheelShowListView.scrollEnabled = scrollState;
}

/**
 *  单击选中事件
 *
 *  @param sender 选中的视频显示窗口
 */
-(void)handleDoubleTabFrom:(id)sender{
    
    UITapGestureRecognizer *viewimage=(UITapGestureRecognizer*)sender;
    
    int channelsCount = [self channelCountAtSelectedYstNumber];
    
    if ([_operationController returnOperationState]|| channelsCount <= 1) {
        
        return;
    }
    
    int _views                 = self.imageViewNums;
    self.imageViewNums         = self._iBigNumbers;
    self._iBigNumbers          = _views;
    self.nSelectedChannelIndex =viewimage.view.tag-WINDOWSFLAG;
    [self changeContenView];
}

/**
 *  双击击选中事件
 *
 *  @param sender 选中的视频显示窗口
 */
-(void)handleSingelTabFrom_FOUR:(id)sender{
    
    if (showWindowNumberType_One ==self.imageViewNums) {
        
        if ([_operationController returnIsplayBackVideo]) {
            
            UITapGestureRecognizer *viewimage=(UITapGestureRecognizer*)sender;
            JVCMonitorConnectionSingleImageView *_clickSingleView=(JVCMonitorConnectionSingleImageView*)viewimage.view;
            _clickSingleView._isPlayBackState=!_clickSingleView._isPlayBackState;
        }
        return;
    }
    
	UITapGestureRecognizer *viewimage=(UITapGestureRecognizer*)sender;
    
    if (viewimage.view.tag==WINDOWSFLAG+self.nSelectedChannelIndex) {
        
        return;
    }
    
    int channelsCount = [self channelCountAtSelectedYstNumber];
    
    for (int i=0; i< channelsCount ; i++) {
        
        JVCMonitorConnectionSingleImageView *imgView = [self singleViewAtIndex:i];
        
        if (viewimage.view.tag!=imgView.tag) {
            
            [imgView unSelectUIView];
            
        }else {
            
            [imgView selectUIView];
            
            self.nSelectedChannelIndex=i;
        }
    }
}

#pragma mark scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
	int index=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    
    int channsCount = [self channelCountAtSelectedYstNumber];
    
    self._iCurrentPage=index;
    
    if (self.imageViewNums == showWindowNumberType_One) {
        
        if (self.nSelectedChannelIndex!=index) {
            
            //[_operationController stopSetting:_operationController._iSelectedChannelIndex];
        }
    
        self.nSelectedChannelIndex=index;
        
    }else {
        
        self.nSelectedChannelIndex = index *self.imageViewNums;
        
        for (int i=0; i < channsCount; i++) {
            
            JVCMonitorConnectionSingleImageView *imgView = [self singleViewAtIndex:i];
            
            if (self.nSelectedChannelIndex != i) {
                
                [imgView unSelectUIView];
                
            }else {
                
                [imgView selectUIView];
            }
        }
    }
    
    [self connectSingleDevicesAllChannel];
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
    
    [self refreshStreamType:singleView.nStreamType withIsHomeIPC:singleView.isHomeIPC effectType:singleView.iEffectType];
    
    [NSThread detachNewThreadSelector:@selector(stopVideoOrFrame) toTarget:self withObject:nil];
}


-(void)openCurrentSingleWindowsVideoData{
    
    //[_operationController openCurrentWindowsVideoData];
    
}

-(BOOL)returnPlayBackViewState{
    
    return [_operationController returnIsplayBackVideo];
    
}

#pragma mark 弹出设备的悬浮通道展示界面
-(void)_playVideoCilck:(int)windowsIndex selectedChannel:(int)selectedChannel{
    
   // [_operationController connectSingleChannel:windowsIndex selectedChannel:selectedChannel];
}

-(void)dealloc{
    
    [amChannelListData release];
    [super dealloc];
}


/**
 *  返回当前选择设备的通道个数
 *
 *  @return 当前选择设备的通道个数
 */
- (int)channelCountAtSelectedYstNumber {

    JVCChannelScourseHelper  *channelHelper       = [JVCChannelScourseHelper shareChannelScourseHelper];
    return [channelHelper channelModelWithDeviceYstNumber:self.strSelectedDeviceYstNumber].count;
}

/**
 *  获取指定索引的单个视图窗口
 *
 *  @param index 索引
 *
 *  @return 单个视图窗口
 */
-(JVCMonitorConnectionSingleImageView *)singleViewAtIndex:(int)index {
    
     return (JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+index];
}

/**
 *  改变窗体布局
 */
-(void)changeContenView{
    
    int channelCount              = [self channelCountAtSelectedYstNumber];
    JVCAppHelper *apphelper       = [JVCAppHelper shareJVCAppHelper];

    WheelShowListView.frame=CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
    
    int count    = channelCount;
    
    int pageNums = count/self.imageViewNums;
    
	if (count%self.imageViewNums != 0) {
        
		pageNums = pageNums+1;
	}
    
	CGSize newSize = CGSizeMake(self.frame.size.width*pageNums,self.frame.size.height);
	[WheelShowListView setContentSize:newSize];
    
    CGFloat  totalWidth      = self.frame.size.width;
    CGFloat  totalHeight     = self.frame.size.height;
    int      ncolumnCount    = sqrt(self.imageViewNums);
    CGFloat  imageViewHeight = totalHeight/ncolumnCount;
    CGFloat  imageViewWidth  = totalWidth/ncolumnCount;
    
	for (int i=0;i < count ; i++) {
        
        int pageIndex = i / self.imageViewNums;
        int index     = i % self.imageViewNums;
        
        CGRect rect;
        rect.size.width  = imageViewWidth ;
        rect.size.height = imageViewHeight;
        
        [apphelper viewInThePositionOfTheSuperView:totalWidth viewCGRect:rect nColumnCount:ncolumnCount viewIndex:index+1];
        
        rect.origin.x += totalWidth * pageIndex;
        
        JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:i];
		singleVideoShow.frame = rect;
        [singleVideoShow updateChangeView];
        [singleVideoShow unSelectUIView];
	}
    
    int positionIndex  = self.nSelectedChannelIndex;
    
    self._iCurrentPage = positionIndex;
    
    if (self.imageViewNums != showWindowNumberType_One ) {
        
        JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];
        
        [singleVideoShow selectUIView];
        
        positionIndex      = positionIndex/self.imageViewNums;
        self._iCurrentPage =positionIndex;
    }
    
    CGPoint position = CGPointMake(self.bounds.size.width*positionIndex,0);
	[WheelShowListView setContentOffset:position animated:NO];
    
    [self connectSingleDevicesAllChannel];
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
    
    [self refreshStreamType:singleView.nStreamType withIsHomeIPC:singleView.isHomeIPC effectType:singleView.iEffectType];
    
    [NSThread detachNewThreadSelector:@selector(stopVideoOrFrame) toTarget:self withObject:nil];
}

#pragma mark 全连接处理

/**
 *  全连事件(子线程调用)
 */
-(void)connectSingleDevicesAllChannel{
	
    [NSThread detachNewThreadSelector:@selector(runConnectAllVideoByLocalChannelID) toTarget:self withObject:nil];
}

/**
 *  全连函数
 */
-(void)runConnectAllVideoByLocalChannelID{
    
    [self CancelConnectAllVideoByLocalChannelID];
    
    nAllLinkFlag   = CONNECTALLDEVICE_Run;
    
    int endIndex   = (self._iCurrentPage + 1) * self.imageViewNums;
    int startIndex =  self._iCurrentPage      * self.imageViewNums;
    int maxCount   = [self channelCountAtSelectedYstNumber];
    
    endIndex =  endIndex >= maxCount ? maxCount : endIndex;
    
    DDLogVerbose(@"%s----startIndex=%d----endIndex=%d",__FUNCTION__,startIndex,endIndex);
    
    for (int i = startIndex; i < endIndex; i++) {
        
        if (isAllLinkRun) {
            
            isAllLinkRun = FALSE;
            nAllLinkFlag = CONNECTALLDEVICE_End;
            DDLogVerbose(@"%s -- run hahhah wait end 003.....",__FUNCTION__);
            return;
        }
        
        [self connectVideoByLocalChannelID:WINDOWSFLAG+i];
        
        if (i!=endIndex-1){
            
            usleep(CONNECTINTERVAL);
        }
    }
    
    nAllLinkFlag = CONNECTALLDEVICE_End;
}

/**
 *  取消全连事件 (子线程调用)
 */
-(void)CancelConnectAllVideoByLocalChannelID {
    
    if (nAllLinkFlag == CONNECTALLDEVICE_Run) {
        
        isAllLinkRun=true;
        
        while (true) {
            
            if (isAllLinkRun) {
                
                DDLogVerbose(@"%s -- run hahhah wait.....",__FUNCTION__);
                usleep(500);
                
            }else{
                
                isAllLinkRun=FALSE;
                break;
            }
        }
    }
}

#pragma mark monitorConnectionSingleImageView delegate

-(void)connectVideoCallBack:(int)nShowWindowID{
    
    [self connectVideoByLocalChannelID:nShowWindowID];
}

/**
 *  远程回放快进
 *
 *  @param nFrameValue 快进的帧数
 */
-(void)fastforwardToFrameValue:(int)nFrameValue{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:self.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_RemotePlaybackSEEK remoteOperationCommand:nFrameValue];
      
    });

}

/**
 *  切割窗口的处理函数
 *
 *  @param singeShowViewNumber 一个视图窗口同时显示监控窗口的数量
 */
-(void)splitViewWindow:(int)singeShowViewNumber{
    
    self.imageViewNums=singeShowViewNumber;
    
    self._iBigNumbers=1;
    
    [self changeContenView];
}

#pragma mark 与网络库交互的功能模块 ystNetWorkHeper delegate

/**
 *  云视通连接的回调函数
 *
 *  @param connectCallBackInfo 连接的返回信息
 *  @param nlocalChannel       对应的本地通道
 *  @param connectResultType   连接返回的状态
 */
-(void)ConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType{
    
    [connectCallBackInfo retain];
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:nlocalChannel-1];

    [singleView connectResultShowInfo:connectCallBackInfo connectResultType:connectResultType];
    
    [connectCallBackInfo release];
}

/**
 *  根据所选显示视频的窗口的编号连接通道集合中指定索引的通道对象
 *
 *  @param nlocalChannelID 本地显示窗口的编号
 */
-(void)connectVideoByLocalChannelID:(int)nlocalChannelID{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCChannelScourseHelper             *channelSourceObj    = [JVCChannelScourseHelper shareChannelScourseHelper];
        NSMutableArray                      *channels            = [channelSourceObj channelModelWithDeviceYstNumber:self.strSelectedDeviceYstNumber];
        int                                  channelID           = nlocalChannelID - WINDOWSFLAG + 1;
       
        JVCMonitorConnectionSingleImageView *singleView          = [self singleViewAtIndex:nlocalChannelID - WINDOWSFLAG];
        
        DDLogCVerbose(@"%s---%@",__FUNCTION__,singleView);
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        BOOL                                 connectStatus       = [ystNetWorkHelperObj checknLocalChannelExistConnect:channelID];
        JVCDeviceModel                      *deviceModel         = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:self.strSelectedDeviceYstNumber];
        
        int                                  channelIndex        = nlocalChannelID - WINDOWSFLAG;
        
        [channels retain];
        
        JVCChannelModel                 *channelModel            = (JVCChannelModel *)[channels objectAtIndex:channelIndex];
        NSString                        *connectInfo             = [NSString stringWithFormat:@"%@-%d",channelModel.strDeviceYstNumber,channelModel.nChannelValue];
    
        //重复连接
        if (!connectStatus) {
            
            [singleView startActivity:connectInfo isConnectType:deviceModel.linkType];
            
            if (deviceModel.linkType) {
                
                connectStatus = [ystNetWorkHelperObj ipConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue  strUserName:deviceModel.userName strPassWord:deviceModel.passWord strRemoteIP:deviceModel.ip nRemotePort:[deviceModel.port intValue] nSystemVersion:IOS_VERSION isConnectShowVideo:TRUE];
               
            }else{
                
                connectStatus = [ystNetWorkHelperObj ystConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue strYstNumber:channelModel.strDeviceYstNumber strUserName:deviceModel.userName strPassWord:deviceModel.passWord nSystemVersion:IOS_VERSION isConnectShowVideo:TRUE];
            }
        }
        
        [channels release];
    });
}

/**
 *  OpenGL显示的视频回调函数
 *
 *  @param nLocalChannel      本地显示窗口的编号
 *  @param imageBufferY       YUV数据中的Y数据
 *  @param imageBufferU       YUV数据中的U数据
 *  @param imageBufferV       YUV数据中的V数据
 *  @param decoderFrameWidth  视频的宽
 *  @param decoderFrameHeight 视频的高
 */
-(void)H264VideoDataCallBackMath:(int)nLocalChannel
                    imageBufferY:(char *)imageBufferY
                    imageBufferU:(char *)imageBufferU
                    imageBufferV:(char *)imageBufferV
               decoderFrameWidth:(int)decoderFrameWidth
              decoderFrameHeight:(int)decoderFrameHeight
       nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber{
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:nLocalChannel-1];
    
    [singleView setImageBuffer:imageBufferY imageBufferU:imageBufferU imageBufferV:imageBufferV decoderFrameWidth:decoderFrameWidth decoderFrameHeight:decoderFrameHeight nPlayBackFrametotalNumber:nPlayBackFrametotalNumber];

    
    [NSThread detachNewThreadSelector:@selector(stopVideoOrFrame) toTarget:self withObject:nil];
    
}

/**
 *  视频来O帧之后请求文本聊天
 *
 *  @param nLocalChannel 本地显示的通道编号 需减去1
 */
-(void)RequestTextChatCallback:(int)nLocalChannel {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCMonitorConnectionSingleImageView  *singleView          =  [self singleViewAtIndex:nLocalChannel-1];
         JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        if (singleView.nStreamType == VideoStreamType_Default) {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
            
        }else {
            
             [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_paraInfo remoteOperationCommand:-1];
        }

    });
}

/**
 *  文本聊天请求的结果回调
 *
 *  @param nLocalChannel 本地本地显示窗口的编号
 *  @param nStatus       文本聊天的状态
 */
-(void)RequestTextChatStatusCallBack:(int)nLocalChannel withStatus:(int)nStatus{

    if (nStatus == JVN_RSP_TEXTACCEPT) {
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWRODelegate                      = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_paraInfo remoteOperationCommand:-1];
            
        });
    }
}

/**
 *  获取当前连接通道的码流参数
 *
 *  @param nLocalChannel 本地连接通道编号
 *  @param nStreamType     码流类型  1:高清 2：标清 3：流畅 0:默认不支持切换码流
 */
-(void)deviceWithFrameStatus:(int)nLocalChannel withStreamType:(int)nStreamType withIsHomeIPC:(BOOL)isHomeIPC withEffectType:(int)effectType{
    
    DDLogVerbose(@"effectType==%d===",effectType);
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:nLocalChannel-1];
    
    singleView.nStreamType                          = nStreamType;
    singleView.isHomeIPC                            = isHomeIPC;
    singleView.iEffectType                          = effectType;
    if (self.nSelectedChannelIndex + 1 == nLocalChannel) {
    
        [self refreshStreamType:nStreamType withIsHomeIPC:singleView.isHomeIPC effectType:singleView.iEffectType];
        
        [self refreshEffectType:nLocalChannel effectType:effectType];

    }
    
    DDLogCVerbose(@"%s----nStreamType=%d",__FUNCTION__,nStreamType);

}

/**
 *  刷新当前码流参数信息
 *
 *  @param nStreamType 码流类型
 */
-(void)refreshStreamType:(int)nStreamType withIsHomeIPC:(BOOL)isHomeIPC  effectType:(int)effectType{


    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(changeCurrentVidedoStreamType:withIsHomeIPC:withEffectType:)]) {
    
        [self.delegate changeCurrentVidedoStreamType:nStreamType withIsHomeIPC:isHomeIPC withEffectType:effectType];
    }
}

/**
 *  刷新当前图片翻转状态
 *
 *  @param nchannel   通道号（要减1）
 *  @param effectType 图像翻转状态
 */
-(void)refreshEffectType:(int)nLocalChannel  effectType:(int)effectType{
    
    if (effectType<0) {
        
        return;
    }
    
    JVCMonitorConnectionSingleImageView *singleView = [self singleViewAtIndex:self.nSelectedChannelIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [singleView updateEffectBtn:effectType];

    });
}

/**
 *  停止视频和开启播放的回调
 */
-(void)stopVideoOrFrame {
    
     JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    /**
     *  视频只发I帧处理
     */
    [ystNetWorkHelperObj RemoteOperationSendDataToDeviceWithfullOrOnlyIFrame:self.imageViewNums > kPlayVideoWithFullFramCriticalValue];
    
     int channelCount  = [self channelCountAtSelectedYstNumber];  //返回当前的窗体个数
    
    int endIndex   = (self._iCurrentPage + 1) * self.imageViewNums;
    int startIndex =  self._iCurrentPage      * self.imageViewNums;

    for (int i = 0;i < channelCount ; i++) {
        
        if (i >= startIndex && i < endIndex) {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:i+1 remoteOperationCommand:JVN_CMD_VIDEO];
            
        }else {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:i+1 remoteOperationCommand:JVN_CMD_VIDEOPAUSE];
        }
	}
}

/**
 *  音频监听回调
 *
 *  @param soundBuffer     音频数据
 *  @param soundBufferSize 音频数据大小
 *  @param soundBufferType 音频的类型
 */
-(void)playVideoSoundCallBackMath:(char *)soundBuffer soundBufferSize:(int)soundBufferSize soundBufferType:(BOOL)soundBufferType{
    
    [[OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance] openAudioFromQueue:(short *)soundBuffer dataSize:soundBufferSize playSoundType:soundBufferType == YES ? playSoundType_8k16B : playSoundType_8k8B];
}

/**
 *  隐藏旋转按钮
 */
- (void)hiddenEffectView
{
    JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[WheelShowListView viewWithTag:WINDOWSFLAG+_operationController._iSelectedChannelIndex];
    [singleVideoShow hidenEffectBtn];
    
}

/**
 *  显示旋转按钮
 */
- (void)showEffectView
{
    JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[WheelShowListView viewWithTag:WINDOWSFLAG+_operationController._iSelectedChannelIndex];
    [singleVideoShow showEffectBtn];
    
}
/**
 *  图像翻转按钮的回调
 */
- (void)effectTypeClickCallBack
{
    JVCMonitorConnectionSingleImageView *singleVideoShow = [self singleViewAtIndex:self.nSelectedChannelIndex];

    if (EffectType_UP == singleVideoShow.iEffectType) {//发送向下命令
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper]RemoteOperationSendDataToDevice:self.nSelectedChannelIndex+1 remoteOperationType:TextChatType_EffectInfo remoteOperationCommand: EffectType_Down];
        
    }else{
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper]RemoteOperationSendDataToDevice:self.nSelectedChannelIndex+1 remoteOperationType:TextChatType_EffectInfo remoteOperationCommand:EffectType_UP];
        
    }
}


@end
