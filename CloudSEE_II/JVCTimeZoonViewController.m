//
//  JVCTimeZoonViewController.m
//  CloudSEE_II
//
//  Created by David on 14/12/11.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCTimeZoonViewController.h"

static JVCTimeZoonViewController *_shareInstance = nil;

@interface JVCTimeZoonViewController ()
{
    UITableView *_tableView;
    
    /**
     *  显示时区的lable
     */
    UILabel *_lbltimeZoon;
    
    /**
     *  存放时区的数组
     */
    NSMutableArray *_arrTimeZoneList;
}

@end

@implementation JVCTimeZoonViewController



@synthesize strCurrentTimer;
@synthesize TimeZoneDelegate;
@synthesize bSelectState;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_lbltimeZoon release];
    [super dealloc];
}

///**
// *  单例
// *
// *  @return 返回单例
// */
//+ (JVCTimeZoonViewController *)shareTimeZoneInstance
//{
//    @synchronized(self)
//    {
//        if (_shareInstance == nil) {
//            
//            _shareInstance = [[self alloc] init ];
//            
//        }
//        return _shareInstance;
//    }
//    return _shareInstance;
//}
//
//+(id)allocWithZone:(struct _NSZone *)zone
//{
//    @synchronized(self)
//    {
//        if (_shareInstance == nil) {
//            
//            _shareInstance = [super allocWithZone:zone];
//            
//            return _shareInstance;
//            
//        }
//    }
//    return nil;
//}

/**
 *  根据时区跟新消息
 *
 *  @param timeIndex 时区
 */
- (void)updateLabelWithTimeZoon:(int)timeIndex
{
    NSString *stringTimer = nil;
    
    for (NSDictionary *tdic in _arrTimeZoneList) {
        
        NSNumber *currentTimer = [tdic objectForKey: KTIMEINFO];
        
        if (currentTimer.intValue == timeIndex) {
            
            stringTimer = [tdic objectForKey:KTIMEZOME];
        }
    }
    
    _lbltimeZoon.text = stringTimer;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self addLeftButton];
    
    self.title = LOCALANGER(@"HITVIS_TIME_zoon");
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // Do any additional setup after loading the view.
    
    /**
     *  显示当前时间的背景
     */
    UIImage *imageHead = [UIImage imageNamed:@"timezone_head_bg.png"];
    UIImageView *imageViewhead = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-imageHead.size.width)/2.0, 10, imageHead.size.width, imageHead.size.height)];
    imageViewhead.image = imageHead;
    [self.view addSubview:imageViewhead];
    [imageViewhead release];
    
    /**
     *  时间表
     */
    UIImage *timeimage = [UIImage imageNamed:@"timehead.png"];
    UIImageView *imageViewtime = [[UIImageView alloc] initWithFrame:CGRectMake(20, (imageHead.size.height- timeimage.size.height)/2.0, timeimage.size.width, timeimage.size.height)];
    imageViewtime.image = timeimage;
    [imageViewhead addSubview:imageViewtime];
    [imageViewtime release];
    
    /**
     *  当前时区
     */
    UILabel *lableCurrent = [[UILabel alloc] initWithFrame:CGRectMake(imageViewtime.frame.size.width+imageViewtime.frame.origin.x+10, imageViewtime.frame.origin.y, 180, imageViewtime.frame.size.height)];
    lableCurrent.textColor = [UIColor colorWithRed:58.0/255 green:58.0/255 blue:58.0/255 alpha:1];
    lableCurrent.text = LOCALANGER(@"homeCurrenttimeZone");
    lableCurrent.backgroundColor = [UIColor clearColor];
    [imageViewhead addSubview:lableCurrent];
    [lableCurrent release];
    
    
    _lbltimeZoon = [[UILabel alloc] initWithFrame:CGRectMake(imageViewhead.frame.size.width+imageViewhead.frame.origin.x -180, lableCurrent.frame.origin.y, 150, lableCurrent.frame.size.height)];
    _lbltimeZoon.backgroundColor = [UIColor clearColor];
    _lbltimeZoon.textColor = [UIColor colorWithRed:21.0/255 green:103.0/255 blue:215.0/255 alpha:1];
    _lbltimeZoon.textAlignment = UITextAlignmentRight;
    //_lbltimeZoon.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"HOME_TIMER_ZOON", nil),self.strCurrentTimer];
    [imageViewhead addSubview:_lbltimeZoon];
    
    _arrTimeZoneList = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i = 0; i<25; i++) {
        
        NSMutableDictionary *tdic = [[NSMutableDictionary alloc] init];
        
        int timeInfo = 12 -i;
        
        NSString *tStr = [NSString stringWithFormat:@"HomeTimeZone_%d",i+1];
        [tdic setObject:LOCALANGER(tStr) forKey:KTIMEZOME];
        
        [tdic setObject:[NSNumber numberWithInt:timeInfo] forKey:KTIMEINFO];
        
        [_arrTimeZoneList addObject:tdic];
        
        [tdic release];
    }
    
    UIImage *imgTablebg = [UIImage imageNamed:@"tableviewBg.png"];
    
    CGFloat heightTabar=0.0;

    
    _tableView =  [[UITableView alloc] initWithFrame:CGRectMake(imageViewhead.frame.origin.x, imageViewhead.frame.size.height+imageViewhead.frame.origin.y+10, imageViewhead.frame.size.width, self.view.frame.size.height  - 140+heightTabar) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundView = nil;
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:imgTablebg];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self updateLabelWithTimeZoon:self.strCurrentTimer.intValue];
}

