//
//  JVCHorizontalStreamView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int , JVCHorStreamCountType) {

       JVCStreamCountType_Second        = 0,//2个码流
       JVCStreamCountType_Third         = 1,//3个码流
    
};

@protocol horizontalStreamViewDelegate <NSObject>

//选中那个按钮
- (void)horizontalStreamViewCallBack:(UIButton *)btn;

@end

@interface JVCHorizontalStreamView : UIView
{
    id<horizontalStreamViewDelegate>horStreamDelegate;
}

- (id)showHorizonStreamView:(UIButton *)btn  andSelectindex:(NSInteger)index streamCountType:(BOOL)streamCountType;
@property(nonatomic,assign)id<horizontalStreamViewDelegate>horStreamDelegate;


@end
