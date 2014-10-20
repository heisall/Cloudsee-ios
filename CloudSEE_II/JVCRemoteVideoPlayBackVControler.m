//
//  JVCRemoteVideoPlayBackVControler.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCRemoteVideoPlayBackVControler.h"
#import "JVCPlaybackBean.h"

@interface JVCRemoteVideoPlayBackVControler ()
{
    UITableView *_tableview;
    
    NSString *strCurrentTimer;
    
    /**
     *  显示当前时间的lable
     */
    UILabel *selectTimeLabel;
    
    /**
     *  记录当前选中的哪天，防止频繁点击刷新
     */
    NSString *strDateSelect;
}


@end

@implementation JVCRemoteVideoPlayBackVControler

@synthesize  arrayDateList;
@synthesize remoteDelegat;
@synthesize iSelectRow;

static  JVCRemoteVideoPlayBackVControler*shareInstance = nil;

static  NSString *KDateFormatFlag = @"yyyy-MM-dd";


+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            shareInstance = [super allocWithZone:zone];
            
            return shareInstance;
            
        }
    }
    return nil;
}

/**
 *  单例
 */
+ (JVCRemoteVideoPlayBackVControler *)shareInstance
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            
            shareInstance = [[self alloc] init];
            
            NSMutableArray *_nultArray=[[NSMutableArray alloc] initWithCapacity:10];
            shareInstance.arrayDateList=_nultArray;
            [_nultArray release];
            
        }
        
        return shareInstance;
        
    }
    return shareInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *_nultArray=[[NSMutableArray alloc] initWithCapacity:10];
        shareInstance.arrayDateList=_nultArray;
        [_nultArray release];
        
    }
    return self;
}

- (void)dealloc
{
    [selectTimeLabel release];
    
    [_tableview release];
    
    //    if (strDateSelect) {
    //
    //        [strDateSelect release];
    //
    //    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    strDateSelect = [[NSString alloc] init];
    
    self.iSelectRow = -1;
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    //        NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;

    formatter.dateFormat = @"YYYY-MM-dd";
    formatter.locale     = [NSLocale currentLocale];
    NSDate *_date=[formatter dateFromString:@"2014-10-26"];

    [formatter release];
    
    DDLogError(@"%s-----date01=%@",__FUNCTION__,_date);

    
    /**
     *  标题
     */
    self.title = NSLocalizedString(@"Play back", nil);
    
    /**
     *  目前测试的时间
     */
    UIImage *imageBtnBg = [UIImage imageNamed:@"rem_bg.png"];
    UIButton *btnImgClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnImgClick setBackgroundImage:imageBtnBg forState:UIControlStateNormal];
    [btnImgClick addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    btnImgClick.frame = CGRectMake(20, 15, 210, 40);
    [self.view addSubview:btnImgClick];
    
    //日期时间label
    UILabel *timeSelectLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, 180, 30)];
    [timeSelectLable setTextColor:SETLABLERGBCOLOUR(RGB_YUANCHENG_LABLE_R, RGB_YUANCHENG_LABLE_G, RGB_YUANCHENG_LABLE_B)];
    [timeSelectLable setBackgroundColor:[UIColor clearColor]];
    timeSelectLable.textAlignment = UITextAlignmentCenter;
    selectTimeLabel = timeSelectLable;
    [self.view addSubview:timeSelectLable];
    selectTimeLabel.text = [self getCurrentDate];
    
    //搜索按钮
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 19, 70, 30)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"rem_ser.png"] ]
                         forState:UIControlStateNormal];
    [searchBtn setTitleColor:SETLABLERGBCOLOUR(RGB_YUANCHENG_BTN_R, RGB_YUANCHENG_BTN_G, RGB_YUANCHENG_BTN_B) forState:UIControlStateNormal];
    [searchBtn setTitle:NSLocalizedString(@"Serach",nil) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(btnSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [searchBtn release];
    
    /**
     *  uitableview
     */
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(20, 64, 283, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 60) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundView = nil;
    UIImageView *tbBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remote_playback_bg.png"]];
    [_tableview setBackgroundView:tbBg];
    [self.view addSubview:_tableview];
}

#pragma mark 返回上级视图
-(void)BackClick{
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  传进一个日期数据获取格式化的数据
 */
- (NSString *)getFormateDate:(NSString *)strUnFormal
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    
    formatter.dateFormat = KDateFormatFlag;
    
    NSDate *_date=[formatter dateFromString:strUnFormal];
    
    NSString *dateString = [formatter stringFromDate:_date];
    
    [formatter release];
    
    return dateString;
    
}

/**
 *  传进一个字符类型的时间，转换为nadate类型的数据
 *
 *  @param dateString 字符串类型数据
 *
 *  @return nsdate类型数据
 */
- (NSDate *)getFormateDateWtihString:(NSString *)dateString
{
    //DDLogError(@"dateString=%@",dateString);
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:KDateFormatFlag];
    /**
     *  解决时差相差8个小时的问题
     */
    NSTimeZone *localZone =[NSTimeZone systemTimeZone];
    NSDate  *timestamp = [formatter dateFromString:dateString];
    NSUInteger interval =[localZone secondsFromGMTForDate:timestamp];
    NSDate *date  = [timestamp dateByAddingTimeInterval:interval];
    [formatter release];
    
    return date;
}

