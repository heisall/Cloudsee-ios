//
//  JVCAlarmVideoPlayViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/16/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmVideoPlayViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

@interface JVCAlarmVideoPlayViewController ()
{
    MPMoviePlayerController *movie;
}

@end

@implementation JVCAlarmVideoPlayViewController
@synthesize _StrViedoPlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidDisappear:animated];
}


- (void)BackClick
{
    [movie stop];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LOCALANGER(@"jvc_alarmVideo_title");
    

    NSURL *url = [NSURL fileURLWithPath:self._StrViedoPlay];
    //视频播放对象
    movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    movie.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    movie.controlStyle = MPMovieControlStyleNone;
    movie.scalingMode = MPMovieScalingModeAspectFit;
    movie.initialPlaybackTime = -1;
    [self.view addSubview:movie.view];
    [movie play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(movieFinishedCallback:)
     
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
     
                                               object:movie]; //播放完后的通知
    
}

-(void)movieFinishedCallback:(NSNotification*)notify {
    
    [self BackClick];
    
}



- (void)movieEventFullscreenHandler:(NSNotification*)notification {
    return;
    [movie setFullscreen:NO animated:NO];
    //  movie.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    
    [movie setControlStyle:MPMovieControlStyleEmbedded];
}

- (void)showControls
{
    for(id views in [[movie view] subviews]){
        for(id subViews in [views subviews]){
            for (id controlView in [subViews subviews]){
                if ( [controlView isKindOfClass:NSClassFromString(@"MPInlineVideoOverlay")] ) {
                    [controlView setAlpha:1.0];
                    [controlView setHidden:NO];
                }
            }
        }
    }
}
- (void)hideControls
{
    for(id views in [[movie view] subviews]){
        for(id subViews in [views subviews]){
            for (id controlView in [subViews subviews]){
                if ( [controlView isKindOfClass:NSClassFromString(@"MPInlineVideoOverlay")] ) {
                    [controlView setAlpha:0.0];
                    [controlView setHidden:YES];
                }
            }
        }
    }
}

#pragma mark -------------------视频播放结束委托--------------------

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:movie];
    
    [_StrViedoPlay release];
    [movie release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
