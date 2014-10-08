//
//  JVCOperationMiddleView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/7/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationMiddleView.h"

static const NSString *BUNDLENAMEMiddle =  @"customMiddleView_cloudsee.bundle";
#define IOS_VERSION_A [[[UIDevice currentDevice] systemVersion] floatValue]
static const double IOS_SYSTEM_7_A  =  7.0;     //ios7
static const int    TAGADD          =  10000;   //tag开始
static const int    SEPERATENUM     =   4;      //按钮之间的空格数
static const double HEGIHT          =   20.0;   //lable的高度
static const int    kMiddleImageSeperateCount     =   2;      //图片名称根据.截开之后得到的数组个数


@interface JVCOperationMiddleView ()
{
    /**
     *  未选中的图片
     */
    NSMutableArray *_amUnSelectedImageNameListData;
    /**
     *  选中的图片
     */
    NSMutableArray *_amSelectedImageNameListData;
    
    /**
     *  获取button的数组
     */
    NSMutableArray *_arrayButtons;
    
}

@end


@implementation JVCOperationMiddleView

@synthesize delegateOperationMiddle;

static JVCOperationMiddleView *_shareInstance = nil;
/**
 *  单例
 *
 *  @return 返回单例
 */
+ (JVCOperationMiddleView *)shareInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            
            _shareInstance.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
            
            /**
             *  初始化按钮mormal的背景图片
             */
            [_shareInstance setUnselectImageListWithType];
            
            /**
             *  设置button数组
             */
            [_shareInstance initButtonsArray];
        }
        return _shareInstance;
    }
    return _shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [super allocWithZone:zone];
            
            return _shareInstance;
            
        }
    }
    return nil;
}

/**
 *  设置middleview
 *
 *  @param titileArray 显示文本
 *  @param frame       frame大小
 *  @param skinType    皮肤颜色
 */
- (void)updateViewWithTitleArray:(NSArray *)titileArray  frame:(CGRect)frame skinType:(int)skinType
{
    _shareInstance.frame  = frame;
    
    /**
     *  清除view上面的控件
     */
    for(UIView *viewContent in _shareInstance.subviews)
    {
        [viewContent removeFromSuperview];
    }
    
    /**
     *  设置选中的颜色背景
     */
    [self setSelectImageListWithType:skinType];
    
    /**
     *  默认的背景图片
     */
    UIImage *_bigItemImage = [[UIImage alloc] initWithContentsOfFile:[self getBundleImagePath:@"operation_bigItemBtnBg.png"]];
    
    /**
     *  计算按钮之间的空格
     */
    int seperateSpace = (frame.size.width-3*_bigItemImage.size.width)/SEPERATENUM;
    
    for(int i=0;i<titileArray.count;i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(seperateSpace+i*(seperateSpace+_bigItemImage.size.width), (frame.size.height - _bigItemImage.size.height)/2.0, _bigItemImage.size.width, _bigItemImage.size.height);
        
        UIImage *normalImage = [[UIImage alloc] initWithContentsOfFile:[self getBundleImagePath:[_amUnSelectedImageNameListData objectAtIndex:i]]];
        
        UIImage * hoverImage= [[UIImage alloc] initWithContentsOfFile:[self getBundleImagePath:[_amSelectedImageNameListData objectAtIndex:i]]];
        
        [btn setBackgroundImage:_bigItemImage forState:UIControlStateNormal];
        
        [btn setImage:normalImage forState:UIControlStateNormal];
        
        [btn setImage:hoverImage forState:UIControlStateHighlighted];
        
        [btn setImage:hoverImage forState:UIControlStateSelected];
        
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-(self.frame.size.height -hoverImage.size.height)/2 ,   0 , 0,0)];
        
        UILabel * _LableTitle=[[UILabel alloc] init];
        _LableTitle.frame=CGRectMake(0.0,btn.frame.size.height*0.65, btn.frame.size.width, HEGIHT);
        _LableTitle.font = [UIFont systemFontOfSize:14];
        _LableTitle.text =[titileArray objectAtIndex:i] ;
        _LableTitle.textAlignment=NSTextAlignmentCenter;
        [btn addSubview:_LableTitle];
        [_LableTitle setBackgroundColor:[UIColor clearColor]];
        
        
        btn.tag = TAGADD+i;
        
        [_shareInstance addSubview:btn];
        
        [btn addTarget:self action:@selector(customButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_arrayButtons  addObject:btn];
        
        [normalImage release];
        
        [hoverImage release];
    }
    
    [_bigItemImage release];
}

