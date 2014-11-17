//
//  JVCConstansALAssetsMathHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@protocol JVCConstansALAssetsDelegate <NSObject>

/**
 *  获取数据回调
 *
 *  @param photoDatas 图像或者视频数组
 */
-(void)alAssetsDatecallBack:(NSMutableArray *)photoDatas;

/**
 * 保存图像到指点相册的返回值
 *
 *  @param result 1 成功  0 失败
 */
- (void)savePhotoToAlassertsWithResult:(NSString *)result;

@end

@interface JVCConstansALAssetsMathHelper : NSObject
{
    ALAssetsLibrary *assetLibrary;
    
    id<JVCConstansALAssetsDelegate> AseeetDelegate;
}
@property(nonatomic,assign)   id<JVCConstansALAssetsDelegate> AseeetDelegate;

@property(nonatomic,retain)ALAssetsLibrary *assetLibrary;

+(void)checkAlbumNameIsExist:(NSString *)albumGroupName;

-(void)returnAblumGroupNameArrayDatas:(NSString *)groupName mathType:(int)mathType;

-(void)saveImageToAlbumPhoto:(UIImage *)saveImage albumGroupName:(NSString *)albumGroupName returnALAssetsLibraryAccessFailureBlock:(ALAssetsLibraryAccessFailureBlock)returnALAssetsLibraryAccessFailureBlock;

-(void)saveVideoToAlbumPhoto:(NSURL *)videoUrl albumGroupName:(NSString *)albumGroupName returnALAssetsLibraryAccessFailureBlock:(ALAssetsLibraryAccessFailureBlock)returnALAssetsLibraryAccessFailureBlock;

@end