/**
 *  获取当前时间
 *
 *  @return 当前时间的字符串
 */
- (NSString *)getCurrentDate
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    
    formatter.dateFormat = KDateFormatFlag;
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    return timestamp;
}

#pragma mark 对外开放的接口  start


#pragma mark  tableview刷新
/**
 *  tableview刷新
 */
- (void)tableViewReloadDate
{
    [_tableview reloadData];
}


#pragma mark 对外开放的接口  end


#pragma mark tableview 的Delegate 方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetify = @"CellIndentify";
    
    JVCPlaybackBean *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetify];
    
    if (!cell) {
        
        cell = [[[JVCPlaybackBean alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetify] autorelease];
    }
    
    [cell initCellContentViews];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSMutableDictionary * dic = [self.arrayDateList objectAtIndex:indexPath.row];
    
    cell.timeLabel.text = [dic valueForKey:@"time"];
    
    cell.sizeLabel.text = [dic valueForKey:@"disk"];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
//    self.iSelectRow = indexPath.row;
//    
//    NSMutableDictionary *dicInfo = [self.arrayDateList objectAtIndex:indexPath.row];
//    
//    if (self.remoteDelegat != nil && [self.remoteDelegat respondsToSelector:@selector(remotePlaybackVideoCallbackWithrequestPlayBackFileInfo:requestPlayBackFileDate:requestPlayBackFileIndex:)]) {
//        
//        [self.remoteDelegat remotePlaybackVideoCallbackWithrequestPlayBackFileInfo:dicInfo
//                                                           requestPlayBackFileDate:[self getFormateDateWtihString:selectTimeLabel.text] requestPlayBackFileIndex:indexPath.row];
//    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.iSelectRow != -1) {//之前选中的，要给置换回来
        
        JVCPlaybackBean *cell = (JVCPlaybackBean *)[_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.iSelectRow inSection:0]];
        
        cell.timeLabel.textColor =SETLABLERGBCOLOUR(RGB_YUANCHENG_LABLE_R, RGB_YUANCHENG_LABLE_G, RGB_YUANCHENG_LABLE_B);//设置v_headerLab的字体颜色
        cell.sizeLabel.textColor = SETLABLERGBCOLOUR(RGB_YUANCHENG_LABLE_R, RGB_YUANCHENG_LABLE_G, RGB_YUANCHENG_LABLE_B);//设置v_headerLab的字体颜色
    }else{//置换颜色
        
        JVCPlaybackBean *cell = (JVCPlaybackBean *)[_tableview cellForRowAtIndexPath:indexPath];
        cell.timeLabel.textColor= SETLABLERGBCOLOUR(31.0, 111.0,232.0);
        cell.sizeLabel.textColor= SETLABLERGBCOLOUR(31.0, 111.0,232.0);
    }
    
    self.iSelectRow = indexPath.row;
    
    NSMutableDictionary *dicInfo = [self.arrayDateList objectAtIndex:indexPath.row];
    
    if (self.remoteDelegat != nil && [self.remoteDelegat respondsToSelector:@selector(remotePlaybackVideoCallbackWithrequestPlayBackFileInfo:requestPlayBackFileDate:requestPlayBackFileIndex:)]) {
        
        
        [self.remoteDelegat remotePlaybackVideoCallbackWithrequestPlayBackFileInfo:dicInfo
                                                           requestPlayBackFileDate:[self getFormateDateWtihString:selectTimeLabel.text] requestPlayBackFileIndex:indexPath.row];
    }
    

    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v_headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30.0)] autorelease];//创建一个视图（v_headerView）
    UILabel *v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5.0, 100, 19)];//创建一个UILable（v_headerLab）用来显示标题
    v_headerLab.backgroundColor = [UIColor clearColor];//设置v_headerLab的背景颜色
    v_headerLab.textColor = SETLABLERGBCOLOUR(RGB_YUANCHENG_COLOUM_R, RGB_YUANCHENG_COLOUM_G,RGB_YUANCHENG_COLOUM_B);//设置v_headerLab的字体颜色
    v_headerLab.font = [UIFont systemFontOfSize:16];//设置v_headerLab的字体样式和大小
    v_headerLab.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
    [v_headerLab setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
    //设置每组的的标题
    if (section == 0) {
        v_headerLab.text =NSLocalizedString(@"starttime", nil);
    }
    UIImage *boderImage=[UIImage imageNamed:@"split_line.png"];
    UIImageView *boderLine=[[UIImageView alloc] initWithImage:boderImage];
    boderLine.frame=CGRectMake(0.0, v_headerView.frame.size.height- boderImage.size.height, v_headerView.frame.size.width,  boderImage.size.height);
    [v_headerView addSubview:boderLine];
    [boderLine release];
    
    [v_headerView addSubview:v_headerLab];//将标题v_headerLab添加到创建的视图（v_headerView）中
    [v_headerLab release];//释放v_headerLab所占用的资源
    
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 5.0, 100, 19)];//创建一个UILable（v_headerLab）用来显示标题
    sizeLabel.backgroundColor = [UIColor clearColor];//设置v_headerLab的背景颜色
    sizeLabel.textColor = SETLABLERGBCOLOUR(RGB_YUANCHENG_COLOUM_R, RGB_YUANCHENG_COLOUM_G,RGB_YUANCHENG_COLOUM_B);//设置v_headerLab的字体颜色
    sizeLabel.font = [UIFont systemFontOfSize:16];//设置v_headerLab的字体样式和大小
    sizeLabel.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
    [sizeLabel setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
    //设置每组的的标题
    if (section == 0) {
        sizeLabel.text = NSLocalizedString(@"disk", nil);
    }
    
    [v_headerView addSubview:sizeLabel];
    [sizeLabel release];
    return v_headerView;//将视图（v_headerView）返回
}


