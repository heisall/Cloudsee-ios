//
//  JVCPhotoViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"

@interface JVCPhotoViewController : JVCBaseGeneralTableViewController
{
    NSMutableArray *mArrayPhotoDatas;
    NSMutableArray *mArrayGroupDatas;

    NSInteger typeTitle;

}
@property(nonatomic,assign)NSInteger typeTitle;
@property(nonatomic,retain) NSMutableArray *mArrayPhotoDatas;
@property(nonatomic,retain) NSMutableArray *mArrayGroupDatas;

- (id)initWithDatasource:(NSArray *)datasource;

@end
