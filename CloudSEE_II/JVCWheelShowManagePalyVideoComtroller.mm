//
//  JVCWheelShowManagePalyVideoComtroller.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-16.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCWheelShowManagePalyVideoComtroller.h"

@implementation JVCWheelShowManagePalyVideoComtroller

/**
 *  返回当前选择设备的通道个数
 *
 *  @return 当前选择设备的通道个数
 */
-(int)channelCountAtSelectedYstNumber{

   // DDLogVerbose(@"%s-------channelCount=%d",__FUNCTION__,[[JVCChannelScourseHelper shareChannelScourseHelper] ChannelListArray].count);
    
    return [[JVCChannelScourseHelper shareChannelScourseHelper] ChannelListArray].count;
}

/**
 *  根据当前的索引返回云视通号
 *
 *  @return 当前选择的云视通号
 */
-(NSString *)ystNumberAtCurrentSelectedIndex{

    JVCChannelScourseHelper  *channelSourceObj    = [JVCChannelScourseHelper shareChannelScourseHelper];
    JVCChannelModel          *channelModel  = (JVCChannelModel *)[[channelSourceObj ChannelListArray] objectAtIndex:self.nSelectedChannelIndex];
    
    return channelModel.strDeviceYstNumber;

}

/**
 *  根据所选显示视频的窗口的编号连接通道集合中指定索引的通道对象
 *
 *  @param nlocalChannelID 本地显示窗口的编号
 */
-(void)connectVideoByLocalChannelID:(int)nlocalChannelID {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCChannelScourseHelper             *channelSourceObj    = [JVCChannelScourseHelper shareChannelScourseHelper];
        JVCChannelModel                     *channelModel        = (JVCChannelModel *)[[channelSourceObj ChannelListArray] objectAtIndex:nlocalChannelID - KWINDOWSFLAG];
        int                                  channelID           = nlocalChannelID - KWINDOWSFLAG + 1;
        JVCMonitorConnectionSingleImageView *singleView          = [self singleViewAtIndex:nlocalChannelID - KWINDOWSFLAG];
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        BOOL                                 connectStatus       = [ystNetWorkHelperObj checknLocalChannelExistConnect:channelID];
        JVCDeviceModel                      *deviceModel         = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:channelModel.strDeviceYstNumber];
        
        NSString                            *connectInfo             = [NSString stringWithFormat:@"%@-%d",channelModel.strNickName,channelModel.nChannelValue];
        
        
        DDLogVerbose(@"%s--------------connectInfo=%@",__FUNCTION__,connectInfo);
        
        //重复连接
        if (!connectStatus) {
            
            [singleView startActivity:connectInfo isConnectType:!deviceModel.linkType];
            
            if (deviceModel.linkType) {
                
                connectStatus = [ystNetWorkHelperObj ipConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue  strUserName:deviceModel.userName strPassWord:deviceModel.passWord strRemoteIP:deviceModel.ip nRemotePort:[deviceModel.port intValue] nSystemVersion:IOS_VERSION isConnectShowVideo:self.isPlayBackVideo == TRUE ? FALSE : TRUE];
                
            }else{
                
                connectStatus = [ystNetWorkHelperObj ystConnectVideobyDeviceInfo:channelID nRemoteChannel:channelModel.nChannelValue strYstNumber:channelModel.strDeviceYstNumber strUserName:deviceModel.userName strPassWord:deviceModel.passWord nSystemVersion:IOS_VERSION isConnectShowVideo:self.isPlayBackVideo == TRUE ? FALSE : TRUE];
            }
        }
        
    });
}

@end
