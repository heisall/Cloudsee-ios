//
//  JVCZoomScrollView.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCZoomScrollView : UIScrollView
{
    UIImageView *imageView;
    BOOL _zoom;
    BOOL _isInitState;
    
}
@property(nonatomic,assign)    BOOL _isInitState;

- (void)initImageView:(UIImage *)tImg;

@end
