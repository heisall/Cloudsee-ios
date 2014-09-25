//
//  JVCDeviceListViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCDeviceListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    /**
     *  设备列表
     */
    NSMutableArray *arrayDeviceList;
}
@property(nonatomic,retain)NSMutableArray *arrayDeviceList;
@end
