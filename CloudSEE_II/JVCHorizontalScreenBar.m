//
//  JVCHorizontalScreenBar.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCHorizontalScreenBar.h"

//
//  HorizontalScreenBar.m
//  CloudSEE
//
//  Created by Yanghu on 9/1/14.
//  Copyright (c) 2014 miaofaqiang. All rights reserved.
//


#define MAXBTNCOUNT  4

#define BTNTAG  232000

@interface JVCHorizontalScreenBar ()
{
    UIButton *streamBtn;
}

@end
@implementation JVCHorizontalScreenBar
@synthesize HorizontalDelegate;
/**
 *  单例
 */
static JVCHorizontalScreenBar *shareInstance = nil;

+(JVCHorizontalScreenBar *)shareHorizontalBarInstance
{
    @synchronized(self)
    {
        
        if (shareInstance == nil) {
            
            shareInstance  = [[self alloc] init];
            
            shareInstance.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            
            [shareInstance initWithItems];
            
            [shareInstance initStreamBtn];
            shareInstance.hidden = YES;
        }
        
    }
    return shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        shareInstance = [super allocWithZone:zone];
        
        return shareInstance;
    }
    
    return nil;
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/**
 *  初始化界面
 */
-  (void)initWithItems
{
    for (int i=0; i<MAXBTNCOUNT; i++) {
        
        UIImage *imgNormal = [UIImage imageNamed:[NSString stringWithFormat:@"HorizontalScreenBar_%d.png",i]];
        
        UIImage *imgHover = [UIImage imageNamed:[NSString stringWithFormat:@"HorizontalScreenBarselect_%d.png",i]];
        
        UIButton *butItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        butItem.frame = CGRectMake(30+i*(imgNormal.size.width+25), (HORIZEROSCREENVIEWHEIGHT - 35)/2.0, 35, 35);
        
        butItem.tag = i+BTNTAG;
        
        [butItem setBackgroundImage:imgNormal forState:UIControlStateNormal];
        
        
        [butItem setBackgroundImage:imgHover forState:UIControlStateSelected];
        
        
        [butItem setBackgroundImage:imgHover forState:UIControlStateHighlighted];
        
        
        [butItem addTarget:self action:@selector(horizontalBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:butItem];
        
    }
}

/**
 *  初始化码流设置按钮
 */
- (void)initStreamBtn
{
    streamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"HorizontalScreenBarstreambtnbg.png"];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    streamBtn.frame = CGRectMake(window.frame.size.height -image.size.width -30 , (HORIZEROSCREENVIEWHEIGHT - image.size.height)/2.0, image.size.width, image.size.height);
    streamBtn.tag = HORIZONTALBAR_STREAM+BTNTAG;
    NSLog(@"streamBtn==%@==%@",NSStringFromCGRect(streamBtn.frame),window);
    [streamBtn addTarget:self action:@selector(horizontalBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [streamBtn setBackgroundImage:image forState:UIControlStateNormal];
    [streamBtn setTitle:LOCALANGER(@"hor_stream_default") forState:UIControlStateNormal];
    [self addSubview:streamBtn];
    
}

/**
 *  HorizontalScreenBar按钮按下的返回值
 *
 *  @param btn 传回相应的but
 */
- (void)horizontalBarBtnClick:(UIButton *)btn
{
    if (HorizontalDelegate!=nil && [HorizontalDelegate respondsToSelector:@selector(HorizontalScreenBarBtnClickCallBack:)]) {
        
        [HorizontalDelegate HorizontalScreenBarBtnClickCallBack:btn];
    }
}

/**
 *  设置按钮为选中状态
 *
 *  @param index 选中状态
 */
- (void)setBtnForSelectState:(int)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+BTNTAG];
    
    btn.selected = YES;
}

/**
 *  设置所有的按钮为非选中状态
 */
- (void)setALlBtnNormal
{
    for (UIButton *btn in self.subviews) {
        
        btn.selected = NO;
    }
}

/**
 *  设置按钮的选中状态为非选中状态
 *
 *  @param index 按钮索引
 */
-(void)setBtnForNormalState:(int)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+BTNTAG];
    
    btn.selected = NO;
}

/**
 *  返回按钮的选中状态
 *
 *  @param index 按钮索引
 */
- (BOOL)getBtnSelectStateWithIndex:(int)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+BTNTAG];
    
    return btn.selected;
}

/**
 *  设置按钮为选中状态
 *
 *  @param index 选中状态
 */
- (void)setBtnEffectImage:(int)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+BTNTAG];
    
    btn.selected = YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

/**
 *  设置码流信息
 */
- (void)setStreamBtnTitle:(NSString *)titile
{
    [streamBtn setTitle:titile forState:UIControlStateNormal];
}


@end

