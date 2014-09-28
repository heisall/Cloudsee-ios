//
//  JVCTopToolBarView.m
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-25.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCTopToolBarView.h"
#import "JVCRGBHelper.h"
#import "JVCEditDeviceTopItemView.h"

@interface JVCTopToolBarView (){

    UIScrollView *lableScoollView;
    int           nCurrentIndex;
}

@end
@implementation JVCTopToolBarView
@synthesize jvcTopToolBarViewDelegate;

static const CGFloat        kTitleLableFontSize                = 16.0f;
static const CGFloat        kTitleWithRightSpacting            = 15.0f;
static const int            kTitleFlagWithBeginValue           = 10000;
static const NSTimeInterval kTitleViewScaleAnimationsInterval  = 0.5;
static const CGFloat        KTitleViewDefaultScale             = 0.9f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        nCurrentIndex = kTitleFlagWithBeginValue;
        
    }
    
    return self;
}

/**
 *  初始化设备管理的顶部工具栏
 *
 *  @param titles 标题集合
 */
-(void)initWithLayout:(NSArray *)titles{
    
    [titles retain];
    
    UIImage *topBarLineImage = [UIImage imageNamed:@"edit_topBar_line.png"];
    UIImage *topBarDropImage   = [UIImage imageNamed:@"edi_topBar_dropBtn.png"];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, topBarDropImage.size.height);
    
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    if ([rgbHelper rgbColorForKey:kJVCRGBColorMacroEditTopToolBarBackgroundColor]) {
        
        self.backgroundColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroEditTopToolBarBackgroundColor];
    }
    
    CGRect toolViewRect = CGRectMake(0.0, 0.0,self.frame.size.width - topBarDropImage.size.width - topBarLineImage.size.width, self.frame.size.height);
    
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.frame        = CGRectMake(toolViewRect.origin.x + toolViewRect.size.width,toolViewRect.origin.y , topBarLineImage.size.width, topBarLineImage.size.height);
    lineView.backgroundColor = [UIColor clearColor];
    lineView.image        = topBarLineImage;
    [self addSubview:lineView];
    [lineView release];
    
    //初始化滚动标签视图
    [self initWithLableScrollView:toolViewRect titles:titles];
    
    [titles release];
}

/**
 *  初始化滚动标签视图
 *
 *  @param scrollViewRect 位置和大小
 *  @param titles         标签集合
 */
-(void)initWithLableScrollView:(CGRect)scrollViewRect titles:(NSArray *)titles{
    
    CGFloat totalLength = 0.0f; //标题的总长度
    
    for (int i = 0; i<titles.count; i++) {
        
        totalLength = totalLength + [self titleWithFrameWidth:[titles objectAtIndex:i] titleCount:titles.count];
    }
    
    //加上间距总和
    totalLength = totalLength + kTitleWithRightSpacting * (titles.count + 1);
    
    lableScoollView = [[UIScrollView alloc] init];
    lableScoollView.frame = scrollViewRect;
    [self addSubview:lableScoollView];
    
	lableScoollView.directionalLockEnabled         = YES;
	lableScoollView.showsVerticalScrollIndicator   =  FALSE;
	lableScoollView.showsHorizontalScrollIndicator =  FALSE;
    lableScoollView.clipsToBounds                  = YES;
	lableScoollView.backgroundColor                = [UIColor clearColor];
    
	CGSize newSize = CGSizeMake(totalLength,self.frame.size.height);
	[lableScoollView setContentSize:newSize];
    
    [lableScoollView release];
    
    CGFloat titleLblRightSpacting  = kTitleWithRightSpacting;
    
    for (int i = 0 ; i < titles.count; i++) {
        
        NSString *title = [titles objectAtIndex:i];
        
        CGFloat titleLenth = [self titleWithFrameWidth:title titleCount:titles.count];
        
        JVCEditDeviceTopItemView *topBarItemView = [[JVCEditDeviceTopItemView alloc]
                                                    initWithFrame:CGRectMake(titleLblRightSpacting, 0.0, titleLenth, self.frame.size.height) title:title titleLableFontSize:kTitleLableFontSize];
        topBarItemView.tag = kTitleFlagWithBeginValue + i;
        
        topBarItemView.transform = CGAffineTransformMakeScale(KTitleViewDefaultScale,1.0f);
        //添加单击事件
        UITapGestureRecognizer* singleRecognizer;
        
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topBarItem:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [topBarItemView addGestureRecognizer:singleRecognizer];
        [singleRecognizer release];
        
        [lableScoollView addSubview:topBarItemView];
        titleLblRightSpacting = titleLblRightSpacting + titleLenth + kTitleWithRightSpacting;
        [topBarItemView release];
    }
    
    [self deviceTopItemAtCurrentIndexWithSelected];
}

