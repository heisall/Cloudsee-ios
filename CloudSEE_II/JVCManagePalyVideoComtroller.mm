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

@interface JVCManagePalyVideoComtroller () {

    UIScrollView            *WheelShowListView;
}

@end

@implementation JVCManagePalyVideoComtroller

@synthesize amChannelListData,_operationController,imageViewNums;
@synthesize _iCurrentPage,_iBigNumbers,nSelectedChannelIndex;
@synthesize strSelectedDeviceYstNumber;

static const int  kPlayViewDefaultMaxValue            = 4;
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
        singleVideoShow.ystNetWorkHelpOperationDelegate=self;
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
        
        
        if (count >1 && count <=4 ) {
            
            self.imageViewNums = 4;
            
        }else if (count >4 && count <=9 ){
        
            self.imageViewNums = 9;
            
        }else if (count >9 && count <= 16) {
        
            self.imageViewNums = 16;
            
        }else if ( count > 0 && count <=1) {
            
            self.imageViewNums = 1;
            
        }else if (count > 16 ){
        
            self.imageViewNums = 16 ;
            
        }else {
        
            self.imageViewNums = 1;
        }
        
        self.nSelectedChannelIndex = 0 ;
    }
}

- (void)setScrollviewByIndex:(NSInteger)Index
{
    CGPoint point = CGPointMake(Index*320, 0);
    
    [WheelShowListView setContentOffset:point animated:NO];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
   
//    _operationController._iSelectedChannelIndex=recognizer.view.tag-KWINDOWSFLAG;
//    // NSLog(@"windows Index=%d",_operationController._iSelectedChannelIndex);
//    if (recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
//        
//        [_operationController ytCTL:JVN_YTCTRL_D goOn:0];
//        
//    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
//        
//        [_operationController ytCTL:JVN_YTCTRL_U goOn:0];
//        
//    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
//        
//        [_operationController ytCTL:JVN_YTCTRL_L goOn:0];
//        
//    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
//        
//        [_operationController ytCTL:JVN_YTCTRL_R goOn:0];
//    }
    
    
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
    
    if (1==self.imageViewNums) {
        
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
        
        JVCMonitorConnectionSingleImageView *imgView=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
        
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
    
    if (self.imageViewNums==1) {
        
        if (self.nSelectedChannelIndex!=index) {
            
            //[_operationController stopSetting:_operationController._iSelectedChannelIndex];
        }
    
        self.nSelectedChannelIndex=index;
        
    }else {
        
        self.nSelectedChannelIndex = index *self.imageViewNums;
        
        for (int i=0; i < channsCount; i++) {
            
            JVCMonitorConnectionSingleImageView *imgView=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
            
            if (self.nSelectedChannelIndex != i) {
                
                [imgView unSelectUIView];
                
            }else {
                
                [imgView selectUIView];
            }
        }
    }
    
    [self connectSingleDevicesAllChannel];
    
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
        
        JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
		singleVideoShow.frame = rect;
        [singleVideoShow updateChangeView];
        [singleVideoShow unSelectUIView];
	}
    
    int positionIndex  = self.nSelectedChannelIndex;
    
    self._iCurrentPage = positionIndex;
    
    if (self.imageViewNums !=1 ) {
        
        JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[WheelShowListView viewWithTag:WINDOWSFLAG+self.nSelectedChannelIndex];
        
        [singleVideoShow selectUIView];
        
        positionIndex      = positionIndex/self.imageViewNums;
        self._iCurrentPage =positionIndex;
    }
    
    CGPoint position = CGPointMake(self.bounds.size.width*positionIndex,0);
	[WheelShowListView setContentOffset:position animated:NO];
    
    [self connectSingleDevicesAllChannel];
    
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


-(void)fastforwardToFrameValue:(int)nFrameValue{
    
    //[_operationController sendPlayBackSEEK:nFrameValue];
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
    
    JVCMonitorConnectionSingleImageView *singleView = (JVCMonitorConnectionSingleImageView *)[self viewWithTag:WINDOWSFLAG+nlocalChannel-1];
    
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
       
        JVCMonitorConnectionSingleImageView *singleView          = (JVCMonitorConnectionSingleImageView *) [self viewWithTag:nlocalChannelID];
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        BOOL                                 connectStatus       = [ystNetWorkHelperObj checknLocalChannelExistConnect:channelID];
        JVCDeviceModel                      *deviceModel         = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:self.strSelectedDeviceYstNumber];
        
        int                                  channelIndex        = nlocalChannelID - WINDOWSFLAG;
        
        [channels retain];
        
        JVCChannelModel                 *channelModel        = (JVCChannelModel *)[channels objectAtIndex:channelIndex];
        NSString                        *connectInfo         = [NSString stringWithFormat:@"%@-%d",channelModel.strDeviceYstNumber,channelModel.nChannelValue];
    
        //DDLogVerbose(@"%s--connectDeviceModel-%@",__FUNCTION__,deviceModel.description);
    
        //重复连接
        if (!connectStatus) {
            
            [singleView startActivity:connectInfo isConnectType:deviceModel.linkType];
            
            if (deviceModel.linkType) {
                
                connectStatus = [ystNetWorkHelperObj ipConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue  strUserName:deviceModel.userName strPassWord:deviceModel.passWord strRemoteIP:deviceModel.ip nRemotePort:[deviceModel.port intValue] nSystemVersion:IOS_VERSION];
               
            }else{
                
                connectStatus = [ystNetWorkHelperObj ystConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue strYstNumber:channelModel.strDeviceYstNumber strUserName:deviceModel.userName strPassWord:deviceModel.passWord nSystemVersion:IOS_VERSION];
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
    
    JVCMonitorConnectionSingleImageView *singleView = (JVCMonitorConnectionSingleImageView *)[self viewWithTag:WINDOWSFLAG+nLocalChannel-1];
    
    [singleView setImageBuffer:imageBufferY imageBufferU:imageBufferU imageBufferV:imageBufferV decoderFrameWidth:decoderFrameWidth decoderFrameHeight:decoderFrameHeight];
    
    [NSThread detachNewThreadSelector:@selector(stopVideoOrFrame) toTarget:self withObject:nil];
    
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
    
    for (int i=0;i < channelCount ; i++) {
        
        
        JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
        
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

@end
