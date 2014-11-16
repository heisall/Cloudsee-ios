//
//  JVCMonitorConnectionSingleImageView.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlView;



typedef NS_ENUM(int, EffectType)
{
    EffectType_UP   = 0,//向上
    EffectType_Down = 4,//向下

};

@protocol JVCMonitorConnectionSingleImageViewDelegate <NSObject>

/**
 *  连接视频
 *
 *  @param nShowWindowID 窗口的编号
 */
-(void)connectVideoCallBack:(int)nShowWindowID;

/**
 *  图像翻转按钮的回调
 */
- (void)effectTypeClickCallBack;

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
    BOOL           _isConnectType;    // 判断该窗口的连接类型 FALSE:YST连接 TRUE:IP直连
    GlView         *_glView;

    id<JVCMonitorConnectionSingleImageViewDelegate> delegate;
    int             nStreamType;     //当前显示窗口的码流类型
    BOOL            isHomeIPC;       //判断当前连接的视频是否是家用的IPC
    
    int             iEffectType;     //标示图像翻转的
    int             nStorageType;    //1：手动 0：报警
}

@property (nonatomic,assign) int      singleViewType,wheelShowType;
@property (nonatomic,assign) BOOL    _isPlayBackState;
@property (nonatomic,assign) BOOL    _isConnectType;
@property (nonatomic,retain) GlView *_glView;
@property (nonatomic,assign) id<JVCMonitorConnectionSingleImageViewDelegate> delegate;
@property (nonatomic,assign) int      nStreamType;     //当前显示窗口的码流类型
@property (nonatomic,assign) BOOL     isHomeIPC;
@property (nonatomic,assign) int      iEffectType;
@property (nonatomic,assign) int      nStorageType;    //1：手动 0：报警

-(void)initWithView;
#pragma mark UIView中的UIImageView的选中与未选中边框颜色处理
-(void)startActivity:(NSString*)connectChannelInfo isConnectType:(BOOL)isConnectType;
-(void)stopActivity:(NSString*)connectInfo;
-(NSString*)getConnectChannelInfo;
-(BOOL)getActivity;
-(void)updateChangeView;
-(void)playBackVideoNumber:(int)value;
-(void)selectUIView;
-(void)unSelectUIView;
-(void)hiddenSlider;


///**
// *  04版主控的显示方式
// *
// *  @param imageBuffer               YUV数据
// *  @param decoderFrameWidth         解码的宽
// *  @param decoderFrameHeight        解码的高
// *  @param nPlayBackFrametotalNumber 远程回放的数据
// */
//-(void)setOldImageBuffer:(char *)imageBuffer decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber;

/**
 *	显示图片方法
 *
 *	@param	imageBufferY
 *	@param	imageBufferU
 *	@param	imageBufferV
 *	@param	decoderFrameWidth
 *	@param	decoderFrameHeight
 */
-(void)setImageBuffer:(char*)imageBufferY imageBufferU:(char*)imageBufferU imageBufferV:(char*)imageBufferV decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber;
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

/**
 *  横屏的时候隐藏旋转按钮
 */
- (void)hidenEffectBtn;
/**
 *  横屏的时候隐藏旋转按钮
 */
- (void)showEffectBtn;

/**
 *  刷新按钮选择状态
 *
 *  @param flagVale 状态
 */
-(void)updateEffectBtn:(int)flagVale;

@end
