//
//  JVCMoreUserSettingModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreUserSettingModel.h"

@implementation JVCMoreUserSettingModel
@synthesize titleString,footString;
@synthesize typeFlag;

- (void)dealloc
{
    [self.titleString release];
    self.titleString = nil;
    
    [self.footString release];
    self.footString = nil;
    
    [super dealloc];
}
@end
