//
//  JVCQRCoderViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/8/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCQRCoderViewController.h"
#import "JVCPredicateHelper.h"

@interface JVCQRCoderViewController ()
{
    int _totalCount;
    float _blockSize;
    int _iCurrentIndex;
    NSTimer *_qrLineTimer;
    UIImageView *_qrLineImageView;
    UILabel *_resultText;
    BOOL _isType;  //FALSE:向下 反之向上
    float _ysize;
}


@end

@implementation JVCQRCoderViewController

//@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void)dealloc{
    
    [self.captureSession release];
    self.captureSession=nil;
    NSLog(@"run hahha delloc Cnnnn");
    [super dealloc];
    
}


- (void)viewDidLoad
{
    [self initCapture];
    
    [zxingLibrary sharedZlObj].DRGelegate = self;
    
    _blockSize=0.5;
    _isType=FALSE;
    _iCurrentIndex=0;
    UIImage *imagaQr=[UIImage imageNamed:@"QdContentbg.png"];
    UIImage *ImageLine=[UIImage imageNamed:@"qdLine.png"];
    
    UIImageView *_ImageQrView=[[UIImageView alloc] initWithImage:imagaQr];
    _ImageQrView.frame=CGRectMake((self.view.frame.size.width-imagaQr.size.width)/2.0, (self.view.frame.size.height-imagaQr.size.height)/2.0, imagaQr.size.width, imagaQr.size.height);
    _totalCount=imagaQr.size.height/_blockSize;
    _ysize=(_ImageQrView.frame.size.height-_blockSize*_totalCount)/2.0;
    _qrLineImageView=[[UIImageView alloc] initWithImage:ImageLine];
    _qrLineImageView.frame=CGRectMake((_ImageQrView.frame.size.width-ImageLine.size.width)/2.0,_ysize, ImageLine.size.width, ImageLine.size.height);
    _qrLineImageView.tag=109;
    //NSLog(@"view=%@",_qrLineImageView);
    _qrLineImageView.backgroundColor=[UIColor clearColor];
    [_ImageQrView addSubview:_qrLineImageView];
    [_qrLineImageView release];
    [_ImageQrView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_ImageQrView];
    [_ImageQrView release];
    
    _totalCount=imagaQr.size.height/_blockSize;
    _iCurrentIndex=0;
    
    _resultText=[[UILabel alloc] init];
    _resultText.frame=CGRectMake(0.0, 0.0, 100.0, 20.0);
    _resultText.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_resultText];
    [_resultText release];
    [_resultText setHidden:YES];
    
    UIImage *imageTextBg=[UIImage imageNamed:@"QrInfoText.png"];
    
    UILabel *_qrInfoTV=[[UILabel alloc] init];
    _qrInfoTV.frame=CGRectMake((self.view.frame.size.width-imageTextBg.size.width)/2.0, _ImageQrView.frame.origin.y+_ImageQrView.frame.size.height+20.0,imageTextBg.size.width, imageTextBg.size.height);
    _qrInfoTV.backgroundColor=[UIColor colorWithPatternImage:imageTextBg];
    _qrInfoTV.textColor=SETLABLERGBCOLOUR(118.0,118.0,118.0);
    if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
        _qrInfoTV.font=[UIFont systemFontOfSize:16];
    }else{
        _qrInfoTV.font=[UIFont systemFontOfSize:14];
    }
    _qrInfoTV.textAlignment=NSTextAlignmentCenter;
    _qrInfoTV.text=NSLocalizedString(@"qrScan", nil);
    [self.view addSubview:_qrInfoTV];
    [_qrInfoTV release];
    
    
    UIImage *_returnImage=[UIImage imageNamed:@"qrReturnBg.png"];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setImage:[UIImage imageNamed:@"qrReturnImageBg.png"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:_returnImage forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"qrReturn", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:SETLABLERGBCOLOUR(18.0, 18.0, 18.0) forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake(30.f, 30.f, _returnImage.size.width, _returnImage.size.height)];
    [self.cancelButton addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    [super viewDidLoad];
    
}

/**
 *  开始二维码扫描
 */
- (void)startScan
{
    UIImage *imagaQr=[UIImage imageNamed:@"QdContentbg.png"];
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationDuration:1.5];
    _qrLineImageView.frame=CGRectMake(_qrLineImageView.frame.origin.x,imagaQr.size.height -7.0, _qrLineImageView.frame.size.width, _qrLineImageView.frame.size.height);
    [UIView commitAnimations];
    
    _qrLineTimer=[NSTimer scheduledTimerWithTimeInterval:1.5
                                                  target:self
                                                selector:@selector(changeQrLineFrame)
                                                userInfo:nil repeats:YES];
    
    self.isScanning=YES;
    [self.captureSession startRunning];
    
}

