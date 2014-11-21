//
//  JVCAdverImageModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kAdverDocument   = @"AdverDoucment";//保存广告位的目录

/**
 *  下载图片成功后告诉试图刷新
 *
 *  @param result 是否下载成功
 */
typedef void(^JVCDownLoadAdverImageSuccess)(void);

@interface JVCAdverImageModel : NSObject
{
    NSString *urlStirng;//图片网路路径
    BOOL     downSuccess;//是否下载完成
    int      index;     //图片的索引
    NSString *AdLick;   //点击图片的超链接
    NSString *localDownUrl;//本地存放的url
    NSString *localImageName;//本地存的图片的名称，例如：http://182.92.242.230/static/banner/ios-02.jpg 名称为ios-02.jpg
}
@property(nonatomic,retain)NSString *urlStirng;//图片网路路径
@property(nonatomic,assign)BOOL     downSuccess;//是否下载完成
@property(nonatomic,assign)int      index;     //图片的索引
@property(nonatomic,retain)NSString *AdLick;   //点击图片的超链接
@property(nonatomic,retain)NSString *localDownUrl;//本地存放的url
@property(nonatomic,retain)NSString *localImageName;
/**
 *  初始化
 *
 *  @param string urlstring
 *
 *  @return 对象
 */
- (id)initAdvertImageModel:(NSString *)string  LinkUrl:(NSString *)lickUrl  index:(int)imageIndex  downState:(BOOL)state downLoadSuccessBlock:(JVCDownLoadAdverImageSuccess)block;
@end
