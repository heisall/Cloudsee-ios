//
//  JVCDeviceAlarmNoDeviceTableViewCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceAlarmNoDeviceTableViewCell.h"
#import "JVCControlHelper.h"
@implementation JVCDeviceAlarmNoDeviceTableViewCell
static const  int KCellOriginX       = 20;//具有左侧的距离
static const  int KCellSpan          = 20;//间距
static const  int KLabelFontSize     = 20;//间距

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  初始化view
 */
- (void)initTableView
{
    for (UIView *contentView in self.contentView.subviews) {
        
        [contentView removeFromSuperview];
    }
 
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
//    UIImageView *imageViewBG = [controlHelper imageViewWithIamge:@"arm_loc_cellbg.png"];
//    [self.contentView addSubview:imageViewBG];
    
    UIImageView *addImageView = [controlHelper imageViewWithIamge:@"arm_loc_add.png"];
    [addImageView retain];
    addImageView.frame = CGRectMake(KCellOriginX, 0, addImageView.width, addImageView.height);
    [self.contentView addSubview:addImageView];
    [addImageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(addImageView.right+KCellSpan,0, self.width-addImageView.width-3*KCellSpan, addImageView.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"点击此处添加设备";
    label.font = [UIFont systemFontOfSize:KLabelFontSize];
    label.numberOfLines = 2;
    label.lineBreakMode = UILineBreakModeWordWrap;
    [self.contentView addSubview:label];
    [label release];
    
    
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
