//
//  JVCLoginViewController.h
//  CloudSEE_II
//  登录账号
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCRegisterViewController.h"
#import "JVCBaseWithGeneralViewController.h"
#import "JVCDropDownView.h"
#import "JVCModifyUnLegalViewController.h"
#import "JVCAPConfigViewController.h"
#import "JVCHelpVIew.h"

@interface JVCLoginViewController : JVCBaseWithGeneralViewController<RegisterUserDelegate,DropDownViewDelegate,modifyUnlegalUserAndPassWordDelegate,UITextFieldDelegate,JVCAPConfigViewControllerDelegate,JVCWelcomeDelegate>


@end
