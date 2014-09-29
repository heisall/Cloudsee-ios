//
//  JVCMoreUserSettingModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

typedef enum {

    TYPEFLAG_None = 0,//什么也不带的标志

    TYPEFLAG_Indicator = 1,//带箭头的指示
    
    TYPEFLAG_SWitch    = 2,//开关的标志

} cellAccessType;
#import <Foundation/Foundation.h>

@interface JVCMoreUserSettingModel : NSObject
{
    NSString *titleString;//标题
    
    NSString *footString; //foot标题
    
    int typeFlag;         //标志
}

@property(nonatomic,strong) NSString *titleString;//标题
@property(nonatomic,strong) NSString *footString; //foot标题

@property(nonatomic,assign) int typeFlag;


@end
