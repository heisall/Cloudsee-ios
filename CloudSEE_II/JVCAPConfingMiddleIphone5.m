//
//  JVCAPConfingMiddleIphone5.m
//  project_NewApMiddle
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Jovision. All rights reserved.
//

#import "JVCAPConfingMiddleIphone5.h"
#import "UIImage+BundlePath.h"

@interface JVCAPConfingMiddleIphone5 ()
{
    NSMutableArray *_arrayList;
    
    NSMutableArray *_arrayImageSelect;
    
    NSMutableArray *_arrayBtnList;
    
    NSMutableArray *_arrayViewList;
}

@end

@implementation JVCAPConfingMiddleIphone5
@synthesize delegateIphone5BtnCallBack;

static const int kMiddleIphone5ImageSeperateCount =2;//图片的名称用点分割之后，得到的数组个数，后面要给他追加@2x
static const int  OFF_X  =  20;                      //距离左边距的距离
static const int OPERATIONBIGITEM  = 20.0;           //距离


static const int  KlabeTextTitleFont    =  16;      //title的字体大小
static const int  KlabeTextDetailFont   =  14;      //detail的字体大小
static const int  KlabeWith             =  210;      //label的宽度
static const int  KlabeAddHeight        =  4;       //label的高度添加值（比字体大4）

/**
 *  单例
 */
static JVCAPConfingMiddleIphone5 *shareApConfigMiddleIphone5Instance = nil;

+ (JVCAPConfingMiddleIphone5 *)shareApConfigMiddleIphone5Instance
{
    @synchronized(self)
    {
        if (shareApConfigMiddleIphone5Instance == nil) {
            
            shareApConfigMiddleIphone5Instance = [[self alloc] init];
            
            [shareApConfigMiddleIphone5Instance initImageArray];
            
            [shareApConfigMiddleIphone5Instance initImageSelectArray];
            
            [shareApConfigMiddleIphone5Instance initBtnArray];
            
            [shareApConfigMiddleIphone5Instance initViewArray];

        }
    }
    return shareApConfigMiddleIphone5Instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shareApConfigMiddleIphone5Instance == nil) {
            
            shareApConfigMiddleIphone5Instance = [super allocWithZone: zone];
            
            return shareApConfigMiddleIphone5Instance;
        }
    }
    return nil;
}



/**
 *  这个方法之前，一定要设置view的frame
 *  显示音频监听、云台、远程回放view
 *
 *  @param titleArray  主title
 *  @param detailArray 副title
 */
- (void)updateViewWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray
{
    for (UIView *viewContent in self.subviews) {
        
        [viewContent removeFromSuperview];
    }
    
    CGFloat height = self.frame.size.height/titleArray.count;
    
    for (int i = 0;i<titleArray.count;i++) {
        /**
         *  主要信息
         */
        NSString *strTitle = [titleArray objectAtIndex:i];
        
        NSString *strDetailTitle = nil;
        
        if (i<detailArray.count) {
            /**
             *  detail信息
             */
            strDetailTitle = [detailArray objectAtIndex:i];
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, i*height, self.frame.size.width, height)];
        contentView.backgroundColor = [UIColor clearColor];
        
        NSString *imageHeadStr = [UIImage imageBundlePath:[_arrayList objectAtIndex:i]];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageHeadStr];
            
        NSString *imageHeadHover = [UIImage imageBundlePath:[_arrayImageSelect objectAtIndex:i]];
        UIImage *imageHover = [[UIImage alloc] initWithContentsOfFile:imageHeadHover];
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = CGRectMake(OFF_X, (height - image.size.height)/2.0, image.size.width, image.size.height);
        [btnImage setImage:image forState:UIControlStateNormal];
        [btnImage setImage:imageHover forState:UIControlStateSelected];
        [btnImage setImage:imageHover forState:UIControlStateHighlighted];
        [btnImage addTarget:self action:@selector(btnImageClick:) forControlEvents:UIControlEventTouchUpInside];
        btnImage.tag = i;
        [contentView addSubview:btnImage];
        [imageHover release];
        
        [_arrayBtnList addObject:btnImage];
        
        UILabel *_titleName=[[UILabel alloc] init];
        _titleName.frame=CGRectMake(btnImage.frame.origin.x+btnImage.frame.size.width+OPERATIONBIGITEM, (height - 43)/2.0, KlabeWith, KlabeTextTitleFont+KlabeAddHeight);
        _titleName.textAlignment=NSTextAlignmentLeft;
        _titleName.text= strTitle;
        _titleName.font= [UIFont systemFontOfSize:KlabeTextTitleFont];
        _titleName.textColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        _titleName.backgroundColor=[UIColor clearColor];
        [contentView addSubview:_titleName];
        [_titleName release];
        
        UILabel *_titleInfo=[[UILabel alloc] init];
        _titleInfo.frame=CGRectMake(_titleName.frame.origin.x, _titleName.frame.origin.y+_titleName.frame.size.height+5.0, KlabeWith, KlabeTextDetailFont+KlabeAddHeight);
        _titleInfo.textAlignment=NSTextAlignmentLeft;
        _titleInfo.text=    strDetailTitle;
        _titleInfo.font=[UIFont systemFontOfSize:KlabeTextDetailFont];
        _titleInfo.textColor=[UIColor colorWithRed:154.0/255 green:154.0/255  blue:154.0/255  alpha:1];
        _titleInfo.backgroundColor=[UIColor clearColor];
        [contentView  addSubview:_titleInfo];
        [_titleInfo release];
        
        
        NSString *imageboardVC = [UIImage imageBundlePath:@"boderBigLine.png"];
        UIImage *boderImage = [[UIImage alloc] initWithContentsOfFile:imageboardVC];
        
        UIImageView *_boderImageView=[[UIImageView alloc] init];
        _boderImageView.frame=CGRectMake((self.frame.size.width-boderImage.size.width)/2.0, height-boderImage.size.height, boderImage.size.width, boderImage.size.height);
        _boderImageView.userInteractionEnabled = YES;
        [_boderImageView setImage:boderImage];
        [contentView addSubview:_boderImageView];
        [_boderImageView release];
        
        contentView.tag = i;
        /**
         *  添加手势
         */
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackGroup:)];
        
        [contentView addGestureRecognizer:recognizer];
        
        [recognizer release];
        
        [self addSubview:contentView];
        
        [_arrayViewList  addObject:contentView];

        [contentView release];
        
        [image release];
    }
}



