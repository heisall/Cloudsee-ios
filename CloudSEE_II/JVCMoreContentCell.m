//
//  JVCMoreContentCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreContentCell.h"

static const int  moreContentCellOff_X  = 20;//距离组边框的距离

static const int  moreContentCellSeperate  = 20;//距离图片的距离


static const int  moreContentCellLabelWith  = 200;//label的宽

static const int  moreContentCellTextFont  = 14;//字体大小

static const int  moreContentRight= 40;//new 的位置距离右边的位置

@implementation JVCMoreContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  根据model初始化
 *
 *  @param model mode类型数据
 */
- (void)initContentCells:(JVCMoreSettingModel *)model
{
 
    //图标
    UIImage *imgIcon = [UIImage imageNamed:model.iconImageName];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(moreContentCellOff_X, (self.height - imgIcon.size.height)/2.0, imgIcon.size.width, imgIcon.size.height)];
    iconImageView.image = imgIcon;
    [self.contentView addSubview:iconImageView];
    [iconImageView release];
    
    //标签
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+moreContentCellSeperate, iconImageView.top, moreContentCellLabelWith, iconImageView.height)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = [UIFont systemFontOfSize:moreContentCellTextFont];
    labelTitle.text = model.itemName;
    [self.contentView addSubview:labelTitle];
    [labelTitle release];
    
    if (model.bNewState) {//有新便签
        
        UIImage *imgIconNew = [UIImage imageNamed:@"mor_cellnew.png"];
        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width -moreContentRight-imgIconNew.size.width , (self.height - imgIconNew.size.height)/2.0, imgIconNew.size.width, imgIconNew.size.height)];
        newImageView.image = imgIconNew;
        [self.contentView addSubview:newImageView];
        [newImageView release];

    }
    
    //横线
    UIImage *imgLine = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLine.size.width)/2.0, self.height - imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    lineImageView.image = imgLine;
    [self.contentView addSubview:lineImageView];
    [lineImageView release];

    
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
