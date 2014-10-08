//
//  JVCRemoteVideoPlayBackVControler.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCRemoteVideoPlayBackVControler.h"

@interface JVCRemoteVideoPlayBackVControler ()

@end

@implementation JVCRemoteVideoPlayBackVControler

@synthesize myTable;
@synthesize _btnSearch;
@synthesize selectTimeLabel,nultArray,_operationController,_is_iSelectedRow,_dateString;
@synthesize _isSendState;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Play back", nil)];
        NSMutableArray *_nultArray=[[NSMutableArray alloc] initWithCapacity:10];
        self.nultArray=_nultArray;
        [_nultArray release];
        
        self._is_iSelectedRow=-1;
        NSMutableString *_muString=[[NSMutableString alloc] initWithCapacity:10];
        self._dateString=_muString;
        [_muString release];
        self._isSendState=NO;
    }
    
    return self;
}


-(void)addLeftButton{//添加返回按钮
    
    UIImage *image = [UIImage imageNamed:@"down_arrow.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    backBarBtn.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=backBarBtn;
    [backBtn release];
    [backBarBtn release];
}

//返回按钮方法
-(void) backToMain{
    _operationController._isPlayBack=FALSE;
    [self gotoBack];
}


-(void) btnSearchAction{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *_date=[formatter dateFromString:self.selectTimeLabel.text];
    [formatter release];
    if (![self._dateString isEqualToString:self.selectTimeLabel.text]&&!self._isSendState) {
        self._is_iSelectedRow=-1;
        [nultArray removeAllObjects];
        [self.myTable reloadData];
        self._isSendState=YES;
        [self._dateString deleteCharactersInRange:NSMakeRange(0, [self._dateString length])];
        [_operationController._playBackDateString deleteCharactersInRange:NSMakeRange(0, [_operationController._playBackDateString length])];
        
        [self._dateString appendString:self.selectTimeLabel.text];
        [_operationController._playBackDateString appendString:self.selectTimeLabel.text];
        [_operationController playBackSendPlayVideoData:_date];
        
        
    }
    
}


-(void) showDatePicker{
    
    if (isFirstAddSheet) {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:NSLocalizedString(@"Sure",nil) otherButtonTitles:nil] autorelease];
        
        actionSheet.userInteractionEnabled = YES;
        UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"NSLocalString", nil)] autorelease]];
        datePicker.tag = 101;
        [actionSheet addSubview:datePicker];
        [actionSheet showInView:self.view];
        // [actionSheet release];
        isFirstAddSheet = FALSE	 ;
		//NSLog(@"this is pic click");
	}
    
}

//日期选择回调
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
	isFirstAddSheet = TRUE ;
	
	switch (buttonIndex) {
		case 0:
		{
            UIDatePicker *datePicker0= (UIDatePicker *)[actionSheet viewWithTag:101];
            NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
            
            
            
            
            formatter.dateFormat = @"yyyy-MM-dd";
            
            NSString *timestamp = [formatter stringFromDate:datePicker0.date];
            self.selectTimeLabel.text = timestamp;
            [formatter release];
		}
			break;
		case 1:
		{
			
		}
			break;
		case 2:
            
			break;
            
		default:
			break;
	}
	//[actionSheet release];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self addLeftButton];
    isFirstAddSheet = TRUE;
//    self.view.backgroundColor = SETLABLERGBCOLOUR(240.0, 240.0, 240.0);
    self.myTable.backgroundView = nil;
    self.myTable.backgroundColor = [UIColor clearColor];
    //表格背景图
    //    UIImageView *tbBg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remote_playback_bg.png"]] autorelease];
    //    [self.myTable setBackgroundView:tbBg];
    //下拉框view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 15, 210, 40)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
	[view addGestureRecognizer:singleTap];
    [singleTap release];
    //[view setBackgroundColor:[UIColor redColor]];
    //下拉框背景图
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downlist_bg.png"]];
    [view addSubview:bgView];
    //日期时间label
    UILabel *timeSelectLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 30)];
