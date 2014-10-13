//
//  JVCVoiceencViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@interface JVCVoiceencViewController : JVCBaseWithGeneralViewController {

    NSString *strSSID;
    NSString *strPassword;
}

@property (nonatomic,retain) NSString *strSSID;
@property (nonatomic,retain) NSString *strPassword;

@end
