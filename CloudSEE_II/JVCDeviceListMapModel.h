//
//  JVCDeviceListMapModel.h
//  CloudSEE_II
//
//  Created by David on 14/12/16.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCBaseMapModel.h"

@interface JVCDeviceListMapModel : JVCBaseMapModel <JVCJson2ModelDelegate>

@property (nonatomic,retain)NSArray *dlist;

@end
