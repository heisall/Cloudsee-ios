//
//  JVCAddDevicePopView.h
//  CloudSEE_II
//  添加按钮按下，弹出的view
//  Created by Yanghu on 10/9/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddDevicePopViewDelegate <NSObject>

/**
 *  选中item的回调
 *
 *  @param index 索引
 */
- (void)didSelectItemRowAtIndex:(int)index;

@end

@interface JVCAddDevicePopView : UIView
{
    id<AddDevicePopViewDelegate>popDelegate;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic,assign) id<AddDevicePopViewDelegate>popDelegate;

@end
