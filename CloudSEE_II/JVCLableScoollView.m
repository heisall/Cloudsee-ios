//
//  JVCLableScoollView.m
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-25.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLableScoollView.h"
#import "JVCEditDeviceTopItemView.h"

@interface JVCLableScoollView (){
    
    int currentIndex;
}

@end

@implementation JVCLableScoollView
static const CGFloat kTitleLableFontSize      = 16.0f;
static const CGFloat kTitleWithRightSpacting  = 15.0f;
static const int  kTitleFlagWithBeginValue    = 10000;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        currentIndex = kTitleFlagWithBeginValue;
    }
    return self;
}

/**
 *  根据标签集合数据设置滚动视图的大小
 *
 *  @param titles 标签集合
 */
-(void)initWithLayout:(NSArray *)titles {
    
    [titles retain];
    
    CGFloat totalLength = 0.0f; //标题的总长度
    
    for (int i = 0; i<titles.count; i++) {
        
        totalLength = totalLength + [self titleWithFrameWidth:[titles objectAtIndex:i] titleCount:titles.count];
    }
    
    //加上间距总和
    totalLength = totalLength + kTitleWithRightSpacting * (titles.count + 1);
    
	self.directionalLockEnabled = YES;
	//self.pagingEnabled = YES;
	self.showsVerticalScrollIndicator=NO;
	self.showsHorizontalScrollIndicator=YES;
	self.bounces=NO;
    self.clipsToBounds= YES;
	self.backgroundColor=[UIColor clearColor];
    
	CGSize newSize = CGSizeMake(totalLength,self.frame.size.height);
	[self setContentSize:newSize];
    
    
    CGFloat titleLblRightSpacting  = kTitleWithRightSpacting;
    
    for (int i = 0 ; i < titles.count; i++) {
        
        NSString *title = [titles objectAtIndex:i];
        
        CGFloat titleLenth = [self titleWithFrameWidth:title titleCount:titles.count];
        
        JVCEditDeviceTopItemView *topBarItemView = [[JVCEditDeviceTopItemView alloc]
                                                    initWithFrame:CGRectMake(titleLblRightSpacting, 0.0, titleLenth, self.frame.size.height) title:title titleLableFontSize:kTitleLableFontSize];
        topBarItemView.tag = kTitleFlagWithBeginValue + i;

       
        //添加单击事件
        UITapGestureRecognizer* singleRecognizer;
        
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topBarItem:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [topBarItemView addGestureRecognizer:singleRecognizer];
        [singleRecognizer release];

        [self addSubview:topBarItemView];
        titleLblRightSpacting = titleLblRightSpacting + titleLenth + kTitleWithRightSpacting;
        [topBarItemView release];
    }
    
    [self deviceTopItemAtCurrentIndexWithSelected];
    
    [titles release];
}

/**
 *  单击事件
 *
 *  @param recognizer 单击手势对象
 */
-(void)topBarItem:(UITapGestureRecognizer*)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        if (recognizer.view.tag != currentIndex) {
            
            [self deviceTopItemAtCurrentIndexWithUnselected];
            
            currentIndex = recognizer.view.tag;
            
            [self deviceTopItemAtCurrentIndexWithSelected];
        }
    }
}

/**
 *  根据标签的内容和字体的大小获取标签的长度
 *
 *  @param title      标签
 *  @param titleCount 标签的个数
 *
 *  @return 标签的长度
 */
-(CGFloat)titleWithFrameWidth:(NSString *)title  titleCount:(int)titleCount{
    
    UIFont *font = [UIFont systemFontOfSize:kTitleLableFontSize];
    CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width * titleCount, self.frame.size.height)];
    
    return size.width;
}

/**
 *  设置ScrollView 中当前选中的 Lable 为选中状态
 *
 */
-(void)deviceTopItemAtCurrentIndexWithSelected{

    JVCEditDeviceTopItemView *deviceTopItemView = (JVCEditDeviceTopItemView *)[self viewWithTag:currentIndex];
    
    [deviceTopItemView setViewSatus:YES];
    
}

/**
 *  设置ScrollView 中当前选中的 Lable 为未选中状态
 *
 */
-(void)deviceTopItemAtCurrentIndexWithUnselected{
    
    JVCEditDeviceTopItemView *deviceTopItemView = (JVCEditDeviceTopItemView *)[self viewWithTag:currentIndex];
    
    [deviceTopItemView setViewSatus:NO];
}

@end
