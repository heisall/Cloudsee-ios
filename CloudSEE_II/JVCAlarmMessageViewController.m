//
//  JVCAlarmMessageViewController.m
//  JVCEditDevice
//  报警
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAlarmMessageViewController.h"
#import "JVCAlarmCell.h"
#import "JVCAlarmModel.h"
#import "JVCDeviceHelper.h"
#import "JVCDeviceMacro.h"
#import "JVCAlarmMacro.h"
#import "JVCSignleAlarmDisplayView.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCAlarmVideoPlayViewController.h"
#import "JVNetConst.h"
#import "JVCAlarmHelper.h"

#import "MJRefreshFooterView.h"
#import "UIScrollView+MJRefresh.h"

#import "JVCConfigModel.h"
#import "JVCAlarmCurrentView.h"
#import "JVCRGBHelper.h"
#import "JVCOperationController.h"
#import "JVCOperationControllerIphone5.h"

enum {
    DownLoadType_PIC    = 0,//图片的
    DownLoadType_VIDEO  = 1,//视频的
    
};


@interface JVCAlarmMessageViewController ()
{

    
    int iDownLoadType;//正在下载标识
    
    int nChannelLinkNum;//连接通道的标识
    
    int nAlarmOriginIndex ;//获取alarm起始的索引
    
    int nDeleteRow;//删除的主控的index
    
}

@end

@implementation JVCAlarmMessageViewController
static const int KSUCCESS = 0;//成功
static const NSTimeInterval KTimerAfterDelay = 0.5;
static const int KChannelNum = 1;//通道连接
static const int KNoAlarmTag = 10003;//没有报警的view的tag
static const int KNoAlarmLabelHeight = 50;//没有报警的view的tag
static const int KNoAlarmSpan    = 15;//没有报警的label距离imageview的距离
static const int KJVCSignleAlarmDisplayView     = 138354;
@synthesize arrayAlarmList;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"jvc_alarmList_Title", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_message_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_message_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
        
        UIColor *tabarTitleColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroTabarItemTitleColor];
        
        if (tabarTitleColor) {
            
            [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabarTitleColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];//高亮状态。
        }
        
        if (IOS8) {
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_message_unselect.png"] selectedImage:[UIImage imageNamed:@"tab_message_select.png"]];
            self.tabBarItem.selectedImage = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem.image = [self.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    self.tenCentKey = kTencentKey_alarmList;
    [super viewDidLoad];
    
    arrayAlarmList  = [[NSMutableArray alloc] init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT)
    {
        [self addTableViewHeadView];
        
        [self addTableViewFootView];

        
        [self.tableView headerBeginRefreshing];
    }else{
        
        [self addNoAlarmDateView];
    }
    
    [self addNavicationRightBarButton];
    
}

- (void)addNavicationRightBarButton
{
    NSString *path= nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"arm_clear" ofType:@"png"];
    
    if (path == nil) {
        
        path = [[NSBundle mainBundle] pathForResource:@"arm_clear@2x" ofType:@"png"];
        
    }
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(showAlertWithClearAllAlarm) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    [image release];

}

#pragma mark  显示弹出清空所有报警信息的列表

- (void)showAlertWithClearAllAlarm
{
    if (arrayAlarmList.count == 0) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_noAlarm")];
        
    }else{


        
        [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:LOCALANGER(@"jvcAlarm_cleanAlll")  delegate:self selectAction:@selector(clearALlAlarm) cancelAction:nil  selectTitle:LOCALANGER(@"jvc_more_loginout_ok" )  cancelTitle:LOCALANGER(@"jvc_more_loginout_quit")];
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self clearALlAlarm];
    }
}

- (void)clearALlAlarm
{
    if (arrayAlarmList.count == 0) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_noAlarm")];
        
    }else{
        
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL result = [[JVCAlarmHelper shareAlarmHelper] deleteAkkAlarmHistory];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                
                if (result) {
                    
                    [arrayAlarmList removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    [self addNoAlarmDateView];
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_delete_success")];
                    
                    nAlarmOriginIndex =0;
                    
                }else{
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_delete_failt")];
                }
                
            });
        });
    }
}

- (void)initLayoutWithViewWillAppear
{
    [super initLayoutWithViewWillAppear];
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL)
    {
        [self.tableView removeHeader];
        [self.tableView removeFooter];
        
        [self addNoAlarmDateView];

    }else{
        if (arrayAlarmList.count>0) {
            
            [self removeNoAlarmView];

        }
        [self addTableViewHeadView];
        [self addTableViewFootView];
    }
}

/**
 *  集成刷新控件
 */