/**
 *  设置btn为选中状态
 *
 *  @param selectIndex 索引
 */
- (void)setBtnSelect:(int)selectIndex
{
    if (selectIndex >=_arrayBtnList.count) {
        
        return;
    }
    
    UIButton *btn = [_arrayBtnList objectAtIndex:selectIndex];
    
    btn.selected = YES;
    
}

/**
 *  设置btn为非选中状态
 *
 *  @param selectIndex 索引
 */
- (void)setBtnUnSelect:(int)selectIndex
{
    if (selectIndex >=_arrayBtnList.count) {
        
        return;
    }
    
    UIButton *btn = [_arrayBtnList objectAtIndex:selectIndex];
    
    btn.selected = NO;
    
}

/**
 *  设置btn全为非选中状态
 */
- (void)setAllBtnUnSelect
{
    for (UIButton *btn in _arrayBtnList) {
        
        btn.selected = NO;

    }
}

/**
 *  初始化数组信息
 */
- (void)initImageArray
{
    _arrayList = [[NSMutableArray alloc] init];
    
    [_arrayList addObject:@"apcofig_0.png"];
    [_arrayList addObject:@"apcofig_1.png"];
    [_arrayList addObject:@"apcofig_2.png"];
}

/**
 *  获取btn的选中状态
 *
 *  @param selectIndex 索引
 */
- (BOOL)getBtnSelectState:(int)selectIndex
{
    if (selectIndex >=_arrayBtnList.count) {
        
        return NO ;
    }
    
    UIButton *btn = [_arrayBtnList objectAtIndex:selectIndex];
    
    return btn.selected;
}
/**
 *  初始化数组信息
 */
- (void)initImageSelectArray
{
    _arrayImageSelect = [[NSMutableArray alloc] init];
    
    [_arrayImageSelect addObject:@"apcofig_0_sec.png"];
    [_arrayImageSelect addObject:@"apcofig_1_sec.png"];
    [_arrayImageSelect addObject:@"apcofig_2_sec.png"];
}

- (void)initBtnArray
{
    _arrayBtnList = [[NSMutableArray alloc] init];
}

- (void)initViewArray
{
    _arrayViewList = [[NSMutableArray alloc] init];
}

/**
 *  点击背景的回调
 *
 *  @param gesture 手势
 */
- (void)clickBackGroup:(UITapGestureRecognizer *)gesture
{
    [self callDelegate:gesture.view.tag];
}

- (void)btnImageClick:(UIButton *)btn
{
    [self callDelegate:btn.tag];
    
}

- (void)callDelegate:(int)responseTag
{
    if (delegateIphone5BtnCallBack !=nil &&[delegateIphone5BtnCallBack respondsToSelector:@selector(operationMiddleIphone5APBtnCallBack:)]) {
        
        [delegateIphone5BtnCallBack operationMiddleIphone5APBtnCallBack:(int )responseTag];
    }
    
}

/**
 *  获取相应的view
 *
 *  @param selectIndex 索引
 *
 *  @return 相应的veiw
 */
- (UIView *)getSelectbgView:(int)selectIndex
{

    if (selectIndex >=_arrayBtnList.count) {
        
        return nil ;
    }
    
    UIView *bgView = [_arrayViewList objectAtIndex:selectIndex];
    
    return bgView;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
