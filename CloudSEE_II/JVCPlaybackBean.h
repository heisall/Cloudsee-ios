//
//  JVCPlaybackBean.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/15/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCPlaybackBean : UITableViewCell
{
 UILabel *timeLabel;//时间
 UILabel *sizeLabel;//盘符
}

@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizeLabel;

@end
