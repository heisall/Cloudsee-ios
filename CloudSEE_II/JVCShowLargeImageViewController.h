//
//  JVCShowLargeImageViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@interface JVCShowLargeImageViewController : JVCBaseWithGeneralViewController<UIScrollViewDelegate>
{  /**
    *  存放传进来的数据
    */
    NSMutableArray *_mArrayPictures;
    
    /**
     *  当前图片再数组中得索引
     */
    NSInteger _index;
}
@property(nonatomic,retain)     NSMutableArray *_mArrayPictures;
@property(nonatomic,assign)    NSInteger _index;
/**
 *  初始化view
 */
- (void)initScrollview:(NSInteger)indexInt;

/**
 *  根据选中的index 初始化
 */
- (void)changePage:(NSNumber *)indexSelect;

@end
