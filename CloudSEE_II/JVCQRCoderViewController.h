//
//  JVCQRCoderViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/8/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "zxingLibrary.h"
@class JVCQRCoderViewController;

@protocol CustomViewControllerDelegate <NSObject>

@optional
- (void)customViewController:(JVCQRCoderViewController *)controller didScanResult:(NSString *)result;

- (void)customViewControllerDidCancel:(JVCQRCoderViewController *)controller;

@end

@interface JVCQRCoderViewController : UIViewController<UIAlertViewDelegate,DecoderResultDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) id<CustomViewControllerDelegate> delegate;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) BOOL isScanning;

/**
 *  开始二维码扫描
 */
- (void)startScan;

@end
