//
//  JVCMoreUserCell.m
//  CloudSEE_II
//  更多界面，用户的cell
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreUserCell.h"
#import "JVCRGBHelper.h"
#import "JVCConfigModel.h"

static const int moreOrigin_x  = 20;  //距离最左边的位置

static const int moreSeperate  = 20;  //与头像的距离

static const int moreLabWith  = 200;  //lab的宽度

static const int moreLabHeigh  = 40;  //lab的高度


static const int moreLabUSernameFont  = 25;  //账号的font

static const int moreLabSeperate  = 5;  //lab之间的距离

static const int MORETEXTFONT  = 14;  //字体大小

static const int MORETEXTFONT_User  = 16;  //用户名的字体大小

@implementation JVCMoreUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  初始化用户的cell
 */
- (void)initMoreCellContentView
{
    
    for (UIView *cotentView  in self.contentView.subviews) {
        
        [cotentView removeFromSuperview];
    }
    
    UIImageView *imageViewbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, CELLHEIGHT_USERHEADER)];//mor_usr_bg@2x.png
    NSString *path = [UIImage imageBundlePath:@"mor_usr_bg.png"];
    UIImage *imagebg = [[UIImage alloc] initWithContentsOfFile:path];
    imageViewbg.image = imagebg;
    [self.contentView addSubview:imageViewbg];
    [imageViewbg release];
    [imagebg release];
    
    //头像
    UIImage *imgMoreUser= [UIImage imageNamed:@"mor_user.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(moreOrigin_x, (120 - imgMoreUser.size.height)/2.0, imgMoreUser.size.width, imgMoreUser.size.height)];
    imageView.image =imgMoreUser;
    [self.contentView addSubview:imageView];
    [imageView release];
    
    //账号名称
    UILabel *labUser = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+moreSeperate, 0, moreLabWith, moreLabHeigh)];
    labUser.center = CGPointMake(labUser.center.x, imageView.center.y);
    labUser.backgroundColor = [UIColor clearColor];
    labUser.font = [UIFont systemFontOfSize:moreLabUSernameFont];
    UIColor *color = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroNavBackgroundColor];
    if (color) {
        labUser.textColor = color;
    }
    labUser.font = [UIFont systemFontOfSize:MORETEXTFONT_User];
    if ( [JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {
        labUser.text = LOCALANGER(@"jvc_log_local");
    }else{
        labUser.text = kkUserName;

    }
    [self.contentView addSubview:labUser];
    [labUser release];
    
//    //最后一次登录时间
//    UILabel *labLastLogin = [[UILabel alloc] initWithFrame:CGRectMake(labUser.left, labUser.bottom+moreLabSeperate, moreLabWith, moreLabHeigh)];
//    labLastLogin.text = @"最后一次登录时间:2014-09-19";
//    labLastLogin.font = [UIFont systemFontOfSize:MORETEXTFONT];
//    labLastLogin.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:labLastLogin];
//    [labLastLogin release];
//    
//    //修改资料
//    UIButton *btnMofify = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnMofify.frame = CGRectMake(labLastLogin.left, labLastLogin.bottom+moreLabSeperate, moreLabShortWith, moreLabHeigh);
//    [btnMofify setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnMofify setTitle:@"修改资料" forState:UIControlStateNormal];
//    [btnMofify.titleLabel setFont:[UIFont systemFontOfSize:MORETEXTFONT]];
//    [btnMofify.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.contentView addSubview:btnMofify];
//    
//    //修改资料
//    UIButton *btnGetPw = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnGetPw.frame = CGRectMake(btnMofify.right+moreSeperate, labLastLogin.bottom+moreLabSeperate, moreLabShortWith, moreLabHeigh);
//    [btnGetPw setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnGetPw setTitle:@"找回密码" forState:UIControlStateNormal];
//    [btnGetPw.titleLabel setFont:[UIFont systemFontOfSize:MORETEXTFONT]];
//    [btnGetPw.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.contentView addSubview:btnGetPw];
    
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
