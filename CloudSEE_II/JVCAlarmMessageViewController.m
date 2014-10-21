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
enum {
    DownLoadType_PIC    = 0,//图片的
    DownLoadType_VIDEO  = 1,//视频的
    
};


@interface JVCAlarmMessageViewController ()
{
    NSMutableArray *arrayAlarmList;
    
    int iDownLoadType;//正在下载标识
    
    int nChannelLinkNum;//连接通道的标识
    
    int nAlarmOriginIndex ;//获取alarm起始的索引
    
}

@end

@implementation JVCAlarmMessageViewController
static const int KSUCCESS = 0;//成功
static const NSTimeInterval KTimerAfterDelay = 0.5;
static const int KChannelNum = 1;//通道连接
static const int KNoAlarmTag = 10003;//没有报警的view的tag
static const int KNoAlarmLabelHeight = 50;//没有报警的view的tag
static const int KNoAlarmSpan    = 30;//没有报警的view的tag

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"报警消息", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_message_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_message_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayAlarmList  = [[NSMutableArray alloc] init];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshingData)];

    NSLog(@"=================%@",NSStringFromCGRect(self.view.frame));
    [self addTableViewFootView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView headerBeginRefreshing];

    
}

- (void)addTableViewFootView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    //自动下拉刷新
    //[_tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.headerReleaseToRefreshText = @"松开马上加载";
    self.tableView.headerRefreshingText = @"正在加载";
    

}


- (void)footerRereshing
{
    [self getAlarmListDate];
}
/**
 *  下拉刷新事件
 */
- (void)headerRereshingData
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
                
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"获取报警历史失败"];
                  
                }
                
                [self.tableView footerEndRefreshing];
                [self.tableView headerEndRefreshing];
            }
            
        });
    });

}

/**
 *  添加没有数据的图片
 */
- (void)addNoAlarmDateView
{
    UIView *viewNoAlarm = (UIView *)[self.view viewWithTag:KNoAlarmTag];
    if (!viewNoAlarm) {
        
        viewNoAlarm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        
        NSString    *pathNoAlarm    = [UIImage imageBundlePath:@"arm_no.png"];
        UIImage     *imageNo        = [[UIImage alloc] initWithContentsOfFile:pathNoAlarm];
        UIImageView *imageView      = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width -imageNo.size.width)/2.0 ,(self.view.height -imageNo.size.height)/2.0, imageNo.size.width, imageNo.size.height)];
        imageView.image             = imageNo;
        [viewNoAlarm addSubview:imageView];
        viewNoAlarm.tag               = KNoAlarmTag;
        
        UILabel *labelNoAlarm        = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+KNoAlarmSpan, self.view.width, KNoAlarmLabelHeight)];
        labelNoAlarm.backgroundColor = [UIColor clearColor];
        labelNoAlarm.textAlignment   = UITextAlignmentCenter;
        labelNoAlarm.text            = @"暂无消息";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayAlarmList.count;
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
    JVCAlarmModel *modelcell = [arrayAlarmList objectAtIndex:indexPath.row];
    [cell initAlermCell:modelcell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVCAlarmCell *homecell = (JVCAlarmCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageViewNew = (UIImageView *)[homecell.contentView viewWithTag:10005];
    [imageViewNew removeFromSuperview];
    
    //点击cell，连接远程回放，判断是否连接上
    
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:indexPath.row];

    if (cellModel.strAlarmLocalPicURL.length !=0) {
        
        [self showJVHAlarmVideoWithModel:cellModel];
        
    }else{
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
    UIView *headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)] autorelease];
    //    UILabel *labelTimer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headView.frame.size.height)];
    //    labelTimer.backgroundColor = [UIColor clearColor];
    //    JDCSAppDelegate *delegate = (JDCSAppDelegate *)[UIApplication sharedApplication].delegate;
    //    alarmModel *tcellModel = [delegate._dealNotificationArray objectAtIndex:section];
    //    labelTimer.textAlignment = UITextAlignmentCenter;
    //    labelTimer.text = tcellModel.strAlarmTime;
    //    labelTimer.textColor =  SETLABLERGBCOLOUR(61.0, 115.0, 175.0);
    //    [labelTimer setFont:[UIFont systemFontOfSize:14]];
    //    [headView addSubview:labelTimer];
    //    [labelTimer release];
    return headView;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVCAlarmModel *model = [arrayAlarmList objectAtIndex:indexPath.row];
    
    [self deleteSingelAlarm:model.strAlarmGuid];
    
}

