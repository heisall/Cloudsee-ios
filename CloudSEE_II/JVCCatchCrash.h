//
//  JVCCatchCrash.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/27/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCCatchCrash : NSObject

void uncaughtExceptionHandler(NSException *exception);

@end
