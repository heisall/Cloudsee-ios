//
//  JVCOpenAdevitiseViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@interface JVCOpenAdevitiseViewController : JVCBaseWithGeneralViewController<UIWebViewDelegate>
{
    NSString *openUrlString;
}
@property(nonatomic,retain) NSString *openUrlString;
@end
