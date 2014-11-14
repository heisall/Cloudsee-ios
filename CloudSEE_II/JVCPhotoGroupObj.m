//
//  JVCPhotoGroupObj.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCPhotoGroupObj.h"

@implementation JVCPhotoGroupObj

@synthesize month,year,day,mArrayPhotos;

-(void)dealloc{
    
    [mArrayPhotos release];
    [super dealloc];
}


- (id)init {
    
    if (self = [super init]) {
        
        NSMutableArray *photos= [[NSMutableArray alloc] init];
        self.mArrayPhotos=photos;
        [photos release];
    }
    return self;
}

@end
