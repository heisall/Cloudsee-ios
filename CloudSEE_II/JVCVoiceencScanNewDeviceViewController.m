//
//  JVCVoiceencScanNewDeviceViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCVoiceencScanNewDeviceViewController.h"
#import "JVCDeviceSourceHelper.h"
static const kScanDeviceWithDefaultCount = 1;//一个设备的时候，默认的用户名密码为admin “”
@interface JVCVoiceencScanNewDeviceViewController ()

@end

@implementation JVCVoiceencScanNewDeviceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)initLayoutWithViewWillAppear {
    
    [super initLayoutWithViewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

/**
 *  返回的所有广播搜到的设备
 *
 *  @param SerachLANAllDeviceList 返回的设备数组
 */
-(void)SerachLANAllDevicesAsynchronousRequestWithDeviceListDataCallBack:(NSMutableArray *)SerachLANAllDeviceList{
    
    [SerachLANAllDeviceList retain];
    
    JVCDeviceSourceHelper *deviceSourceObj = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    
    NSArray *lanModelDeviceList=[deviceSourceObj LANModelListConvertToSourceModel:SerachLANAllDeviceList];
    
    [lanModelDeviceList retain];
    
    [deviceSourceObj updateLanModelToChannelListData:lanModelDeviceList];
    
    [lanModelDeviceList release];
    
    
    for (int i = 0; i < SerachLANAllDeviceList.count; i++) {
        
        JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[SerachLANAllDeviceList objectAtIndex:i];
        
        
        if (amLanSearchModelList.count >= kNewDeviceWithMaxCount) {
            
            [self stopScanfDeviceTimer];
            break;
        }
        
        if ([self checkLanSearchModelIsExist:model.strYstNumber] ) {
            
            continue;
        }
        
        if (!model.iNetMod) {
            
            continue;
        }
        
        [amLanSearchModelList addObject:model];
        
        [self playNewSound];
        
        UIButton *newButton = [self newDeviceuttonWithTag:amLanSearchModelList.count - 1];
        
        [newButton retain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGFloat x  ;
            CGFloat y  ;
            
            do {
                
                x  = [self getRandomNumber:0 to:kNewDeviceImageViewWithRadius*2];
                y  = [self getRandomNumber:0 to:kNewDeviceImageViewWithRadius*2];
                
            }while (![self checkNewDevicePoint:scanfNewDevice_x+x withY:scanfNewDevice_y+y]);
            
            CGRect rectDevice    = newButton.frame;
            rectDevice.origin.x  = scanfNewDevice_x + x;
            rectDevice.origin.y  = scanfNewDevice_y + y;
            newButton.frame      = rectDevice;
            newButton.alpha = kNewDeviceImageViewWithMinAlpha;
            newButton.transform = CGAffineTransformMakeScale(kNewDeviceImageViewWithMinScale, kNewDeviceImageViewWithMinScale);
            [self.view addSubview:newButton];
            
            [UIView animateWithDuration:kNewDeviceWithanimateWithDuration animations:^{
                
                newButton.alpha     = 1.0f;
                newButton.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL isFinshed){
                
//                if (self.nScanfDeviceMaxCont == kScanDeviceWithDefaultCount) {
//                    
//                    [self playConfigSound];
//                }
                
            }];
        });
        
        [newButton release];
    }
    
    [SerachLANAllDeviceList release];
    
}

-(UIButton *)newDeviceuttonWithTag:(int)tag{

    UIButton *button = [super newDeviceuttonWithTag:tag];
    
    JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:tag];
    
    if ( ADDDEVICE_HAS_EXIST == [[JVCDeviceSourceHelper shareDeviceSourceHelper] addDevicePredicateHaveYSTNUM:model.strYstNumber]){
       
        [button setBackgroundImage:[UIImage imageNamed:@"sca_device.png"] forState:UIControlStateNormal];
        button.alpha = kDeviceImageViewWithMinAlpha;
    }
    
    return button;
}

/**
 *  添加新设备
 */
-(void)addNewScanDevice:(UIButton *)button
{
    nSelectedIndex               = button.tag - kNewDeviceButtonWithTag;
    JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:nSelectedIndex];
    BOOL        isNewDevice      = ADDDEVICE_HAS_EXIST != [[JVCDeviceSourceHelper shareDeviceSourceHelper] addDevicePredicateHaveYSTNUM:model.strYstNumber];
    
    if (isNewDevice) {
        
        JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:nSelectedIndex];
        
        [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:[NSString stringWithFormat:@"%@：%@",LOCALANGER(@"qrDevice"),model.strYstNumber] delegate:self selectAction:@selector(addQRdevice) cancelAction:nil selectTitle:LOCALANGER(@"jvc_DeviceList_APadd") cancelTitle:LOCALANGER(@"jvc_DeviceList_APquit") alertTage:JVCSCanType_addDevice];
    }else{
        
        
        JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:nSelectedIndex];

        [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:[NSString stringWithFormat:@"%@：%@\n(%@)",LOCALANGER(@"qrDevice"),model.strYstNumber,LOCALANGER(@"jvc_scanf_reSacn_HasExit")] delegate:self selectAction:@selector(addQRdevice) cancelAction:nil selectTitle:nil cancelTitle:LOCALANGER(@"jvc_scanf_reSacn_Close") alertTage:JVCSCanType_NOmal];
        
    }
}


/**
 *  播放发现设备
 */
-(void)playNewSound{
    
    NSString *soundPath = [[NSBundle mainBundle ] pathForResource:@"sca_new" ofType:@"mp3"];
    
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] playSound:soundPath withIsRunloop:NO];
}

/**
 *  播放配置完成
 */
-(void)playConfigSound{
    
    NSString *soundPath = [[NSBundle mainBundle ] pathForResource:NSLocalizedString(@"jvc_scanf_finshed", nil) ofType:@"mp3"];
    
    JVCSystemSoundHelper *soundHelperObj = [JVCSystemSoundHelper shareJVCSystemSoundHelper];
    
    [soundHelperObj playSound:soundPath withIsRunloop:NO];
}

- (void)addQRdevice
{
    JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:nSelectedIndex];
    
    [JVCDeviceMathsHelper shareJVCUrlRequestHelper].deviceDelegate = self;
    
    
    if (model.iDeviceChannelCount == kScanDeviceWithDefaultCount) {
        
        [[JVCDeviceMathsHelper shareJVCUrlRequestHelper] addDeviceWithYstNum:model.strYstNumber
                                                                    userName:(NSString *)DefaultHomeUserName
                                                                    passWord:(NSString *)DefaultHomePassWord
                                                                    ChannelCount:model.iDeviceChannelCount];
    }else {
        
        [[JVCDeviceMathsHelper shareJVCUrlRequestHelper] addDeviceWithYstNum:model.strYstNumber
                                                                    userName:(NSString *)DefaultUserName
                                                                    passWord:(NSString *)DefaultPassWord ChannelCount:model.iDeviceChannelCount];
    }

}

@end
