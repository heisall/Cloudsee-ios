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

@implementation JVCManagePalyVideoComtroller

@synthesize _amWheelData,_operationController,WheelShowListView,imageViewNums;
@synthesize _iCurrentPage,_iBigNumbers,nSelectedChannelIndex;

int  nAllLinkFlag;
BOOL isAllLinkRun;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self._iBigNumbers=4;
    }
    return self;
}

/**
 *  初始化视频显示窗口
 */
-(void)initWithLayout{
    
    JVCCloudSEENetworkHelper *ystNetWorkHelperObj=[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    //[ystNetWorkHelperObj registerCallBack];
    
    ystNetWorkHelperObj.ystNWHDelegate   =self;
    
    float _totalWidth=self.frame.size.width;
    float _totalHeight=self.frame.size.height;
    
    float _image_w=0.0;
    float _image_h=0.0;
    
    int lieSize=1;
	if (self.imageViewNums==4) {
		lieSize=2;
	} else if (self.imageViewNums==9){
        lieSize=3;
    }
    _image_w=_totalWidth/lieSize;
    _image_h=_totalHeight/lieSize;
    
    WheelShowListView= [[UIScrollView alloc] init];
	WheelShowListView.directionalLockEnabled = YES;
	WheelShowListView.pagingEnabled = YES;
	WheelShowListView.showsVerticalScrollIndicator=NO;
	WheelShowListView.showsHorizontalScrollIndicator=YES;
	WheelShowListView.bounces=NO;
    WheelShowListView.clipsToBounds=YES;
	WheelShowListView.frame=CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
	WheelShowListView.delegate = self;
    
	WheelShowListView.backgroundColor=[UIColor clearColor];
    
	int count=[_amWheelData count];
    int pageNums=count/self.imageViewNums;
	if (count%self.imageViewNums!=0) {
		pageNums=pageNums+1;
	}
	CGSize newSize = CGSizeMake(self.frame.size.width*pageNums,self.frame.size.height);
	[WheelShowListView setContentSize:newSize];
	[self addSubview:WheelShowListView];
	[WheelShowListView release];
	
	
	[UIView beginAnimations:@"View" context:nil];
    [UIView setAnimationDuration:0.5];
    
	for (int i=0;i<[_amWheelData count]+1 ; i++) {
		
		int flag=i;
        
        int pageValue=flag/self.imageViewNums;
        int pageNum=flag%self.imageViewNums;
        
        int row=(pageNum+1)/lieSize;
		int lie=(pageNum+1)%lieSize;
		if ((pageNum+1)%lieSize!=0) {
			row=(pageNum+1)/lieSize+1;
		}else {
			lie=lieSize;
		}
        
		JVCMonitorConnectionSingleImageView *singleVideoShow=[[JVCMonitorConnectionSingleImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*pageValue+ _image_w*(lie-1),_image_h*(row-1), _image_w,_image_h)];
        
        singleVideoShow.layer.borderWidth=1.0;
        [singleVideoShow unSelectUIView];
        singleVideoShow.singleViewType=1;
        singleVideoShow.wheelShowType=1;
        singleVideoShow.ystNetWorkHelpOperationDelegate=self;
		[singleVideoShow initWithView];
		singleVideoShow.tag=KWINDOWSFLAG+i;
        
        if (i==[self._amWheelData count]) {
            
            [singleVideoShow getGlViewMaxmodel];
            [singleVideoShow setHidden:YES];
        }
        
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
    
    [UIView commitAnimations];
    
    CGPoint position = CGPointMake(self.bounds.size.width*self.nSelectedChannelIndex,0);
    
    self._iCurrentPage=self.nSelectedChannelIndex;
    
	[WheelShowListView setContentOffset:position animated:NO];
    
    [self connectVideoByLocalChannelID:KWINDOWSFLAG+self._iCurrentPage];
    
}

- (void)setScrollviewByIndex:(NSInteger)Index
{
    CGPoint point = CGPointMake(Index*320, 0);
    
    [WheelShowListView setContentOffset:point animated:NO];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    // NSLog(@"Swipe received.");
    _operationController._iSelectedChannelIndex=recognizer.view.tag-KWINDOWSFLAG;
    // NSLog(@"windows Index=%d",_operationController._iSelectedChannelIndex);
    if (recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        [_operationController ytCTL:JVN_YTCTRL_D goOn:0];
        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        [_operationController ytCTL:JVN_YTCTRL_U goOn:0];
        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        [_operationController ytCTL:JVN_YTCTRL_L goOn:0];
        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        [_operationController ytCTL:JVN_YTCTRL_R goOn:0];
    }
    
    
}

-(void)longPressedOncell:(id)sender{
    
    if (self.frame.size.height>=300.0||[_operationController returnIsplayBackVideo]) {
        return;
    }
    
    if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        JVCMonitorConnectionSingleImageView *singleView=(JVCMonitorConnectionSingleImageView*)((UILongPressGestureRecognizer *)sender).view;
        if (![singleView getActivity]) {
            
            for (int i=0; i<[_amWheelData count]; i++) {
                JVCMonitorConnectionSingleImageView *imgView=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
                // NSLog(@"value=%d",self.tag);
                //NSLog(@"imgView=%@",imgView );
                if (singleView.tag!=imgView.tag) {
                    [imgView unSelectUIView];
                }else {
                    if (self.imageViewNums==1) {
                        [imgView unSelectUIView];
                    }else{
                        
                        [imgView selectUIView];
                    }
                    _operationController._iSelectedChannelIndex=i;
                }
            }
            [_operationController gotoDeviceShowChannels];
        }
        
    }
}


/**
 *  单击选中事件
 *
 *  @param sender 选中的视频显示窗口
 */
-(void)handleDoubleTabFrom:(id)sender{
    
    UITapGestureRecognizer *viewimage=(UITapGestureRecognizer*)sender;
    
    if ([_operationController returnOperationState]||[self._amWheelData count]<=1) {
        
        return;
    }
    
    int _views=self.imageViewNums;
    self.imageViewNums=self._iBigNumbers;
    self._iBigNumbers=_views;
    self.nSelectedChannelIndex=viewimage.view.tag-WINDOWSFLAG;
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
    
    
    for (int i=0; i<[_amWheelData count]; i++) {
        
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
    
    self._iCurrentPage=index;
    
    if (self.imageViewNums==1) {
        
        if (self.nSelectedChannelIndex!=index) {
            
            //[_operationController stopSetting:_operationController._iSelectedChannelIndex];
        }
        
        self.nSelectedChannelIndex=index;
        
        DDLogVerbose(@"%s---%d",__FUNCTION__,self.nSelectedChannelIndex);
        [self connectVideoByLocalChannelID:self.nSelectedChannelIndex+WINDOWSFLAG];
        
    }else {
        
        self.nSelectedChannelIndex=index*self.imageViewNums;
        
        for (int i=0; i<[_amWheelData count]+1; i++) {
            
            JVCMonitorConnectionSingleImageView *imgView=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
            
            if (_operationController._iSelectedChannelIndex!=i) {
                
                [imgView unSelectUIView];
                
            }else {
                
                [imgView selectUIView];
            }
        }
        
        [self connectSingleDevicesAllChannel];
        
    }
    
    // [NSThread detachNewThreadSelector:@selector(openCurrentSingleWindowsVideoData) toTarget:self withObject:nil];
}


-(void)openCurrentSingleWindowsVideoData{
    
    [_operationController openCurrentWindowsVideoData];
    
}

-(BOOL)returnPlayBackViewState{
    
    return [_operationController returnIsplayBackVideo];
    
}

#pragma mark 弹出设备的悬浮通道展示界面
-(void)_playVideoCilck:(int)windowsIndex selectedChannel:(int)selectedChannel{
    
    [_operationController connectSingleChannel:windowsIndex selectedChannel:selectedChannel];
}


-(void)dealloc{
    
    [_amWheelData release];
    [super dealloc];
}

/**
 *  改变窗体布局
 */
-(void)changeContenView{
    
    WheelShowListView.frame=CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
    [WheelShowListView setBackgroundColor:[UIColor clearColor]];
    
    int count=[self._amWheelData count];
    int pageNums=count/self.imageViewNums;
    
	if (count%self.imageViewNums!=0) {
        
		pageNums=pageNums+1;
	}
    
	CGSize newSize = CGSizeMake(self.frame.size.width*pageNums,self.frame.size.height);
	[WheelShowListView setContentSize:newSize];
    
    float _totalWidth=self.frame.size.width;
    float _totalHeight=self.frame.size.height;
    
    float _image_w=0.0;
    float _image_h=0.0;
    
    int lieSize=1;
    
	if (self.imageViewNums==4) {
        
		lieSize=2;
	} else if (self.imageViewNums==9){
        
        lieSize=3;
    }else if (self.imageViewNums==16){
        
        lieSize=4;
    }else if (self.imageViewNums==25){
        
        lieSize=5;
    }
    
    _image_w=_totalWidth/lieSize;
    _image_h=_totalHeight/lieSize;
    
	for (int i=0;i<[self._amWheelData count]+1 ; i++) {
        
        int flag=i;
        
        int pageValue=flag/self.imageViewNums;
        int pageNum=flag%self.imageViewNums;
        
        int row=(pageNum+1)/lieSize;
		int lie=(pageNum+1)%lieSize;
        
		if ((pageNum+1)%lieSize!=0) {
            
			row=(pageNum+1)/lieSize+1;
		}else {
            
			lie=lieSize;
		}
        
        JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[self viewWithTag:WINDOWSFLAG+i];
		singleVideoShow.frame=CGRectMake(self.frame.size.width*pageValue+ _image_w*(lie-1),_image_h*(row-1), _image_w,_image_h);
        [singleVideoShow updateChangeView];
        [singleVideoShow unSelectUIView];
        
        if (i==[self._amWheelData count]) {
            
            [singleVideoShow setHidden:YES];
        }
        
	}
    
    int positionIndex=self.nSelectedChannelIndex;
    
    self._iCurrentPage=positionIndex;
    
    //    if (self.imageViewNums>4) {
    //
    //        _operationController._isConnectdevcieType=true;
    //
    //    }else{
    //
    //        _operationController._isConnectdevcieType=FALSE;
    //
    //        [_operationController channelAllWaitI];
    //    }
    
    if (self.imageViewNums!=1) {
        
        JVCMonitorConnectionSingleImageView *singleVideoShow=(JVCMonitorConnectionSingleImageView*)[WheelShowListView viewWithTag:WINDOWSFLAG+self.nSelectedChannelIndex];
        
        [singleVideoShow selectUIView];
        positionIndex=positionIndex/self.imageViewNums;
        self._iCurrentPage=positionIndex;
        
        [self connectSingleDevicesAllChannel];
    }
    
    CGPoint position = CGPointMake(self.bounds.size.width*positionIndex,0);
	[WheelShowListView setContentOffset:position animated:NO];
    
    //[NSThread detachNewThreadSelector:@selector(openCurrentSingleWindowsVideoData) toTarget:self withObject:nil];
    
    
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
    
    int endIndex   = (self._iCurrentPage+1)*self.imageViewNums;
    int startIndex = self._iCurrentPage*self.imageViewNums;
    
    if ( endIndex   >= [self._amWheelData count] ) {
        
        endIndex   =[self._amWheelData count];
    }
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
    
    [_operationController sendPlayBackSEEK:nFrameValue];
}

#pragma mark operationView Delegate

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
        
        int                               channelID           = nlocalChannelID - WINDOWSFLAG;
        JVCDeviceModel                      *model               = [self._amWheelData objectAtIndex:channelID];
        JVCMonitorConnectionSingleImageView *singleView          = (JVCMonitorConnectionSingleImageView *) [self viewWithTag:nlocalChannelID];
        JVCCloudSEENetworkHelper                 *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        BOOL                              connectStatus       = [ystNetWorkHelperObj checknLocalChannelExistConnect:nlocalChannelID];
        
        NSString                         *connectInfo         = [NSString stringWithFormat:@"%@-%d",model.yunShiTongNum,model.channelValue];
        
        //重复连接
        if (! connectStatus) {
            
            [singleView startActivity:connectInfo isConnectType:model.linkType];
            
            if (model.linkType) {
                
                connectStatus = [ystNetWorkHelperObj ipConnectVideobyDeviceInfo:channelID+1 nRemoteChannel:model.channelValue  strUserName:model.userName strPassWord:model.passWord strRemoteIP:model.ip nRemotePort:[model.port intValue] nSystemVersion:IOS_VERSION];
                
                
            }else{
                
                connectStatus = [ystNetWorkHelperObj ystConnectVideobyDeviceInfo:channelID+1 nRemoteChannel:model.channelValue strYstNumber:model.yunShiTongNum strUserName:model.userName strPassWord:model.passWord nSystemVersion:IOS_VERSION];
            }
        }
        
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
    
}



/**
 *  音频监听回调
 *
 *  @param soundBuffer     音频数据
 *  @param soundBufferSize 音频数据大小
 *  @param soundBufferType 音频的类型
 */
-(void)playVideoSoundCallBackMath:(char *)soundBuffer soundBufferSize:(int)soundBufferSize soundBufferType:(BOOL)soundBufferType{
    
    
    [[OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance] openAudioFromQueue:(short *)soundBuffer dataSize:soundBufferSize monoValue:soundBufferType];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