- (void)stopSCan
{
    
}

-(void)changeQrLineFrame{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    UIImage *imagaQr=[UIImage imageNamed:@"QdContentbg.png"];
    _isType=!_isType;
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationDuration:1.5];
    if (!_isType) {
        
        _qrLineImageView.frame=CGRectMake(_qrLineImageView.frame.origin.x,imagaQr.size.height -7.0, _qrLineImageView.frame.size.width, _qrLineImageView.frame.size.height);
        
    }else{
        
        _qrLineImageView.frame=CGRectMake(_qrLineImageView.frame.origin.x, _ysize, _qrLineImageView.frame.size.width, _qrLineImageView.frame.size.height);
    }
    [UIView commitAnimations];
    [pool  release];
    
    
    
}


- (void)pressPhotoLibraryButton:(UIButton *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        self.isScanning = NO;
        [self.captureSession stopRunning];
    }];
}

- (void)pressCancelButton:(UIButton *)button
{
    self.isScanning = NO;
    
    [self.captureSession stopRunning];
    
    
    if ([_qrLineTimer isValid]) {
        [_qrLineTimer invalidate];
        _qrLineTimer=nil;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    //    self.captureSession = tempCapture;
    //    [tempCapture release];
    
    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    NSLog(@"error =%@",[error description]);
    if (!error) {
        
        [self.captureSession removeInput:captureInput];
        
        [self.captureSession addInput:captureInput];
    }else{
        return;
    }
    
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [self.captureSession addOutput:captureOutput];
    
    NSString* preset = 0;
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        [inputDevice
         supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            // NSLog(@"960");
            preset = AVCaptureSessionPresetiFrame960x540;
        }
    if (!preset) {
        // NSLog(@"MED");
        preset = AVCaptureSessionPresetMedium;
    }
    self.captureSession.sessionPreset = preset;
    
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.captureVideoPreviewLayer];
    
    self.isScanning = YES;
    [self.captureSession startRunning];
    NSLog(@"run delloc 009");
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        // NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    [[zxingLibrary sharedZlObj] decodeImage:image];
    
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{[[zxingLibrary sharedZlObj] decodeImage:image];}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.isScanning = YES;
        [self.captureSession startRunning];
    }];
}


-(void)decoderFailedCallBack
{
    DDLogInfo(@"fail==decoderFailedCallBack");
}

- (void)decoderSucceedCallBack:(NSString *)decoderResultText
{
    [decoderResultText retain];
    
    self.isScanning = NO;
    [self.captureSession stopRunning];
    
    if ([[JVCPredicateHelper shareInstance] predicateYSTIsLegal:decoderResultText]) {
        _resultText.text=[NSString stringWithFormat:@"%@",decoderResultText];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@［ %@ ］",NSLocalizedString(@"qrDevice", nil),decoderResultText] message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"qrAdd", nil) otherButtonTitles:NSLocalizedString(@"qrContinue", nil),nil];
        [alertView show];
        [alertView release];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"qrNoDevice", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"qrContinue", nil) otherButtonTitles:nil];
        alertView.tag=100;
        [alertView show];
        [alertView release];
    }
    
    [decoderResultText release];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        self.isScanning = YES;
        [self.captureSession startRunning];
        _resultText.text=@"";
    }else{
        if (buttonIndex==0) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(customViewController:didScanResult:)]) {
                
                if ([_qrLineTimer isValid]) {
                    [_qrLineTimer invalidate];
                    _qrLineTimer=nil;
                }
                [self.delegate customViewController:self didScanResult:_resultText.text];
            }
        }else{
            self.isScanning = YES;
            [self.captureSession startRunning];
            _resultText.text=@"";
            
        }
    }
    
}


#pragma mark  方向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(interfaceOrientation== UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    return NO;
    
}

#if 0
- (BOOL)shouldAutorotate
{
    return YES;
}
#endif
#if 1
-(NSUInteger)supportedInterfaceOrientations{
    //    if([[self.navigationController topViewController] isKindOfClass:[operationController class]])
    //        return UIInterfaceOrientationMaskAll;
    //    else
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown;
}
#endif

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