- (void)addTableViewHeadView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshingDataAlarmDate)];
    //自动下拉刷新
    //[_tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = LOCALANGER(@"jvc_PullToRefreshText");
    self.tableView.headerReleaseToRefreshText = LOCALANGER(@"jvc_PullReleaseToRefreshText");
    self.tableView.headerRefreshingText = LOCALANGER(@"jvc_PullRefreshingText");
}


- (void)addTableViewFootView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    //自动下拉刷新
    //[_tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.footerPullToRefreshText = LOCALANGER(@"jvc_PullfooterToRefreshText");
    self.tableView.headerReleaseToRefreshText = LOCALANGER(@"jvc_PullfooterReleaseToRefreshText");
    self.tableView.headerRefreshingText = LOCALANGER(@"jvc_PullfooterRefreshingText");
    

}


- (void)footerRereshing
{
    [self getAlarmListDate];
}
/**
 *  下拉刷新事件
 */
- (void)headerRereshingDataAlarmDate
{
    //下拉
    nAlarmOriginIndex = 0;

    [self getAlarmListDate];
}

- (void)getAlarmListDate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *array = [[JVCAlarmHelper shareAlarmHelper] getHistoryAlarm:nAlarmOriginIndex];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (array !=nil) {
                if (array.count !=0) {
                    
                    if (nAlarmOriginIndex == 0) {
                        
                        [arrayAlarmList removeAllObjects];
                        
                        [self removeNoAlarmView];
                    }
                    [arrayAlarmList addObjectsFromArray:array];
                    
                    [self.tableView reloadData];
                    
                    [self.tableView footerEndRefreshing];
                    [self.tableView headerEndRefreshing];
                    
                    nAlarmOriginIndex = nAlarmOriginIndex+arrayAlarmList.count;
                    
                }else{
                    
                    if (nAlarmOriginIndex == 0) {//显示没有数据的view
                        
                        [self  addNoAlarmDateView];
                        
                    }else{
                        
                        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_noMore")];
                        
                    }
                    
                    [self.tableView footerEndRefreshing];
                    [self.tableView headerEndRefreshing];
                }
            }else{
            
                if (nAlarmOriginIndex == 0 ||arrayAlarmList.count == 0) {//显示没有数据的view
                    
                    [self  addNoAlarmDateView];
                    
                }
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_getAlarmError")];

            }
        
            
        });
    });

}

/**
 *  添加没有数据的图片
 */
- (void)addNoAlarmDateView
{
    
    if (arrayAlarmList.count>0) {
        return;
    }
    UIView *viewNoAlarm = (UIView *)[self.view viewWithTag:KNoAlarmTag];
    if (!viewNoAlarm) {
        
        viewNoAlarm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        
        NSString    *pathNoAlarm    = [UIImage imageBundlePath:@"arm_no.png"];
        UIImage     *imageNo        = [[UIImage alloc] initWithContentsOfFile:pathNoAlarm];
        
        UIImageView *imageView      = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width -imageNo.size.width)/2.0 ,(self.view.height -imageNo.size.height)/2.0-50, imageNo.size.width, imageNo.size.height)];
        imageView.image             = imageNo;
        [viewNoAlarm addSubview:imageView];
        [imageView release];
        
        viewNoAlarm.tag               = KNoAlarmTag;
        
        UILabel *labelNoAlarm        = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+KNoAlarmSpan, self.view.width, KNoAlarmLabelHeight)];
        UIColor *color = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KLickTypeLeftLabelColor];
        if (color) {
            labelNoAlarm.textColor = color;
        }
        labelNoAlarm.backgroundColor = [UIColor clearColor];
        labelNoAlarm.textAlignment   = UITextAlignmentCenter;
        labelNoAlarm.text            = LOCALANGER(@"jvc_alarmlist_noAlarm");
        [viewNoAlarm addSubview:labelNoAlarm];
        [labelNoAlarm release];
        
        [self.tableView addSubview:viewNoAlarm];
        [viewNoAlarm release];
        [imageNo release];
        


    }else{
        
        [self.tableView bringSubviewToFront:viewNoAlarm];
    }
    
}

/**
 *  从父视图删除
 */
-(void)removeNoAlarmView
{
    UIView *viewNoAlarm = (UIView *)[self.tableView viewWithTag:KNoAlarmTag];
    [viewNoAlarm removeFromSuperview];
}

