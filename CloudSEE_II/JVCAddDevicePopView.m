//
//  JVCAddDevicePopView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/9/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAddDevicePopView.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"

static const float  kArrowHeight        =  10.f;//高度
static const float  kArrowCurvature     =   6.f;
static const float  SPACE               =   2.f;//间隔
static const float  ROW_HEIGHT          =   44.f;//行高
static const int    kTextFontSize       =   16;//字体大小

static const float  kOff_x              =   10.f;//距离左侧10
static const float  kImageSize          =   35.f;//添加图片增加
static const float  kOff_x_leftMin      =   5.f;//左间隔最小5
static const float  koff_x_right_Min    =   315.f;//右间隔最小5
static const float  kItemSizeAdd        =   30.f;//item 都要加40


@interface   JVCAddDevicePopView()<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *handerView;
    
    UITableView *tableViewItems;
    
    NSArray *titleArray;
    
    NSArray *imageArray;
    
    CGPoint showPoint;
}
@end
@implementation JVCAddDevicePopView
@synthesize popDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIColor *viewboardColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroPopBoardColor];
        
        if (viewboardColor) {
            
            self.borderColor = viewboardColor;
        }
        self.layer.cornerRadius = 15.0;
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        
//        NSString *pathStr = [UIImage imageBundlePath:@"add_popbg.png"];
//        UIImage *imagebg = [[UIImage alloc] initWithContentsOfFile:pathStr];
//        // Initialization code
//        self.backgroundColor = [UIColor colorWithPatternImage:imagebg];;
//        [imagebg release];
//        
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images
{
    self = [super init];
    if (self) {
        showPoint = point;
        titleArray = [titles retain];
        imageArray = [images retain];
        
        self.frame = [self getViewFrame];
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    
    frame.size.height = [titleArray count] * ROW_HEIGHT + SPACE + kArrowHeight;
    
    for (NSString *title in titleArray) {
        CGFloat width =  [title sizeWithFont:[UIFont systemFontOfSize:kTextFontSize] constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByCharWrapping].width;
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([titleArray count] == [imageArray count]) {
        
        frame.size.width = kOff_x + kImageSize + frame.size.width + kItemSizeAdd;
    }else{
        frame.size.width = kOff_x + frame.size.width + kItemSizeAdd;
    }
    
    frame.origin.x = showPoint.x - frame.size.width/2;
    frame.origin.y = showPoint.y;
    
    //左间隔最小5x
    if (frame.origin.x < kOff_x_leftMin) {
        frame.origin.x = kOff_x_leftMin;
    }
    //右间隔最小5x
    if ((frame.origin.x + frame.size.width) > koff_x_right_Min) {
        frame.origin.x = koff_x_right_Min - frame.size.width;
    }
    
    return frame;
}


-(void)show
{
    handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [handerView setFrame:[UIScreen mainScreen].bounds];
    [handerView setBackgroundColor:[UIColor clearColor]];
    [handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:handerView];
    
    CGPoint arrowPoint = [self convertPoint:showPoint fromView:handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [handerView removeFromSuperview];
    }];
    
}


#pragma mark - UITableView

-(UITableView *)tableView
{
    if (tableViewItems != nil) {
        return tableViewItems;
    }
    
    CGRect rect = self.frame;
    rect.origin.x = SPACE;
    rect.origin.y = kArrowHeight + SPACE;
    rect.size.width -= SPACE * 2;
   // rect.size.height -= (SPACE - kArrowHeight);
    
    tableViewItems = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableViewItems.delegate = self;
    tableViewItems.dataSource = self;
    tableViewItems.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewItems.alwaysBounceHorizontal = NO;
    tableViewItems.alwaysBounceVertical = NO;
    tableViewItems.showsHorizontalScrollIndicator = NO;
    tableViewItems.showsVerticalScrollIndicator = NO;
    tableViewItems.scrollEnabled = NO;
    tableViewItems.backgroundColor = [UIColor clearColor];

    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return tableViewItems;
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
//    cell.backgroundView = [[UIView alloc] init];
    
//    UIColor *viewBGColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroViewControllerBackGround];
//    
//    if (viewBGColor) {
//        
//        cell.backgroundView.backgroundColor = viewBGColor;
//    }
    
    if ([imageArray count] == [titleArray count]) {
        cell.imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:kTextFontSize];
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= IOS7) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
    if (popDelegate !=nil && [popDelegate respondsToSelector:@selector(didSelectItemRowAtIndex:)]) {
        
        [popDelegate didSelectItemRowAtIndex:indexPath.row];
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.borderColor set]; //设置线条颜色
    
    CGRect frame = CGRectMake(0, kOff_x, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint arrowPoint = [self convertPoint:showPoint fromView:handerView];
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
    
    /********************向上的箭头**********************/
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
    [popoverPath addCurveToPoint:arrowPoint
                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
                   controlPoint2:arrowPoint];//actual arrow point
    
    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
                   controlPoint1:arrowPoint
                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    /********************向上的箭头**********************/
    
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
    
    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
    
    //填充颜色
    UIColor *viewBGColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroPopBgColor];
    
    if (viewBGColor) {
        
        [viewBGColor setFill];
    }
    [popoverPath fill];
    
    [popoverPath closePath];
    [popoverPath stroke];
    

}

- (void)dealloc
{
    [tableViewItems release];
    [titleArray release];
    [imageArray release];
    [super dealloc];
}

@end