/**
 *  设置button的状态为选中状态
 *
 *  @param buttonIndex button的索引
 *  @param skinType    皮肤
 */
- (void)setSelectButtonWithIndex:(int)buttonIndex  skinType:(int)skinType
{
    [self setSelectImageListWithType:skinType];
    
    if (buttonIndex>=_arrayButtons.count) {
        return;
    }
    UIButton *btn = [_arrayButtons objectAtIndex:buttonIndex];
    
    [btn setSelected:YES];
}

/**
 *  设置所有的button为非选中状态
 */
- (void)setButtonSunSelect
{
    for (UIButton *btn in _arrayButtons) {
        
        [btn setSelected:NO];
    }
}

/**
 *  设置button的数组
 */
- (void)initButtonsArray
{
    _arrayButtons = [[NSMutableArray alloc] init];
    
}
/**
 *  btn选中的图标集合
 *
 *  @param  皮肤颜色值
 *
 */
- (void)setSelectImageListWithType:(int )skinType
{
    /**
     *  btn选中的图标集合
     */
    if (!_amSelectedImageNameListData) {
        
        _amSelectedImageNameListData = [[NSMutableArray alloc] init];
        
    }else{
        
        [_amSelectedImageNameListData removeAllObjects];
        
    }
    
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"audioListennerSelected.png"]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"ytoSelectedBtn.png"]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"playBackVideoSelected.png"]];
}

/**
 *  设置皮肤未选中的图片集合
 */
- (void)setUnselectImageListWithType{
    /**
     *  btn没有选中的图标集合
     */
    _amUnSelectedImageNameListData = [[NSMutableArray alloc] init];
    
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"audioListener.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"ytoBtn.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"playBackVideo.png"]];
}

/**
 *  返回iphone4/4s按钮的状态
 *
 *  @return 选中状态yes 非选中状态No
 */
- (BOOL)getAudioBtnState
{
    UIButton *btn = [_arrayButtons objectAtIndex:0];
    return btn.selected;
    
}
/**
 *  button点击的事件
 *
 *  @param sender 按下的按钮事件
 */
- (void)customButtonClick:(UIButton *)sender
{
    if (delegateOperationMiddle !=nil && [delegateOperationMiddle respondsToSelector:@selector(operationMiddleViewButtonCallback:)]) {
        
        [delegateOperationMiddle operationMiddleViewButtonCallback:(int)sender.tag - TAGADD ];
    }
}

/**
 *  返回UIImage
 *
 *	@param	ImageName	图片的名字
 *
 *	@return	返回指定指定图片名的图片
 */
-(NSString *)getBundleImagePath:(NSString *)ImageName{
    
    NSString *main_image_dir_path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:(NSString *)BUNDLENAMEMiddle];
    
    NSString *image_path= nil;//[main_image_dir_path stringByAppendingPathComponent:ImageName];
    
    NSArray *array = [ImageName componentsSeparatedByString:@"."];
    
    if (kMiddleImageSeperateCount == array.count ) {
        
        NSString *imageName = [array objectAtIndex:0];
        imageName  = [imageName stringByAppendingString:@"@2x."];
        imageName = [ImageName stringByAppendingString:[array objectAtIndex:1]];
        image_path = [main_image_dir_path stringByAppendingPathComponent:ImageName];
    }
    return image_path;
}


- (void)dealloc
{
    [_arrayButtons release];
    [_amUnSelectedImageNameListData release];
    [_amUnSelectedImageNameListData release];
    [super dealloc];
}



@end