//    [timeSelectLable setTextColor:SETLABLERGBCOLOUR(RGB_YUANCHENG_LABLE_R, RGB_YUANCHENG_LABLE_G, RGB_YUANCHENG_LABLE_B)];
    [timeSelectLable setBackgroundColor:[UIColor clearColor]];
    timeSelectLable.textAlignment = UITextAlignmentLeft;
    if ([self._dateString length]>0) {
        [timeSelectLable setText:self._dateString];
    }else{
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        
        
        
        
        formatter.dateFormat = @"YYYY-MM-dd";
        
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        [timeSelectLable setText:timestamp];
        
    }
    
    self.selectTimeLabel = timeSelectLable;
    [view addSubview:timeSelectLable];
    //搜索按钮
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 17, 70, 30)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"btn_remote_search_0.png" ]
                         forState:UIControlStateNormal];
    [searchBtn setTitleColor:SETLABLERGBCOLOUR(RGB_YUANCHENG_BTN_R, RGB_YUANCHENG_BTN_G, RGB_YUANCHENG_BTN_B) forState:UIControlStateNormal];
    [searchBtn setTitle:NSLocalizedString(@"Serach",nil) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(btnSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    
    [self.view addSubview:view];
    [view release];
    [bgView release];
    [timeSelectLable release];
    [searchBtn release];
    //[self initData];
    
    CGFloat heightTabar=0.0;
    if (IOS_VERSION<IOS7) {
        heightTabar = self.navigationController.navigationBar.frame.size.height;
    }
    
    if (!iphone5) {
        heightTabar+=64;
    }
    UITableView *_tableview = [[UITableView alloc] initWithFrame:CGRectMake(20, 64, 283, self.view.frame.size.height-64-heightTabar) style:UITableViewStylePlain];
    
    _tableview.delegate = self;
    _tableview.dataSource =self;
    self.myTable = _tableview;
    [self.view addSubview:_tableview];
    [_tableview release];
    
    //表格背景图
    UIImageView *tbBg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remote_playback_bg.png"]] autorelease];
    [self.myTable setBackgroundView:tbBg];
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc{
    [_dateString release];
    _dateString=nil;
    [myTable release];
    myTable=nil;
    [nultArray release];
    [_btnSearch release];
    _btnSearch=nil;
    [selectTimeLabel release];
    selectTimeLabel=nil;
    [super dealloc];
}



//定制表格
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
	
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [nultArray count] ;//[levelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	static NSString *str = @"Cell";
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:str];
	if (cell == nil) {
		//NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"playbackBean" owner:self options:nil];
		//cell = [arr objectAtIndex:0];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
	}
	
	NSMutableDictionary * dic = [nultArray objectAtIndex:indexPath.row];
    
//    cell.timeLabel.text = [dic valueForKey:@"date"];
//    
//    cell.timeLabel.textColor =SETLABLERGBCOLOUR(RGB_YUANCHENG_LABLE_R, RGB_YUANCHENG_LABLE_G, RGB_YUANCHENG_LABLE_B);//设置v_headerLab的字体颜色
//    cell.timeLabel.font = [UIFont systemFontOfSize:16];//设置v_headerLab的字体样式和大小
//    
//    cell.sizeLabel.text = [dic valueForKey:@"disk"];
//    cell.sizeLabel.textColor = SETLABLERGBCOLOUR(RGB_YUANCHENG_LABLE_R, RGB_YUANCHENG_LABLE_G, RGB_YUANCHENG_LABLE_B);//设置v_headerLab的字体颜色
//    cell.sizeLabel.font = [UIFont systemFontOfSize:16];//设置v_headerLab的字体样式和大小
//    
//    if (self._is_iSelectedRow==indexPath.row) {
//        cell.timeLabel.textColor= SETLABLERGBCOLOUR(31.0, 111.0,232.0);
//        cell.sizeLabel.textColor= SETLABLERGBCOLOUR(31.0, 111.0,232.0);
//    }
    cell.textLabel.text =[dic valueForKey:@"date"];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *_date=[formatter dateFromString:self.selectTimeLabel.text];
    [formatter release];
    _operationController._isPlayBack=FALSE;
    
    if (self._is_iSelectedRow!=indexPath.row) {
        [_operationController playBackDisplay:[indexPath row] playBackDate:_date];
    }
    
    [self gotoBack];
    
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;
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
