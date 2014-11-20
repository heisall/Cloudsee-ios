//
//  JVCPlaybackBean.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/15/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCPlaybackBean.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"

@implementation JVCPlaybackBean
@synthesize timeLabel,sizeLabel;

static int const KplayBackLabelHeight           = 23.0f;  //标签的高度
static int const KplayBackLabelWidth            = 200.0f;  //标签的高度
static int const KplayBackTimeLabelSizeWidth    = 60.0f; //盘符标签的宽度
static int const KplayBackLabelWithRightAndLeft = 10.0f;  //标签距离左右的间距
static int const KplayBackLabelFontSize         = 14.0f;  //字体大小

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    return self;
}

/**
 *  初始化
 *
 *  @param title 时间+类型
 *  @param disk  磁盘
 */
- (void)initCellContentViews
{
    for (UIView *viewIn in self.contentView.subviews)
    {
        [viewIn removeFromSuperview];
    }
        
    timeLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(KplayBackLabelWithRightAndLeft, (self.height- KplayBackLabelHeight)/2.0,KplayBackLabelWidth, KplayBackLabelHeight)];
    timeLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:timeLabel];
    
    sizeLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.size.width + timeLabel.frame.origin.x, (self.height- KplayBackLabelHeight)/2.0, KplayBackTimeLabelSizeWidth, KplayBackLabelHeight)];
    sizeLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:sizeLabel];
    
    timeLabel.font = [UIFont systemFontOfSize:KplayBackLabelFontSize];
    sizeLabel.font = [UIFont systemFontOfSize:KplayBackLabelFontSize];
    
    UIColor *color = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kPlayBackCellLabelColor];
    
    if (color) {
        
        timeLabel.textColor = color;
        sizeLabel.textColor = color;
    }
}

- (void)dealloc {
    
	[sizeLabel release];
	[timeLabel release];
	
    [super dealloc];
}

@end
