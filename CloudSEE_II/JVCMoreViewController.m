//
//  JVCMoreViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreViewController.h"
#import "JVCMoreUserCell.h"
#import "JVCMoreSettingHelper.h"
#import "JVCMoreSettingModel.h"
//账号
#import "JVCAccountHelper.h"
//tableview的选中事件
#import "JVCApHelpViewController.h"
#import "JVCMoreUserSettingViewController.h"
//登录
#import "JVCLoginViewController.h"

#import "JVCDataBaseHelper.h"

#import "JVCMorEditPassWordViewController.h"
#import "AppDelegate.h"
#import "JVCKeepOnlineHelp.h"
#import "JVCSystemConfigMacro.h"
#import "JVCConfigModel.h"
#import "JSONKit.h"
@interface JVCMoreViewController ()
{
    NSMutableArray *arrayList;
}

@end

@implementation JVCMoreViewController

static const int        CELLHEIGHT_CONTENTH         = 44;   //里面内容的cell高度
static const int        CELLHEIGHT_HEADSECTION      = 20;   //section的高度
static const int        KUserLoginOutState_Success  = 0;   //账号注册成功
static const int        kAlertTag                   = 200;   //alert的tag
static const int        kAlertNEWVersionTag         = 3000;   //新版本的tag
static const NSString   *KNUm                       = @"Num";//检测更新的返回值
static const NSString   *KContentK                  = @"Content";//检测更新的返回值
static const NSString   *KCFBundleVersion           = @"CFBundleVersion";//版本号
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"更多", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_more_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_more_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化arrayList
    arrayList = [[NSMutableArray alloc] initWithCapacity:10];
    [arrayList addObjectsFromArray:[[JVCMoreSettingHelper shareDataBaseHelper]getMoreSettingList]];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark  tableview 的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return CELLHEIGHT_USERHEADER;
        
    }
    return CELLHEIGHT_CONTENTH;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0||section ==1) {
        
        return 0;
    }
    
    return CELLHEIGHT_HEADSECTION;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height = 0.0;
    if (section !=0||section !=1) {
        height =  CELLHEIGHT_HEADSECTION;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width,height)];
    view.backgroundColor = [UIColor clearColor];
    //横线
    UIImage *imgLine = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width- imgLine.size.width)/2.0, imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    lineImageView.image = imgLine;
    [view addSubview:lineImageView];
    [lineImageView release];
    
    return [view autorelease];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    }
    
    NSMutableArray *array = [arrayList objectAtIndex:section];
    
    return array.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {//用户信息
        
        static NSString *cellIndentify = @"cellUserIndentifiy";
        
        JVCMoreUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
        
        if (cell == nil) {
            
            cell = [[[JVCMoreUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell initMoreCellContentView];
        
        return cell;
        
    }else  {
        
        static NSString *cellIndentify = @"cellIndentifiy";
        
        JVCMoreContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
        
        if (cell == nil) {
            
            cell = [[[JVCMoreContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        for (UIView *viewContent in cell.contentView.subviews) {
            
            [viewContent removeFromSuperview];
        }
        
        NSMutableArray *arraySection = [arrayList objectAtIndex:indexPath.section];
        JVCMoreSettingModel *cellModel = [arraySection objectAtIndex:indexPath.row];
        cell.delegateSwitch = self;
        if (cellModel.bBtnState !=MoreSettingCellType_Btn ) {//正常显示
            
            [cell initContentCells:cellModel];
            
            
        }else{//按钮显示
            
            UIImage *iamgeBtn = [UIImage imageNamed:@"mor_logOut.png"];
            UIButton *btnLoginOut = [UIButton buttonWithType:UIButtonTypeCustom];
            btnLoginOut.frame =CGRectMake((self.view.width - iamgeBtn.size.width)/2.0, (cell.height- iamgeBtn.size.height)/2.0, iamgeBtn.size.width, iamgeBtn.size.height);
            [btnLoginOut addTarget:self action:@selector(showUserLoginOutAlert) forControlEvents:UIControlEventTouchUpInside];
            [btnLoginOut setTitle:@"注销" forState:UIControlStateNormal];
            [btnLoginOut setBackgroundImage:iamgeBtn forState:UIControlStateNormal];
            [cell.contentView addSubview:btnLoginOut];
            
            
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//账号信息
        
//        JVCMoreUserSettingViewController *moreUserSettingVC = [[JVCMoreUserSettingViewController alloc] init] ;
//        [self.navigationController pushViewController:moreUserSettingVC animated:YES];
//        [moreUserSettingVC release];
    }
    
    if (indexPath.section == 1 ) {//
        
       if(indexPath.row == 1)
        {
            if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地登录
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"本地模式暂停使用"];
                
            }else{
                JVCMorEditPassWordViewController *editVC = [[JVCMorEditPassWordViewController alloc] init];
                [self.navigationController pushViewController:editVC animated:YES];
                [editVC release];

            }
        }
    }else if(indexPath.section == 3)
    {
        if (indexPath.row == 0) {//打开评论
            
            [self moreOperItunsComment];
            
        }
    }else if(indexPath.section == 2)
    {
        if (indexPath.row == 0) {//检测更新
            
            [self checkNewVersion];
            
        }else if (indexPath.row == 3) {//意见与反馈
            
            if ([JVCConfigModel shareInstance ]._netLinkType !=NETLINTYEPE_NONET) {
                //弹出发邮件的视图
                [self sendEmail];
                
            }else{
                [[JVCAlertHelper shareAlertHelper ]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"networkError", nil) ];
            }
        }
    }
}

/**
 *  显示用户注销的的alert
 */
- (void)showUserLoginOutAlert
{
    UIAlertView *alertUser = [[UIAlertView alloc] initWithTitle:@"确定要注销吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertUser show];
    alertUser.tag = kAlertTag;
    alertUser.delegate = self;
    [alertUser release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertTag) {
        
        if (buttonIndex == 0) {//确定
            
            [self userLoginOut];
            
        }
    }else  if(alertView.tag == kAlertNEWVersionTag)
    {
        if (buttonIndex == 0) {//跟新
//            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
//            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
//            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
        
    }

}

/**
 *  账号注销
 */
- (void)userLoginOut
{
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地登录
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate presentLoginViewController];
        /**
         *  关闭设备列表界面timer
         */
        [delegate stopDeviceListTimer];
        
    }else{
        
        [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            int reuslt =  [[JVCAccountHelper sharedJVCAccountHelper] UserLogout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                DDLogVerbose(@"注销收到的返回值=%d",reuslt);
                
                
                if (KUserLoginOutState_Success == reuslt) {//成功,弹出注册界面
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate presentLoginViewController];
                    /**
                     *  关闭设备列表界面timer
                     */
                    [delegate stopDeviceListTimer];
                    
                    [[JVCAlertHelper shareAlertHelper]alertHidenToastOnWindow];
                    
                    //并且把秘密置换成功
                    [[JVCDataBaseHelper shareDataBaseHelper] updateUserAutoLoginStateWithUserName:kkUserName loginState:kLoginStateOFF];
                    
                }else{//失败
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"注销失败"];
                }
            });
        });
    }
}


