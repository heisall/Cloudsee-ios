//
//  JVCEditChannelInfoTableViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/9/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
@class JVCChannelModel;
@interface JVCEditChannelInfoTableViewController : JVCBaseGeneralTableViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *YstNum;
    
     JVCChannelModel *channelModel;
    
    NSMutableArray *arrayChannelsList;//通道数组

}


@property(nonatomic,retain)NSString *YstNum;//通道数组
@property(nonatomic,retain) JVCChannelModel *channelModel;
@property(nonatomic,retain)    NSMutableArray *arrayChannelsList;//通道数组

/**
 *  修改通道昵称的方法
 */
- (void)handlePredicatChannelNickNameSuccess:(NSString *)channelName;

/**
 *  编辑昵称成功
 */
-(void)handleEdicteNickNameSuccessResult:(int)result;

/**
 *  删除通道处理结果
 *
 *  @param reuslt       类型
 *  @param channelModel 通道model
 */
- (void)handleDeleteChannelResult:(int)reuslt  deleteModel:(JVCChannelModel *)channelModelDelete;

/**
 *  当设备下面只有一个通道的时候，直接删除设备
 *
 *  @param result             删除返回值
 *  @param channelModelDelete 通道
 */
- (void)handleDeleteDeviceWithNoChannel:(int)result   channelModel:(JVCChannelModel *)channelModelDelete;

/**
 *  初始化channellist
 */
- (void)initChannelist;

/**
 *  添加通道方法
 */
- (void)addDeviceChannlesMaths;

- (void)updateTableview;


@end
