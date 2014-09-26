//
//  JVCMoreSettingModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreSettingModel.h"

@implementation JVCMoreSettingModel
@synthesize iconImageName,bNewState,itemName,bBtnState;

- (void)dealloc
{
    [iconImageName release];
    iconImageName = nil;
    
    [itemName release];
    itemName = nil;
    
    [super dealloc];
}


@end
