//
//  JVCMediaMacro.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

static const  KJVCMediaColumNUm  = 3;//一行的最大值
static const  NSString *kKYCustomPhotoAlbumName =   @"CloudSEE_Photo";
static const  NSString *kKYCustomVideoAlbumName =   @"CloudSEE_Video";
static const  NSString *kKShare_Photo           =   @"CloudSEE_Other";


/**
 *  图片浏览枚举
 */
enum PHOTOBROWSING{
    TYPE_PHOTO=0,
    TYPE_VIDEO=1,
    TYPE_ANOTHER=2,
};

enum resultType{
    
    RESULT_ERROR=0,
    RESULT_SUCCESSFUL=1
    
};


enum MATH_TYPE{
    
    MATH_TYPE_PHOTO=0,
    MATH_TYPE_VIDEO=1,
    
};