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
static int const KPlayBackLabelWith   = 98;//高
static int const KplayBackLabelHeight = 23;//宽

static int const KplayBackTimeLabelOrigin = 23;//
static int const KplayBackLabelSizeOrigin = 190;//
static int const KplayBackLabelFontSize   = 16;//字体大小

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
          }
    return self;
}

- (void)initCellContentViews 
{
    for (UIView *viewIn in self.contentView.subviews)
    {
        [viewIn removeFromSuperview];
    }
        
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KplayBackTimeLabelOrigin, (self.height- KplayBackLabelHeight)/2.0, KPlayBackLabelWith, KplayBackLabelHeight)];
    timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:timeLabel];
    
    sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KplayBackLabelSizeOrigin, (self.height- KplayBackLabelHeight)/2.0, KPlayBackLabelWith, KplayBackLabelHeight)];
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
