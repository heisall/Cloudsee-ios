//
//  JVCDeviceListAdvertCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceListAdvertCell.h"
#import "StyledPageControl.h"

@interface JVCDeviceListAdvertCell ()
{
    /**
     *  滚动的广告条
     */
    UIScrollView        *_scrollView;
    
    /**
     *  pageControl
     */
    StyledPageControl   *_pageController;
    
    NSMutableArray      *_arrayDefaultImage;
}

@end

@implementation JVCDeviceListAdvertCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _arrayDefaultImage = [[NSMutableArray alloc] init];
        
        for (int i=0; i<2; i++) {
            
            [_arrayDefaultImage addObject:[NSString stringWithFormat:@"devAdv_default_%d.jpg",i]];
        }
    }
    return self;
}

/**
 *  初始化cell
 */
- (void)initCellContent
{
    for (UIView *contentViewInCell in self.contentView.subviews) {
        
        [contentViewInCell removeFromSuperview];
        contentViewInCell = nil;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, kTableViewCellAdeviceHeigit)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.width*_arrayDefaultImage.count, self.height);
    [self.contentView addSubview:_scrollView];
    
    for (int i=0; i<_arrayDefaultImage.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.width, 0, _scrollView.width, _scrollView.height)];
        
        NSString *imageBundlePath = [UIImage imageBundlePath:[_arrayDefaultImage objectAtIndex:i]];
        
        UIImage *imageName = [[UIImage alloc]initWithContentsOfFile:imageBundlePath];
        imgView.image = imageName;
        [imageName release];
        
        [_scrollView addSubview:imgView];
        [imgView release];
    }
    
    
    
    [_scrollView release];
    
    _pageController = [[StyledPageControl alloc] initWithFrame:CGRectMake(self.width - 100, _scrollView.height - 30,80 , 30)];
    [_pageController setPageControlStyle:PageControlStyleThumb];
    _pageController.currentPage = 0;
    _pageController.numberOfPages = _arrayDefaultImage.count;
    [_pageController setThumbImage:[UIImage imageNamed:@"devAdv_white.png"]];
    [_pageController setSelectedThumbImage:[UIImage imageNamed:@"devAdv_red.png"]];
    [self.contentView addSubview:_pageController];
    [_pageController release];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffX = floor(scrollView.contentOffset.x/self.width) ;
    [_pageController setCurrentPage:contentOffX];
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

- (void)dealloc
{
    [super dealloc];
}

@end
