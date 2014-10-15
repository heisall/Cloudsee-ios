//
//  JVCPlaybackBean.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/15/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCPlaybackBean.h"

@implementation JVCPlaybackBean
@synthesize timeLabel,sizeLabel;

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


- (void)dealloc {
	[sizeLabel release];
	[timeLabel release];
	
    [super dealloc];
}


@end