#pragma mark tableview的
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  arrayAlarmList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *imageCellBg = [UIImage imageNamed:@"arm_cellbg.png"];
    
    return imageCellBg.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentify";
    JVCAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell ==nil) {
        
        cell = [[[JVCAlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JVCAlarmModel *modelcell = [arrayAlarmList objectAtIndex:indexPath.section];
    [cell initAlermCell:modelcell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVCAlarmCell *homecell = (JVCAlarmCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageViewNew = (UIImageView *)[homecell.contentView viewWithTag:10005];
    [imageViewNew removeFromSuperview];
    
    //点击cell，连接远程回放，判断是否连接上
    
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:indexPath.section];
    
    cellModel.bNewAlarm = NO;
    
    nDeleteRow = indexPath.section;

    if (cellModel.strAlarmLocalPicURL.length !=0) {
        
        [self showJVHAlarmVideoWithModel:cellModel];
        
    }else{
        
        if (cellModel.strAlarmPicUrl.length<=0) {
            [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_noAlarm_PIC")];
            return;
        }
        [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
        
        iDownLoadType = DownLoadType_PIC;

        [self connetDeviceWithYSTNum];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:section];

    UIView *headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)] autorelease];
    UILabel *labelTimer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headView.frame.size.height)];
    labelTimer.backgroundColor = [UIColor clearColor];
    labelTimer.textAlignment = UITextAlignmentCenter;
    labelTimer.text = [NSString stringWithFormat:@"%@",cellModel.strAlarmTime];
    labelTimer.textColor =  SETLABLERGBCOLOUR(61.0, 115.0, 175.0);
    [labelTimer setFont:[UIFont systemFontOfSize:14]];
    [headView addSubview:labelTimer];
    [labelTimer release];
    return headView;
    
}

/**
 *  去除黏性
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVCAlarmModel *model = [arrayAlarmList objectAtIndex:indexPath.section];
    
    [self deleteSingelAlarm:model.strAlarmGuid];
    
    nDeleteRow = indexPath.section;
    
}

- (void)deleteSingelAlarm:(NSString *)deviceGuid
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        BOOL result = [[JVCAlarmHelper shareAlarmHelper] deleteAlarmHistoryWithGuid:deviceGuid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            if (result) {
                
                [arrayAlarmList removeObjectAtIndex:nDeleteRow];

//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

                [self.tableView reloadData];
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_delete_success")];
                
                nAlarmOriginIndex -- ;
                
                if (nAlarmOriginIndex <=0) {
                    nAlarmOriginIndex = 0;
                    [self.tableView headerBeginRefreshing];
                }

            }else{
            
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_alarmlist_delete_failt")];
            }
            
        });
    });
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)dealloc
{
    [arrayAlarmList release];
    
    [super dealloc];
}


- (void)showJVHAlarmVideoWithModel:(JVCAlarmModel *)model
{
    [model retain];
    
    JVCSignleAlarmDisplayView *alarmView = [[JVCSignleAlarmDisplayView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    alarmView.tag = KJVCSignleAlarmDisplayView;
    alarmView.tAlarmModel = model;
    alarmView.palyVideoDelegate = self;
    [alarmView initView];
    
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration = 1;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:forwardAnimation, nil];
    animationGroup.delegate = self;
    animationGroup.duration = forwardAnimation.duration + 1;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    static NSString * const kAddAnimation = @"kAddAnimation";
    
    [self.view.window addSubview:alarmView];
    [alarmView.layer addAnimation:animationGroup forKey:kAddAnimation];
        
    [alarmView release];
    
    [model release];
    
}


-(void)removeJVHAlarmShowView
{
    JVCSignleAlarmDisplayView *viewContent = (JVCSignleAlarmDisplayView *)[self.view.window viewWithTag:KJVCSignleAlarmDisplayView];
    if (viewContent) {
        [viewContent removeFromSuperview];
    }
    
    JVCCloudSEENetworkHelper *cloudSEEObj =  [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    cloudSEEObj.ystNWRPVDelegate          =  nil;
}


/**
 *  down远程回放的图片
 */
- (void)downRemotePlayBackPic:(int)nlocalChannel
{
    iDownLoadType = DownLoadType_PIC;
    
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:nDeleteRow];
    
    DDLogCVerbose(@"%s----downlocad==cellModel.strAlarmPicUrl =%@",__FUNCTION__,cellModel.strAlarmPicUrl );
    
    NSString *pathAccount = [[JVCSystemUtility shareSystemUtilityInstance] getRandomPicLocalPath];
    
    JVCCloudSEENetworkHelper *cloudSEEObj =  [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    cloudSEEObj.ystNWRPVDelegate          =  self;
    
    [cloudSEEObj RemoteDownloadFile:nlocalChannel withDownLoadPath:(char *)[cellModel.strAlarmPicUrl UTF8String] withSavePath:pathAccount];
    
    
}

/**
 *  down远程回放的图片
 */
- (void)downRemotePlayBackVideo:(int)nlocalChannel
{
    iDownLoadType = DownLoadType_VIDEO;

    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:nDeleteRow];
    
    DDLogCVerbose(@"%s----downlocad",__FUNCTION__);
    
    NSString *pathAccount = [[JVCSystemUtility shareSystemUtilityInstance] getRandomVideoLocalPath];
    
    JVCCloudSEENetworkHelper *cloudSEEObj =  [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    cloudSEEObj.ystNWRPVDelegate          =  self;
    
    [cloudSEEObj RemoteDownloadFile:nlocalChannel withDownLoadPath:(char *)[cellModel.strAlarmVideoUrl UTF8String] withSavePath:pathAccount];
    
    
}


/**
 *  远程下载文件的回调
 *
 *  @param downLoadStatus 下载的状态
 
 JVN_RSP_DOWNLOADOVER  //文件下载完毕
 JVN_CMD_DOWNLOADSTOP  //停止文件下载
 JVN_RSP_DOWNLOADE     //文件下载失败
 JVN_RSP_DLTIMEOUT     //文件下载超时
 
 *  @param path           下载保存的路径
 */
-(void)remoteDownLoadCallBack:(int)downLoadStatus withDownloadSavePath:(NSString *)savepath {
    
    DDLogCVerbose(@"%s--------savePath=%@ status=%d",__FUNCTION__,savepath,downLoadStatus);
    [[JVCAlertHelper shareAlertHelper] performSelectorOnMainThread:@selector(alertHidenToastOnWindow) withObject:nil waitUntilDone:NO];

    
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:nDeleteRow];
    
    if (savepath.length<=0) {
        
        [self disRemoteLink];
        
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:LOCALANGER(@"jvc_alarmlist_getAlarmError")];
        return;
        
    }
    
    if (downLoadStatus == JVN_RSP_DOWNLOADOVER) {//成功
        
        if (iDownLoadType == DownLoadType_PIC) {
           
            cellModel.strAlarmLocalPicURL = [NSString stringWithFormat:@"%@",savepath];
            
            [self disRemoteLink];
            
            [self performSelectorOnMainThread:@selector(showJVHAlarmVideoWithModel:) withObject:cellModel waitUntilDone:NO];
            
        }else{

            cellModel.strAlarmLocalVideoUrl = [NSString stringWithFormat:@"%@",savepath];;
            
            [self performSelectorOnMainThread:@selector(playMovie:) withObject:cellModel.strAlarmLocalVideoUrl waitUntilDone:NO];
            
            /**
             *  调用端口连接
             */
           [self disRemoteLink];

        }
        
    }else{
        
        [self disRemoteLink];
        
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:LOCALANGER(@"jvc_alarmlist_getAlarmError")];
        
    }
    
}

