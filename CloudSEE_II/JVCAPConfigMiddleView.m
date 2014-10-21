//
//  JVCAPConfigMiddleView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAPConfigMiddleView.h"
#import "JVCOperationMiddleView.h"

@interface JVCAPConfigMiddleView ()
{
    NSMutableArray *_ApUnSelectedImageNameListData;
    
    NSMutableArray *_ApSelectArray;
    
    NSMutableArray *_arrayBtnList;
}
@end

@implementation JVCAPConfigMiddleView
@synthesize delegateApOperationMiddle;

static const double KHEGIHT          =   20.0;   //lable的高度
static const int KTAGADD = 100000;         //起始tag

static JVCAPConfigMiddleView *_shareInstance = nil;
/**
 *  单例
 *
 *  @return 返回单例
 */
+ (JVCAPConfigMiddleView *)shareAPConfigMiddleInstance
{
        @synchronized(self)
        {
            if (_shareInstance == nil) {
                
                _shareInstance = [[self alloc] init ];
                
                /**
                 *  初始化按钮mormal的背景图片
                 */
                [_shareInstance setUnselectImageList];
                [_shareInstance setSelectImageList];
                
                /**
                 *  设置button数组
                 */
                [_shareInstance initApButtonsArray];
            }
            return _shareInstance;
    }
    return _shareInstance;
}

/**
 *  设置middleview
 *
 *  @param titileArray 显示文本
 *  @param frame       frame大小
 *  @param skinType    皮肤颜色
 */
- (void)updateAPViewWithTitleArray:(NSArray *)titileArray  
{
    
    /**
     *  清除view上面的控件
     */
    for(UIView *viewContent in _shareInstance.subviews)
    {
        [viewContent removeFromSuperview];
    }
    
    /**
     *  默认的背景图片
     */
    NSString *imagepathBg = [UIImage getBundleImagePath:@"operation_bigItemBtnBg.png" bundleName:(NSString *)BUNDLENAMEMiddle];
    
    UIImage *_bigItemImage = [[UIImage alloc] initWithContentsOfFile:imagepathBg];
    
    /**
     *  计算按钮之间的空格
     */
    int seperateSpace = (_shareInstance.width -titileArray.count*_bigItemImage.size.width)/(titileArray.count+1);
    
    for(int i=0;i<titileArray.count;i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(seperateSpace+i*(seperateSpace+_bigItemImage.size.width), (_shareInstance.height - _bigItemImage.size.height)/2.0, _bigItemImage.size.width, _bigItemImage.size.height);
        
        UIImage *normalImage = [[UIImage alloc] initWithContentsOfFile: [UIImage getBundleImagePath:[_ApUnSelectedImageNameListData objectAtIndex:i] bundleName:(NSString *)BUNDLENAMEMiddle]];
        
        UIImage *hoverImage = [[UIImage alloc] initWithContentsOfFile: [UIImage getBundleImagePath:[_ApSelectArray objectAtIndex:i] bundleName:(NSString *)BUNDLENAMEMiddle]];

        [btn setBackgroundImage:_bigItemImage forState:UIControlStateNormal];
        
        [btn setImage:normalImage forState:UIControlStateNormal];
        
        [btn setImage:hoverImage forState:UIControlStateHighlighted];
        
        [btn setImage:hoverImage forState:UIControlStateSelected];
        
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-(self.frame.size.height -hoverImage.size.height)/2+15 ,0 , 0,0)];
        
        UILabel * _LableTitle=[[UILabel alloc] init];
        _LableTitle.frame=CGRectMake(0.0,btn.frame.size.height*0.65, btn.frame.size.width, KHEGIHT);
        _LableTitle.font = [UIFont systemFontOfSize:14];
        _LableTitle.text =[titileArray objectAtIndex:i] ;
        _LableTitle.textAlignment=NSTextAlignmentCenter;
        [btn addSubview:_LableTitle];
        [_LableTitle setBackgroundColor:[UIColor clearColor]];
        
        btn.tag = KTAGADD+i;
        
        [_shareInstance addSubview:btn];
        
        [btn addTarget:self action:@selector(apButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_arrayBtnList  addObject:btn];
        
        [normalImage release];
        
        [hoverImage release];
    }
    
    [_bigItemImage release];
}

/**
 *  button点击的事件
 *
 *  @param sender 按下的按钮事件
 */
- (void)apButtonClick:(UIButton *)sender
{
    if (delegateApOperationMiddle !=nil && [delegateApOperationMiddle respondsToSelector:@selector(ApConfigoperationMiddleViewButtonCallback:)]) {
        
        [delegateApOperationMiddle ApConfigoperationMiddleViewButtonCallback:(int)sender.tag - KTAGADD ];
    }
}

/**
 *  设置button的状态为选中状态
 *
 *  @param buttonIndex button的索引
 *  @param skinType    皮肤
 */
- (void)setAPConfigButtonSelect:(int)buttonIndex
{
    if (buttonIndex >=_arrayBtnList.count) {
        
        return;
    }
    
    UIButton *btn = [_arrayBtnList objectAtIndex:buttonIndex];
    
    btn.selected = YES;
}

/**
 *  设置button为非选中状态
 */
- (void)setButtonunSelect:(int )buttonindex
{
    if (buttonindex >=_arrayBtnList.count) {
        
        return;
    }
    
    UIButton *btn = [_arrayBtnList objectAtIndex:buttonindex];
    
    btn.selected = NO;
}

/**
 *  返回iphone4/4s按钮的状态
 *
 *  @return 选中状态yes 非选中状态No
 */
- (BOOL)getBtnSelectState:(int)buttonIndex
{
    if (buttonIndex >=_arrayBtnList.count) {
        
        return NO ;
    }
    
    UIButton *btn = [_arrayBtnList objectAtIndex:buttonIndex];
    
    return  btn.selected;
}

    /**
     *  设置皮肤未选中的图片集合
     */
- (void)setUnselectImageList{
    /**
     *  btn没有选中的图标集合
     */
    _ApUnSelectedImageNameListData = [[NSMutableArray alloc] init];
    
    [_ApUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"audioListener.png"]];
    [_ApUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"ytoBtn.png"]];
    [_ApUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"operation_talk.png"]];
}

- (void)setSelectImageList{
    /**
     *  btn没有选中的图标集合
     */
    _ApSelectArray = [[NSMutableArray alloc] init];
    
    [_ApSelectArray addObject:[NSString stringWithFormat:@"%@",@"audioListennerSelected.png"]];
    [_ApSelectArray addObject:[NSString stringWithFormat:@"%@",@"ytoSelectedBtn.png"]];
    [_ApSelectArray addObject:[NSString stringWithFormat:@"%@",@"opera_4_talk_Hover.png"]];
}

- (void)initApButtonsArray
{
    _arrayBtnList = [[NSMutableArray alloc] init];
}

@end
