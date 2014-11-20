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
#import "JVCRGBHelper.h"
#import "JVCSuggestAndFeedViewController.h"
#import "JVCMediaManagerViewController.h"
#import "JVCURlRequestHelper.h"

@interface JVCMoreViewController ()
{
    NSMutableArray *arrayList;
}

@end

@implementation JVCMoreViewController

static const int        CELLHEIGHT_CONTENTH         = 44;   //里面内容的cell高度
static const int        CELLHEIGHT_HEADSECTION      = 20;   //section的高度
static const int        KUserLoginOutState_Success  = 0;   //账号注册成功

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"jvc_more_title", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_more_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_more_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
        
        UIColor *tabarTitleColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroTabarItemTitleColor];
        
        if (tabarTitleColor) {
            
            [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabarTitleColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];//高亮状态。
        }
        
        if (IOS8) {
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_more_unselect.png"] selectedImage:[UIImage imageNamed:@"tab_more_select.png"]];
            self.tabBarItem.selectedImage = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem.image = [self.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }

        
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.tenCentKey = kTencentKey_more;
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
            
            JVCConfigModel *modelConfig = [JVCConfigModel shareInstance];
            if (cellModel.bBtnState == MoreSettingCellType_AccountSwith) {
                
                if (modelConfig._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT ) {
                    
                    cell.switchCell.on = modelConfig.bSwitchSafe;

                }else{
                    cell.switchCell.on = NO;

                }
            }
            
        }else{//按钮显示
            
            UIImage *iamgeBtn = [UIImage imageNamed:@"mor_logOut.png"];
            UIButton *btnLoginOut = [UIButton buttonWithType:UIButtonTypeCustom];
            btnLoginOut.frame =CGRectMake((self.view.width - iamgeBtn.size.width)/2.0, (cell.height- iamgeBtn.size.height)/2.0, iamgeBtn.size.width, iamgeBtn.size.height);
            [btnLoginOut addTarget:self action:@selector(showUserLoginOutAlert) forControlEvents:UIControlEventTouchUpInside];
            [btnLoginOut setTitle:LOCALANGER(@"jvc_more_LogOut") forState:UIControlStateNormal];
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
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_local_noSupport")];
                
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
            
        }else if (indexPath.row == 2) {//意见与反馈
            
            if ([JVCConfigModel shareInstance ]._netLinkType !=NETLINTYEPE_NONET) {
                //弹出发邮件的视图
              //  [self sendEmail];
                
                [self sendSuggestAndFeedBack];
                
            }else{
                [[JVCAlertHelper shareAlertHelper ]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"networkError", nil) ];
            }
        }
    }else if(indexPath.section == 4)//媒体
    {
        [self mediaManagerViewController];
    }
}

/**
 *  显示用户注销的的alert
 */
- (void)showUserLoginOutAlert
{
    
    [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:LOCALANGER(@"jvc_more_loginout") delegate:self selectAction:@selector(userLoginOut) cancelAction:nil selectTitle:LOCALANGER(@"jvc_more_loginout_ok") cancelTitle:LOCALANGER(@"jvc_more_loginout_quit")alertTage:0];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        if (buttonIndex == 0) {//确定
            
            [self userLoginOut];
            
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
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_loginout_error")];
                }
            });
        });
    }
}


#pragma mark  评论的事件
- (void)moreOperItunsComment
{
  
    if (IOS8) {
   
        UIAlertController *controlAlert = [UIAlertController alertControllerWithTitle:LOCALANGER(@"jvc_more_loginout_appStore") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [controlAlert addAction:[UIAlertAction actionWithTitle:LOCALANGER(@"jvc_more_loginout_quit") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        
        [controlAlert addAction:[UIAlertAction actionWithTitle:LOCALANGER(@"jvc_more_loginout_ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[JVCSystemUtility shareSystemUtilityInstance] openItunsCommet];

        }]];
        
        [self presentViewController:controlAlert animated:YES completion:nil];
        
    }else{
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:LOCALANGER(@"jvc_more_loginout_appStore") delegate:self cancelButtonTitle:LOCALANGER(@"jvc_more_loginout_quit") destructiveButtonTitle:LOCALANGER(@"jvc_more_loginout_ok") otherButtonTitles: nil];
        [sheet showInView:self.view.window];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet release];
    }

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
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_local_noSupport")];
            
            state.on = !state.on;
            return;
        }else{
            
            if (state.on) {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:(NSString *)kAPPWELCOMEAlarmState];
                [[JVCAccountHelper sharedJVCAccountHelper]  activeServerPushToken:kkToken];
            }else{
                
                [[JVCAccountHelper sharedJVCAccountHelper] CancelServerPushToken:kkToken];
                   [[NSUserDefaults standardUserDefaults] setObject:@"close" forKey:(NSString *)kAPPWELCOMEAlarmState];
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
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"networkError")];
        
    }else{
    
      JVCURlRequestHelper *moreCheckVersion =  [[[JVCURlRequestHelper alloc] init] autorelease];

        [moreCheckVersion requeAppVersion];
    
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

#pragma mark 意见与反馈
- (void)sendSuggestAndFeedBack
{
    JVCSuggestAndFeedViewController *suggestVC = [[JVCSuggestAndFeedViewController alloc] init];
    [self.navigationController pushViewController:suggestVC animated:YES];
    [suggestVC release];
}

- (void)mediaManagerViewController
{
    JVCMediaManagerViewController  *mediVC = [[JVCMediaManagerViewController alloc] init];
    [self.navigationController pushViewController:mediVC animated:YES];
    [mediVC release];
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
