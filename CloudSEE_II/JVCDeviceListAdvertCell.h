//
//  JVCDeviceListAdvertCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@protocol JVCAdverDelegate <NSObject>

/**
 *  选中相应的图片
 *
 *  @param urlString 网址
 */
- (void)JVCAdvertClickImageWithIndex:(NSString *)urlString;

@end


static const int             kTableViewCellAdeviceHeigit             = 140;   //广告条的高度

@interface JVCDeviceListAdvertCell : UITableViewCell<UIScrollViewDelegate>
{
    id<JVCAdverDelegate>JVCAdevrtDelegate;
}
@property(nonatomic,assign)id<JVCAdverDelegate>JVCAdevrtDelegate;

/**
 *  初始化cell
 */
- (void)initCellContent;

@end