/**
 *  播放view的回调
 */
- (void)playVideoCallBack:(JVCAlarmModel *)playModel
{
    
    [self removeJVHAlarmShowView];
    
    JVCOperationController *tOPVC;
    
    if (iphone5) {
        
        tOPVC = [[JVCOperationControllerIphone5 alloc] init];
        
    }else
    {
        tOPVC = [[JVCOperationController alloc] init];
        
    }
    
    tOPVC.strSelectedDeviceYstNumber = playModel.strYstNumber;
    tOPVC.isPlayBackVideo            = TRUE;
    tOPVC.strPlayBackVideoPath       = playModel.strAlarmVideoUrl;
    tOPVC._iSelectedChannelIndex     = 0;
    [self.navigationController pushViewController:tOPVC animated:YES];
    [tOPVC release];
    

//    if (playModel.strAlarmLocalVideoUrl.length ==0 ||playModel.strAlarmVideoUrl.length !=0) {//down 视频
//                
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//
//            if (playModel.strAlarmLocalVideoUrl.length >0) {//直接播放
//                
//                [self performSelectorOnMainThread:@selector(playMovie:) withObject:playModel.strAlarmLocalVideoUrl waitUntilDone:NO];
//                return ;
//            }
//            
//            if ([[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] returnCurrentLintState:nChannelLinkNum]) {
//                
//                [[JVCAlertHelper shareAlertHelper]performSelectorOnMainThread:@selector(alertShowToastOnWindow) withObject:nil waitUntilDone:NO];
//
//                [self downRemotePlayBackVideo:nChannelLinkNum];
//
//            }else{
//                
//                [[JVCAlertHelper shareAlertHelper]performSelectorOnMainThread:@selector(alertShowToastOnWindow) withObject:nil waitUntilDone:NO];
//                [self connetDeviceWithYSTNum];
//
//            }
//            
//        });
//        
//    }else{
//        
//        
//        [self playMovie:playModel.strAlarmLocalVideoUrl];
//        
//    }
}

