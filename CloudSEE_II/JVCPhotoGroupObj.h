//
//  JVCPhotoGroupObj.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCPhotoGroupObj : NSObject
{
    NSUInteger month;
    NSUInteger year;
    NSUInteger day;
    NSMutableArray *mArrayPhotos;
}

@property (nonatomic, assign) NSUInteger month;
@property (nonatomic, assign) NSUInteger year;
@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, retain) NSMutableArray *mArrayPhotos;

@end
