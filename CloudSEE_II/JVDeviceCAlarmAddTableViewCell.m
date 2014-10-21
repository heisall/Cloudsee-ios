//
//  JVDeviceCAlarmAddTableViewCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVDeviceCAlarmAddTableViewCell.h"
#import "JVCControlHelper.h"
@implementation JVDeviceCAlarmAddTableViewCell
static const int KCellOrignX    = 15;//距离左侧的距离
static const int KCellSpan      = 20;//间距

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initAlarmAddTableViewContentView:(JVCLockAlarmModel *)model
{
    for (UIView *contentView in self.contentView.subviews) {
        
        [contentView removeFromSuperview];
    }
    
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
    UIImageView *imageViewBG = [controlHelper imageViewWithIamge:@"arm_loc_cellbg.png"];
    [self.contentView addSubview:imageViewBG];
    
    NSString *imageStr = nil;
    
    if (model.alarmType == JVCAlarmLockType_Door) {
        imageStr = @"arm_device_0.png";
    }else{
        imageStr = @"arm_device_1.png";
    }
//    UIImageView *imageViewDevice = [controlHelper imageViewWithIamge:imageStr];
//    imageViewDevice.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
