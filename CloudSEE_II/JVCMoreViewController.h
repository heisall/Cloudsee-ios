//
//  JVCMoreViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "JVCMoreContentCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "JVCURlRequestHelper.h"
@interface JVCMoreViewController : JVCBaseGeneralTableViewController<UIAlertViewDelegate,JVCMoreCellSwitchDelegate,MFMailComposeViewControllerDelegate,JVCURLRequestDelegate,UIActionSheetDelegate>


@end
