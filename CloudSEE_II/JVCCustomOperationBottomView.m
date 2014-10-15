//
//  JVCCustomOperationBottomView.m
//  CloudSEE_II
//  视频播放界面，最下面的部分
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCCustomOperationBottomView.h"

static const NSString *BUNDLENAMEButtom = @"customBottomView_cloudsee.bundle";//bundle的名称

static const double IOS_SYSTEM_7_A = 7.0; //ios7
static const int TAGADD = 100000;         //起始tag
static const int kButtomImageSeperateCount = 2;//png图片被.分开的时候的数组个数
@interface JVCCustomOperationBottomView (){
    
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

@implementation JVCCustomOperationBottomView

@synthesize BottomDelegate;

static JVCCustomOperationBottomView *_shareInstance = nil;

/**
 *  单例
 *
 *  @return 返回 单例
 */
+ (JVCCustomOperationBottomView *)shareInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            
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
 *  初始化播放视频底部view
 *
 *  @param titileArray title的列表
 *  @param frame       frame大小
 *  @param skinType    皮肤类型
 *
 *  @return id类型
 */
- (void)updateViewWithTitleArray:(NSArray *)titileArray Frame:(CGRect)frame SkinType:(int)skinType
{
    _shareInstance.frame = frame;
    
    /**
     *  初始化按钮数组
     */
    _arrayButtons = [[NSMutableArray alloc] initWithCapacity:10];
    
    /**
     *  设置未选中的集合
     */
    [_shareInstance setUnselectImageListWithType];
    /**
     *  设置选中的集合
     */
    [self setSelectImageListWithType:skinType];
    
    UIFont *font = [UIFont systemFontOfSize:12];
    
    // Initialization code
    
    for (int i=0; i<titileArray.count; i++) {
        
        UIImage *imageNormal  =[UIImage imageWithContentsOfFile:[self getBundleImagePath: [_amUnSelectedImageNameListData  objectAtIndex:i]]];
        
        UIImage *imageHover   = [UIImage imageWithContentsOfFile:[self getBundleImagePath:[_amSelectedImageNameListData objectAtIndex:i]]];
        
        NSString *title  = [titileArray objectAtIndex:i];
        
        CGSize size  = CGSizeMake(imageNormal.size.width, 800);
        
        double IOS_VERSION_A =[[UIDevice currentDevice] systemVersion].floatValue;
        
        if (IOS_VERSION_A>=IOS_SYSTEM_7_A) {//ios7
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
            
            size = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            
        }else{
            
            size = [title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(i*(frame.size.width/titileArray.count), 0, frame.size.width/titileArray.count, frame.size.height);
        
        [btn setTitle:[titileArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn setImage:imageNormal forState:UIControlStateNormal];
        
        btn.tag =TAGADD+i;
        
        [btn setImage:imageHover forState:UIControlStateHighlighted];
        
        [btn setImage:imageHover forState:UIControlStateSelected];
        
        [btn.titleLabel setFont:font];
        
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -size.width/2)];
        
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: @"smallItem__Normal.png"]] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover.png"]]] forState:UIControlStateHighlighted];
        
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover_.png"]]] forState:UIControlStateSelected];
        
        
        [_shareInstance addSubview:btn];
        
        [_arrayButtons addObject:btn];
        
    }
    
}

/**
 *  按钮点击的回调
 */
- (void)clickButton:(UIButton *)btn
{
    if (BottomDelegate !=nil &&[BottomDelegate respondsToSelector:@selector(customBottomPressCallback:)]) {
        
        [BottomDelegate customBottomPressCallback:btn.tag - TAGADD];
        
    }
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
    
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"smallCaptureSelectedBtn.png"]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"megaphoneSelected.png"]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"videoSelected.png"]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"streamSelected.png"]];
}

/**
 *  设置皮肤未选中的图片集合
 */
- (void)setUnselectImageListWithType{
    /**
     *  btn没有选中的图标集合
     */
    _amUnSelectedImageNameListData = [[NSMutableArray alloc] init];
    
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"smallCaptureUnselectedBtn.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"megaphoneUnselected.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"videoUnselected.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"streamUnselected.png"]];
}

/**
 *  根据index获取button
 *
 *  @param index 获取button的索引
 *
 *  @return 放回相应的bug，如果超出返回nil
 */
-(UIButton *)getButtonWithIndex:(int )index
{
    if (index>_arrayButtons.count) {
        
        return nil;
        
    }
    
    return [_arrayButtons objectAtIndex:index];
    
}