#pragma mark  评论的事件
- (void)moreOperItunsComment
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定去APPStore评论吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    [sheet showInView:self.view.window];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//确定
        
        [[JVCSystemUtility shareSystemUtilityInstance] openItunsCommet];
        
    }
}

/**
 *  修改switch按钮的回调方法
 *
 *  @param state 开关状态
 */
- (void)modifySwitchState:(UISwitch *)state
{
    if (state.tag == MoreSettingCellType_AccountSwith) {
        
        if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL ) {
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"本地模式暂停使用"];
            
            state.on = !state.on;
            return;
        }else{
            
            if (!state.on) {
                
                [[JVCAccountHelper sharedJVCAccountHelper]  activeServerPushToken:kkToken];
            }else{
                
                [[JVCAccountHelper sharedJVCAccountHelper] CancelServerPushToken:kkToken];
                
            }
            [JVCConfigModel shareInstance].bSwitchSafe = state.on;

        }
    }else{//打开帮助
    
    
    }
    
    
    
    
    
}



#pragma mark 检测更新
- (void)checkNewVersion
{
    if ([JVCConfigModel shareInstance ]._netLinkType ==NETLINTYEPE_NONET) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"没有网路，请检测网路"];
        
    }else{
    
        [JVCURlRequestHelper shareJVCUrlRequestHelper].delegateUrl = self;

        [[JVCURlRequestHelper shareJVCUrlRequestHelper] requeAppVersion];
    }
}
/**
 *  请求成功的回调
 */
