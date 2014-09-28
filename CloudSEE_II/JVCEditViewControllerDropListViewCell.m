//
//  JVCEditViewControllerDropListViewCell.m
//  CloudSEE_II
//  设备编辑界面 顶部下拉弹出的表格视图的单个Cell视图
//  Created by chenzhenyang on 14-9-26.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCEditViewControllerDropListViewCell.h"
#import "JVCRGBHelper.h"


@interface JVCEditViewControllerDropListViewCell (){

    UIImageView *iconImageView;
    UIImageView *selectImageView;
    UILabel     *titleLbl;
}

@end

@implementation JVCEditViewControllerDropListViewCell

static const CGFloat kIconWithRightSpacting             = 15.0f;
static const CGFloat kSelectedImageViewWithLeftSpacting = 10.0f;
static const CGFloat kTitleWithFontSize                 = 18.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
     
    }
    
    return self;
}

/**
 *  初始化单个设备视图
 */
-(void)initWithLayoutView:(NSString *)titleName{
    
    [titleName retain];
    
    UIImage *iconImage   = [UIImage imageNamed:@"edi_drop_icon_unselect.png"];
    UIImage *selectImage = [UIImage imageNamed:@"edi_drop_flag_select.png"];
    UIImage *borderImage = [UIImage imageNamed:@"edi_drop_line.png"];
    
    //图标
    iconImageView    = [[UIImageView alloc] init];
    
    iconImageView.frame           = CGRectMake(kIconWithRightSpacting, (self.contentView.frame.size.height - iconImage.size.height)/2.0, iconImage.size.width, iconImage.size.height);
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.image           = iconImage;
    [self.contentView addSubview:iconImageView];
    [iconImageView release];
    
    //选中图标
    selectImageView = [[UIImageView alloc] init];
    selectImageView.frame           = CGRectMake(self.contentView.frame.size.width - selectImage.size.width - kSelectedImageViewWithLeftSpacting, (self.contentView.frame.size.height - selectImage.size.height)/2.0, selectImage.size.width, selectImage.size.height);
    selectImageView.backgroundColor = [UIColor clearColor];
    selectImageView.image           = selectImage;
    [self.contentView addSubview:selectImageView];
    [selectImageView release];
    
    selectImageView.hidden = YES;
    
    //标题
    titleLbl                 = [[UILabel alloc] init];
    titleLbl.backgroundColor = [UIColor clearColor];
    
    UIColor * fontColor      = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroEditDropListViewCellTitleFontUnselectedColor];
    
    if (fontColor) {
        
        titleLbl.textColor       = fontColor;
    }
    titleLbl.frame           =  CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width, iconImageView.frame.origin.y, selectImageView.frame.origin.x - iconImageView.frame.origin.x - iconImageView.frame.size.width, iconImageView.frame.size.height);
    titleLbl.font            = [UIFont systemFontOfSize:kTitleWithFontSize];
    titleLbl.text            = titleName;
    [self.contentView addSubview:titleLbl];
    [titleLbl release];
    
    [titleName release];
    
    UIImageView *borderImageView    = [[UIImageView alloc] init];
    borderImageView.frame           = CGRectMake((self.contentView.frame.size.width - borderImage.size.width)/2.0, self.contentView.frame.size.height - borderImage.size.height, borderImage.size.width, borderImage.size.height);
    borderImageView.backgroundColor = [UIColor clearColor];
    borderImageView.image           = borderImage;
    
    [self.contentView addSubview:borderImageView];
    [borderImageView release];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

/**
 *  设置当前选中行
 *
 *  @param selected 是否选中
 */
-(void)setViewSelectedView:(BOOL)selected{
    
    NSString *iconName  = selected == YES ? @"edi_drop_icon_select.png" : @"edi_drop_icon_unselect.png";
    
    iconImageView.image = [UIImage imageNamed:iconName];
    
    UIColor *titleFontColor = [[JVCRGBHelper shareJVCRGBHelper ] rgbColorForKey: selected == YES ? kJVCRGBColorMacroNavBackgroundColor : kJVCRGBColorMacroEditDropListViewCellTitleFontUnselectedColor];
    
    titleLbl.textColor = titleFontColor;
    
    selectImageView.hidden = !selected;
    
}



@end
