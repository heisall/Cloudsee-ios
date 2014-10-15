//
//  JVCCustomCoverView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/7/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCCustomCoverView.h"

static NSString const * BUNDLENAME     =  @"CustomCoverView.bundle";//遮罩的图片

static int      const   STARTHEIGHT    = 64;                           //开始位置

static double   const TIMERDURATION    = 0.5;// 动画时间

@interface JVCCustomCoverView ()
{
    NSMutableArray *_itemsArrayListData;
    
    int _selectIndex;
    
    UIView *tempView;
    
    UILabel *label;
    
    NSMutableArray *_btnArrays;
}

@end

@implementation JVCCustomCoverView
@synthesize CustomCoverDelegate;


static double const ITEM_HEIGHT     = 40.0 ;//一个item的高度
static double const ITEM_WIDTH      = 120.0;//一个item的宽度
static int  const TOPITEMFLAGSTARTINDEXVALUE =100;//item的起始flag

static JVCCustomCoverView *_shareInstance = nil;

/**
 *  单例
 *
 *  @return 返回 单例
 */
+ (JVCCustomCoverView *)shareInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            
            _shareInstance.userInteractionEnabled = YES;
            
            [_shareInstance initArray];
            
            _shareInstance.clipsToBounds = YES;
            
            _shareInstance.backgroundColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:0.5];
            
        }
        return _shareInstance;
    }
    return _shareInstance;
}

- (void)initArray
{
    _itemsArrayListData = [[NSMutableArray alloc] init];
    
    _btnArrays          = [[NSMutableArray alloc] init];
    
}

+(id)allocWithZone:(NSZone *)zone
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
 *  跟新覆盖试图消息
 *
 *  @param titleArray 分屏消息
 *  @param skinType   皮肤
 */
- (void)updateConverViewWithTitleArray:(NSArray *)titleArray  skinType:(int )skinType
{
    /**
     *  清除之前的数据
     */
    for (UIView *viewContrnt in self.subviews) {
        
        [viewContrnt removeFromSuperview];
    }
    // Initialization code
    /**
     *  白色三角
     */
    UIImage *_splitItemInfo=[UIImage imageWithContentsOfFile:[self getBundleImagePaht:[NSString stringWithFormat: @"splitItem.png"]]];
    
    UIImageView *_splitItemView=[[UIImageView alloc] initWithImage:_splitItemInfo];
    
    _splitItemView.backgroundColor=[UIColor clearColor];
    
    _splitItemView.frame=CGRectMake((self.frame.size.width-_splitItemInfo.size.width)/2.0,STARTHEIGHT, _splitItemInfo.size.width, _splitItemInfo.size.height);
    
    [self addSubview:_splitItemView];
    
    
    [_splitItemView release];
    
    /**
     *  清除数据元素
     */
    [_itemsArrayListData removeAllObjects];
    [_itemsArrayListData addObjectsFromArray:titleArray];
    [_btnArrays removeAllObjects];
    
    UIControl *controll = [[UIControl alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    [controll addTarget:self action:@selector(removeConverView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:controll];
    [controll release];
    /**
     *  分屏按钮
     */
    int off_y =_splitItemInfo.size.height+_splitItemView.frame.origin.y;
    
    
    for (int i=0; i<[_itemsArrayListData count]; i++) {
        
        UIButton *_topItemView  = [UIButton buttonWithType:UIButtonTypeCustom];
        _topItemView.frame      =CGRectMake(self.frame.origin.x, i*ITEM_HEIGHT+off_y, ITEM_WIDTH, ITEM_HEIGHT);
        _topItemView.center     = CGPointMake(_splitItemView.center.x, _topItemView.center.y);
        _topItemView.tag        = i+TOPITEMFLAGSTARTINDEXVALUE;
        
        [_topItemView setTitle:[_itemsArrayListData objectAtIndex:i] forState:UIControlStateNormal];
        [_topItemView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_topItemView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_topItemView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIImage *imghov=[UIImage imageWithContentsOfFile:[self getBundleImagePaht:[NSString stringWithFormat: @"SplitItemBg.png"]]];
        [_topItemView setBackgroundImage:imghov forState:UIControlStateHighlighted];
        [_topItemView setBackgroundImage:imghov forState:UIControlStateSelected];
        UIImage *imgNor=[UIImage imageWithContentsOfFile:[self getBundleImagePaht:[NSString stringWithFormat: @"unSplitItemBg.png"]]];
        [_topItemView setBackgroundImage:imgNor forState:UIControlStateNormal];
        [_topItemView addTarget:self action:@selector(handleSingelTabFrom:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArrays addObject:_topItemView];
        
        [self addSubview:_topItemView];
    }
    
    BOOL isSelect = NO;
    
    for (UIButton *btn in _btnArrays) {
        
        if([btn isSelected])
        {
            [btn setSelected:YES];
        }
    }
    
    if (!isSelect) {
        
        UIButton *btn = [_btnArrays firstObject];
        
        [btn setSelected:YES];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:TIMERDURATION];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height);
    
    [UIView commitAnimations];
    
    
    
    
}

/**
 *  相应点击事件
 *
 *  @param sender 手势
 */
-(void)handleSingelTabFrom:(id)sender{
    
	UIButton *topBtnSender=(UIButton*)sender;
    
    for (UIButton *btn in _btnArrays) {
        
        [btn setSelected:NO];
        
    }
    
    UIButton *btn = [_btnArrays objectAtIndex:topBtnSender.tag - TOPITEMFLAGSTARTINDEXVALUE];
    
    [btn setSelected:YES];
    
    [self removeConverView];
    
    if (CustomCoverDelegate !=nil && [CustomCoverDelegate respondsToSelector:@selector(customCoverViewButtonCkickCallBack:)]) {
        
        [CustomCoverDelegate customCoverViewButtonCkickCallBack:(int)topBtnSender.tag - TOPITEMFLAGSTARTINDEXVALUE];
    }
}

/**
 *  移除converview
 */
- (void)removeConverView
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:TIMERDURATION];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    
    [UIView commitAnimations];
}


/**
 *  返回UIImage
 *s
 *	@param	ImageName	图片的名字
 *
 *	@return	返回指定指定图片名的图片
 */
-(NSString *)getBundleImagePaht:(NSString *)ImageName{
    
    NSString *main_image_dir_path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:(NSString *)BUNDLENAME];
    
    NSString *image_path=[main_image_dir_path stringByAppendingPathComponent:ImageName];
    
    return image_path;
}

@end

