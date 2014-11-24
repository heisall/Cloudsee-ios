//
//  JVCPopStreamView.h
//  CloudSEE_II
//  码流切换
//  Created by Yanghu on 10/15/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCHorizontalStreamView.h"

@protocol JVCPopStreamViewDelegate <NSObject>

/**
 *  切换码流的
 *
 *  @param index 选中的码流的index
 */
- (void)changeStreamViewCallBack:(int)index;

@end
@interface JVCPopStreamView : UIView
{
    id<JVCPopStreamViewDelegate>delegateStream;
}
@property(nonatomic,assign) id<JVCPopStreamViewDelegate>delegateStream;

- (id)initStreamView:(UIButton *)btn  andSelectindex:(NSInteger)index  streamCountType:(BOOL)streamCountType;

- (void)show;

/**
 *  让码流设置界面消失
 */
- (void)dismissStream;
@end