/**
 *  单击事件
 *
 *  @param recognizer 单击手势对象
 */
-(void)topBarItem:(UITapGestureRecognizer*)recognizer
{
    DDLogVerbose(@"%s---offset==%lf",__FUNCTION__,lableScoollView.contentOffset.x);
    
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        if (recognizer.view.tag != nCurrentIndex) {
            
            [UIView animateWithDuration:kTitleViewScaleAnimationsInterval animations:^{
                
                [self deviceTopItemAtCurrentIndexWithUnselected];
                
                nCurrentIndex = recognizer.view.tag;
                
                [self deviceTopItemAtCurrentIndexWithSelected];
                [self topItemViewWithAlignmentLeft:recognizer.view];
                
            } completion:^(BOOL finshed){
            
                if (self.jvcTopToolBarViewDelegate != nil && [self.jvcTopToolBarViewDelegate respondsToSelector:@selector(topItemSelectedIndex:)]) {
                    
                    [self.jvcTopToolBarViewDelegate topItemSelectedIndex:recognizer.view.tag - kTitleFlagWithBeginValue];
                }
            
            }];
        }
    }
}

/**
 *  当滚动标签显示不全时，自动补齐
 *
 *  @param topItemView 选中的滚动标签
 */
-(void)topItemViewWithAlignmentLeft:(UIView *)topItemView{
    
    CGRect topItemRect = topItemView.frame;
    
    CGPoint scorllOffect             =  lableScoollView.contentOffset;
    CGFloat topItemViewOffect_min_x  =  topItemView.frame.origin.x  + topItemRect.size.width - lableScoollView.frame.size.width;                               //标签显示需要的最小的偏移量
    CGFloat topItemViewOffect_max_x  =  topItemView.frame.origin.x;     //标签显示需要的最大的偏移量
    
    
    if (scorllOffect.x < topItemViewOffect_min_x || scorllOffect.x > topItemViewOffect_max_x) {
        
        CGPoint position = CGPointMake(topItemRect.origin.x  - kTitleWithRightSpacting,0);
        [lableScoollView setContentOffset:position animated:NO];
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
    
    JVCEditDeviceTopItemView *deviceTopItemView = (JVCEditDeviceTopItemView *)[lableScoollView viewWithTag:nCurrentIndex];
    
    deviceTopItemView.transform = CGAffineTransformIdentity;
    [deviceTopItemView setViewSatus:YES];
}

/**
 *  设置ScrollView 中当前选中的 Lable 为未选中状态
 *
 */
-(void)deviceTopItemAtCurrentIndexWithUnselected{
    
    JVCEditDeviceTopItemView *deviceTopItemView = (JVCEditDeviceTopItemView *)[lableScoollView viewWithTag:nCurrentIndex];

    deviceTopItemView.transform = CGAffineTransformMakeScale(KTitleViewDefaultScale,1.0f);
    [deviceTopItemView setViewSatus:NO];
}

/**
 *  根据索引选中顶部的操作按钮
 *
 *  @param index 索引
 */
-(void)setSelectedTopItemAtIndex:(int)index{
    
    int selectedIndex = kTitleFlagWithBeginValue + index;
    
    if (selectedIndex != nCurrentIndex) {
        
        JVCEditDeviceTopItemView *deviceTopItemView = (JVCEditDeviceTopItemView *)[lableScoollView viewWithTag:selectedIndex];
        
        [UIView animateWithDuration:kTitleViewScaleAnimationsInterval animations:^{
            
            [self deviceTopItemAtCurrentIndexWithUnselected];
            
            nCurrentIndex = selectedIndex;
            
            [self deviceTopItemAtCurrentIndexWithSelected];
            [self topItemViewWithAlignmentLeft:deviceTopItemView];
            
        }];
    }
}


@end