#pragma mark  UIActionSheet 的delegate以及方法
-(void) showDatePicker{
    
    
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:NSLocalizedString(@"Sure",nil) otherButtonTitles:nil] autorelease];
    
    actionSheet.userInteractionEnabled = YES;
    UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"NSLocalString", nil)] autorelease]];
    datePicker.tag = 101;
    datePicker.locale  = [NSLocale currentLocale];
    datePicker.calendar = [NSCalendar currentCalendar];
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:self.view];
    // [actionSheet release];
    //NSLog(@"this is pic click");
    
    
}

//日期选择回调
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
	
	switch (buttonIndex) {
		case 0:
		{
            UIDatePicker *datePicker0= (UIDatePicker *)[actionSheet viewWithTag:101];
            NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone systemTimeZone];
            formatter.dateFormat = KDateFormatFlag;
            
            NSString *timestamp = [formatter stringFromDate:datePicker0.date];
            selectTimeLabel.text = timestamp;
            [formatter release];
            
            //[self btnSearchAction];
		}
			break;
            
		default:
			break;
	}
	//[actionSheet release];
    
}

-(void) btnSearchAction{
    
    BOOL statePost  = (strDateSelect.length == 0 ||![strDateSelect  isEqualToString:selectTimeLabel.text])?YES:NO ;
    
    if (self.remoteDelegat != nil && [self.remoteDelegat respondsToSelector:@selector(remoteGetPlayBackDateWithSelectDate:)]  && statePost) {
        
        [self.remoteDelegat remoteGetPlayBackDateWithSelectDate:[self getFormateDateWtihString:selectTimeLabel.text]];
        /**
         *  选中了不同的天，置换为默认值
         */
        self.iSelectRow = -1;
        
        /**
         *  把选中的时间
         */
        if (strDateSelect ) {
            
            [strDateSelect release];
            
        }
        strDateSelect = [selectTimeLabel.text retain];
        
    }
    
    if (self.remoteDelegat !=nil && [self.remoteDelegat respondsToSelector:@selector(remoteGetPlayBackDateWithSelectDate:)]) {
        
        [self.remoteDelegat remoteGetPlayBackDateWithSelectDate:[self getFormateDateWtihString:selectTimeLabel.text]];
        
    }
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
@end
