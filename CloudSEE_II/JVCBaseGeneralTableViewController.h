//
//  JVCBaseGeneralTableViewController.h
//  CloudSEE_II
//  tableview继承的基类，解决了，屏幕旋转问题
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCBaseGeneralTableViewController : UITableViewController

/**
 *  视图可见时加载的view
 */
- (void)initLayoutWithViewWillAppear;

/**
 *  视图不可见时释放的View
 */
-(void)deallocWithViewDidDisappear;

- (void)BackClick;

/**
 *  下拉刷新事件
 */
- (void)headerRereshingData;
@end
