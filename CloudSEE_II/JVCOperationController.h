//
//  JVCOperationController.h
//  CloudSEE_II
//  播放类库
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCDeviceModel.h"
#import "AQSController.h"
@class JVCManagePalyVideoComtroller;
@class OpenALBufferViewcontroller;

@protocol operationControllerDelegate <NSObject>

/**
 *  分割视频源窗口
 *
 *  @param singeShowViewNumber 一页显示几个监控画面(最大16个)
 */
-(void)splitViewWindow:(int)singeShowViewNumber;

@end


@interface JVCOperationController : UIViewController
{
    NSMutableArray *_aDeviceChannelListData;
    int _iSelectedChannelIndex;
    UIAlertView * wheelAlterInfo;
    NSMutableArray *_amUnSelectedImageNameListData;
    NSMutableArray *_amSelectedImageNameListData;
    
    bool _issound;
    bool  _isTalk;
    bool _isLocalVideo;
    bool _isPlayBack;
    JVCDeviceModel *_deviceModel;
    int _iViewState;  // 0：正常 1: 注销登陆 2: 地图登陆
    NSMutableArray *_playBackVideoDataArray;//远程回放视频列表

    
    NSMutableString *_playBackDateString;
    BOOL _isConnectdevcieType;
    
    UIScrollView *scrollview;
    NSMutableArray *_amDeviceListData;    //存放的设备信息集合
    int _selectedDeviceIndex;
    UIButton *_bSmallMoreBtn;
    
    int skinSelect;
    BOOL _isConnectModel; //no 单设备  yes :多设备
    
    id <operationControllerDelegate> delegate;
    JVCManagePalyVideoComtroller  *_managerVideo;

}

@property (nonatomic,retain) NSMutableArray *_aDeviceChannelListData;
@property (nonatomic,assign) int _iSelectedChannelIndex;
@property (nonatomic,assign) bool _issound,_isTalk,_isLocalVideo,_isPlayBack;
@property (nonatomic,assign) BOOL _isConnectdevcieType;
@property (nonatomic,retain) JVCDeviceModel *_deviceModel;
@property (nonatomic,assign) int _iViewState;
@property (nonatomic,retain) NSMutableString *_playBackDateString;
@property (nonatomic,retain) NSMutableArray *_playBackVideoDataArray;
@property (nonatomic,retain) NSMutableArray *_amDeviceListData;
@property (nonatomic,assign) int _selectedDeviceIndex;
@property (nonatomic,assign) BOOL _isConnectModel;
@property (nonatomic,assign) BOOL showSingeleDeviceLongTap;
@property (nonatomic,assign) id <operationControllerDelegate> delegate;

-(void)connectSingleChannel:(int)_iWindowsIndex selectedChannel:(int)selectedChannel;

void deliverMessageCallBack(int nLocalChannel, unsigned char  uchType, char *pMsg);//从类库中回调操作类型的函数
void deliverDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize,int nWidth,int nHeight);//发送数据的回调函数

void textDeliverDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize);

//语音对讲回调
void remoteChatDataCallBack(int nLocalChannel, unsigned char uchType, unsigned char *pBuffer, int nSize);

#pragma mark 远程回放检索回调
void CheckResultCallBack(int nLocalChannel,unsigned char *pBuffer, int nSize);
#pragma mark 远程回放
void remotePlayDataCallBack(int nLocalChannel, unsigned char uchType, unsigned char *pBuffer, int nSize, int nWidth, int nHeight, int nTotalFrame);

-(int)returnChannelID:(int)windowIndexValue;
-(int)returnChannelPage:(int)windowIndexValue;
-(void)gotoDeviceShowChannels;
- (void)saveLocalVideo:(NSString*)urlString;
-(void)saveLocalChannelPhoto;
-(void)openCurrentWindowsVideoData;
-(void)unAllLink;
-(void)unSelectSmallButtonStyle:(UIButton*)unSelectedButton;
-(void)selectSmallButtonStyle:(UIButton*)selectedButton;
-(void)ytCTL:(int)type goOn:(int)goOnFlag;
-(void)unSelectBigButtonStyle:(UIButton*)selectedButton;
-(void)selectBigButtonStyle:(UIButton*)selectedButton;
-(void)ytoHidenClick;
-(void)playSoundPressed;
-(void)stopSetting:(int)nLocalChannel;
-(void)sendSelectDate:(NSDate*)date;
-(void)playBackDisplay:(int)selecetedIndex playBackDate:(NSDate*)date;
-(void)initwithSoundClass:(OpenALBufferViewcontroller*)openAl aqsController:(AQSController*)aqsController;
-(bool)IsFILE_HEADER_EX:(void *)pBuffer dwSize:(uint32_t)dwSize;
-(void)gotoBack;

-(void)openVideoSound:(UIButton*)_openVideoSound;
-(void)playBackVideo;
-(void)ytoClick:(UIButton*)button;

- (void)showPlayBackVideo:(bool)_isOpen;


-(BOOL)isKindOfBufInStartCode:(char*)buffer;
-(void)changePlaySate;
-(void)playBackSendPlayVideoData:(NSDate*)date;
-(void)changeRotateFromInterfaceOrientationFrame:(BOOL)IsRotateFrom;
- (void)startCapImageAnimation;
-(BOOL)returnIsplayBackVideo;
-(void)sendPlayBackSEEK:(int)frameNumber;
-(void)connectSingleDevicesAllChannel;
-(BOOL)returnOperationState;

-(void)connectSingleScrollChannel:(int)_iWindowsIndex selectedChannel:(int)selectedChannel;

- (void)setScrollviewByIndex:(NSInteger)Index;
-(void)gotoShowSpltWindow;
-(void)changeSplitView:(int)_splitWindows;
-(NSMutableArray*)getSplitWindowMaxNumbers;
-(void)channelAllWaitI;
-(UIImage*)convertViewToImage:(UIView*)v;
-(BOOL)isCheckCurrentSingleViewGlViewHidden;

/**
 * 按下事件的执行方法
 *
 *  @param index btn的index
 */
- (void)MiddleBtnClickWithIndex:(int )index;

/**
 *  音频监听功能（关闭）
 */
-(void)audioButtonClick;

@end
