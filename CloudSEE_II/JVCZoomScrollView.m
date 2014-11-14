//
//  JVCZoomScrollView.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCZoomScrollView.h"
#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define ScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@implementation JVCZoomScrollView
#define ZOOMSCALE 2.0
@synthesize _isInitState;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        self.showsHorizontalScrollIndicator =NO;
        self.showsVerticalScrollIndicator = NO;
        
    }
    return self;
}

- (void)initImageView:(UIImage *)tImg
{
    
    imageView = [[UIImageView alloc]init];
    
    //  imageView.frame = CGRectMake(0, 0, self.frame.size.width * 2, self.frame.size.height * 2);
    imageView.frame = CGRectMake((self.frame.size.width-tImg.size.width)/2.0, (self.frame.size.height-tImg.size.height)/2.0, tImg.size.width, tImg.size.height);
    imageView.userInteractionEnabled = YES;
    imageView.image =tImg;
    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    
    float minimumScale = self.frame.size.width / imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    self.maximumZoomScale =2;
    [self setZoomScale:minimumScale];
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
    //
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    // [scrollView setZoomScale:scale animated:NO];
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                   scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark - View cycle
- (void)dealloc
{
    [imageView release];
    
    [super dealloc];
}



@end