- (void)deleteSingelAlarm:(NSString *)deviceGuid
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        BOOL result = [[JVCAlarmHelper shareAlarmHelper] deleteAlarmHistoryWithGuid:deviceGuid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            if (result) {
                
                int row = self.tableView.indexPathForSelectedRow.row;
                
                [arrayAlarmList removeObjectAtIndex:row];

//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

                [self.tableView reloadData];
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"删除成功"];
                
                nAlarmOriginIndex -- ;

            }else{
            
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"删除失败"];
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
    alarmView.tag = 138354;
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
    JVCSignleAlarmDisplayView *viewContent = (JVCSignleAlarmDisplayView *)[self.view.window viewWithTag:138354];
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
    
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    DDLogCVerbose(@"%s----downlocad",__FUNCTION__);
    
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

    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
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

    
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    if (downLoadStatus == JVN_RSP_DOWNLOADOVER) {//成功
        
        if (iDownLoadType == DownLoadType_PIC) {
            NSLog(@"========111111======%@",savepath);
            cellModel.strAlarmLocalPicURL = [NSString stringWithFormat:@"%@",savepath];
            
            [self performSelectorOnMainThread:@selector(showJVHAlarmVideoWithModel:) withObject:cellModel waitUntilDone:NO];
            
        }else{
            NSLog(@"========222222======%@",savepath);

            cellModel.strAlarmLocalVideoUrl = [NSString stringWithFormat:@"%@",savepath];;
            
            [self performSelectorOnMainThread:@selector(playMovie:) withObject:cellModel.strAlarmLocalVideoUrl waitUntilDone:NO];
            
            /**
             *  调用端口连接
             */
           [self disRemoteLink];

        }
        
    }else{
        
        [self disRemoteLink];
        
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:@"获取报警信息失败，请重试"];
        
    }
    
}

/**
 *  播放view的回调
 */
- (void)playVideoCallBack:(JVCAlarmModel *)playModel
{
    iDownLoadType = DownLoadType_VIDEO;

    if (playModel.strAlarmLocalVideoUrl.length ==0 ||playModel.strAlarmVideoUrl.length !=0) {//down 视频
                
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            

            if (playModel.strAlarmLocalVideoUrl.length >0) {//直接播放
                
                [self performSelectorOnMainThread:@selector(playMovie:) withObject:playModel.strAlarmLocalVideoUrl waitUntilDone:NO];
                return ;
            }
            
            if ([[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] returnCurrentLintState:nChannelLinkNum]) {
                
                [[JVCAlertHelper shareAlertHelper]performSelectorOnMainThread:@selector(alertShowToastOnWindow) withObject:nil waitUntilDone:NO];

                [self downRemotePlayBackVideo:nChannelLinkNum];

            }else{
                
                [[JVCAlertHelper shareAlertHelper]performSelectorOnMainThread:@selector(alertShowToastOnWindow) withObject:nil waitUntilDone:NO];
                [self connetDeviceWithYSTNum];

            }
            
        });
        
    }else{
        
        
        [self playMovie:playModel.strAlarmLocalVideoUrl];
        
    }
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
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
        
        if (   iDownLoadType== DownLoadType_VIDEO) {//down视频
            
            [self downRemotePlayBackVideo:nChannelLinkNum];

        }else{
            //云视通连接成功，down图片
            
            [self downRemotePlayBackPic:nlocalChannel];
        }
  
        
    }else {
        
        [[JVCAlertHelper shareAlertHelper] performSelectorOnMainThread:@selector(alertHidenToastOnWindow) withObject:nil waitUntilDone:NO];
        
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:@"获取报警信息错误，请重试"];
        
    }
    
    
}

/**
 *  断开远程连接方法
 */
- (void)disRemoteLink
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate = nil;
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:nChannelLinkNum];
    });
}

@end