- (void)URlRequestSuccessCallBack:(NSMutableData *)receive
{
    if (receive.length<=0) {
        return;
    }
    NSArray *tReceiveArray = [receive objectFromJSONData];
    NSString *getVersionInteger =nil;
    
    //判断当前版本与获取到得版本得信息
   
    NSDictionary *versionDic=nil;
    for (int i=0; i<tReceiveArray.count; i++) {
        NSDictionary *tempDic = [tReceiveArray objectAtIndex:i];
        NSInteger  tStringVersionInt = [[tempDic objectForKey:KNUm] integerValue];
        if (tStringVersionInt == 1) {//内容
            versionDic = tempDic;
            continue;
        }else if(tStringVersionInt == 0)//版本号
        {
            getVersionInteger= [tempDic objectForKey:KContentK];
            
        }
    }
    
    NSArray *arrayRemote = [getVersionInteger componentsSeparatedByString:@"."];
    
    NSString *versionCurrent = [[[NSBundle mainBundle] infoDictionary] objectForKey:KCFBundleVersion];
    NSArray *arrayVersionCurrent = [versionCurrent componentsSeparatedByString:@"."];
    
    [JVCConfigModel shareInstance]._bNewVersion = NO;
    
    if (arrayRemote.count<3) {//有错
        
        [self alertVithVersionUpdate];
        
        return;
        
    }
    /**
     *  远端数据
     */
    NSString *remoteItem1 = [arrayRemote objectAtIndex:0];
    NSString *remoteItem2 = [arrayRemote objectAtIndex:1];
    NSString *remoteItem3 = [arrayRemote objectAtIndex:2];
    
    /**
     *  本地保存数据
     */
    NSString *VersionCurrentItem1 = [arrayVersionCurrent objectAtIndex:0];
    NSString *VersionCurrentItem2 = [arrayVersionCurrent objectAtIndex:1];
    NSString *VersionCurrentItem3 = [arrayVersionCurrent objectAtIndex:2];
    
    /**
     *  跟新消息
     */
    NSString *versionString = [versionDic objectForKey:KContentK];
    
    if (remoteItem1.intValue>VersionCurrentItem1.intValue) {
        
        [JVCConfigModel shareInstance]._bNewVersion = YES;
    }else{
        
        if (remoteItem2.intValue>VersionCurrentItem2.intValue) {
            
            [JVCConfigModel shareInstance]._bNewVersion = YES;
            
        }else{
            
            if (remoteItem3.intValue>VersionCurrentItem3.intValue) {
                
                [JVCConfigModel shareInstance]._bNewVersion = YES;
                
            }
        }
    }
    
    if ([JVCConfigModel shareInstance]._bNewVersion) {
        
        
        NSString *alertString = [versionString stringByReplacingOccurrencesOfString:@"&" withString:@"\n"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"UpdateBtn",nil ) otherButtonTitles:NSLocalizedString(@"local_location", nil), nil];
        alertView.tag = kAlertNEWVersionTag;
        [alertView show];
        [alertView release];
    }else{
        
        [self alertVithVersionUpdate];
    }

}

- (void)managerRequestListSuccess:(NSData *)tData
{
    
    
}

/**
 *  没有版本升级时的提示
 */
- (void)alertVithVersionUpdate
{
    [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"home_version_last_count3", nil) ];
}


#pragma mark 发送意见与反馈
- (void)sendEmail
{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        // NSLog(@"%@",[mailClass canSendMail]?@"1":@"2");
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self showSendEmailText];
            // [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self showSendEmailText];
        //[self launchMailAppOnDevice];
    }
}

- (void)showSendEmailText
{
    [[JVCAlertHelper shareAlertHelper] alertToastWithMessage:NSLocalizedString(@"emailHelp", nil) andTimer:5];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    
    [self  dismissModalViewControllerAnimated:YES];
    
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"version", nil),email];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]]; }



// 2. Displays an email composition interface inside the application. Populates all the Mail fields.

-(void)displayComposerSheet

{
    
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];/*MFMailComposeViewController邮件发送选择器*/
    
    mailPicker.mailComposeDelegate = self;
    mailPicker.title = NSLocalizedString(@"suggestAndFeedBack", nil);
    //设置主题
    [mailPicker setSubject: NSLocalizedString(@"suggestAndFeedBack", nil)];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"feedbackandsuggestion@gmail.com"];
    
    [mailPicker setToRecipients: toRecipients];
    
    NSString *string =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    
    NSString *emailBody = string ;//NSLocalizedString(@"suggestAndFeedBack", nil);
    
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController: mailPicker animated:YES];
    [mailPicker release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [arrayList release];
    arrayList = nil;
    
    [super dealloc];
}

@end