/**
 *  设置button的选中状态
 *
 *  @param index    要选中的button
 *  @param skinType 皮肤的标志
 *
 *  @return 成功yes  否则 no
 */
- (BOOL)setbuttonSelectStateWithIndex:(int )index andSkinType:(int )skinType
{
    if (index>_arrayButtons.count) {
        
        return NO;
        
    }
    
    UIButton *btn =  [_arrayButtons objectAtIndex:index];
    
    
    [self setSelectImageListWithType:skinType];
    
    UIImage *imageHover   = [UIImage imageWithContentsOfFile:[self getBundleImagePath:[_amSelectedImageNameListData objectAtIndex:index]]];
    
    [btn setImage:imageHover forState:UIControlStateSelected];
    [btn setImage:imageHover forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover.png"]]] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover.png"]]] forState:UIControlStateSelected];
    [btn setSelected:YES];
    
    return YES;
}

/**
 *  设置单个按钮为未选中状态
 *
 *  @param index button的索引
 *
 *  @return yes 成功  no 失败
 */
- (BOOL)setbuttonUnSelectWithIndex:(int )index
{
    if (index>_arrayButtons.count) {
        
        return NO;
        
    }
    
    UIButton *btn =  [_arrayButtons objectAtIndex:index];
    
    //    UIImage *imageHover   = [UIImage imageWithContentsOfFile:[self getBundleImagePaht:[_amUnSelectedImageNameListData objectAtIndex:index]]];
    
    btn.selected = NO;
    
    //    [btn setImage:imageHover forState:UIControlStateNormal];
    
    return YES;
    
}

/**
 *  换肤之后，重新设置选中的按钮颜色
 *
 *  @param skinType 选中的皮肤颜色
 */
- (void)resetSelectButtonsWithSkinType:(int )skinType
{
    [self setSelectImageListWithType:skinType];
    
    for (int i=0;i<_arrayButtons.count;i++) {
        
        UIButton *btn = [_arrayButtons objectAtIndex:i];
        
        if (btn.selected ) {
            
            btn.selected = NO;
            
            [btn setImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath:[_amSelectedImageNameListData objectAtIndex:i]] ] forState:UIControlStateSelected];
            
            [btn setImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath:[_amSelectedImageNameListData objectAtIndex:i]] ] forState:UIControlStateHighlighted];
            
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover.png"]]] forState:UIControlStateHighlighted];
            
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover.png"]]] forState:UIControlStateSelected];
            
            
            btn.selected = YES;
            
            
        }else{
            
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover.png"]]] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath: [ NSString stringWithFormat: @"smallItem_Hover.png"]]] forState:UIControlStateSelected];
            
            
            [btn setImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath:[_amSelectedImageNameListData objectAtIndex:i]]] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageWithContentsOfFile:[self getBundleImagePath:[_amSelectedImageNameListData objectAtIndex:i]]] forState:UIControlStateSelected];
            
            
            
        }
        
    }
    
}


/**
 *  设置所有的按钮未未选中状态
 */
- (void)setAllButtonUnselect
{
    for (int i=0;i<_arrayButtons.count;i++) {
        
        UIButton *btn = [_arrayButtons objectAtIndex:i];
        
        [btn setSelected:NO];
        
        //[btn setImage:[UIImage imageWithContentsOfFile:[self getBundleImagePaht:[_amUnSelectedImageNameListData objectAtIndex:i]] ] forState:UIControlStateNormal];
    }
}

/**
 *  设置码流
 *
 *  @param stremType 码流类型
 */
- (void)setVideoStreamState:(int)stremType
{
    if (BUTTON_TYPE_MORE>_arrayButtons.count) {
        return;
    }
    
    UIButton *btn = [_arrayButtons objectAtIndex:BUTTON_TYPE_MORE];
    NSString *bundString =  [ NSString stringWithFormat: @"stream_%d",stremType];
    [btn setTitle:NSLocalizedString(bundString, nil) forState:UIControlStateNormal];
    
}

/**
 *  返回UIImage
 *
 *	@param	ImageName	图片的名字
 *
 *	@return	返回指定指定图片名的图片
 */
-(NSString *)getBundleImagePath:(NSString *)ImageName{
    
    NSString *main_image_dir_path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:(NSString *)BUNDLENAMEButtom];
    
    NSString *image_path= nil;//[main_image_dir_path stringByAppendingPathComponent:ImageName];
    
    NSArray *array = [ImageName componentsSeparatedByString:@"."];
    
    if (kButtomImageSeperateCount == array.count ) {
        
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
    
    [_amSelectedImageNameListData release];
    
    [super dealloc];
}

@end
