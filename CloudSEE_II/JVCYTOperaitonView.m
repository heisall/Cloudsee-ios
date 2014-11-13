//
//  JVCYTOperaitonView.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCYTOperaitonView.h"
#import "JVCCustomYTOView.h"


@implementation JVCYTOperaitonView

static const int kWithSeperate  = 10;//距离各个边界的距离
static const NSTimeInterval kTimerAfter  = 0.2;//距离各个边界的距离
/**
 *  初始化view
 *
 *  @param frame frame 大小
 *
 *  @return view对象
 */
- (id)initContentViewWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        NSArray *imageArray  = [NSArray arrayWithObjects:@"yt_top@2x.png",@"yt_bottom@2x.png",@"yt_left@2x.png",@"yt_right@2x.png",@"yt_auto@2x.png", nil];
        
        CGPoint centPont = self.center;
        
        for (int i=0; i<imageArray.count; i++) {
            
            NSString *stringImage = [UIImage imageBundlePath:[imageArray objectAtIndex:i]];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:stringImage];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(centPont.x- image.size.width/2.0, centPont.y- image.size.height/2.0, image.size.width,image.size.height)];
            imageView.image = image;
            
            CGRect framePoint = imageView.frame;
            
            switch (i+1) {
                case JVN_YTCTR_TYPE_U:
                    framePoint.origin.y = kWithSeperate;
                    break;
                case JVN_YTCTR_TYPE_L:
                    framePoint.origin.x = kWithSeperate;
                    break;
                case JVN_YTCTR_TYPE_D:
                    framePoint.origin.y = self.height - kWithSeperate- imageView.size.height;
                    break;
                case JVN_YTCTR_TYPE_R:
                    framePoint.origin.x = self.width - kWithSeperate- imageView.size.width;
                    break;
                case JVN_YTCTR_TYPE_A:
            
                    break;
                    
                default:
                    break;
            }
            imageView.tag = i+1;//+1与枚举相同
            imageView.frame = framePoint;
            [self addSubview:imageView];
            imageView.hidden = YES;
            [imageView release];
            [image release];
        }
        
    }
    return self;
}

/**
 *  根据选中的项目设置，云台帮助界面显示
 *
 *  @param operationType tag
 */
-(void)showOperationTypeImageVIew:(int)operationType
{
    switch (operationType) {
        case JVN_YTCTR_TYPE_U:
            [self setImageViewhoverimageTag:JVN_YTCTR_TYPE_U];
            break;
        case JVN_YTCTR_TYPE_D:
            [self setImageViewhoverimageTag:JVN_YTCTR_TYPE_D];
            break;

        case JVN_YTCTR_TYPE_L:
            [self setImageViewhoverimageTag:JVN_YTCTR_TYPE_L];
            break;

        case JVN_YTCTR_TYPE_R:
            [self setImageViewhoverimageTag:JVN_YTCTR_TYPE_R];
            break;
        case JVN_YTCTR_TYPE_A:
        case JVN_YTCTR_TYPE_AT:
        {
            [self setCenterImageViewhoverWithImageName:@"yt_auto@2x.png"];
            
            [self performSelector:@selector(setAutoImageViewHiden) withObject:nil afterDelay:kTimerAfter];
        }
            break;
        case JVN_YTCTR_TYPE_BBD:
            [self setCenterImageViewhoverWithImageName:@"yt_scaled@2x.png"];
            break;
        case JVN_YTCTR_TYPE_BBX:
            [self setCenterImageViewhoverWithImageName:@"yt_scalex@2x.png"];
            break;
        case JVN_YTCTR_TYPE_BJD:
            [self setCenterImageViewhoverWithImageName:@"yt_zoomd@2x.png"];
            break;
        case JVN_YTCTR_TYPE_BJX:
            [self setCenterImageViewhoverWithImageName:@"yt_zoomx@2x.png"];
            break;
            
        default:
            [self setImageViewhoverimageTag:-1];
            break;
           

    }
}

/**
 *  设置按钮的tag值
 *
 *  @param imageTag  图片tag
 */
- (void)setImageViewhoverimageTag:(int )imageTag
{
    for ( id contentView in self.subviews) {
        
        if ([contentView isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imageViewNor = (UIImageView *)contentView;
            
            if (imageViewNor.tag == imageTag) {
                
                imageViewNor.hidden = NO;
                
            }else{
                imageViewNor.hidden = YES;

            
            }
        }
    }
}

- (void)setAutoImageViewHiden
{
    [self setImageViewhoverimageTag:-1];
}

/**
 *  设置按钮的tag值
 *
 *  @param imageTag  图片tag
 */
- (void)setCenterImageViewhoverWithImageName:(NSString *)imageString
{
    for ( id contentView in self.subviews) {
        
        if ([contentView isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imageViewNor = (UIImageView *)contentView;
            
            imageViewNor.hidden = YES;
        }
    }
    
    UIImageView *imageview = (UIImageView *)[self viewWithTag:JVN_YTCTR_TYPE_A];
    imageview.hidden = NO;
    NSString *stringImage = [UIImage imageBundlePath:imageString];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:stringImage];
    imageview.image =image;
    [image release];
}


@end