/**
 *  点击背景的事件
 */
- (void)jvcSingleAlarmClickBackGroundCallBack
{
    [self removeJVHAlarmShowView];
    
    [self disRemoteLink];

}

- (void)playMovie:(NSString *)filePath
{
    [self removeJVHAlarmShowView];
    
    [filePath retain];
    
    JVCAlarmVideoPlayViewController *view = [[JVCAlarmVideoPlayViewController alloc] init];
    view._StrViedoPlay = filePath;

    [self.navigationController pushViewController:view animated:YES];
    
    [filePath release];
    [view release];
}

/**
 *  连接云视通
 */
- (void)connetDeviceWithYSTNum
{
    [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = YES;

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:nDeleteRow];
        
        JVCDeviceModel *deviceModel = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:cellModel.strYstNumber];
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate = self;
        
        NSString *deviceUserName ;
        NSString *delvicePassword;
        
        if (deviceModel == nil) {
            
            deviceUserName  = (NSString *)DefaultUserName;
            delvicePassword = (NSString *)DefaultPassWord;
        }else{
            
            deviceUserName = deviceModel.userName;
            delvicePassword = deviceModel.passWord;
        }
        
        
        if (deviceModel.linkType) {
            
            [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] ipConnectVideobyDeviceInfo:1 nRemoteChannel:cellModel.iYstChannel  strUserName:deviceUserName strPassWord:delvicePassword strRemoteIP:deviceModel.ip nRemotePort:[deviceModel.port intValue] nSystemVersion:IOS_VERSION isConnectShowVideo:NO];
            
        }else{
            
            [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] ystConnectVideobyDeviceInfo:1
                                                                                   nRemoteChannel:cellModel.iYstChannel strYstNumber:cellModel.strYstNumber
                                                                                      strUserName:deviceUserName
                                                                                      strPassWord:delvicePassword nSystemVersion:IOS_VERSION isConnectShowVideo:NO];
        }
        
    });
    
}


/**
 *  连接的回调代理
 *
 *  @param connectCallBackInfo 返回的连接信息
 *  @param nlocalChannel       本地通道连接从1开始
 *  @param connectType         连接返回的类型
 */
-(void)ConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType
{
    
    nChannelLinkNum = nlocalChannel;
    
    if (connectResultType == CONNECTRESULTTYPE_Succeed) {
        
        if (iDownLoadType == DownLoadType_VIDEO) {//down视频
            
            [self downRemotePlayBackVideo:nChannelLinkNum];

        }else{
            //云视通连接成功，down图片
            
            [self downRemotePlayBackPic:nlocalChannel];
        }
  
        
    }else {
        
        NSString *localInfoKey = nil;
        
        switch (connectResultType) {
                
            case  CONNECTRESULTTYPE_ConnectFailed:
            case  CONNECTRESULTTYPE_AbnormalConnectionDisconnected: //Disconnected Due To CloudSEE Service Has Been Stopped
            case  CONNECTRESULTTYPE_ServiceStop:                    //"Disconnected Due To CloudSEE Service Has Been Stopped"
            case  CONNECTRESULTTYPE_DisconnectFailed:               //Connection Failed
            case  CONNECTRESULTTYPE_YstServiceStop:                  //CloudSEE Service Has Been Stopped
            case  CONNECTRESULTTYPE_VerifyFailed:                      //身份验证不成功
            case  CONNECTRESULTTYPE_ConnectMaxNumber:{
                
                NSString *localstring=[NSString  stringWithFormat:@"connectResultInfo_%d",connectResultType];
                
                localInfoKey = LOCALANGER(localstring);
            }
                break;
                default:
                localInfoKey = LOCALANGER(@"jvc_alarmlist_getAlarmError");
                break;
        }
        
        [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = NO;

        [[JVCAlertHelper shareAlertHelper] performSelectorOnMainThread:@selector(alertHidenToastOnWindow) withObject:nil waitUntilDone:NO];
        
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:localInfoKey];
        
    }
    
    
}

/**
 *  断开远程连接方法
 */
- (void)disRemoteLink
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = NO;

        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate            = nil;
        ystNetWorkHelperObj.ystNWRPVDelegate          =  nil;
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:nChannelLinkNum];
    });
}

@end
