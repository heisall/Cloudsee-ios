//
//  zxingLibrary.h
//  zxingLibrary
//
//  Created by jovision on 14-6-12.
//  Copyright (c) 2014年 jovision. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DecoderResultDelegate <NSObject>

@optional

/**
 *  解码成功的回调函数
 *
 *  @param decoderResultText 解码返回的文本
 */
-(void)decoderSucceedCallBack:(NSString *)decoderResultText;


/**
 *  解码失败的回调函数
 */
-(void)decoderFailedCallBack;

@end

@interface zxingLibrary : NSObject{


    id<DecoderResultDelegate>DRGelegate;

}

@property(nonatomic,assign)id<DecoderResultDelegate>DRGelegate;

/**
 *  解析二维码的对象
 *
 *  @return 解析二维码的对象
 */
+(zxingLibrary *)sharedZlObj;

/**
 *  解析二维码
 *
 *  @param image 需要解析的二维码图片
 */
- (void)decodeImage:(id)decoderImage;

@end
