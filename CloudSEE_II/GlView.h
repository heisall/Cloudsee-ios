//
//  GlView.h
//  GlView
//
//  Created by jovision on 13-12-14.
//  Copyright (c) 2013年 jovision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlView : NSObject{

    id _kxMoveDecoder;
    id _kxMoveGLView;
    id _yuvFrame;
}

@property(nonatomic,retain) id _kxMoveGLView;
@property(nonatomic,retain) id _kxMoveDecoder;
@property(nonatomic,retain) id _yuvFrame;


/**
 *	初始化解码器和解码后显示的画面窗口
 *
 *	@param	decoderWidth	    初始化解码器的宽
 *	@param	decoderHeight	    初始化解码器的高
 *	@param	frameSizeWidth	    解码后显示的画面窗口的宽
 *	@param	frameSizeHeight	    解码后显示的画面窗口的高
 */
-(void)initWithDecoderWidth:(int)decoderWidth decoderHeight:(int)decoderHeight frameSizeWidth:(int)frameSizeWidth frameSizeHeight:(int)frameSizeHeight;

/**
 *	解码一针之后 YUV显示的方法
 *
 *	@param	imageBufferY	     解码一针之后Y数据
 *	@param	imageBufferU	     解码一针之后U数据
 *	@param	imageBufferV	     解码一针之后V数据
 *	@param	decoderFrameWidth	 解码一针之后的宽
 *	@param	decoderFrameHeight	 解码一针之后的宽
 */
-(void)decoder:(char*)imageBufferY imageBufferU:(char*)imageBufferU imageBufferV:(char*)imageBufferV decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight;

/**
 *	屏幕旋转之后更新画布
 *
 *	@param	decoderFrameWidth	更新的高
 *	@param	decoderFrameHeight	更新的宽
 */
-(void)updateDecoderFrame:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight;
@end
