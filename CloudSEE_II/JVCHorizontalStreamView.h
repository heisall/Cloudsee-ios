//
//  JVCHorizontalStreamView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol horizontalStreamViewDelegate <NSObject>

//选中那个按钮
- (void)horizontalStreamViewCallBack:(UIButton *)btn;

@end

@interface JVCHorizontalStreamView : UIView
{
    id<horizontalStreamViewDelegate>horStreamDelegate;
}

- (id)showHorizonStreamView:(UIButton *)btn  andSelectindex:(NSInteger)index ;
@property(nonatomic,assign)id<horizontalStreamViewDelegate>horStreamDelegate;


@end
