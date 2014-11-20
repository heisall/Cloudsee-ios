//
//  JVCShowLargeImageViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCShowLargeImageViewController.h"
#import "JVCZoomScrollView.h"
#import "JVCPhotoModelObj.h"

@interface JVCShowLargeImageViewController ()
{
    UIScrollView *_scrView;
    
    NSMutableArray *_mArrayZoonViews;
    
    UIPageControl *pageControl;
    
    NSMutableArray *controllers;
    BOOL pageControlUsed;
    
    int _iViewHeight;
}

@end

@implementation JVCShowLargeImageViewController

@synthesize _mArrayPictures;
@synthesize _index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _mArrayZoonViews = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)dealloc
{
    
    [controllers release];
    controllers = nil;
    [_mArrayZoonViews release];
    
    if (_scrView) {
        [_scrView release];
        _scrView = nil;
    }
    [super dealloc];
}

- (void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.title = LOCALANGER(@"home_photos");
    _iViewHeight = self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height;
    
    //    UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithTitle:LOCALANGER(@"home_share") style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressSharkNoView:)];
    //    self.navigationItem.rightBarButtonItem= itemBar;
    //    [itemBar release];
    
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initScrollview:nil];
    
    controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < self._mArrayPictures.count; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    
    [self changePage:[NSNumber numberWithInt:_index]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化view
 */
- (void)initScrollview:(NSInteger)indexInt
{
    _scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrView.pagingEnabled =YES;
    _scrView.delegate = self;
    _scrView.contentSize = CGSizeMake(self.view.frame.size.width*self._mArrayPictures.count, self.view.frame.size.height);
    [self.view addSubview:_scrView];
    [self initShareBtn];
    
}
- (void)changePage:(NSNumber *)indexSelect
{
    int page = indexSelect.intValue;
    
    _index = indexSelect.intValue;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
    CGRect frame = _scrView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

/**
 *  初始化分享按钮
 */
- (void)initShareBtn
{
    //    UIButton *_btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _btnShare.frame = CGRectMake(20, self.view.frame.size.height-100, 100, 30);
    //    [_btnShare setTitle:@"分享" forState:UIControlStateNormal];
    //    [_btnShare addTarget:self action:@selector(buttonPressSharkNoView:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_btnShare];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) /  scrollView.frame.size.width) + 1;
    
    _index = currentPage;
    
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= self._mArrayPictures.count)
        return;
    
    // replace the placeholder if necessary
    if (!controllers) {
        return;
    }
    JVCZoomScrollView *controller = [controllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        CGRect frame = self.view.frame;
        frame.origin.x = frame.size.width * page+3;
        frame.origin.y = 0;
        frame.size.width = frame.size.width-6;
        frame.size.height = _iViewHeight;
        
        JVCZoomScrollView *_tVC = [[JVCZoomScrollView alloc] initWithFrame:frame];
        
        _tVC._isInitState = YES;
        
        JVCPhotoModelObj *objBig =[self._mArrayPictures objectAtIndex:page];
        [_tVC initImageView:objBig.ImgBig];
        
        [controllers replaceObjectAtIndex:page withObject:_tVC];
        controller = _tVC;
        
        [_tVC release];
        
    }
    
    // add the controller's view to the scroll view
    if (controller.superview == NULL)
    {
        [_scrView addSubview:controller];
    }
    
    
}

@end
