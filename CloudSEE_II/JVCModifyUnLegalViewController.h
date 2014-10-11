//
//  JVCModifyUnLegalViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCLabelFieldSView.h"
@protocol modifyUnlegalUserAndPassWordDelegate <NSObject>

- (void)modifyUserAndPWSuccessCallBack;

@end

@interface JVCModifyUnLegalViewController : JVCBaseWithGeneralViewController<JVCLabelFieldSViewDelegate,UITextFieldDelegate>
{
    id<modifyUnlegalUserAndPassWordDelegate>delegate;

}
@property(nonatomic,assign) id<modifyUnlegalUserAndPassWordDelegate>delegate;

@end
