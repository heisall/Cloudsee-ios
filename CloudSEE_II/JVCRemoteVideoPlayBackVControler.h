//
//  JVCRemoteVideoPlayBackVControler.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCOperationController.h"

@protocol RemotePlayBackVideodelegate <NSObject>
//
//[[ystNetWorkHelper shareystNetWorkHelperobjInstance] RemoteRequestSendPlaybackVideo:_managerVideo.nSelectedChannelIndex+1 requestPlayBackFileInfo:[playbackSearchFileListMArray objectAtIndex:0] requestPlayBackFileDate:[NSDate date] requestPlayBackFileIndex:0];

/**
 *  远程回调选中的一行的回调
 *
 *  @param dicInfo 字典数据（时间）
 *  @param date    时间（选中的哪天数）
 *  @param index   选中返回数据的哪一行（具体的时间，小时：分钟：秒）
 */
- (void)remotePlaybackVideoCallbackWithrequestPlayBackFileInfo:(NSMutableDictionary *)dicInfo  requestPlayBackFileDate:(NSDate *)date  requestPlayBackFileIndex:(int )index;

/**
 *  获取选中日期的回调
 *
 *  @param date 传入的日期
 */
- (void)remoteGetPlayBackDateWithSelectDate:(NSDate *)date;

@end

@interface JVCRemoteVideoPlayBackVControler : JVCBaseWithGeneralViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    /**
     *  存放数据的数组
     */
    NSMutableArray *arrayDateList;
    
    /**
     *  存放当前选中的indexrow.row
     */
    int  iSelectRow;
    
    id<RemotePlayBackVideodelegate> remoteDelegat;
    
    
}
@property(nonatomic,retain)NSMutableArray *arrayDateList;
@property(nonatomic,assign)id<RemotePlayBackVideodelegate> remoteDelegat;
@property(nonatomic,assign)int  iSelectRow;
/**
 *  tableview刷新
 */
- (void)tableViewReloadDate;

/**
 *  返回到上一层
 */
-(void)BackClick;

/**
 *  单例
 */
+ (JVCRemoteVideoPlayBackVControler *)shareInstance;


@end
