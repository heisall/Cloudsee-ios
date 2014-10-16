//
//  JVCMonitorConnectionSingleImageView.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlView;

@protocol YstNetWorkHelpOperationDelegate <NSObject>

/**
 *  连接视频
 *
 *  @param nShowWindowID 窗口的编号
 */
-(void)connectVideoCallBack:(int)nShowWindowID;


/**
 *  远程回放的快进
 *
 *  @param nFrameValue 快进到哪一阵
 */
-(void)fastforwardToFrameValue:(int)nFrameValue;

@end

@interface JVCMonitorConnectionSingleImageView : UIView
{
    BOOL           disFlag;
    int            singleViewType;
    float          sing_x;
    float          sing_y;
    int            imageflag;
    int            wheelShowType;        //1表示单画面轮显 0.表示四画面轮显（前提是singleViewType=1 轮显模式下）
    NSMutableArray *_amConnectInfoList;
    NSTimer        *_tConnectInfoTimer;

    CGFloat         lastScale;
    BOOL           _isPlayBackState;
    BOOL           _isConnectType;      // 判断该窗口的连接类型 FALSE:YST连接 TRUE:IP直连
    GlView         *_glView;

    id<YstNetWorkHelpOperationDelegate> ystNetWorkHelpOperationDelegate;
    int             nStreamType;     //当前显示窗口的码流类型
    BOOL            isHomeIPC;           //判断当前连接的视频是否是家用的IPC
}

@property (nonatomic,assign) int      singleViewType,wheelShowType;
@property (nonatomic,assign) BOOL    _isPlayBackState;
@property (nonatomic,assign) BOOL    _isConnectType;
@property (nonatomic,retain) GlView *_glView;
@property (nonatomic,assign) id<YstNetWorkHelpOperationDelegate> ystNetWorkHelpOperationDelegate;
@property (nonatomic,assign) int      nStreamType;     //当前显示窗口的码流类型
@property (nonatomic,assign) BOOL     isHomeIPC;

-(void)initWithView;
#pragma mark UIView中的UIImageView的选中与未选中边框颜色处理
-(void)setImage:(UIImage*)image;
-(void)startActivity:(NSString*)connectChannelInfo isConnectType:(BOOL)isConnectType;
-(void)stopActivity:(NSString*)connectInfo;
-(NSString*)getConnectChannelInfo;
-(BOOL)getActivity;
-(void)updateChangeView;
-(void)playBackVideoNumber:(int)value;
-(void)selectUIView;
-(void)unSelectUIView;
-(void)hiddenSlider;


/**
 *	显示图片方法
 *
 *	@param	imageBufferY
 *	@param	imageBufferU
 *	@param	imageBufferV
 *	@param	decoderFrameWidth
 *	@param	decoderFrameHeight
 */
-(void)setImageBuffer:(char*)imageBufferY imageBufferU:(char*)imageBufferU imageBufferV:(char*)imageBufferV decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight;

/**
 *	获得当前的视频窗口对应的GLView对象
 */
-(void)getGlViewmodel;


/**
 *  执行显示连接的通道的信息
 *
 *  @param connectInfo 显示连接的通道的信息
 */
-(void)runSetConnectDeviceInfo:(NSString *)connectInfo;

/**
 *  停止Activity旋转
 *
 *  @param connectInfo 提示的信息
 */
-(void)runStopActivity:(NSString*)connectInfo;

/**
 *  网络连接返回的连接状态和对应
 *
 *  @param connectResultText 连接返回的信息
 *  @param connectResultType 连接返回的类型
 */
-(void)connectResultShowInfo:(NSString *)connectResultText  connectResultType:(int)connectResultType;



@end