-(void)addLeftButton{//添加返回按钮
    
    UIImage *image = [UIImage imageNamed:@"nav_back.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    backBarBtn.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=backBarBtn;
    [backBtn release];
    [backBarBtn release];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}
#pragma mark 返回上级视图
-(void)gotoBack{
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark tableview的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrTimeZoneList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    
    for (UIView *viewCell in cell.contentView.subviews) {
        
        [viewCell removeFromSuperview];
    }
    
    /**
     *  默认的时钟
     */
    UIImage *imagecellTime = [UIImage imageNamed:@"celltimeZonedefault.png"];
    UIImageView *imageCellhead = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, imagecellTime.size.width, imagecellTime.size.height)];
    imageCellhead.image = imagecellTime;
    [cell.contentView addSubview:imageCellhead];
    [imageCellhead release];
    
    NSDictionary *cellDic = [_arrTimeZoneList objectAtIndex:indexPath.row];
    UILabel *lblCellContent = [[UILabel alloc] initWithFrame:CGRectMake(imageCellhead.frame.origin.x+imageCellhead.frame.size.width+10, imageCellhead.frame.origin.y, 180, imageCellhead.frame.size.height)];
    lblCellContent.backgroundColor = [UIColor clearColor];
    lblCellContent.text =[cellDic objectForKey:KTIMEZOME];
    [cell.contentView addSubview:lblCellContent];
    [lblCellContent release];
    
    UIImage *imageDetail = [UIImage imageNamed:@"cellDetail.png"];
    UIImageView *imageViewDetail = [[UIImageView alloc] initWithFrame:CGRectMake(_tableView.frame.size.width-imageDetail.size.width-10, imageCellhead.frame.origin.y, imageDetail.size.width, imageDetail.size.height)];
    imageViewDetail.image = imageDetail;
    [cell.contentView addSubview:imageViewDetail];
    [imageViewDetail release];
    
    UIImage *imgCellSeperate = [UIImage imageNamed:@"celltimeSeperate.png"];
    UIImageView *imageViewCellSeperate = [[UIImageView alloc]initWithFrame:CGRectMake((_tableView.frame.size.width-imgCellSeperate.size.width)/2.0, cell.frame.size.height-imgCellSeperate.size.height , imgCellSeperate.size.width, imgCellSeperate.size.height)];
    imageViewCellSeperate.image = imgCellSeperate;
    [cell.contentView addSubview:imageViewCellSeperate];
    [imageViewCellSeperate release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *cellDic = [_arrTimeZoneList objectAtIndex:indexPath.row];
    NSLog(@"====%@==",cellDic);
    NSNumber *cellNum = [cellDic objectForKey:KTIMEINFO];
    
    //重复时区不让再重新选则
    if (cellNum.intValue == self.strCurrentTimer.intValue) {
        return;
    }
  
    
    if (TimeZoneDelegate !=nil && [TimeZoneDelegate respondsToSelector:@selector(setDeviceTimerZoneWithIndex:)]) {
        
        [TimeZoneDelegate setDeviceTimerZoneWithIndex:cellNum.intValue];
        
    }
    [self gotoBack];
   
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(interfaceOrientation== UIInterfaceOrientationPortrait)
    {
        return YES;
    }
    return NO;
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation

{
    
    return UIInterfaceOrientationPortrait;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
